function [atOutput,t] = S2TFFT(freqSeries,spectralSeries,dampRatio,scaleFactor,toleranceUpward,toleranceDownward,totalTime,risePeriod,stablePeriod,descendFactor)
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
        at=ifft(at);
        atOutput=at(1:length(t)).*envelope';
        Sat=tts3(dampRatio,freqSeries,atOutput,1/fs);
        biasu=(Sat-SseriesScaled)/maxSseriesScaled;
        biasb=(Sat)./SseriesScaled;
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




