function Cluster = ConnectedComponents(Image,Original)

Cluster = zeros(size(Image)); %% Output labelled image
NewLabel=1; %% Current label

%% For every pixel
for i=2:size(Image,1)
    for j=2:size(Image,2)
        
        if (Image(i,j)==1)
            %% Check the neihbourds at the top and at the left
            %% and assign their label to n1 and n2
            n1 = Cluster(i-1,j);
            n2 = Cluster(i,j-1);
            
            %% If one of them already belongs to a component, or if they
            %% belong to the same component, apply the label
            if ((n1>0)&&(n2==0))
                Cluster(i, j) = n1;
            elseif ((n2>0)&&(n1==0))
                Cluster(i, j) = n2;
            elseif (n2==n1)
                Cluster(i, j) = n1;
            end
            
            %% If they are both labelled with different labels,
            %% apply the label min(n1,n2) to the two components
            if (n1~=n2)&&(n1>0)&&(n2>0)
               Cluster(i, j) = min(n1, n2);
            end
            
            %% If they do not belong to any component, assign a new
            %% label to the pixel
            if (n1==0) && (n2==0)
                NewLabel = NewLabel+1;
                Cluster(i, j) = NewLabel;
            end
            
        end
        
    end
end

%% Reassign the cluster
p=1;
for k=1:NewLabel
    if sum(sum(Cluster==k))>0
        Cluster(Cluster==k)=p;
        p=p+1;
    end
end

imagesc(Cluster);axis image; axis xy; title('Select a component');axis off;...
    colormap jet
[x y] = ginput(gcf);
index = Cluster(round(y),round(x));
imagesc(Original);axis image; axis xy; colormap gray;axis off
hold on; contour((Cluster==index),[0.5 0.5],'r'); hold off
title('Segmented Vesicle')
