classdef RTFWForm4 < formFig
    
    methods 
        function FF = RTFWForm4()
            FF.renderer = @lowResPDF;
            FF.setTitle('RTFWForm4 Title');

            FF.gridExtent = [7,19];

            FF.addPanel([1 1 4 3]);
            FF.addPanel([1 3 4 5]);
            FF.addPanel([1 5 4 7]);
            FF.addPanel([1 7 4 9]);
            
            FF.addPanel([4 1 7 13]);
            
            FF.addPanel([1 9 4 12]);
            FF.addPanel([1 12 4 15]);
            FF.addPanel([1 15 4 19]);

            %FF.addPanel([4 13 7 19]);
            for col = 0:2
                for row = 0:2
                    FF.addPanel([4+col 13+2*row 5+col 15+2*row]);
                end
            end

        end
    end
end