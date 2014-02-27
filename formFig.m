%%
%
%   Cheat sheet:
%
%   m - Toggle menu
%   z - Add to workspace
%   a - Add panel
%   c - Copy panel to clipboard
%   x - Cut panel to clipboard
%   v - Paste panel
%   r - Rotate figure
%   n - Next page
%   b - Prev. page
%   t - Tile pages
%   p - Save to PDF
%   [shift] p - Save all pages to PDF
%   q - Close figure
%   [shift] q - Select page 1
%   i,j,k,l - Move panel
%   [shift] i,j,k,l - Expansion
%   [ctrl] i,j,k,l - Contraction 
%   h - Heading (title) of page
%
%
classdef formFig < handle
    properties
        figHandle
        paperSize = [8.5 11];			 % [width height] (in.)
        margins   = [.625 .5 .5 .5];      % [top bot L R] (in.)
        viewScale = .75;                % (Pixels/in.)
        gridExtent
        renderer
        axesList
        axesCoords
        paperAxes
        marginHandles
        titleHandle
        fileName
        nextPage
        prevPage
    end    
    
    methods
        
        function FF = formFig(setGridExtent)
            FF.figHandle = figure('Visible','on',...
                                  'Resize','off','MenuBar','none',...
                                  'Units','inches','KeyPressFcn',{@keyPress,FF},...
                                  'Renderer','Painters');
            FF.paperAxes = axes('Visible','off','Units','normalized');
            FF.renderer = @lowResPDF;
            FF.titleHandle = text(FF.paperSize(1)/2, (FF.paperSize(2) - .563),...
                '','FontUnits','normalized','FontSize',.12/FF.paperSize(2),...
                'HorizontalAlignment','center','VerticalAlignment','baseline');
            if nargin > 0
                FF.gridExtent = setGridExtent;
            else
                FF.gridExtent = [4,6];
            end
            FF.updateFigurePaperPosition()              
        end
        
        function setNextPage(FF,NP)
            FF.nextPage = NP;
            NP.prevPage = FF;
        end
        function setPrevPage(FF,PP)
            FF.prevPage = PP;
            PP.nextPage = FF;
        end     
        function setPaperSize(FF,newSize)
            FF.paperSize = newSize;
            FF.updateFigurePaperPosition()
        end
        
        function updateFigurePaperPosition(FF)

            % Set the screen figure size and position (inches)
            %set(FF.figHandle,...
            %    'PaperPosition',[0, 0, FF.paperSize(1)*FF.viewScale, FF.paperSize(2)*FF.viewScale]); 
            curPos = get(FF.figHandle,'Position');
            set(FF.figHandle,'Position',...
                [curPos(1), curPos(2), FF.paperSize(1)*FF.viewScale, FF.paperSize(2)*FF.viewScale]);

            % Update the paper axes (Norm)
            set(FF.paperAxes,   'XLim',[0 FF.paperSize(1)],...
                                'YLim',[0 FF.paperSize(2)],...
                                'Position',[0,0,1,1]);
            % Update the title position
            set(FF.titleHandle,'Position', [FF.paperSize(1)/2, (FF.paperSize(2) - .563)]);                
                            
            FF.drawMargins();
            FF.refreshPositions(1:length(FF.axesList));
        
        end
        
        function drawMargins(FF)
            if ~isempty(FF.marginHandles)
                delete(FF.marginHandles);
            end
            axes(FF.paperAxes);
            margX = [FF.margins(3), FF.paperSize(1)-FF.margins(4),...
                    FF.paperSize(1)-FF.margins(4), FF.margins(3), ...
                    FF.margins(3)];
            margY = [FF.margins(2), FF.margins(2),...
                     FF.paperSize(2) - FF.margins(1), FF.paperSize(2) - FF.margins(1),...
                     FF.margins(2)];
            FF.marginHandles = line(margX,margY,'Color','k','LineStyle','--');
        end
        
        function setScale(FF,newScale)
            FF.viewScale = newScale;
            % Iteratively set position until stable. Not clear why
            % position changes; probably something in the MATLAB figure
            % manager. Usually converges in 1-3 reps
            targetPosition = [.5, .5, FF.paperSize(1)*FF.viewScale, FF.paperSize(2)*FF.viewScale];
            while ~isequal(get(FF.figHandle,'Position'),targetPosition)
                FF.updateFigurePaperPosition();
                % get(gcf,'Position')
            end
        end
        
        function tileDisplay(FF)
            % Find the base figure
            baseFF = FF;
            while ~(isempty(baseFF.prevPage))
                baseFF = baseFF.prevPage;
            end
            
            % Tile them
            orPos = get(baseFF.figHandle,'Position');
            n = 1;
            set(baseFF.figHandle,'Position',[.25 .25 orPos(3) orPos(4)]);
            while ~isempty(baseFF.nextPage)
                n = n + 1;
                baseFF = baseFF.nextPage;
                orPos = get(baseFF.figHandle,'Position');
                set(baseFF.figHandle,'Position',[.25*n .25*n orPos(3) orPos(4)]);
            end
            
            % Set the focus in order
            figure(baseFF.figHandle);
            while ~isempty(baseFF.prevPage)
                baseFF = baseFF.prevPage;
                figure(baseFF.figHandle);
            end
        end
        
        function addPanel(FF,coords,varargin) % [top left bottom right]
            
            if nargin > 2
                panelN = varargin{1};
            else
                panelN = length(FF.axesList) + 1;
            end
            figure(FF.figHandle);
            FF.axesList(panelN) = axes('XTick',[],'YTick',[],...
                'Units','inches','Visible','on',...
                'ActivePositionProperty','OuterPosition',...
                'Box','on','XLim',[0 1],'YLim',[0 1]);
            FF.axesCoords{panelN} = coords;
            text(.5,.5,num2str(panelN),...
                    'FontUnits','normalized','FontSize',.25,...
                    'HorizontalAlignment','center');
            FF.refreshPositions(panelN);
        end
        
        function refreshPositions(FF, axesNumbers)
            for axesN = axesNumbers
                if (ishandle(FF.axesList(axesN))) && (FF.axesList(axesN) ~= 0)
                    coords = FF.axesCoords{axesN};
                    left = coords(1); top = coords(2);
                    right = coords(3); bottom = coords(4);
                    % Compute coords in relative units
                    [relL, relT] = FF.getRelCoords([left,top]);
                    [relR, relB] = FF.getRelCoords([right,bottom]);
                    relWidth = relR - relL;
                    relHeight = relT - relB;
                    set(FF.axesList(axesN),'Units','normalized',...
                        'OuterPosition',[relL,relB,relWidth,relHeight]);
                end
            end
        end
        

        
        function [relXCoord relYCoord] = getRelCoords(FF,ixCoords)
            
            xIX = ixCoords(1);
            yIX = ixCoords(2);
            relLMargin = FF.margins(3)/FF.paperSize(1);
            relTMargin = FF.margins(1)/FF.paperSize(2);
            writeableXSize = FF.paperSize(1) - FF.margins(3) - FF.margins(4);
            writeableYSize = FF.paperSize(2) - FF.margins(1) - FF.margins(2);
            relXScale = (writeableXSize/FF.paperSize(1))/(FF.gridExtent(1) - 1);
            relYScale = (writeableYSize/FF.paperSize(2))/(FF.gridExtent(2) - 1);
            
            relXCoord = relLMargin + (xIX - 1)*relXScale;
            relYCoord = 1 - relTMargin - (yIX - 1)*relYScale;        
        end
        
        function cloneAxesIn(FF,sourceArray,varargin)
            
            if nargin < 3
                targetIX = 1:length(sourceArray);
            else
                targetIX = varargin{1};
            end
            
            normalizeObjects(sourceArray); % Sets all units to normalized
            for sourceN = 1:length(sourceArray)
                if strcmp(get(sourceArray(sourceN),'Type'),'axes')
                    coords = FF.axesCoords{targetIX(sourceN)};
                    delete(FF.axesList(targetIX(sourceN)));
                    set(sourceArray(sourceN),...
                            'ActivePositionProperty','OuterPosition');
                    FF.axesList(targetIX(sourceN)) = copyobj(sourceArray(sourceN),FF.figHandle);
                    FF.axesCoords{targetIX(sourceN)} = coords; 
                    
                end
            end
            FF.refreshPositions(targetIX);
        end
        
        function setTitle(FF, titleString)
        	set(FF.titleHandle,'String',titleString);
        end
        
        function setFileName(FF, fileName)
            FF.fileName = fileName;
        end

		function close(FF)
			if ~isempty(FF.nextPage)
				FF.nextPage.close();
            end
            FF.prevPage.nextPage = [];
			delete(FF.axesList);
			delete(FF.figHandle);
		end

        
        function PDF(FF,varargin)
            
            if nargin > 1
                fileName = varargin{1};
            else
                if ~isempty(FF.fileName)
                    baseName = strrep(FF.fileName,'.fig','');
                    fileName = [baseName,'.pdf'];
                else
                    fileName = [datestr(now,'yymmdd-HHMMSS'),'.pdf'];
                end
            end
            
            FF.printPreview(true);
            
            % Set the paper size and position
            set(FF.figHandle,'PaperSize',FF.paperSize,...
                'PaperUnits','inches',...
                'PaperPosition',[0, 0, FF.paperSize(1), FF.paperSize(2)],...
                'PaperPositionMode','manual');

            feval(FF.renderer,FF.figHandle,fileName);
        end
        
        function allPDF(FF,varargin)
            
            % Find the base figure
            baseFF = FF;
            while ~(isempty(baseFF.prevPage))
                baseFF = baseFF.prevPage;
            end
            
            % Write a PDF for each figure
            nFig = 0;
            cFF = baseFF;
            CMD = ['pdftk '];
            while ~isempty(cFF)
                cFF.PDF(['t',num2str(nFig+1),'.pdf']);
                CMD = [CMD,'t',num2str(nFig+1),'.pdf '];
                nFig = nFig + 1;
                cFF = cFF.nextPage;
            end
            
            % Get a fileName
            if nargin > 1
                fileName = varargin{1};
            else
                if ~isempty(FF.fileName)
                    if nFig > 1
                        baseName = strrep(FF.fileName,'.fig','');
                        fileName = [baseName,'.pdf'];
                    else
                        baseName = strrep(FF.fileName,'.fig','');
                        fileName = [baseName,'.pdf'];
                    end
                else
                    if nFig > 1
                        fileName = [datestr(now,'yymmdd-HHMMSS'),'p1-p',num2str(nFig),'.pdf'];
                    end
                end
            end
            
            % Concatenate PDFs
            unix([CMD,'cat output ',fileName]);
            
            % Remove temporary PDFs
            for n = 1:nFig
                CMD = ['rm t',num2str(n),'.pdf'];
                unix(CMD);
            end
            
            disp(['Wrote all PDFs to: ',fileName]);
        end
        
        function printPreview(FF,varargin)     
            
            if nargin < 2
                previewOn = true;
            else
                previewOn = varargin{1};
            end
            
            if previewOn            
                set(FF.marginHandles,'Visible','off');
                set(FF.figHandle,'Color','w');
            else
                set(FF.marginHandles,'Visible','on');
                set(FF.figHandle,'Color',[.8 .8 .8]);
            end
            
        end
    end
    
