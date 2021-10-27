%Arithmetic Recombination
function [neworder] = crossOver(orderA, orderB, crossoverRate)
neworder = orderA;

r = rand(1);
if (r < crossoverRate) %Chance to crossover
    neworder = (orderA + orderB) ./ 2;
end