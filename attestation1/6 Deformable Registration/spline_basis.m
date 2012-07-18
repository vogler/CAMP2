function res = spline_basis(index, u)

switch index
    case 0
        res = (-1*(u*u*u) + 3*u*u - 3*u + 1) / 6;
    case 1
        res = (3*u*u*u - 6*u*u + 4) / 6;
    case 2
        res = (-3*u*u*u + 3*u*u + 3*u + 1) / 6;
    case 3
        res = u*u*u / 6;
    case 4
        res = 0;
    otherwise
        res = 0;
end;