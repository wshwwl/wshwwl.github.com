[首页](https://wshwwl.github.io)  [关于](https://wshwwl.github.io/about.html) 

# 反应谱求解的修正

通过[反应谱的求解](https://wshwwl.github.io/articles/2019/12/02/Response.html)描述的方法可以求得任意单个固有频率的系统在地震激励下的响应（含位移、速度、加速度），但该方法给出的响应是对应每个地震加速度时程采样时间点处的响应。如地震加速度时程的采样时间点为：0 s、0.01 s、0.02 s、0.03 s...，则通过该代码求出来的响应对应的时间点也为：0 s、0.01 s、0.02 s、0.03 s...等。这些时间点不一定是最大响应时刻，尤其对于高频段，可能会有比较大的偏差。

![](.\acc.jpg)

以一段随机输入为例，上图为其一个时间段的加速度时程，图中圆圈'o'为原始地震加速度采样点，为减小计算步长，更准确的捕捉反应峰值，对原曲线进行插值，新的采样点为'*'所标注的点，这样就可以求解这些时刻处任意系统的响应，输入的本质不变，但获得的输出点更密集了。

将该地震加速度输入低、中、高三个不同固有频率的单自由度系统作为激励，固有频率分别为1 Hz，50 Hz，100 Hz，分别得到加速度响应如下图所示。

![](.\accresp.jpg)

两种步长求解出来的响应谱如下图所示：

![](.\resp.jpg)

* 对于较低固有频率的系统，其响应幅值变化较慢，原采样点处的响应和真实最大响应之间差值较小，精度可以接受。

* 对于拥有较高固有频率的系统，如上图中固有频率50 Hz的系统，红线的峰值和蓝线的峰值存在较大差异。若仍按原步长求解，则很有可能错过峰值。

为了准确捕捉峰值，需要减小计算的步长。

什么样的情况下需要减小计算步长呢，我一般处理时，是使地震加速度时程的采样频率大于系统固有频率的20倍，则可以得到很好的精度。如上图中，求50 Hz频率对应的加速度反应谱值时，要对原地震时程的采样点加密到采样频率为1000 Hz，即步长减小为十分之一。

下面的代码则是判断所求响应谱的最大频率是否满足上述条件，如不满足，则对数据加密。

```matlab
function  rsacc = tts2(dampRatio,freqs,acc,dt)
%TTS2 Summary of this function goes here
%   Detailed explanation goes here
    if max(freqs)*20>1/dt
       time1=0:dt:length(acc)*dt-dt;
       dt=1/max(freqs)/20;
       time2=0:dt:max(time1);
       acc=interp1(time1,acc,time2);
    end
    n=length(freqs);
    rsacc=zeros(1,n);
    for i=1:n
        rsacc(i)=max(abs(sdof_response(dampRatio,freqs(i),dt,acc)));
    end
 end
```





