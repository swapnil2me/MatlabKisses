function y=fitwithbkg2(para,freq)

% f0=para(1);
% gam=para(2);
% A=para(3);
% B=para(4);
% H=para(5);
% delphi=para(6);
y=para(3)+para(4).*freq +para(5).*cos(atan((para(1)^2 -freq.^2)./para(2)./freq )+para(6))./(sqrt((1-(freq.^2)./(para(1)^2)).^2 +(para(2).*freq./para(1)./para(1)).^2));
end