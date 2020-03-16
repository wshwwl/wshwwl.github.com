clear all ;
s=load('ag.mat');
ag=s.a4;
dt=0.025;
tg=0:dt:dt*length(ag)-dt;
index=tg>=3&tg<=13;
tg=tg(index)-3;
ag=ag(index);
figure(1)
plot(tg,ag)
grid on
hold on
%%
alpha=0.1:0.01:0.3;
T=1:0.5:8;
p=2*pi./T;
sd=zeros(length(alpha),length(T));
sv=zeros(length(alpha),length(T));
rd=zeros(length(tg),1);
rv=zeros(length(tg),1);
for i=1:length(alpha)
    i
    indext=find(ag>tan(alpha(i)),1);
    tgtrig=interp1([ag(indext-1),ag(indext)],[tg(indext-1),tg(indext)],tan(alpha(i)));
    tg_temp=[tgtrig,tg(indext:end)];
    ag_temp=[tan(alpha(i));ag(indext:end)];
    for j=1:length(T)
        j
        initt=tg_temp(1);inity=[0,0];index=1;
        while initt<tg_temp(end)
            [rt_temp,ry_temp,te,ye,ie]=testrock2(alpha(i),T(j),tg_temp,ag_temp,[initt,tg_temp(index+1)],inity);
%             plot(rt_temp,ry_temp,'black');
            if rt_temp(end)==tg_temp(index+1)
                inity=ry_temp(end,:);
                sd(i,j)=max(sd(i,j),max(abs(ry_temp(:,1))));
                sv(i,j)=max(sv(i,j),max(abs(ry_temp(:,2))));
                initt=tg_temp(index+1);
                index=index+1;
                continue;
            end
            if ie==1
                inity=ye;
                inity(2)=inity(2)*(1-1.5*(sin(alpha(i)))^2);
                initt=te;
                sv(i,j)=max(sv(i,j),max(abs(ye(2))));
                continue;
            end
            if ie==2
                sd(i,j)=max(sd(i,j),max(abs(ry_temp(:,1))));
                sv(i,j)=max(sv(i,j),max(abs(ry_temp(:,2))));
                break;
            end
        end
        
        sd(i,j)=sd(i,j)/alpha(i);
        sv(i,j)=sv(i,j)/p(j);
    end
end