end

function keyPress(callingFig,E, FF)
    
    moveIncrement = .1;
    callingAxis = get(callingFig,'CurrentAxes');
    global copyFigHandle;

    % Read in key modifiers
    if length(E.Modifier) > 0
        if strcmp(E.Modifier{1},'shift')
            shiftOn = true;
            controlOn = false;
        elseif strcmp(E.Modifier{1},'control')
            controlOn = true;
            shiftOn = false;
        else
            shiftOn = false;
            controlOn = false;
        end
    else
        shiftOn = false;
        controlOn = false;
    end

    switch E.Key
        % Toggle menu
        case 'm'
            if strcmp(get(FF.figHandle,'MenuBar'),'figure')
                set(FF.figHandle,'MenuBar','none');
            else
                set(FF.figHandle,'MenuBar','figure');
            end
        case 'z'
            assignin('base','form',FF);
            disp('Grabbed form to workspace.');
        case 'a'
            FF.addPanel([1 1 2 2]);
        % Rotate figure 90 deg
        case 'r'
            FF.paperSize = [FF.paperSize(2) FF.paperSize(1)]; 
            FF.updateFigurePaperPosition();
            set(callingFig,'CurrentAxes',callingAxis);
        % Bring next page to front
        case 'n'
            if ~isempty(FF.nextPage)
                figure(FF.nextPage.figHandle);
            end
        case 'b'
            if ~isempty(FF.prevPage)
                figure(FF.prevPage.figHandle);
            end
        % Tile Display    
        case 't'    
            FF.tileDisplay();
        case 'p'
            if shiftOn
                disp('Saving all PDFs...');
                FF.allPDF();
            else
                disp('Saving PDF...');
                FF.PDF();
            end
        case 'q'
            if shiftOn
            	% Find the base figure
                baseFF = FF;
                while ~(isempty(baseFF.prevPage))
                    baseFF = baseFF.prevPage;
                end
                baseFF.close();
            else
                FF.close();
            end
        % Move modes    
        case 'j'
            % Look for graphics on the panels
            callingPanelN = dsearchn(FF.axesList',callingAxis);
            coords = FF.axesCoords{callingPanelN};
            if shiftOn
                coords(1) = coords(1) - moveIncrement;
            elseif controlOn
                coords(1) = coords(1) + moveIncrement;
            else
                coords([1,3]) = coords([1,3]) - moveIncrement;
            end
            FF.axesCoords{callingPanelN} = coords;
            FF.updateFigurePaperPosition();
            set(callingFig,'CurrentAxes',callingAxis);
        case 'l'
            % Look for graphics on the panels
            callingPanelN = dsearchn(FF.axesList',callingAxis);
            coords = FF.axesCoords{callingPanelN};
            if shiftOn
                coords(3) = coords(3) + moveIncrement;
            elseif controlOn
                coords(3) = coords(3) - moveIncrement;
            else
                coords([1,3]) = coords([1,3]) + moveIncrement;
            end
            FF.axesCoords{callingPanelN} = coords;
            FF.updateFigurePaperPosition();
            set(callingFig,'CurrentAxes',callingAxis);
        case 'i'
            % Look for graphics on the panels
            callingPanelN = dsearchn(FF.axesList',callingAxis);
            coords = FF.axesCoords{callingPanelN};
            if shiftOn
                coords(2) = coords(2) - moveIncrement;
            elseif controlOn
                coords(2) = coords(2) + moveIncrement;
            else
                coords([2,4]) = coords([2,4]) - moveIncrement;
            end
            FF.axesCoords{callingPanelN} = coords;
            FF.updateFigurePaperPosition();
            set(callingFig,'CurrentAxes',callingAxis);
        case 'k'
            % Look for graphics on the panels
            callingPanelN = dsearchn(FF.axesList',callingAxis);
            coords = FF.axesCoords{callingPanelN};
            if shiftOn
                coords(4) = coords(4) + moveIncrement;
            elseif controlOn
                coords(4) = coords(4) - moveIncrement;
            else
                coords([2,4]) = coords([2,4]) + moveIncrement;
            end
            FF.axesCoords{callingPanelN} = coords;
            FF.updateFigurePaperPosition();
            set(callingFig,'CurrentAxes',callingAxis);
         
        % Copy an axis    
        case 'c'
            % Clear existing clipboard
            if ishandle(copyFigHandle)
                delete(copyFigHandle);
            end
            copyFigHandle = figure('Visible','off');
            
            % Look for graphics on the panels
            callingPanelN = dsearchn(FF.axesList',callingAxis);

            % Copy to the clipboard
            copyobj(callingAxis,copyFigHandle);
            disp('Axis copied to clipboard.');

            
            % Reset current figure
            figure(callingFig);
            set(callingFig,'CurrentAxes',callingAxis);

        case 'x'
            % Clear existing clipboard
            if ishandle(copyFigHandle)
                delete(copyFigHandle);
            end
            copyFigHandle = figure('Visible','off');
            
            % Look for graphics on the panels
            callingPanelN = dsearchn(FF.axesList',callingAxis);
                
                % Copy to the clipboard
                copyobj(callingAxis,copyFigHandle);
                disp('Axis copied to clipboard.');
                
                % Delete the old axis and replace it with a blank panel
                coords = FF.axesCoords{callingPanelN};
                callingPanelN = dsearchn(FF.axesList',callingAxis);
                delete(callingAxis);
                
                % Reset current figure
                figure(callingFig);
                
                FF.addPanel(coords,callingPanelN);
                disp('Axis CUT to clipboard.');
                      
        case 'v'
            if ~ishandle(copyFigHandle)
                disp('Nothing copied to clipboard.');
                return;
            end
            
            % Delete the old axis and replace it with a blank panel
            callingPanelN = dsearchn(FF.axesList',callingAxis);
            coords = FF.axesCoords{callingPanelN};
            delete(callingAxis);
            FF.addPanel(coords,callingPanelN);
            FF.cloneAxesIn(get(copyFigHandle,'CurrentAxes'),callingPanelN);
            
            % Reset current figure
            figure(callingFig);
            disp('Axis pasted from clipboard.');
            set(callingFig,'CurrentAxes',FF.axesList(callingPanelN));
        case 'h'
            % Print a heading title
            headString = input('Enter a title: ','s');
            FF.setTitle(headString);

    end
    
    
    
end
            

    
    
    
    
