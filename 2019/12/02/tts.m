function  rsacc = tts(dampRatio,freqs,acc,dt)
%TTS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n=length(freqs);
rsacc=zeros(1,n);
 for i=1:n
     rsacc(i)=max(abs(sdof_response(dampRatio,freqs(i),dt,acc)));
 end
 
end

