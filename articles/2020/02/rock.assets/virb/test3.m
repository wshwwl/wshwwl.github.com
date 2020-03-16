clear all ;
s=load('ag.mat');
ag=s.a4;
dt=0.025;
tg=0:dt:dt*length(ag)-dt;
index=tg>=3&tg<=13;
tg=tg(index)-3;
ag=ag(index);
% figure(1)
% plot(tg,ag)
% grid on
% hold on
%%
alpha=0.1:0.1:0.3;
T=1:1:8;
p=2*pi./T;
sd=zeros(length(alpha),length(T));
sv=zeros(length(alpha),length(T));
tic
for i=1:length(alpha)
    i
    index=find(abs(ag)>tan(alpha(i)),1);
    sgn=sign(ag(index));
    if index==1
        tgtrig=tg(1);
        index=2;
    else
        tgtrig=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha(i)));
    end
     for j=1:length(T)
        j
        rst=zeros(length(tg),2);
        initt=tgtrig;inity=[0,0];
        interIndex=index;
        while initt<tg(end)
            [rt_temp,ry_temp,te,ye,ie]=testrock(alpha(i),T(j),tg,ag,[initt,tg(interIndex)],inity);
%             plot(rt_temp,ry_temp,'black');
            if rt_temp(end)==tg(interIndex)
                inity=ry_temp(end,:);
                rst(interIndex,:)=inity;
                initt=tg(interIndex);
                interIndex=interIndex+1;
                continue;
            end
            if ie==1
                inity=ye;
                inity(2)=inity(2)*(1-1.5*(sin(alpha(i)))^2);
                initt=te;
                if abs(inity(2))<1e-6
                    inity=[0,0];
                    indexTemp=find(abs(ag(interIndex:end))>tan(alpha(i)),1);
                    if ~isempty(indexTemp)
                        interIndex=interIndex+indexTemp-1;
                        sgn=sign(ag(interIndex));
                        initt=interp1([ag(interIndex-1),ag(interIndex)],[tg(interIndex-1),tg(interIndex)],sgn*tan(alpha(i)));            
                    else
                        break
                    end
                end
                continue;
            end
            if ie==2
                rst(interIndex,:)=ye;
                break;
            end
        end
        
        sd(i,j)=max(abs(rst(:,1)))/alpha(i);
        sv(i,j)=max(abs(rst(:,2)))/p(j);
    end
end
surf(T,alpha,sd)
toc
% plot(tg,rst)