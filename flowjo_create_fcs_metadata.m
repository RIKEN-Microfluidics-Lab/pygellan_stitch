function [fcs_hdr]=flowjo_create_fcs_metadata(start_time,end_time,project,experiment,cells,...
    filename,data_path,channels,num_of_event)
software_ver='zscan_stitch_ver2';
creater='Hirofumi Shintaku';
%if strcmp(type,'hydrogel')
%    listpar={'center_x','center_y','center_z','radii','metric','mean_intensity','Green','Red','num_of_G','num_of_R','id'};
%else%if strcmp(type,'raw_hydrogel')
    %channels
    listpar=cat(2,{'center_x','center_y','center_z','radii','metric'},cellstr(channels),{'id','bool'});
%end
NumOfPar=length(listpar);
par=struct('name',listpar,...
    'name2',listpar,...
    'range',1024,...
    'bit',16',...
    'decade',4,...
    'log',0,...
    'logzero',0,...
    'gain',1);
fcs_hdr=struct('fcstype','FCS3.0',...
    'filename',filename,...
    'filepath',data_path,...
    'TotalEvents',num_of_event,...
    'NumOfPar',NumOfPar,...
    'Creater',software_ver,...
    'CompLabels',[],...
    'CompMat',[],...
    'par',par,...
    'starttime',char(start_time),...
    'stoptime',char(end_time),...
    'cytometry',computer,...
    'date',char(datetime('now','TimeZone','local','Format','d-MMM-y')),...
    'byteorder','4,3,2,1',...
    'datatype','l',...
    'system',computer('arch'),...
    'project',project,...
    'experiment',experiment,...
    'cells',cells,...
    'creator',creater,...
    'cytsn',[]);
end