function [t,envelope] = GetEnvelope(fs,TotalTime,risePeriod,stablePeriod,descendPara)
%ENVELOPE 此处显示有关此函数的摘要

dt=1/fs;
t=0:dt:TotalTime;
ntd=length(t);
T1=risePeriod;
T2=risePeriod+stablePeriod;
envelope=zeros(1,length(t));
for i=1:ntd
    if t(i)<=T1
        envelope(i)=(t(i)/T1)^2;
    else
        if t(i)>T1 && t(i)<=T2 
            envelope(i)=1;
        else 
            if t(i)>T2
                envelope(i)=exp(-descendPara*(t(i)-T2));
            end
        end
    end
end
end

