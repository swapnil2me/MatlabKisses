%%%Sorting Algorithm%%%
clc
clear all
a=input('enter the number in []: ');
n=length(a);
for j=2:n
    key=a(j);
    i=j-1;
    while i >= 1
        if a(i)>key
            a(i+1)=a(i);
            a(i)=key;
            i=i-1;
        else
            i=i-1;
        end
    end
end
a;