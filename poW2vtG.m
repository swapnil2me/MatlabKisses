function [vtG] = poW2vtG(poW)
    vtG = (10.^((poW-10)./20))./sqrt(2);
end