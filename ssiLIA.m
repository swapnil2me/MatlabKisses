function tot = ssiLIA(ssi)
% a = [1 2 5];b = [1 10 100];c=[1e-15 1e-12 1e-9 1e-6];
% 
% nanas   = floor(ssi./9)
% appas   = floor(rem(ssi,9)./3)
% bedas   = rem(rem(ssi,9),3)
% tot        = c(floor(ssi./9)+1).*b(floor(rem(ssi,9)./3)+1).*a(rem(rem(ssi,9),3)+1)
data.ind = 0:1:26;
data.val = [2e-15 5e-15 10e-15 20e-15 50e-15 100e-15 200e-15 500e-15 ...
                  1e-12 2e-12 5e-12 10e-12 20e-12 50e-12 100e-12 200e-12 500e-12 ...
                  1e-9 2e-9 5e-9 10e-9 20e-9 50e-9 100e-9 200e-9 500e-9 1e-6 ];
tot = data.val(data(:).ind==ssi);
end