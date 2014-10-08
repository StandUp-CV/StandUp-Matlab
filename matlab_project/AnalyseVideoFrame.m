function [ personCount, positions ] = AnalyseVideoFrame( frame, faceDetector, noseDetector ) %#codegen
%GETNEXTVIDEOFRAME Summary of this function goes here
%   Detailed explanation goes here



    %% Track using the Hue channel data
    noseBBox   = step(noseDetector,frame);
    
    positions = 1:4;
    personCount = 1;
    nil = 1:4;
    if (size(noseBBox) == size(nil))
        %% Track face
        bbox = step(faceDetector, frame);
        
%         dimensions = size(bbox);
        
%         if length(size(dimensions)) == 3
%             personCount = dimensions(1,3);
%             positions = [1:4; personCount];
%             for idx=personCount
%                 %dim = size(bbox,idx);
%                 positions(idx) = bbox(1:2, 1:2, idx);
%             end
        if length(bbox) == 4
            positions = bbox;
        end
        

    end
end

