clear; clc; close all; 

%% Read a video frame and run the detector.
videoFileReader = vision.VideoFileReader('samplevideos/sample4.mp4');

%% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();
noseDetector = vision.CascadeObjectDetector('Nose');

%% Create a video player object for displaying video frames.
% videoInfo    = info(videoFileReader);
% videoPlayer  = vision.VideoPlayer('Position',[300 300 videoInfo.VideoSize+30]);
figure;
%% Track the face over successive video frames until the video is finished.
while ~isDone(videoFileReader)

    % Extract the next video frame
    videoFrame = im2bw(step(videoFileReader));
    % Analyse frame for persons and positions of them
    %[ personCount, positions ] = AnalyseVideoFrame( videoFrame, faceDetector, noseDetector );
    imshow(videoFrame);
    
    % Step the player window forward
    %step(videoPlayer, videoFrame);
end

%% Release resources
release(videoFileReader);
release(videoPlayer);