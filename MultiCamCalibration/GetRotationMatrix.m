function [ rot ] = GetRotationMatrix( rx, ry, rz )
%GETROTATIONMATRIX Summary of this function goes here
%   Detailed explanation goes here

X = eye(3,3);
Y = eye(3,3);
Z = eye(3,3);

X(2,2) = cos(rx);
X(2,3) = -sin(rx);
X(3,2) = sin(rx);
X(3,3) = cos(rx);

Y(1,1) = cos(ry);
Y(1,3) = sin(ry);
Y(3,1) = -sin(ry);
Y(3,3) = cos(ry);

Z(1,1) = cos(rz);
Z(1,2) = -sin(rz);
Z(2,1) = sin(rz);
Z(2,2) = cos(rz);

rot = Z*Y*X;

end

