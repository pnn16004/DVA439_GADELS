%Alopex local search
function [population,fitness,T,numEval] = ALS(population,fitness,...
    T,lambda,gamma,threshold,funcNum,bound,bestPop)

[D, N] = size(population);

[bestFitness,bestIndex] = max(fitness);

alpha = -1; %Scaling factor
while (alpha <= 0)
   alpha = min(1,normpdf(rand,0,lambda));
end

C = zeros(D,N); %Relation of local change and change in obj. func.
PS = 0; %Indices of individuals that received LS
count = 0; %Keeps count of number of indices

numEval = 0;
for i = 1:N
    if fitness(i) >= threshold
        A = population(:,i); %Individual with fitness above threshold
        fitA = fitness(i);
        
        if (rand < gamma)
            index = bestIndex;
        else
            index = i; %Will make it random in the next step
        end
        while(index == i) %Randomize while equal to A
            index = randperm(N,1);
        end
        B = population(:,index); %Chosen individual
        fitB = fitness(index);
        
        %C - Relation of local change and change in obj. func.
        %P = zeros(D,N); %Probability for a positive move
        %delta = zeros(D,N); %Direction of the move
        %Q = zeros(D,1); %Trial solution
%         for j = 1:D
%             C(j,i) = (A(j) - B(j)) * (fitA - fitB);
%             P(j,i) = 1/(1 + exp(C(j,i)/T));
%             if P(j,i) >= rand
%                 delta(j,i) = 1;
%             else
%                 delta(j,i) = -1;
%             end
%             Q(j) = A(j) + delta(j,i) * abs(A(j) - B(j)) * alpha;
%         end
        C(:,i) = (A - B) * (fitA - fitB);
        P = 1./(1 + exp(C(:,i)/T));
        delta = (P >= rand(D,1));
        Q = A + delta .* abs(A - B) * alpha;      
        Q = min(max(Q, bound(1)), bound(2));
        
        errQ = cec14_func(Q, funcNum);
        fitQ = 1/(errQ + 1);
        fitQ = fitQ/bestPop{3}; %Normalize
        
        if fitQ > fitA %Replace if the new solution is better
            population(:,i) = Q;
            fitness(i) = fitQ;
            
            count = count + 1; %Number of indices
            PS(count) = i; %Index of individual that received LS
            
            if fitA < bestFitness %Update if best in whole population
                bestFitness = fitQ;
                bestIndex = i;
            end
        end
        numEval = numEval + 1;
    end
end

%Calculate evolving temperature
if count > 0 %If any individuals received LS
    avgC = 0;
    for in = 1:count %For each index
        i = PS(count); %Indices
        for j = 1:D
            avgC = avgC + abs(C(j,i));
        end
    end
    %|PS| == length(PS)?
    T = 1/D * 1/length(PS) * avgC; %Mean correlation
else
    T = 1; %Initial value
end