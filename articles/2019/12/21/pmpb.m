% 四个节点的应力状态，依次为sx、sy、sz、sxy、syz、sxz
sn4=[-0.25037E+08 -0.32145E+08 -0.79458E+07  0.28775E+08  0.0000      0.0000 ];
sn1=[ 0.96907E+08  0.12621E+09  0.80323E+08 -0.12683E+09  0.0000      0.0000];
sn3=[ 0.11512E+08  0.18354E+08  0.19262E+08 -0.12366E+08  0.0000      0.0000];
sn2=[ 0.51497E+08  0.70925E+08  0.48394E+08 -0.62210E+08  0.0000      0.0000];
S=[sn1;sn2;sn3;sn4];
%各点坐标
ln4=[0.792667608977E-001    1.66897695709         0.00000000000];
ln1=[0.774554851510E-001    1.66747760283         0.00000000000];
ln3=[0.786600643580E-001    1.66847985656         0.00000000000];
ln2=[0.780563057757E-001    1.66798007181         0.00000000000];
% 各点距离第一点的距离loc
dis = @(loc1,loc2) sqrt(sum((loc1-loc2).^2));
loc=[0,dis(ln1,ln2),dis(ln1,ln3),dis(ln1,ln4)];
%六个应力分量依次线性化
[sxm,sxb]=linearize(loc,S(:,1));
[sym,syb]=linearize(loc,S(:,2));
[szm,szb]=linearize(loc,S(:,3));
[sxym,sxyb]=linearize(loc,S(:,4));
[syzm,syzb]=linearize(loc,S(:,5));
[sxzm,sxzb]=linearize(loc,S(:,6));
%分别求出薄膜和弯曲应力的三个主应力
[s1m,s2m,s3m]=s1s2s3([sxm,sym,szm,sxym,syzm,sxzm]);
[s1b,s2b,s3b]=s1s2s3([sxb,syb,szb,sxyb,syzb,sxzb]);

s1b_o=s1b; %外侧的第一主应力的弯曲应力
s1b_i=-s3b;%内测的第一主应力的弯曲应力

function [pm,pb] = linearize( loc,stress )
% 线性化函数，输出薄膜应力和外侧弯曲应力
loc=reshape(loc,size(stress));
t=diff(loc);
T=sum(t);
pm=sum(0.5*(stress(1:end-1)+stress(2:end)).*t)/T;

%计算弯曲应力的积分，这里粗暴的将眼壁厚的应力曲线分成1000段，化为求和计算，精度足够。
nt=1000;
Ts=0:T/nt:T;
Ss=interp1(loc,stress,Ts);
pb=sum((Ss(1:end-1)+Ss(2:end))/2*T/nt.*(0.5*Ts(1:end-1)+0.5*Ts(2:end)-T/2))*6/T^2;
end

function [s1,s2,s3 ] = s1s2s3( stress )
% 根据任意点的应力状态求出其3个主应力。
sx=stress(1);
sy=stress(2);
sz=stress(3);
sxy=stress(4);
syz=stress(5);
sxz=stress(6);
I1=sx+sy+sz;
I2=sy*sz+sx*sz+sx*sy-syz^2-sxz^2-sxy^2;
I3=[sx,sxy,sxz;
    sxy,sy,syz;
    sxz,syz,sz];
I3=det(I3);
S=sort(roots([1,-I1,I2,-I3]),1,'descend');
s1=S(1);
s2=S(2);
s3=S(3);
end



