function Loss = lossSgen2Dev(Sgen,Dev)
    Loss = 10*log10(20)+20*log10(Sgen)-10-20*log10(sqrt(2)*Dev);
end