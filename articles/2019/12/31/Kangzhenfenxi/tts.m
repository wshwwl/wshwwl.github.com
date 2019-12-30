function rsa=tts(at,t,dampratio,freq_in_Hz)
	warning('off','Control:analysis:LsimUndersampled');
    omega = 2*pi.*freq_in_Hz; 
    nf=length(omega);
    disp=zeros(nf,1);
    spd=zeros(nf,1);
    acc=zeros(nf,1);
    for i = 1:length(omega)
        SYS = tf(1,[1,2*dampratio*omega(i),omega(i)*omega(i)]); 
        disp(i) = max(abs(lsim(SYS,at,t)));
        spd(i) = omega(i)*disp(i); 
        acc(i) = (omega(i)^2)*max(abs(lsim(SYS,at,t)));
    end
    rsa=acc;
end