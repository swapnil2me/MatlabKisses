function turnOnSMA(SMA)
currentState = str2double(query(SMA,':outp:stat?'));

if currentState == 0
    fprintf(SMA,':outp:stat 1');
end

end