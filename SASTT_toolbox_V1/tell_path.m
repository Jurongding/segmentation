function tell_path()
%Determines whether the folder exists
global filepath str_temp rdata
%Get the same folder name
index_dir=findstr(filepath,'\');
l=length(index_dir);
l1=index_dir(l);
l2=index_dir(l-1);
str_temp=filepath(l2+1:l1-1);
if exist([filepath,'result',str_temp])
    button1=questdlg({'Do you want to overwrite the contents of the folder?';'If you click yes, it is overwritten. Otherwise reserved.'},'question','Yes','No','default');
    if strcmp(button1,'Yes')==1
        rmdir([filepath,'result',str_temp],'s') % if it exist,delete it
        mkdir([filepath,'result',str_temp]);
    elseif strcmp(button1,'No')==1
        if exist([filepath,'result',str_temp,'\','processresults.nii'],'file')
            [rdata,dataHead]=rest_ReadNiftiImage([filepath,'result',str_temp,'\','processresults.nii']);
        else
            h=msgbox([filepath,'result',str_temp,'\','processresults.nii','not find!']);
            if ishandle(h)
                pause(0.5);
                delete(h)
            end
        end
    end
else
    mkdir([filepath,'result',str_temp]);
end
