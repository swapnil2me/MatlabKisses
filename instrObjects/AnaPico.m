classdef AnaPico
    properties
        address;
        instR;
        sF;
        eF;
        dF;
        rampSteps;
        rampPS;Attn;
    end
    
    methods
        function obj=AnaPico(address,sF,eF,dF,rampSteps,rampPS)
            AcPc = instrfind('Type', 'visa-tcpip', 'RsrcName', ['TCPIP0::',address,'::inst0::INSTR'], 'Tag', '');
            if isempty(AcPc)
                AcPc = visa('NI', ['TCPIP0::',address,'::inst0::INSTR']);
            else
                fclose(AcPc);
                AcPc = AcPc(1);
            end
            set(AcPc, 'InputBufferSize', 2048);
            set(AcPc, 'OutputBufferSize', 2048);
            set(AcPc, 'EOSMode', 'read&write');
            % Connect to instrument object, obj1.
            fopen(AcPc);
            fprintf(AcPc, 'UNIT:POW V');
            obj.instR = AcPc;
            obj.sF=sF;
            obj.eF=eF;
            obj.dF=dF;
            obj.rampSteps=rampSteps;
            obj.address = address;
            obj.rampPS = rampPS;
        end
        %% V Ramp
        function rampV(obj,setV)
            AcPc = obj.instR;
            isOptOn= str2num(query(AcPc, ':OUTP:STAT? '));
            if ~isOptOn
                fprintf(AcPc, ':sour:pow:lev:imm:ampl 0.001');
                fprintf(AcPc, ':OUTP:STAT ON');
            end
            outV = str2num(query(AcPc, ':sour:pow:lev?'))*1000;
            ps = obj.rampPS;
            RmpN = obj.rampSteps;
            if setV ==0
                setV = 1;
            end
            RmpSt =(outV-setV)/RmpN;
            if RmpSt ==0
                disp('Already at OSV');
                setVc = setV;
                return
            end
            for irmp = 1:RmpN
                setVc=(outV-irmp*RmpSt)/1000;
                Vstr =  [':sour:pow:lev:imm:ampl ',num2str(setVc)];
                fprintf(AcPc, Vstr);
                pause(ps)
            end
            setVc = setVc*1000;
        end
        %% Set Freq
        function setFreq(obj,frq)
            % Freq in MHz
            % Phase in Rad
%             if nargin == 2
%                 phs = 0;
%             end
            fprintf(obj.instR, ['freq ',num2str(frq.*1e6,'%.8f')]);
        end
        
        %% Close
        function close(obj)
            fclose(obj.instR);
        end
        
    end
end