close all; clear all; clc;
dim = 13;
unT = 1;

xLow = -44.6;
yLow = -43.3;
map = jet;
for i=1:13
    
    for j = 1:13
        
        rectangle('Position',[xLow+(i-1)*unT yLow+(j-1)*unT unT unT],...
            'FaceColor',map(mod(j,64),:))
        
    end
    
end