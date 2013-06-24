function [error, spikeCount] = OptimalSixFringeWaveFinder ( fringeSize, Ipp )

if nargin < 1
    fringeSize = 1024;
end
if nargin < 2
    Ipp = 255;
end

lambda1s = 1:200;
lambda2s = 1:200;

noiseAmt = 0.03;
errorTolerance = 1;

error = zeros(length(lambda1s), length(lambda2s));
spikeCount = zeros(length(lambda1s), length(lambda2s));
x = 1 : fringeSize;

sprintf('       ');
fprintf('\n f1    \tf2   \terror')
for i = 1:length(lambda1s)
    for j = 1:length(lambda2s)
        
    lambda1 = lambda1s(i);
    lambda2 = lambda2s(j);
   
    % Make sure we can unwrap the entire wavelength and are divisible by
    % our step count
    if(fringeSize > lambda_eq( lambda1, lambda2 ) || lambda1 == lambda2 || 0 ~= mod(lambda1, 3) || 0 ~= mod(lambda2, 3))
        error(i,j) = Inf; spikeCount(i,j) = Inf; continue;
    end
    
    % Get our ideal fringe
    fringe1 = getFringe(x, lambda1);
    fringe2 = getFringe(x, lambda2);
    
    % Quantize
    fringe1 = uint8( ( fringe1 + 1) * ( Ipp / 2 ) );
    fringe2 = uint8( ( fringe2 + 1) * ( Ipp / 2 ) );
    
    % Add noise with normal dist, mean 0 and standard deviation noiseAmt
    % Negative and positive numbers are added
    fringe1 = double(fringe1) / (255 / 2) - 1 + normrnd(0, noiseAmt, [length(x), 3] );
    fringe2 = double(fringe2) / (255 / 2) - 1 + normrnd(0, noiseAmt, [length(x), 3] );
    
    phi1 = getPhi(fringe1);
    phi2 = getPhi(fringe2);
    
    phase = phiAbs3(phi1, phi2, lambda1, lambda2);
    PhiRecovered = phase * lambda1 / ( 2 * pi );
    delta = PhiRecovered - x;
    spikeCount(i,j) = sum(delta > lambda1);
    error(i,j) = rms(delta) / fringeSize;
    
    if (error(i,j) < errorTolerance),
        %fprintf('\n%3d \t%3d \t%1.5f', lambda1, lambda2, error(i,j))
    end 
    end
end

fprintf('\n');
minError = min( min( error(:,:) ) );
[lambda1, lambda2] = find(minError == error);

fprintf('Lowest Error: %d \t%d \t%1.5f\n', lambda1, lambda2, minError )

figure; imagesc(error, [0 errorTolerance]);
ylabel('\lambda_1');
xlabel('\lambda_2');
title('RMS Error: Two Wavelength Method');

figure; imagesc(spikeCount, [0 fringeSize/4]);
ylabel('\lambda_1');
xlabel('\lambda_2');
title('Spike Count: Two Wavelength Method');

figure; scatter(reshape(error, 1, []), reshape(spikeCount, 1, []));
cursorMode = datacursormode(gcf);
set(cursorMode, 'enable','on', 'UpdateFcn', @scatterPlotDataCursorOutput, 'NewDataCursorOnClick',false);

end

function lambda = lambda_eq(lambda1, lambda2)
    lambda = lambda1 * lambda2 / abs(lambda1 - lambda2);
end

function phi = delta_phi( phi1, phi2 )
    phi = mod( phi1 - phi2, 2*pi );
end

function fringe = getFringe( x, lambda )
    fringe = zeros( length( x ), 3 );
    fringe(:,1) = cos( ( 2.0 * pi ) * ( x / lambda ) + ( 2 * pi / 3 ) );
    fringe(:,2) = cos( ( 2.0 * pi ) * ( x / lambda ) );
    fringe(:,3) = cos( ( 2.0 * pi ) * ( x / lambda ) - ( 2 * pi / 3 ) );
end

function phi = getPhi( fringe )
    S = sqrt(3) * ( fringe(:,3) - fringe(:,1) );
    C = 2 * fringe(:,2) - fringe(:,1) - fringe(:,3);
    phi = atan2(S, C)';
end

function kStep = getPeriod(phi1, phi12, P1, P12)
    k = ( phi12 * ( P12 / P1 ) - phi1 ) / (2.0 * pi ); 
    kStep = round( k );
end

function Phi = phiAbs3(phi1, phi2, P1, P2)
    P12   = lambda_eq(P1, P2);
    phi12 = delta_phi( phi1, phi2 );
    k     = getPeriod( phi1, phi12, P1, P12 );
    Phi   = phi1 + 2 * pi * k;
end

function output_txt = scatterPlotDataCursorOutput(obj,event_obj)
    % Display the position of the data cursor
    % obj          Currently not used (empty)
    % event_obj    Handle to event object
    % output_txt   Data cursor text string (string or cell array of strings).

    pos = get(event_obj,'Position');

    % Import x and y
    x = get(get(event_obj,'Target'),'XData');
    y = get(get(event_obj,'Target'),'YData');

    % Find index
    index_x = find(x == pos(1));
    index_y = find(y == pos(2));
    index = intersect(index_x,index_y);

    [lambda1, lambda2] = ind2sub([200, 200], index);
    
    % Set output text
    output_txt = {['X: ',num2str(pos(1),4)], ...
                  ['Y: ',num2str(pos(2),4)], ...
                  ['Lambda1: ', num2str(lambda1)], ...
                  ['Lambda2: ', num2str(lambda2)]};

    % If there is a Z-coordinate in the position, display it as well
    if length(pos) > 2
        output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
    end

end