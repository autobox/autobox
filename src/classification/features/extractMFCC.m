

load corpusMatrix.mat
addpath kannumfcc
addpath voicebox
for fIndex = 1:5
    f = features(corpusMatrix,fIndex);
    
    csvwrite(['CrossValidation/Features/f',fIndex, '.csv'],f) 

end        
