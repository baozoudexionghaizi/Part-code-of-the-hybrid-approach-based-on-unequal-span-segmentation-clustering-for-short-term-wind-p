function [center,obj_fun]=FCM_real_distance_step(data,segrecord,U,n)
Record=find(segrecord==1);%�˴���Record�Ǽ�¼��Ⱦɫ�������е�1��
dist=[];
Dist=0;
Dist1=0;
Dist2=0;
Dist3=0;
Dist4=0;
%% ��������8�� , ���������������
clusterrecord=[];
center1=[];
if n>=1
index1=find(U(1,:)==max(U));%�ҳ�����Ϊ��һ����������� 
        for i=1:1:size(index1,2)
         clusterrecord=[clusterrecord; Record(1,index1(i)), Record(1,index1(i)+1), U(1,index1(i))];
        end
        center1=Real_distance_SampleCenterAverage(data,clusterrecord); %�������ֵ
        %����ռ�ʵ�ʾ����ܺ�
        for i=1:1:size(index1,2)
        %% �򻯿ռ��������
        A_y=mean(data(1,Record(1,index1(1,i)):1:Record(1,index1(1,i)+1))); %yֵ��ƽ����
        dist=[dist,abs(center1-A_y)];
        
%         A_y=mean(data(1,Record(1,index1(1,i)):1:Record(1,index1(1,i)+1))); 
%         A_min=min(data(1,Record(1,index1(1,i)):1:Record(1,index1(1,i)+1))); 
%         A_max=max(data(1,Record(1,index1(1,i)):1:Record(1,index1(1,i)+1))); 
%         dist=[dist,abs(center1(1,1)-A_min)+abs(center1(1,2)-A_y)+abs(center1(1,3)-A_max)];
        end
       Dist1=sum(dist);
       center.center1=center1;    
end
clusterrecord=[];
dist=[];
center2=[];
if n>=2
index2=find(U(2,:)==max(U));%�ҳ�����Ϊ�ڶ������������ 
       for i=1:1:size(index2,2)
        clusterrecord=[clusterrecord; Record(1,index2(i)), Record(1,index2(i)+1), U(1,index2(i))];
       end
       center2=Real_distance_SampleCenterAverage(data,clusterrecord); %�������ֵ            
        for i=1:1:size(index2,2)
       %% �򻯿ռ��������
        A_y=mean(data(1,Record(1,index2(1,i)):1:Record(1,index2(1,i)+1))); %yֵ��ƽ����
        dist=[dist,abs(center2-A_y)];     
        
%         A_y=mean(data(1,Record(1,index2(1,i)):1:Record(1,index2(1,i)+1))); 
%         A_min=min(data(1,Record(1,index2(1,i)):1:Record(1,index2(1,i)+1))); 
%         A_max=max(data(1,Record(1,index2(1,i)):1:Record(1,index2(1,i)+1))); 
%         dist=[dist,abs(center2(1,1)-A_min)+abs(center2(1,2)-A_y)+abs(center2(1,3)-A_max)];
        
        end
         Dist2=sum(dist);
        center.center2=center2;
end

clusterrecord=[];
dist=[];
center3=[];
if n>=3  
index3=find(U(3,:)==max(U));%�ҳ�����Ϊ��������������� 
        for i=1:1:size(index3,2)
         clusterrecord=[clusterrecord; Record(1,index3(i)), Record(1,index3(i)+1), U(1,index3(i))];
        end
        center3=Real_distance_SampleCenterAverage(data,clusterrecord); %�������ֵ
        for i=1:1:size(index3,2)
%        %% �򻯿ռ��������
        A_y=mean(data(1,Record(1,index3(1,i)):1:Record(1,index3(1,i)+1))); %yֵ��ƽ����
        dist=[dist,abs(center3-A_y)];  
        
%         A_y=mean(data(1,Record(1,index3(1,i)):1:Record(1,index3(1,i)+1))); 
%         A_min=min(data(1,Record(1,index3(1,i)):1:Record(1,index3(1,i)+1))); 
%         A_max=max(data(1,Record(1,index3(1,i)):1:Record(1,index3(1,i)+1))); 
%         dist=[dist,abs(center3(1,1)-A_min)+abs(center3(1,2)-A_y)+abs(center3(1,3)-A_max)];
        end
        Dist3=sum(dist);
        center.center3=center3;
end

clusterrecord=[];
dist=[];
center4=[];
if n>=4
index4=find(U(4,:)==max(U));%�ҳ�����Ϊ��������������� 
        for i=1:1:size(index4,2)
         clusterrecord=[clusterrecord; Record(1,index4(i)), Record(1,index4(i)+1), U(1,index4(i))];
        end
        center4=Real_distance_SampleCenterAverage(data,clusterrecord); %�������ֵ            
        for i=1:1:size(index4,2)
        %% �򻯿ռ��������
        A_y=mean(data(1,Record(1,index4(1,i)):1:Record(1,index4(1,i)+1))); %yֵ��ƽ����
        dist=[dist,abs(center4-A_y)];
        
%         A_y=mean(data(1,Record(1,index4(1,i)):1:Record(1,index4(1,i)+1))); 
%         A_min=min(data(1,Record(1,index4(1,i)):1:Record(1,index4(1,i)+1))); 
%         A_max=max(data(1,Record(1,index4(1,i)):1:Record(1,index4(1,i)+1))); 
%         dist=[dist,abs(center4(1,1)-A_min)+abs(center4(1,2)-A_y)+abs(center4(1,3)-A_max)];
        end
        Dist4=sum(dist);
        center.center4=center4;     
end
%% ����Ŀ�꺯��ֵ
obj_fun=(Dist1+Dist2+Dist3+Dist4)/(size(Record,2)-1); %����Ŀ�꺯��ֵ
end

