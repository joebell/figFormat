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

aList = {[1 1 1],[2 2 2],[3 3 3]};
bList = {'c','d','e'}
for a = aList
    for b = bList
        a
        b
    end
end



