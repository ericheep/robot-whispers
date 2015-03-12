// RobotSend.ck
// Eric Heep

public class RobotSend {

    OscOut out;
    ("chuckServer.local", 50000) => out.dest;

    ["/clappers", "/marimba", "/trimpbeat", "/trimpspin"] @=> string address[];
    
    // clapper list
    // 0,  1,  2,  3,  4,  7, 17

    // marimba list
    // 45, 47, 48, 50, 52, 53, 54,
    // 55, 57, 59, 60, 62, 64, 65,
    // 66, 67, 69, 71, 72, 74, 76,
    // 77, 78, 79, 81, 83, 84, 86,
    // 66, 90, 91, 93, 95, 96],

    // trimpbeat
    // 59, 60, 61, 62, 63, 64, 65,
    // 66, 67, 68, 69, 70, 71, 72,
    // 73, 74, 75, 76, 77, 78 

    // ~~~~~~~~~~~~~~~~~~~~~~
    60 => float low_threshold;
    75 => float mid_threshold;
    80 => float high_threshold;
    50::ms => dur wait_time;

    // first row is the actuator, second row is the mel band associated with it
    // clappers, 
    [[ 0,  1], 
     [ 0,  1],
    // marimba, 
     [45, 50, 54, 59, 62, 65, 69, 71, 77, 81, 83, 84, 90, 93, 96], 
     [ 1,  2,  3,  4,  5,  6, 16, 17, 18, 19, 20, 21, 22, 23, 23], 
    // trimpbeat, 
     [59, 60], 
     [ 0,  2], 
    // trimpspin
     [ 0,  1], 
     [ 0,  2]] 
     @=> int low_actuator_a[][];

    // 1st element, clappers; 2nd element, marimba; 
    // 3rd element, trimpbeat; 4th element, trimpspin
    [4, 38, 12,  1] @=> int low_velocity_a[];

    // ~~~~~~~~~~~~~~~~~~~~~~

    // clappers
    [[ 0,  0,  0], 
     [ 0,  0,  0], 
    // marimba
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // trimpbeat
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // trimpspin
     [ 0,  0,  0], 
     [ 0,  0,  0]] 
     @=> int mid_actuator_a[][];

    [0,  0,  0,  0] @=> int mid_velocity_a[];

    // ~~~~~~~~~~~~~~~~~~~~~~~

    // clappers
    [[ 0,  0,  0], 
     [ 0,  0,  0], 
    // marimba
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // trimpbeat
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // trimpbeat
     [ 0,  0,  0], 
     [ 0,  0,  0]] 
     @=> int high_actuator_a[][];

     [ 0,  0,  0,  0] @=> int high_velocity_a[];

    // clappers, 
    [[ 0,  1,  2,  3,  4,  7, 17], 
     [ 0,  1,  4,  7, 10, 22, 23],
    // marimba, 
     [ 0], 
     [ 0], 
    // trimpbeat, 
     [59, 60], 
     [ 0,  2], 
    // trimpspin
     [ 0,  1], 
     [ 0,  2]] 
     @=> int low_actuator_b[][];

    // 1st element, clappers; 2nd element, marimba; 
    // 3rd element, trimpbeat; 4th element, trimpspin
    [14, 38, 12, 1] @=> int low_velocity_b[];

    // ~~~~~~~~~~~~~~~~~~~~~~

    // clappers
    [[ 0,  0,  0], 
     [ 0,  0,  0], 
    // marimba
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // trimpbeat
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // trimpspin
     [ 0,  0,  0], 
     [ 0,  0,  0]] 
     @=> int mid_actuator_b[][];

    [0,  0,  0,  0] @=> int mid_velocity_b[];

    // ~~~~~~~~~~~~~~~~~~~~~~~

    // clappers
    [[ 0,  0,  0], 
     [ 0,  0,  0], 
    // marimba
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // trimpbeat
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // trimpbeat
     [ 0,  0,  0], 
     [ 0,  0,  0]] 
     @=> int high_actuator_b[][];

     [0,  0,  0,  0] @=> int high_velocity_b[];

    // vars to hold total number of actuators per threshold setting
    int num_low_a;
    int num_mid_a;
    int num_high_a;

    int num_low_b;
    int num_mid_b;
    int num_high_b;

    // finds the number of assigned actuators
    for (int i; i < address.size(); i++) {
        low_actuator_a[i * 2].size() +=> num_low_a; 
        mid_actuator_a[i * 2].size() +=> num_mid_a; 
        high_actuator_a[i * 2].size() +=> num_high_a; 
        low_actuator_b[i * 2].size() +=> num_low_b; 
        mid_actuator_b[i * 2].size() +=> num_mid_b; 
        high_actuator_b[i * 2].size() +=> num_high_b; 
    }

    int switch[24];
    10 => int switch_threshold;
    int waiting[6][0];

    // our variables so the actuators don't trigger too quickly
    num_low_a => waiting[0].size;
    num_mid_a => waiting[1].size;
    num_high_a => waiting[2].size;
    num_low_b => waiting[3].size;
    num_mid_b => waiting[4].size;
    num_high_b => waiting[5].size;

    // functions to ensure we don't constantly send messages 
    fun void wait(int type, int idx) {
        1 => waiting[type][idx];
        wait_time => now;
        0 => waiting[type][idx];
    }

    // our sender
    fun void send(string addr, int idx, int vel) {
        out.start(addr);
        out.add(idx);
        out.add(vel);
        out.send();
    }

    // stuff
    fun void send(int idx, int type, int arr[][], int vel[]) {
        int ctr;
        for (int i; i < arr.size()/2; i++) {
            for (int j; j < arr[i * 2].size(); j++) {
                if (idx == arr[i * 2 + 1][j]) {
                    if (waiting[type][ctr] == 0) {
                        switch[idx]++;
                        send(address[i], arr[i * 2][j], vel[i]);
                        spork ~ wait(type, ctr); 
                    }
                }
                ctr++;
            }
        }
    }

    fun void check(float X[], int cap) {
        for (int i; i < cap; i++) {
            if (X[i] > low_threshold) {
                if (switch[i] < switch_threshold) {
                    send(i, 0, low_actuator_a, low_velocity_a); 
                }
                else {
                    send(i, 3, low_actuator_b, low_velocity_b); 
                }
            }
        }
    }
} 

/*
RobotSend rob;
for (int i; i < rob.low_actuator.size(); i++) {
    for (int j; j < rob.low_actuator[i].size(); j++) {
        <<< rob.address[i], rob.low_actuator[i][j], rob.low_velocity[i] >>>;
    }
}
*/
