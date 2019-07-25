function data = fSweepSMALSTb(sf,ef,bs,ss,fr,mx,GTsg,SDsg,Lia)
%% Freq sweep
mx=mx*1e-6;
[~,fb] = genFreLst(sf,ef,bs,ss,fr);
N = length(fb);

figure(1);hold on;
data(N) = struct();
%data.Freq=zeros(N,1);
%data.Amp=zeros(N,1);
%data.Phs=zeros(N,1);
for i=1:N
    F =fb(i);
    mF = F-mx;
    wrteFrqPhs(GTsg,F,0)
    wrteFrqPhs(SDsg,mF,0)
    if i == 1
        [A,P]=readLIAsens(Lia,3000);
    end
    [A,P]=readLIAsens(Lia,300);
    data(i).Freq=F;
    data(i).Amp=A;
    data(i).Phs=P;
    %pause(0.1)
    yyaxis left
    plot(F,A*1e9,'ob','MarkerSize',1.5);
    yyaxis right
    plot(F,P,'sr','MarkerSize',2);
end
end