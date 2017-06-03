clear all
clc

addpath(genpath('./'));
load('modelBsds.mat');

img='../data/cars_100/';
result='../data/output/result/';
CPM='./CPM';
epicFlow='EpicFlow/';

if ~exist([result,'/match'],'dir')
    mkdir([result,'/match']);
end

if ~exist([result,'/edge'],'dir')
    mkdir([result,'/edge']);
end

if ~exist([result,'/flow'],'dir')
    mkdir([result,'/flow']);
end

files=dir([img,'*.png']);

beg_frame=1;
img_old=imread([img,files(beg_frame).name]);

% num=length(files);
num=2;
for i=beg_frame+1:num
    tic
    
    im=imread([img,files(i).name]);
    
    % get the match relationship
    cmd=[CPM,'CPM ',[img,files(i-1).name],' ',[img,files(i).name],' ',[result,'match/',files(i-1).name(1:end-3),'txt']];
    system(cmd);
    
    % get the edge file
    edges = edgesDetect(img_old, model);
    fid=fopen([result,'edge/',files(i-1).name(1:end-3),'txt'],'wb'); 
    fwrite(fid,transpose(edges),'single'); 
    fclose(fid);
    
    % get the dense optical flow through edge-preserving interpolation 
    cmd=[epicFlow,'epicflow-static ',[img,files(i-1).name],' ',[img,files(i).name],' ',...
        [result,'edge/',files(i-1).name(1:end-3),'txt'],' ',[result,'match/',files(i-1).name(1:end-3),'txt'],' ',...
        [result,'flow/',files(i-1).name(1:end-3),'flo']];
    system(cmd);
    
    img_old=im;
    
    toc
end