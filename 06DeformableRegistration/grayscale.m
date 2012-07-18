function res = grayscale(img)
img = img(:, :, 1);
res = double(img) / double(max(img(:)));
end