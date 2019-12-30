function rsm = RSM( f )
%RSM Summary of this function goes here
%   Detailed explanation goes here
%%  Rd 位移响应
fn=f;
dr=0.1;
f1=1;
f2=fn;
f3=200;
f12=min(f3,max(f2-dr*5*f2,f1));
f23=max(f1,min(f2+dr*5*f2,f3));

if f12>f1
    fj1=linspace(f1,f12,1000);
else
    fj1=[];
end

if f23>f12
    fj2=linspace(f12,f23,1000);
else
    fj2=[];
end
if f23<f3
    fj3=linspace(f23,f3,1000);
else
    fj3=[];
end

fj=[fj1,fj2,fj3];

% fj=0.45:0.0001:0.55;
r=fj./fn;
% r=0:0.01:5;    %r=w/wn 表示激励频率比无阻尼固有频率；

Rd=(1-r.^2).^2+(2*dr*r).^2;
Rd=1./sqrt(Rd);
% plot(r,Rd)
% hold on;
% xlabel('频率比(Hz)');
% ylabel('Rd');
% grid on;

%%  Ra 绝对加速度响应
Ra=sqrt((2*dr.*Rd.*r).^2+Rd.^2);  

% loglog(fj,Ra.*Ra)
% xlabel('频率比 \omega/\omega_n');
% ylabel('Ra');
% grid on;

%% 路谱
freq=[1.,4.,16.,40.,80.,200.];
aa=[5.e-005,1.e-002,1.e-002,1.e-003,1.e-003,1.e-005];
logfreq=log10(freq);
logaa=log10(aa);
logfj=log10(fj);
logaj=interp1(logfreq,logaa,logfj,'linear');
aj=10.^logaj;

df_road=diff(fj);
avra_road=zeros(length(aj)-1,1);
for i=1:length(fj)-1
    avra_road(i)=0.5*(aj(i)+aj(i+1));
end
rsm_road=sqrt(sum(df_road'.*avra_road));

%% 求均方根值
ra=Ra.*Ra.*aj;
% loglog(fj,ra)
% xlabel('频率比 \omega/\omega_n');
% ylabel('Ra');
% grid on;
df=diff(fj);
avra=zeros(length(ra)-1,1);
for i=1:length(ra)-1
    avra(i)=0.5*(ra(i)+ra(i+1));
end
rsm=sqrt(sum(df'.*avra));
rsm=rsm/rsm_road;
end

