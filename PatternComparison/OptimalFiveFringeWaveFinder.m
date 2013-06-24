function error = OptimalFiveFringeWaveFinder (fringeSize)

lambda1s = 1:200;
lambda2s = 1:200;

noiseAmt = 0.1;
errorTolerance = 1;

error = zeros(length(lambda1s), length(lambda2s));
spikeCount = zeros(length(lambda1s), length(lambda2s));
x = 1 : fringeSize;

sprintf('       ');
fprintf('\n f1    \tf2   \terror')
for i = 1:length(lambda1s),
    for j = 1:length(lambda2s),
        
    lambda1 = lambda1s(i);
    lambda2 = lambda2s(j);
   
    % Make sure we can unwrap the entire wavelength and are divisible by
    % our step count
    if(fringeSize > lambda_eq( lambda1, lambda2 ) || 0 ~= mod(lambda1, 5) || 0 ~= mod(lambda2, 5))
        error(i,j) = Inf; spikeCount(i,j) = Inf; continue;
    end
    
    % Add noise with normal dist, mean 0 and standard deviation noiseAmt
    % Negative and positive numbers are added
    fringe = getFringe(x, lambda1, lambda2) + normrnd(0, noiseAmt, [length(x), 5] );
    phi1 = getPhi1(fringe);
    phi2 = getPhi2(fringe);
    
    phase = phiAbs(phi1, phi2, lambda1, lambda2);
    PhiRecovered = phase * lambda1 / ( 2 * pi );
    delta = PhiRecovered - x;
    spikeCount(i,j) = sum(delta > lambda1);
    error(i,j) = rms(delta) / fringeSize;
    
    if (error(i,j) < errorTolerance),
        fprintf('\n%3d \t%3d \t%1.5f', lambda1, lambda2, error(i,j))
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
title('Two Wavelength Method');

figure; imagesc(spikeCount, [0 fringeSize/4]);
ylabel('\lambda_1');
xlabel('\lambda_2');
title('Spike Count: Two Wavelength Method');
end

function lambda = lambda_eq(lambda1, lambda2)
    lambda = lambda1 * lambda2 / abs(lambda1 - lambda2);
end

function phi = delta_phi( phi1, phi2 )
    phi = mod( phi1 - phi2, 2*pi );
end

function fringe = getFringe( x, lambda1, lambda2 )
    fringe = zeros( length( x ), 5 );
    for n = 1 : 5
        fringe(:,n) = ( cos( ( 2.0 * pi ) * ( x / lambda1 ) - ( 2 * pi * (n - 1) / 5 ) ) + cos( ( 2.0 * pi ) * ( x / lambda2 ) - ( 4 * pi * (n - 1) / 5 ) ) ) * .5;
    end
end

function phi = getPhi1( fringe )
    S = zeros(length(fringe(:,1)), 1);
    C = zeros(length(fringe(:,1)), 1);
    for n = 1 : 5
        S = S + fringe(:,n) * sin( ( 2 * pi * (n - 1) / 5 ) );
        C = C + fringe(:,n) * cos( ( 2 * pi * (n - 1) / 5 ) );
    end
    
    phi = atan2(S, C)';
end

function phi = getPhi2( fringe )
    S = zeros(length(fringe(:,1)), 1);
    C = zeros(length(fringe(:,1)), 1);
    for n = 1 : 5
        S = S + fringe(:,n) * sin( ( 4 * pi * (n - 1) / 5 ) );
        C = C + fringe(:,n) * cos( ( 4 * pi * (n - 1) / 5 ) );
    end
    
    phi = atan2(S, C)';
end

function kStep = getPeriod(phi1, phi12, P1, P12)
    k = ( phi12 * ( P12 / P1 ) - phi1 ) / (2.0 * pi ); 
    kStep = round( k );
end

function Phi = phiAbs(phi1, phi2, P1, P2)
    P12   = lambda_eq(P1, P2);
    phi12 = delta_phi( phi1, phi2 );
    k     = getPeriod( phi1, phi12, P1, P12 );
    Phi   = phi1 + 2 * pi * k;
end