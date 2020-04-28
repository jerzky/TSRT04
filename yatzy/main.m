clc;
close all
[xhat, s2hat] = yatzy(10000, false);
fprintf('The mean is: %.2f and the variance: %.2f\n', xhat, s2hat);
