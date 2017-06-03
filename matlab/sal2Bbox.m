function [ bbox ] = sal2Bbox( img, sal, opt_flow )
%SAL2BBOX saliency to bounding box
%   img: image
%   sal: saliency map
%   opt_flow: optical flow
%   bbox: bounding box

[row, col] = size(sal);
bbox = [];
stdThreshold_img = 20;

%% get bounding box from saliency map
boundBox = getBboxFromSaliency(sal);

%% judge is the box illegal
boundBox = uint16(boundBox);
for i=1:length(boundBox(:, 1))
    x = max(boundBox(i,1), 1);
    y = max(boundBox(i,2), 1);
    w = min(boundBox(i,3), col-x);
    h = min(boundBox(i,4), row-y);
    boundBox(i,:)=[x,y,w,h];
end

for i = 1: length(boundBox(:, 1))
    width = double(boundBox(i, 3));
    height = double(boundBox(i, 4));
    % remove outlier
    if height > row*0.9 || width > col*0.5 || width > 5*height || height > 5*width
        continue;
    end
    
    if width + height < ceil(row/12)
        continue;
    end
    
    x = boundBox(i, 1);
    y = boundBox(i, 2);
    w = boundBox(i, 3);
    h = boundBox(i, 4);
    
    if width * height/(row*col) > 0.25
        continue;
    elseif width * height/(row*col) > 0.06
        sub_opt_flow=opt_flow(y+1:y+h,x+1:x+w,:);
        sub_sal=sal(y+1:y+h,x+1:x+w);
        H = extractFlowColor( flowToColor(sub_opt_flow), sub_sal>graythresh(sub_sal) );
        
        % this parameter define the optical flow varies
        pos=find(H>200);
        if(max(pos)-min(pos)>150)
            continue;
        end
    end
    
    % judge objectness
    sub_img = img(y+1: y+h, x+1: x+w, :);
    if std2(rgb2gray(sub_img)) < stdThreshold_img
        continue;
    end
    
    bbox = [bbox; uint16(boundBox(i, :))];
end

end

