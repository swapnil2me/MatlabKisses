function wrteFrqPhs(obj1,frq,phs)
%%
% Freq in MHz
% Phase in Rad
% Swapnil More
% 20-08-2018
if nargin == 2
    phs = 0;
end
fprintf(obj1, ['FREQ ',num2str(frq,'%.8f'),' MHz; PHAS ',num2str(phs),';']);
end