function info = ReadDbcFile(file)
   [pathstr,name,ext] = fileparts(file);
   disp(pathstr);
   disp(name);
   disp(ext);
   if strcmp(ext, 'dbc') == 0
       info = 'File type error';
       return;
   end
   cell_obj=cell(10,1);
   i = 1;
    [fid,msg] = fopen(file,'rt');
    if fid == -1
        disp(msg);
    else
        while true
            tline = fgetl(fid);
            if ~ischar(tline)
               break; 
            end
            if length(tline) < 3
               continue; 
            end
            if tline(1:3) == 'BO_'
               cell_obj(i,1) = cellstr(GetMsgName(tline));
               i = i + 1;
            end
        end
    end
     info = cell_obj;
end

function msg_name = GetMsgName(str)
    space_num = 0;
    name_start_id=0;
    name_end_id=0;
    for i=1:length(str)
        if str(i) == ' '
            space_num = space_num + 1;
        end
        if space_num == 2 && name_start_id == 0
            name_start_id = i + 1;
        end
        if str(i) == ':'
            name_end_id = i - 1;
            break;
        end
    end
    msg_name = str(name_start_id:name_end_id);

end
