function [ Irec ] = InterpolateSample( I, px, py, px2, py2 )
%INTERPOLATESAMPLE Summary of this function goes here
%   Detailed explanation goes here

[nr,nc] = size(I);
Irec = 255*ones(nr,nc);

px_0 = floor(px2);
py_0 = floor(py2);

good_points = find((px_0 >= 0) & (px_0 <= (nc-2)) & (py_0 >= 0) & (py_0 <= (nr-2)));

px2 = px2(good_points);
py2 = py2(good_points);
px_0 = px_0(good_points);
py_0 = py_0(good_points);

alpha_x = px2 - px_0;
alpha_y = py2 - py_0;

a1 = (1 - alpha_y).*(1 - alpha_x);
a2 = (1 - alpha_y).*alpha_x;
a3 = alpha_y .* (1 - alpha_x);
a4 = alpha_y .* alpha_x;

ind_lu = px_0 * nr + py_0 + 1;
ind_ru = (px_0 + 1) * nr + py_0 + 1;
ind_ld = px_0 * nr + (py_0 + 1) + 1;
ind_rd = (px_0 + 1) * nr + (py_0 + 1) + 1;

ind_new = (px(good_points)-1)*nr + py(good_points);
Irec(ind_new) = a1 .* I(ind_lu) + a2 .* I(ind_ru) + a3 .* I(ind_ld) + a4 .* I(ind_rd);

end

