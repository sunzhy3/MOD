function [ sal ] = backgroundConnectivity( img, idxImg, adjcMatrix, pixelList )
%BACKGROUNDCONNECTIVITY use the image and superpixel information,
%computing saliency
%   img: image
%   idxImg: superpixel label
%   adjcMatrix: connectivity matrix
%   pixelList: pixel lists, cell{}
%   sal: saliency

[h, w, ~] = size(img);
frameRecord = [h, w, 1, h, 1, w];
%% Get super-pixel properties
% spNum = size(adjcMatrix, 1);
meanRgbCol = GetMeanColor(img, pixelList);
meanPos = GetNormedMeanPos(pixelList, h, w);
bdIds = GetBndPatchIds(idxImg);
colDistM = GetDistanceMatrix(meanRgbCol);
posDistM = GetDistanceMatrix(meanPos);
[clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);

%% Saliency Optimization
[bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bdIds, clipVal, geoSigma);
wCtr = CalWeightedContrast(colDistM, posDistM, bgProb);
optwCtr = SaliencyOptimization(adjcMatrix, bdIds, colDistM, neiSigma, bgWeight, wCtr);
sal = GetSaliencyMap(optwCtr, pixelList, frameRecord, '', true);

end

