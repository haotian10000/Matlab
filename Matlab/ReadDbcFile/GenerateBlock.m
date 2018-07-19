%{
sig_obj is a cell;
CAN_ID
signal name; start bit; bit len; factor; offset; min; max;

%}
function GenerateBlock()

%��ȡ�źŵĸ���

%��������ڵ�λ��

%����ÿ���źŵ�λ��

%ѭ�������źſ�
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
%����һ��Subsystem
sig_block_name = strcat(str_model_name,'/',str_sig_name);
add_block('simulink/Ports & Subsystems/Subsystem',sig_block_name);
delete_line(sig_block_name,'In1/1','Out1/1');
%���Demux
add_block('simulink/Signal Routing/Demux',strcat(sig_block_name,'/','Demux'),'Outputs','8');
%������Ҫ�����ֽڵ����ݿ��
byte_x_pos = ceil((start_bit+1)/8);
byte_y_pos = ceil((start_bit+bit_len)/8);

port_num = byte_y_pos - byte_x_pos + 1;
%���ADD
add_block('simulink/Math Operations/Add',strcat(sig_block_name,'/','Add'),'Inputs','++++++++');
%����ź�Gainģ��
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
%����˿��ź�λ��

%Demuxλ�ã��˿���

%����8λ����Addģ��








