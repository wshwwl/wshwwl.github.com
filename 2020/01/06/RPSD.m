%fw,sw为输入功率谱密度曲线
fw=[1.,4.,16.,40.,80.,200.];
sw=[5.e-005,1.e-002,1.e-002,1.e-003,1.e-003,1.e-005];
%阻尼比
dampRatio=0.1; 
%固有频率
fn=10;
%对输入的功率谱曲线插值
logfw=log10(fw);
logsw=log10(sw);
minlogfw=min(logfw);
maxlogfw=max(logfw);
ilogfw=minlogfw:(maxlogfw-minlogfw)/1000:maxlogfw;
ilogsw=interp1(logfw,logsw,ilogfw);
ifw=10.^ilogfw;
isw=10.^ilogsw;
%rsw:响应的功率谱密度曲线
rsw=RPS(ifw,isw,fn,dampRatio);
loglog(ifw,rsw)
grid on;
xlabel('频率/(Hz)');
ylabel('响应谱密度/(g^2/Hz)');
legend(['\zeta=',num2str(dampRatio),',f_n=',num2str(fn),'Hz']);

%求解固有频率fn，阻尼比dampRatio的系统的响应谱密度曲线的函数
function rps = RPS(fw,sw, fn ,dampRatio)
r=fw/fn;
Ra=sqrt((1+4*dampRatio^2*r.^2)./((1-r.^2).^2+4*dampRatio^2*r.^2));
rps=Ra.^2.*sw;
end