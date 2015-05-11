// RobotSend.ck
// Eric Heep

public class RobotSend {

    NanoKontrol n;
   
    spork ~ controls();

    80 => float low_threshold;
    80 => float mid_threshold;
    80 => float high_threshold;
    80 => float other_threshold;

    fun void print() {
        <<< "low:", low_threshold, "mid:", mid_threshold, "high:", high_threshold, "other:", other_threshold >>>; 
    }

    fun void controls() {
        int prev_slider[4];

        while (true) {
            if (n.slider[0] != prev_slider[0]) {
                n.slider[0] => prev_slider[0];
                n.slider[0]/127.0 * 40 + 40 => low_threshold; 
                print();
            }
            if (n.slider[1] != prev_slider[1]) {
                n.slider[1] => prev_slider[1];
                n.slider[1]/127.0 * 40 + 40 => mid_threshold; 
                print();
            }
            if (n.slider[2] != prev_slider[2]) {
                n.slider[2] => prev_slider[2];
                n.slider[2]/127.0 * 40 + 40 => high_threshold;
                print();
            }
            if (n.slider[3] != prev_slider[3]) {
                n.slider[3] => prev_slider[3];
                n.slider[3]/127.0 * 40 + 40 => other_threshold;
                print();
            }
            10::ms => now;
        }
    }

    // robots
    OscOut out;
    ("chuckServer.local", 50000) => out.dest;

    // switches
    OscOut switch_out;
    ("10.2.34.255", 40000) => switch_out.dest; 

    ["/clappers", "/marimba", "/trimpbeat", "/trimpspin", "/switch", "/drumBot", "/devibot", "/ganapati"] @=> string address[];
    
    // clapper list
    // 0,  1,  2,  3,  4,  7, 17

    // marimba list
    // 45, 47, 48, 50, 52, 
    // 53, 54, 55, 57, 59, 
    // 60, 62, 64, 65, 66, 
    // 67, 69, 71, 72, 74, 
    // 76, 77, 78, 79, 81, 
    // 83, 84, 86, 66, 90, 
    // 91, 93, 95, 96],

    // trimpbeat
    // 59, 60, 61, 62, 
    // 63, 64, 65, 66
    // 67, 68, 69, 70, 
    // 71, 72, 73, 74, 
    // 75, 76, 77, 78 

    // ~~~~~~~~~~~~~~~~~~~~~~
    50::ms => dur wait_time;

    // first row is the actuator, second row is the mel band associated with it
    // clappers, 
    [[  0,  1,   2,  3,  4,  7, 17], 
     [ 12,  13, 14, 15, 16, 17, 18],
    // marimba, 
     [45, 47, 53, 54, 60, 62, 67, 69, 76, 77, 83, 84, 91, 93], 
     [ 5,  5,  6,  6,  7,  7,  8,  8,  9,  9, 10, 10, 11, 11], 
    // trimpbeat, 
     [59, 60, 63, 64, 67, 68, 71, 72, 75, 76], 
     [ 0,  0,  1,  1,  2,  2,  3,  3,  4,  4], 
    // trimpspin
     [ 0,  1], 
     [ 0,  2], 
    // switch 
     [  0,  1,  2,  3,  4], 
     [ 19, 20, 21, 22, 23],
     // drumbot
     [0],
     [0],
     // devibot
     [0],
     [0],
     // ganapati
     [0],
     [0]]
     @=> int low_actuator_a[][];

    // 1st element, clappers; 2nd element, marimba; 
    // 3rd element, trimpbeat; 4th element, trimpspin
    [ 3, 17, 10,  1,  1, 0, 0, 0] @=> int low_velocity_a[];

    // ~~~~~~~~~~~~~~~~~~~~~~

    // clappers
    [[ 0], 
     [ 0], 
    // marimba, 
     [48, 50, 55, 57, 64, 65, 71, 72, 78, 79, 86, 66, 95, 96], 
     [ 5,  5,  6,  6,  7,  7,  8,  8,  9,  9, 10, 10, 11, 11], 
    // trimpbeat
     [  0], 
     [  0], 
    // trimpspin
     [ 0], 
     [ 0], 
    // switch 
     [  0,  1,  2,  3,  4], 
     [ 19, 20, 21, 22, 23], 
     // drumbot
     [0],
     [0],
     // devibot
     [0],
     [0],
     // ganapati
     [0],
     [0]]
     @=> int mid_actuator_a[][];

    [3, 15, 17,  0,  3, 0, 0, 0] @=> int mid_velocity_a[];

    // ~~~~~~~~~~~~~~~~~~~~~~~

