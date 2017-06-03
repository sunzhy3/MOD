clear all;
addpath(genpath('./'));

% parameters setting
getParameters;

% process the mod algorithm between continuous frames
for i = 1: length(flowFiles)
    
    % read the input files
    img_old = imread([imgPath, imgFiles(i).name]);
    img_new = imread([imgPath, imgFiles(i+1).name]);
    opt_flow = readFlowFile([outputDir,vid, '/flow/', flowFiles(i).name]);
    
    [h, w, c] = size(img_old);
    
    % amplitude optical flow
    amp = sqrt(opt_flow(:, :, 1).^2 + opt_flow(:, :, 2).^2);
    mean_amp = mean(amp(:));
    max_amp = max(amp(:));
    
    % handle the static camera and none moving objects
    if mean_amp < min_mean_amp && max_amp < min_max_amp
        imwrite(img_old, [outputDir,vid, '/result/', imgFiles(i).name]);
        imwrite(zeros(h,w),[outputDir,vid, '/saliency/', imgFiles(i).name])
        continue;
    end
    
    % superpixel segmentation
    frameRecord = [h, w, 1, h, 1, w];
    pixNumInSP = 300;                        % pixels in each superpixel
    spnumber = round(h * w / pixNumInSP);     % super-pixel number for current image
    %SLIC
    compactness = 20; % the larger, the more regular patches will get
    [idxImg, ~] = SLIC_mex(img_old, spnumber, compactness);    % idxImg, spNum
    
    % handle the static camera
    if mean_amp < min_mean_amp
        % two other situation: 1, feature points clustering
        %                    2, use the saliency
        % experimentally, this decrease the undetected error rate(false negative)
        motion_sal = dim2Normalize(amp);
        motion_sal = pixel2superpixel(motion_sal,idxImg);
    else
        motion_sal = motionSaliencyMeasure(img_old, opt_flow, idxImg);
    end
    imwrite(motion_sal,[outputDir,vid, '/saliency/', imgFiles(i).name])
    
    % saliency to boundingbox
    bbox_sal  = sal2Bbox(img_old, motion_sal, opt_flow);

    im_withBox = plotRectangular(img_old, bbox_sal, 5, [0 255 0]);
    imwrite(im_withBox, [outputDir,vid, '/result/', imgFiles(i).name]);
end
