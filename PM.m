%etaM between [20, 100]
function offspring = PM(parents,mutationRate,etaM,bound)

[D,p] = size(parents);

%To mutate or not
randNum = rand(D,p);
mutate = (randNum < mutationRate);

u = rand(D,p); %Decide which delta value
deltaU = (u > 0.5); %0-low, 1-high

%Calculate delta values based on u
deltaVal = zeros(D,p);
deltaVal(~deltaU) = (2*u(~deltaU)).^(1/(1+etaM)) - 1; %delta left
deltaVal(deltaU) = 1 - (2*(1-u(deltaU))).^(1/(1+etaM)); %delta right

%Calculate offspring based on delta and if crossovered or not
offspring(~deltaU(:,1),:) = parents(~deltaU(:,1),:) + deltaVal(~deltaU(:,1),:) .*...
    (parents(~deltaU(:,1),:)-bound(1)) .* ~mutate(~deltaU(:,1),:); %lower bound
offspring(deltaU(:,1),:) = parents(deltaU(:,1),:) + deltaVal(deltaU(:,1),:) .*...
    (parents(deltaU(:,1),:)-bound(1)) .* ~mutate(deltaU(:,1),:); %upper bound

offspring(~deltaU(:,2),:) = parents(~deltaU(:,2),:) + deltaVal(~deltaU(:,2),:) .*...
    (parents(~deltaU(:,2),:)-bound(2)) .* ~mutate(~deltaU(:,2),:); %lower bound
offspring(deltaU(:,2),:) = parents(deltaU(:,2),:) + deltaVal(deltaU(:,2),:) .*...
    (parents(deltaU(:,2),:)-bound(1)) .* ~mutate(deltaU(:,2),:); %upper bound