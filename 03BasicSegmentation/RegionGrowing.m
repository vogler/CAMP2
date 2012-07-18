function Region = RegionGrowing(I,T)

Visited = zeros(size(I));
Region = zeros(size(I));

% Location of the 8 neighbors
neigb=[-1 0; 1 0; 0 -1;0 1; 1 1; -1 -1; -1 1; 1 -1];
[s1, s2] = size(I);
t = tic;

% Select and add the seed point to the queue of pixels to visit "list"
figure; imagesc(I);axis image; axis xy; title('Select the seed point');...
    colormap gray;axis off
[y x] = ginput(1);
x = round(x); 
y = round(y);

% Grow until no more pixel can be added to the FIFO list
Im = I(x,y); % Inintuialize the mean Intensity inside the region
Is = Im; % Seed point
list = [x, y];
while size(list,1)~=0
    
    % Pick up and remove the first pixel from the list
    p = list(1, :);
    list(1, :) = [];
    Visited(p(1), p(2)) = 1;
    
    % Check if pixel is homogeneous
    % By comparing it to the mean Intensity inside the region
    
    if abs(I(p(1), p(2))-Im)<=T && abs(I(p(1), p(2))-Is)<=T %homogen
        Region(p(1), p(2)) = 1;
        Im = mean(I(Region==1));
        for k = 1:8
            n = neigb(k, :);
            n1 = p(1)+n(1);
            n2 = p(2)+n(2);
            if n1>0 && n2>0 && n1<=s1 && n2<=s2 && Visited(n1, n2)==0
                %list = [list; p+n];
                list(size(list, 1)+1, :) = p+n;
                Visited(n1, n2) = 1;
            end
        end
    else
       
    end
    %Im = mean(mean(I.*(Region==1)));
    
    if toc(t)>1/23
        imagesc(I+Region,[0 1]); axis image; colormap gray; axis off; axis xy;
        drawnow;
        t = tic;
    end
    
end

%% Display
imagesc(I+Region,[0 1]); axis image; colormap gray; axis off; axis xy;
drawnow;

