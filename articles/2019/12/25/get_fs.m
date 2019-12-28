function [fs] = get_fs(fmax)
%GET_FS 确定采样频率
    forder=10^(floor(log10(fmax)));
    fs=fmax/forder;
    fint=[1,2,2.5,4,5,8];
    for i=1:length(fint)
       if fs<=fint(i) 
           fs=fint(i);
           break;
       end   
    end
    fs=2*fs*forder;
    if fs<50
        fs=50;
    end
end

