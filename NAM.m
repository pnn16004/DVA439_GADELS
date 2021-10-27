%NAM
function [mother, father] = NAM(population)

mother = population(:,randi(2000)); %random mother
[~,I] = max(pdist2(mother',population')); %find furthest from mother
father = population(:,I); %make it the father