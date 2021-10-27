function [offspring] = mutate(parents, mutationRate, bound)

[D, p] = size(parents);

%To mutate or not
randNum = rand(D,p);
mutate = (randNum < mutationRate);

offspring = (bound(1)+(bound(2)+bound(2))*rand(D,p)).*mutate...
    + parents.*(~mutate);