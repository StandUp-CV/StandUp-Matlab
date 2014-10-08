
% Create video input object. 
vid = videoinput('winvideo', 1, 'YUY2_320x240')

% Set video input object properties for this application.
% Note that example uses both SET method and dot notation method.
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = 3;

% Set value of a video source object property.
vid_src = getselectedsource(vid);
set(vid_src,'Tag','motion detection setup');
set(vid,'ReturnedColorSpace','rgb');

% Create a figure window.
figure; 
% wiener filter neighbourhood
wienerFilter = [5 5];
% top, left and right boundary
top = 120;
left = 40;
right = 200;
% Start acquiring frames.
start(vid)

% Calculate difference image and display it.
while(vid.FramesAcquired<=100) % Stop after 100 frames
    data = getdata(vid,2);
    
    first_img = wiener2(rgb2gray(data(:,:,:,1)), wienerFilter);
    second_img = wiener2(rgb2gray(data(:,:,:,2)), wienerFilter);
    
    bw_img = im2bw(first_img);
    
    [width, height] = size(bw_img);
    %col = width/2;
    %row = height/2;
    %boundary = bwtraceboundary(bw_img,[row, col],'N');
    
    
    %plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);
    
    BW_filled = imfill(bw_img,'holes');
    boundaries = bwboundaries(BW_filled);
    
    subplot(1,4,3), imshow(first_img)
    hold on;
    
    for k=1:length(boundaries)
        b = boundaries{k};
        plot(b(:,2),b(:,1),'g','LineWidth',2);
    end
    
    diff_im = imabsdiff(first_img,second_img);
    
    subplot(1,4,1), imshow(first_img);
    subplot(1,4,2), imshow(second_img);
    subplot(1,4,4), imshow(diff_im);

end

stop(vid)

delete(vid)
close(gcf)