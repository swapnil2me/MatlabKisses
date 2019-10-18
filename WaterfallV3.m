clear all; close all; clc;
VgDC = -10;
VgAC = 1300:1:1850;%input('VgAC:');%900:50:1850;%[400:100:1000 1050:50:1600];%[500:100:1300 1375 1450 1525 1600];
fid='-10_1300_1850-6dB';
lm=0;%input('No of Loops: ');
[~, LD]=uigetfile('*.txt');


mapF = autumn(round(length(VgAC)*1.75)); %
mapB = winter(round(length(VgAC)*1.75));%
clc;
%LD  = 'E:\Swapnil\01_Results_Folder\SiX_Marsha_Chip03\039_Platau_-10_-7_Volt\19_-10V_Complete_Platau';
VsdAC = 200;
AttnG = [6];
AttnS = 42;
fData1 = [];fData2 = [];
zf=[];zb=[];x=[];
ifrq=1;
for il = 0:lm
    close all
for id = 1:length(VgDC)
    for ig = 1:length(VgAC)
        for itg = 1:length(AttnG)
            for is = 1:length(VsdAC)
                for its = 1:length(AttnS)
                    
                        VsdACd = sgen2dev(VsdAC(is),AttnS(its));
                        VgACd = sgen2dev(VgAC(ig),AttnG(itg));
                        [F,B ]=Nmgsd(VgDC(id),VgAC(ig),AttnG(itg),VsdAC(is),AttnS(its),il);
                        tempF=[LD,'\',F];
                        tempB=[LD,'\',B];
                        if exist(tempF, 'file') == 2 && exist(tempB, 'file') == 2
                            df = importdata(tempF);
                            db = importdata(tempB);
                            if length(df(:,2)') == length(db(:,2)')
%                                 if ~ isempty(zf)
%                                     a = length(zf(end,:));
%                                     b=length(df(:,2));
%                                     c=  length(zf(:,1));
%                                     if b>a
%                                         d=b-a;
%                                         zs=zeros(c,1);
%                                         for izf=1:d
%                                             zf = [zf zs];
%                                             zb = [zb zs];
%                                         end
%                                         df(:,1)
%                                         ifrq=ifrq+1;
%                                     end
%                                 end
                            end
                            zf = [zf; df(:,2)'.*1e9];
                            zb = [zb; db(:,2)'.*1e9];
                            x= [x;VgACd];
                            yf=df(:,1);
                            yb = db(:,1);
                        end
                    end
                end
            end
        end
    end

%close all
%close all;
%x=VgAC;
%yf=df(:,1);
%yb = db(:,1);
%h1 = waterfall(yf,x,zf);
xMat = repmat(x',length(yf),1);
yfMat = repmat(yf,1,length(x));
ybMat = repmat(yb,1,length(x));
%colormap(jet)
figure(10);hold on;
plot3(ybMat,xMat,zb,'LineWidth',0.0005,'LineStyle',':')
plot3(yfMat,xMat,zf,'LineWidth',2);hold off;
title(['Forward Sweep Vsd_{ac} : ',num2str(VsdACd), 'mV','  Vg_{dc} : ',num2str(VgDC(1)), 'V']);
figure(20); hold on;
plot3(yfMat,xMat,zf,'LineWidth',0.0005,'LineStyle',':')
plot3(ybMat,xMat,zb,'LineWidth',1.2);hold off;
title(['Backward Sweep Vsd_{ac} : ',num2str(VsdACd), 'mV','  Vg_{dc} : ',num2str(VgDC(1)), 'V']);
figure(30); hold on;
plot3(yfMat,xMat,zf,'LineWidth',2);
plot3(ybMat,xMat,zb,'LineWidth',2,'LineStyle','-');hold off;
%hold on;
%h2 = waterfall(yb,x,zb);
title(['Fwd-Bkw Sweep Vsd_{ac} : ',num2str(VsdACd), 'mV','  Vg_{dc} : ',num2str(VgDC(1)), 'V']);
Plot_Prop_3D(figure(10),'Forward Sweep','Freq (MHz)','VgAC (mV)','Amplitude (nA)')
Plot_Prop_3D(figure(20),'Backward Sweep','Freq (MHz)','VgAC (mV)','Amplitude (nA)')
Plot_Prop_3D(figure(30),'Fwd-Bkw Sweep','Freq (MHz)','VgAC (mV)','Amplitude (nA)')
fig1 = figure(10);
fig2 = figure(20);
fig3 = figure(30);
cld1 = fig1.CurrentAxes.Children;
cld2 = fig2.CurrentAxes.Children;
cld3 = fig3.CurrentAxes.Children;
lc = length(cld3)/2;
for ic = 1:lc
    temp1 = cld1(ic);
    temp2 = cld1(ic+lc);
    temp3 = cld2(ic);
    temp4 = cld2(ic+lc);
    temp5 = cld3(ic);
    temp6 = cld3(ic+lc);
    temp1.Color = mapF(ic,:);%end+(ic)-lc
    temp2.Color = [256 256 256]./256;%[230 230 230]./256;%mapB((end-ic),:);
    temp3.Color = mapB(end+(ic)-lc,:);
    temp4.Color = [256 256 256]./256;%[230 230 230]./256;%mapB((end-ic),:);
    temp5.Color = mapB(end+(ic)-lc,:);
    temp6.Color = mapF(ic,:);
    %drawnow;
    %pause(0.1)
end
%pause
cd(LD)
%input('fid:')
fid=[fid,'_L',num2str(il+1)];
sdr = '01_waterfall';
mkdir([LD,'/',sdr,'/Fwd']);
mkdir([LD,'/',sdr,'/Bkw']);
mkdir([LD,'/',sdr,'/FBW']);
 saveas(fig1,[sdr,'/Fwd','/','FWD_',fid,'.fig']);
 saveas(fig1,[sdr,'/Fwd','/','FWD_',fid,'.png']);
saveas(fig2,[sdr,'/Bkw','/','BKW_',fid,'.fig']);
saveas(fig2,[sdr,'/Bkw','/','BKW_',fid,'.png'])
saveas(fig3,[sdr,'/FBW','/','FWD-BKW_',fid,'.fig']);
saveas(fig3,[sdr,'/FBW','/','FWD-BKW_',fid,'.png']);
zf=[];zb=[];x=[];
end
close all