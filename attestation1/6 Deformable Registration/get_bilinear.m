function res = get_bilinear(img, x, y)

intx = floor(x);
inty = floor(y);

dx = x - intx;
dy = y - inty;

if (intx > 0 && intx+1 <= size(img,2) && inty > 0 && inty+1 <= size(img,1))
	res = img(inty,   intx  ) * (1-dx) * (1-dy) ...
        + img(inty+1, intx  ) * (1-dx) *   dy ...
		+ img(inty,   intx+1) *   dx   * (1-dy) ...
		+ img(inty+1, intx+1) *   dx   *   dy  ;
else
    res = 0;
end
