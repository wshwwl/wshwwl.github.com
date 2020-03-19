function [s1,s2,s3 ] = s1s2s3( stress )
%S1S2S3 Summary of this function goes here
%   Detailed explanation goes here
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

