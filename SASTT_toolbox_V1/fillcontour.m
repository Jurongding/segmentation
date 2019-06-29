function  fc=fillcontour(img)
% fills the outline
% is filled from four directions
img1=img;img2=img;
[m,n]=size(img);
fc=zeros(size(img));
for i1=1:m
    for j1=1:n
        if img1(i1,j1)==1
            img1(i1,j1)=0;
        elseif img1(i1,j1)==0
            break;
        end
    end
end
for i2=m:-1:1
    for j2=n:-1:1
        if img1(i2,j2)==1
            img1(i2,j2)=0;
        elseif img1(i2,j2)==0
            break;
        end
    end
end
for i3=1:n
    for j3=1:m
        if img2(j3,i3)==1
            img2(j3,i3)=0;
        elseif img2(j3,i3)==0
            break;
        end
    end
end
for i4=n:-1:1
    for j4=m:-1:1
        if img2(j4,i4)==1
            img2(j4,i4)=0;
        elseif img2(j4,i4)==0
            break;
        end
    end
end
fc(intersect(find(img1),find(img2)))=1;
end