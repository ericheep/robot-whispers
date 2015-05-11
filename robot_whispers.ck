// classes
Mel mel;
Matrix mat;
RobotSend lbot;
RobotSend rbot;
Visualization vis;

adc.left => Gain lgain => FFT lfft => blackhole;
adc.right => Gain rgain => FFT rfft => blackhole;

// sending audio out to Danny's soundcard
lgain => dac.left;
rgain => dac.right;

// fft parameters 
second / samp => float sr;
512 => int N => int win => rfft.size => lfft.size;

Windowing.hamming(N) => lfft.window;
Windowing.hamming(N) => rfft.window;
UAnaBlob lblob, rblob, lrmsblob, rrmsblob;

// calculates transformation matrix
mel.calc(512, sr, "mel") @=> float mx[][];
mat.transpose(mx) @=> mx;

24 => int MEL_BANDS;

// cuts off unnecessary half of transformation weights
mat.cutMat(mx, 0, win/2) @=> mx;

float lX[0];
float rX[0];

// main program
while (true) {
    // creates our array of fft bins
    lfft.upchuck() @=> lblob;
    rfft.upchuck() @=> rblob;

    win::samp => now;

    // keystrength cross correlation
    mat.dot(lblob.fvals(), mx) @=> lX;
    mat.dot(rblob.fvals(), mx) @=> rX;

    // rms scaling
    mat.rmstodb(lblob.fvals()) @=> lX;
    mat.rmstodb(rblob.fvals()) @=> rX;

    lbot.check(lX, MEL_BANDS, "left");
    rbot.check(rX, MEL_BANDS, "right");

    //vis.data(X, "/data");
}
