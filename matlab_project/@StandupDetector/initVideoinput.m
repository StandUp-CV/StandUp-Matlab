function [ output_args ] = initVideoinput( frameIntervall )
%INITVIDEOINPUT Summary of this function goes here
%   Detailed explanation goes here
% Create video input object. 
vid = videoinput('winvideo', 1, 'YUY2_320x240')

% Set video input object properties for this application.
% Note that example uses both SET method and dot notation method.
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = frameIntervall;

% Set value of a video source object property.
vid_src = getselectedsource(vid);
set(vid_src,'Tag','motion detection setup');
set(vid,'ReturnedColorSpace','rgb');

% wiener filter neighbourhood
wienerFilter = [5 5];
end

