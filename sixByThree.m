function FG = sixByThree()

    FG = formFig([7,4]);
    for y = 1:3
        for x = 1:6
            FG.addPanel([x y x+1 y+1]);
        end
    end