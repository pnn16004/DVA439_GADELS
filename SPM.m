%Single Point Mutation - Flip one gene to a random number
function [offspring] = SPM(parents, mutationRate, bound)

[D, ~] = size(parents);

offspring = parents;

r = rand(1);
if (r < mutationRate) %Chance to mutate
    offspring(randperm(D,1),1) = bound(1) + (bound(2)+bound(2)) * rand(1);
end
r = rand(1);
if (r < mutationRate) %Chance to mutate
    offspring(randperm(D,1),2) = bound(1) + (bound(2)+bound(2)) * rand(1);
end

% %To mutate or not
% offspring = parents;
% randNum = rand(p,p);
% mutate = (randNum < mutationRate);
% flag = [randperm(D,p)' randperm(D,p)'];
% offspring(flag(:,1),:) = (bound(1)+(bound(2)+bound(2))*...
%     rand(p,1)) .* mutate(:,1) + parents(~mutate(:,1));

% offspring = parents;
% for i = 1:p
%     r = rand(1);
%     if (r < mutationRate) %Chance to mutate
%         offspring(randperm(D,1)) = bound(1) + (bound(2)+bound(2)) * rand(1);
%     end
% end