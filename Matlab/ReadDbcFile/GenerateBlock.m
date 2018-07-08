function GenerateBlock(sig_obj)
add_block('simulink/Commonly Used Blocks/Constant','test/Constant');
set_param('test/Constant','position',[140,80,180,120]);
add_block('simulink/Commonly Used Blocks/Gain','test/Gain');
set_param('test/Gain','position',[220,80,260,120]);
add_line('test','Constant/1','Gain/1');

end

function GenerateOneSystem(obj)
simulink
end