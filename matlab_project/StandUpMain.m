
% Create video input object. 
vid = videoinput('winvideo', 1, 'YUY2_320x240')
% Start sample with 200 frames
WebcamSample2(vid,1000)
% clean up the mess
delete(vid)
close(gcf)