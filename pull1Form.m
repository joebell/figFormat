classdef pull1Form < formFig
    
    methods
        function FF = pull1Form(varargin)
            
            FF.gridExtent = [2,2];
            FF.setTitle('');
            FF.addPanel([1 1 2 2]);
            
            if nargin == 0
            elseif nargin == 2
                FF.setFileName(varargin{1});   
                axToClone = varargin{2};
                axList = hgload(varargin{1});
                size(axList)
                FF.cloneAxesIn(axList(axToClone),1);
            end
        end
    end
end