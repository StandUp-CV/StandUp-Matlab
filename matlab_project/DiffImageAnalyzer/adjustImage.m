function imgCorrect = adjustImage( img )
%adjustImage correct the image
%   streches the histogram of the image (historgram linearizing) and appys
%   a gamma correction by gamma=1.1
    % find max gray-value
    % convert matrix to vector and get maximum 
    maxValue = max(img(:));
    % find min gray-value    
    % get a vector with minimums of each column. get min
    minValue = min(min(img));

    if (maxValue == minValue)
        imgCorrect = img;
    else
        % correct the image
        imgCorrect = imadjust( img, [double(minValue)/255 double(maxValue)/255], [0 1], 1.1 );
    end
end

