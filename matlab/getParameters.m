% data storage path
inputDir = './data/input/';
outputDir = './data/output/';

% video name
vid = 'rear26';

imgPath = [inputDir,vid, '/'];
imgFiles = dir([imgPath,'*.png']);
flowFiles = dir([outputDir,vid, '/flow/*.flo']);

% create directories for mid-result
if ~exist([outputDir,vid, '/result/'],'dir')
    mkdir([outputDir,vid, '/result/']);
end

if ~exist([outputDir,vid, '/saliency/'],'dir')
    mkdir([outputDir,vid, '/saliency/']);
end

% minimum mean optical flow amplitude
min_mean_amp = 1;

% minimum max optical flow amplitude
min_max_amp = 5;