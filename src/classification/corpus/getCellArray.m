function cellArray = getCellArray(monoWav,thresh)

aboveThresh = abs(monoWav')>thresh;
starts = strfind(aboveThresh, [zeros(1,2000), 1])+2000;
stops = strfind(aboveThresh, [1, zeros(1,2000)]);

for i = 1:min(length(starts),length(stops))
    cellArray{i} = monoWav(starts(i):stops(i));
end


end

