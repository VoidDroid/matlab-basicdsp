This is a GUI tool for LMS algorithms. Current ver. - 0.5

Requires MATLAB 2015 or above. Download the files and store them in the same directory. Open `lms_var.fig` in Matlab. To do this, start Matlab --> New --> Graphical User Interface --> Open Existing GUI --> Browse and locate `lms_var.fig`. Run the file after it opens.

# GUI Details

`Waveform` - Input signal to the adaptive filter (also the desired signal). `Arbitrary` is used for loading other waveforms. (will be added in a future version)  
`Frequency` - Frequency of input signal.  
`Noise` - Select the type of noise. Phase noise will be added in a future version.  
`Sigma` - Standard deviation for White Gaussian noise.  
`Lambda` - Average rate of occurence for Shot noise (modeled on Poisson Distribution).  
`LMS Algorithms` - Select the type of LMS algorithm (Block LMS will be added in a future version).  
`Step` - Step size of the LMS algorithm.  
`Order` - Select number of filter taps.  
`Evaluate` - After entering the above parameters click evaluate to obtain the Learning Curve and Filtered output.


