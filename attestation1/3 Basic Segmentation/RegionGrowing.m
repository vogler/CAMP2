function Region = RegionGrowing(I,T)

Visited = zeros(size(I));
Region = zeros(size(I));

% Location of the 8 neighbors
neigb=[-1 0; 1 0; 0 -1;0 1; 1 1; -1 -1; -1 1; 1 -1];
[s1, s2] = size(I);
t = tic;

% select and add the seed point to the queue
figure; imagesc(I);axis image; axis xy; title('Select the seed point');...
    colormap gray;axis off
[y x] = ginput(1);
x = round(x);
y = round(y);
%Im = I(x,y);
%list = [x, y];

% grow until no more pixel can be added to the queue
Im = I(x,y); % init the mean intensity inside the region
list = [x, y];
Visited(x,y)=1;
while(size(list,1)~=0)
    
    % pop the first pixel from the list
    p = list(1,:);
    list = list(2:end,:);
    
    % check if pixel is homogeneous
    % by comparing it to the mean intensity inside the region and the seed
    % point
    
    if abs(I(p(1),p(2))-Im)<=T && abs(I(p(1),p(2))-I(x,y))<=T%compare I(p) to Im (or mean(Region==1)?) and seed point (x,y). true if diff below T
        Region(p(1),p(2))=1;
        Im = mean(I(Region==1));
        for k = 1:8 % check all neighbors
            p_a = p+neigb(k,:);
            if p_a(1)>0 && p_a(2)>0 && p_a(1)<=s1 && p_a(2)<=s2 && Visited(p_a(1),p_a(2))~=1 % pixel inside image and not visited
                list = [list; p_a];
                Visited(p_a(1),p_a(2))=1; % mark every match as visited
            end
        end
    end
    
    if toc(t)>1/23
        imagesc(I+Region,[0 1]); axis image; colormap gray; axis off; axis xy;
        drawnow;
        t = tic;
    end
    
end

%% Display
imagesc(I+Region,[0 1]); axis image; colormap gray; axis off; axis xy;
drawnow;

