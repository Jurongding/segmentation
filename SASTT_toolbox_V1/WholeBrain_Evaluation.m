function [w_Accuracy,w_Sensitivity,w_Specificity]=WholeBrain_Evaluation()
% evaluates the entire tumor segmentation result of the brain
% evaluated parameters: accuracy, sensitivity, specificity
global  filepath str_temp data path1 edata
try
    [rdata,~]=rest_ReadNiftiImage([filepath,'result',str_temp,'\','processresults.nii']);
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
    [rdata,~]=rest_ReadNiftiImage(path0);
end
if isempty(edata)
    [filename,filepath1,index] = uigetfile({'*.nii','please select a standard data'});
    if index
        path1=[filepath1 filename];
    end
    [edata,~]=rest_ReadNiftiImage(path1);
end
[~,~,d3]=size(edata);
sk=[];s3=0;
for sl=1:d3
    si=edata(:,:,sl);
    if find(si>0)
        s3=s3+1;
        sk(s3,1)=sl;
    end
end
buttomslice=min(sk);
topslice=max(sk);
TP=0;TN=0;FP=0;FN=0;
for slice=buttomslice:topslice
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
    LTP=abic;
    LTN=ac-abuc;
    LFP=aa-abic;
    LFN=bb-abic;
    TP=TP+LTP;TN=TN+LTN;FP=FP+LFP;FN=FN+LFN;
end
w_Accuracy=(TP+TN)/(TP+TN+FP+FN);
w_Sensitivity=TP/(TP+FN);
w_Specificity=TN/(TN+FP);
end