



function [R I0]= Split(Image2,R,t,T,D,create,already,father,son,I0)

%% "Image2" is the image to split
%% "R" regroups the regions
%% "t" is the index of the father
%% "T" is the threshold for the homogeneity measure
%% "D" is the minimum size of a region
%% "already" indicates which region has been created and completely tested (resp. 0 and 1)
%% "create" indicates if the children of the father have already been
%% created 
%% "father" gives for a leaf t which leaf is its father
%% "son" gives for a leaf t which leaves are its children/sons


%% STEP 1:
%% If the region t has not been studied yet,
if create(t)==0
    tn = sum(already~=-1);
    %% subdivide the Region t into 4 regions from tn+1 to tn+4.

    %% 1. SubRegion 1
    son(t,1) = tn+1;
    % a. Set that the father of son(t,1) is t in "father"
    ??
    % b. Define the limits of the region
    ??
    % c. Set that this leaf has been created
    already(son(t,1))=0;
    
    %% SubRegion 2
    ??
    
    %% SubRegion 3
    ??
    
    %% SubRegion 4
    ??
    
    %% Indicate that the children of t have been created
    create(t)=1;
    
    %% Display
    for k = 1:4
        Region = zeros(size(Image2));
        Region(R(son(t,k),1)+1:R(son(t,k),2),R(son(t,k),3)+1:R(son(t,k),4))...
            = 1;
        figure(1); hold on; contour(Region,0.5,'g'); axis image; ...
            colormap gray; axis xy; hold off
        I0(R(son(t,k),1)+1:R(son(t,k),2),R(son(t,k),3))=0;
        I0(R(son(t,k),1)+1:R(son(t,k),2),R(son(t,k),4))=0;
        I0(R(son(t,k),1),R(son(t,k),3)+1:R(son(t,k),4))=0;
        I0(R(son(t,k),2),R(son(t,k),3)+1:R(son(t,k),4))=0;
    end
    axis off
    pause(1/23)
    drawnow
    
    %else
    %% The children were already created
    %% So you do not have nothing to create
end

%% STEP 2:
%% Check if one of the untested children is not homogeneous and that the
%% minimal size has not been reached for the region
Found = 0;      % Indicates if such a child can be found.
limit_size = ?? % = 0 if the size of the children of the region t is smaller than the minimal size
                % = 1 otherwise.
k = 1;          % Just a index to test the 4 children.
if limit_size
    while k<=4 && Found==0 
        %% If the considered child has not been completelty tested,
        if ?? 
            % Check if this child is homogeneous
            % and change the value of Found accordingly.
            ??
        end
        k = k+1; % Test to the next child of t 
    end
end
k = k-1;

%% STEP 3:
%% - Case1: At the end of this loop, no such child has been found and Found==0;
%%      -->We should then find the father of t and try one of its brother
%% - Case2: Or a child has been found and Found =1;
%%      -->We should then splitting again by applying Split to this child

if Found == 1
    %% Split again
    [R I0] = Split(Image2,R,son(t,k),T,D,create,already,father,son,I0);
else
    %% Backtracking
    % Indicate that the father and its children have already been completely tested
    ??
    % Identify the father of t
    index = ??
    if index~=0 %% Check that we have not reached the root
        % Try to split the other children of index, (brothers of t)
        [R I0] = ??
    end
end

end


function H = ComputeHomogen(Image2,R)

I = Image2(R(1)+1:R(2),R(3)+1:R(4));

Choice = 1;

if Choice ==1
    H = max(I(:))-min(I(:));
elseif Choice == 2
    H = sqrt(var(I(:)));
end

end