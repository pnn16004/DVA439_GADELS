function Y = LS(X,n,step,bound)
% X = vector of current best solution
% n = no. of chromosomes selected
%=====================================================
L = length(X);
A = zeros(1,n);
B = X * ones(1,n); %Make 2*dim copies of X
%B = min(max([X+step*rand(L,n/2) X-step*rand(L,n/2)],bound(1)),bound(2));
for i = 1:L
    %Take i:th entry of X and randomly step it according to stepsize
    A(i,2*i-1) = step*rand; %Save in every uneven number
    
    %Step in other direction
    A(i,2*i) = -step*rand; %Save in every even number
end
C = min(max(B + A, bound(1)), bound(2));
Y = C(:,randperm(length(B), n)); %Take n random chromosomes from C