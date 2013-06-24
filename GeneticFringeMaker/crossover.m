function xoverKids = crossover(parents,options,NVARS, FitnessFcn,thisScore,thisPopulation)

%   crossover Custom crossover function for traveling salesman.
%   XOVERKIDS = CROSSOVER_PERMUTATION(PARENTS,OPTIONS,NVARS, ...
%   FITNESSFCN,THISSCORE,THISPOPULATION) crossovers PARENTS to produce
%   the children XOVERKIDS.
%
%   The arguments to the function are 
%     PARENTS: Parents chosen by the selection function
%     OPTIONS: Options structure created from GAOPTIMSET
%     NVARS: Number of variables 
%     FITNESSFCN: Fitness function 
%     STATE: State structure used by the GA solver 
%     THISSCORE: Vector of scores of the current population 
%     THISPOPULATION: Matrix of individuals in the current population

global P height width H source;

nChildren = length(parents)/2;
[m, n] = size(thisPopulation);
xoverKids = zeros(length(parents)/2, n);

if (nChildren > 0),
    for i = 1:nChildren,
        index = i*2-1; %index of the parent
        parent = reshape(thisPopulation(parents(index),:), height,width);
        child =  reshape(thisPopulation(parents(index+1),:), height, width);
        x = rand();
        if x > 0.75,
            parent = circshift(parent, [floor(rand()*height), 0]);
        elseif x > 0.5,
            parent = 1 - circshift(parent, [0 width/2]);
            %parent = circshift(parent, [floor(rand()*height), 0]);
        elseif x > 0.25,
            parent = 1 - fliplr(parent);
            %parent = circshift(parent, [floor(rand()*height), 0]);
        end
        
        
        row = floor(rand()*(height-1)+1);
        col = floor(rand()*(width-1)+1);
        

        
        %Give a 50% chance that we will select a cell that is above
        %one standard deviation in error
        if rand() > 0.5,
            [z, error] = fitness(child);
            meanError = mean(error(:));
            stdError = std(error(:));
            nMax = 0;
            while nMax < 100;
                row1 = floor(rand()*(height-1)+1);
                col1 = floor(rand()*(width-1)+1);
                if (error(row1,col1) > (meanError + stdError)),
                    row = row1;
                    col = col1;
                    break;
                end
                nMax = nMax + 1;
            end
        end

        row1 = row + floor(rand()*6);
        col1 = col + floor(rand()*6);
        
        child(modNoZero(row:row1, height), modNoZero(col:col1, width)) = parent(modNoZero(row:row1, height), modNoZero(col:col1, width));
        xoverKids(i,:) = reshape(child, 1, []);

    end
end

end