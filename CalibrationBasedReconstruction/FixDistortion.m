function [ fixedUV ] = FixDistortion( uvCoord, intrinsic, distortion )
%FIXDISTORTION Corrects for distortion coefficients 

fixedUV = intrinsic \ uvCoord;

% Fix radial distortion first
r2 = fixedUV(1) * fixedUV(1) + fixedUV(2) * fixedUV(2);
r4 = r2 * r2;
r6 = r4 * r2;
cDist = 1.0 + distortion(1) * r2 + distortion(2) * r4 + distortion(5) * r6;
fixedUV = fixedUV .* [cDist; cDist; 1.0];

% Fix tangental
a1 = 2.0 * fixedUV(1) * fixedUV(2);
a2 = r2 + 2.0 * fixedUV(1) * fixedUV(1);
a3 = r2 + 2.0 * fixedUV(2) * fixedUV(2);
fixedUV = fixedUV + [distortion(3) * a1 + distortion(4) * a2;
                     distortion(3) * a3 + distortion(4) * a1;
                     0.0];

fixedUV = intrinsic * ( fixedUV ./ [fixedUV(3); fixedUV(3); fixedUV(3) ] );
end

