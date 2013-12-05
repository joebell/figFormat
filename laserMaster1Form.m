classdef laserMaster1Form < formFig
    
    methods 
        function FF = laserMaster1Form()
            FF.renderer = @lowResPDF;
            FF.setTitle('laserMasterForm1 Title');
            FF.gridExtent = [4,8];
            offsetVal = [0 1 0 1]*0;
                FF.addPanel([1 1 2 2]+offsetVal);
                FF.addPanel([2 1 3 2]+offsetVal);
                FF.addPanel([3 1 4 2]+offsetVal);
            offsetVal = [0 1 0 1]*1;
                FF.addPanel([1 1 2 2]+offsetVal);
                FF.addPanel([2 1 3 2]+offsetVal);
                FF.addPanel([3 1 4 2]+offsetVal);
            offsetVal = [0 1 0 1]*2;
                FF.addPanel([1 1 2 2]+offsetVal);
                FF.addPanel([2 1 3 2]+offsetVal);
                FF.addPanel([3 1 4 2]+offsetVal);
            offsetVal = [0 1 0 1]*3;
                FF.addPanel([1 1 2 2]+offsetVal);
                FF.addPanel([2 1 3 2]+offsetVal);
                FF.addPanel([3 1 4 2]+offsetVal);  
                
            FF.addPanel([1 5 4 6]);
            FF.addPanel([1 6 2 7]);FF.addPanel([2 6 3 7]);FF.addPanel([3 6 4 7]);
            FF.addPanel([1 7 2 8]);FF.addPanel([2 7 3 8]);FF.addPanel([3 7 4 8]);
        end
    end
end