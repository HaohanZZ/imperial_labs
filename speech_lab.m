% x : input samples
% p : order of LPC
% A : prediction error filter, (A = [1; -a])
% G : rms prediction error
% r : autocorrelation coefficients
% a : predictor coefficients

clc;
clear;
p = 12;
load('s5.mat');
%signal 
x = s5;
% sounds;
soundsc(x);

windowSize = 320; 
x_w = (1/windowSize)*ones(1,windowSize);

% x_SH,x_AA
x_SH = x(15500:16750);
x_AA = x(16750:18800);
soundsc(x_SH);
soundsc(x_AA);

%Apply hamming windows
x_SH = enframe(x_SH,hamming(320),160);
x_AA = enframe(x_AA,hamming(320),160);

%% the phoneme signal x_SH
[A_SH, G_SH, r_SH, a_SH] = autolpc(x_SH, p);

%frequency response of 
% vocal tract filter H(z)
b_SH = G_SH;
a_SH = A_SH;
[hv_SH , wv_SH] = freqz(b_SH,a_SH,"whole");
figure(1)
plot(wv_SH/pi,20*log10(abs(hv_SH)));
ax = gca;
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
hold

%prediction error filter
[hp_SH , wp_SH] = freqz(a_SH,1,"whole");
plot(wp_SH/pi,20*log10(abs(hp_SH)));
legend("vocal tract filter","prediction error filter")
title("Frequency responses of the phoneme SH")

%% the phoneme signal x_AA
[A_AA, G_AA, r_AA, a_AA] = autolpc(x_AA, p);
% est_SH = filter([0 - A_SH(2:end)],1,x_SH);
% err_SH = x_SH - est_SH;

%frequency response of 
% vocal tract filter H(z)
b_AA = G_AA;
a_AA = A_AA;
[hv_AA , wv_AA] = freqz(b_AA,a_AA,"whole");
figure(2)
plot(wv_AA/pi,20*log10(abs(hv_AA)));
ax = gca;
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
hold

%prediction error filter
[hp_AA , wp_AA] = freqz(a_AA,1,"whole");
plot(wp_AA/pi,20*log10(abs(hp_AA)));
legend("vocal tract filter","prediction error filter")
title("Frequency responses of the phoneme AA")
%% zplane of prediction error filter: SH and AA
%SH
figure(3)
subplot(1,2,1);
zplane(roots(a_SH),1)
grid
title("zeros and poles in prediction SH")

subplot(1,2,2);
zplane(roots(b_SH),roots(a_SH))
grid
title("zeros and poles in vocal tract SH")

figure(4)
subplot(1,2,1);
zplane(roots(a_AA),1);
grid
title("zeros and poles in prediction AA")

subplot(1,2,2);
zplane(roots(b_AA),roots(a_AA))
grid
title("zeros and poles in vocal tract AA")

%% question 3
% x_SH_p = filter([0 -(a_SH(2:end)).'],1, s5(15500:16750));
% x_AA_p = filter([0 -(a_AA(2:end)).'],1, s5(16750:18800));
fs = 8000; %Sample frequency
N = 512; %fft points
n=0:N-1;
f=n*fs/N; % Frequency sequence.20*log10(f_SH))
f_SH = abs(fft(x_SH.',N));
f_AA = abs(fft(x_AA.',N));
figure(3)
plot(wv_SH/pi,20*log10(abs(hv_SH)));
hold on
plot(wv_SH/pi,20*log10(f_SH));
ax = gca;
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
figure(4)
plot(wv_AA/pi,20*log10(abs(hv_AA)));
hold on 
plot(wv_AA/pi,20*log10(f_AA));
ax = gca;
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')

