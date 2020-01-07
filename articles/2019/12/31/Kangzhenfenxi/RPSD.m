%fw,swΪ���빦�����ܶ�����
fw=[1.,4.,16.,40.,80.,200.];
sw=[5.e-005,1.e-002,1.e-002,1.e-003,1.e-003,1.e-005];
%�����
dampRatio=0.1; 
%����Ƶ��
fn=10;
%������Ĺ��������߲�ֵ
logfw=log10(fw);
logsw=log10(sw);
minlogfw=min(logfw);
maxlogfw=max(logfw);
ilogfw=minlogfw:(maxlogfw-minlogfw)/1000:maxlogfw;
ilogsw=interp1(logfw,logsw,ilogfw);
ifw=10.^ilogfw;
isw=10.^ilogsw;
%rsw:��Ӧ�Ĺ������ܶ�����
rsw=RPS(ifw,isw,fn,dampRatio);
loglog(ifw,rsw)
grid on;
xlabel('Ƶ��/(Hz)');
ylabel('��Ӧ���ܶ�/(g^2/Hz)');
legend(['\zeta=',num2str(dampRatio),',f_n=',num2str(fn),'Hz']);

%������Ƶ��fn�������dampRatio��ϵͳ����Ӧ���ܶ����ߵĺ���
function rps = RPS(fw,sw, fn ,dampRatio)
r=fw/fn;
Ra=sqrt((1+4*dampRatio^2*r.^2)./((1-r.^2).^2+4*dampRatio^2*r.^2));
rps=Ra.^2.*sw;
end