function offspring = UC(mother, father, crossoverRate)

offspring = [mother father];

r = rand(1);
if (r < crossoverRate) %Chance to crossover
    %alpha = rand(size(mother));
    gamma = 0.1;
    alpha = unifrnd(-gamma, 1+gamma, size(mother));
    
    offspring(:,1) = alpha .* mother + (1-alpha) .* father;
    offspring(:,2) = alpha .* father + (1-alpha) .* mother;
end