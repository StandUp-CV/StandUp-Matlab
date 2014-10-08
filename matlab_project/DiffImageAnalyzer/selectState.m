function [ handles ] = selectState( handles, horiz, vertic )
%SELECTSTATE selects the next state of the person.
%   Changes the state according to the last one and the registered
%   movements.
    if (handles.stateUpdateFlag == false)
        return;
    end
    %% Change the current state
    % current state is sleeping
    if (handles.currentStateNo == 1)
        % movement registered this frame is horizontal or vertical
        if (horiz)
            handles = setState(2, handles);
        elseif (vertic)
            handles = setState(2, handles);
        end
    % current state is up
    elseif (handles.currentStateNo == 2)
        % movement registered this frame is horizontal or vertical
        if (horiz)
            handles = setState(5, handles);
        elseif (vertic)
            handles = setState(3, handles);
        end
    % current state is down
    elseif (handles.currentStateNo == 3)
        % movement registered this frame is horizontal or vertical
        if (horiz)
        elseif (vertic)
            handles = setState(2, handles);
        end
    % current state is in
    elseif (handles.currentStateNo == 4)
        % movement registered this frame is horizontal or vertical
        if (horiz)
            handles = setState(5, handles);
        elseif (vertic)
            handles = setState(3, handles);
        end
    % current state is out
    elseif (handles.currentStateNo == 5)
        % movement registered this frame is horizontal or vertical
        if (horiz)
            handles = setState(4, handles);
        elseif (vertic)
        end
    else
        
    end
    %% Change GUI state label
    set(handles.stateLabel,'String',char(handles.currentState.state));
    handles.stateUpdateFlag = false;
end

function handles = setState(stateNumber, handles)
%SETSTATE sets the state for the person/camera
    handles.currentStateNo = stateNumber;
    handles.currentState.state = handles.personState(stateNumber).state;
    handles.timerCounter = 0;
    switch (stateNumber)
        case 1 % 'sleeping'
            handles.timerMax = 10;
        case 2 % 'up'
            handles.timerMax = 30;
        case 3 % 'down'
            handles.timerMax = 30;
        case 4 % 'in'
            handles.timerMax = 20;
        case 5 % 'out'
            handles.timerMax = 20;
    end
end

