function data = addFld(locn,fldnm,flnm)
%% Description
% Adds a 'fldnm' filed to struct loaded from resdata MAT file
% the filed contains the Ginput data
% Swapnil More 05/09/2018
cd(locn);
direct = 'Mat_file';
load([direct,'\',flnm],'data');
if ~isfield(data,fldnm)
    data(1).(fldnm)=[];
    disp(':p')
end
for i=1:length(data)
    if strcmp(fldnm,'FwResF')
        plot(data(i).FreqF,data(i).AmpF,'.r')
        hold on
        plot(data(i).FreqB,data(i).AmpB,'.b','MarkerSize',0.5)
    elseif strcmp(fldnm,'BkResF')
        plot(data(i).FreqB,data(i).AmpB,'.b')
        hold on
        plot(data(i).FreqF,data(i).AmpF,'.r','MarkerSize',0.5)
    end
    
    
    %% GInput Loop
    drawnow
    numPointsClicked =0;
    clear xfl yfl
    while 1 < 2
        numPointsClicked = numPointsClicked + 1;
        [dm1,dm2,btn] = ginput(1);
        if ~isempty(btn)
            xfl(numPointsClicked)=dm1; yfl(numPointsClicked)=dm2; button=btn;
            plot(xfl(numPointsClicked), yfl(numPointsClicked), 'r+', 'MarkerSize', 15);
        elseif isempty(btn)
            button = 3;
        end
        
        if button == 3
            % Exit loop if
            break;
            
        end
    end
    hold off
    data(i).(fldnm) = [data(i).(fldnm) xfl(1:end-1)];
    data(i).(fldnm)=unique(data(i).(fldnm));
    save([direct,'\','Data_',fldnm,'.mat'],'data');
    %pause;
    
end
close all;
end