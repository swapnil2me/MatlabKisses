function freq_list = freq_list_for_sweep(sF,eF,peaks,peak_resolution,step_big,step_small)

peakI = peaks - peak_resolution/2 * step_small;
peakF = peaks + peak_resolution/2 * step_small;

j=1;
freqIM=[];
for i=1:length(peaks)
    freqP(i,:) = [peakI(i):step_small:peakF(i)];
    
    if i>1
        if freqP(i-1,end)<freqP(i,1)
            freqIM(j,:) = freqP(i-1,end):step_big:freqP(i,1);
            j=j+1;
        end
    end
end

freqS = sF:step_big:min(peaks);
freqE = max(peaks):step_big:eF;


freq_list = unique(sort([freqS,reshape(freqP,1,[]),reshape(freqIM,1,[]),freqE],'ascend'))';
end