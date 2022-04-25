%% simple sinusoidal example

Fsig = 150;
Fs = 10*Fsig;
Ts = 1/Fs;
N = 100;
time = (0:N-1)*Ts;
y = sin(2*pi*Fsig*time);
Y = fft(y,N);

P2 = abs(Y)/N;
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
freq_axis = Fs/N * (0:(N/2));

disp(['Signal frequency: ',num2str(Fsig)]);

figure(1); clf;
plot(time, y, '-x');
xlabel('time in s');
ylabel('amplitude');

figure(2); clf;
% freq_axis = freq_sin*(0:Nt-1)/Nt;
%Y = Y(N/2+1:end);
plot(freq_axis,P1);
xlabel('frequency in Hz');
ylabel('amplitude');

%% Matlab example

Fs = 400;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 400;             % Length of signal
t = (0:L-1)*T;        % Time vector

% Form a signal containing a 50 Hz sinusoid of amplitude 0.7 and a 120 Hz sinusoid of amplitude 1.
% S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
S = sin(2*pi*50*t)+sin(2*pi*120*t);

% Corrupt the signal with zero-mean white noise with a variance of 4.
% X = S + 2*randn(size(t));
X = S;

% Plot the noisy signal in the time domain. It is difficult to identify the frequency components by looking at the signal X(t).
figure(1);
plot(1000*t(1:50),X(1:50))
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('X(t)')

Y = fft(X);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
figure(2);
plot(f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% test fftmod
Fsig = 50;
Fs = 10*Fsig;
Ts = 1/Fs;
N = 100;
time = (0:N-1)*Ts;
y = sin(2*pi*Fsig*time);
zp = 1000;

[signal_FD,freq_axis] = fftmod(y,zp,Fs);
plot(freq_axis,signal_FD);

%% transform Gauß pulse
nts = 1500;
dt = 2.1e-11;
Fs = 1/dt;
time = 0:dt:(nts*dt);
fmax = 10e9;
zp = 0;

% Anregungssignal (verteilter eingeprägter Strom von Außen- zu Innenleiter)
% value
omega = 2*pi*fmax;
sigma = sqrt(2*log(100)/omega^2);
tm = time - sqrt(2*sigma^2 * log(1000));
gauss_pulse = exp(-tm.^2 / (2*sigma^2));

figure(1);
plot(time, gauss_pulse);

figure(2);
[signal_FD,freq_axis] = fftmod(gauss_pulse,zp,Fs);
plot(freq_axis,signal_FD); 