    // clappers
    [[ 0], 
     [ 0], 
    // marimba, 
     [52, 59, 66, 74, 81, 65, 90],
     [ 5,  6,  7,  8,  9, 10, 11],
    // trimpbeat
     [ 0], 
     [ 0], 
    // trimpbeat
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // switch 
     [  0,  1,  2,  3,  4], 
     [ 19, 20, 21, 22, 23], 
     // drumbot
     [0],
     [0],
     // devibot
     [0],
     [0],
     // ganapati
     [0],
     [0]]
     @=> int high_actuator_a[][];

     [ 0, 15, 0, 0, 8, 0, 0, 0] @=> int high_velocity_a[];

    // ~~~~~~~~~~~~~~~~~~~~~~~

    // clappers
    [[ 0], 
     [ 0], 
    // marimba, 
     [ 52],
     [ 0],
    // trimpbeat
     [ 0], 
     [ 0], 
    // trimpbeat
     [ 0], 
     [ 0], 
    // switch 
     [ 0], 
     [ 0], 
     /// drumbot
     [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12],
     [0, 5, 6, 7, 8, 9,10,11,12,13,14,15,16],
     // devibot
     [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12],
     [0, 5, 6, 7, 8, 9,10,11,12,13,14,15,16],
     // ganipati
     [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12],
     [0, 5, 6, 7, 8, 9,10,11,12,13,14,15,16]]
     @=> int other_actuator_a[][];

     [ 0, 0, 0,  0, 8, 10, 10, 10] @=> int other_velocity_a[];


    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ second section

    // clapper list
    // 0,  1,  2,  3,  4,  7, 17

    // marimba list
    // 45, 47, 48, 50, 52, 
    // 53, 54, 55, 57, 59, 
    // 60, 62, 64, 65, 66, 
    // 67, 69, 71, 72, 74, 
    // 76, 77, 78, 79, 81, 
    // 83, 84, 86, 66, 90, 
    // 91, 93, 95, 96],

    // trimpbeat
    // 59, 60, 61, 62, 
    // 63, 64, 65, 66
    // 67, 68, 69, 70, 
    // 71, 72, 73, 74, 
    // 75, 76, 77, 78 

    // clappers, 
    [[ 0,  7,  1,  2,  3,  4, 17], 
     [ 2,  4,  6,  9, 20, 21, 23],
    // marimba, 
     [45, 47, 53, 54, 60, 62, 67, 69, 76, 77, 83, 84, 91, 93], 
     [ 1,  1,  3,  3, 12, 12, 15, 15, 18, 18, 20, 20, 22, 22], 
    // trimpbeat
     [59, 60, 63, 64, 71, 72, 75, 76], 
     [ 5,  5, 11, 11, 14, 14, 17, 17], 
    // trimpspin
     [ 0,  1], 
     [ 0,  2], 
    // switch 
     [ 0,  1,  2,  3], 
     [ 7, 10, 13, 16], 
     // drumbot
     [0],
     [0],
     // devibot
     [0],
     [0],
     // ganapati
     [0],
     [0]]
     @=> int low_actuator_b[][];

    // 1st element, clappers; 2nd element, marimba; 
    // 3rd element, trimpbeat; 4th element, trimpspin
    [4, 14, 12, 10, 9, 0, 0, 0] @=> int low_velocity_b[];

    // ~~~~~~~~~~~~~~~~~~~~~~

    // clappers
    [[ 0,  0,  0], 
     [ 0,  0,  0], 
    // marimba, 
     [48, 50, 55, 57, 64, 65, 67, 71, 71, 78, 79, 86, 95, 96], 
     [ 1,  1,  3,  3, 12, 12, 15, 15, 18, 18, 20, 20, 22, 22], 
    // trimpbeat, 
     [61, 62, 69, 70, 73, 74, 77, 78], 
     [ 5,  5, 11, 11, 14, 14, 17, 17], 
    // trimpspin
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // trimpspin
     [ 0,  0,  0], 
     [ 0,  0,  0], 
     // drumbot
     [0],
     [0],
     // devibot
     [0],
     [0],
     // ganapati
     [0],
     [0]]
     @=> int mid_actuator_b[][];

    [0,  15,  14,  0, 0, 0, 0, 0] @=> int mid_velocity_b[];

    // ~~~~~~~~~~~~~~~~~~~~~~~

