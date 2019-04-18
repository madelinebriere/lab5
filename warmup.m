xi = [1 2 4 5 7];
yi = [3 3 -1 -5 -8];

a = -2;
b = 6;
x = linspace(0,8,1000);
y = a.*x + b;

plot(xi,yi,'x', x,y);
title('Warmup Least Squares');