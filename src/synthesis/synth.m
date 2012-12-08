function output = synth(beatTimeStamps,labels,velocities)
% beatTimeStamps = [1,2,3,4];
% labels = [1 1 2 3];
% velocities = [127 40 127 127];
addpath samples
Fs = 44100;
sampleTimeStamps = round(beatTimeStamps/80*60 * 44100);
kick = wavread('kick.wav');
snare = wavread('snare.wav');
hihat = wavread('hihat.wav');
output = zeros(1,max(sampleTimeStamps)+max([size(kick,1),size(snare,1),size(hihat,1)]));
sounds{1} = kick;
sounds{2} = hihat;
sounds{3} = snare;
for i = 1:length(sampleTimeStamps);
    soundType = labels(i);
    sampleRegion = sampleTimeStamps(i):sampleTimeStamps(i)+length(sounds{soundType})-1;
    size(sampleRegion)
    length(sounds{soundType})
    output(sampleRegion) = ...
        output(sampleRegion)+ velocities(i)/127*sounds{labels(i)}';
    

end
sound(output,Fs);