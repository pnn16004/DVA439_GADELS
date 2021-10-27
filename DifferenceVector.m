function donor = DifferenceVector(population,scaleFactor,index,bestsol)
% % Donor Vector is created as V = X(r1) + F(scaleFactor)(X(r2) - X(r3))
%     X1 = population(index(1),:);
%     X2 = population(index(2),:);
%     X3 = population(index(3),:);
%     
%    donor = X1 + scaleFactor*(X2 - X3);
% Donor Vector is created as V = X(n) + F(scaleFactor)(X(r2) - X(r3))
% X(n) = Best solution
%     X1 = population(:,index(1));
    X2 = population(:,index(2));
    X3 = population(:,index(3));
    
   donor = bestsol + scaleFactor*(X2 - X3);
end

