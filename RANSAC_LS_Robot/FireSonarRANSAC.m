function dataHat = FireSonarRANSAC(X,Y)
xhat = zeros(1,length(X));
yhat = zeros(1,length(Y));
%corrupt
noise = .01*randn(1,length(X));
xhat = X+noise; %zero mean .01 std dev gausian noise added to ground truth
yhat = Y+noise;
%multipath error for 25 percent of values
% for i=1:length(X)
%     if(rand<=.25)
%         mp_errorx = xhat(i)*(.2+(.3)*rand());%multipath error between 20-50%
%         xhat(i) = xhat(i)+ mp_errorx;
%         mp_errory = yhat(i)*(.2+(.3)*rand());%multipath error between 20-50%
%         yhat(i) = yhat(i)+ mp_errory;
%     end
%     
% end
    
dataHat = [xhat;yhat];