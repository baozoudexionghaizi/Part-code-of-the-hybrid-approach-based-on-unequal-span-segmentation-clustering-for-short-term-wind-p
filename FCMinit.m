function U= FCMinit(n,data_n)
%%�Ӻ��� ģ�������ʼ��
        U=rand(n,data_n); % ������ɡ����ࡱ�У���������������
        col_sum=sum(U); %��ÿһ����������ÿ����������ȵĺ�
        U=U./col_sum(ones(n,1),:);  %ʹÿһ����������ÿ����������ȵĺ�Ϊ1
end

