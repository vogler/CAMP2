% points of the "nikolaus haus"
p1 = [0,0]';
p2 = [1,0]';
p3 = [0,1]';
p4 = [1,1]';
p5 = [0.5,1.5]';
p6 = [0,-1]';
p7 = [1,-1]';

%sequencial arrangement of the points to plot them
p=[p1,p2,p3,p4,p5,p6,p7];

%define the axes in x and y direction
paxes=[p1,p2,p1,p3];

%define the right order to plot the correct house
pnikolaus = [p1,p2,p4,p5,p3,p1,p4,p3,p2];

% extend the points to homogeneous coordinates
pnikolaus(3,:) = 1;

figure(1);
axis equal;
hold on;

% plot simple house
plot(p(1,:),p(2,:),'bx');
plot(pnikolaus(1,:),pnikolaus(2,:),'r-');
plot(paxes(1,:),paxes(2,:),'b-');

% -----
% plot translated house by the vector (2,3)'
figure(2);
axis equal;
hold on;

% TODO: define 3x3 transformation matrix A1 that translates the point set
% pnikolaus by (2,3)'
A1 = [1 0 2;
      0 1 3;
      0 0 1];

% TODO: transform the pnikolaus point set with the translation matrix A1
nik1 = A1 * pnikolaus; %%

% plot the original and the translated house in the same figure
plot(p(1,:),p(2,:),'bx')
plot(pnikolaus(1,:),pnikolaus(2,:),'r.-')
plot(paxes(1,:),paxes(2,:),'b-')
plot(nik1(1,:),nik1(2,:),'g-')

%-----
% plot rotated house by 45degree CCW (pi/4)  
figure(3);
axis equal;
hold on;

% TODO: define the 3x3 transformation matrix that rotates counter clockwise
% with 45 degrees (pi/4)
r = pi/4;
A2 = [cos(r) -sin(r) 0;
      sin(r)  cos(r) 0;
       0       0     1];

% TODO: transform the pnikolaus point set with the rotation matrix
nik2 = A2 * pnikolaus; %%

% plot the original and the rotated house in the same figure
plot(p(1,:),p(2,:),'bx')
plot(pnikolaus(1,:),pnikolaus(2,:),'r.-')
plot(paxes(1,:),paxes(2,:),'b-')
plot(nik2(1,:),nik2(2,:),'g-')

% -----
% Concardinate the transformations in different orders
% 1) first translation than rotation in world coordinates
figure(4);
axis equal;
hold on;

% TODO: transform the pnikolaus point set where first the rotation A2 and
% afterwards the translation A1 is performed in world coordinates
nik3 = A2 * A1 * pnikolaus; %%
% nik3 = A2 * (A1 * pnikolaus); %%

plot(p(1,:),p(2,:),'bx')
plot(pnikolaus(1,:),pnikolaus(2,:),'r.-')
plot(paxes(1,:),paxes(2,:),'b-')
plot(nik3(1,:),nik3(2,:),'g-')

% 2) first rotation than translation in world coordinates
figure(5);
axis equal;
hold on;

% TODO: transform the pnikolaus point set where first the translation A1 and
% afterwards the rotation A2 is performed in world coordinates
nik4 = A1 * A2 * pnikolaus; %%
% nik4 = A1 * (A2 * pnikolaus); %%

plot(p(1,:),p(2,:),'bx')
plot(pnikolaus(1,:),pnikolaus(2,:),'r.-')
plot(paxes(1,:),paxes(2,:),'b-')
plot(nik4(1,:),nik4(2,:),'g-')

% 3) combine both transformations in one single matrix
figure(6);
axis equal;
hold on;

% TODO: create one single matrix A3 that containts the above specified
% rotation in the upper left 2x2 matrix and the translation specified above
% in the first two rows of the last column
A3 = [cos(r) -sin(r) 2;
      sin(r)  cos(r) 3;
       0       0     1];
% -> equal to the one before: rotation, then translation

% TODO: transform the pnikolaus point set with the A3 matrix
nik5 = A3 * pnikolaus; %%

plot(p(1,:),p(2,:),'bx')
plot(pnikolaus(1,:),pnikolaus(2,:),'r.-')
plot(paxes(1,:),paxes(2,:),'b-')
plot(nik5(1,:),nik5(2,:),'g-')

% ------
% affine transformation
figure(7);
axis equal;
hold on;

% affine transformation matrix A4
A4 = [1.6 0.1 1.5; ...
      0.3 1.5 0.5; ...
      0 0 1];

% TODO: transform the pnikolaus point set with the affine A4 matrix  
nik6 = A4 * pnikolaus; %%

plot(p(1,:),p(2,:),'bx')
plot(pnikolaus(1,:),pnikolaus(2,:),'r.-')
plot(paxes(1,:),paxes(2,:),'b-')
plot(nik6(1,:),nik6(2,:),'g-')


% -----  
% projective transformation
figure(8);
axis equal;
hold on;

% projective transformation matrix A5
A5 = [1.6 0.1 1.5; ...
      0.3 1.5 0.5; ...
      0.2 0.3 1];

%TODO: transform the points pnikolaus by the projective transformation A5
nik7 = A5 * pnikolaus; %%

for i=1:size(nik7,2)
% TODO: normalize the points after the projective transformation. Each point
% has to be devided by the entry in its third row. (to validate the result
% see if the last row is throughout all points 1)
    nik7(:,i) = nik7(:,i)/nik7(3,i);
end


plot(p(1,:),p(2,:),'bx')
plot(pnikolaus(1,:),pnikolaus(2,:),'r.-')
plot(paxes(1,:),paxes(2,:),'b-')
plot(nik7(1,:),nik7(2,:),'g-')

