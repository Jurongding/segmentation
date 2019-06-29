function seg_type_one()
% algorithm for the first type of tumor
warning off;
global Im maxslice str_temp filepath data dataHead t1 slice
global t0 flag1 flag2 rdata topslice terminalslice rstr
flag1=1;flag2=1;
t0 = clock;%Program running starts timing
tell_path;%Determine if the path to the stored result exists
%Set progress bars and properties
h=waitbar(0,'please wait...');
hps=get(h,'Position');
hps=[620 655 hps(3) hps(4)];
set(h,'Position',hps,'visible','on');
if isempty(findall(0,'type','figure','name','SASTT'))
    delete(h);
end
pause(0.1);
calc_time;%Calculate program run time and unit conversion
waitbar(0,h,{'0% completed';['It takes ',num2str(t1),' ',rstr]});
%processing the largest slice of tumor
try
    slice=maxslice;
    I=data(:,:,slice);
    I=(I.*255)./max(max(I));
    I=rot90(I);
    I=round(I);
    Im=I;
    if(size(I,3)==3), I=rgb2gray(I); end
    se2=strel('disk',2);
    %Morphological reconstruction
    I=imreconstruct(imclose(imreconstruct(imopen(I,se2),I),se2),I);
    %Reverse treatment of cerebrospinal fluid
    [m,n]=size(I);
    th=mean2(I);
    I(find(I<=th))=255;
    M=ones(size(I));
    for i1=1:m
        for j1=1:n
            if I(i1,j1)==255
                M(i1,j1)=Im(i1,j1);
            else
                M(i1,j1)=0;
            end
        end
    end
    
    for i2=1:m
        for j2=1:n
            M(i2,j2)=255-M(i2,j2);
        end
    end
    %Contrast Enhancement: Exponential Enhancement
    Gamma=2;
    P=myExpEnhance(M,Gamma);
    se=strel('disk',1);
    P=imclose(P,se);
    Igs=double(P);
    % % Mouse to get the initial outline of the tumor
    check_axes=guidata(findall(0,'type','figure','name','SASTT'));
    h_axes=check_axes.h_axes;
    axes(h_axes);
    imshow(Im,'border','tight','displayrange',[]);hold on
    x=[];y=[];c=1;N=50; %Define the number of points c, the upper limit N
    while c<N
        [xi,yi,button]=ginput(1);
        % Get coordinate vector
        x=[x xi];
        y=[y yi];
        hold on
        plot(xi,yi,'ro');
        % Stop the loop if you right click
        if(button==3), break; end
        c=c+1;
    end
    
    % Copy the first point to the end of the matrix to form a Snake ring
    xy = [x;y];
    c=c+1;
    xy(:,c)=xy(:,1);
    % Spline interpolation
    t=1:c;
    ts = 1:0.05:c;
    xys = spline(t,xy,ts);
    xs = xys(1,:);
    ys = xys(2,:);
    % the effect of Spline interpolation
    hold on
    temp=plot(xs,ys,'b.');
    %%snake algorithm
    [xs,ys]=snake_algorithm(Igs,xs,ys);
    xx=xs;yy=ys;
    %Get the processing results in axes and save
    str=strcat(filepath,'result',str_temp,'\',num2str(slice),'th slice.png');
    pix=getframe(h_axes);
    imwrite(pix.cdata,str);
    sc=roundn(1/(topslice-terminalslice+1),-3);
    calc_time;
    waitbar(sc,h,{[num2str(sc*100),'%',' completed.'];['It takes ',num2str(t1),' ',rstr]});
catch
    he1=msgbox(['The program runs to the', num2str(slice),'th slice of the tumor and an error occurs!']);
    if ishandle(he1)
        pause(0.5);
        delete(he1);
    end
end
% Segmentation from the largest slice to the cranial top
try
    for slice=maxslice+1:1:topslice
        sc=roundn(((slice-maxslice+1)/(topslice-terminalslice+1)),-3);
        I=data(:,:,slice);
        I=(I.*255)./max(max(I));
        I=rot90(I);
        I=round(I);
        Im=I;
        if(size(I,3)==3), I=rgb2gray(I); end
        se2=strel('disk',2);
        I=imreconstruct(imclose(imreconstruct(imopen(I,se2),I),se2),I);
        [m,n]=size(I);
        th=mean2(I);
        I(find(I<=th))=255;
        M=ones(size(I));
        for i1=1:m
            for j1=1:n
                if I(i1,j1)==255
                    M(i1,j1)=Im(i1,j1);
                else
                    M(i1,j1)=0;
                end
            end
        end
        for i2=1:m
            for j2=1:n
                M(i2,j2)=255-M(i2,j2);
            end
        end
        N=myExpEnhance(M,Gamma);
        se=strel('disk',2);
        N=imclose(N,se);
        Igs =double(N);
        check_axes=guidata(findall(0,'type','figure','name','SASTT'));
        h_axes=check_axes.h_axes;
        axes(h_axes);
        imshow(Im,'border','tight','displayrange',[]);
        hold on
        temp=plot(xs,ys,'b.');
        [xs,ys]=snake_algorithm(Igs,xs,ys);
        str=strcat(filepath,'result',str_temp,'\',num2str(slice),'th slice.png');
        pix=getframe(h_axes);
        imwrite(pix.cdata,str);
        calc_time;
        waitbar(sc,h,{[num2str(sc*100),'%',' completed. '];['It takes ',num2str(t1),' ',rstr]});
    end
catch
    he2=msgbox(['The program runs to the', num2str(slice),'th slice of the tumor and an error occurs!']);
end
%Split from the largest slice down
try
    for slice=maxslice-1:-1:terminalslice
        sc=roundn(((topslice-maxslice+1)/(topslice-terminalslice+1)+(maxslice-slice)/(topslice-terminalslice+1)),-3);
        I=data(:,:,slice);
        I=(I.*255)./max(max(I));
        I=round(I);
        I=rot90(I);
        Im=I;
        if(size(I,3)==3), I=rgb2gray(I); end
        se2=strel('disk',2);
        I=imreconstruct(imclose(imreconstruct(imopen(I,se2),I),se2),I);
        [m,n]=size(I);
        th=mean2(I);
        I(find(I<=th))=255;
        M=ones(size(I));
        for i1=1:m
            for j1=1:n
                if I(i1,j1)==255
                    M(i1,j1)=Im(i1,j1);
                else
                    M(i1,j1)=0;
                end
            end
        end
        for i2=1:m
            for j2=1:n
                M(i2,j2)=255-M(i2,j2);
            end
        end
        N=myExpEnhance(M,Gamma);
        se=strel('disk',2);
        N=imclose(N,se);
        Igs=double(N);
        check_axes=guidata(findall(0,'type','figure','name','SASTT'));
        h_axes=check_axes.h_axes;
        axes(h_axes);
        imshow(Im,'border','tight','displayrange',[]);
        % the effect of Spline interpolation
        hold on
        temp=plot(xx,yy,'b.');
        [xx,yy]=snake_algorithm(Igs,xx,yy);
        str=strcat(filepath,'result',str_temp,'\',num2str(slice),'th slice.png');
        pix=getframe(h_axes);
        imwrite(pix.cdata,str);
        calc_time;
        waitbar(sc,h,{[num2str(sc*100),'%',' completed. '];['It takes ',num2str(t1),' ',rstr]});
    end
catch
    he3=msgbox(['The program runs to the', num2str(slice),'th slice of the tumor and an error occurs!']);
end
if ishandle(h)
    pause(1);
    delete(h);
end
%The ROI area after the completion of the furnace is rewritten into volume data.
rest_WriteNiftiImage(rdata,dataHead,[filepath,'result',str_temp,'\','processresults.nii']);
end