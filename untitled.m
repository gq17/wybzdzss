t = 0:0.1:2.4*pi;
x = cos(t)+cos(10*t);
xfft = fft(x);

figure;
subplot(1,2,1);
plot(x);
subplot(1,2,2);
plot(abs(xfft));