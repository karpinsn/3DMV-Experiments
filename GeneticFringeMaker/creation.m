function x = creation(NVARS,FitnessFcn,options)

global gaussianWidth H width height source

source1 = reshape(source, height, []);

rows = 1:3*height;
cols = 1:3*width;


x = floydSteinbergDither(source1);
x = reshape(x, 1, []);


x2 = floydSteinbergDither(source1')';
x(2,:) = x2(:);

x3 = fliplr(floydSteinbergDither(fliplr(source1)));
x(3,:) = x3(:);

x4 = fliplr(floydSteinbergDither(fliplr(source1')))';
x(4,:) = x4(:);

for i = 5:20,
    x(i,:) = x(1,:);
end

source2(rows,cols) = source1(modNoZero(rows,height), modNoZero(cols,width));
source2 = floydSteinbergDither(source2);
source2 = source2(height+1:2*height, width+1:2*width);
x(5,:) = reshape(source2, 1, []);

end