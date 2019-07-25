function [ DevV ] = sgen2dev( SigV, Attn )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
DevV = (10.^(((10*log10(20)+20*log10(SigV))-10-Attn)./(20)))./sqrt(2);

end

