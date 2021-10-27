%Find the n largest number in a vector.
%mode = 1, max. mode = 2, min.
function [M, I] = findExtreme(A, n, mode)

if mode == 1
    func = @max;
    empty = -Inf;
elseif mode == 2
    func = @min;
    empty = Inf;
end

M = zeros(1,n);
I = zeros(1,n);
for i = 1:n
    [M(i), I(i)] = func(A);
    A(I(i)) = empty;
end
