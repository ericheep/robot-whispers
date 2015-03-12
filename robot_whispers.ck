// classes
Mel mel;
Matrix mat;
RobotSend rob;
Visualization vis;

// sound chain
adc => FFT fft => blackhole;

// fft parameters 
second / samp => float sr;
512 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;
UAnaBlob blob;

// calculates transformation matrix
mel.calc(512, sr, "mel") @=> float mx[][];
mat.transpose(mx) @=> mx;

24 => int MEL_BANDS;

// cuts off unnecessary half of transformation weights
mat.cutMat(mx, 0, win/2) @=> mx;

float X[0];

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;

    // keystrength cross correlation
    mat.dot(blob.fvals(), mx) @=> X;

    // rms scaling
    mat.rmstodb(blob.fvals()) @=> X;

    rob.check(X, MEL_BANDS);

    vis.data(X, "/data");
}
