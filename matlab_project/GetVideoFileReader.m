function [ videoFileReader ] = GetVideoFileReader( path )
%GETVIDEOFILEREADER Summary of this function goes here
%   Detailed explanation goes here
    path = 'samplevideos/sample4.mp4';
    videoFileReader = vision.VideoFileReader(path);

end

