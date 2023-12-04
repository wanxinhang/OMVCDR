function [H] = update_H(H,X,Z)
%UPDATE_H �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%   �˴���ʾ��ϸ˵��
num_p=size(H,1);
num_view = size(H,2);
U = cell(num_p,num_view);
V = cell(num_p,num_view);
T = cell(num_p,num_view);
for p=1:num_p
    for v=1:num_view
        T{p,v} = X{v}*Z{p}';
        [U{p,v},~,V{p,v}] = svd(T{p,v},'econ');
        H{p,v} = U{p,v}*V{p,v}';
    end
end
end

