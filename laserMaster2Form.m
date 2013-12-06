classdef laserMaster2Form < formFig
    
    methods 
        function FF = laserMaster2Form()
            FF.renderer = @highResPDF;
            FF.setTitle('laserMasterForm2 Title');
            FF.gridExtent = [2,2];
            FF.setPaperSize = [11 8.5];
            FF.addPanel([1 1 2 2]);
        end
    end
end