function aPage = formPage()

aPage.paperSize = [8.5 11];			% [width height] (in.)
aPage.margins   = [.5 .5 .5 .5];	% [top bot L R] (in.)
aPage.gridExtent = [4, 6];

aPage.figHandle = figure();

xExtent = aPage.paperSize(1) - sum(aPage.margins(3:4));
yExtent = aPage.paperSize(2) - sum(aPage.margins(1:2));
unitWidth  = xExtent/(aPage.gridExtent(1) - 1);
unitHeight = yExtent/(aPage.gridExtent(2) - 1); 

aPage.fractExtent.x = meshgrid(1:aPage.gridExtent(1),1:aPage.gridExtent(2));

	marginFractions(1:2) = aPage.margins(1:2)./aPage.paperSize(2);
	marginFractions(3:4) = aPage.margins(3:4)./aPage.paperSize(1);

function handle = newPlot(top,bot,left,right)

	handle = blankAxis();
end

function handle = blankAxis()

	handle = axes();
	set(handle,'XTick',[],'YTick',[]);
end

end



