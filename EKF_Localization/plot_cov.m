function h = plot_cov(mu,P)
Sigma = P;
p = .997; %empirical rule for 3 std devs
s = -2 * log(1 - p);

[V, D] = eig(Sigma * s);

t = linspace(0, 2 * pi);
a = (V * sqrt(D)) * [cos(t(:))'; sin(t(:))'];

h = plot(a(1, :) + mu(1), a(2, :) + mu(2));