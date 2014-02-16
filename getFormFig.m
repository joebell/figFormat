function FF = getFormFig()

    keyArgs = get(gcf,'KeyPressFcn');
    FF = keyArgs{2};