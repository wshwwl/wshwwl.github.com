f=10:0.1:20;
rsmf=zeros(size(f));
for i=1:length(f)
    rsmf(i)=RSM(f(i));
end

plot(f,rsmf);
grid on;
xlabel('ÆµÂÊ/(Hz)');
ylabel('RMS_o/RMS_i');