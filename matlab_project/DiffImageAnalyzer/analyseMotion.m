function motionDegree = analyseMotion( motionPic, segPic, sensivity )
% analyseMotion analyses the motion in a given picture based on grey-value threshold
%   checks for gray values above sensitity and weightens them with the segmentation results.
%   this value is divided by the total number of pixels in the
%   picture.
    % get the size of the image part
    [height, width] = size(motionPic);
    % finds all pixels greater than the sensivity
    motionTreshold = motionPic>sensivity;
    % weightens the motion with the segmentation
    weightedMotion = motionTreshold .* segPic;
    % summs all up
    sumWeighted = sum(weightedMotion(:));
    % get the percentage of weighted motion in the image frame.
    motionDegree = sumWeighted/(height*width);
    % scale up for better values
    motionDegree = motionDegree*10.0;

end

