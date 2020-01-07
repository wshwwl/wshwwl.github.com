%fw,sw为输入功率谱密度曲线
fw=[1.,4.,16.,40.,80.,200.];
sw=[5.e-005,1.e-002,1.e-002,1.e-003,1.e-003,1.e-005];
%对输入的功率谱曲线插值
logfw=log10(fw);
logsw=log10(sw);
minlogfw=min(logfw);
maxlogfw=max(logfw);
ilogfw=minlogfw:(maxlogfw-minlogfw)/1000:maxlogfw;
ilogsw=interp1(logfw,logsw,ilogfw);
ifw=10.^ilogfw;
isw=10.^ilogsw;
%阻尼比
dampRatio=[0.05,0.1,0.2]; 
%固有频率
% fn=1:500;
fn=logspace(log10(1),log10(500),200);
%rsm存储各个固有频率、阻尼比的系统的响应均方根值与输入的比值
rsm=zeros(length(fn),length(dampRatio));
%rsw:响应的功率谱密度曲线
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
xlabel('频率/(Hz)');
ylabel('RMS_o/RMS_i');
legend('\zeta='+string(dampRatio));

%求解固有频率fn，阻尼比dampRatio的系统的响应谱密度曲线的函数
function rps = RPS(fw,sw, fn ,dampRatio)
r=fw/fn;
Ra=sqrt((1+4*dampRatio^2*r.^2)./((1-r.^2).^2+4*dampRatio^2*r.^2));
rps=Ra.^2.*sw;
end