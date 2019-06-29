function [xs,ys]=snake_algorithm(img,xs,ys)
global km Im slice rdata
%snake algorithm
Igs=img;
NIter =300; % Number of iterations
alpha=0.2;   beta=0.5;gamma = 1; kappa = 0.1;wl = 0; we=0.4; wt=0;
[row, col] = size(Igs);
% image force-line function
Eline = Igs;
% image force-edge function
[gx,gy]=gradient(Igs);
Eedge = -1*sqrt((gx.*gx+gy.*gy));
% image force-end point function
% convolution is to solve partial derivatives, and the partial derivative of discrete points is differential solution
m1 = [-1 1];
m2 = [-1;1];
m3 = [1 -2 1];
m4 = [1;-2;1];
m5 = [1 -1;-1 1];
cx = conv2(Igs,m1,'same');  %Convolution operation, returning the same size matrix as the original matrix
cy = conv2(Igs,m2,'same');
cxx = conv2(Igs,m3,'same');
cyy = conv2(Igs,m4,'same');
cxy = conv2(Igs,m5,'same');
for i = 1:row
    for j= 1:col
        Eterm(i,j) = (cyy(i,j)*cx(i,j)*cx(i,j) -2 *cxy(i,j)*cx(i,j)*cy(i,j) + cxx(i,j)*cy(i,j)*cy(i,j))/((1+cx(i,j)*cx(i,j) + cy(i,j)*cy(i,j))^1.5);
    end
end
%     external force Eext = Eimage + Econ
Eext = wl*Eline + we*Eedge + wt*Eterm;
%     calculate gradient
[fx,fy]=gradient(Eext);
[~, m] = size(xs);
%     Calculate five diagonal matrices
b(1)=beta;
b(2)=-(alpha + 4*beta);
b(3)=(2*alpha + 6 *beta);
b(4)=b(2);
b(5)=b(1);

A=b(1)*circshift(eye(m),2);
A=A+b(2)*circshift(eye(m),1);
A=A+b(3)*circshift(eye(m),0);
A=A+b(4)*circshift(eye(m),-1);
A=A+b(5)*circshift(eye(m),-2);
%     Calculate the inverse of the matrix
[L, U] = lu(A + gamma.* eye(m));
Ainv = inv(U) * inv(L);
%                          paint
for i1=1:NIter
    ssx = gamma*xs - kappa*interp2(fx,xs,ys);
    ssy = gamma*ys - kappa*interp2(fy,xs,ys);
    %         Update the position of the outline
    xs = ssx*Ainv  ;
    ys = ssy*Ainv ;
    % display the position of the outline
    axes1=findall(0,'type','axes','tag','axes1');
    axes(axes1);
    imshow(Im,'border','tight','displayrange',[]);title([num2str(slice),'th slice']);
    hold on;
    plot([xs xs(1)], [ys ys(1)], 'r-','LineWidth',2);
    hold off;
    pause(0.001)
end
km=zeros(size(Im));
for f=1:length(xs)
    km(round(ys(1,f)),round(xs(1,f)))=1;
end
se=strel('disk',2);
km1=imdilate(km,se);
km2=double(~logical(km1));
km=fillcontour(km2);
km=imadd(km,km1);
se1=strel('disk',1);
se3=strel('disk',3);
km=imopen(imerode(km,se1),se3);
km=km.*Im;
rdata(:,:,slice)=rot90(km,3);

