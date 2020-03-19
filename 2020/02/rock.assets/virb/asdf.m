clear all ;
s=load('ag.mat');
ag=s.a4;
dt=0.025;
tg=0:dt:dt*length(ag)-dt;
index=tg>=3&tg<=13;
tg=tg(index)-3;
ag=ag(index);

alpha=0.3;
T=2;
p=2*pi./T;
% for i=1:length(alpha)
%     index=find(ag>tan(alpha),1);
%     tgtrig=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],tan(alpha));
%     tg_temp=[tgtrig,tg(index:end)];
%     ag_temp=[tan(alpha);ag(index:end)];
%     for j=1:length(T)
        [rt,dtheta]=untitled(alpha,T,tg,ag);
%         sd(i,j)=max(abs(dtheta(:,1)))/alpha(i);
%         sv(i,j)=max(abs(dtheta(:,2)))/p(j);
%     end
% end

% surf(T,alpha,sd)
% surf(T,alpha,sv);

plot(rt,dtheta)
hold on