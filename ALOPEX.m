%Alopex local search
function [population,fitness,T,numEval] = ALS(population,fitness,...
    T,lambda,gamma,threshold,generation,funcNum)

[D, popSize] = size(population);

[bestFitness,bestIndex] = max(fitness);

alpha = -1;
while (alpha <= 0)
    alpha = min(1,rand(lambda));
end

P = 0; %Indices of individuals that received LS in prev. gen.
avgC = zeros(dimension,1);
times = 0;
loop = 1;

numEval = 0;
for i = 1:popSize
    if fitness(i) >= threshold
        P = P + 1;
        while (loop == 1)
            A = population(:,i); %A_i = X_i,g
            fitA = fitness(i);
            
            if (rand < gamma)
                index = bestIndex;
            else
                index = i; %Will make it random in the next step
            end
            while(index == i) %Randomize while equal to A
                index = floor(randomUniform(1,populationSize,1));
            end
            B = population(:,index); %Chosen individual
            fitB = fitness(index);
            
            C = zeros(1,D); %Relation of local change and change in obj. func.
            for j = 1:D
                C(j) = (A(j) - B(j)) * (fitA - fitB);
            end
            
            if times == 0
                avgC = avgC + C;
            end
            
            %Probability for a positive move
            if generation == 1
                T = sum(abs(C))/D;
                aux = exp(C/T);
                P = ones(D,1)./(1 + aux);
            else
                aux = exp(C./T);
                if mod(generation,2) == 1
                    for k = 1:D
                        P(k) = 1./(1 + aux(k));
                    end
                else
                    P = ones(D,1)./(1 + aux);
                end
            end
            
            %Direction of the move
            delta = zeros(D, 1);
            for l = 1:dimension
                r = randomUniform(0,1,1);
                if P(l) >= r
                    delta(l) = 1;
                else
                    delta(l) = -1;
                end
            end
            
            Q = A + delta .* abs(A - B) * alpha;
            Q = min(max(Q, bound(1)), bound(2));
            
            fitQ = cec14_func(Q, funcNum);
            numEval = numEval + 1;
            
            if fitQ < fitA
                population(:,i) = Q;
                fitness(i) = fitQ;
                if fitA < bestFitness
                    bestFitness = fitQ;
                    bestIndex = i;
                    loop = 1;
                else
                    loop = 0;
                end
            else
                loop = 0;
            end
            times = times + 1;
        end
    end
end

if mod(generations,2) == 1
    T = avgC ./ P;
else
    T = 1/D * 1/abs(P) * sum(abs(avgC));
end