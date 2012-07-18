dirInput = '../Datasets/*.mat';
dirFeatures = '../Features/';
dirGT = '../GT/';
prefixMean = 'Xmean_';
prefixBinary = 'Xbin_';
filter_sizes = [3, 5, 7];

% init
if(isdir(dirFeatures))
    rmdir(dirFeatures, 's');
end
mkdir(dirFeatures);
if(isdir(dirGT))
    rmdir(dirGT, 's');
end
mkdir(dirGT);

% go through all datasets
files = dir(dirInput);
for i=1:length(files)
    file = files(i).name;
    load(file); % yields MR and GT
    
    % images for MR and GT
%     gray = mat2gray(L);
%     X = gray2ind(gray, 256);
%     rgb = ind2rgb(X, hot(256));
% 
%     imwrite(rgb, 'membrane2.jpg')
%     imshow membrane2.jpg
    imwrite(ind2rgb(gray2ind(mat2gray(GT), 256), jet(256)), [dirGT num2str(i) '_GT.jpg'], 'jpg');
    imwrite(ind2rgb(gray2ind(mat2gray(MR), 256), jet(256)), [dirGT num2str(i) '_MR.jpg'], 'jpg');
    
    % Mean and Local Binary Patterns Features
    for fi=1:length(filter_sizes)
        X = featuresMean(MR, filter_sizes(fi));
        save([dirFeatures prefixMean file], 'X');
        X = featuresBinary(MR, filter_sizes(fi));
        save([dirFeatures prefixBinary file], 'X');
    end 
end