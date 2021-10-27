function [population,fitness,avg,minErr,bestPop,progress] = calcFit(...
    population,fitness,minErr,bestPop,funcNum,progress,settings,bound)

if (settings(6) == 1)
    if (progress(1) <= 0)
        [~, I] = findExtreme(fitness, progress(4), 1);
        bestPops = population(:,I); %Save only the best
        population = bound(1) + (bound(2)+bound(2)) * rand(size(population));
        population(:,I) = bestPops; %Put best back
        progress(1) = progress(2); %Reset value
    end
elseif (settings(6) == 0)
    if (progress(1) <= 0) %Too long without a better population
        [~, I] = findExtreme(fitness, progress(4), 1);
        bestPops = population(:,I); %Save only the best
        %Vigorous mutation
        for i = 1:size(population,2)
            population(:,i) = mutate(population(:,i), progress(3), bound);
        end
        population(:,I) = bestPops; %Put best back
        progress(1) = progress(2); %Reset value
    end
end

err = cec14_func(population,funcNum) - funcNum * 100; %Benchmark
[e, index] = min(err);
avg = mean(err);

%Best
if (e < minErr) %Save best
    if (e * 1 > minErr) %For evolution
        progress(1) = progress(1) - 1;
    elseif (progress(1) < progress(2))
        progress(1) = progress(1) + 1;
    end
    minErr = e;
    bestPop{1} = population(:,index);
else
    progress(1) = progress(1) - 1;
end

%fitness = 1 ./ (err.^6 + 1);
fitness = 1 ./ (err + 1);

%Normalize fitness score
if (settings(8) == 1 && bestPop{3} ~= 0)
    tot = bestPop{3}; %Relative fitness
else
    tot = sum(fitness, 'all');
end
%tot = sum(fitness, 'all');
fitness = fitness / tot;

%Best
bestPop{2} = fitness(index);
bestPop{3} = tot;