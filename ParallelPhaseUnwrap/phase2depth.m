function [ depthMap ] = phase2Depth(actualPhase, referencePhase, scalingFactor)

depthMap = (actualPhase - referencePhase) * scalingFactor;

end
