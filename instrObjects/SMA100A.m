classdef SMA100A
    properties
        address;
        instR;
        sF;
        eF;
        dF;
        rampSteps;
        rampPS;
    end
    
    methods
        function obj=SMA100A(address,sF,eF,dF,rampSteps,rampPS)
            inst = instrfind('Type', 'visa-tcpip', 'RsrcName', ['TCPIP0::',address,'::inst0::INSTR'], 'Tag', '');
            if isempty(inst)
                inst = visa('NI', ['TCPIP0::',address,'::inst0::INSTR']);
            else
                fclose(inst);
                inst = inst(1);
            end
            fopen(inst);
            obj.instR = inst;
            obj.sF=sF;
            obj.eF=eF;
            obj.dF=dF;
            obj.rampSteps=rampSteps;
            obj.address = address;
            obj.rampPS = rampPS;
        end
        %% V Ramp
        function rampV(obj,setV)
            SMA = obj.instR;
            ps = obj.rampPS;
            RmpN = obj.rampSteps;
            if setV ==0
                setV = 1;
            end
            OCV = str2double(query(SMA, ':sour:pow:lev?'))*1000;
            RmpSt =(OCV-setV)/RmpN;
            if RmpSt ==0
                disp('Already at OSV');
                setVc = setV;
                return
            end
            for irmp = 1:RmpN
                setVc=(OCV-irmp*RmpSt)/1000;
                Vstr =  [':pow ',num2str(setVc)];
                fprintf(SMA, Vstr);
                pause(ps)
            end
            setVc = setVc*1000;
        end
        %% Set Freq
        function setFreq(obj,frq,phs)
            % Freq in MHz
            % Phase in Rad
            if nargin == 2
                phs = 0;
            end
            fprintf(obj.instR, ['FREQ ',num2str(frq,'%.8f'),' MHz; PHAS ',num2str(phs),';']);
        end
        
        %% Close
        function close(obj)
            fclose(obj.instR);
        end
        
    end
end