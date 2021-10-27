% The purpose of selection operatior is to identify good (usually
% above-average) solutions in the population, it is because we can identify
% bad solutions and those solutions will be deleted from the mating pool
% and we can identify good solutions and so we can make multiple copies of
% it. Binary Tournament Selection Operator is similar to playing a
% tournament among the teams. binary stands for tournament between two
% teams, the outcome will be 'win', 'tie' or 'lose'. The process is
% performed by picking 2 solutions randomly and chose the one that has
% better value.
function matingPool = BTS(fitness)
[~, fitSize] = size(fitness);
% Each solutions will participate twice in the tournament
% matingPool is the vector to store the index of parent solutions
matingPool = NaN(fitSize,1);
% randomly shuffle the index of the population members, stores in index
index = randperm(fitSize);

% loop until (populationSize - 1)
% assuming we have a population size of 6 with shuffled index of 3,1,6,5,4,2
% so the fixture will be 3v1, 1v6, 6v5, 5v4, 4v2, we can see that when it
% gets to last item, atleast the 2nd item untill the item(last-1) has played
% twice, to ensure that 1st and last item plays twice, we schedule the
% fixture outside the loop
for a = 1 : (fitSize - 1)
    % select one pair of population member for tournament fixture
    fixture = [index(a) index(a+1)];
    % We get there fitness
    fitDuel = fitness(fixture);
    % ind collects the index of the winner, we ignore the fitness
    [~,ind] = max(fitDuel);
    % we store the index the index of the winner
    matingPool(a) = fixture(ind);
end

% fixture for the first and the last item
fixture = [ index(fitSize) index(1) ];
fitDuel = fitness(fixture);
[~,ind] = max(fitDuel);
matingPool(fitSize) = fixture(ind);