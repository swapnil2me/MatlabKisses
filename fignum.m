function fnum = fignum()

h = findobj('Type', 'figure');
lf = length(h);

cout=2;
if lf == 0
    fnum = 1;
else
    num=[h.Number];
    while find(num == cout,1)
        cout = cout+1;
    end
    fnum = cout;
end
end