f=1:1:500;
rsmf=zeros(size(f));
for i=1:length(f)
    rsmf(i)=RSM(f(i));
end

plot(f,rsmf);
grid on;
xlabel('Ƶ��/(Hz)');
ylabel('RMS_o/RMS_i');