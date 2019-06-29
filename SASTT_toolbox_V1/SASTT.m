function varargout = SASTT(varargin)
% SASTT MATLAB code for SASTT.fig
%      SASTT, by itself, creates a new SASTT or raises the existing
%      singleton*.
%
%      H = SASTT returns the handle to a new SASTT or the handle to
%      the existing singleton*.
%
%      SASTT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SASTT.M with the given input arguments.
%
%      SASTT('Property','Value',...) creates a new SASTT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SASTT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SASTT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SASTT

% Last Modified by GUIDE v2.5 23-May-2019 18:56:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SASTT_OpeningFcn, ...
    'gui_OutputFcn',  @SASTT_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SASTT is made visible.
function SASTT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SASTT (see VARARGIN)
clc;
movegui( gcf, 'center' );
% Choose default command line output for SASTT
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SASTT wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = SASTT_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear  global
global data filepath dataHead ok kx ii i0 k dm3 path str_temp
[filename,filepath,index] = uigetfile({'*.nii'});
if index
    path=[filepath filename];
    cla;
    [data,dataHead]=rest_ReadNiftiImage(path);
    [~,~,dm3]=size(data);
    ok=true;
    kx=[];
    ii=0;i0=0;k=[];
    set(handles.edit2,'enable','on');
    set(handles.edit3,'enable','on');
    set(handles.edit4,'enable','on');
    set(handles.edit9,'enable','on');
    set(handles.edit13,'enable','on');
    set(handles.pushbutton2,'enable','on');
    set(handles.pushbutton16,'enable','on');
    set(handles.pushbutton6,'enable','on');
    set(handles.pushbutton23,'enable','on');
    set(handles.pushbutton24,'enable','on');
    set(handles.pushbutton26,'enable','on');
    set(handles.pushbutton27,'enable','on');
    set(handles.pushbutton17,'enable','on');
    set(handles.pushbutton21,'enable','on');
    index_dir=findstr(filepath,'\');
    l=length(index_dir);
    l1=index_dir(l);
    l2=index_dir(l-1);
    str_temp=filepath(l2+1:l1-1);
end
set(handles.edit11,'string',path);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset;
head_three_dim_reconstruct;

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global maxslice;
max_slice_evaluation;
set(handles.edit2,'string',num2str(maxslice));

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global maxslice topslice terminalslice data vs  
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
cla reset;
set(handles.pushbutton11,'enable','on');
set(handles.pushbutton12,'enable','on');
set(handles.pushbutton13,'enable','on');
set(handles.pushbutton14,'enable','on');
set(handles.pushbutton15,'enable','on');
set(handles.pushbutton18,'enable','on');
set(handles.pushbutton19,'enable','on');
set(handles.pushbutton30,'enable','on');
maxslice=get(handles.edit2,'string');
maxslice=str2double(maxslice);
I=data(:,:,maxslice);
maxgray=max(max(I));
I=(I.*255)./maxgray;
I=rot90(I);
I=round(I);
check_axes=guidata(findall(0,'type','figure','name','SASTT'));
h_axes=check_axes.h_axes;
axes(h_axes);
imshow(I,'border','tight','displayrange',[]);
if maxslice<terminalslice || maxslice>topslice
    msgbox('You have entered the wrong number of tumor slices, please re-enter£¡');
elseif isnan(maxslice)
    hl=errordlg('not a number','error');
    set(handles.edit2,'string','');
    pause(1);
    if ishandle(hl)
        delete(hl);
    end
end
vs=str2double(get(handles.edit2,'string'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global terminalslice ir dm3 data
if isnan(str2double(get(handles.edit9,'string')))
    h0=msgbox('Please enter the tumor category!');
    pause(1);
    if ishandle(h0)
        delete(h0);
    end
end
terminalslice=get(handles.edit3,'String');
guidata(hObject,handles);
terminalslice = str2double(terminalslice);
ir=terminalslice;
if terminalslice<=0 || terminalslice>dm3
    hg=errordlg('Incorrect input range!');
    pause(1);
    if ishandle(hg)
        delete(hg);
    end
elseif isnan(ir)
    hl=errordlg('not a number','error');
    pause(1);
    if ishandle(hl)
        delete(hl);
    end
end
I=data(:,:,terminalslice);
I=(I.*255)./max(max(I));
I=rot90(I);
I=round(I);
check_axes=guidata(findall(0,'type','figure','name','SASTT'));
h_axes=check_axes.h_axes;
axes(h_axes);
imshow(I,'border','tight','displayrange',[]);

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit3.
function edit3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
global dm3 topslice data
topslice=get(handles.edit4,'String');
% guidata(hObject,handles);
topslice = str2double(topslice);
if topslice<=0 || topslice>dm3
    hd=errordlg('Incorrect input range!');
    pause(1);
    if ishandle(hd)
        delete(hd);
    end
elseif isnan(topslice)
    hk=errordlg('not a number','error');
    pause(1);
    if ishandle(hk)
        delete(hk);
    end
end
I=data(:,:,topslice);
I=(I.*255)./max(max(I));
I=rot90(I);
I=round(I);
check_axes=guidata(findall(0,'type','figure','name','SASTT'));
h_axes=check_axes.h_axes;
axes(h_axes);
imshow(I,'border','tight','displayrange',[]);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset;
rotate3d off;
global str_temp ir topslice filepath
topslice=get(handles.edit4,'String');
guidata(hObject,handles);
ir=topslice;
check_axes=guidata(findall(0,'type','figure','name','SASTT'));
h_axes=check_axes.h_axes;
axes(h_axes);
imshow(imread([filepath,'result',str_temp,'\',ir,'th slice.png']));
title([ir,'th slice']);

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global str_temp ir topslice filepath flag2
topslice=get(handles.edit3,'String');
guidata(hObject,handles);
ir=str2double(ir)-1;
if ir<str2double(topslice)
    if ~exist([filepath,'result',str_temp,'\',num2str(ir),'th slice.png'],'file')
        ir=str2double(topslice) ;
        hs=msgbox('Has reached the top of the tumor£¡');
        if ishandle(hs)
            pause(1);
            delete(hs);
        end
        ir=num2str(ir);
        check_axes=guidata(findall(0,'type','figure','name','SASTT'));
        h_axes=check_axes.h_axes;
        axes(h_axes);
        imshow(imread([filepath,'result',str_temp,'\',ir,'th slice.png']));
        title([ir,'th slice']);
    elseif exist([filepath,'result',str_temp,'\',num2str(ir),'th slice.png'],'file')
        if flag2==1
            hs=msgbox('Viewing previously processed results£¡');
            if ishandle(hs)
                pause(1);
                delete(hs);
            end
            flag2=0;
        end
        ir=num2str(ir);
        check_axes=guidata(findall(0,'type','figure','name','SASTT'));
        h_axes=check_axes.h_axes;
        axes(h_axes);
        imshow(imread([filepath,'result',str_temp,'\',ir,'th slice.png']));
        title([ir,'th slice']);
    end
else
    ir=num2str(ir);
    check_axes=guidata(findall(0,'type','figure','name','SASTT'));
    h_axes=check_axes.h_axes;
    axes(h_axes);
    imshow(imread([filepath,'result',str_temp,'\',ir,'th slice.png']));
    title([ir,'th slice']);
end
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global str_temp ir terminalslice filepath flag1
terminalslice=get(handles.edit4,'String');
guidata(hObject,handles);
ir=str2double(ir)+1;
if ir>str2double(terminalslice)
    if ~exist([filepath,'result',str_temp,'\',num2str(ir),'th slice.png'],'file')
        ir=str2double(terminalslice) ;
        hs=msgbox('Has reached the bottom of the tumor£¡');
        if ishandle(hs)
            pause(1);
            delete(hs);
        end
        ir=num2str(ir);
        check_axes=guidata(findall(0,'type','figure','name','SASTT'));
        h_axes=check_axes.h_axes;
        axes(h_axes);
        imshow(imread([filepath,'result',str_temp,'\',ir,'th slice.png']));
        title([ir,'th slice']);
    elseif exist([filepath,'result',str_temp,'\',num2str(ir),'th slice.png'],'file')
        if flag1==1
            hs=msgbox('Viewing previously processed results£¡');
            if ishandle(hs)
                pause(1);
                delete(hs);
            end
            flag1=0;
        end
        ir=num2str(ir);
        check_axes=guidata(findall(0,'type','figure','name','SASTT'));
        h_axes=check_axes.h_axes;
        axes(h_axes);
        imshow(imread([filepath,'result',str_temp,'\',ir,'th slice.png']));
        title([ir,'th slice']);
    end
else
    ir=num2str(ir);
    check_axes=guidata(findall(0,'type','figure','name','SASTT'));
    h_axes=check_axes.h_axes;
    axes(h_axes);
    imshow(imread([filepath,'result',str_temp,'\',ir,'th slice.png']));
    title([ir,'th slice']);
end
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset;
rotate3d off;
global str_temp ir terminalslice filepath
terminalslice=get(handles.edit3,'String');
ir=terminalslice;
check_axes=guidata(findall(0,'type','figure','name','SASTT'));
h_axes=check_axes.h_axes;
axes(h_axes);
imshow(imread([filepath,'result',str_temp,'\',ir,'th slice.png']));
title([ir,'th slice']);

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data rdata topslice terminalslice pompt Accuracy Sensitivity Specificity
topslice=str2double(get(handles.edit4,'string'));
terminalslice=str2double(get(handles.edit3,'string'));
rdata=zeros(size(data));
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
pompt=get(handles.edit9,'string');
switch pompt
    case '1'
        seg_type_one ;
        cla reset;
        hmsg=msgbox('Finished£¡');
        pause(1);
        if ishandle(hmsg)
            delete(hmsg);
        end
    case '2'
        Linear_stretching;
        seg_type_two;
        cla reset;
        hmsg=msgbox('Finished£¡');
        pause(1);
        if ishandle(hmsg)
            delete(hmsg);
        end
    case '3'
        Linear_stretching;
        seg_type_three;
        hmsg=msgbox('Finished£¡');
        pause(1);
        if ishandle(hmsg)
            delete(hmsg);
        end
        cla reset;
end

% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%°ïÖú¶Ô»°¿ò
msgbox({'Type 1: The gray value of the tumor boundary is very close to the gray level of the cerebrospinal fluid and the position is very close..';...
        'Type 2: The gray value of the inner boundary of the tumor is slightly lower than white matter and is completely surrounded by white matter, or the gray value of the inner boundary of the tumor is slightly lower than gray matter and is completely surrounded by gray matter.';...
        'Type 3: The gray value of the inner boundary of the tumor is slightly lower than that of the gray matter and is located in the ventricle.'},'Tips','Help');


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[w_Accuracy,w_Sensitivity,w_Specificity]=WholeBrain_Evaluation;
msgbox({'        Whole Brain estimate:      ';['        Accuracy:  ',num2str(w_Accuracy)];['        Sensitivity: ',num2str(w_Sensitivity)];['        Specificity: ',num2str(w_Specificity)]},'Evaluation Results');

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiwait(handles.figure1);

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear;clc;close all;

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pompt
pompt=get(handles.edit9,'string');
if isempty(get(handles.edit11,'string'))
    hp=msgbox('The path is empty');
    pause(1);
    delete(hp);
    set(handles.edit9,'string','');
end
pompt=str2double(pompt);
if isnan(pompt)
    h3=errordlg('not a number','error');
    pause(1);
    if ishandle(h3)
        delete(h3);
    end
end
% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear  global;
global path data dataHead dm3
path=get(handles.edit11,'string');
if ~exist(path,'file')
    hp=msgbox(' path is error !');
    pause(1);
    delete(hp);
    clear path;
    set(handles.edit11,'string','');
else
    [data,dataHead]=rest_ReadNiftiImage(path);
    [~,~,dm3]=size(data);
    set(handles.edit3,'enable','on');
    set(handles.edit4,'enable','on');
    set(handles.edit9,'enable','on');
    set(handles.edit13,'enable','on');
    set(handles.pushbutton2,'enable','on');
    set(handles.pushbutton16,'enable','on');
    set(handles.pushbutton6,'enable','on');
    set(handles.pushbutton23,'enable','on');
    set(handles.pushbutton24,'enable','on');
    set(handles.pushbutton26,'enable','on');
    set(handles.pushbutton27,'enable','on');
    set(handles.edit2,'enable','on');
    set(handles.pushbutton17,'enable','on');
    set(handles.pushbutton21,'enable','on');
    index_dir=findstr(filepath,'\');
    l=length(index_dir);
    l1=index_dir(l);
    l2=index_dir(l-1);
    str_temp=filepath(l2+1:l1-1);
end
% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[l_Accuracy,l_Sensitivity,l_Specificity]=LargestSlice_Evaluation;
msgbox({'        Largest slice estimate£º       ';['        Accuracy:  ',num2str(l_Accuracy)];['        Sensitivity: ',num2str(l_Sensitivity)];['        Specificity: ',num2str(l_Specificity)]},'Evaluation Results');

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data maxslice
maxslice=str2double(get(handles.edit2,'string'));
if isempty(maxslice)
    hx=msgbox('No data entered yet !');
    pause(1);
    if ishandle(hx)
        delete(hx);
    end
else
    maxslice=maxslice+1;
    set(handles.edit2,'string',num2str(maxslice));
    I=data(:,:,maxslice);
    maxgray=max(max(I));
    I=(I.*255)./maxgray;
    I=rot90(I);
    I=round(I);
    check_axes=guidata(findall(0,'type','figure','name','SASTT'));
    h_axes=check_axes.h_axes;
    axes(h_axes);
    imshow(I,'border','tight','displayrange',[]);
end
% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data maxslice
maxslice=str2double(get(handles.edit2,'string'));
if isempty(maxslice)
    hx=msgbox('No data entered yet !');
    pause(1.5);
    if ishandle(hx)
        delete(hx);
    end
else
    maxslice=maxslice-1;
    set(handles.edit2,'string',num2str(maxslice));
    I=data(:,:,maxslice);
    I=(I.*255)./max(max(I));
    I=rot90(I);
    I=round(I);
    check_axes=guidata(findall(0,'type','figure','name','SASTT'));
    h_axes=check_axes.h_axes;
    axes(h_axes);
    imshow(I,'border','tight','displayrange',[]);
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(hObject);

function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data vs
vs=str2double(get(handles.edit13,'string'));
if ~isnan(vs)
    I=data(:,:,vs);
    maxgray=max(max(I));
    I=(I.*255)./maxgray;
    I=rot90(I);
    I=round(I);
    check_axes=guidata(findall(0,'type','figure','name','SASTT'));
    h_axes=check_axes.h_axes;
    axes(h_axes);
    imshow(I,'border','tight','displayrange',[]);
end
% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data vs
vs=str2double(get(handles.edit13,'string'));
if isempty(vs)
    hx=msgbox('No data entered yet !');
    pause(1);
    if ishandle(hx)
        delete(hx);
    end
else
    vs=vs+1;
    set(handles.edit13,'string',num2str(vs));
    I=data(:,:,vs);
    I=(I.*255)./max(max(I));
    I=rot90(I);
    I=round(I);
    check_axes=guidata(findall(0,'type','figure','name','SASTT'));
    h_axes=check_axes.h_axes;
    axes(h_axes);
    imshow(I,'border','tight','displayrange',[]);
end

% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data vs
vs=str2double(get(handles.edit13,'string'));
if isempty(vs)
    hx=msgbox('No data entered yet !');
    pause(1);
    if ishandle(hx)
        delete(hx);
    end
else
    vs=vs-1;
    set(handles.edit13,'string',num2str(vs));
    I=data(:,:,vs);
    I=(I.*255)./max(max(I));
    I=rot90(I);
    I=round(I);
    check_axes=guidata(findall(0,'type','figure','name','SASTT'));
    h_axes=check_axes.h_axes;
    axes(h_axes);
    imshow(I,'border','tight','displayrange',[]);
end

% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({' 1¡¢ This is an open source toolkit. It is mainly used to segment and extract tumors according to the type of tumor.';' 2¡¢ If the program has an unknown error, please close and restart.';' 3¡¢ The software supports separate processing of tumor slices with poor processing results, click the Re-Execute button, enter the slice to be processed again, and click the Execute button!.'},'Instructions','Help');

% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hr=msgbox('Please enter the range of the tumor and the largest slice of the tumor!');
if ishandle(hr)
    pause(1);
    delete(hr);
end
set(handles.edit2,'string','');
set(handles.edit3,'string','');
set(handles.edit4,'string','');

% --- Executes during object creation, after setting all properties.
function h_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate h_axes
