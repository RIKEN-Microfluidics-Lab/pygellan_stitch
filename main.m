clear all

import py.pygellan.magellan_data.MagellanDataset 
data_path = uigetdir;
% data_path='D:\Shintaku\20200901\nishikawa_beads9_10';
sigma=180;%imflatfield parameter



project=[];
experiment=[];
cells=[];
start_time=datetime('now','TimeZone','local','Format',' HH:mm:ss');


magellan=MagellanDataset(data_path);
num_col_row=cell(magellan.get_num_rows_and_cols());
col=int64(num_col_row{2});
row=int64(num_col_row{1});
num_frames=uint64(magellan.get_num_frames())-1;
pix_size=magellan.pixel_size_xy_um();

% Obtain name of channel
channel_names=cell(magellan.get_channel_names());
for icnt=1:length(channel_names)
    channel(icnt)=string(channel_names{icnt});
end

%[ix,iy,iz,iz_max]=zscan_find_focal_plane(magellan,channel(1),col,row);

for icnt=1:length(channel_names)
    [stitch.(channel{icnt}),~] = zscan_focused_image(magellan,channel(icnt),1,...
        sigma,col,row,ix,iy,iz,iz_max,num_frames,1,[data_path '\' char(channel(icnt)) '.tiff']);
end




