function dst_img=myLinearEnhance(src_img,fa,fb,ga,gb)    
% piecewise linear stretching for contrast enhancement
[height,width] = size(src_img);  
dst_img=uint8(zeros(height,width));  
src_img=double(src_img);  
%Three-stage slope 
k1=ga/fa;   
k2=(gb-ga)/(fb- fa);  
k3=(255- gb)/(255- fb);  
for i=1:height  
    for j=1:width  
            if src_img(i,j) <= fa  
                dst_img(i,j)= k1*src_img(i,j);  
            elseif fa < src_img(i,j) && src_img(i,j) <= fb  
                dst_img(i,j)= k2*( src_img(i,j)- fa)+ ga;  
            else  
                dst_img(i,j)= k3*( src_img(i,j)- fb)+ gb;  
            end  
    end  
end  
dst_img=uint8(dst_img);  