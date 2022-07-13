function U = FCM_DRefroce_init(data,segrecord,n,expo)
%选择相似度最差的n个样本,进行初始隶属度设置
% data：实际时间序列
% segrecord：分割点集合
% n:聚类个数
% expo：模糊聚类参数
Record=find(segrecord==1);
data_n=size(Record,2)-1;  %由此处可见，样本段落序号是由左侧的点来代替的
%% 寻找N个异常最大化中心
if n>=1
dist=0;
Dist=[];
for i=1:1:data_n
    for j=1:1:data_n
        dist=dist+dtw(data(1,Record(1,i):1:Record(1,i+1)),data(1,Record(1,j):1:Record(1,j+1)),0);
    end
        Dist=[Dist;dist];
        dist=0;
end
[~,index]=max(Dist);
center1=data(1,Record(1,index):1:Record(1,index+1));
end
%***************************
if n>=2
Dist=[];
for i=1:1:data_n
        Dist=[Dist;dtw(data(1,Record(1,i):1:Record(1,i+1)),center1,0)];
end
[~,index]=max(Dist);
center2=data(1,Record(1,index):1:Record(1,index+1));
end
%***************************
if n>=3
Dist=[];
for i=1:1:data_n
    a=dtw(data(1,Record(1,i):1:Record(1,i+1)),center1,0);
    b=dtw(data(1,Record(1,i):1:Record(1,i+1)),center2,0);
%          Dist=[Dist;(a/(a+b))*b+(b/(a+b))*a];
%         Dist=[Dist;a+b];
        Dist=[Dist;(a+b)/abs(a-b)];
end
[~,index]=max(Dist);
center3=data(1,Record(1,index):1:Record(1,index+1));
end
%**************************
if n>=4
Dist=[];
for i=1:1:data_n
    a=dtw(data(1,Record(1,i):1:Record(1,i+1)),center1,0);
    b=dtw(data(1,Record(1,i):1:Record(1,i+1)),center2,0);
    c=dtw(data(1,Record(1,i):1:Record(1,i+1)),center3,0);
%           Dist=[Dist;((a+b)/(a+b+c))*c+((a+c)/(a+b+c))*b+((b+c)/(a+b+c))*a];
%       Dist=[Dist;a+b+c];
        Dist=[Dist;(a+b+c)/(abs(a-b)+abs(a-c)+abs(c-b))];
end
[~,index]=max(Dist);
center4=data(1,Record(1,index):1:Record(1,index+1));
end
%*************************
% if n>=5
% Dist=[];
% for i=1:1:data_n
%     a=dtw(data(1,Record(1,i):1:Record(1,i+1)),center1,0);
%     b=dtw(data(1,Record(1,i):1:Record(1,i+1)),center2,0);
%     c=dtw(data(1,Record(1,i):1:Record(1,i+1)),center3,0);
%     d=dtw(data(1,Record(1,i):1:Record(1,i+1)),center4,0);
% %       Dist=[Dist;((a+b+c)/(a+b+c+d))*d+((a+b+d)/(a+b+c+d))*c+((a+c+d)/(a+b+c+d))*b+((b+c+d)/(a+b+c+d))*a];
% %       Dist=[Dist;a+b+c+d];
%       Dist=[Dist;(a/(a+b+c+d))*a+(b/(a+b+c+d))*b+(c/(a+b+c+d))*c+(d/(a+b+c+d))*d];
% end
% [~,index]=max(Dist);
% center5=data(1,Record(1,index):1:Record(1,index+1));
% end
%*************************
% if n>=6
% Dist=[];
% for i=1:1:data_n
%     a=dtw(data(1,Record(1,i):1:Record(1,i+1)),center1,0);
%     b=dtw(data(1,Record(1,i):1:Record(1,i+1)),center2,0);
%     c=dtw(data(1,Record(1,i):1:Record(1,i+1)),center3,0);
%     d=dtw(data(1,Record(1,i):1:Record(1,i+1)),center4,0);
%     e=dtw(data(1,Record(1,i):1:Record(1,i+1)),center5,0);
%       Dist=[Dist;((a+b+c+d)/(a+b+c+d+e))*e+((a+b+c+e)/(a+b+c+d+e))*d+((a+b+d+e)/(a+b+c+d+e))*c+((a+c+d+e)/(a+b+c+d+e))*b+((b+c+d+e)/(a+b+c+d+e))*a];
% %      Dist=[Dist;a+b+c+d+e];
% end
% [~,index]=max(Dist);
% center6=data(1,Record(1,index):1:Record(1,index+1));
% end
%计算初始距离
Dist=zeros(n,data_n); % 随机生成“几类”行，“样本个数”列
for i=1:1:data_n
    if n>=1
    Dist(1,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center1,0);
    end
    if n>=2
    Dist(2,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center2,0);
    end
    if n>=3
    Dist(3,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center3,0);
    end
    if n>=4
    Dist(4,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center4,0);
    end
%     if n>=5
%     Dist(5,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center5,0);
%     end
%     if n>=6
%     Dist(6,i)=dtw(data(1,Record(1,i):1:Record(1,i+1)),center6,0);
%     end
end
% figure
% plot(center1);
% hold on;
% plot(center2);
% hold on;
% plot(center3);
% hold on;
% plot(center4);
Dist(find(Dist==0))=1;
%% 首次更新隶属度
 tmp=Dist.^(-2/(expo-1));                %这里是更新隶属度矩阵
 U=tmp./(ones(n,1)*sum(tmp));        %这里是更新隶属度矩阵
end

