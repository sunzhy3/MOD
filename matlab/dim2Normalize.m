function [outIM] = dim2Normalize(im)
% normalize an image
outIM=(im-min(im(:)))/(max(im(:))-min(im(:)));
end

