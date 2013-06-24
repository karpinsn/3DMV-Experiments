function a = modNoZero(a, b)

a = mod(a, b);
a(a == 0) = b;

end