function wrteSMAPhs(SMA,phs)
%%
% Freq in MHz
% Phase in Rad
% Swapnil More
% 20-08-2018
if nargin == 1
    phs = 0;
end
fprintf(SMA, ['PHAS ',num2str(phs),' RAD;']);
%fprintf(SMA, ['PHAS:REF']);
end