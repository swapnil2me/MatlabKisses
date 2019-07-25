function [rmS, peaK, meaN, sD]=readPOWesa(ESA, uniT, centF, spaN, banD, tc)
%% Code Info
% Reading Power at centF (MHz)
% with span of spaN (Hz)
% with band width of banD (kHz)
% with sweep time of tc (micro seconds)
% Swapnil 3-10-2018
%% Set Fer Level
    fprintf(ESA, 'UNIT:POW DBM')
    fprintf(ESA, 'DISP:WIND:TRAC:Y:RLEV 0dBm')
%% Read Values
    fprintf(ESA, ['UNIT:POW ',uniT]);
    fprintf(ESA, 'SYST:DISP:UPD ON');

    fprintf(ESA, ['FREQ:CENT ',num2str(centF),'MHz;SPAN ',num2str(spaN),'Hz']);

    fprintf(ESA, ['BAND:RES ',num2str(banD),'kHz']);
    fprintf(ESA, ['SWE:TIME ',num2str(tc),'US']);
    fprintf(ESA, 'CALC:MARK:FUNC:SUMM:PPE ON');
    fprintf(ESA, 'CALC:MARK:FUNC:SUMM:MEAN ON');
    fprintf(ESA, 'CALC:MARK:FUNC:SUMM:RMS ON');
    fprintf(ESA, 'CALC:MARK:FUNC:SUMM:SDEV ON');
    pause(tc/1000);
    peaK = str2double(query(ESA, 'CALC:MARK:FUNC:SUMM:PPE:RES?'));

    meaN = str2double(query(ESA, 'CALC:MARK:FUNC:SUMM:MEAN:RES?'));
    rmS = str2double(query(ESA, 'CALC:MARK:FUNC:SUMM:RMS:RES?'));
    sD = str2double(query(ESA, 'CALC:MARK:FUNC:SUMM:SDEV:RES?'));



end