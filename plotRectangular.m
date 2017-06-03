function [ outIM ] = plotRectangular( image, bbox, wid, color )
% plot bounding box over image
% image: source image
% bbox: bounding box
% wid: the width of line
% color: color of rectangle

[row,col,~] = size(image);
if ~isempty(bbox)
    for j = 1: length(bbox(:,1))
        b = uint16(bbox(j, :));
        x = max(b(1), 1);
        y = max(b(2), 1);
        w = min(b(3), col-x);
        h = min(b(4), row-y);
        
        image(y+1: y+h, x+1: x+wid, 1) = color(1);
        image(y+1: y+h, x+1: x+wid, 2) = color(2);
        image(y+1: y+h, x+1: x+wid, 3) = color(3);
        
        image(y+1: y+h, x+w-wid: x+w, 1) = color(1);
        image(y+1: y+h, x+w-wid: x+w, 2) = color(2);
        image(y+1: y+h, x+w-wid: x+w, 3) = color(3);
        
        image(y+1: y+wid, x+1: x+w, 1) = color(1);
        image(y+1: y+wid, x+1: x+w, 2) = color(2);
        image(y+1: y+wid, x+1: x+w, 3) = color(3);
        
        image(y+h-wid: y+h, x+1: x+w, 1) = color(1);
        image(y+h-wid: y+h, x+1: x+w, 2) = color(2);
        image(y+h-wid: y+h, x+1: x+w, 3) = color(3);
    end
end
outIM=image;
end

