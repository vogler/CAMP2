%% Computer Aided Medical Procedures II - Summer 2012
%% Filtering
%% Exercise 2: Basic filtering in the frequency domain

clear all; 

%%-----------------------------------------------------------------------%%
%% A. Create the shape logan phantom 512x512 (function phantom)
%% And add some normal noise
sx = 512; sy = 512; % Size of the image
SL = phantom(sx,sy);
SLn = SL + 0.25 * randn(sx, sy);

%%-----------------------------------------------------------------------%%
%% B. Fill the files imfft and imifft.m

%%-----------------------------------------------------------------------%%
%% C. Ideal Low Pass Filter (ILPF)
%% - Create the transfert function H_ilpf of the ILPF with D0=100
%% - Use imfft and imifft to filter the image in the frequency domain
%% - Repeat with D0 = [25 50 75]

H_ilpf = zeros(size(SLn));
for D0 = [100, 25, 50, 75]
    %% Create the transfert function H_ilpf(D0)
    for i = 1:size(SLn,1)
        for j = 1:size(SLn,2)
            x = i-size(SLn,1)/2;
            y = j-size(SLn,2)/2;
            D = sqrt(x^2 + y^2);
            if(D <= D0)
                H_ilpf(i,j) =  1;
            else
                H_ilpf(i,j) =  0;
            end
        end
    end
    %% Filter SLn using H_ilpf
    SLn_f = imifft(imfft(SLn).*H_ilpf);
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
% small D0 -> only low frequencies -> oscillations (Gibbs
% Phenomenon/Ringing Effect) because of sharp edges in mask
% bigger D0 -> more higher frequencies allowed -> more noise

%%-----------------------------------------------------------------------%%
%% D. Butterworth Low Pass Filter (BLPF)
%% - Create the transfert function H_blpf of the BLPF with D0=50 and n = 2
%% and apply it to the image by using the functions imfft and imifft.
%% - Repeat with D0 = 50 and n = [1 2 5 10 15 20 25]. 
%% - Comment the result.

H_blpf = zeros(size(SLn));
D0 = 50; 

% higher n -> more selective in frequency but also more ringing
for n = [1 2 5 10 15 20 25]
    for i = 1:size(SLn,1)
        for j = 1:size(SLn,2)
            x = i-size(SLn,1)/2;
            y = j-size(SLn,2)/2;
            D = sqrt(x^2 + y^2);
            H_blpf(i,j) = 1/(1+(D/D0)^(2*n));
        end
    end
    %% Filtered SLn using H_blpf
    SLn_f = imifft(imfft(SLn).*H_blpf);
    %% Display the results
    figure(1);
    subplot(2,2,1);imagesc(SLn); axis image; colormap gray; axis off; ...
        title('Original Image')
    subplot(2,2,2);imagesc(H_blpf); axis image; colormap gray; axis off; ...
        title('Transfert function')
    subplot(2,2,3);imagesc(SLn_f); axis image; colormap gray; axis off; ...
        title('Filtered Image')
    subplot(2,2,4);imagesc(SLn_f(1:200,201:400)); axis image; colormap gray;...
        axis off; title('Filtered Image')
    pause(0.5)
end
disp('End Exercise 2')
