%% Radix 2 Decimation in Frequency 
% Matlab Program for DFT-FFT using DIF algorithm 
% Input : Normal Order, An array of Length N
% Output: Normal Order (Output Bits reversed) X[k]
% For any length N (RADIX 2 DIF)
clc;
clear all; close all;
Input_Data=[(1:8)*20,zeros(1,248)]; % 8 + 248 = 256
% Input_Data = [1, j, -1, 2, 1, j, -1, 2] %, 1, j, -1, 2, 1, j, -1, 2];
N=length(Input_Data);
x=Input_Data; % ,zeros(1,(2^levels)-N)]; In case of Not power 2
Num_Stages=log2(N); % Number of stages
% Number_of_TwFactor = (log2(N))*(N/2);
Twiddle_Factor = exp(-1i*2*pi*(0:N/2-1)/N); % Calculating Twiddle Factor W = exp(-1i*2*pi*(n/N))
Twiddle_Factor_Cos_Sin = cos(2*pi*(1/N)*(0:N/2-1))-j*sin(2*pi*(1/N)*(0:N/2-1));
Cos_Data = cos(2*pi*(1/N)*(0:N/2-1));
Sin_Data = sin(2*pi*(1/N)*(0:N/2-1));

for Stages=Num_Stages:-1:1
     Levels=2^Stages
     Twiddle_Factor_Level = Twiddle_Factor(1:N/Levels:N/2);
     for k=0:Levels:N-Levels;
         for n=0:Levels/2-1;
             A = x(n+k+1);
             B = x(n+k+(Levels/2)+1);
             x_index_0 = (n+k+1)
             x(n+k+1) = A + B;
             x_index_1 = (n+k+(Levels/2)+1)
             x(n+k+(Levels/2)+1) = (A-B)*Twiddle_Factor_Level(n+1); % DIF
         end
     end
end

X_K=bitrevorder(x);
XX_KK = X_K';

ansft=fft(Input_Data);
ans_KK = ansft';
