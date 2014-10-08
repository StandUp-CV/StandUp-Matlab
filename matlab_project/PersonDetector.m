clear; clc; close all;
% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();
noseDetector = vision.CascadeObjectDetector('Nose');
upperBodyDetector = vision.CascadeObjectDetector('UpperBody');

% Read a video frame and run the detector.
%videoFileReader = vision.VideoFileReader('samplevideos/sample4.mp4');

% Create a video player object for displaying video frames.
%videoInfo    = info(videoFileReader);
%videoPlayer  = vision.VideoPlayer('Position',[300 300 640+30]);

videoPlayer = videoinput('winvideo', 1, 'YUY2_640x480');
% Set video input object properties for this application.
% Note that example uses both SET method and dot notation method.
set(videoPlayer,'TriggerRepeat',Inf);
videoPlayer.FrameGrabInterval = 2; 
% Set value of a video source object property.
vid_src = getselectedsource(videoPlayer);
set(vid_src,'Tag','motion detection setup');

% Create a figure window.
figure; 

% Start acquiring frames.
start(videoPlayer)

% Track the face over successive video frames until the video is finished.
while videoPlayer.FramesAcquired<=50

    % Extract the next video frame
    videoFrame = getdata(videoPlayer, 1); 
    
    noseBBox   = step(noseDetector,videoFrame);
    
    if (size(noseBBox) ~= [0 0])
        % Track using the Hue channel data
        bbox = step(faceDetector, videoFrame);

        % Detect the nose within the face region. The nose provides a more accurate
        % measure of the skin tone because it does not contain any background
        % pixels.
%         faceImage    = imcrop(videoFrame,bbox(1,:));
%         noseBBox     = step(noseDetector,faceImage);

        % The nose bounding box is defined relative to the cropped face image.
        % Adjust the nose bounding box so that it is relative to the original video
        % frame.
%         noseBBox(1,1:2) = noseBBox(1,1:2) + bbox(1,1:2);

        % Insert a bounding box around the object being tracked
        videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
        imshow(videoOut);
        % Display the annotated video frame using the video player object
        %step(videoPlayer, videoOut);
    else
%         upperBodyBBox = step(upperBodyDetector,videoFrame);
%         if (size(upperBodyBBox) ~= [0 0])
%             % Insert a bounding box around the object being tracked
%         	videoOut = insertObjectAnnotation(videoFrame,'rectangle',upperBodyBBox,'Upper Body');
%             % Display the annotated video frame using the video player object
%             step(videoPlayer, videoOut);
%         else
            % Display the annotated video frame using the video player object
            %step(videoPlayer, videoFrame);
%         end
        imshow(videoFrame);
    end
end

delete(videoPlayer)
clear
close(gcf)

% Release resources
%release(videoFileReader);
%release(videoPlayer);