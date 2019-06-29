function max_slice_evaluation()
% Estimate the largest slice of the tumor based on the extent of the tumor
%The principle adopted by judge the number of slices as parity, and take the median according to the parity
% If the tumor is not severely stressed, the shape is still somewhat symmetrical.
global maxslice topslice terminalslice data
mk=[];ik=0;
for ms=topslice:terminalslice
    ik=ik+1;
    mk(1,ik)=ms;
end
ml=terminalslice-topslice+1;
if rem(ml,2)==1
    maxslice=mk((ml+1)/2);
else
    maxslice=mk(ml/2);
end
set(handles.edit2,'string',num2str(maxslice));
I=data(:,:,maxslice);
maxgray=max(max(I));
I=(I.*255)./maxgray;
I=rot90(I);
I=round(I);
axes=findall(0,'type','axes','tag','axes1');
axes(axes1);
imshow(I,'border','tight','displayrange',[]);
end