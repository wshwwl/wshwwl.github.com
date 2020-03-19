function [sr,sv,su,rri,rvi,rui]=rock3(alphaList,TList,tg,ag)
% 求解地震波输入下的响应谱
% alphaList：为一列刚体的alpha数组
% TList：    为一列刚体的T数组
% tg：       地震波时间列
% ag：       地震波幅值列
g=9.81;
pList=2*pi./TList;
sr=zeros(length(alphaList),length(TList));
sv=zeros(length(alphaList),length(TList));
su=zeros(length(alphaList),length(TList));

%%%%%%%% 循环求解,花费时间较长
    for i=1:length(alphaList)
        i
         for j=1:length(TList)
            ry=rock(alphaList(i),TList(j));     %求解得到每一组alpha、T参数下的响应
            rmax=max(abs(ry));          %求得响应的绝对值的最大值
            sr(i,j)=rmax(1)/alphaList(i);   %存储最大角度响应
            sv(i,j)=rmax(2)/pList(j);       %存储最大角速度响应
            su(i,j)=3*g*(TList(j)^2)*(sin(alphaList(i))-sin(alphaList(i)-rmax(1)))/8/pi/pi; %存储最大位移响应
        end
    end
%%%%%%%%计算积分    
    rri=0;
    for i=1:length(alphaList)-1
        for j=1:length(TList)-1
            rri=rri+(alphaList(i+1)-alphaList(i))*(TList(j+1)-TList(j))*(sr(i,j)+sr(i+1,j)+sr(i,j+1)+sr(i+1,j+1))/4;
        end
    end
    rvi=0;
    for i=1:length(alphaList)-1
        for j=1:length(TList)-1
            rvi=rvi+(alphaList(i+1)-alphaList(i))*(TList(j+1)-TList(j))*(sv(i,j)+sv(i+1,j)+sv(i,j+1)+sv(i+1,j+1))/4;
        end
    end
    rui=0;
    for i=1:length(alphaList)-1
        for j=1:length(TList)-1
            rui=rui+(alphaList(i+1)-alphaList(i))*(TList(j+1)-TList(j))*(su(i,j)+su(i+1,j)+su(i,j+1)+su(i+1,j+1))/4;
        end
    end
    
    %子函数：求解单组参数在地震下的响应
    function [ry]=rock(alpha,T)
        p=2*pi/T;
        ry=zeros(length(tg),2);
        index=find(abs(ag)>tan(alpha),1);
        if isempty(index)
            return;
        end
        sgn=sign(ag(index));
        if index==1
            tgtrig=tg(1);
            index=2;
        else
            tgtrig=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));
        end
        %% 求解
        tstart=tgtrig;
        inity=[0,0];
        option=odeset('MaxStep',0.025,'RelTol',1e-8,'AbsTol',1e-10,'Events',@EventFcn);
        while tstart<tg(end)
            [rt_temp,ry_temp,te,ye,ie]=ode45(@wffc,[tstart,tg(index)],inity,option);
        %     subplot(2,1,1);plot(rt_temp,ry_temp(:,1)/alpha,'r');hold on;
        %     subplot(2,1,2);plot(rt_temp,ry_temp(:,2),'r');hold on;
            ry(index,:)=max([ry(index,:);abs(ry_temp)]);
            if rt_temp(end)==tg(index)
                inity=ry_temp(end,:);
                tstart=tg(index);
                index=index+1;
                continue;
            end
            if ie(end)==1
                inity=ye(end,:);
                inity(2)=inity(2)*(1-1.5*(sin(alpha))^2);
                tstart=te(end);
                if abs(inity(2))<1e-6
                    inity=[0,0];
                    nextIndex=find(abs(ag(index:end))>tan(alpha),1);
                    if ~isempty(nextIndex)
                        index=index+nextIndex-1;
                        sgn=sign(ag(index));
                        tstart=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));  
                    else
                        break;
                    end
                end
                continue;
            end
            if ie==2
                break;
            end
        end

    %% 微分方程
        function dy=wffc(t,y)
            dy=zeros(2,1);
            ag_t=interp1(tg,ag,t,'linear'); %根据线性插值，获取对应时间的地震加速度值
            %微分方程组
            if (abs(y(1))==0)&&(abs(y(2))==0)&&(abs(ag_t)<tan(alpha))
                dy(1)=0;
                dy(2)=0;
            else
                sgn=sign(y(1));
                dy(1)=y(2);
                dy(2)=-p^2*(sin(alpha*sgn-y(1))+ag_t*cos(alpha*sgn-y(1)));
            end
        end

        function [value,isterminal,direction]=EventFcn(~,y)
            value(1)=y(1);
            isterminal(1)=1;
            direction(1)=0;

            value(2)=abs(y(1))-alpha;
            isterminal(2)=1;
            direction(2)=1;
        end
    end
end


