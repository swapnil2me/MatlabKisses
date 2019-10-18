clear all; close all; clc;
VgDC = -10;
VgAC = 950:1:1050;%input('VgAC:');%900:50:1850;%[400:100:1000 1050:50:1600];%[500:100:1300 1375 1450 1525 1600];
fid='-10_950_1050-6dB';
lm=0;%input('No of Loops: ');
[~, LD]=uigetfile('*.txt');


mapF =  winter(round(length(VgAC)*1.75));%autumn(round(length(VgAC)*1.75)); %
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
                        if true
                            df = importdata(tempF);
                            
                            if true
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
                            zf = [zf; df(3:end,2)'.*1e9];
                            
                            x= [x;VgACd];
                            yf=df(3:end,1);
                            
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

%colormap(jet)
figure(10);hold on;
plot3(yfMat,xMat,zf,'LineWidth',2,'LineStyle','-')

title(['Backward Sweep Vsd_{ac} : ',num2str(VsdACd), 'mV','  Vg_{dc} : ',num2str(VgDC(1)), 'V']);


Plot_Prop_3D(figure(10),'Forward Sweep','Freq (MHz)','VgAC (mV)','Amplitude (nA)')

fig1 = figure(10);

cld1 = fig1.CurrentAxes.Children;
lc = length(cld1);
for ic = 1:lc
    temp1 = cld1(ic);
    
    
    temp1.Color = mapF(ic,:);%end+(ic)-lc
   
   
    %drawnow;
    %pause(0.1)
end
%pause
cd(LD)
%input('fid:')
fid=[fid,'_L',num2str(il+1)];
sdr = '01_waterfall';
mkdir([LD,'/',sdr,'/BKW']);
 saveas(fig1,[sdr,'/BKW','/','BKW_',fid,'.fig']);
 saveas(fig1,[sdr,'/BKW','/','BKW_',fid,'.png']);
zf=[];zb=[];x=[];
end
close all