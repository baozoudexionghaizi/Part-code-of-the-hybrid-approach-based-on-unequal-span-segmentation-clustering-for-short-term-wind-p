function U= FCMinit(n,data_n)
%%子函数 模糊矩阵初始化
        U=rand(n,data_n); % 随机生成“几类”行，“样本个数”列
        col_sum=sum(U); %求每一个样本属于每个类的隶属度的和
        U=U./col_sum(ones(n,1),:);  %使每一个样本属于每个类的隶属度的和为1
end

