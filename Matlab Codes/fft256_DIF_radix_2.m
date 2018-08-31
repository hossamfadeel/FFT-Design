% 256-points fft  (DIF radix-2)  only support 256-fft 
clc;clear all;close all; 
% ==============================Setting===================================== 
N=256; 
Symbol_n=3; 
% bit_n=256*4*Symbol_n; 
% % ========================================================================== 
% % ==============================generator signal============================ 
% bit_s=(sign(randn(1,bit_n))+1)/2; 
% a=reshape(bit_s,Symbol_n*256,4); 
% x=bi2de(a,'left-msb'); 
% qam16=qammod(x,16); 
% qam16=(qam16)'; 
% qam16_r=real(qam16); 
% qam16_i=imag(qam16); 
% power=0; 
% for k=1:Symbol_n*16, 
%     qam_p=qam16_r(k)*qam16_r(k)+qam16_i(k)*qam16_i(k); 
%     power=power+qam_p; 
% end 
% x=qam16/sqrt(power/(Symbol_n*16));  
% save ('x.mat','x'); 
load x.mat 
% x=0.994*ones(1,N)-j*0.994*ones(1,N); 
realin=real(x); 
for i=1:N*Symbol_n, 
realin_bit(i,:)=number2vector(realin(i)*2^11,12); 
end 
imagin=imag(x); 
for i=1:N*Symbol_n, 
imagin_bit(i,:)=number2vector(imagin(i)*2^11,12); 
end 
 
 
 
% x=[rand(1,256)]; 
% save ('x.mat','x'); 
% load x.mat 
% x=ones(1,256); 
% for i=1:256 
% y(i,:)=number2vector(x(i)*2^10,12); 
% end 
 
% load realin.mat; 
% load imagin.mat; 
 
% x=imag(x)+j*real(x); 
 
 
% load outre.txt; 
% load outim.txt; 
 
 
 
%  
%  
%  
%  
%  
%  
%  
%  
%  
total_op=[]; 
fft_op=[];      
 
% reg1_max=[]; 
% reg1_min=[]; 
% reg2_max=[]; 
% reg2_min=[]; 
% reg3_max=[]; 
% reg3_min=[]; 
% reg4_max=[]; 
% reg4_min=[]; 
% reg5_max=[]; 
% reg5_min=[]; 
% reg6_max=[]; 
% reg6_min=[]; 
% reg7_max=[]; 
% reg7_min=[]; 
% reg8_max=[]; 
% reg8_min=[]; 
 
 
 
 
 
 
for sym=1:Symbol_n 
    x1=x((sym-1)*256+1:(sym-1)*256+256); 
% x =[ones(1,N)] ; 
reg1 = []; 
reg2 = []; 
reg3 = []; 
reg4 = []; 
reg5 = []; 
reg6 = []; 
reg7 = []; 
reg8 = []; 
 
 
 
 
%----stage1----- 
for i = 1:N/2 
    reg1(i)    = x1(i) + x1(i+N/2) ; 
    reg1(i+N/2) = (x1(i) - x1(i+N/2))*exp(-j*2*pi*(i-1)/N); 
%      reg1(i+N/2) = (x1(i) - x1(i+N/2)); 
end; 
 
% %----stage2-----  
for i = 1:N/4 
    for k = 0:N/2:N-1 
        reg2(i+k)    = reg1(i+k) + reg1(i+N/4+k); 
        reg2(i+N/4+k)= (reg1(i+k) - reg1(i+N/4+k))*exp(-j*2*pi*2*(i-1)/N); 
%         reg2(i+N/4+k)= (reg1(i+k) - reg1(i+N/4+k)); 
    end; 
end; 
 
 
%----stage3----- 
for i = 1:N/8 
    for k = 0:N/4:N-1; 
        reg3(i+k)    = reg2(i+k) + reg2(i+N/8+k);  
        reg3(i+N/8+k)= (reg2(i+k) - reg2(i+N/8+k))*exp(-j*2*pi*4*(i-1)/N); 
%         reg3(i+N/8+k)= (reg2(i+k) - reg2(i+N/8+k)); 
    end 
end; 
 
% %----stage4----- 
for i = 1:N/16 
    for k = 0:N/8:N-1; 
        reg4(i+k)     = reg3(i+k) + reg3(i+N/16+k);  
        reg4(i+N/16+k)= (reg3(i+k) - reg3(i+N/16+k))*exp(-j*2*pi*8*(i-1)/N); 
%         reg4(i+N/16+k)= (reg3(i+k) - reg3(i+N/16+k)); 
    end 
end;     
 
% %----stage5----- 
for i = 1:N/32 
    for k = 0:N/16:N-1; 
        reg5(i+k)    = reg4(i+k) + reg4(i+N/32+k);  
        reg5(i+N/32+k)  = (reg4(i+k) - reg4(i+N/32+k))*exp(-j*2*pi*N/16*(i-1)/N); 
