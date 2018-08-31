clc;
clear all;
xr_in=[(1:8)*20,zeros(1,248)];
xi_in=zeros(1,256);
Y=fft(xr_in)
