%LS good: 7,8,9,10,11,12,13,14, (cap)23,24,25,26,27,28,29,30
%LS ok: 5,6,15,16,18,19,20,22
%GA good: 11,12,13,14,15,16,19,20,22, (cap)23,24,25,26,27,28,29,30
%GA ok: 1,3,4,5,6,7,8,9,17,18
function [minErr,bestPop] = AGA(popSize,D,funcNum,progress,settings,...
    pALS)
if nargin < 1
    popSize = 1000;
    D = 30; %2, 10, 30, 50, 100
    funcNum = 30; %1-30
    %           Rs  NR  mR  e n  ss m
    %progress = [100 50 0.4 5 60 60 1];
    progress = [300 100 0.5 1 60 60 1];
    %           R S C M P E L T F
    %settings = [1 1 0 0 9 9 1 9 2]; %GADEALS Gen,TS,SBX,SPM,-,-,ALS,-,taken
    settings = [1 1 0 0 1 1 1 0 1]; %GADEALS Gen,TS,SBX,SPM,P1,E1,ALS,1,flip
    %settings = [1 1 0 0 9 9 0 1 0]; %GADELS Gen,TS,SBX,SPM,-,-,LS,1,flip
    %settings = [9 9 9 9 0 9 1 1 9]; %DEALS -,-,-,-,P0,-,ALS,1,-
    %settings = [1 1 0 0 9 9 9 1 0]; %GADE Gen,TS,SBX,SPM,-,-,-,1,flip
    %settings = [9 9 9 9 1 0 9 1 9]; %DE -,-,-,-,P0,E0,-,1,-
    %settings = [0 1 0 1 9 9 1 0 9]; %GAALS Stat,TS,SBX,PM,-,-,ALS,0,-
    %settings = [1 1 0 0 0 9 1 0 9]; %GAALS Gen,TS,SBX,SPM,P0,-,ALS,0,- |
    %settings = [0 1 0 0 0 1 0 0 9]; %GALS Stat,TS,SBX,SPM,P0,E1,LS,0,-
    %settings = [1 1 0 1 0 1 9 0 9]; %GA Gen,TS,SBX,PM,P0,E1,-,0,-
    %settings = [0 0 0 0 0 0 9 0 9]; %GA Stat,RWS,SBX,SPM,P0,E0,-,0,-
    pALS = [4 1 0.5]; % frequency, length, gamma
end
if settings(8) == 1
    popSize = 100;
end

incest = 0.1; %0.03
crossoverRange = 0.9; %0.9
mutationRange = 0.4; %0.5
eta = [1 75]; %SBX: 1-10, PM: 20-100
%popShrink = [100 0.95]; %- setting(6)
popShrink = [20 0.99];
taken = round(popSize * 0.5);
N_min = 10; %- setting(6)

%mex cec14_func.cpp -DWINDOWS
%rng(2, 'twister')
%rng('default')
%rand('state', sum(100*clock))

% Initialize variables %
bound = [-100 100];
minErr = Inf;
bestPop{3} = 0;
index = 0;
popChange = popSize;
maxEvals = 10000 * D;
%mutationFunc = @(x) [exp(-x) 1/(1+x)];
turn = 0;
T = 1; %Initial temperature for ALS

% Setup %
%Population of randomized, D size vectors
%Search range within bounds^D
population = bound(1) + (bound(2)+bound(2)) * rand(D, popSize);

%Give each population a normalized fitness score
[population,fitness,~,minErr,bestPop,progress] =...
    calcFit(population,[],minErr,bestPop,funcNum,progress,settings,bound);

evals = popSize;

%Plot
figure(1);
xlabel("Generation");
ylabel("Objective function value");
title("Population evolution");
g = animatedline('Color', 'y', 'Linewidth', 1);
h = animatedline('Color', 'g', 'Linewidth', 1.5);
legend('Average', 'Minimum')

while (evals + popChange <= maxEvals && minErr > 10^(-8))
    index = index + 1;
    
    x = (max(fitness) - min(fitness)) * popChange;
    if (settings(4) == 0)
        mutationRate = exp(-x);
        %mutationRate = 1 / (1+x);
    else
        %mutationRate = 1 / (1+x) * (1-mutationRange);
        mutationRate = exp(-x) * (1-mutationRange);
    end
    crossoverRate = crossoverRange + (1 - 1 / (1+x)) * (1-crossoverRange);
    
    %eta(1) = 10 * progress(1)/progress(2);
    pALS(2) = abs(ceil(10 * (1 - popSize/popChange)));
    
    if settings(9) == 0 %Run for a number of generations
        if turn == 0
            if mod(index,5) == 0
                settings(8) = ~settings(8);
                turn = 1;
            end
        elseif turn == 1
            if mod(index,10) == 0
                settings(8) = ~settings(8);
                turn = 0;
            end
        end
    elseif settings(9) == 1 %Switch each generation
        if turn == 0
            settings(8) = ~settings(8);
            turn = 1;
        elseif turn == 1
            settings(8) = ~settings(8);
            turn = 0;
        end
    elseif settings(9) == 2 %DE on percentage of population
        if turn == 0
            settings(8) = 0;
            turn = 1;
            if size(population,2) <= taken
                oldPop(:,pos) = population;
                oldFit(:,pos) = fitness;
                population = oldPop;
                fitness = oldFit;
            end
        elseif turn == 1
            settings(8) = 1;
            turn = 0;
            [~,pos] = findExtreme(fitness, taken, 1);
            oldPop = population;
            oldFit = fitness;
            population = population(:,pos);
            fitness = fitness(:,pos);
            evals = evals - popChange + length(pos); %Since it gets smaller
        end
    end
    
    if settings(8) == 0 %GA
        [population,fitness,avg,minErr,bestPop,progress] = nextGen(...
            population,fitness,incest,mutationRate,crossoverRate,settings,...
            eta,minErr,bestPop,funcNum,progress,bound,popChange);
    elseif settings(8) == 1 %DE
        [population,fitness,avg,minErr,bestPop,progress] = DE(population,...
            fitness,crossoverRate,bound,minErr,bestPop,funcNum,progress,settings);
    end
    evals = evals + popChange;
    
    if (settings(7) == 1) %Alopex local search
        if (mod(index,pALS(1)) == 0)
            for i = 1:pALS(2)
                if evals + popChange >= maxEvals
                    break;
                end
                threshold = bestPop{2};
                %threshold = sum(fitness)/popSize; %average
                threshold = (threshold+bestPop{2})/2;
                lambda = 0.5 - evals/maxEvals * 0.5 + 10^-2;
                [population,fitness,T,numEval] = ALS(population,fitness,....
                    T,lambda,pALS(3),threshold,funcNum,bound,bestPop);
                evals = evals + numEval;
            end
        end
    end
    
    %Shrink population over time
    if (settings(5) == 0)
        if (popChange >= popSize * 0.4) %If still big enough
            if (mod(index,popShrink(1)+1) == popShrink(1)) %Which gen
                popChange = ceil(popChange * popShrink(2)); %Shrink
                popChange = floor(popChange * popShrink(2)); %Shrink
            end
        end
    elseif (settings(5) == 1) %LPSR from L-SHADE
        [population,fitness,change] = LPSR(population,fitness,popChange,popSize,...
            N_min,evals,maxEvals);
        %popChange = size(population, 2);
        popChange = popChange - change;
    end
    
    figure(1)
    addpoints(g,index,avg);
    addpoints(h,index,minErr);
    ylim([minErr*0.5 minErr*2])
    drawnow
end

if minErr < 10^(-8)
    minErr = 0;
end