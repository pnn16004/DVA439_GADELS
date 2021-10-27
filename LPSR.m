%Linear Population Size Reduction (LPSR)
function [population,fitness,change] = LPSR(population,fitness,N,N_init,N_min,...
    NFE,MAX_NFE)
%N is the current population size
%N_init is the starting population size
%N_min is the smallest possible value where evolutionary operators work
%NFE is the current number of fitness evaluations
%MAX_NFE is the maximum number of fitness evaluations

N_next = round((N_min-N_init)/MAX_NFE * NFE + N_init);

if N > N_next
    change = N - N_next + 1;
    
    %Find least fittest N - N_next and delete
%     [~, I] = findExtreme(fitness, change, 2);
%     fitness(I) = [];
%     population(:,I) = [];
%     fitness = fitness / sum(fitness);
    
%     %Needs it sorted
%     [fitness,order] = sort(fitness,'descend');
%     population(:,order);
%     
%     lowest = N - N_next + 1;
%
%     %Delete worst N-N_next
%     population(:,end-lowest:end) = [];
%     fitness = fitness(1:size(population,2));
%     %Normalize fitness score again
%     fitness = fitness * bestPop{3};
%     fitness = fitness / sum(fitness);
%     %Shuffle
%     order = randperm(length(fitness));
%     fitness = fitness(order);
%     population = population(:,order);
else
    change = 0;
end