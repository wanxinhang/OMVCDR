close all; clear all; clc
warning off;
addpath(genpath('ClusteringMeasure'));
addpath(genpath('utils'));
addpath(genpath('measure'));
addpath(genpath('eval'));
ResSavePath = 'Res/';
MaxResSavePath = 'final_res/';
eachResSavePath = 'each_Res/';

if(~exist(ResSavePath,'file'))
    mkdir(ResSavePath);
    addpath(genpath(ResSavePath));
end

if(~exist(MaxResSavePath,'file'))
    mkdir(MaxResSavePath);
    addpath(genpath(MaxResSavePath));
end

dataPath = './datasets/';
% datasetName = {'3sources','Yale','Texas','Cornell','WebKB_cor2views','MSRCV1','Washington','WebKB_Wisconsin2views','Wisconsin','Dermatology','ORLRnSp','ORL_3Views','ORL_4Views','NGs','BBCSport','Movies','BBC','proteinFold','WebKB','HW_2Views','MFeat_2Views','uci-digit','Cora','Wiki_fea','CiteSeer','NUS-WIDE-SCENE','NUS-WIDE-OBJECT-10','Reuters-7200','Hdigit','SUNRGBD','STL10_4Views','Reuters','NUS-WIDE-OBJECT','YouTubeFace10_4Views','CIFAR100_Train_4Views','FashionMNIST_4Views','MNIST_ALL_4Views','TinyImageNet_4Views','YouTubeFace50_4Views'};
% datasetName = {'Cornell','WebKB_cor2views','MSRCV1','Washington','WebKB_Wisconsin2views','Wisconsin','Dermatology','ORLRnSp','ORL_3Views','ORL_4Views','NGs','BBCSport','Movies','BBC','proteinFold','WebKB','HW_2Views','MFeat_2Views','uci-digit','Cora','Wiki_fea','CiteSeer','NUS-WIDE-SCENE','NUS-WIDE-OBJECT-10','Reuters-7200','Hdigit','SUNRGBD','STL10_4Views','Reuters','NUS-WIDE-OBJECT','YouTubeFace10_4Views','CIFAR100_Train_4Views','FashionMNIST_4Views','MNIST_ALL_4Views','TinyImageNet_4Views','YouTubeFace50_4Views'};
% datasetName = {'proteinFold','Flower17','WebKB','MFeat_2Views','HW_2Views','MFeat_2Views','uci-digit','BDGP','Caltech101-20','Cora','Wiki_fea','CiteSeer','Hdigit','NUS-WIDE-SCENE','NUS-WIDE-OBJECT-10','Reuters','NUS-WIDE-OBJECT','YouTubeFace10_4Views','CIFAR100_Train_4Views','FashionMNIST_4Views','MNIST_ALL_4Views','YouTubeFace20_4Views'};
% datasetName = {'Reuters-7200','SUNRGBD','VGGFace2_50_4Views','VGGFace2_100_4Views','YouTubeFace20_4Views'};
% datasetName = {'ORL_3Views','AwA_fea','Caltech256','VGGFace2_200_4Views','TinyImageNet_4Views'};
% datasetName = {'Flower17','HW_2Views','MFeat_2Views','BDGP','Hdigit','YouTubeFace10_4Views','AwA_fea','YouTubeFace20_4Views'};
datasetName = {'MNIST_fea'};
num_p=3;
for dataIndex = 1 : length(datasetName)
    dataName = [dataPath datasetName{dataIndex} '.mat'];
    load(['F:\wxh_work\datasets\MultiView_Dataset\',datasetName{dataIndex} ]);
    num_cluster = length(unique(Y));
    num_view = length(X);
    gt=Y;
    for v=1:num_view
%         X{v} = zscore(X{v})';
        X{v} = X{v}';
    end
    if length(find(Y==0))>0
        for i=1:size(X{1},2)
            Y(i)=Y(i)+1;
        end
    end
    gt=Y;
    ResBest = zeros(1, 8);
    ResStd = zeros(1, 8);
    % parameters setting
    r1 = 2.^(-5:1:5);
    acc = zeros(length(r1), 1);
    nmi = zeros(length(r1), 1);
    purity = zeros(length(r1), 1);
    idx = 1;
    best_acc=0;
    best_nmi=0;
    best_pur=0;
    YY=inintialize_Y(X,num_cluster);
%     error('mmp');
    for lam = 1 : length(r1)
        r1Temp = r1(lam);
        fprintf('Please wait a few minutes\n');
        tic;
        [Y,obj,beta] = my_alg(X,num_p, num_cluster,r1Temp,YY);
        val = my_eval_y(Y, gt);
        time=toc;
        resFile1 = [eachResSavePath datasetName{dataIndex}, '-iter=', num2str(lam), '.mat'];
        save(resFile1,'val','time','obj','beta');
        res(lam,:) = val;
        if res(lam,1)>best_acc
            best_acc=res(lam,1);
        end
        if res(lam,2)>best_nmi
            best_nmi=res(lam,2);
        end
        if res(lam,3)>best_pur
            best_pur=res(lam,3);
        end
    end
    resFile2 = [MaxResSavePath datasetName{dataIndex}, '-ACC=', num2str(best_acc), '.mat'];
    save(resFile2,'best_acc','best_nmi','best_pur');
end