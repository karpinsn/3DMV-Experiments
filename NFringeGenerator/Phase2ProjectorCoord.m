function [ u ] = Phase2ProjectorCoord( phi0, pitch, phase )
%PHASE2PROJECTOR This function takes a phase reading and converts it
%to a projector coordinate

u = 1 + ( ( phase - phi0 ) / ( ( 2 * pi ) / pitch ) );
end