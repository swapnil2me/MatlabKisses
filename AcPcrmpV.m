function AcPcrmpV(AcPc,vOut)
fclose(AcPc);
set(AcPc, 'InputBufferSize', 2048);
set(AcPc, 'OutputBufferSize', 2048);
set(AcPc, 'EOSMode', 'read&write');
fopen(AcPc);
fprintf(AcPc, 'UNIT:POW V');
isOptOn= str2num(query(AcPc, ':OUTP:STAT? '));
if (isOptOn==0)
    fprintf(AcPc, ':sour:pow:lev:imm:ampl 0.001');
    fprintf(AcPc, ':OUTP:STAT ON');
    pl=1e-3;
    plStSize=1e-3;
    plsn=floor(abs(vOut-pl)/plStSize);
    plSteps=linspace(pl,vOut,plsn);
    for i=1:plsn
        fprintf(AcPc, sprintf(':sour:pow:lev:imm:ampl %g',plSteps(i)));
        pause(0.0001);
    end
else    
     pl=str2num(query(AcPc, ':sour:pow:lev?')); %% quarray power level
     if(pl~=vOut)
         plStSize=1e-3;
         plsn=floor(abs(vOut-pl)/plStSize);
         plSteps=linspace(pl,vOut,plsn);
         for i=1:plsn
             fprintf(AcPc, sprintf(':sour:pow:lev:imm:ampl %g',plSteps(i)));
             pause(0.0001);
         end
     end
end
end
