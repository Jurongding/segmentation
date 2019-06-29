function seg_type_three()
% algorithm for the third type of tumor
warning off;
global md md1 th str_temp filepath maxslice topslice slice rdata
global data dataHead t0 flag1 flag2 t1 rstr terminalslice Im
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
pause(1);
calc_time;%Calculate program run time and unit conversion
waitbar(0,h,{'0% completed';['It takes ',num2str(t1),' ',rstr]});
%processing the largest slice of tumor
try
    ok=true;
    slice=maxslice;
    I=data(:,:,slice);
    I=(I.*255)./max(max(I));
    I=rot90(I);
    I=round(I);
    Im=I;
    if(size(I,3)==3), I=rgb2gray(I); end
    th=mean2(I)+2;
    I(find(I<=th))=255;
    se2=strel('disk',2);
    %Morphological reconstruction
    I=imreconstruct(imclose(imreconstruct(imopen(I,se2),I),se2),I);
    se=strel('disk',1);
    I=imopen(I,se);
    %%Contrast Enhancement: Piecewise linear stretching Enhancement
    fa =md1;
    fb=md;
    ga=50;
    gb=250;
    J=myLinearEnhance(I,fa,fb,ga,gb);
    se=strel('disk',2);
    J=imclose(J,se);
    Igs=double(J);
    check_axes=guidata(findall(0,'type','figure','name','SASTT'));
    h_axes=check_axes.h_axes;
    axes(h_axes);
    imshow(Im,'border','tight','displayrange',[]);
    while ok
        x=[];y=[];c=1;N=100; %Define the number of points c, the upper limit N
            % % Mouse to get the initial outline of the tumor
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
        ok=false;
    end
        % the effect of Spline interpolation
    hold on
    temp=plot(xs,ys,'b.');
    %                     Snakes algorithm
%     NIter =300; % Number of iterations
%     alpha=0.2;    beta=0.8;gamma = 1; kappa = 0.1; wl = 0; we=0.4; wt=0;
    [xs,ys]=snake_algorithm(Igs,xs,ys);
    xx=xs;yy=ys;
    str=strcat(filepath,'result',str_temp,'\',num2str(slice),'th slice.png');
    pix=getframe(h_axes);
    imwrite(pix.cdata,str);
    sc=roundn(1/(topslice-terminalslice+1),-3);
    calc_time;
    waitbar(sc,h,{[num2str(sc*100),'%',' completed.'];['It takes ',num2str(t1),' ',rstr]});
catch
    he1=msgbox(['The program runs to the', num2str(slice),'th slice of the tumor and an error occurs!']);
end
% Segmentation from the largest slice to the cranial top
try
    for slice=maxslice+1:topslice
        sc=roundn(((slice-maxslice+1)/(topslice-terminalslice+1)),-3);
        I=data(:,:,slice);
        I=(I.*255)./max(max(I));
        I=rot90(I);
        I=round(I);
        Im=I;
        if(size(I,3)==3), I=rgb2gray(I); end
        th=mean2(I)+1;
        I(find(I<=th))=255;
        se2=strel('disk',2);
        I=imreconstruct(imclose(imreconstruct(imopen(I,se2),I),se2),I);
        se=strel('disk',2);
        I=imopen(I,se);
        J=myLinearEnhance(I,fa,fb,ga,gb);
        se=strel('disk',2);
        J=imclose(J,se);
        Igs=double(J);
        check_axes=guidata(findall(0,'type','figure','name','SASTT'));
        h_axes=check_axes.h_axes;
        axes(h_axes);
        imshow(Im,'border','tight','displayrange',[]);
        % the effect of Spline interpolation
        hold on
        temp=plot(xs,ys,'b.');
        %                     Snakes algorithm
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
        I=rot90(I);
        I=round(I);
        Im=I;
        if(size(I,3)==3), I=rgb2gray(I); end
        th=mean2(I)+1;
        I(find(I<=th))=255;
        se2=strel('disk',2);
        I=imreconstruct(imclose(imreconstruct(imopen(I,se2),I),se2),I);
        se=strel('disk',1);
        I=imopen(I,se);
        J=myLinearEnhance(I,fa,fb,ga,gb);
        se=strel('disk',2);
        J=imclose(J,se);
        Igs=double(J);
        check_axes=guidata(findall(0,'type','figure','name','SASTT'));
        h_axes=check_axes.h_axes;
        axes(h_axes);
        imshow(Im,'border','tight','displayrange',[]);
        % the effect of Spline interpolation
        hold on
        temp=plot(xx,yy,'b.');
        %                     Snakes algorithm
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