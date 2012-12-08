#!/bin/bash
MATLAB="/Applications/MATLAB_R2012a.app/bin/"
$MATLAB/matlab -nodesktop -nosplash -nodisplay -r "wav2midi('$1');quit"

#TODO: Specify which classifier.