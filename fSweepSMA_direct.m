function data = fSweepSMA_direct(sF,eF,dF,GTsg,Lia)
%% Freq sweep

N = round(abs(eF-sF)/dF);
if sF>eF
    dF = -dF;
end
F=sF-dF;
figure(1);hold on;
data(N) = struct();
%data.Freq=zeros(N,1);
%data.Amp=zeros(N,1);
%data.Phs=zeros(N,1);
for i=0:N
    F =F+dF;
    
    wrteFrqPhs(GTsg,F,0);
    if i == 0
        [A,P]=readLIA844(Lia,3000);
    end
    [A,P]=readLIA844(Lia,500);
    data(i+1).Freq=F;
    data(i+1).Amp=A;
    data(i+1).Phs=P;
    %pause(0.1)
    yyaxis left
    plot(F,A*1e9,'ob','MarkerSize',1.5);
    yyaxis right
    plot(F,P,'sr','MarkerSize',2);
end
end