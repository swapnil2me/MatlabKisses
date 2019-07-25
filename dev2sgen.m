function [ Vsig ] = dev2sgen( Vdev, Attn )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
Vsig = 10.^((20*log10(sqrt(2).*Vdev)+10+Attn-10*log10(20))/(20));
end