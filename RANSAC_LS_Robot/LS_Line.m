function [a_r,b_r] = LS_Line(rho,alpha)
counter = 1;
%display(alpha);
for i=1:length(rho)
    if(rho(i)~=-1)
        dx = cos(alpha(i));
        dy = sin(alpha(i));
        X(counter,:) = [1,rho(i)*dx];
        Y(counter) = rho(i)*dy;
        counter = counter+1;
    end
end

B = X\Y';

a_r = B(2);
b_r = B(1); 