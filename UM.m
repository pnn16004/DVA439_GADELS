%mu0.02, sigma0.1
function mutation = UM(offspring, mutationRate)

sigma = 0.1;

flag =(rand(size(offspring)) < mutationRate);

mutation = offspring;
r = rand(size(offspring));
mutation(flag) = offspring(flag) + sigma * r(flag);