%% Computer Aided Medical Procedures II - Summer 2012
%% Filtering
%% Exercise 2: Basic filtering in the frequency domain
clear all; 

%%-----------------------------------------------------------------------%%
%% A. Create the shape logan phantom 512x512 (function phantom)
%% And add some normal noise
sx = 512; sy = 512; % Size of the image
SL = phantom(sx,sy);
SLn = SL + (0.25.*randn(sx, sy));

%%-----------------------------------------------------------------------%%
%% B. Fill the files imfft and imifft.m
% done

%%-----------------------------------------------------------------------%%
%% C. Ideal Low Pass Filter (ILPF)
%% - Create the transfert function H_ilpf of the ILPF with D0=100
%% - Use imfft and imifft to filter the image in the frequency domain
%% - Repeat with D0 = [25 50 75]

H_ilpf = zeros(size(SLn));
for D0 = [100, 25, 50, 75]
    %% Create the transfert function H_ilpf(D0)
    % The problem with this function is that it represents an ideal low pass
    % filter, that cuts all frequencies above a certain threshold. When
    % transfering the filtered image back into the spatial domain artefacts as
    % Ringing Effects/Oscillations occour (Gibbs phenomenon).
    for i = 1:size(SLn,1)
        for j = 1:size(SLn,2)
            D = sqrt((i-sx/2)^2 + (j-sy/2)^2);
            if D <= D0
                H_ilpf(i,j) = 1;
            else
                H_ilpf(i,j) = 0;
            end
        end
    end
    %% Filter SLn using H_ilpf
    % 1. Transfer image into the frequency domain (imfft).
    % 2. Apply ILPF filter.
    % 3. Re-Transfer the filtered image back into the spatial domain.
    SLn_f = imifft((imfft(SLn) .* H_ilpf));
    %% Display the results
    figure(1);
    subplot(2,2,1);imagesc(SLn); axis image; colormap gray; axis off; ...
        title('Original Image')
    subplot(2,2,2);imagesc(H_ilpf); axis image; colormap gray; axis off; ...
        title('Transfert function')
    subplot(2,2,3);imagesc(SLn_f); axis image; colormap gray; axis off; ...
        title('Filtered Image')
    subplot(2,2,4);imagesc(SLn_f(1:200,201:400)); axis image; colormap gray;...
        axis off; title('Filtered Image')
    pause(0.5)
end
input('Continue?')

%% 2. Repeat C.1. with D0 = 25,50,75. Comment the result
% When we use D0 = 100 we can see no ring artefacts.
% On the other hand when we choose a narrow low pass with D0 = 25, we get
% ring effects (Gibbs phenomenon). The higher we chosse D0 the fewer ring
% effects occour, because we suppress less frequencies by the higher
% threshold value. The drawback of a higher threshold is that we have
% noise in the image (compared to lower D0), what we initially wanted to reduce.
%%-----------------------------------------------------------------------%%

%% D. Butterworth Low Pass Filter (BLPF)
%% - Create the transfert function H_blpf of the BLPF with D0=50 and n = 2
%% and apply it to the image by using the functions imfft and imifft.
%% - Repeat with D0 = 50 and n = [1 2 5 10 15 20 25]. 
%% - Comment the result.
% We see that the result is better than the results obtained from the
% previous filter (ideal low pass filter). Nonetheless, the higher the
% order of the Butterworth filter becomes, the sharper is the transfer
% function which results in ring effects at higher n. At an n of 10 we
% notice the beginning of a ring effect. At higher n (>15) there is no
% significant difference between the results, because the transer function
% is already very sharp.

H_blpf = zeros(size(SLn));
D0 =25; 

for n = [1 2 5 10 15 20 25]
    % The higher the order of the filter the sharper is the transfer
    % function. (the higher the order the smaller is the transition
    % section)
    for i = 1:size(SLn,1)
        for j = 1:size(SLn,2)
            D = sqrt((i-sx/2)^2 + (j-sy/2)^2);      % Compute the vector length at the point (i,j) originating from the center
                                                    % The image is parsed from the one edge to the other, therefore we have to
                                                    % transpose the values that the center is the origin.
            % Computation of D seperated in steps to accentuate them:
            %x = i-size(SLn,1)/2;
            %y = j-size(SLn,2)/2;
            %D = sqrt(x^2 + y^2);
            H_blpf(i,j) = 1/(1+(D/D0)^(2*n));       % Butterworth formula
        end
    end
    %% Filtered SLn using H_blpf
    % 1. Transfer image into the frequency domain (imfft).
    % 2. Apply butterworth filter.
    % 3. Re-Transfer the filtered image back into the spatial domain.
    SLn_f = imifft((imfft(SLn) .* H_blpf));
    %% Display the results
    figure(1);
    subplot(2,2,1);imagesc(SLn); axis image; colormap gray; axis off; ...
        title('Original Image')
    subplot(2,2,2);imagesc(H_blpf); axis image; colormap gray; axis off; ...
        title('Transfert function')
    subplot(2,2,3);imagesc(SLn_f); axis image; colormap gray; axis off; ...
        title(['Filtered Image' '[' int2str(n) ']'])
    subplot(2,2,4);imagesc(SLn_f(1:200,201:400)); axis image; colormap gray;...
        axis off; title(['Filtered Image' '[' int2str(n) ']'])
    pause(0.5)
end
disp('End Exercise 2')
