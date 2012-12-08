%%Make corpus matrix

folder = ...
    '/Users/headradio/Dropbox/Skinny\ Papa\ \(1\)/Beatbox\ Detection/BeatBoxCorpus/'; 

directory = dir('BeatBoxCorpus/*.wav');
ditherAmount = 3*10^-5;
thresh = ditherAmount+4*10^-5;
corpusCellArray = {};
corpusLabels = [];
for fileIndex = 1:length(directory)
    fileName = directory(fileIndex,1).name
    wav = wavread(['BeatBoxCorpus/',fileName]);
    switch fileName(1:end-5)
        case 'Kicks'
            label = 1;
            wav = wav(:,1);
            cellArray = getCellArray(wav,thresh);
            labels = ones(size(cellArray))'*label;
        case 'Snare'
            label = 2;
            wav = wav(:,1);
            cellArray = getCellArray(wav,thresh);
            labels = ones(size(cellArray))'*label;
        case 'HiHats'
            label = 3;
            wav = wav(:,1);
            cellArray = getCellArray(wav,thresh);
            labels = ones(size(cellArray))'*label;
        case 'ActualPatternKickLeftHiMiddleSnareRight'
            bassWav = wav(:,1);%left
            snareWav = wav(:,2);%right
            hiHatWav = min(wav')';%center
            bassCellArray = getCellArray(bassWav,thresh);
            snareCellArray = getCellArray(snareWav,thresh);
            hiHatCellArray = getCellArray(hiHatWav,thresh);
                
            cellArray = [bassCellArray,snareCellArray,hiHatCellArray];
            labels = [1*ones(size(bassCellArray))';...
                      1*ones(size(snareCellArray))';...
                      1*ones(size(hiHatCellArray))'];
    end
   corpusCellArray = [corpusCellArray,cellArray];
   corpusLabels = [corpusLabels;labels];
   size(corpusCellArray)
end
save('corpusCellArray.mat','corpusCellArray')
soundLength = zeros(size(corpusCellArray));
for i = 1:length(corpusCellArray)
    soundLength(i) = length(corpusCellArray{i});
end
corpusMatrix = zeros(length(corpusCellArray),5000);
for i = 1:length(corpusCellArray)
    segl = length(corpusCellArray{i});
    if segl >=5000
        
        corpusMatrix(i,:) = corpusCellArray{i}(1:5000)';
    end
    if segl <5000
        corpusMatrix(i,:) = [corpusCellArray{i}', zeros(1,5000-segl)];
    end
end
save('corpusMatrix.mat','corpusMatrix')
csvwrite('corpusMatrix.csv',corpusMatrix)
csvwrite('corpusLabels.csv', corpusLabels)
% maxSoundLength = max(soundLength);
% corpusMatrix = zeros(length(corpusCellArray),maxSoundLength);
% for i = 1:length(corpusCellArray)
%     corpusMatrix(i,:) = [corpusCellArray{i},zeros(maxSoundLength-soundLength(i))];
% end


