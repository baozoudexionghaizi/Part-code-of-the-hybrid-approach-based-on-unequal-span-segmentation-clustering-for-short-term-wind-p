function[best_center,best_U,best_obj_fun]=FCM_CDTW_Cluster(data,segrecord,n,generation,xuhao,parent_number,options)
%% 采用模糊C均值将数据集data分为n类,重复n次实验，挑选最好的结果输出，但是结果不收敛，有点难受
%用法
% 1 [center,U,obj_fcn]=FCMCluster(data,n,options);
% 2 [center,U,obj_fcn]=FCMCluster(data,n);
 
%输入 
% data    n*m矩阵，n个样本数，每个样本的维度为m
% n       类别数
% options 4*1 矩阵
%   options(1):隶属度矩阵U的加权指数
%   options(2):最大迭代次数
%   options(3):隶属度最小变化量，迭代终止条件
%   options(4):每次迭代是否输出信息标志
 
%输出
% center    聚类中心
% U         隶属度矩阵
% obj_fun   目标函数值

%% 输入参数配置
if nargin~=6 && nargin~=7
    error('Too many or too few input arguments');
end 
 
%默认参数
default_options=[2;100;1e-5;1];
%参数配置
  %如果只输入前两个参数，选用默认的参数;如果参数个数小于4，其他选用默认参数
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
%% 将options 中的分量分别赋值给四个变量
  expo=options(1);   %隶属度矩阵U的加权指数
  max_iter=options(2);
  min_impro=options(3);
  display=options(4);
%% 输出迭代次数个目标函数变化值
  obj_fun=zeros(max_iter,1); 
%% 初始化“模糊分配矩阵”
 % 1.普通随机矩阵
%   data_n=size(find(segrecord==1),2)-1;
%   U=FCMinit(n,data_n);
 % 2.最大差异矩阵
if generation==0
  U=FCM_DRefroce_init(data,segrecord,n,expo); %进化第一代使用最大化寻找最优分割
else                                           %进化第二代一切照旧
     if xuhao >=1 && xuhao <=parent_number      %如果是属于变异部分的话
        global center_bianyi_sent;
        center1=center_bianyi_sent.(['population' num2str(xuhao)]).center1;
        center2=center_bianyi_sent.(['population' num2str(xuhao)]).center2;
        center3=center_bianyi_sent.(['population' num2str(xuhao)]).center3;
        center4=center_bianyi_sent.(['population' num2str(xuhao)]).center4;
        Record=find(segrecord==1);
        data_n=size(Record,2)-1;  %由此处可见，样本段落序号是由左侧的点来代替的
        %计算初始距离
        Dist=zeros(n,data_n); % 随机生成“几类”行，“样本个数”列
        for i=1:1:data_n   
            Dist(1,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center1,0);
            Dist(2,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center2,0);
            Dist(3,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center3,0);
            Dist(4,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center4,0);       
        end
        tmp=Dist.^(-2/(expo-1));                %这里是更新隶属度矩阵
        U=tmp./(ones(n,1)*sum(tmp));        %这里是更新隶属度矩阵
    else  %如果不属于变异部分的话
       U=FCM_DRefroce_init(data,segrecord,n,expo); 
    end
end
  best_obj_fun=0;
  best_center=[];
  best_U=[];
%% 主程序
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
                obj_fun(i)=sum(value)/(size(Record,2)-1); %设置目标函数值
           else
              [U,center,obj_fun(i)]=FCMstep(data,segrecord,U,n,expo,center);
           end
       end
       if display
           fprintf('FCM:Iteration count=%d,obj_fun=%f\n',i,obj_fun(i));
       end
       %终止条件判别
       if i>1
           if abs(obj_fun(i)-obj_fun(i-1))<min_impro
               break;
           end 
       end 
       % 寻最优结果输出
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


