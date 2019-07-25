function [rmS, peaK, meaN, sD]=readPOWesaInstant(ESA, uniT,tc)
if nargin == 2
    tc=0;
end
pause(tc/1000);
fprintf(ESA, ['UNIT:POW ',uniT]);
peaK = str2double(query(ESA, 'CALC:MARK:FUNC:SUMM:PPE:RES?'));
if strcmp(uniT,'VOLT')
    facT=1000;
else
    facT=1;
end
    meaN =facT* str2double(query(ESA, 'CALC:MARK:FUNC:SUMM:MEAN:RES?'));
    rmS =facT* str2double(query(ESA, 'CALC:MARK:FUNC:SUMM:RMS:RES?'));
    sD =facT* str2double(query(ESA, 'CALC:MARK:FUNC:SUMM:SDEV:RES?'));
end