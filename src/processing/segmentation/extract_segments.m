function [segments, beat_numbers, velocities] = extract_segments(fname, segment_length, tempo)
w = wavread([fname, '.wav']);

% w = double(w > 0.1);
w = 0.5 * (w(:,1) + w(:,2));

% Rewrite wav.
% w = w(1:1*size(w,1));
% fname = [fname, '-proc'];
% wavwrite(w, 44100, fname);

system(['./onset_detection/onset_program.py --offline --aw -s -t 5 files ', fname, '.wav']);

f = fopen([fname, '.onsets.txt'], 'r');
beat_times = cell2mat(textscan(f, '%.4f')) * 44100;

% Convert s to beat indices (120 beats per minute).
beat_numbers = (tempo * beat_times / 60) / 44100;

% Compute velocities.
velocities = zeros(size(beat_times));
N = min(segment_length, 1000);
wp = [w; zeros(N,1)];
for i=1:numel(beat_times)
  velocities(i) = sum(abs(wp(beat_times(i):beat_times(i)+N)));
end

velocities = floor(127.0 * velocities / max(velocities));

% % Write out onsets for midi conversion.
% f = fopen([fname, '.premidi'], 'w');
% % Times
% for i=1:numel(beat_numbers)-1
%   fprintf(f, '%.4f,', beat_numbers(i));
% end
% fprintf(f, '%.4f\n', beat_numbers(end));
% % Instruments
% for i=1:numel(beat_numbers)-1
%   fprintf(f, '1,');
% end
% fprintf(f, '1\n');
% % Velocities
% for i=1:numel(velocities)-1
%   fprintf(f, '%d,', velocities(i));
% end
% fprintf(f, '%d\n', velocities(end));

plot(w);
hold on
stem(beat_times, velocities .* ones(size(beat_times)) / 200.0, 'k');
%sound(w(is:ie), 44100);

% Return segments and velocities.
segments = zeros(numel(beat_times), segment_length);
for i=1:numel(beat_times)-1; 
  segments(i,:) = truncpad(w(beat_times(i):beat_times(i+1)), segment_length);
end
segments(end,:) = truncpad(w(beat_times(end):end), segment_length);

% for i=1:size(segments,1)
%   plot(segments(i,:));
%   pause;
% end

function s = truncpad(s, L)
if numel(s) > L
  s = s(1:L);
elseif numel(s) < L
  s = [s; zeros(L - numel(s), 1)];
end