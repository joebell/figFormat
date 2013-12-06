%

close all; clear all;

myMaster = laserMaster1Form();

f1 = figure('visible','off');
a1 = axes();
plot(1:10);

f2 = figure('visible','off');
a2 = axes();
image(magic(9),'CDataMapping','scaled');

myMaster.cloneAxesIn([a1,a2],[10 12]);





