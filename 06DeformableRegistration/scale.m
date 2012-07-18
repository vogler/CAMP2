function res = scale(img)

minimum = min(img(:));
maximum = max(img(:));

img = img - minimum;
res = img / (maximum-minimum);

end