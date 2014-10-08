%clear
close all

% Create a figure window.
%diff_frame = figure; 

hOpticalFlow = vision.OpticalFlow( ...
    'OutputValue', 'Horizontal and vertical components in complex form', ...
    'ReferenceFrameDelay', 2);
hMean1 = vision.Mean;
hMean2 = vision.Mean('RunningMean', true);

hMedianFilt = vision.MedianFilter;

hclose = vision.MorphologicalClose('Neighborhood', strel('square',8));

hblob = vision.BlobAnalysis(...
    'CentroidOutputPort', false, 'AreaOutputPort', true, ...
    'BoundingBoxOutputPort', true, 'ExtentOutputPort', true, ...
    'OutputDataType', 'double', ...
    'MinimumBlobArea', 500, 'MaximumBlobArea', 4000, 'MaximumCount', 10);

herode = vision.MorphologicalErode('Neighborhood', strel('square',4));

hshapeins1 = vision.ShapeInserter('BorderColor', 'Custom', ...
                                  'CustomBorderColor', [0 1 0]);
hshapeins2 = vision.ShapeInserter('Shape','Lines', ...
                                   'BorderColor', 'Custom', ...
                                   'CustomBorderColor', [255 255 0]);

htextins = vision.TextInserter('Text', '%4d', 'Location',  [1 1], ...
                               'Color', [1 1 1], 'FontSize', 12);
sz = get(0,'ScreenSize');
pos = [20 sz(4)-500 640 480];
hVideo1 = vision.VideoPlayer('Name','Original Video','Position',pos);
pos2 = pos(1);
pos(1) = pos(1)+660; % move the next viewer to the right
hVideo2 = vision.VideoPlayer('Name','Motion Vector','Position',pos);
pos(1) = pos2;
pos(2) = pos(2)-500;
hVideo3 = vision.VideoPlayer('Name','Thresholded Video','Position',pos);
pos(1) = pos(1)+640;
hVideo4 = vision.VideoPlayer('Name','Results','Position',pos);

% Initialize variables used in plotting motion vectors.
lineRow   =  22;
firstTime = true;
motionVecGain  = 20;
borderOffset   = 5;
decimFactorRow = 5;
decimFactorCol = 5;
exitVid = false; 

% Create video input object. 
vid = videoinput('winvideo', 1, 'YUY2_640x480')

% Set video input object properties for this application.
% Note that example uses both SET method and dot notation method.
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = 5;
vid.ReturnedColorSpace = 'rgb';
%set(vid,'ReturnedColorSpace','rgb');

% Set value of a video source object property.
vid_src = getselectedsource(vid);
set(vid_src,'Tag','motion detection setup');
set(vid,'ReturnedColorSpace','rgb');

% Start acquiring frames.
%preview(vid);
start(vid)

while vid.FramesAcquired<=100  % Stop when end of file is reached
    
    frame = im2double(getdata(vid,1)); 

    %frame_org = getdata(vid,1);
    %frame  = step(hVidReader);  % Read input video frame
    grayFrame = rgb2gray(frame);
    
    %frame_fft = fft2(grayFrame);
    frame_wiener = wiener2(grayFrame, [5 5]);
    %frame_wiener = ifft(frame_fft_wiener);
    
    ofVectors = step(hOpticalFlow, frame_wiener);   % Estimate optical flow

    % The optical flow vectors are stored as complex numbers. Compute their
    % magnitude squared which will later be used for thresholding.
    y1 = ofVectors .* conj(ofVectors);
    % Compute the velocity threshold from the matrix of complex velocities.
    vel_th = 0.5 * step(hMean2, step(hMean1, y1));

    % Threshold the image and then filter it to remove speckle noise.
    segmentedObjects = step(hMedianFilt, y1 >= vel_th);

    % Thin-out the parts of the road and fill holes in the blobs.
    segmentedObjects = step(hclose, step(herode, segmentedObjects));

    % Estimate the area and bounding box of the blobs.
    [area, bbox, extent] = step(hblob, segmentedObjects);
    % Select boxes inside ROI (below white line).
    Idx = bbox(:,1) > lineRow;

    % Based on blob sizes, filter out objects which are unlikely to be
    % cars. When the extent property of a blob exceeds 0.4 (40%),
    % classify it as a car.
    isCar = extent > 0.4;
    numCars = sum(isCar);   % Number of cars
    bbox(~isCar, :) = [];   % Keep only the bounding boxes for objects
                            % classifed as cars.

    % Draw bounding boxes around the tracked cars.
    y2 = step(hshapeins1, frame, bbox);

    % Display the number of cars tracked and a white line showing the ROI.
    y2(22:23,:,:)   = 1;   % The white line.
    y2(1:15,1:30,:) = 0;   % Background for displaying count
    result = step(htextins, y2, int32(numCars));

    % Generate coordinates for plotting motion vectors.
    if firstTime
      [R C] = size(ofVectors);            % Height and width in pixels
      RV = borderOffset:decimFactorRow:(R-borderOffset);
      CV = borderOffset:decimFactorCol:(C-borderOffset);
      [Y X] = meshgrid(CV,RV);
      firstTime = false;
    end

    % Calculate and draw the motion vectors.
    tmp = ofVectors(RV,CV) .* motionVecGain;
    lines = [Y(:), X(:), Y(:) + real(tmp(:)), X(:) + imag(tmp(:))];
    motionVectors = step(hshapeins2, frame, lines);

    % Display the results
    %imshow(frame_org);
    step(hVideo1, frame_wiener);            % Original video
    step(hVideo2, motionVectors);    % Video with motion vectors
    step(hVideo3, segmentedObjects); % Thresholded video
    step(hVideo4, result);           % Video with bounding boxes
    %hold on;
end
stop(vid)

delete(vid)
clear
close(gcf)
