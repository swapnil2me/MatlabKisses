function [RVgDC,RVgAC,RVsAC,LIA] = getInstRObjs(pastConf)
RmpN= 200;
ps = 0.005;
%% VGDC
switch pastConf.InstR{1}{pastConf.InstR_selection(1)}
    case 'KT26'
        RVgDC=SMA100A(pastConf.IpS{4},pastConf.Arv(4,1),pastConf.Arv(4,3),pastConf.Arv(4,2),RmpN,ps);
        disp('VgDC : KT26');
    case 'LIA'
        RVgDC =SRS830(str2double(pastConf.IpS{1}),pastConf.Arv(5,1));
        disp('VgDC : LIA');
end
%% VGAC
switch pastConf.InstR{2}{pastConf.InstR_selection(2)}
    case 'SMA'
        RVgAC=SMA100A(pastConf.IpS{2},pastConf.Arv(4,1),pastConf.Arv(4,3),pastConf.Arv(4,2),RmpN,ps);
        disp('VgAC : SMA');
end
%% VSAC
switch pastConf.InstR{3}{pastConf.InstR_selection(3)}
    case 'SMA'
        RVsAC=SMA100A(pastConf.IpS{3},pastConf.Arv(4,1),pastConf.Arv(4,3),pastConf.Arv(4,2),RmpN,ps);
        disp('VsAC : SMA');
end
%% LIA
switch pastConf.InstR{4}{pastConf.InstR_selection(4)}
    case 'SRS830'
        LIA = SRS830(str2double(pastConf.IpS{1}),pastConf.Arv(5,1));
        disp('LIA : srs');
end

end