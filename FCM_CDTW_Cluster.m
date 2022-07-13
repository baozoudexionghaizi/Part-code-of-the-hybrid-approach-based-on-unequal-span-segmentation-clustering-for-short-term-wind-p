function[best_center,best_U,best_obj_fun]=FCM_CDTW_Cluster(data,segrecord,n,generation,xuhao,parent_number,options)
%% ����ģ��C��ֵ�����ݼ�data��Ϊn��,�ظ�n��ʵ�飬��ѡ��õĽ����������ǽ�����������е�����
%�÷�
% 1 [center,U,obj_fcn]=FCMCluster(data,n,options);
% 2 [center,U,obj_fcn]=FCMCluster(data,n);
 
%���� 
% data    n*m����n����������ÿ��������ά��Ϊm
% n       �����
% options 4*1 ����
%   options(1):�����Ⱦ���U�ļ�Ȩָ��
%   options(2):����������
%   options(3):��������С�仯����������ֹ����
%   options(4):ÿ�ε����Ƿ������Ϣ��־
 
%���
% center    ��������
% U         �����Ⱦ���
% obj_fun   Ŀ�꺯��ֵ

%% �����������
if nargin~=6 && nargin~=7
    error('Too many or too few input arguments');
end 
 
%Ĭ�ϲ���
default_options=[2;100;1e-5;1];
%��������
  %���ֻ����ǰ����������ѡ��Ĭ�ϵĲ���;�����������С��4������ѡ��Ĭ�ϲ���
  if nargin==3
      options=default_options;
  else
       if length(options)<4
           tmp=default_options;
           tmp(1:length(options))=options;
           options=tmp;
       end 
       nan_index=find(isnan(options)==1);
       options(nan_index)=default_options(nan_index);
 
       if options(1)<=1
           error('The exponent should be greater than 1!');
       end 
  end 
%% ��options �еķ����ֱ�ֵ���ĸ�����
  expo=options(1);   %�����Ⱦ���U�ļ�Ȩָ��
  max_iter=options(2);
  min_impro=options(3);
  display=options(4);
%% �������������Ŀ�꺯���仯ֵ
  obj_fun=zeros(max_iter,1); 
%% ��ʼ����ģ���������
 % 1.��ͨ�������
%   data_n=size(find(segrecord==1),2)-1;
%   U=FCMinit(n,data_n);
 % 2.���������
if generation==0
  U=FCM_DRefroce_init(data,segrecord,n,expo); %������һ��ʹ�����Ѱ�����ŷָ�
else                                           %�����ڶ���һ���վ�
     if xuhao >=1 && xuhao <=parent_number      %��������ڱ��첿�ֵĻ�
        global center_bianyi_sent;
        center1=center_bianyi_sent.(['population' num2str(xuhao)]).center1;
        center2=center_bianyi_sent.(['population' num2str(xuhao)]).center2;
        center3=center_bianyi_sent.(['population' num2str(xuhao)]).center3;
        center4=center_bianyi_sent.(['population' num2str(xuhao)]).center4;
        Record=find(segrecord==1);
        data_n=size(Record,2)-1;  %�ɴ˴��ɼ���������������������ĵ��������
        %�����ʼ����
        Dist=zeros(n,data_n); % ������ɡ����ࡱ�У���������������
        for i=1:1:data_n   
            Dist(1,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center1,0);
            Dist(2,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center2,0);
            Dist(3,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center3,0);
            Dist(4,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center4,0);       
        end
        tmp=Dist.^(-2/(expo-1));                %�����Ǹ��������Ⱦ���
        U=tmp./(ones(n,1)*sum(tmp));        %�����Ǹ��������Ⱦ���
    else  %��������ڱ��첿�ֵĻ�
       U=FCM_DRefroce_init(data,segrecord,n,expo); 
    end
end
  best_obj_fun=0;
  best_center=[];
  best_U=[];
%% ������
center.center0=[];
   for i=1:max_iter
       if generation==0
       [U,center,obj_fun(i)]=FCMstep(data,segrecord,U,n,expo,center);
       else
           if i==1 && xuhao <=parent_number
              center.center1=center_bianyi_sent.(['population' num2str(xuhao)]).center1;
              center.center2=center_bianyi_sent.(['population' num2str(xuhao)]).center2;
              center.center3=center_bianyi_sent.(['population' num2str(xuhao)]).center3;
              center.center4=center_bianyi_sent.(['population' num2str(xuhao)]).center4;
              value=min(Dist);
                obj_fun(i)=sum(value)/(size(Record,2)-1); %����Ŀ�꺯��ֵ
           else
              [U,center,obj_fun(i)]=FCMstep(data,segrecord,U,n,expo,center);
           end
       end
       if display
           fprintf('FCM:Iteration count=%d,obj_fun=%f\n',i,obj_fun(i));
       end
       %��ֹ�����б�
       if i>1
           if abs(obj_fun(i)-obj_fun(i-1))<min_impro
               break;
           end 
       end 
       % Ѱ���Ž�����
       if i==1
             best_obj_fun=obj_fun(i);
             best_center=center;
             best_U=U;
       else
           if obj_fun(i)<=best_obj_fun
               best_obj_fun=obj_fun(i);
             best_center=center;
             best_U=U;
           end
       end
       
   end
%   
end


