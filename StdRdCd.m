clear all;
clc;
a=dlmread('.txt');
b=dlmread('.txt');
c=dlmread('.txt');
d=dlmread('.txt');
e=dlmread('.txt');
f=dlmread('.txt');
g=dlmread('.txt');
h=dlmread('.txt');
i=dlmread('.txt');
j=dlmread('.txt');
k=dlmread('.txt');
l=dlmread('.txt');
m=dlmread('.txt');
n=dlmread('.txt');
o=dlmread('.txt');
p=dlmread('.txt');
q=dlmread('.txt');
r=dlmread('.txt');
s=dlmread('.txt');
t=dlmread('.txt');
hold all;
grid on;
grid minor;
set(gca,'YTickLabel',[]);
plot(a(:,1),a(:,2));
plot(b(:,1),b(:,2));
plot(c(:,1),c(:,2));
plot(d(:,1),d(:,2));
plot(a(:,1),e(:,2));
plot(a(:,1),f(:,2));
plot(a(:,1),g(:,2));
plot(a(:,1),h(:,2));
plot(a(:,1),i(:,2));
plot(a(:,1),j(:,2));
plot(a(:,1),k(:,2));
plot(a(:,1),l(:,2));
plot(a(:,1),m(:,2));
plot(a(:,1),n(:,2));
plot(a(:,1),o(:,2));
plot(a(:,1),p(:,2));
plot(a(:,1),q(:,2));
plot(a(:,1),r(:,2));
legend('Bulk MoS2 Wos ','Bulk MoS2 WS');%,
title('\fontsize{16} Efferct on strain on bulk MoS2 on Su8 substrate')
xlabel('Energy (eV)','FontSize',12,'FontWeight','bold') 
xlabel('Raman Shift','FontSize',12,'FontWeight','bold')
ylabel('Intensity (cnt)','FontSize',12,'FontWeight','bold')