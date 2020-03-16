function [rt,ry]=rock1(alpha,T,tg,ag)
% ������Ϊalpha��T�ĸ�����ʱ��ͷ�ֵ����Ϊtg��ag�ĵ��������µ���Ӧ��
% tg\ag:���𲨵�ʱ���кͷ�ֵ��,ag�ĵ�λΪg��
p=2*pi/T;
rt=tg;                      % �洢ʱ���
ry=zeros(length(tg),2);     % ���ڴ洢ÿ��ʱ�̵���Ӧ������������У���һ��Ϊ�Ƕȣ��ڶ���Ϊ���ٶ�
% ��ֹ״̬�£�ֻ�е�������ٶȵķ�ֵ�ľ���ֵabs(ag)>tan(alpha)ʱ������ſ�ʼ�ڶ�
% Ѱ�ҵ����е�һ����ֵ�ľ���ֵ����tan(alpha)�ĵ���±�index��
index=find(abs(ag)>tan(alpha),1); 
if isempty(index)
    return;
end
sgn=sign(ag(index));    %��ֵ�������Ǹ�
if index==1             %�����һ��ֵ���㹻����ʼ�����ʱ����Ϊ���𲨵ĵ�һ��ʱ�� 
    tgtrig=tg(1);
    index=2;
else                    %����ͨ����ֵ��õ����ֵ����tan(alpha)��ʱ��tgtrig.
    tgtrig=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));
end
    
%% ���
%option:ode45�����������ã�RelTolΪ�����AbsTolΪ������
%Events����ָ��һ����������������ֵΪ0ʱ���򴥷��¼����ú������������ã�
% 1.������ҡ�ڷ����л�ʱ���ж���⣬����ҡ�ڵĽ��ٶȳ���һ������ϵ����
% 2.�������ҡ�ڽǶȳ���alphaʱ����Ϊ�����ַ�����ֹ���㡣
option=odeset('MaxStep',0.025,'RelTol',1e-8,'AbsTol',1e-10,'Events',@EventFcn);
inity=[0,0];                % ����ĳ�ʼֵ
tstart=tgtrig;              % ��ʼ����ʱ�̣���ʱ���𣬸���ſ�ʼ�ڶ�
while tstart<tg(end)        % ÿһ��ѭ����⣬ÿ��ֻ���һ��ʱ��Σ�ֱ�����𲨵����һ��
    %����ode45������⣬����ʱ���Ϊ[tstart,tg(index)]����ʱ���������index��1��Ȼ��ѭ�����
    % @wffcΪ������΢�ַ��̣��÷�����3�ֿ��ܵ���ֹ���
    % 1���������������ʱ���[tstart,tg(index)]�ε����
    % 2: ����ҡ�ڷ���ı䵼����ֹ
    % 3������ҡ�ڽǶȳ���alpha������ֹ��
    % rt_temp��ry_tempΪ�����ʱ�䡢��ֵ
    % teΪ�����¼�ʱ��ʱ�䣬yeΪ�����¼�ʱ����Ӧ��
    % ie��ֵָʾ��ֹ��ԭ�����ie=1�������Ϸ�����2�����ie=2�������Ϸ�����3
    [rt_temp,ry_temp,te,ye,ie]=ode45(@wffc,[tstart,tg(index)],inity,option);
    subplot(4,1,2);plot(rt_temp,ry_temp(:,1)/alpha,'r');hold on; %
    subplot(4,1,3);plot(rt_temp,ry_temp(:,2),'r');hold on;
    subplot(4,1,4);plot(rt_temp,3*9.81*(T^2)*(sin(alpha*sign(ry_temp(:,1)))-sin(alpha*sign(ry_temp(:,1))-ry_temp(:,1)))/8/pi/pi,'r');hold on;
    if rt_temp(end)==tg(index)      % ode45������ֹ
        ry(index,:)=ry_temp(end,:); % ����tg(index)ʱ�̵���Ӧ
        inity=ry_temp(end,:);       % ��ʱ������ʱ�̵Ľ����Ϊ��һʱ������ĳ�ʼֵ
        tstart=tg(index);           % ��һʱ��ε���ʼʱ��Ϊtg(index)
        index=index+1;              % ѭ����ʼ��һʱ��ε����
        continue;
    end
    if ie(end)==1                   % �������ҡ�ڷ���ı䵼����ֹ
        inity=ye(end,:);            % ��һ�����ĳ�ʼֵΪ�ж����ʱ����Ӧ
        inity(2)=inity(2)*(1-1.5*(sin(alpha))^2); % ���ٶȳ��Ա���ϵ��
        tstart=te(end);             % ��һ�����ĳ�ʼʱ��
        if abs(inity(2))<1e-6       % �����ʱ���ٶ�С��1e-6,����Ϊ�����Ѿ�ֹ
            inity=[0,0];            % ����һ�ε�����ʼֵ����Ϊ0
            nextIndex=find(abs(ag(index:end))>tan(alpha),1); %Ѱ�ҵ�������һ����ֵ����tan(alpha)�ĵ�
            if ~isempty(nextIndex)
                index=index+nextIndex-1;
                sgn=sign(ag(index));
                tstart=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));  
            else                    % ����Ҳ���������岻���ٰڶ���������ֹ                
                ry(index,:)=ry_temp(end,:);
                break;
            end
        end
        continue;
    end
    if ie==2    % �������ҡ�ڽǶȳ���alpha������ֹ����
        break;
    end
end

%% ΢�ַ���
    function dy=wffc(t,y)
        dy=zeros(2,1); %���ڴ洢���������Ƕȣ����ٶ�
        ag_t=interp1(tg,ag,t,'linear'); %�������Բ�ֵ����ȡ��Ӧʱ��ĵ�����ٶ�ֵ
        %΢�ַ�����
        %�����崦�ھ�ֹ״̬ʱ�����������ٶ�С��tan(alpha)�򲻲����ڶ�
        if (abs(y(1))==0)&&(abs(y(2))==0)&&(abs(ag_t)<tan(alpha))
            dy(1)=0;
            dy(2)=0;
        else   %����ڶ���΢�ַ���
            sgn=sign(y(1));
            dy(1)=y(2);
            dy(2)=-p^2*(sin(alpha*sgn-y(1))+ag_t*cos(alpha*sgn-y(1)));
        end
    end
    
    % ode45���¼���������value=0ʱ������
    function [value,isterminal,direction]=EventFcn(~,y)
        value(1)=y(1);      % �¼�1������ҡ�ڷ���ı䣬����ʱ����ҡ�ڽǶ�Ϊ0
        isterminal(1)=1;    % isterminalΪ1ʱ����ʾ���¼��Ĵ����ᵼ�������ֹ
        direction(1)=0;     % directionΪ0����ʾvalue������0�������½���0�����ᴥ���¼�
        
        value(2)=abs(y(1))-alpha;   %�¼�2������ҡ�ڽǶȳ���alphaʱ����Ϊ�����㷭
        isterminal(2)=1;
        direction(2)=1;             % directionΪ1����ʾvalue������0ʱ���Żᴥ���¼�
    end
end


