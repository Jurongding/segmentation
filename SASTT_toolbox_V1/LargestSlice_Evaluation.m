function [l_Accuracy,l_Sensitivity,l_Specificity]=LargestSlice_Evaluation()
% evaluates the largest section of the tumor
% evaluated parameters: accuracy, sensitivity, specificity
global filepath str_temp data path1 maxslice edata
try
    [rdata,dataHead]=rest_ReadNiftiImage([filepath,'result',str_temp,'\','processresults.nii']);
catch
    h=msgbox('the ''processresult.nii'' cannot find! ');
    if ishandle(h)
        pause(1)
        delete(h)
    end
    [file_rdata,path_rdata,ind] = uigetfile({'*.nii'},'please select ''processresult.nii'' file');
    if ind
        path0=[path_rdata file_rdata];
    end
    [rdata,dataHead]=rest_ReadNiftiImage(path0);
    
end
if isempty(edata)
    [filename,filepath1,index] = uigetfile({'*.nii'},'please select a standard data');
    if index
        path1=[filepath1 filename];
    end
    [edata,Head]=rest_ReadNiftiImage(path1);
end
slice=maxslice;
C=data(:,:,slice);
cep=length(find(C==0));
A=rdata(:,:,slice);
B=edata(:,:,slice);
A(find(A>0))=255;
B(find(B>0))=255;
abi=zeros(size(A));
abu=zeros(size(A));
[mi,ni]=size(A);
ac=mi*ni-cep;
aa=length(find(A));
bb=length(find(B));
abi(intersect(find(A),find(B)))=255;
abu(union(find(A),find(B)))=255;
abic=length(find(abi));
abuc=length(find(abu));
TP=abic;
TN=ac-abuc;
FP=aa-abic;
FN=bb-abic;
l_Accuracy=(TP+TN)/(TP+TN+FP+FN);
l_Sensitivity=TP/(TP+FN);
l_Specificity=TN/(TN+FP);
end