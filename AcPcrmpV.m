function AcPcrmpV(obj,vOut)
fclose(obj);
set(obj, 'InputBufferSize', 2048);
set(obj, 'OutputBufferSize', 2048);
set(obj, 'EOSMode', 'read&write');
fopen(obj);
fprintf(obj, 'UNIT:POW V');
rfStat= str2num(query(obj, ':OUTP:STAT? '));
if (rfStat==0)
    fprintf(obj, ':sour:pow:lev:imm:ampl 0.001');
    fprintf(obj, ':OUTP:STAT ON');
    pl=1e-3;
    plStSize=1e-3;
    plsn=floor(abs(vOut-pl)/plStSize);
    plSteps=linspace(pl,vOut,plsn);
    for i=1:plsn
        fprintf(obj, sprintf(':sour:pow:lev:imm:ampl %g',plSteps(i)));
        pause(0.0001);
    end
else    
     pl=str2num(query(obj, ':sour:pow:lev?')); %% quarray power level
     if(pl~=vOut)
         plStSize=1e-3;
         plsn=floor(abs(vOut-pl)/plStSize);
         plSteps=linspace(pl,vOut,plsn);
         for i=1:plsn
             fprintf(obj, sprintf(':sour:pow:lev:imm:ampl %g',plSteps(i)));
             pause(0.0001);
         end
     end
end
end
