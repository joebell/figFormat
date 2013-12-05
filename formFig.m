classdef formFig < handle
    
    properties
        figHandle
        paperSize = [8.5 11];			% [width height] (in.)
        margins   = [.75 .5 .5 .5];       % [top bot L R] (in.)
        viewScale = .5;                 % (Pixels/in.)
        gridExtent
        renderer
        axesList
        unusedAxes
        paperAxes
        marginHandles
        titleHandle
    end
    
    methods
        
        function FF = formFig(setGridExtent)
            FF.figHandle = figure('Visible','on',...
                                  'Resize','off','MenuBar','none',...
                                  'Units','inches');
            FF.paperAxes = axes('Visible','off','Units','normalized');
            FF.renderer = @lowResPDF;
            FF.titleHandle = text(FF.paperSize(1)/2, (FF.paperSize(2) - .625),...
                'Title','FontUnits','normalized','FontSize',.2/FF.paperSize(2),...
                'HorizontalAlignment','center','VerticalAlignment','baseline');
            if nargin > 0
                FF.gridExtent = setGridExtent;
            else
                FF.gridExtent = [4,6];
            end
            FF.updateFigurePaperPosition()              
        end
        
        function updateFigurePaperPosition(FF)

            % Set the screen figure size and position (inches)
            %set(FF.figHandle,...
            %    'PaperPosition',[0, 0, FF.paperSize(1)*FF.viewScale, FF.paperSize(2)*FF.viewScale]); 
            set(FF.figHandle,'Position',...
                [.5, .5, FF.paperSize(1)*FF.viewScale, FF.paperSize(2)*FF.viewScale]);

            % Update the paper axes (Norm)
            set(FF.paperAxes,   'XLim',[0 FF.paperSize(1)],...
                                'YLim',[0 FF.paperSize(2)],...
                                'Position',[0,0,1,1]);
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
        
        function addPanel(FF,coords) % [top left bottom right]
            FF.axesList(end+1) = axes('XTick',[],'YTick',[],...
                'Units','inches','UserData',coords,'Visible','on',...
                'Box','on','XLim',[0 1],'YLim',[0 1]);
            panelN = length(FF.axesList);
            text(.5,.5,num2str(panelN),...
                    'FontUnits','normalized','FontSize',.25,...
                    'HorizontalAlignment','center');
            FF.unusedAxes(end+1) = true;
            FF.refreshPositions(panelN);
        end
        
        function refreshPositions(FF, axesNumbers)
            for axesN = axesNumbers
                coords = get(FF.axesList(axesN),'UserData');
                left = coords(1); top = coords(2);
                right = coords(3); bottom = coords(4);
                % Compute coords in relative units
                [relL, relT] = FF.getRelCoords([left,top]);
                [relR, relB] = FF.getRelCoords([right,bottom]);
                relWidth = relR - relL;
                relHeight = relT - relB;
                set(FF.axesList(axesN),'Units','normalized',...
                    'OuterPosition',[relL,relB,relWidth,relHeight]);
                if FF.unusedAxes(axesN)
                	% Make the empty panel fill the full range
                    OP = get(FF.axesList(axesN),'OuterPosition');
                    set(FF.axesList(axesN),'Position',OP);
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
            
            for sourceN = 1:length(sourceArray)
                coords = get(FF.axesList(targetIX(sourceN)),'UserData');
                delete(FF.axesList(targetIX(sourceN)));
                FF.axesList(targetIX(sourceN)) = copyobj(sourceArray(sourceN),FF.figHandle);
                set(FF.axesList(targetIX(sourceN)),'UserData',coords); 
            end
            FF.unusedAxes(targetIX) = false;
            FF.refreshPositions(targetIX);
        end
        
        function setTitle(FF, titleString)
        	set(FF.titleHandle,'String',titleString);
        end
        
        function PDF(FF,fileName)
            
            FF.printPreview(true);
            
            % Set the paper size and position
            set(FF.figHandle,'PaperSize',FF.paperSize,...
                'PaperUnits','inches',...
                'PaperPosition',[0, 0, FF.paperSize(1), FF.paperSize(2)],...
                'PaperPositionMode','manual');

            feval(FF.renderer,FF.figHandle,fileName);
        end
        
        function printPreview(FF,varargin)     
            
            if nargin < 2
                previewOn = true;
            else
                previewOn = varargin{1};
            end
            
            if previewOn            
                for axesN = find(FF.unusedAxes == true)
                    axisChildren = get(FF.axesList(axesN),'Children');
                    set(axisChildren,'Visible','off');
                    set(FF.axesList(axesN),'Visible','off');
                end
                set(FF.marginHandles,'Visible','off');
                set(FF.figHandle,'Color','w');
            else
                for axesN = find(FF.unusedAxes == true)
                    axisChildren = get(FF.axesList(axesN),'Children');
                    set(axisChildren,'Visible','on');
                    set(FF.axesList(axesN),'Visible','on');
                end
                set(FF.marginHandles,'Visible','on');
                set(FF.figHandle,'Color',[.8 .8 .8]);
            end
            
        end
    end
    
end
    
    
    
    