    // clappers
    [[ 0,  0,  0], 
     [ 0,  0,  0], 
    // marimba
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // trimpbeat, 
     [59, 60, 63, 64, 67, 68, 71, 72, 75, 76], 
     [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 
    // trimpspin
     [ 0,  0,  0], 
     [ 0,  0,  0], 
    // switch 
     [ 0,  0,  0], 
     [ 0,  0,  0], 
     // drumbot
     [0],
     [0],
     // devibot
     [0],
     [0],
     // ganapati
     [0],
     [0]]
     @=> int high_actuator_b[][];

     [0,  0,  10,  0, 0, 0, 0, 0] @=> int high_velocity_b[];

    // ~~~~~~~~~~~~~~~~~~~~~~~

    // clappers
    [[ 0], 
     [ 0], 
    // marimba, 
     [ 52],
     [ 0],
    // trimpbeat
     [ 0], 
     [ 0], 
    // trimpspin
     [ 0], 
     [ 0], 
    // switch 
     [ 0], 
     [ 0], 
     // drumbot
     [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12],
     [0, 5, 6, 7, 8, 9,10,11,12,13,14,15,16],
     // devibot
     [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12],
     [0, 5, 6, 7, 8, 9,10,11,12,13,14,15,16],
     // ganapati
     [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12],
     [0, 5, 6, 7, 8, 9,10,11,12,13,14,15,16]]
     @=> int other_actuator_b[][];

     [ 0,  0,  0,  0, 8, 10, 10, 10] @=> int other_velocity_b[];

    // vars to hold total number of actuators per threshold setting
    int num_low_a;
    int num_mid_a;
    int num_high_a;
    int num_other_a;

    int num_low_b;
    int num_mid_b;
    int num_high_b;
    int num_other_b;

    // finds the number of assigned actuators
    for (int i; i < address.size(); i++) {
        low_actuator_a[i * 2].size() +=> num_low_a; 
        mid_actuator_a[i * 2].size() +=> num_mid_a; 
        high_actuator_a[i * 2].size() +=> num_high_a; 
        other_actuator_a[i * 2].size() +=> num_other_a; 
        low_actuator_b[i * 2].size() +=> num_low_b; 
        mid_actuator_b[i * 2].size() +=> num_mid_b; 
        high_actuator_b[i * 2].size() +=> num_high_b; 
        other_actuator_b[i * 2].size() +=> num_other_b; 
    }

    int switch[24];
    1000 => int switch_threshold;
    int waiting[8][0];

    // our variables so the actuators don't trigger too quickly
    num_low_a => waiting[0].size;
    num_mid_a => waiting[1].size;
    num_high_a => waiting[2].size;
    num_other_a => waiting[3].size;
    num_low_b => waiting[4].size;
    num_mid_b => waiting[5].size;
    num_high_b => waiting[6].size;
    num_other_b => waiting[7].size;

    // functions to ensure we don't constantly send messages 
    fun void wait(int type, int idx) {
        1 => waiting[type][idx];
        wait_time + Math.random2(0,50)::ms=> now;
        0 => waiting[type][idx];
    }

    // 0-5 which arduino
    // 0-3 which array of switches
    // 1-7 how many switches

    // our sender
    fun void send(string addr, int idx, int vel) {
        if (addr != "/switch") {
            out.start(addr);
            out.add(idx);
            out.add(vel);
            out.send();
        }
        if (addr == "/switch") {
            switch_out.start(addr);
            switch_out.add(Math.random2(0,3));
            switch_out.add(Math.random2(0,2));
            switch_out.add(Math.random2(0,8));
            //switch_out.add(7);
            switch_out.send();
        }
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

    fun void check(float X[], int cap, string which) {
        for (int i; i < cap; i++) {
            if (X[i] > low_threshold) {
                if (switch[i] < switch_threshold) {
                    send(i, 0, low_actuator_a, low_velocity_a); 
                }
                else {
                    send(i, 4, low_actuator_b, low_velocity_b); 
                }
            }
            if (X[i] > mid_threshold) {
                if (switch[i] < switch_threshold) {
                    send(i, 1, mid_actuator_a, mid_velocity_a); 
                }
                else {
                    send(i, 5, mid_actuator_b, mid_velocity_b); 
                }
            }
            if (X[i] > high_threshold) {
                if (switch[i] < switch_threshold) {
                    send(i, 2, high_actuator_a, high_velocity_a); 
                }
                else {
                    send(i, 6, high_actuator_b, high_velocity_b); 
                }
            }
            if (X[i] > other_threshold) {
                if (switch[i] < switch_threshold) {
                    send(i, 3, other_actuator_a, other_velocity_a); 
                }
                else {
                    send(i, 7, other_actuator_b, other_velocity_b); 
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
