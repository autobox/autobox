function matrix = getMatrix(fileName)

wav = wavread(['BeatBoxCorpus/',fileName]);
wav = wav(:,1);
aboveThresh = wav'>thresh;
starts = strfind(aboveThresh, [zeros(1,100), 1]);
stops = strfind(aboveThresh, [1, zeros(1,100)]);
print starts


end

