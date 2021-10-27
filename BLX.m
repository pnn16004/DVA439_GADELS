function offspring = BLX(mother, father, crossoverRate, bound)

offspring = [mother father];

r = rand;
if (r < crossoverRate) %Chance to crossover
    Cmax = max([mother'; father']);
    Cmin = min([mother'; father']);
    I = Cmax - Cmin;
    %alpha = rand(size(mother));
    alpha = 0.1;
    temp = Cmax + I .* alpha;
    upper = min(max(temp,bound(1)), bound(2));
    temp = Cmin - I .* alpha;
    lower = min(max(temp,bound(1)), bound(2));
    for i = 1:2
        offspring(:,i) = lower + (upper+upper) .* rand;
    end
end