classdef SRS830
    properties
        address;
        instR;
        refreQ; % Hertz
    end
    
    methods
        function obj = SRS830(address,refreQ)
            inst = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', address, 'Tag', '');
            if isempty(inst)
                inst = gpib('NI', 0, address);
            else
                fclose(inst);
                inst = inst(1);
            end
            fopen(inst);
            obj.instR = inst;
            obj.refreQ= refreQ;
            obj.address = address;
        end
        
        %% Ramp Aux
        function rampVaux(obj,chn,OSV,RmpN,ps)
            Lia = obj.instR;
            OCV = str2double(query(Lia,['AUXV?',num2str(chn)]))*1000;
            RmpSt =((OCV-OSV)/RmpN);
            if RmpSt ==0
                disp('Already at OSV');
                OSVi = OSV/1000;
                return
            end
            for irmp = 1:RmpN
                OSVi=(OCV-irmp*RmpSt)/1000;
                fprintf(Lia, ['AUXV',num2str(chn),',',num2str(OSVi)]);
                pause(ps);
            end
        end
        
        %%
        function [A,P] = readAPsens(obj,tCon)
            LIA = obj.instR;
            pause(tCon/1000)
            ovI =str2double(query(LIA, 'lias?0'));
            ovT =str2double(query(LIA, 'lias?1'));
            ovOP =str2double(query(LIA, 'lias?2'));
            unlok =query(LIA, 'lias?3');
            while ovI==1
                disp('Input Overload');
                ovI =str2double(query(LIA, 'lias?0'));
            end
            while ovOP ==1
                ssi = str2double(query(LIA, 'SENS ?'));
                disp(['Increasing LIA sensitivity level: ',num2str(ssi)]);
                fprintf(LIA, ['SENS ',num2str(ssi+1)]);
                pause(1.5);
                ovOP =str2double(query(LIA, 'lias?2'));
            end
            while ovT ==1
                disp('Time Constant Overload');
                ovT =str2double(query(LIA, 'lias?1'));
            end
            while str2double(unlok) == 1
                disp('LIA Unlocked')
                pause(tCon/1000)
                unlok = query(LIA, 'lias?3');
                
            end
            data2 = query(LIA, 'SNAP?3,4');
            ind = strfind(data2,',');
            A = str2double(data2(1:ind-1));
            P = str2double(data2(ind+1:end));
        end
        %% Sweep and read
        function data=sweepandread(obj,GTsg,SDsg,directn)
            mx=obj.refreQ*1e-6;
            sF = GTsg.sF;
            eF = GTsg.eF;
            dF = SDsg.dF;
            
            N = round(abs(eF-sF)/dF);
            
            if directn < 0
                [eF,sF] = deal(sF,eF);
            end
            
            if sF>eF
                dF = -dF;
            end
            F=sF-dF;
            
            data(N) = struct();
            for i=0:N
                F =F+dF;
                mF = F-mx;
                GTsg.setFreq(F,0)
                SDsg.setFreq(mF)
                if i == 0
                    [A,P]=obj.readAPsens(3000);
                end
                [A,P]=obj.readAPsens(500);
                data(i+1).Freq=F;
                data(i+1).Amp=A;
                data(i+1).Phs=P;
                figure(2);hold on;
                yyaxis left
                plot(F,A*1e9,'ob','MarkerSize',1.5);
                yyaxis right
                plot(F,P,'sr','MarkerSize',2);hold off;
            end
            
        end
        %% Close
        function close(obj)
            fclose(obj.instR);
        end
    end
end