function hydrogel_main1_detection(parameter,stitch,pygellan)
project=[];
experiment=[];
cells=[];
start_time=datetime('now','TimeZone','local','Format',' HH:mm:ss');
data_path=parameter.data_path;


fcsfile=parameter.fcsname;
rawhydrogelfilename= char(fullfile(data_path,append(fcsfile,".fcs")));

cutoff.cluster=8;
cutoff.radii=15;
cutoff.high_intensity=5e2;
cutoff.low_intensity=5e2;
parameter.cutoff=cutoff;

parameter.thresholdG=0.5;
parameter.thresholdR=0.5;
parameter.filterMagG=50;
parameter.filterMagR=50;
parameter.mindistance=0.9;
parameter.zfocus=min(parameter.iz_max);
parameter.t_sphericity=0.98;


%     b=uint16(stitch_532(row_shift+1:row_shift+im_size_x2,:,:));
channel=transpose(fieldnames(stitch));

num_ch=length(channel);
for icnt=1:num_ch
    ch_name=channel{icnt};
    b=uint16(stitch.(channel{icnt}));     % Bright field
    if strcmp(ch_name,'BF')
        hydrogel=zscan_detect_hydrogel(b,parameter,'');
    end
        [intensity]=frame_measure_intensity_hydrogel(b,hydrogel);
         hydrogel.(ch_name)=intensity;
    
end

%figure(2)
%visualize_color_image(R,B,b)
end_time=datetime('now','TimeZone','local','Format',' HH:mm:ss');
%delete(p)

hydrogel.channels=channel;
%% export an fcs file
% [fcs_hdr]=flowjo_create_fcs_metadata(start_time,end_time,project,experiment,cells,rawBeadsfilename,data_path,length(beads.radii),'beads');
% flowjo_export_data2fcs(rawBeadsfilename, beads, fcs_hdr,'beads')
% 
% [fcs_hdr]=flowjo_create_fcs_metadata(start_time,end_time,project,experiment,cells,rawRedfilename,data_path,length(Gbeads.radii),'beads')
% flowjo_export_data2fcs(rawRedfilename, Rbeads, fcs_hdr,'Red')
num_of_event=length(hydrogel.radii);

 [fcs_hdr]=flowjo_create_fcs_metadata(start_time,end_time,project,experiment,cells,...
     rawhydrogelfilename,data_path,...
     channel,num_of_event);

 flowjo_export_data2fcs(parameter,rawhydrogelfilename, hydrogel, fcs_hdr)
% if isfield(parameter,'Mdl')
%     figure(2);
%     [~]=main2_flowjo('machine_learning',rawhydrogelfilename,parameter.xml_filename);
% end
channels=hydrogel.channels;
num_ch=length(channels);
figure(5);
for icnt=1:num_ch
    subplot(num_ch+2,1,icnt);hist(hydrogel.(channels{icnt}),100);xlabel(channels{icnt})
end
subplot(num_ch+2,1,3);hist(hydrogel.(channels{1})./hydrogel.(channels{2}),100);xlabel('normalized')
subplot(num_ch+2,1,4);hist(hydrogel.radii,100);xlabel('radii (pixel)')
end
