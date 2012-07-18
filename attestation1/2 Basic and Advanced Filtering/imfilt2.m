function B = imfilt2(A, N)

    B = zeros(size(A));
    ax = size(A,1);
    ay = size(A,2);
    C = createBorderCond(A, N, 'mirror');		% select border condition 'mirror'
    
	% Select median from neighbours
    for x = 1:ax 
        for y = 1:ay
           med = C(x:x+2*N, y:y+2*N);
           B(x,y) = median(med(:));
        end  
    end
    
end