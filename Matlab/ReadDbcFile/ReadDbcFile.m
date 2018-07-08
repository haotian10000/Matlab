function [signal,status] = ReadDbcFile(file)
    [pathstr,name,ext] = fileparts(file);
    disp(pathstr);
    disp(name);
    disp(ext);
    if strcmp(ext, '.dbc') == 0
        status = 'File type error';
        return;
    end
    status = 'OK';
    info = GetMsgObj(file);
    temp = CellObjToMulti(info(1,1));
    sys_name = CatSysName(temp);
    msg = CellObjToMulti(info(1,2));
    infomation = GetMsgInfo(msg);
    signal = [sys_name,infomation];
end

function msg_obj = GetMsgObj(file)
    i = 1;
    head_str='';
    bo_str = '';
    find_bo_flg = 0;
    cell_obj=cell(1,2);
    [fid,info] = fopen(file,'rt');
    if fid == -1
        disp(info);
    else
        while true
            tline = fgetl(fid);
            if ~ischar(tline)
                break; 
            end
            if length(tline) >=3
                head_str = tline(1:3);
                if strcmp(head_str,'BO_')
                    find_bo_flg = 1;
                    bo_str = tline;
                end
            end
            if length(tline) >=4 && find_bo_flg==1
                head_str = tline(1:4);
                if strcmp(head_str,' SG_')
                    cell_obj(i,1) = cellstr(bo_str);
                    cell_obj(i,2) = cellstr(tline);
                    i = i + 1;
                end
            end
        end
    end
    fclose(fid);
    msg_obj = cell_obj;
end

function multi_cell = CellObjToMulti(obj)
    st = string(obj);
    for i = 1:length(st)
        str = deblank(st(i));
        str = regexp((str),'\s+','split');
        multi_cell = cellstr(str);
    end
end

function cat_sys_name = CatSysName(obj)
    str_name = char(obj(1,3));
    str_name = (str_name(1:length(str_name)-1));
    
    str_id = char(obj(1,2));
    cat_sys_name = strcat(str_name,'_',str_id);
end

function sig_cel=GetMsgInfo(obj)
    %获取信号名
    sig_name = char(obj(1,3));
    %获取起始位,获取位长度
    str_ch = char(obj(1,5));
    ind1 = strfind(str_ch,'|');
    ind2 = strfind(str_ch,'@');
    start_bit = str_ch(1:ind1-1);
    bit_len = str_ch(ind1+1:ind2-1);
    %获取计算因子,获取偏移量
    str_ch = char(obj(1,6));
    ind1 = strfind(str_ch,'(');
    ind2 = strfind(str_ch,',');
    ind3 = strfind(str_ch,')');
    factor = str_ch(ind1+1:ind2-1);
    offset = str_ch(ind2+1:ind3-1);
    %获取最小值,获取最大值
    str_ch = char(obj(1,7));
    ind1 = strfind(str_ch,'[');
    ind2 = strfind(str_ch,'|');
    ind3 = strfind(str_ch,']');
    min = str_ch(ind1+1:ind2-1);
    max = str_ch(ind2+1:ind3-1);
    sig_cel = {sig_name,start_bit,bit_len,factor,offset,min,max};
end