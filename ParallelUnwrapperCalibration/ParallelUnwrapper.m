function [ n, f ] = ParallelUnwrapper( near1, near2, far1, far2, pitch1, pitch2, unwrappingLine)
%% Wrapping
[n1, ~, n12] = fringe2phase( near1, near2 );
[f1, ~, f12] = fringe2phase( far1, far2 );

%% Calculation Terms
[height, width] = size(n1);
pitch12 = (pitch1 * pitch2) / abs(pitch1 - pitch2);

%% Unwrapping
unwrap = @(p, w) p < unwrappingLine(w);
for w = 1 : width
    for h = 1 : height
        n12(h,w) = n12(h,w) + unwrap(n12(h,w), w) * 2 * pi;
        f12(h,w) = f12(h,w) + unwrap(f12(h,w), w) * 2 * pi;
    end
end

%% Unwrap phi1
kn = floor((n12 * (pitch12/pitch1) - n1) / (2.0 * pi));
kf = floor((f12 * (pitch12/pitch1) - f1) / (2.0 * pi));

% This phase should be unwrapped
n = n1 + kn * 2.0 * pi;
f = f1 + kf * 2.0 * pi;

%% Test Plot
figure;
hold on;
plot(n(400,:), 'r');
plot(f(400,:), 'b');

end

