function [ intrinsic, distortion, extrinsic ] = ReadCalibration( calibFilename )
%READCALIBRATION Reads a javascript calibration file and returns the calib
%values

intrinsic = zeros( 3 );
extrinsic = zeros( 3, 4 );
distortion = zeros( 1, 5 );

fileHandle = fopen( calibFilename );
line = fgetl( fileHandle );

while( ischar( line ) )
    subStart = strfind( line, '[' ) + 1;
    subEnd = strfind( line, ']' ) - 1;
    
    if( strfind( line, 'this.Intrinsic' ) > 0 )
        line = line( subStart : subEnd );
        intrinsic = reshape( sscanf( line, '%f,', 3 * 3 ), 3, 3 )';
    elseif( strfind( line, 'this.Extrinsic' ) > 0 )
        line = line( subStart : subEnd );
        extrinsic = reshape( sscanf( line, '%f,', 4 * 3 ), 4, 3 )';
    elseif( strfind( line, 'this.Distortion' ) > 0 )
        line = line( subStart : subEnd );
        distortion = sscanf( line, '%f,', 3 * 3 )';
    end
    line = fgetl( fileHandle );
end

fclose( fileHandle );
end

