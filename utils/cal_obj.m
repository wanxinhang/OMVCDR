function [obj] = cal_obj(cnt1,cnt2,alpha,beta,lambda,num_p)
%CAL_OBJ �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
obj=0;
for p=1:num_p
    obj=obj+alpha(p)^2*cnt1(p)+beta(p)^2*cnt2(p);
end
end

