function geneticFringeMaker
    close all;
    
    pitch = 120;
    nIterations = 3*floor(3000+3000*log(pitch - 15));
    
    [x,fval,exitflag,output,population,score] = genetic_algorithm(1, 2, 0.7, nIterations, nIterations, 1e-20, pitch);
    I = reshape(x, [], pitch);
    imwrite(I, sprintf('genetic_fringes/%d.png', pitch));
    print('-dpng', sprintf('genetic_fringes/%d_graph.png', pitch));
       
    %WRITE GENETIC FRINGE
    I_genetic = zeros(768, 1024);
    I_genetic_1 = uint8(I);
    
    for k = 1:3,
        I = circshift(I_genetic_1, [0 pitch*k/3]);
        [m, n] = size(I_genetic);
        I_genetic(1:m, 1:n) = I(modNoZero(1:m, 24), modNoZero(1:n, pitch));
        imwrite(I_genetic, sprintf('genetic_fringes/fringe/%d_genetic_%d.png', pitch, k));
    end
end