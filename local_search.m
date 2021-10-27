function Y = local_search(X,n,step,bound)
% X = vector of current best solution
% n = no. of chromosomes selected
%=====================================================
UB = bound(2);
LB = bound(1);
L = length(X);
A = X * ones(1,2*L); %Make 2*dim copies of X
for i = 1:L
    %Take i:th entry of X and randomly step it according to stepsize
    L1 = X(i) + step*rand;
    %Check for boundaries
    if L1 > UB
        L1 = UB;
    end
    if L1 < LB
        L1 = LB;
    end
    A(i,2*i-1) = L1; %Save in every uneven number
    
    %Step in other direction
    L2 = X(i) - step*rand;
    %Boundaries
    if L2 > UB
        L2 = UB;
    end
    if L2 < LB
        L2 = LB;
    end
    A(i,2*i) = L2; %Save in every even number
end
Y = A(:,randperm(length(A), n)); %Take n random chromosomes from A