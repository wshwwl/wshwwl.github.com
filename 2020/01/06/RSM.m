%fw,swΪ���빦�����ܶ�����
fw=[1.,4.,16.,40.,80.,200.];
sw=[5.e-005,1.e-002,1.e-002,1.e-003,1.e-003,1.e-005];
%������Ĺ��������߲�ֵ
logfw=log10(fw);
logsw=log10(sw);
minlogfw=min(logfw);
maxlogfw=max(logfw);
ilogfw=minlogfw:(maxlogfw-minlogfw)/1000:maxlogfw;
ilogsw=interp1(logfw,logsw,ilogfw);
ifw=10.^ilogfw;
isw=10.^ilogsw;
%�����
dampRatio=[0.05,0.1,0.2]; 
%����Ƶ��
% fn=1:500;
fn=logspace(log10(1),log10(500),200);
%rsm�洢��������Ƶ�ʡ�����ȵ�ϵͳ����Ӧ������ֵ������ı�ֵ
rsm=zeros(length(fn),length(dampRatio));
%rsw:��Ӧ�Ĺ������ܶ�����
for i=1:length(dampRatio)
    for j=1:length(fn)
        rsw=RPS(ifw,isw,fn(j),dampRatio(i));
        rsm(j,i)=sqrt(trapz(ifw,rsw));
    end
end
rsmInput=sqrt(trapz(ifw,isw));
rsm=rsm/rsmInput;
for i=1:length(dampRatio)
    semilogx(fn,rsm(:,i));
    hold on;
end
hold off;
grid on;
xlabel('Ƶ��/(Hz)');
ylabel('RMS_o/RMS_i');
legend('\zeta='+string(dampRatio));

%������Ƶ��fn�������dampRatio��ϵͳ����Ӧ���ܶ����ߵĺ���
function rps = RPS(fw,sw, fn ,dampRatio)
r=fw/fn;
Ra=sqrt((1+4*dampRatio^2*r.^2)./((1-r.^2).^2+4*dampRatio^2*r.^2));
rps=Ra.^2.*sw;
end