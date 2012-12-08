function wav2midi(fname, segment_length, tempo)

if nargin < 3
  tempo = 80;
end
if nargin < 2
  segment_length = 5000;
end

disp(fname)
disp(segment_length)
disp(tempo)

% Extract segments.
[segments, beat_numbers, velocities] = extract_segments(fname, segment_length, tempo);

% Extract features.
fprintf('Extracting features...');
X = features(segments, 3);
f = fopen([fname, '_features.csv'], 'w');
for i=1:size(X,1);
  fprintf(f, '%.4f,', X(i,1:end-1));
  fprintf(f, '%.4f\n', X(i,end));
end

% Classify.
fprintf('Classifying...');
system(['python test.py ', fname]);
instruments = cell2mat(textscan(fopen([fname, '_labels.csv'], 'r'), '%d'));

fprintf('Converting to MIDI...');
f = fopen([fname, '.premidi'], 'w');
% Write times.
fprintf(f, '%d,', beat_numbers(1:end-1));
fprintf(f, '%d\n', beat_numbers(end));
% Write instruments.
fprintf(f, '%d,', instruments(1:end-1));
fprintf(f, '%d\n', instruments(end));
% Write velocities.
fprintf(f, '%d,', velocities(1:end-1));
fprintf(f, '%d\n', velocities(end));

system(['python toMIDI.py ', fname, '.premidi']);

% synth(round(beat_numbers * 4.0) / 4.0, instruments, velocities);
synth(beat_numbers, instruments, velocities);