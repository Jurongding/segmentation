function head_three_dim_reconstruct()
% Volume rendering of processed tumors
% Adds transparency to non-tumor areas
%Add color and lighting to the tumor area
%Set the angle of view of the tumor display
global str_temp filepath dataHead data
repath=[filepath,'result',str_temp,'\','processresults.nii'];
if ~exist(repath,'file')
    [filename,filepath,index] = uigetfile({'*.nii'});
    if index
        repath=[filepath filename];
    end
end
[ndata,dataHead]=rest_ReadNiftiImage(repath);
s1=1;tran_plane=[];
[sagittal,coronal,transverse]=size(ndata);
for tran_slice=1:transverse
    if length(find(ndata(:,:,tran_slice)>0))
        tran_plane(s1,1)=tran_slice;
        s1=s1+1;
    end
end
tran_buttom=min(tran_plane);
tran_top=max(tran_plane);
for i=tran_buttom:tran_top
    ndata(:,:,i)=flipud(ndata(:,:,i));
end
for j=1:transverse
    data(:,:,i)=flipud(data(:,:,i));
end
D=smooth3(data);
E=smooth3(ndata);
% D(:,:,1:60) = [];
% E(:,:,1:60) = [];
p1 = patch(isosurface(D, 5),'Facealpha','0.1',...
    'EdgeColor','none');
 patch(isocaps(D, 5),'FaceColor','none',...
    'EdgeColor','none');
 patch(isosurface(E, 5),'FaceColor',[1 0 0],...
    'EdgeColor','none');
 patch(isocaps(E, 5),'FaceColor','interp',...
    'EdgeColor','none');
view(3)
axis tight
daspect([1,1,1])
colormap(gray(100))
camlight right
camlight
lighting gouraud
isonormals(D,p1)
view(45,30);
rotate3d on
end