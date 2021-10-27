function offspring = differenceVectorGA(population,offspring,pM,...
    scaleFactor,bestsol,bound)

[D, popSize] = size(population);

if rand > pM
    for i = 1:size(offspring,2)
        index = i;
        while (ismember(i, index))
            index = randperm(popSize, 3);
        end
        offspring(:,i) = DifferenceVector(population,scaleFactor,index,bestsol);
        offspring(:,i) = min(max(offspring(:,1),bound(1)), bound(2));
        
%         donor = DifferenceVector(population,scaleFactor,index,bestsol);
%         delta = randi(D);
%         for j =1:D
%             if(rand <= pM) || delta == j
%                 offspring(j,i) = donor(j);
%             end
%         end
    end
end