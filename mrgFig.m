function [ output_args ] = mrgFig(fnum1,fnum2 )
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here
L = findobj(fnum1,'type','line');
copyobj(L,findobj(fnum2,'type','axes'));

end

