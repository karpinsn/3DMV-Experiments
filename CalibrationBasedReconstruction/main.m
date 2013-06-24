%% Calibration Stuff
CameraIntrinsic = [2459.56,0,412.643;
                   0,2461.09,293.85;
                   0,0,1];

CameraExtrinsic = [0.905874, 0.004509, -0.423524, -70.8353;
                   0.0114156, -0.99984, 0.013772, 43.4707;
                   -0.423394,-0.0173105,-0.90578,1090.39];
               
CameraMatrix = CameraIntrinsic * CameraExtrinsic;

ProjectorIntrinsic = [4790.76,0,361.259;
                      0,4763.45,280.102;
                      0,0,1];
                 
ProjectorExtrinsic = [-0.999542,-0.0302509,-0.000308468,210.328;
                      -0.0301956,0.996988,0.0714395,80.2316;
                      -0.00185357,0.0714162,-0.997445,1806.64];
                   
ProjectorMatrix = ProjectorIntrinsic * ProjectorExtrinsic;

%% Testing
original = [0;0;0;1];
cam = CameraMatrix * original;
cam = cam ./ cam(3);

proj = ProjectorMatrix * original;
proj = proj ./ proj(3);

recon = ProcessCoordinate(cam, proj(1), CameraMatrix, ProjectorMatrix);

uv = [0;0;1];
ProcessCoordinate(uv, Phase2UPMap(2.0, -5.1313, 60), CameraMatrix, ProjectorMatrix)
ProcessCoordinate(uv, Phase2UPMap(5.0, -5.1313, 60), CameraMatrix, ProjectorMatrix)

%% Read a frame
captureMovie = VideoReader('Captured.avi');
fringe1 = zeros(captureMovie.height, captureMovie.width, 3);
fringe2 = zeros(captureMovie.height, captureMovie.width, 3);

offset = 1;
for channel = 1 : 3
    fringe1(:,:,channel) = rgb2gray(read(captureMovie, channel + offset));
    fringe2(:,:,channel) = rgb2gray(read(captureMovie, 3 + channel + offset));
end

%% Phase decoding
phase = Fringe2Phase(fringe1, fringe2, 60, 63);
uPMap = Phase2UPMap(phase, -5.1313, 60);

% TODO - Find this bug
uPMap = 1024 - uPMap;

%% Triangulation!
[m,n] = size(phase);
xyz = double(zeros(m,n,3));

s = warning('off','all'); % turn all warnings off. Bad phase values yield bad nearly singular matricies
for width = 1 : n
    for height = 1 : m
        uv = [width; height; 1];
        uP = uPMap(height,width);
        xyz(height,width,:) = ProcessCoordinate(uv, uP, CameraMatrix, ProjectorMatrix);
    end
end
warning(s); % Turn warnings back on 

plot3(xyz(:,:,1), xyz(:,:,2), xyz(:,:,3), '.');
set(gca, 'DataAspectRatio', [1,1,1]);