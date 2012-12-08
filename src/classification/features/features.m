

function mfccMatrix = features(segs,fIndex)
%load segs.mat
%segs = corpusMatrix;
findex = 1;    
fs = 44100;
addpath kannumfcc
addpath voicebox

switch fIndex
    case 1
        numCoeffs = 20;
        testf = kannumfcc(numCoeffs,segs(1,:)',fs);
        mfccMatrix = zeros(size(segs,1),length(testf(:)));
        for i = 1:size(segs,1)
           mfcc = kannumfcc(numCoeffs,segs(i,:)',fs);
           mfccMatrix(i,:) = mfcc(:);
        end
    case 2
        numCoeffs = 20;
        testf = kannumfcc(numCoeffs,segs(1,:)',fs);
        mfccMatrix = zeros(size(segs,1),length(testf(:)));
        for i = 1:size(segs,1)
           mfcc = kannumfcc(numCoeffs,segs(i,:)',fs);
           mfccMatrix(i,:) = mfcc(:);
        end
        mfccMatrix = bsxfun(@rdivide, mfccMatrix, mean(mfccMatrix));
        mfccMatrix = mfccMatrix - mean(mfccMatrix,2);
        mfccMatrix = bsxfun(@rdivide, mfccMatrix, var(mfccMatrix));
    case 3
        numCoeffs = 20;
        testf = kannumfcc(numCoeffs,segs(1,:)',fs);
        mfccMatrix = zeros(size(segs,1),length(testf(:)));
        for i = 1:size(segs,1)
           mfcc = kannumfcc(numCoeffs,segs(i,:)',fs);
           mfccMatrix(i,:) = mfcc(:);
        end
        mfccMatrix = bsxfun(@rdivide, mfccMatrix, mean(mfccMatrix));
        mfccMatrix = mfccMatrix - mean(mfccMatrix,2);
        mfccMatrix = bsxfun(@rdivide, mfccMatrix, var(mfccMatrix));
    case 4
        numCoeffs = 20;
        testf = kannumfcc(numCoeffs,segs(1,:)',fs);
        mfccMatrix = zeros(size(segs,1),length(mean(testf)));
        for i = 1:size(segs,1)
           mfcc = kannumfcc(numCoeffs,segs(i,:)',fs);
           mfccMatrix(i,:) = mean(mfcc);
        end
        mfccMatrix = bsxfun(@rdivide, mfccMatrix, mean(mfccMatrix));
        mfccMatrix = mfccMatrix - mean(mfccMatrix,2);
        mfccMatrix = bsxfun(@rdivide, mfccMatrix, var(mfccMatrix));
    case 5
        numCoeffs = 24;
        testf = kannumfcc(numCoeffs,segs(1,:)',fs);
        mfccMatrix = zeros(size(segs,1),length(testf(:)));
        for i = 1:size(segs,1)
           mfcc = kannumfcc(numCoeffs,segs(i,:)',fs);
           mfccMatrix(i,:) = mfcc(:);
        end
       mfccMatrix = bsxfun(@rdivide, mfccMatrix, mean(mfccMatrix));
        mfccMatrix = mfccMatrix - mean(mfccMatrix,2);
        mfccMatrix = bsxfun(@rdivide, mfccMatrix, var(mfccMatrix));
end


%csvwrite('f1.csv',mfccMatrix)
%save('mfccMatrix.mat','mfccMatrix');