function mutationChildren = mutation(parents ,options,NVARS, FitnessFcn, state, thisScore,thisPopulation,mutationRate)

global height width nChannel source H lastBest;

[m, n] = size(thisPopulation);
mutationChildren = zeros(length(parents), n);

if (state.Generation == 1),
    lastBest = reshape(thisPopulation(1,:), height, width);
end

for i = 1:length(parents),
    mutationChildren(i,:) = thisPopulation(parents(i),:);
        row = floor(1+rand()*(height));
        col = floor(1+rand()*(width));
        I = reshape(mutationChildren(i,:), height, width);
        
        %Give a 50% probability of only working on the worst cell
        if rand() > 0.5,
            [z, error] = fitness(mutationChildren(i,:));
            meanError = mean(error(:));
            stdError = std(error(:));
            
            
            while true;
                    row2 = floor(1+rand()*(height));
                    col2 = floor(1+rand()*(width));
                    if ( (row2 <= height) && (col2 <= width)),
                        if error(row2,col2) < (meanError + stdError),
                            row = row2;
                            col = col2;
                            break;
                        end
                    end
            end
        end
        
        x = rand();
        if x > 0.66,
            %Flip the value of a cell
            if (I(row,col) == 1), I(row,col) = 0;
            else I(row,col) = 1;
            end
        elseif x > 0.33,
            I(row,col) = 1 - I(row,col);
            I(modNoZero(row+1,height),col) = 1 - I(modNoZero(row+1,height),col);
            I(row,modNoZero(col+1,width)) = 1 - I(row,modNoZero(col+1,width));
            I(modNoZero(row+1,height),modNoZero(col+1, width)) = 1 - I(modNoZero(row+1,height),modNoZero(col+1, width));
        else
            %Switch a cell with a neighbor
            % Try to find a cell with a neighbor that is opposite of it
            nMax = 0; %Make sure we don't loop forever
            while (nMax < 10),
                row2 = modNoZero(round(row + rand()*2-3), height);
                col2 = modNoZero(round(col + rand()*2-3), width);
                if (I(row, col) ~= I(row2,col2)),
                    temp = I(row,col);
                    I(row,col) = I(row2,col2);
                    I(row2,col2) = temp;
                    break
                end
                nMax = nMax + 1;
            end
    
        
        end
        
        mutationChildren(i,:) = reshape(I,1,[]);
    
end


end