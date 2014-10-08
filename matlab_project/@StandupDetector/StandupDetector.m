classdef StandupDetector %#codegen
    %STANDUPDETECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vid;
        wienerFilter;
    end
    methods
        function obj = set.vid(obj, value)
            obj.vid = value;
        end 
        function value = get.vid(obj)
            value = obj.vid;
        end
        
        function obj = set.wienerFilter(obj, value)
            obj.wienerFilter = value;
        end 
        function value = get.wienerFilter(obj)
            value = obj.wienerFilter;
        end
    end
    methods (Access = public)

        function [ ] = initVideoinput( frameIntervall )
            %INITVIDEOINPUT Summary of this function goes here
            %   Detailed explanation goes here
            % Create video input object. 
            obj.vid = videoinput('winvideo', 1, 'YUY2_320x240');

            % Set video input object properties for this application.
            % Note that example uses both SET method and dot notation method.
            set(obj.vid, 'TriggerRepeat', Inf);
            obj.vid.FrameGrabInterval = frameIntervall;

            % Set value of a video source object property.
            vid_src = getselectedsource(get.vid(obj));
            set(vid_src,'Tag','motion detection setup');
            set(obj.vid,'ReturnedColorSpace','rgb');

            % wiener filter neighbourhood
            obj.wienerFilter = [5 5];
        end
        
        function startVideoStream( obj )
            %STARTVIDEOSTREAM Summary of this function goes here
            %   Detailed explanation goes here

            % Start acquiring frames.
            start(obj.vid)
        end
        
        function [ output_args ] = stepVideo( obj )
            %STEPVIDEO Summary of this function goes here
            %   Detailed explanation goes here
            
            data = getdata(obj.vid,2);
    
            first_img = wiener2(rgb2gray(data(:,:,:,1)), obj.wienerFilter);
            second_img = wiener2(rgb2gray(data(:,:,:,2)), obj.wienerFilter);

            bw_img = im2bw(first_img);

            %[width, height] = size(bw_img);
            %col = width/2;
            %row = height/2;
            %boundary = bwtraceboundary(bw_img,[row, col],'N');


            %plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);

            BW_filled = imfill(bw_img,'holes');
            boundaries = bwboundaries(BW_filled);

            subplot(1,2,1), imshow(first_img)
            hold on;

            for k=1:10
                b = boundaries{k};
                plot(b(:,2),b(:,1),'g','LineWidth',2);
            end

            diff_im = imabsdiff(first_img,second_img);

            subplot(1,2,2), imshow(diff_im);


        end
        
        function stopVideoStream(obj)
            stop(obj.vid)

            delete(obj.vid)
            close(gcf)
        end
    end
    
end

