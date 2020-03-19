[首页](https://wshwwl.github.io)  [关于](https://wshwwl.github.io/about.html) 

# 三角级数法合成地震动

[toc]

## 参考书籍

有关于地震动合成的主要参考书籍**《地震工程学》**，作者为胡聿贤。

![](.\book.jpg)

## 三角级数法

其过程简述如下：

* Step 1：确定需要控制的反应谱$S_a(T)$;
* Step 2：反应谱转换为功率谱；

$$
S(\omega_k)=\frac{2\zeta}{\pi\omega_k}S_a^2(\omega_k)/\left\{-2ln\left[-\frac{\pi}{\omega_kT_d}ln{P}\right]\right\} ,\quad \omega_k=k\cdot\Delta\omega
$$

* Step 3：功率谱转换成傅里叶谱；

$$
A_k=A(\omega_k)=[4S(\omega_k)\Delta\omega]^{1/2}
$$

* Step 4：采用随机相位和振幅非平稳函数$f(t)$将傅里叶谱转换成时程；

$$
a(t)=f(t)\cdot\sum_{k=N_1}^{N_2}A_ke^{i(\omega_kt+\phi_k)}
$$

* Step 5：求该时程的反应谱；
* Step 6：求该反应谱与目标反应谱的比值；根据该比值调节傅里叶谱；
* 重复Step 4至Step 6过程，直到求解的反应谱与目标反应谱的偏差在允许范围以内。

上面公式中:

* $\omega_k$与$A_k$分别为第$k$个傅里叶分量的频率和振幅；
* 相位角$\phi_k$在$0$~$2\pi$之间均匀随机分布；
* $N_1\Delta\omega<2\pi/T_M$,$N_2\Delta\omega>2\pi/T_1$;
* $S(\omega)$为功率谱；$T_d$为持续时间；$\zeta$为阻尼比；
* $P$为反应不超过反应谱值的概率，一般可取$P\ge0.85$。
* 为保证求解能够收敛，$\Delta\omega$需足够小，即保证有足够多的三角级数。

该过程用流程图表示为：

```flow
sa1=>start: 目标反应谱
sw=>operation: 功率谱
aw=>operation: 傅里叶谱
th=>operation: 转为时程，求反应谱
div=>condition: 计算偏差
adjust=>operation: 调整傅里叶谱
e=>end 

sa1->sw->aw->th->div
div(no)->aw
div(yes)->e
```

## Matlab求解

以下代码使用$FFT$进行求解，每一组随机数迭代100次，最大尝试20组随机数。

```matlab
function [atOutput,t] = S2TFFT(freqSeries,spectralSeries,dampRatio,scaleFactor,toleranceUpward,toleranceDownward,totalTime,risePeriod,stablePeriod,descendFactor)
% freqSeries:反应谱的频率向量
% SpectralSeries：反应谱的谱值向量
% dampRatio:阻尼比
% scaleFactor:谱值放大系数
% toleranceUpward:上偏差
% toleranceDownard：下偏差
% risePeriod：上升段
% stablePeriod：稳定段
% descendFactor：衰减系数
fmax=max(freqSeries(1),freqSeries(end));
fmin=min(freqSeries(1),freqSeries(end));
%% 采样频率
fsOrder=10^(floor(log10(fmax)));
fs=fmax/fsOrder;
fInt=[1,2,2.5,4,5,8];
for i=1:length(fInt)
   if fs<=fInt(i) 
       fs=fInt(i);
       break;
   end   
end
fs=2*fs*fsOrder;
if fs<50
    fs=50;
end
%% 合成参数
df=min(fmin/20,1/totalTime);
nf=fs/2/df;
nf=2^(nextpow2(nf));
nfft=2*nf;
df=fs/nfft;
T=1/df;
%% 反应谱转换功率谱
P=0.9; 
n1=floor(fmin/df);
n2=ceil(fmax/df);
freqs=n1*df:df:n2*df;
Sa=interp1(freqSeries,spectralSeries,freqs,'linear','extrap');
Aw=zeros(nf+1,1);
for i=n1+1:n2+1
    Aw(i)=(2*dampRatio/(2*pi*pi*freqs(i-n1)))*Sa(i-n1)^2/(-2*log(-1*pi*log(P)/(2*pi*freqs(i-n1)*T)));
    Aw(i)=sqrt(4*Aw(i)*2*pi*df);
end
%% 包络线
[t,envelope]=GetEnvelope(fs,totalTime,risePeriod,stablePeriod,descendFactor);
%% 合成
for randomTimes=1:20
	% 随机相位
    phase=2*pi*rand(nf+1,1);
    phase(end)=0;
    phase(1)=0;
    phase=nfft*exp(phase*sqrt(-1));
    SseriesScaled=spectralSeries*scaleFactor;
    maxSseriesScaled=max(SseriesScaled);
    succeed=false;
    for cicles=1:100
        vecf=phase.*Aw;
        at=[vecf;flipud(conj(vecf(2:end-1)))];
        %逆变换合成时程
        at=ifft(at);
        %乘以非平稳包络线
        atOutput=at(1:length(t)).*envelope';
        % 求解反应谱
        Sat=tts(dampRatio,freqSeries,atOutput,1/fs);
        %计算上下偏差
        biasu=(Sat-SseriesScaled)/maxSseriesScaled;
        biasb=(Sat)./SseriesScaled;
        %如果偏差过大则调整傅里叶谱值
        if max(biasu)>toleranceUpward || min(biasb)<1-toleranceDownward
            blxs=SseriesScaled./Sat;
            xblxs=interp1(freqSeries,blxs,freqs,'linear','extrap');
            Aw(n1+1:n2+1)=Aw(n1+1:n2+1).*xblxs';
        else
            succeed=true;
            break;
        end
    end
    if succeed
        break;
    end
end
if ~succeed
   atOutput=[];
   t=[];
end
end
```























