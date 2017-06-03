function [ sOut ] = pixel2superpixel( data, idxImg)
%PIXEL2SUPERPIXEL change the pixel-wise data to superpixel-wise
%   data: pixel-wise data
%   idxImg: superpixel segmentation label
%   sOut: output superpixel-wise data

% superpixel number
spNum = length(unique(idxImg(:)));

% scalar
[~,~,chn]=size(data);
sOut = data;

% assign
for n = 1: chn
    M = data(:,:,n);
    for i = 1: spNum
        A = data(:,:,n);
        mean_superpixel = mean(A(idxImg==i));
        M(idxImg==i) = mean_superpixel;
    end
    sOut(:,:,n)=M;
end
end

