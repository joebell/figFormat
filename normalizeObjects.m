function normalizeObjects(objList)

objChild = findall(objList);

for n=1:length(objChild)
    
    if isprop(objChild(n),'Units');
        set(objChild(n),'Units','normalized');
    end
    if isprop(objChild(n),'FontUnits');
        set(objChild(n),'FontUnits','normalized');
    end
    if isa(objChild(n),'axes');
        set(objChild(n),'OuterPosition',[0 0 1 1]);
    end
end
    