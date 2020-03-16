function [rt,ry]=rock1(alpha,T,tg,ag)
% 求解参数为alpha、T的刚体在时间和幅值依次为tg、ag的地震作用下的响应。
% tg\ag:地震波的时间列和幅值列,ag的单位为g。
p=2*pi/T;
rt=tg;                      % 存储时间点
ry=zeros(length(tg),2);     % 用于存储每个时刻的响应结果，含有两列，第一列为角度，第二列为角速度
% 静止状态下，只有当地震加速度的幅值的绝对值abs(ag)>tan(alpha)时，刚体才开始摆动
% 寻找地震波中第一个幅值的绝对值超过tan(alpha)的点的下标index。
index=find(abs(ag)>tan(alpha),1); 
if isempty(index)
    return;
end
sgn=sign(ag(index));    %该值是正还是负
if index==1             %如果第一个值就足够大，则开始计算的时刻则为地震波的第一个时刻 
    tgtrig=tg(1);
    index=2;
else                    %否则，通过插值求得地震幅值等于tan(alpha)的时刻tgtrig.
    tgtrig=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));
end
    
%% 求解
%option:ode45的求解参数设置，RelTol为相对误差，AbsTol为绝对误差。
%Events参数指向一个函数，当函数的值为0时，则触发事件。该函数有两个作用：
% 1.当刚体摇摆方向切换时，中断求解，并将摇摆的角速度乘以一个比例系数。
% 2.当刚体的摇摆角度超过alpha时，认为刚体侵翻，终止计算。
option=odeset('MaxStep',0.025,'RelTol',1e-8,'AbsTol',1e-10,'Events',@EventFcn);
inity=[0,0];                % 计算的初始值
tstart=tgtrig;              % 开始求解的时刻，该时刻起，刚体才开始摆动
while tstart<tg(end)        % 每一步循环求解，每次只求解一个时间段，直到地震波的最后一刻
    %调用ode45进行求解，求解的时间段为[tstart,tg(index)]，该时间段求解完后，index加1，然后循环求解
    % @wffc为待求解的微分方程，该方程有3种可能的终止结果
    % 1：正常结束，完成时间段[tstart,tg(index)]段的求解
    % 2: 由于摇摆方向改变导致终止
    % 3：由于摇摆角度超过alpha导致终止。
    % rt_temp，ry_temp为求解后的时间、幅值
    % te为触发事件时的时间，ye为触发事件时的响应，
    % ie的值指示终止的原因，如果ie=1，则是上方可能2，如果ie=2，则是上方可能3
    [rt_temp,ry_temp,te,ye,ie]=ode45(@wffc,[tstart,tg(index)],inity,option);
    subplot(4,1,2);plot(rt_temp,ry_temp(:,1)/alpha,'r');hold on; %
    subplot(4,1,3);plot(rt_temp,ry_temp(:,2),'r');hold on;
    subplot(4,1,4);plot(rt_temp,3*9.81*(T^2)*(sin(alpha*sign(ry_temp(:,1)))-sin(alpha*sign(ry_temp(:,1))-ry_temp(:,1)))/8/pi/pi,'r');hold on;
    if rt_temp(end)==tg(index)      % ode45正常终止
        ry(index,:)=ry_temp(end,:); % 保存tg(index)时刻的响应
        inity=ry_temp(end,:);       % 该时间段最后时刻的结果作为下一时间段求解的初始值
        tstart=tg(index);           % 下一时间段的起始时刻为tg(index)
        index=index+1;              % 循环开始下一时间段的求解
        continue;
    end
    if ie(end)==1                   % 如果由于摇摆方向改变导致终止
        inity=ye(end,:);            % 下一次求解的初始值为中断求解时的响应
        inity(2)=inity(2)*(1-1.5*(sin(alpha))^2); % 角速度乘以比例系数
        tstart=te(end);             % 下一次求解的初始时间
        if abs(inity(2))<1e-6       % 如果此时角速度小于1e-6,则认为刚体已静止
            inity=[0,0];            % 将下一次的求解初始值设置为0
            nextIndex=find(abs(ag(index:end))>tan(alpha),1); %寻找地震波中下一个幅值超过tan(alpha)的点
            if ~isempty(nextIndex)
                index=index+nextIndex-1;
                sgn=sign(ag(index));
                tstart=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));  
            else                    % 如果找不到，则刚体不会再摆动，计算终止                
                ry(index,:)=ry_temp(end,:);
                break;
            end
        end
        continue;
    end
    if ie==2    % 如果由于摇摆角度超过alpha，则终止计算
        break;
    end
end

%% 微分方程
    function dy=wffc(t,y)
        dy=zeros(2,1); %用于存储计算结果：角度，角速度
        ag_t=interp1(tg,ag,t,'linear'); %根据线性插值，获取对应时间的地震加速度值
        %微分方程组
        %当刚体处于静止状态时，如果地震加速度小于tan(alpha)则不产生摆动
        if (abs(y(1))==0)&&(abs(y(2))==0)&&(abs(ag_t)<tan(alpha))
            dy(1)=0;
            dy(2)=0;
        else   %刚体摆动的微分方程
            sgn=sign(y(1));
            dy(1)=y(2);
            dy(2)=-p^2*(sin(alpha*sgn-y(1))+ag_t*cos(alpha*sgn-y(1)));
        end
    end
    
    % ode45的事件函数，当value=0时触发。
    function [value,isterminal,direction]=EventFcn(~,y)
        value(1)=y(1);      % 事件1：刚体摇摆方向改变，即此时刚体摇摆角度为0
        isterminal(1)=1;    % isterminal为1时，表示该事件的触发会导致求解终止
        direction(1)=0;     % direction为0，表示value上升到0，或者下降到0，都会触发事件
        
        value(2)=abs(y(1))-alpha;   %事件2：刚体摇摆角度超过alpha时，认为刚体倾翻
        isterminal(2)=1;
        direction(2)=1;             % direction为1，表示value上升到0时，才会触发事件
    end
end


