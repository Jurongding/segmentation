function Linear_stretching()
global vs  data  md1  md
I=data(:,:,vs);
maxgray=max(max(I));
I=(I.*255)./maxgray;
I=rot90(I);
I=round(I);
set(gcf,'visible','off');
Contrastenhancement;
check_axes=guidata(findall(0,'type','figure','name','Contrastenhancement'));
h_axes=check_axes.axes1;
axes(h_axes);
imshow(I,[],'border','tight','displayrange',[]);
pause(1);
ps1=[]; x=[];y=[];c=0;N=10; %定义取点个数c,上限N
while c<N
    [xi,yi,button]=ginput(1);
    % 获取坐标向量
    x=[x xi];
    y=[y yi];
    hold on
    plot(xi,yi,'r*');
    % 若为右击，则停止循环
    if(button==3)&&c>4
        break;
    elseif (button==3)&&c<4
        cp=msgbox('请选择3个点以上');
        if ishandle(cp)
            pause(1);
            delete(cp);
        end
        
    end
    c=c+1;
end
ps1(2,:)=x;ps1(1,:)=y;
ps1=round(ps1);
pg=[];
for ki=1:c
    pg(1,ki)=I(ps1(1,ki),ps1(2,ki));
end
md=max(pg(1,2:c));md1=min(pg(1,2:c));
md2=pg(1,1);
if md2>md
    md=md2+10;
elseif md2<md && md2>md1
    md=md+10;
elseif md2<md1
    md=md+10; md1=md2;
end
pause(1);
close(gcf);
set(gcf,'visible','on');
end