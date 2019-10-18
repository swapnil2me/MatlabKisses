%%
clear all;
close all;
clc;
% fig17=figure(17);text(0.18,0.25,'Do Not Use Matlab','FontSize',24,'FontWeight','bold')
% figure(17);text(0.35,0.65,'RUN IS ON','FontSize',24,'FontWeight','bold')
% fig17.Position = [1316 76 560 420];
%% Set the Instruments


RsgVs = openAnPclan('169.254.7.87');
RsgVg = openAnPclan('169.254.7.42');
Lia =openLIAgpibCable(8);
%% Drive Condition Space
VgDC=-10;
VgAC=1600:-100:500;
AttnG=6;
VsdAC=1000;
AttnS = 36;
%% Frequency range
sF = 48;
eF = 51;
dF = 0.02;
mx = 1987;
%% Ramp COnditions
DCrmpStp = 400;
ACrmpStp = 100;
rmpPause = 0.001;
Gatechn = 1;
%% Ramp Up instruments
clc;
disp('!!! Ramping Up !!!')
dcVc=LIAAuxRampV(Lia,Gatechn,VgDC(1)*1000,DCrmpStp,rmpPause);

%acV = TSGrmpV(Tsg,VgAC(1),100);
RacV1 = AcPcrmpV(RsgVg,VgAC(1).*1e-3);
RacV2 = AcPcrmpV(RsgVs,VsdAC(1).*1e-3);
%% The Parameter Sweep
disp('!!! Prameter Sweep Began !!!')
for i = 1:length(VgDC)
    dcVc=LIAAuxRampV(Lia,Gatechn,VgDC(i)*1000,DCrmpStp,rmpPause);
    for j = 1:length(VgAC)
        RacV1 = AcPcrmpV(RsgVg,VgAC(j).*1e-3);
        for k=1:length(VsdAC)
            RacV2 = AcPcrmpV(RsgVs,VsdAC(k).*1e-3);
            %% the frequency Sweep
            VsdACd = sgen2dev(RacV2,AttnS);
            VgACd = sgen2dev(RacV1,AttnG);
            FF = [num2str(VgDC(i),'%2.2f'),'V_VgDC_',num2str(VgACd,'%2.2f'),'mV_VgAC_',num2str(VsdACd,'%2.2f')...
                ,'mV_VsdAC_FWD_',num2str(sF),'_',num2str(eF),'_MHZ.csv'];
            FB = [num2str(VgDC(i),'%2.2f'),'V_VgDC_',num2str(VgACd,'%2.2f'),'mV_VgAC_',num2str(VsdACd,'%2.2f')...
                ,'mV_VsdAC_BKW_',num2str(eF),'_',num2str(sF),'_MHZ.csv'];
            
            dataF=fSweepAnPc(sF,eF,dF,mx,RsgVg,RsgVs,Lia);
            TF = struct2table(dataF);
            writetable(TF,FF);
            pause(2);
            dataB=fSweepAnPc(eF,sF,dF,mx,RsgVg,RsgVs,Lia);
            TB = struct2table(dataB);
            writetable(TB,FB);
            
            clf(figure(1));
            clear dataF
            clear TF
            clear dataB
            clear TB
        end
    end
end
%% Ramp Down Instruments
disp('!!! Ramping Down !!!')
dcVc=LIAAuxRampV(Lia,Gatechn,0,DCrmpStp,rmpPause);
AcPcrmpV(RsgVg,0);
AcPcrmpV(RsgVs,0);
%% Clear Instrumentation
fclose(RsgVg);
fclose(RsgVs);
fclose(Lia);
%% Run Complete
close all;
disp('!!! RUN COMPLETE !!!')
%%