%         reg5(i+N/32+k)  = (reg4(i+k) - reg4(i+N/32+k)); 
    end 
end;   
 
%----stage6----- 
for i = 1:N/64 
    for k = 0:N/32:N-1; 
        reg6(i+k)    = reg5(i+k) + reg5(i+N/64+k);  
        reg6(i+N/64+k)  = (reg5(i+k) - reg5(i+N/64+k))*exp(-j*2*pi*N/8*(i-1)/N); 
%         reg6(i+N/64+k)  = (reg5(i+k) - reg5(i+N/64+k)); 
    end 
end;    
 
%----stage7----- 
for i = 1:N/128 
    for k = 0:N/64:N-1; 
        reg7(i+k)    = reg6(i+k) + reg6(i+N/128+k);  
        reg7(i+N/128+k)  = (reg6(i+k) - reg6(i+N/128+k))*exp(-j*2*pi*N/4*(i-1)/N); 
%         reg7(i+N/128+k)  = (reg6(i+k) - reg6(i+N/128+k)); 
    end 
end;   
 
%----stage8----- 
for k=1:2:N, 
reg8(k)=reg7(k)+reg7(k+1); 
end; 
for k=2:2:N, 
reg8(k)=(reg7(k-1)-reg7(k)); 
end; 
 
output = reg8; 
% ----bit reversal--- 
num=0:N-1; 
temp=dec2bin(0:N-1); 
z=bin2dec(temp(:,end:-1:1))'; 
output=(output([z+1])); 
total_op=[total_op output]; 
fft_op=[fft_op ifft(x1,N)]; 
% reg1_max=[reg1_max max(real(reg1))]; 
% reg1_min=[reg1_min min(real(reg1))]; 
% reg2_max=[reg2_max max(real(reg2))]; 
% reg2_min=[reg2_min min(real(reg2))]; 
% reg3_max=[reg3_max max(real(reg3))]; 
% reg3_min=[reg3_min min(real(reg3))]; 
% reg4_max=[reg4_max max(real(reg4))]; 
% reg4_min=[reg4_min min(real(reg4))]; 
% reg5_max=[reg5_max max(real(reg5))]; 
% reg5_min=[reg5_min min(real(reg5))]; 
% reg6_max=[reg6_max max(real(reg6))]; 
% reg6_min=[reg6_min min(real(reg6))]; 
% reg7_max=[reg7_max max(real(reg7))]; 
% reg7_min=[reg7_min min(real(reg7))]; 
% reg8_max=[reg8_max max(real(reg8))]; 
% reg8_min=[reg8_min min(real(reg8))]; 
end 
% -----check----- 
temp=cell2mat(textread('outre.txt','%s'))-'0'; 
for i=1:N*Symbol_n 
out_re_dec(i)=vector2number(temp(i,:)); 
end 
 
temp=cell2mat(textread('outim.txt','%s'))-'0'; 
for i=1:N*Symbol_n 
out_im_dec(i)=vector2number(temp(i,:)); 
end 
% %  
rtl_re=out_re_dec*2^-11; 
rtl_im=out_im_dec*2^-11; 
mat_re=real(fft_op)*16; 
mat_im=imag(fft_op)*16; 
 
 
figure; 
stem(rtl_re,'o'); 
% stem(real(output/sqrt(N)),'o') 
hold on; 
stem(mat_re,'rx'); 
% stem(mat_im,'rx'); 
legend('rtl','matlab') 
title ('Real part') 
xlabel('Samples'); 
ylabel('Value'); 
 
 
 
figure; 
stem(rtl_im,'o'); 
% stem(imag(output/sqrt(N)),'o') 
hold on; 
stem(mat_im,'rx'); 
% stem(mat_re,'rx'); 
legend('rtl','matlab') 
title('Imag Part') 
xlabel('Samples'); 
ylabel('Value'); 
 
figure 
subplot (2,1,1) 
gg=abs(rtl_re-mat_re); 
bar(gg) 
axis([0 768 0 0.08]); 
title ('Inaccuracy @ real part') 
xlabel ('Samples') 
ylabel ('Subtraction') 
subplot (2,1,2) 
gg2=abs(rtl_im-mat_im); 
bar(gg2) 
axis([0 768 0 0.08]); 
title ('Inaccuracy @ imag part') 
xlabel ('Samples') 
ylabel ('Subtraction') 
 
 
 
max(abs(rtl_re-mat_re)) 
max(abs(rtl_im-mat_im)) 
 
avg_inaccuracy_re=sum(abs(rtl_re-mat_re))/768 
avg_inaccuracy_im=sum(abs(rtl_im-mat_im))/768 
 

