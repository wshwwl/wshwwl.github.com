function [rt,rtheta,te,ye,ie]=testrock(alpha,T,tg,ag,tspan,init)
p=2*pi/T;
option=odeset('MaxStep',0.025,'RelTol',1e-8,'AbsTol',1e-10,'Events',@EventFcn);
[rt,rtheta,te,ye,ie]=ode45(@wffc,tspan,init,option);

    function dy=wffc(t,y)
        dy=zeros(2,1);
        ag_t=interp1(tg,ag,t,'linear'); %�������Բ�ֵ����ȡ��Ӧʱ��ĵ�����ٶ�ֵ
%         ΢�ַ�����
        if (abs(y(1))==0)&&(abs(y(2))==0)&&(abs(ag_t)<tan(alpha))
            dy(1)=0;
            dy(2)=0;
            t
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


