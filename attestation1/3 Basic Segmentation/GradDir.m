function dir = GradDir(Image)

%foo

[g_x,g_y] = gradient(Image);
dir = atan(g_y./g_x);