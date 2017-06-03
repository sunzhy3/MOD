function [ bbox ] = getBboxFromSaliency( salImg )
%GETBOUNDINGBOXFROMSALIENCY
%   salImg: saliency map
%   bbox: bounding box

bbox = [];
imBw = im2bw(salImg);
% dilation
% SE1 = strel('rectangle',[3 3]);
SE2 = strel('rectangle',[5 5]);
% imBw1 = imerode(imBw,SE1);
imBw1 = imdilate(imBw,SE2);
region = regionprops(imBw1,'BoundingBox');
if ~isempty(region)
    for i = 1: length(region)
        bbox = [bbox; region(i).BoundingBox];
    end
end

% start second level region extraction
salImg_backup=salImg;
salImg(imBw)=0;
imBw2 = salImg>graythresh(salImg);
SE1 = strel('rectangle',[3 3]);
SE2 = strel('rectangle',[5 5]);
imBw2 = imerode(imBw2,SE1);
imBw2 = imdilate(imBw2,SE2);
region = regionprops(imBw2,'BoundingBox');
bbox_sec=[];
if ~isempty(region)
    for i = 1: length(region)
        box_sec = region(i).BoundingBox;
        flag=true;
        for j=1:length(bbox(:,1))
            if isCovered(box_sec,bbox(j,:))
                flag=false;
                break;
            end
        end
        
        if flag
            bbox_sec=[bbox_sec;box_sec];
        end
    end
end

bbox=[bbox;bbox_sec];
end

