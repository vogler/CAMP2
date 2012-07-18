% The Iterative Closest Point Algorithm
% author: Martin Groher, TUM, 2006
% For the cource 
% COMPUTER AIDED MEDICAL PROCEDURES (CAMP) II
%
% INPUT: SOURCEPTS, the template points to be transformed (3xN) inhomogeneous
%        TARGETPTS, the reference points (target, 3xN) inhomogeneous
%        maxIters, the maximum number of iterations before algorithm stops
% OUTPUT: R computed rotation
%         t computed translation
%         iters the number of iterations needed for convergence

function [R,t,iters] = IterativeClosestPoint(srcPts, tgtPts, maxIters)
transPts=srcPts;
n = size(tgtPts,2);
m = size(srcPts,2);

%Initialize D and Dmax
D=0;
for i=1:n-1
    D = D + sqrt((tgtPts(:,i)-tgtPts(:,i+1))'*(tgtPts(:,i)-tgtPts(:,i+1)));
end
D = D/(n-1);
dMax = 200*D;

%local helper variables
R=zeros(3,3);
t = zeros(3,1);
axis=[0 0 0]';
tChange=1e16;
rChange=1e16;
delta=0.0001;
iters=0;

%loop until convergence of motion
while ((tChange > delta || rChange > delta) && (iters <= maxIters))
    iters=iters+1;
    out = sprintf('Iter %d: ', iters);
    CP=[];
    srcPtsSS=[];
    transPtsSS=[];
    dist=[];

    %(i) find closest points
    subsetIndex=1;
    found=0;
    for i=1:m
        % (1) implement function at line 144:
        % TODO
        tmpCP = getClosestPoints(tgtPts,transPts(:,i),dMax);
        % only attach those that have not been found yet:
        j=1;
        while (j < size(tmpCP,2))
            found=0;
            for k=1:size(CP,2)
                if (tmpCP(1,j)==CP(1,k)&&tmpCP(2,j)==CP(2,k)&&tmpCP(3,j)==CP(3,k))
                    found=1;
                    break;
                end
            end
            if (found==0)
                % a closest point candidate has been found that is not
                % included already in the list of closest points
                break;
            end           
            j=j+1;
        end
        if (found==0 && size(tmpCP,2) ~= 0)
            transPtsSS(:,subsetIndex) = transPts(:,i);
            srcPtsSS(:,subsetIndex) = srcPts(:,i);
            CP(:,subsetIndex) = tmpCP(:,j);
            subsetIndex = subsetIndex+1;
        end
    end
    
    %(ii) update matching (statistical analysis)
    dMean=0;
    dDev=0;
    nSS=size(srcPtsSS,2);
    for i=1:nSS
        dist(i) = sqrt((transPtsSS(:,i)-CP(:,i))'*(transPtsSS(:,i)-CP(:,i)));
        dMean=dMean+dist(i);
    end
    dMean = dMean / nSS;
    for i=1:nSS
        dDev = dDev+(dist(i)-dMean)^2;
    end
    dDev = sqrt(dDev / (nSS-1));
    % (2) update the matching. Reset dMax according to 
    % mean (dMean) and standard deviation (dDev) of all
    % distances
    if (dMean < D)              % reg is quite good
        disp('The registration is quite good');
        % TODO
        dMax = dMean * 3*dDev;
    elseif (dMean < 3*D)        % reg is still good
        disp('The registration is still good');
        % TODO
        dMax = dMean * 2*dDev;
    elseif (dMean < 6*D)        % reg is not too bad
        disp('The registration is not too bad');
        % TODO
        dMax = dMean * dDev;
    else                        % reg is really bad
        disp('The registration is really bad');
        % TODO
        dMax = median(dist); % dMean
    end      
    % now, delete all points from the list which are not within the
    % specified distance dMax
    tmpsrcPtsSS=[];
    tmpCP=[];
    j=1;
    for i=1:nSS
        if (dist(i) <= dMax)
            tmpsrcPtsSS(:,j) = srcPtsSS(:,i);
            tmpCP(:,j) = CP(:,i);
            j=j+1;
        end
    end
    inlier = size(tmpsrcPtsSS,2);
    outlier = size(srcPts,2)-size(tmpsrcPtsSS,2);
    srcPtsSS = tmpsrcPtsSS;
    CP = tmpCP;
    nSS = size(srcPtsSS,2);
    tmp = sprintf('dMax = %.3f, #inliers = %d, #outliers = %d, meanDist = %.3f, meanDev = %.3f', dMax, inlier, outlier, dMean, dDev);
    out = strcat(out,tmp);
    % abort if we have less than 3 points for computing the motion
    if (nSS<3)
        error('ICP: Not enough points for computing the motion. Abort');
    end;
        
    %(iii) compute motion
    oldAxis = axis;
    oldt=t;
    % (3) compute the motion of the subset of the source points
    % (srcPtsSS) and the set of closest points (CP). Save the
    % transformation in T
    % TODO
    T = pointBasedRegistration(srcPtsSS, CP);
    R = T(1:3,1:3);
    q = DCM2Quat(R);
    qAngle = 2 * acos(q(4));
    axis = (qAngle / sin(qAngle * 0.5) .* q(1:3));
    t = T(1:3,4);
    tChange = sqrt((oldt - t)'*(oldt-t));
    rChange = sqrt((oldAxis-axis)'*(oldAxis-axis));
    tmp = sprintf(', tChange = %.3f, rChange = %.3f\n', tChange, rChange);
    out = strcat(out,tmp);
    disp(out);       
    
    %(iv) (4) apply motion to all points in template (src)
    % save the transformed Pts in transPts
    % TODO
    srcPts(4,:) = 1;
    transPts = T * srcPts; %+t?
    transPts = transPts(1:3,:);
    srcPts = srcPts(1:3,:);
  end %while
end

function cp = getClosestPoints(pts, pt, d)
% (1) search for all points in point-list
% pts (3xN) which has a distance less or equal
% to distance d from point pt. Save result
% in cptmp!
% TODO
cptmp = [];
for i=1:size(pts, 2)
    p = pts(:,i);
    dist = sqrt(sum((p-pt).^2));
%     dist = sqrt((p(1)-pt(1))^2+(p(2)-pt(2))^2+(p(3)-pt(3))^2);
    if(dist<=d)
        cptmp(:, end+1) = p;
    end
end
%sort in ascending order:
cp=qs(cptmp, pt);
end

% Vector-Distance-Quicksort in MatLAB. works for vector lists v and a
% vector p.
% the sorting is according to ||v-p||,
% i.e. the vector list is sorted according to its Eucldiean distances to p
function vec = qs(v,p)
if (size(v,2)<=1)
    vec=v;
    return;
end
pivot=v(:,round(size(v,2)/2));
less=[];
greater=[];
for i=2:size(v,2)
   if ( (v(:,i)-p)'*(v(:,i)-p) < (pivot -p)'*(pivot-p) )
       less= [less,v(:,i)];
   end
   if ( (v(:,i)-p)'*(v(:,i)-p) >= (pivot -p)'*(pivot-p) )
       greater=[greater,v(:,i)];
   end
end
vec = [qs(less,p), pivot, qs(greater,p)];
end
