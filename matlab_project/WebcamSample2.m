function WebcamSample2( vid, frameCount )

%% Set video input object properties for this application.
% Note that example uses both SET method and dot notation method.
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = 2;

%% Set value of a video source object property.
vid_src = getselectedsource(vid);
set(vid_src,'Tag','motion detection setup');
set(vid,'ReturnedColorSpace','rgb');


%% Create a figure window.
mainFrame = figure;
%% Start acquiring frames.
start(vid)
%% Declare variables
%wiener filter neighbourhood
wienerFilter = [5 5];
% top, left and right boundary
data = getdata(vid,2);
first_img =  wiener2(rgb2gray(data(:,:,:,1)), wienerFilter);
second_img = wiener2(rgb2gray(data(:,:,:,2)), wienerFilter);
diff_im = imabsdiff(first_img,second_img);
[height, width] = size(diff_im);
height = uint32(height);
width = uint32(width);
top = uint32(0.33 * height);
left = uint32(0.2 * width);
right = uint32(0.8 * width);
topMotion = 0;
%% Calculate difference image and display it.
while(vid.FramesAcquired<=frameCount+2) % Stop after 100 frames
    %% Get data from the last two frames
    data = getdata(vid,2);
    
    first_img =  wiener2(rgb2gray(data(:,:,:,1)), wienerFilter);
    second_img = wiener2(rgb2gray(data(:,:,:,2)), wienerFilter);
    
    %% calculate the difference
    diff_im = adjustImage( imabsdiff(first_img,second_img) );
    %[height, width] = size(diff_im);
    
    %% get the top, left and right part of the image
    top_im = diff_im(1:top,:);
    left_im = diff_im(:,1:left);
    right_im = diff_im(:,right:width);
    
    %% Show plots for each part analyzed
%     subplot(2,3,1), imshow(first_img);
%     subplot(2,3,2), imshow(second_img);
%     subplot(2,3,3), imshow(diff_im);
%     
%     subplot(2,3,4), imshow(top_im);
%     subplot(2,3,5), imshow(left_im);
%     subplot(2,3,6), imshow(right_im);
    
    subplot(2,2,1), imshow(first_img);
    subplot(2,2,2), imshow(top_im);
    subplot(2,2,3), imshow(left_im);
    subplot(2,2,4), imshow(right_im);
    %% Analyse the motion in the picture
    topMotion = analyseMotion(top_im,32);
    leftMotion = analyseMotion(left_im,32);
    rightMotion = analyseMotion(right_im,32);
    %% Print results for the frame
    fprintf('Top: %.3f Left: %.3f Right: %.3f\n', topMotion, leftMotion, rightMotion);
end
%% stop video
stop(vid)

end

