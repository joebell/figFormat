classdef axesContainer < handle
    
    properties       
        axesList      
    end
    
    methods
        
        function AC = axesContainer(varargin)
            if nargin == 0
                AC.setTitle('');
            if nargin == 1
                AC.setTitle(varargin{1});
            end
        end
            
        function addAxis(AC, axisHandle)
            AC.axesList(end+1) = axisHandle;
        end
        
        function setTitle(AC,title)
            figH = figure('Visible','off');
            textH = text(0,0,title);
            AC.addAxis(textH); 
        end
    end
    
end