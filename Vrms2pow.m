function pow = Vrms2pow(Vrms)
pow = 10*log10((Vrms/(1000))^2/(50*1e-3));
end
