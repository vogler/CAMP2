% filtered backprojection
function recon = fbp(sinogram, projections, filter)

tic;


if strcmp(filter, 'Ram-Lak') % implement Ram-Lak filter on our own
    
    % apply Ram-Lak filter to sinogram (for each projection=column)
    fftSino = fftshift(fft(sinogram));
    f = -1:2/(size(sinogram,1)-1):1; % #rows of sinogram
    %f = linspace(-1, 1, length(sinogram));
    ramlak = abs(f');
    ramlak = repmat(ramlak, [1 size(sinogram, 2)]);
    size(fftSino)
    size(ramlak)
    filteredSino = real(ifft(ifftshift(fftSino.*ramlak)));
    
    % apply backprojection via iradon (filtering disabled)
    recon = iradon(filteredSino, projections, 'linear', 'none');
    
else % cheap way out - use filter provided by iradon
    
    recon = iradon(sinogram, projections, 'linear', filter);
    
end;

elapsed = toc;
disp(['FBP done in ' num2str(elapsed) ' seconds.']);
