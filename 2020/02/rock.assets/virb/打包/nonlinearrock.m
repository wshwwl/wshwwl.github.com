function nonlinearrock(alpha,p)
    p=2;alpha=deg2rad(15);
    ap=0.315034034;
    omega=pi;    tstop=2;
    tg=0:0.1:10; tcos=0:0.1:tstop;
    ag=zeros(1,length(tg));
    ag(1:length(tcos))=ap*cos(omega*tcos);
    subplot(3,3,3)
    plot(tg,ag); xlabel('time(s)');ylabel('Âö³å·ùÖµ(g)');title(['A=',num2str(ap,9),'g']);grid on;

    %%%
    tspan=[0,10];
    inity=[0,0];
    option=odeset('RelTol',1e-8,'AbsTol',1e-10,'Events',@EventFcn);
    while tspan(1)<tspan(end)
        [rt_temp,ry_temp,te,ye,ie]=ode45(@wffc,tspan,inity,option);
        subplot(3,3,6);plot(rt_temp,ry_temp(:,1)/alpha,'black');hold on;
        subplot(3,3,9);plot(rt_temp,ry_temp(:,2),'r'); hold on;
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
    subplot(3,3,6);xlabel('time(s)');ylabel('\theta/\alpha');hold off;grid on;
    subplot(3,3,9);xlabel('time(s)');ylabel('\theta''');hold off;grid on;
    
    function dy=wffc(t,y)
        dy=zeros(2,1);
        sgn=sign(y(1));
        if sgn==0
            sgn=sign(y(2));
        end
        dy(1)=y(2);
        if t<=tstop
            dy(2)=-p^2*(sin(alpha*sgn-y(1))+ap*cos(omega*t)*cos(alpha*sgn-y(1)));
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


