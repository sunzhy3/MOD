function [ motion_sal ] = motionSaliencyMeasure( img, opt_flow, idxImg )
% compute the motion saliency
%   img: image
%   opt_flow: optical flow
%   idxImg: superpixel label
%   opt_sal: motion saliency

spNum = length(unique(idxImg(:)));
adjcMatrix = GetAdjMatrix(idxImg, spNum);
pixelList = cell(spNum, 1);
for n = 1:spNum
    pixelList{n} = find(idxImg == n);
end

%% optical flow measure
amp = sqrt(opt_flow(:, :, 1).^2 + opt_flow(:, :, 2).^2);
angle = atan2(opt_flow(:, :, 1), opt_flow(:, :, 2));
flow_measure = cat(4, opt_flow(:, :, 1), opt_flow(:, :, 2), amp, angle); % define 4-D flow measure

opt_sal_1 = backgroundConnectivity( flow_measure, idxImg, adjcMatrix, pixelList );
%% optical flow image
% opt_img = flowToColor(opt_flow);
% opt_sal_2 = backgroundConnectivity( opt_img, idxImg, adjcMatrix, pixelList );

%% fusion the saliency
motion_sal = opt_sal_1;
end

