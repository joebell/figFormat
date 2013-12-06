classdef axesContainer < handle
    
    properties       
        axesList
        fileName
        title        
    end
    
    methods
        
        function AC = axesContainer(varargin)
            if nargin == 1
                AC.setFileName(varargin{1});
            elseif nargin == 2
                AC.setFileName(varargin{1});
                AC.setTitle(varargin{2});
            end
        end
            
        function addAxis(AC, axisHandle)
            AC.axesList(end+1) = axisHandle;
        end
        
        function setFileName(AC,fileName)
            AC.fileName = fileName;
        end
        
        function setTitle(AC,title)
            AC.title = title;
        end
    end