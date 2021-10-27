%Small eta gives more diversity and vice versa
function offspring = SBX(parents,pX,etaC,bound)

% determine size of the parents and decision variables
[D, ~] = size(parents);

offspring = parents;

%To crossover or not
randNum = rand(D,1);
crossover = (randNum <= pX);

u = rand(D,1); %Decide which beta value
betaU = (u > 0.5); %0-low, 1-high

%Calculate beta values based on u
betaVal = zeros(D,1);
betaVal(~betaU) = (2*u(~betaU)).^(1/(etaC+1));
betaVal(betaU) = (1./(2*(1-u(betaU)))).^(1/(etaC+1));

%Calculate offspring based on beta and if crossovered or not
offspring(:,1) = 0.5*(((1 + betaVal).*parents(:,1)) + ...
    (1-betaVal).*parents(:,2)) .* crossover + parents(:,1) .* ~crossover;
offspring(:,2) = 0.5*(((1 - betaVal).*parents(:,1)) + ...
    (1+betaVal).*parents(:,2)) .* crossover + parents(:,1) .* ~crossover;

%Check bounds
offspring(:,1) = min(max(offspring(:,1),bound(1)), bound(2));
offspring(:,2) = min(max(offspring(:,2),bound(1)), bound(2));