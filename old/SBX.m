%Small eta gives more diversity and vice versa
function offspring = SBX(parents,pX,etaC,bound)

% determine size of the parents and decision variables
[D, ~] = size(parents);

offspring = parents;

% generate random number to decide crossover
randNum = rand;
if randNum < pX
    % iterate both decision variables
    for i = 1:D
        % generate random number(u)to determine the beta value
        u = rand;
        if u <= 0.5
            beta_value = (2*u)^(1/(etaC+1));
        else
            beta_value = (1/(2*(1-u)))^(1/(etaC+1));
        end
        % Generating the offsprings
        offspring(i,1) = 0.5*(((1 + beta_value)*parents(i,1)) + ...
            (1-beta_value)*parents(i,2));
        offspring(i,2) = 0.5*(((1 - beta_value)*parents(i,1)) + ...
            (1+beta_value)*parents(i,2));
    end
    % Check for bounds
    offspring(:,1) = min(max(offspring(:,1),bound(1)), bound(2));
    offspring(:,2) = min(max(offspring(:,2),bound(1)), bound(2));
end
end