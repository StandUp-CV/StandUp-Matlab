function handles = response( topMotion, leftMotion, rightMotion, handles )
%RESPONSE analyses the motion values into a GUI response.
%   Checks for left, right and top values above a defined value and returns
%   GUI changes.

    % Left motion found?
    if (leftMotion > 0.15)
        % Change GUI response label
        set(handles.response,'String','Left In/Out');
        % selects the next state of the person
        handles = selectState(handles, true, false);
    % Right motion found?
    elseif (rightMotion > 0.15)
        % Change GUI response label
        set(handles.response,'String','Right In/Out');
        % selects the next state of the person
        handles = selectState(handles, true, false);
    % Top motion found?
    elseif (topMotion > 0.1)
        % Change GUI response label
        set(handles.response,'String','Top In/Out');
        % selects the next state of the person
        handles = selectState(handles, false, true);
    else
        % Change GUI response label
        set(handles.response,'String','Nothing');
    end
end

