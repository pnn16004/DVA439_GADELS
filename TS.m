function parent = TS(population, fitness)
[~, popSize] = size(population);

%20% of the population rounded to the closest power of 2
k = max(pow2(round(log2(popSize * 0.2))), 2);

%Get k random unique individuals
selection = randperm(popSize,k);

%Higher fitness gets picked
[~,index] = max(fitness(selection));
parent = population(:,selection(index));