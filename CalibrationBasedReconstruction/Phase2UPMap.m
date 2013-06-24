function [ uPMap ] = Phase2UPMap(phase, Phi0, pitch)

uPMap = 1.0 + ( ( phase - Phi0) ./ ( ( 2.0 .* pi ) ./ pitch ) );

end
