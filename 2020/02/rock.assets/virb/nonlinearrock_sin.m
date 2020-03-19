function nonlinearrock_sin(alpha,p)

p=2.14; %�������p
alpha=0.25; %�������alpha
ap=2.93*alpha; %���Ǻ�����ֵ,���ﲻ��Ҫ����g����Ϊ����΢�ַ������Ѿ�������g��
omega=5*p; %���Ǻ������ٶ�
tstop=2*pi/omega; %��/����������ֹʱ��
tg=0:0.01:6; %ȫ������ʱ��
ag=zeros(1,length(tg)); %��ʼ�����룬ȫΪ0��
tsin=0:0.01:tstop; %�������������ʱ���
ag(1:length(tsin))=ap*sin(omega*tsin); %���������ҵ����븲�ǵ���ʼ������ȥ
subplot(3,1,1)
plot(tg,ag)

tstart=asin(tan(alpha)/ap)/omega; %��ʼ����ʱ�̣���ʱ������ķ�ֵ����ap*sin(omega*t)=tan(alpha),��������ң����ʱ��Ϊ0������֮ǰд����0.
inity=[0,0];
option=odeset('RelTol',1e-8,'AbsTol',1e-10,'Events',@EventFcn);
tspan=[tstart,2];
while tspan(1)<tspan(end)
    [rt_temp,ry_temp,te,ye,ie]=ode45(@wffc,tspan,inity,option);
    subplot(3,1,2);plot(rt_temp,ry_temp(:,1)/alpha,'black');hold on;
    subplot(3,1,3);plot(rt_temp,ry_temp(:,2)/p,'r');hold on;
    if isempty(ie)
        break;
    end
    if ie(end)==1
        inity=ye(end,:);
        inity(2)=inity(2)*(1-1.5*(sin(alpha))^2);
        tspan=[te(end),tspan(end)];
        if abs(inity(2))<1e-6
            break;
        end
        continue;
    end
    if ie(end)==2
        break;
    end
end

    function dy=wffc(t,y)
        t
        dy=zeros(2,1);
        ag_t=ap*sin(omega*t); %���㵱ǰʱ�̵ļ��ٶ�,��������ң����Ϊ����
        sgn=sign(y(1));
        if sgn==0
            sgn=sign(y(2)); %���ƫת�Ƕ�Ϊ0������ݽ��ٶ��жϼ���ƫת�ķ���
            if sgn==0
                sgn=-sign(ag_t); %���ƫת���ٶ�ҲΪ0�����Ե�����ٶȵķ������жϼ���ƫת�ķ���
            end
        end
        dy(1)=y(2);
        if t<=tstop
            dy(2)=-p^2*(sin(alpha*sgn-y(1))+ag_t*cos(alpha*sgn-y(1)));
        else
            dy(2)=-p^2*sin(alpha*sgn-y(1));
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


