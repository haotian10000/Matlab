%{
sig_obj is a cell;
CAN_ID
signal name; start bit; bit len; factor; offset; min; max;

%}
function GenerateBlock()

%获取信号的个数

%计算输入口的位置

%计算每个信号的位置

%循环创建信号块
signal_obj = {'muxtest','sig_tst','12','2','0.1','10','2','200'}; 
GenerateSignalSubsystem([0,0,100,100],signal_obj);


%{
signal name; start bit; bit len; factor; offset; min; max;
%}
function GenerateSignalSubsystem(position, signal_obj)
index = 1;
str_model_name  = char(signal_obj(index));
index = index + 1;
str_sig_name    = char(signal_obj(index));
index = index + 1;
start_bit	= str2num( char(signal_obj(index)));
index = index + 1;
bit_len     = str2num( char(signal_obj(index)));
index = index + 1;
factor      = str2num( char(signal_obj(index)));
index = index + 1;
offset      = str2num( char(signal_obj(index)));
index = index + 1;
min         = str2num( char(signal_obj(index)));
index = index + 1;
max         = str2num( char(signal_obj(index)));
%创建一个Subsystem
sig_block_name = strcat(str_model_name,'/',str_sig_name);
add_block('simulink/Ports & Subsystems/Subsystem',sig_block_name);
delete_line(sig_block_name,'In1/1','Out1/1');
%添加Demux
add_block('simulink/Signal Routing/Demux',strcat(sig_block_name,'/','Demux'),'Outputs','8');
%计算需要几个字节的数据跨度
byte_x_pos = ceil((start_bit+1)/8);
byte_y_pos = ceil((start_bit+bit_len)/8);

port_num = byte_y_pos - byte_x_pos + 1;
%添加ADD
add_block('simulink/Math Operations/Add',strcat(sig_block_name,'/','Add'),'Inputs','++++++++');
%添加信号Gain模块
x1 = 0; y1 = 0; x2 = 50; y2 = 20;
for i= 1:8
    add_block('simulink/Math Operations/Gain',strcat(sig_block_name,'/','Gain',num2str(i)),'Position',[x1 y1 x2 y2],'Gain','0');
%     x1 = 0; y1 = y1+i*10; x2 = 50; y2 = y2+i*10;
end
% j = 0;
% for i=byte_x_pos:byte_y_pos
%     str = strcat('Gain',num2str(i));
%     set_param('model_name/subsystem_name/Gain','Gain',num2str(j));
%     j = j*256;
% end
%输入端口信号位置

%Demux位置，端口数

%大于8位增加Add模块








