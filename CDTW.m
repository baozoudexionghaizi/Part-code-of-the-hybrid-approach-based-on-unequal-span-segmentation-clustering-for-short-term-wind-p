function [Y]= CDTW(Rearrangesequence,t,r,RearrangeSEG)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
T=Rearrangesequence(1,RearrangeSEG(t,1):1:RearrangeSEG(t,2));
R=Rearrangesequence(1,RearrangeSEG(r,1):1:RearrangeSEG(r,2));
 [~,T1,R1,W,tw,rw]=dtw(T,R,0);
% W�ĵ�һ����dtw�ĵ�һ�������Ӧ��Ť��·����W�ĵڶ�����dtw�ĵڶ��������Ӧ��Ť��·��
 C=zeros(1,size(W,1));
 L=zeros(1,size(W,1));
 %********************************************************************
 for i=1:1:size(C,2)
     L(1,i)=(W(i,1)*RearrangeSEG(t,3)+W(i,2)*RearrangeSEG(r,3))/(RearrangeSEG(t,3)+RearrangeSEG(r,3));
     C(1,i)=(T1(1,W(i,1))*RearrangeSEG(t,3)+R1(1,W(i,2))*RearrangeSEG(r,3))/(RearrangeSEG(t,3)+RearrangeSEG(r,3));
 end
 % ����������ֵ�����������������
%  if floor((size(T,2)+size(R,2))/2)>L(1,end)
%    C=C;  
%  end
%  Y=interp1(L,C,1:1:floor((size(T,2)+size(R,2))/2),'spline');
for j=2:1:size(L,2)
    if L(1,j)<L(1,j-1)    %2019.10.30�������޸� L(1,j)<=L(1,j-1) 
         error('********û�е���********');
    end
end
  Y=interp1(L,C,1:1:floor(L(1,end)),'spline');      %2019.10.1�޸�
 % ���������Ƿ��д���
 if size(Y,2)==0
    error('********�����Ƿ��д��󣬾�ֵ�������********'); 
 end
end
