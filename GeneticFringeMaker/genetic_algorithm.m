function [x,fval,exitflag,output,population,score] = genetic_algorithm(nvars,EliteCount_Data,CrossoverFraction_Data,Generations_Data,StallGenLimit_Data,TolFun_Data, pitch)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = gaoptimset;

% Define the variables
if nargin == 0,
    pitch = 36;
end
defineVariables(pitch);

%% Modify options setting
options = gaoptimset(options,'EliteCount', EliteCount_Data);
options = gaoptimset(options,'CrossoverFraction', CrossoverFraction_Data);
options = gaoptimset(options,'MigrationDirection', 'both');
options = gaoptimset(options,'Generations', Generations_Data);
options = gaoptimset(options,'StallGenLimit', StallGenLimit_Data);
options = gaoptimset(options,'TolFun', TolFun_Data);
options = gaoptimset(options,'CreationFcn', @creation);
options = gaoptimset(options,'FitnessScalingFcn', {  @fitscalingtop [] }); %fitscalingshiftlinear
options = gaoptimset(options,'SelectionFcn', {  @selectiontournament [] });
options = gaoptimset(options,'CrossoverFcn', @crossover);
options = gaoptimset(options,'MutationFcn', @mutation);
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'PlotFcns', { @gaplotbestf });
options = gaoptimset(options,'Vectorized', 'off');
options = gaoptimset(options,'UseParallel', 'always');
[x,fval,exitflag,output,population,score] = ...
ga(@fitness,nvars,[],[],[],[],[],[],[],[],options);
