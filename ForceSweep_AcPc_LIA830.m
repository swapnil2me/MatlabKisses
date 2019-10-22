clear all;close all;clc;
%% Initial Parameters
sF = 10;%MHz
eF = 100;%MHz
dF = 0.02;%MHz
mixDF = 2019;%Hz
rampSteps = 200;
rampPause = 0.005;
%% Open InstR
VgAC_Inst = AnaPico('169.254.7.42',sF,eF,dF,rampSteps,rampPause);
VsAC_Inst = AnaPico('169.254.7.87',sF,eF,dF,rampSteps,rampPause);
LIA_Inst  = SRS830(8,mixDF);
%% Sgen Voltages
Vs   = 300;VsAC_Inst.rampV(Vs);
VsAC_Inst.Attn = 36;
VgAC   = 300:1:360;
VgAC_Inst.Attn = 16;
freQS = 10:0.5:12;
vgDC = -10;
%% Data Handeling
locn       = 'D:\Swapnil\06_01_Matlab\testFolder';
locn       = strjoin(regexp(locn,'\','split'),'/');
formatFWD = '%.2fV_VgDC_%0.2fmV_VsdAC_%3.4fMhz_VgAC_FWD_%0.2f_%0.2f_mV';
formatBKW = '%.2fV_VgDC_%0.2fmV_VsdAC_%3.4fMhz_VgAC_BKW_%0.2f_%0.2f_mV';
%% The Loop
for i = 1:length(vgDC)
    LIA_Inst.rampVaux(1,vgDC(i)*1000,rampSteps,rampPause);
    for j = 1:length(freQS)
        VgAC_Inst.setFreq(freQS(j))
        VsAC_Inst.setFreq(freQS(j)-mixDF*1e-6)
        
        fileName = sprintf(formatFWD,vgDC(i),Vs(i),freQS(j),sgen2dev(VgAC(1),VgAC_Inst.Attn),sgen2dev(VgAC(end),VgAC_Inst.Attn));
        fileID   = fopen([locn,'/',fileName,'.csv'],'w');
        fprintf(fileID,'VgAC,Amp,Phs\n');
        VgAC_Inst.rampSteps=5;
        VgAC_Inst.rampPS = 0.005;
        for k = 1:length(VgAC)
            VgAC_Inst.rampV(VgAC(k));
            [A,P] = LIA_Inst.readAPsens(300);
            fprintf(fileID,'%12.8f,%12.8f,%12.8f\n',sgen2dev(VgAC(k),VgAC_Inst.Attn),A,P);
            figure(1);hold on
            yyaxis left
            plot(sgen2dev(VgAC(k),VgAC_Inst.Attn),A*1e9,'ob','MarkerSize',1.5);
            yyaxis right
            plot(sgen2dev(VgAC(k),VgAC_Inst.Attn),P,'sr','MarkerSize',2);hold off;
        end
        fclose(fileID);
        
        fileName = sprintf(formatBKW,vgDC(i),Vs(i),freQS(j),sgen2dev(VgAC(end),VgAC_Inst.Attn),sgen2dev(VgAC(1),VgAC_Inst.Attn));
        fileID   = fopen([locn,'/',fileName,'.csv'],'w');
        fprintf(fileID,'VgAC,Amp,Phs\n');
        for k = length(VgAC):-1:1
            VgAC_Inst.rampV(VgAC(k));
            [A,P] = LIA_Inst.readAPsens(300);
            fprintf(fileID,'%12.8f,%12.8f,%12.8f\n',sgen2dev(VgAC(k),VgAC_Inst.Attn),A,P);
            figure(1);hold on
            yyaxis left
            plot(sgen2dev(VgAC(k),VgAC_Inst.Attn),A*1e9,'om','MarkerSize',1.5);
            yyaxis right
            plot(sgen2dev(VgAC(k),VgAC_Inst.Attn),P,'sk','MarkerSize',2);hold off;
        end
        fclose(fileID);
        clf(figure(1))
    end
end
%% Ramp down
LIA_Inst.rampVaux(1,0,rampSteps,rampPause)
VgAC_Inst.rampV(0)
VsAC_Inst.rampV(0)
fclose('all');