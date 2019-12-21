function  rsacc = tts(dampRatio,freqs,acc,dt)
%TTS 此处显示有关此函数的摘要
%   此处显示详细说明
n=length(freqs);
rsacc=zeros(1,n);
 for i=1:n
     rsacc(i)=max(abs(sdof_response(dampRatio,freqs(i),dt,acc)));
 end
 
end

