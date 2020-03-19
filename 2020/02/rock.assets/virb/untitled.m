function [rt,rtheta]=untitled(alpha,T,tg,ag)
p=2*pi/T;
init=zeros(2,1);
option=odeset('Events',@EventsFcn);
option2=odeset('MaxStep',0.025,'RelTol',1e-8,'AbsTol',1e-12);
[rt,rtheta]=ode45(@wffc,[min(tg),max(tg)],init,option2);

    function dy=wffc(t,y)
        % ϵͳ΢�ַ�����
        dy=zeros(2,1);
        ag_t=interp1(tg,ag,t,'linear'); %�������Բ�ֵ����ȡ��Ӧʱ��ĵ�����ٶ�ֵ
        %΢�ַ�����
        %�����鴦�ھ�ֹ״̬ʱ��������ˮƽ���ٶ�̫С�����޷��÷����˶���
        if (abs(y(1))<1e-8)&&(abs(y(2))<1e-8)&&(abs(ag_t)<tan(alpha))
            dy(1)=0;
            dy(2)=0;
            sgn=0;
            t
        else
            sgn=sign(y(1));
            dy(1)=y(2);
            dy(2)=-p^2*(sin(alpha*sgn-y(1))+(ag_t)*cos(alpha*sgn-y(1)));
        end
%        if sgn*lastVelDirection==-1
           
%            plot(t,dtheta(1),'.');
%            hold on;
%             dtheta(1)=dtheta(1)*(1-1.5*(sin(alpha))^2);
%             plot(t,dtheta(1),'*');
%        end
%         lastVelDirection=sgn;
    end

    function [value,isterminal,direction]=EventsFcn(t,y)
       value=y(1);
       isterminal=1;
       direction=0;
    end
end


