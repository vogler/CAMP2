function c = kmeans(I0,m)

%% Step 1. Transform the Image to a vector
[s1 s2] = size(I0);
I = I0(:); % vector containing imagepixels

%% Step 2. Kmeans algorithm
% Number of classes
K = length(m);

%% Initialization
m0 = ones(1,length(m));
iter = 1;
c=zeros(size(I0));

%% Iteration
while any(m-m0)
    
    m0 = m;
    %% STEP 1: Assignment step: 
    %% Assign each pixel to the cluster whose mean is the nearest to its intensity
    for i = 1:length(I) % For every pixel in the image
        [~,c(i)] = min(abs(I(i)-m));        % Assign the label c(i)
    end
    
    if iter ==1 %% %% Display initialization
        
        subplot(2,1,2); imagesc(reshape(c,s1,s2)); axis image;  ...
            axis xy; title('Segmented Image - - Initialization');axis off
        subplot(2,1,1); hist(I,100);title('KMEAN - Histogram - Initialization')
        axis([0 1 0 2000])
        for k = 1:K
            hold on; plot(m(k)*ones(1,1500),1:1500,'g','Linewidth',2);
        end
        for k = 1:K-1
            hold on; plot((m(k)+m(k+1))/2*ones(1,1500),1:1500,'r','Linewidth',1);
        end
        hold off
        pause(0.1)
    end
    
    %% STEP 2: Update step
    for k = 1:K     % For every class,
        m(k)= mean(I(c==k));    % compute the mean intensity in this class
    end
    
    %% Display the result
    subplot(2,1,2); imagesc(reshape(c,s1,s2)); axis image;  ...
        axis xy; title(['Segmented Image - Iter ' num2str(iter)]);axis off
    subplot(2,1,1); hist(I,100);title(['KMEAN - Histogram - Iter ' num2str(iter)])
    axis([0 1 0 2000])
    for k = 1:K
        hold on; plot(m(k)*ones(1,1500),1:1500,'g','Linewidth',2);
    end
    for k = 1:K-1
        hold on; plot((m(k)+m(k+1))/2*ones(1,1500),1:1500,'r','Linewidth',1);
    end
    hold off;
    drawnow
    %pause(0.2)
    
    iter = iter+1;
end

%% Reshape the output image
%c = reshape(c,s1,s2);


