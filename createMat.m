function createMat(locn,sweep)
%% Conditions
% Location must have forward sweep data
% frequencie range must be same with equal step size
%%
cd(locn);
filesF  = dir('*_FWD_*.csv');
filesB  = dir('*_BKW_*.csv');
[~,b]=sort([filesF(:).datenum],'descend');
filesF(:)=filesF(b);
[~,b]=sort([filesB(:).datenum],'descend');
filesB(:)=filesB(b);
%% Name String Format
StrDC = 'V_VgDC_';
StrVg = 'mV_VgAC_';
StrVs = 'mV_VsdAC';
%% Initiate Structures
Nf = length(filesF);

Fdata(Nf) = struct();

%% Extract Drive Conditions
for i=1:Nf
    idc = strfind(filesF(i).name,StrDC);
    iVg = strfind(filesF(i).name,StrVg);
    iVs = strfind(filesF(i).name,StrVs);
    Fdata(i).VgDC = str2double(filesF(i).name(1:idc-1));
    Fdata(i).VgAC = str2double(filesF(i).name(idc+length(StrDC):iVg-1));
    Fdata(i).VsdAC = str2double(filesF(i).name(iVg+length(StrVg):iVs-1));
    tempD = readtable(filesF(i).name);
    Fdata(i).FreqF = tempD.Freq;
    Fdata(i).AmpF = tempD.Amp;
    Fdata(i).PhasF = tempD.Phs;
end
if strcmp(sweep,'vgdc')
    [~,b]= sort([Fdata(:).VgDC],'ascend');
    Fdata(:)=Fdata(b);
elseif strcmp(sweep,'vgac')
    [~,b]= sort([Fdata(:).VgAC],'ascend');
    Fdata(:)=Fdata(b);
elseif strcmp(sweep,'vsdac')
    [~,b]= sort([Fdata(:).VsdAC],'ascend');
    Fdata(:)=Fdata(b);
end
%% Backward Data
if length(filesB)>1
    Nb = length(filesB);
    Bdata(Nb) = struct();
    for i=1:Nb
        idc = strfind(filesB(i).name,StrDC);
        iVg = strfind(filesB(i).name,StrVg);
        iVs = strfind(filesB(i).name,StrVs);
        Bdata(i).VgDC = str2double(filesB(i).name(1:idc-1));
        Bdata(i).VgAC = str2double(filesB(i).name(idc+length(StrDC):iVg-1));
        Bdata(i).VsdAC = str2double(filesB(i).name(iVg+length(StrVg):iVs-1));
        tempD = readtable(filesB(i).name);
        Bdata(i).FreqB = tempD.Freq;
        Bdata(i).AmpB = tempD.Amp;
        Bdata(i).PhasB = tempD.Phs;
    end
    if strcmp(sweep,'vgdc')
        [~,b]= sort([Bdata(:).VgDC],'ascend');
        Bdata(:)=Bdata(b);
        logi = [Fdata(:).VgDC]==[Bdata(:).VgDC];
    elseif strcmp(sweep,'vgac')
        [~,b]= sort([Bdata(:).VgAC],'ascend');
        Bdata(:)=Bdata(b);
        logi = [Fdata(:).VgAC]==[Bdata(:).VgAC];
    elseif strcmp(sweep,'vsdac')
        [~,b]= sort([Bdata(:).VsdAC],'ascend');
        Bdata(:)=Bdata(b);
        logi = [Fdata(:).VsdAC]==[Bdata(:).VsdAC];
    end
    %% Combine Fwd and Bkw structs
    for i=1:Nf
        if logi(i)
            Fdata(i).FreqB=Bdata(i).FreqB;
            Fdata(i).AmpB=Bdata(i).AmpB;
            Fdata(i).PhasB=Bdata(i).PhasB;
        end
    end
end
%% Sort Data




%% Save .mat file
data = Fdata;
direct = 'Mat_file';
mkdir(direct);
save([direct,'\temp.mat'],'data');
clear all;
end
%%
function out = Swap_fitting_cvs(FNme)


data1=readtable(FNme);
ldata = length([data1.Amp]);

data0 = data1.Freq;
data0 = [data0 [data1.Amp] [data1.Phs]];

figure(101);
plot(data0(:,1),data0(:,2));
L1 = ginput(1);
Fm = L1(1);
L2 = find(data0(:,1)>Fm,1);
L1 = ginput(1);
Fm = L1(1);
L3 = find(data0(:,1)>Fm,1);
close(figure(101))
%pause
data=data0(L2:L3,:);
f0max = max(data(:,1));
f0min = min(data(:,1));
f0ini = (f0max+f0min)/2;
Aini=0.09;
Bini=-1e-6;
Qini=150;
Hini=-0.0020;
delphiini=2.5;
gamini=f0ini/Qini;

R=data(:,2).*1e9 ;% Nano Amprere  
freq=data(:,1);%Mega Heartz
thet=data(:,3).*pi./180;
Amin=-1;
Bmin=-1e-6;
Hmin=-10;
delphimin=-pi;

gammin=f0ini/(Qini.*10);

Amax=1;
Bmax=1e-6;
Hmax=10;
delphimax=pi;

gammax=f0ini/(Qini./10);

%% fitting to lorentzian equation
para=[f0ini gamini Aini Bini Hini delphiini];
%optimization parameters
opt=optimset('LargeScale','on','DiffMaxChange',1e-6, ...
    'DiffMinChange',1e-18,'Display','iter','Maxiter',5800,'Tolfun',1e-26,'TolX',1e-10,'MaxFunEval',6800);
% [para,resnorm,residual]=lsqcurvefit('freq_vg_fit2',para,Vg,fexp,[],[],opt);
[para,resnorm,residual]=lsqcurvefit('fitwithbkg2',para,freq,R,[f0min gammin Amin Bmin Hmin delphimin],[f0max gammax Amax Bmax Hmax delphimax],opt);
% para=lsqcurvefit('fit_mult_lorentz2',para,lambda,Ie,[],[],opt); % you can
% fit without specifying the limits on parameters


f0=para(1);
gam=para(2);
Q=f0/gam;
A=para(3);
B=para(4);
H=para(5);
delphi=para(6);
L=A+B.*freq + H.*cos(atan((f0^2 -freq.^2)./gam./freq )+delphi)./(sqrt((1-(freq.^2)./(f0^2)).^2 +(gam.*freq./f0./f0).^2));

     figure(4);
      subplot(2,1,1);plot(freq,data(:,3));
      subplot(2,1,2);plot(freq,L,'r','LineWidth',2'); hold on; plot(freq,R,'*');hold off;
      drawnow;
%     temp = ginput(2);

new_thet=mod(thet-delphi,pi);
new_R=(H.*cos(atan((f0^2 -freq.^2)./gam./freq ))./(sqrt((1-(freq.^2)./(f0^2)).^2 +(gam.*freq./f0./f0).^2)));
Ibg1 = (A+B.*freq);
Ibg = mean(Ibg1(1:20));
Imax = max(L);%*1e-10;
Imin = min(L);%*1e-10;
Ipeak = Imax-Imin;
Ipeak2 = H*Q;
zmax = (Imax*5e-3*300e-9)/(Imin*10);
%marsha_data = [Vsdac f0 Q Imax Imin];
% if  not(isempty(temp))
%         f0 = temp(1,1);
%         Ipeak = abs(temp(1,2)-temp(2,2));
% end
out = [f0 Ipeak Q Ibg Ipeak2];
out = [f0 A B H Q];
end
