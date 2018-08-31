% function [hexstring]=ndec2hex(x,n)
% % x : input decimal number
% % n :   number of bits to perform 2's complements
% % hexstring : hex representation of two's complement of x 
% x=x + (x<0).*2^n; 
% hexstring=dec2hex(x, ceil(n/4));
% end
% 
% function [x]=nhex2dec(hexstring,n)
% % hexstring : hex representation of two's complement of xmydec=hex2dec(hexstring);
% % x : input decimal number
% % n :   number of bits to perform 2's complements
% x = hex2dec(hexstring);
% x = x - (x >= 2.^(n-1)).*2.^n;
% end

Y_plus  = dec2hex(X) % Put positive Values of cosine here
Y_minus = dec2hex(bitcmp(abs(X)-1,32)) % Put negative Values of cosine here

X_sine=[]% Put your decimal Values of sine here
Y_sine= dec2hex(X_sine)


