function RTFWmapFigures1(fileName)

    axesArray = hgload(fileName);
    titleString = get(axesArray(1),'String');
    
    form1 = laserMaster1Form();
    
    form1.setTitle(titleString);
    form1.cloneAxesIn(axesArray([1:19]+1,1:19));
    form1.setFileName = fileName;