%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B = image_rotate(A, a, cor)
% input: A   image
%        a   angle (degrees)
%        cor center of rotation 
%            ([ 0 0 ] denotes image center)
%

function A = image_rotate(A,a,cor)

    d1 = size(A,1);
    d2 = size(A,2);
    
    pad1 = round(d1*1.5);
    pad2 = round(d2*1.5);
    
    % pad    
    A = padarray( A, [ pad1 pad2 ], 0 );
    
    % translate, such that cor at middle
    A = image_translate(A, -cor);
    
    % rotate
    A = imrotate( A, a, 'bilinear', 'crop' );

    % translate back
    A = image_translate(A, cor);    
    
    % unpad    
    A = A( pad1+1:pad1+d1, pad2+1:pad2+d2);
