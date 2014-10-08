function varargout = Standup_GUI(varargin)
% STANDUP_GUI MATLAB code for Standup_GUI.fig
%      STANDUP_GUI, by itself, creates a new STANDUP_GUI or raises the existing
%      singleton*.
%
%      H = STANDUP_GUI returns the handle to a new STANDUP_GUI or the handle to
%      the existing singleton*.
%
%      STANDUP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STANDUP_GUI.M with the given input arguments.
%
%      STANDUP_GUI('Property','Value',...) creates a new STANDUP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Standup_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Standup_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Standup_GUI

% Last Modified by Hans Ferchland v2.5 20-Dec-2012 17:03:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Standup_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Standup_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Standup_GUI is made visible.
function Standup_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Standup_GUI (see VARARGIN)

% Choose default command line output for Standup_GUI
handles.output = hObject;
% possible states of the person (1, 2, 3, 4, 5)
handles.personState = struct('state', {'sleeping', 'up', 'down', 'in', 'out'});
% current state index
handles.currentStateNo = 1;
% current state of the person
handles.currentState = handles.personState(handles.currentStateNo);
% create video input handle from plug and play hardware (must support
% YUY2_320x240)
handles.vid = videoinput('winvideo', 1, 'YUY2_320x240');
handles.stateUpdateFlag = true;
handles.timerCounter = 0;
handles.timerMax = 25;
% Update handles structure
guidata(hObject, handles);
webcamStream(handles.vid, handles, hObject);
% UIWAIT makes Standup_GUI wait for user response (see UIRESUME)
% uiwait(handles.standup);

% --- Outputs from this function are returned to the command line.
function varargout = Standup_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function webcamStream(vid, handles, hObject)
%% Set video input object properties for this application.
% Set Framegrab intervall to every two frames
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = 2;

%% Set value of a video source object property.
% set source for video
vid_src = getselectedsource(vid);
% set a tag for the webcam stream
set(vid_src,'Tag','motion detection setup');
% set color space to rgb
set(vid,'ReturnedColorSpace','rgb');

%% Start acquiring frames.
start(vid)

%% Declare variables
% wiener filter neighbourhood
wienerFilter = [7 7];
% segmentatiio parameter for threshold adjustment
fudgeFactor = .5;
% top, left and right boundary
data = getdata(vid,1);
% find out the initial width and height
first_gray = rgb2gray(data(:,:,:,1));
[height, width] = size(first_gray);
height = uint32(height);
width = uint32(width);
% calculate the side space and top space
top = uint32(0.33 * height);
left = uint32(0.2 * width);
right = uint32(0.8 * width);
% holds the values for motion percentage for the last 5 frames
topAverage = [0 0 0 0 0];
leftAverage = [0 0 0 0 0];
rightAverage = [0 0 0 0 0];
% current value in calculation for the average motion value
avgCounter = 1;
avgValues = 5;
% handle for the GUI frame
axes(handles.cameraStream);

%% Calculate difference image and display it.
while( isvalid(vid) ) %vid.FramesAcquired<=frameCount+2) % Stop after 100 frames
    %% Get data from the last two frames
    data = getdata(vid,2);
    % increase the framecounter
    frameCounter = vid.FramesAcquired;
    
    %% get images from data
    first_gray = rgb2gray(data(:,:,:,1));
    second_gray = rgb2gray(data(:,:,:,2));
    % smooth images with wiener filter
    first_img_wiener =  wiener2(first_gray, wienerFilter);
    second_img_wiener = wiener2(second_gray, wienerFilter);

    %% calculate the difference
    % adjust the histogram and calc the difference
    diff_im_wiener = adjustImage( imabsdiff(first_img_wiener, second_img_wiener) );
    
    %% Boundary Segmentation
    segout = boundaryDetect( diff_im_wiener, fudgeFactor );
    
    %% get the top, left and right part of the image
    % parts for the segmentation components
    top_im_seg = segout(1:top,left:right);
    left_im_seg = segout(top:height,1:left);
    right_im_seg = segout(top:height,right:width);
    % parts for the motion components
    top_im_diff = diff_im_wiener(1:top,left:right);
    left_im_diff = diff_im_wiener(top:height,1:left);
    right_im_diff = diff_im_wiener(top:height,right:width);
   
    %% Analyse the motion and segmentation in the picture
    topMotion = analyseMotion(top_im_diff, top_im_seg, 64);
    leftMotion = analyseMotion(left_im_diff, left_im_seg, 64);
    rightMotion = analyseMotion(right_im_diff, right_im_seg, 64);
    % get the current values and write them into average array
    topAverage(avgCounter) = topMotion;
    leftAverage(avgCounter) = leftMotion;
    rightAverage(avgCounter) = rightMotion;
    % calculate the average from the last five values
    topAvg = sum(topAverage)/avgValues;
    leftAvg = sum(leftAverage)/avgValues;
    rightAvg = sum(rightAverage)/avgValues;
    
    %% Print results for the frame in the GUI
    set(handles.leftValueAvg,'String',topAvg);
    set(handles.topValueAvg,'String',leftAvg);
    set(handles.rightValueAvg,'String',rightAvg);
    
    set(handles.leftValueCur,'String',leftMotion);
    set(handles.topValueCur,'String',topMotion);
    set(handles.rightValueCur,'String',rightMotion);
    
    set(handles.frameCount,'String',frameCounter);
    
    %% Respond via GUI according to the average values
    handles = response(topAvg, leftAvg, rightAvg, handles);
    %% Counter for average of the values of motion
    if (avgCounter < avgValues)
        avgCounter = avgCounter + 1;
    else
        avgCounter = 1; 
    end
    
    if (handles.timerCounter < handles.timerMax)
        handles.timerCounter = handles.timerCounter + 1; 
    else
        handles.timerCounter = 0;
        handles.stateUpdateFlag = true;
    end
    
    %% Show plots for each part analyzed
    % normal image and wiener image
    subplot(2,1,1), imshowpair(first_gray, first_img_wiener, 'montage'); axis off;
    % segmentation and image difference
    subplot(2,1,2), imshowpair(segout, diff_im_wiener, 'montage'); axis off;
    
    %% Update handles structure
    guidata(hObject, handles);
end
%% stop video
stop(vid)

% --- Executes when user attempts to close standup.
function standup_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to standup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% delete the video handle at closing
delete(handles.vid);
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes when standup is resized.
function standup_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to standup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
