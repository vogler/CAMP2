%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B = image_translate(A, t)
%   A image, t translation vector
%   uses best-neighbor

function B = image_translate(A,t)

    B = A*0;
    
    d1 = size(B,1);
    d2 = size(B,2);
    % backward warping
    for xb=1:d1
        for yb=1:d2

			%%% TODO
			% calculate the correct indices for accessing matrix A
            tx = t(1);
            ty = t(2);
            xa = xb-tx;
            ya = yb-ty;
            if ( xa>0 && ya>0 && xa<=d1 && ya<=d2 ) % inside image?
                % alt 1: round
                %B(xb,yb) = A( round(xa) , round(ya) );
                % alt 2: bilinear interpolation
                x = xb; y = yb; u = round(xa); v = round(ya);
                if (u > 0 && v > 0 && u+1 <= d1 && v+1 <= d2) % inside image?
                    i = A(u,v)*(u+1-x)*(v+1-y) + A(u+1,v)*(x-u)*(v+1-y) + A(u,v+1)*(u+1-x)*(y-v) + A(u+1,v+1)*(x-u)*(y-v);
                    B(xb,yb) = i;
                end
            end
            
        end
    end
end