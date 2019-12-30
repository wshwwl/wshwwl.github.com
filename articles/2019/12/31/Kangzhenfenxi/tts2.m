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

