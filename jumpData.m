function JumpData = jumpData(locn,flnm)
%% Description
% Creates Jump data from the resonance sweep loaded form 'flnm' MAT file
% The frequency data must be uniform
% i.e. the flnm.Mat must have been created usung createMatUniF.m
% the filed contains the Ginput data
%Saves data in separate JumpData.Mat

% Swapnil More 05/09/2018
cd(locn);
load(flnm,'data');
frqF = [data.FreqF];
frqB = [data.FreqB];

%% create JumpData
%JumpData(length(data))=struct();
JumpData.VgDC = [];
JumpData.VgAC = [];
JumpData.VsdAC = [];
JumpData.JUFfreq = [];
JumpData.JDFfreq = [];
JumpData.JUBfreq = [];
JumpData.JDBfreq = [];
JumpData.JUFamp = [];
JumpData.JDFamp = [];
JumpData.JUBamp = [];
JumpData.JDBamp = [];
%% Sweep Data
for i=1:length(data)
    JumpData(i).VgDC = data(i).VgDC;
    JumpData(i).VgAC = data(i).VgAC;
    JumpData(i).VsdAC = data(i).VsdAC;
    %% Forward Sweep GIP
    ampF = data(i).AmpF;
    ampB = data(i).AmpB;
    fig=figure(1);
    fig.Position=[130 386 1605 420];
    plot(frqF,ampF,'r')
    hold on
    plot(frqB,ampB,'.b','MarkerSize',0.5)
    
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
    datag = [xfl' yfl'];
    %% Extracting Jumps Forward sweep
    for dig = 1:(length(datag)-1)/2
        d1 = find((frqF-datag(1+(dig-1)*2,1))> 0,1);
        d2 = find((frqF-datag(2+(dig-1)*2,1))> 0,1);
        iNd1 = min(d1,d2);
        iNd2 = max(d1,d2);
        difList = abs(diff(ampF(iNd1:iNd2)))*1e9;
        [~,difListMaxIndx] = max(difList);
        SndMaxdifList=max(difList(difList<max(difList)));
        SndMaxind=find(difList==SndMaxdifList,1);
        difJumpInd = min(difListMaxIndx,SndMaxind);
        A0 = ampF(iNd1+difJumpInd-1)*1e9;% -1 because index of Tlist stars from 1,
        % but Tlist(1) is iNd1
        f0 = frqF(iNd1+difJumpInd-1);
        if (A0-ampF(iNd1+difJumpInd)) > 0
            JumpData(i).JDFfreq = [JumpData(i).JDFfreq f0];
            JumpData(i).JDFamp = [JumpData(i).JDFamp A0];
        elseif (A0-ampF(iNd1+difJumpInd)) < 0
            JumpData(i).JUFfreq = [JumpData(i).JUFamp f0];
            JumpData(i).JUFamp = [JumpData(i).JUFamp A0];
        end
    end
    %pause;
    %% Backward Sweep GIP
    
    plot(frqB,ampB,'b')
    hold on
    plot(frqF,ampF,'.r','MarkerSize',0.5)
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
    datag = [xfl' yfl'];
    %% Extracting Jumps Backward sweep
    for dig = 1:(length(datag)-1)/2

        d1 = find((frqB-datag(1+(dig-1)*2,1))<0,1);
        d2 = find((frqB-datag(2+(dig-1)*2,1))< 0,1);
        iNd1 = min(d1,d2);
        iNd2 = max(d1,d2);
        difList = abs(diff(ampB(iNd1:iNd2)))*1e9;
        [~,difListMaxIndx] = max(difList);
        SndMaxdifList=max(difList(difList<max(difList)));
        SndMaxind=find(difList==SndMaxdifList,1);
        difJumpInd = min(difListMaxIndx,SndMaxind);
        disp('writing bkw data')
        A0 = ampB(iNd1+difJumpInd)*1e9;% -1 because index of Tlist stars from 1,
        % but Tlist(1) is iNd1
        f0 = frqB(iNd1+difJumpInd);
        if (A0-ampB(iNd1+difJumpInd-1)) < 0
            disp('writing bkw data');
            JumpData(i).JUBfreq = [JumpData(i).JUBfreq f0];
            JumpData(i).JUBamp = [JumpData(i).JUBamp A0];
        elseif (A0-ampB(iNd1+difJumpInd-1)) > 0
            disp('writing bkw data')
            JumpData(i).JDBfreq = [JumpData(i).JUBfreq f0];
            JumpData(i).JDBamp = [JumpData(i).JDBamp A0];
        end
    end
    %pause;
    
end
close all;
save('JumpData.mat','JumpData');
end