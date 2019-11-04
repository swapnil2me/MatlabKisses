function createMatUniF(locn,sweep,fnm)
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
    if i==1

    Fdata(1).FreqF = tempD.Freq;
    end
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
        if i==1
        Bdata(1).FreqB = tempD.Freq;
        end
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
save([direct,'/',fnm,'.mat'],'data');
clear all;
end