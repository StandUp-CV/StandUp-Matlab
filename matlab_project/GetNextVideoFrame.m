function [ frame ] = GetNextVideoFrame(videoFileReader) %#codegen
%GETNEXTVIDEOFRAME Summary of this function goes here
%   Detailed explanation goes here

%% Read a video frame form file reader
frame = step(videoFileReader);

end

