classdef pullAllForm < formFig
    
    properties
        maxX = 6
        maxY = 5
    end
    
    methods
        function FF = pullAllForm(varargin)
            
            FF.setTitle('');
            FF.gridExtent = [FF.maxX FF.maxY] + 1;
            FF.setPaperSize([11 8.5]);
            
            for yN = 1:FF.maxY
                for xN = 1:FF.maxX
                    FF.addPanel([xN yN xN+1 yN+1]);
                end
            end
            
            
            if nargin > 0 
                
                % Set the filename
                FF.setFileName(varargin{1});
                
                % Open a temp figure to load axes into
                tempF = figure('Visible','off');
                axList = hgload(varargin{1});
                
                
                if nargin > 1
                    dispList = varargin{2};
                else
                    dispList = 1:length(axList);
                end
                % If we can't fit them all on the page, make another page                
                if length(dispList) > (FF.maxX*FF.maxY)
                    FF.nextPage = pullAllForm(varargin{1},dispList((FF.maxX*FF.maxY + 1):end));
                    dispList((FF.maxX*FF.maxY + 1):end) = [];
                end
                
                % Clone in the dispList
                FF.cloneAxesIn(axList(dispList(:)),1:length(dispList));
                
                % Add IX numbers
                for n = 1:length(dispList)
                    figure(FF.figHandle);
                    set(FF.figHandle,'CurrentAxes',FF.axesList(n));
                    h = text(mean(xlim()),mean(ylim()),num2str(dispList(n)),...
                    'FontUnits','normalized','FontSize',.5,...
                    'HorizontalAlignment','center');
                end
                    
                % Delete the temporary figure
                delete(axList);
                close(tempF);
                
            end
            
            
        end
    end
end