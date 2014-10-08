function [ BWfinal ] = boundaryDetect( image, fudgeFactor )
% BOUNDARYDETECT detects the boundary and segments the image according to
% the fudge factor.  
% gets the bw threshold and get the edges via sobel filter. Dilates them 
% and fills the gaps. Finally smoothes the image via dimonds. 

    % Detect Entire Cell
    [~, threshold] = edge(image, 'sobel');
    BWs = edge(image,'sobel', threshold * fudgeFactor);
    % Dilate the Image
    se90 = strel('line', 3, 90);
    se0 = strel('line', 3, 0);
    BWsdil = imdilate(BWs, [se90 se0]);
    %Fill Interior Gaps
    BWdfill = imfill(BWsdil, 'holes');
    % Smoothen the Object
    seD = strel('diamond',1);
    BWfinal = imerode(BWdfill,seD);
    BWfinal = imerode(BWfinal,seD);
    
end

