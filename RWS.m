%Roulette wheel scheme
function [parent] = RWS(population, fitness)
index = 1; %Which population
r = rand * sum(fitness); %Random numb between 0 and fitness sum
%Higher fitness score gives higher prob to get picked
while (r > 0)
    r = r - fitness(index); %Subtract until less than 0
    index = index + 1;
end
index = index - 1; %The one that got it under 0 should be picked
parent = population(:,index); %Send back chosen population