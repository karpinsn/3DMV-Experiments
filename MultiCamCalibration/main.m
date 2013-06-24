%% Read in the camera calibration
intrinsic = [1.71391223e+003 0. 3.87103546e+002; ...
             0. 1.71188330e+003 4.71616547e+002; ...
             0. 0. 1.];
         
distortion = [-1.79589480e-001 3.02766383e-001 -2.17730156e-003 9.17747675e-005 -1.93590903e+000];
extrinsic = [-6.92292058e-004 9.74833906e-001 -2.22931430e-001; ...
              9.99314666e-001 -7.57609913e-003 -3.62320207e-002; ...
              -3.70091498e-002 -2.22803742e-001 -9.74160552e-001];

% OpenCV has X axis going down, we want it left and right
zRot = makehgtform('zrotate', 90 * pi / 180);
extrinsic = zRot(1:3,1:3) * extrinsic; 
          
extrinsicTranslation = [-3.40280390e+000; -5.11039400e+000; 2.58861847e+001];

%% Now rotate the reference
image = imread('Plane.png');
image = rgb2gray(image);
[height, width] = size(image);

% Create our list of coordinates
[mu, mv] = meshgrid(1:width, 1:height);
mu = reshape(mu', width*height,1);
mv = reshape(mv', width*height,1);
texCoordList = [(mu-1)';(mv-1)';ones(1, length(mu))];

%% Apply intrinsic and distortion parameters
% Texture 2 lens coordinates
lensCoordList = intrinsic \ texCoordList;


% Fix radial distortion
r2 = lensCoordList(1,:).^2 + lensCoordList(2,:).^2;

rDist = 1.0 + distortion(1) * (r2) + ...
              distortion(2) * (r2.^2) + ...
              distortion(3) * (r2.^3);

lensCoordList = lensCoordList .* (ones(3,1) * rDist);
lensCoordList(3,:) = 1.0;          

% Fix tangental distortion
a1 = 2.0 .* lensCoordList(1,:) .* lensCoordList(2,:);
a2 = r2 + 2.0 .* lensCoordList(1,:).^2;
a3 = r2 + 2.0 .* lensCoordList(2,:).^2;

lensCoordList = lensCoordList + [distortion(3) .* a1 + distortion(4) .* a2; 
                                 distortion(3) .* a3 + distortion(4) .* a1;
                                 zeros(1, length(a1))];
                             
%% Apply extrinsic rotation
% Transpose is inverse of rotation matrix
worldCoordList = extrinsic \ lensCoordList;

% Since our coordinate system origin is in the upper left hand,
% we need to shift down. This can be done by a y translation
worldCoordList = worldCoordList - ([0;-.42;0] * ones(1, width*height));

% Scale back
worldCoordList = worldCoordList ./ [worldCoordList(3,:); worldCoordList(3,:); worldCoordList(3,:)];


% Convert back to new lens coordinate system. Since we want it facing the
% camera, we would multiply by the identity
lensCoordList = worldCoordList;

% Convert back to image coordinate system
texCoordList = intrinsic * lensCoordList;

%% Resample Image
% Lens 2 texture
samples = InterpolateSample(double(image), mu, mv, texCoordList(1,:), texCoordList(2,:));
samples = uint8(samples);

figure;
imshow(samples);