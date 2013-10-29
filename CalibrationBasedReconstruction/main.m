%% Calibration Stuff
[ CameraIntrinsic, CameraDistortion, CameraExtrinsic ] = ReadCalibration( 'CameraCalibration.js' );
CameraMatrix = CameraIntrinsic * CameraExtrinsic;
[ ProjectorIntrinsic, ProjectorDistortion, ProjectorExtrinsic ] = ReadCalibration( 'ProjectorCalibration.js' );
ProjectorMatrix = ProjectorIntrinsic * ProjectorExtrinsic;

%% Read a frame
fringe1 = double( imread('fringe1.png') );
fringe2 = double( imread('fringe2.png') );

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
        uv = FixDistortion( uv, CameraIntrinsic, CameraDistortion );
        uP = uPMap(height,width);
        xyz(height,width,:) = ProcessCoordinate(uv, uP, CameraMatrix, ProjectorMatrix);
    end
end
warning(s); % Turn warnings back on 