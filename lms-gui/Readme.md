This is a GUI tool for LMS algorithms. Current ver. - 0.7

Download the files and store them in the same directory. Open `lms_var.fig` in Matlab. To do this, start Matlab --> New --> Graphical User Interface --> Open Existing GUI --> Browse and locate `lms_var.fig`. Run the file after it opens.

### Use

`Waveform` - Input signal to the adaptive filter (also the desired signal).  
`Arbitrary` - Used to load waveforms from the base workspace. Enter the name of the waveform in the textbox and click load.  
`Frequency` - Frequency of input signal.  
`Noise` - Select the type of noise. Phase noise will be added in a future version.  
`Sigma` - Standard deviation for White Gaussian noise.  
`Lambda` - Average rate of occurence for Shot noise (modeled on Poisson Distribution).  
`LMS Algorithms` - Select the type of LMS algorithm.  
`Step` - Step size of the LMS algorithm.  
`Order` - Select number of filter taps.  
`Evaluate` - After entering the above parameters click evaluate to obtain the Learning Curve and Filtered output.

Was programmed in MATLAB 2015 but is compatible with earlier versions.
