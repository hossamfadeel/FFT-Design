%% Test Sequence for 256 FFT DIF
% The test sequence can be generated in MatLab as follows:
clc; clear all; close all;
X=[(1:8)*20,zeros(1,248)]; % 8 + 248 = 256
Y=fft(x)