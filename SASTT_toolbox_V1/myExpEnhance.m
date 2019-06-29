function dst_img=myExpEnhance(I,Gamma)    
% index contrast enhancement
I = mat2gray(I,[0 255]);    
C = 1;    
g2 = C*(I.^Gamma);   
max=255;  
min=0;  
dst_img=uint8(g2*(max-min)+min); 