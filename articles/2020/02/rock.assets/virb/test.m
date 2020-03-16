clear all ;
s=load('ag.mat');
ag=s.a4;
dt=0.025;
tg=0:dt:dt*length(ag)-dt;
index=tg>=3&tg<=13;
tg=tg(index)-3;
ag=ag(index);

alpha=0.1;
T=2;

index=find(abs(ag)>tan(alpha),1);
sgn=sign(ag(index));
if index==1
    tgtrig=tg(1);
else
    tgtrig=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));
end
%% 
% [rt,ry]=testrock(alpha,T,tg,ag,[tgtrig,tg(end)],[0,0]);
% plot(rt,ry(:,1));
% hold on
%%
% figure(1)
% plot(tg,ag);
%%
% startIndex=index-1;
% if startIndex==0
%     startIndex=1;
% end
% rt2=tg;
% ry2=zeros(length(rt2),2);
% initt=tgtrig;
% inity=[0,0];
% for i=startIndex:length(tg)-1
%    [rt_temp,ry_temp]=testrock(alpha,T,tg,ag,[initt,tg(i+1)],inity); 
%    inity=ry_temp(end,:);
%    ry2(i+1,:)=inity;
%    initt=tg(i+1);
% end
% plot(rt2,ry2(:,1));

%%
% tic
% index=find(abs(ag)>tan(alpha),1);
% sgn=sign(ag(index));
% if index==1
%     tgtrig=tg(1);
% else
%     tgtrig=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));
% end
% rt2=tg;
% ry2=zeros(length(rt2),2);
% inity=[0,0];
% initt=tgtrig;
% startIndex=index-1;
% if startIndex==0
%     startIndex=1;
% end
% while initt<tg(end)
%     [rt_temp,ry_temp,te,ye,ie]=testrock(alpha,T,tg,ag,[initt,tg(startIndex+1)],inity);
%     subplot(2,1,1);plot(rt_temp,ry_temp(:,1),'black');hold on;
%     subplot(2,1,2);plot(rt_temp,ry_temp(:,2),'r');hold on;
%     if rt_temp(end)==tg(startIndex+1)
%         inity=ry_temp(end,:);
%         ry2(startIndex+1,:)=inity;
%         initt=tg(startIndex+1);
%         startIndex=startIndex+1;
%         continue;
%     end
%     if ie==1
%         inity=ye;
%         inity(2)=inity(2)*(1-1.5*(sin(alpha))^2);
%         initt=te;
%         if abs(inity(2))<1e-6
%             inity=[0,0];
%         end
%         continue;
%     end
%     if ie==2
%         ry2(startIndex+1,:)=ye;
%         break;
%     end
% end
% plot(rt2,ry2);
% hold on;
% toc
%% 3
tic
% figure(2)
index=find(abs(ag)>tan(alpha),1);
sgn=sign(ag(index));
if index==1
    tgtrig=tg(1);
else
    tgtrig=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));
end
rt3=tg;
ry3=zeros(length(rt3),2);
inity=[0,0];
initt=tgtrig;
startIndex=index-1;
if startIndex==0
    startIndex=1;
end
while initt<tg(end)
    [rt_temp,ry_temp,te,ye,ie]=testrock(alpha,T,tg,ag,[initt,tg(startIndex+1)],inity);
    subplot(2,1,1);plot(rt_temp,ry_temp(:,1)/alpha,'black');hold on;
    subplot(2,1,2);plot(rt_temp,ry_temp(:,2),'y');hold on;
    if rt_temp(end)==tg(startIndex+1)
        inity=ry_temp(end,:);
        ry3(startIndex+1,:)=inity;
        initt=tg(startIndex+1);
        startIndex=startIndex+1;
        continue;
    end
    if ie==1
        inity=ye;
        inity(2)=inity(2)*(1-1.5*(sin(alpha))^2);
        initt=te;
        if abs(inity(2))<1e-6
            inity=[0,0];
            index=find(abs(ag(startIndex+1:end))>tan(alpha),1);
            if ~isempty(index)
                startIndex=startIndex+index-1;
                sgn=sign(ag(startIndex+1));
                initt=interp1([ag(startIndex),ag(startIndex+1)],[tg(startIndex),tg(startIndex+1)],sgn*tan(alpha));            
            else
                break;
            end
        end
        continue;
    end
    if ie==2
        ry3(startIndex+1,:)=ye;
        break;
    end
end
% plot(rt3,ry3(:,1),'g');
% hold on;
toc
%% 4 
tic
index=find(abs(ag)>tan(alpha),1);
sgn=sign(ag(index));
if index==1
    tgtrig=tg(1);
else
    tgtrig=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));
end
inity=[0,0];
initt=tgtrig;
while initt<tg(end)
    [rt_temp,ry_temp,te,ye,ie]=testrock(alpha,T,tg,ag,[initt,tg(end)],inity);
    subplot(2,1,1);plot(rt_temp,ry_temp(:,1)/alpha,'black');hold on;
    subplot(2,1,2);plot(rt_temp,ry_temp(:,2),'r');hold on;
    if isempty(ie)
        break
    end
    if ie(end)==1
        inity=ye(end,:);
        inity(2)=inity(2)*(1-1.5*(sin(alpha))^2);
        initt=te(end);
        if abs(inity(2))<1e-6
            inity=[0,0];
            currentIndex=find(tg>initt,1)-1;
            nextIndex=find(abs(ag(currentIndex+1:end))>tan(alpha),1);
            if ~isempty(nextIndex)
                nextIndex=currentIndex+nextIndex-1;
                sgn=sign(ag(nextIndex+1));
                initt=interp1([ag(nextIndex),ag(nextIndex+1)],[tg(nextIndex),tg(nextIndex+1)],sgn*tan(alpha));            
            else
                break;
            end
        end
        continue;
    end
    if ie(end)==2
%         ry3(startIndex+1,:)=ye(end,:);
        break;
    end
end
toc