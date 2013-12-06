function form1 = RTFWmapFigures1(fileName)

    f = figure('Visible','off');
    axesArray = hgload(fileName);
    titleString = get(axesArray(1),'String');
    
    form1 = laserMaster1Form();
    form1.setTitle(titleString);
    form1.setFileName(fileName);
    form1.cloneAxesIn(axesArray([1:12]+1),1:12);
    form1.cloneAxesIn(axesarray(14),13);
    
    form2 = laserMaster2Form();
    form1.nextPage = form2;
    form2.setTitle(titleString);
    form2.setFileName(fileName);
    form2.cloneAxesIn(21,1);
    
    form3 = laserMaster3Form();
    form2.nextPage = form3;
    form3.setTitle(titleString);
    form3.setFileName(fileName);
    form3.cloneAxesIn(15:17,1:3);
    form3.cloneAxesIn(18:19,4:5);
    form3.cloneAxesIn(38:55,6:23);
    form3.cloneAxesIn(56,24);
    
    form4 = laserMaster4Form();
    form3.nextPage = form4;
    form4.setTitle(titleString);
    form4.setFileName(fileName);
    form4.cloneAxesIn(34:36,1:4);
    form4.cloneAxesIn(24,5);
    form4.cloneAxesIn(22,6);
    form4.cloneAxesIn(23,7);
    form4.cloneAxesIn(20,8);
    form4.cloneAxesIn(25:33,9:17);
    
    delete(axesArray);
    close(f);