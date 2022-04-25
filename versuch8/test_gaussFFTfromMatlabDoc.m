Fs = 100;           % Sampling frequency
t = -0.5:1/Fs:0.5;  % Time vector
L = length(t);      % Signal length

sigma = 0.1;
X = 1/(4*sigma*sqrt(2*pi))*(exp(-t.^2/(2*sigma^2)));

figure(1); clf;
plot(t,X);
title('Gaussian Pulse in Time Domain');
xlabel('Time (t)');
ylabel('X(t)');

n = 2^nextpow2(L);
Y = fft(X,n);

f = 0:Fs/n:(Fs/2);
P = abs(Y/n);

figure(2); clf;
plot(f,P(1:n/2+1));
title('Gaussian Pulse in Frequency Domain');
xlabel('Frequency (f)');
ylabel('|P(f)|');