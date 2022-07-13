function [Y]= CDTW(Rearrangesequence,t,r,RearrangeSEG)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
T=Rearrangesequence(1,RearrangeSEG(t,1):1:RearrangeSEG(t,2));
R=Rearrangesequence(1,RearrangeSEG(r,1):1:RearrangeSEG(r,2));
 [~,T1,R1,W,tw,rw]=dtw(T,R,0);
% W的第一列是dtw的第一个输入对应的扭曲路径，W的第二列是dtw的第二个输入对应的扭曲路径
 C=zeros(1,size(W,1));
 L=zeros(1,size(W,1));
 %********************************************************************
 for i=1:1:size(C,2)
     L(1,i)=(W(i,1)*RearrangeSEG(t,3)+W(i,2)*RearrangeSEG(r,3))/(RearrangeSEG(t,3)+RearrangeSEG(r,3));
     C(1,i)=(T1(1,W(i,1))*RearrangeSEG(t,3)+R1(1,W(i,2))*RearrangeSEG(r,3))/(RearrangeSEG(t,3)+RearrangeSEG(r,3));
 end
 % 三次样条插值求出两个样本的中心
%  if floor((size(T,2)+size(R,2))/2)>L(1,end)
%    C=C;  
%  end
%  Y=interp1(L,C,1:1:floor((size(T,2)+size(R,2))/2),'spline');
for j=2:1:size(L,2)
    if L(1,j)<L(1,j-1)    %2019.10.30做出了修改 L(1,j)<=L(1,j-1) 
         error('********没有单调********');
    end
end
  Y=interp1(L,C,1:1:floor(L(1,end)),'spline');      %2019.10.1修改
 % 验正程序是否有错误
 if size(Y,2)==0
    error('********程序是否有错误，均值计算出错********'); 
 end
end
