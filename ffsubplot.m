% Function for generating subplots in the style of MATLAB's subplot
function FF = ffsubplot(rows, cols, number)

    nFigs = length(get(0,'Children'));
    if nFigs > 0
        % If there's an existing figure, see if it's empty
        if length(get(gcf,'Children')) == 0
            % If it's empty, close it and make a new formFig
            close(gcf);
            FF = formFig([cols+1,rows+1]);
        else
            % If it's not empty, see if it's already a formFig
            keyArgs = get(gcf,'KeyPressFcn');
            if length(keyArgs) ~= 2
                % If not a formFig and isn't empty, just do a regular subplot.
                subplot(rows,cols,number);
                return;
            else
                % If it is already a formFig, keep going with it.
                FF = keyArgs{2};
            end
        end
    else
        % If there's no existing figure, make one.
        FF = formFig([cols+1,rows+1]);
    end

    if (length(number) == 1)
        % Single pane axis
        if (length(FF.axesList) >= number) && (ishandle(FF.axesList(number))) && ...
                (FF.axesList(number) ~= 0)
            % If there's already an existing axis number, make it current
            set(FF.figHandle,'CurrentAxes',FF.axesList(number));
        else
            % If there's not an existing axis number, make one.
            rowN = floor((number-1)/cols)+1;
            colN = mod(number-1,cols)+1;
            FF.addPanel([colN rowN colN+1 rowN+1],number);
        end
    else
        % Multiple pane axis
        if (length(FF.axesList) >= number(1)) && (ishandle(FF.axesList(number(1)))) && ...
                (FF.axesList(number(1)) ~= 0)
            % If there's already an existing axis number, make it current
            set(FF.figHandle,'CurrentAxes',FF.axesList(number(1)));
        else
            % If there's not an existing axis number, make one.
            rowN = floor((number-1)./cols)+1;
            colN = mod(number-1,cols)+1;
            rowMin = min(rowN); rowMax = max(rowN);
            colMin = min(colN); colMax = max(colN)
            FF.addPanel([colMin rowMin colMax+1 rowMax+1],number(1));
        end
    end


