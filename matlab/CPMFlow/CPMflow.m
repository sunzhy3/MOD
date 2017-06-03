function [opt_flow] = CPMflow(imgFile_old, imgFile_new, resultDir)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load('modelBsds.mat');
CPM='./CPM/';
epicFlow='EpicFlow/';

if ~exist([resultDir,'/match'],'dir')
    mkdir([resultDir,'/match']);
end

if ~exist([resultDir,'/edge'],'dir')
    mkdir([resultDir,'/edge']);
end

if ~exist([resultDir,'/flow'],'dir')
    mkdir([resultDir,'/flow']);
end

img_old = imread(imgFile_old);

tic

% get the match relationship
cmd=[CPM,'CPM ', imgFile_old,' ', imgFile_new,' ',[resultDir,'match/',imgFile_old(end-9: end-3),'txt']];
system(cmd);

% get the edge file
edges = edgesDetect(img_old, model);
fid = fopen([resultDir, 'edge/', imgFile_old(end-9: end-3), 'txt'], 'wb'); 
fwrite(fid, transpose(edges), 'single'); 
fclose(fid);

% get the dense optical flow through edge-preserving interpolation 
cmd=[epicFlow,'epicflow-static ',[imgPath, imgFile_old],' ',[imgPath, imgFile_new],' ',...
    [resultDir,'edge/',imgFile_old(end-9: end-3),'txt'],' ',[resultDir,'match/',imgFile_old(end-9: end-3),'txt'],' ',...
    [resultDir,'flow/',imgFile_old(end-9: end-3),'flo']];
system(cmd);

toc

end

