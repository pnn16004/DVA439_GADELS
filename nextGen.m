function [population,fitness,avg,minErr,bestPop,progress] = nextGen(...
    population,fitness,incest,mutationRate,crossoverRate,settings,eta,...
    minErr,bestPop,funcNum,progress,bound,popChange)

[D, popSize] = size(population);
newPopulation = zeros(D, popSize);

%Shuffle individuals
order = randperm(popSize);
fitness = fitness(order);
population = population(:,order);

index = 1;
while (index <= popChange)
    %Pick two populations randomly based on fitness
    tol = 0; %decrease incest tolerance (tol = -incest, same indv)
    while (settings(2) < 5)
        if (settings(2) == 0) %Roulette wheel scheme
            mother = RWS(population, fitness);
            father = RWS(population, fitness);
        elseif (settings(2) == 1) %Tournament selection
            mother = TS(population, fitness);
            father = TS(population, fitness);
        elseif (settings(2) == 2) %bad
            [mother,father] = NAM(population);
        end
        if (pdist([mother'; father']) >= incest + tol) %Incest prevention
            break;
        end
        tol = max(tol - 0.1 * (incest - tol), -incest);
    end
    
    if (settings(3) == 0) %Simulated binary crossover
        offspring = SBX([mother father],crossoverRate,eta(1),bound);
    elseif (settings(3) == 1) %Uniform crossover
        offspring = UC(mother,father,crossoverRate);
    elseif (settings(3) == 2) %Blend crossover
        offspring = BLX(mother,father,crossoverRate,bound);
    elseif (settings(3) == 3)
        %offspring = crossOver(mother, father, crossoverRate);
    end
    
    if (settings(4) == 0) %Single point mutation
        offspring = SPM(offspring, mutationRate, bound);
    elseif (settings(4) == 1) %Polynomial mutation
        offspring = PM(offspring,mutationRate,eta(2),bound);
    elseif (settings(4) == 2) %Uniform mutation
        offspring = UM(offspring, mutationRate);
    elseif (settings(4) == 3)
        offspring = differenceVectorGA(population,offspring,mutationRate,...
            0.77,bestPop{2},bound);
    end
    
    %Save new population
    newPopulation(:,index:index+1) = offspring;
    
    index = index + 2;
end

%Local search
if (settings(7) == 0)
    %Find the most similar ones
    n = progress(5);
    %n = max(round(n * progress(1)/progress(2)), 60);
    [~, I] = findExtreme(pdist2(bestPop{1}',newPopulation','euclidean','Smallest',1),n,progress(7));
    step = max(round(progress(6) * progress(1)/progress(2)), 0.001);
    newPopulation(:,I) = LS(newPopulation(:,1),n,step,bound);
end

if (settings(1) == 0) %Stationary
    %Overwrite old population
    population = newPopulation;
    
    %Calculate fitness
    [population,fitness,avg,minErr,bestPop,progress] = calcFit(...
        population,fitness,minErr,bestPop,funcNum,progress,settings,bound);
elseif (settings(1) == 1) %Generational
    %Best fitness among new and old, survive
    [population,newFitness,avg,minErr,bestPop,progress] = calcFit(...
        newPopulation,fitness,minErr,bestPop,funcNum,progress,settings,bound);
    
    [fitness,order] = sort([fitness newFitness],'descend');
    fitness = fitness(1:popChange);
    %Normalize fitness score again
    fitness = fitness / sum(fitness);
    
    combPopulation = [population newPopulation];
    population = combPopulation(:,order(1:popChange));
end