function rHat = FireSonar(r)
rHat = zeros(1,30);

%corrupt
noise = .01*randn(1,30);
%r = r+noise; %zero mean .01 std dev gausian noise added to ground truth

%multipath error for 25 percent of values
for i=1:length(r)
    if(rand<=0)
        mp_error = r(i)*(.2+(.3)*rand());%multipath error between 20-50%
        rHat(i) = r(i)+ mp_error;
    else
        rHat(i) = r(i);
    end
    
    if(r(i)>10 || r(i)<0)
        rHat(i) = -1;
    end
end
    
