classdef laserMaster3Form < formFig
    
    methods 
        function FF = laserMaster3Form()
            FF.setTitle('laserMasterForm3 Title');
            FF.gridExtent = [4,8];
            
            FF.addPanel([1 1 3 3]);
            FF.addPanel([1 3 3 5]);
            FF.addPanel([3 1 4 5]);
            
            offsetVal = [0 1 0 1]*4;
            FF.addPanel([1 1 2 2]+offsetVal);
            FF.addPanel([2 1 3 2]+offsetVal);
            FF.addPanel([3 1 4 2]+offsetVal);
            offsetVal = [0 1 0 1]*5;
            FF.addPanel([1 1 2 2]+offsetVal);
            FF.addPanel([2 1 3 2]+offsetVal);
            FF.addPanel([3 1 4 2]+offsetVal);
            offsetVal = [0 1 0 1]*6;
            FF.addPanel([1 1 2 2]+offsetVal);
            FF.addPanel([2 1 3 2]+offsetVal);
            FF.addPanel([3 1 4 2]+offsetVal);
        end
    end
end