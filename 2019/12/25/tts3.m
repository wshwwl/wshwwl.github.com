function  rsacc = tts3(dampRatio,freqs,acc,dt)
%TTS2 Summary of this function goes here
%   Detailed explanation goes here
fmax=max(freqs);
fcut1=1/dt/20;
fcut2=fcut1;
if fmax>fcut1
    fs_scale1=ceil(fmax*20*dt);
    acc1=interp1(acc,1:1/fs_scale1:length(acc));
    dt1=dt/fs_scale1;
    if fs_scale1>2
        fs_scale2=ceil(fs_scale1/2);
        acc2=interp1(acc,1:1/fs_scale2:length(acc));
        dt2=dt/fs_scale2;
        fcut2=fcut1*fs_scale2;
    end
end

n=length(freqs);
rsacc=zeros(n,1);
 for i=1:n
     if freqs(i)<fcut1
        rsacc(i)=max_sdof_acc_response(dampRatio,freqs(i),dt,acc);
     elseif freqs(i)<fcut2
        rsacc(i)=max_sdof_acc_response(dampRatio,freqs(i),dt2,acc2);
     else
        rsacc(i)=max_sdof_acc_response(dampRatio,freqs(i),dt1,acc1); 
     end
 end

end

