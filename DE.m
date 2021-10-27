function [population,fitness,avg,minErr,bestPop,progress] = DE(population,...
    fitness,crossoverRate,bound,minErr,bestPop,funcNum,progress,settings)

%Parameters
[D, popSize] = size(population);
scaleFactor = 0.75; %Mutation scaling factor
crossoverRate = 0.75;
trial_vector = population;

%Get best
[bestfit,maxIndex] = max(fitness);
bestsol = population(:,maxIndex);

%Mutation for all solutions
for i = 1:popSize
    % Generate the donor vector using mutation
    % Select 3 vectors not equal to target
    index = i;
    while (ismember(i, index))
        index = randperm(popSize, 3);
    end
    donor = DifferenceVector(population,scaleFactor,index,bestsol);
    % Perform crossover to generate offspring
    % Recombination Binomial (uniform) crossover
    % Generate delta to choose position to switch Target & Trial vectors variables
    %delta = randi(D,D,1);
    %flag = rand(D,1) <= crossoverRate;
    %trial_vector(flag,i) = delta(flag);
    delta = randi(D);
    for j =1:D
        if(rand <= crossoverRate) || delta == j
            trial_vector(j,i) = donor(j);
        else
            trial_vector(j,i) = population(j,i);
        end
    end
end

%Evaluation and replacement
trial_vector = min(max(trial_vector, bound(1)), bound(2));
[trial_vector,fitnessGenome,avg,minErr,bestPop,progress] = calcFit(...
    trial_vector,fitness,minErr,bestPop,funcNum,progress,settings,bound);

flag = fitnessGenome > fitness;
fitness(flag) = fitnessGenome(flag);
population(:,flag) = trial_vector(:,flag);


% fitness = fitness * bestPop{3};
% fitness = 1./fitness - 1;
% 
% trial_vector = min(max(trial_vector, bound(1)), bound(2));
% fitnessGenome = cec14_func(trial_vector,funcNum) - funcNum * 100;
% flag = fitnessGenome < fitness;
% fitness(flag) = fitnessGenome(flag);
% population(:,flag) = trial_vector(:,flag);
% 
% avg = mean(fitness);
% minErr = min(fitness);
% fitness = 1 ./ (fitness + 1);
% tot = sum(fitness, 'all');
% fitness = fitness / tot;
% bestPop{3} = tot;
% bestPop{2} = max(fitness);
% bestPop{1} = population(:,maxIndex);
% 
% preTot = bestPop{3};
% fitness = fitness * preTot;
% fitness = 1./fitness - 1;