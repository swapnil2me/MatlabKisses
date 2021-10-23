clear all;close all
mapF1 = brewermap(120,'RdGy');
map1 = mapF1(1:40,:);
map2 = mapF1(80:120,:);
mapF = [map1;map2];
% mapF = brewermap(30,'YlGnBu');
[a,b,c] =  uigetfile('*.csv','MultiSelect','on');

foldName = b;
fnum = length(a);
dt = readtable([foldName,'/',a{1}]);
fs = dt.Freq(1);
fe = dt.Freq(end);


[a_bkg,b_bkg,c_bkg] =  uigetfile('*.csv','MultiSelect','on');
if a_bkg ~= 0
    foldName_bkg = b_bkg;
    dt_bkg = readtable([foldName_bkg,'/',a_bkg]);
    dt_bkg.X = dt_bkg.Amp.*cosd(dt_bkg.Phs);
    dt_bkg.Y = dt_bkg.Amp.*sind(dt_bkg.Phs);
    freqBool = dt_bkg.Freq >= fs & dt_bkg.Freq <= fe;
    xBkg = dt_bkg.X(freqBool);
    yBkg = dt_bkg.Y(freqBool);%(dt_bkg.Freq >= 108)
else
    xBkg = 0;
    yBkg = 0;
end

freqN = length([dt.Freq])
freqData = zeros(freqN,fnum);
ampData = zeros(freqN,fnum);
phsData = zeros(freqN,fnum);
xData = zeros(freqN,fnum);
yData = zeros(freqN,fnum);
vs = zeros(1,fnum);

for i = 1:fnum
    fname = a{i};
    strk_ind = strfind(fname,'V_VgDC');
    dt = readtable([foldName,'/',fname]);
    dt.X = dt.Amp.*cosd(dt.Phs);
    dt.Y = dt.Amp.*sind(dt.Phs);
    freqData(:,i) = dt.Freq;
    xData(:,i) = dt.X-xBkg;
    yData(:,i) = dt.Y-yBkg;
    vs(i) = str2double(fname(1:strk_ind-1));
end

f = figure(1);
f.Position=[493 565 560 420];
for i = 1:fnum
    x = freqData(:,i);
    z_x = xData(:,i);
    z_y = yData(:,i);
    y = zeros(size(x)) + vs(i);
    ampData(:,i) = log(sqrt(z_x.^2+z_y.^2));
    phsData(:,i) = atan2(z_y,z_x);
    plot3(x,y,ampData(:,i),'Color','k');hold on
end
view([0,89.4])

f = figure(2);
f.Position=[493 74 560 420];
for i = 1:fnum
    x = freqData(:,i);
    y = zeros(size(x)) + vs(i);
    plot3(x,y,phsData(:,i),'Color','k');hold on
end
view([0,89.4])

f = figure(3);
f.Position=[1088 565 560 420];
imagesc(vs,x,ampData)
colormap(mapF(end:-1:1,:));set(gca,'Ydir','normal')
c=colorbar;

f = figure(4);
f.Position=[1090 71 560 420];
imagesc(vs,x,phsData)
colormap(mapF(1:1:end,:));set(gca,'Ydir','normal')
c=colorbar;

