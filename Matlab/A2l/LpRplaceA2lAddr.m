function LpRplaceA2lAddr(ASAP2File, MAPFile)
% ASAP2POST Post-processing of ASAP2 file.
%
%   Operations performed:
%   - Replace ECU_Address placeholders with addresses from appropriate
%     MAP file
%
%   Syntax:
%   ASAP2POST(ASAP2File, MAPFile)
%
%   Inputs:
%   - ASAP2File: ASAP2 file.
%   - MAPFile:   Corresponding Linker MAP file
%
%   ECU_Address Placeholder Replacement:
%   --------------------------------------
%   - Calls "getSymbolTable1" to get the symbol table (constructed from a      
%     linker map file).
%   - Parses through the ASAP2 file and replaces ECU_Address placeholder
%     with actual memory address (from symbol table).
%   - The default MATLAB subfunction provided expects the following:
%     - ECU_Address placeholder in ASAP2 file: 
%       0x0000 /* @ECU_Address@varName@ */
%     - MAP file format (space OR tab delimited):
%       ----------------------------------------
%       varName(column1)  ECU_Address(column2)
%       ----------------------------------------
%       a                 0xFFF0
%       b                 0xFFF1
%       ...
%
%   MAP files vary from compiler to compiler. 
%   To use the provided MATLAB subfunction with your compiler, either:
%   - Modify the existing MATLAB subfunction to suite your MAP file format
%   (or use any of the example subfunctions provided that correspond to
%   your file format) 
%   OR
%   - Reformat your MAP file to match the format described above.

%   Copyright 1994-2010 The MathWorks, Inc.

if nargin~=2
    DAStudio.error('RTW:asap2:invalidInputParam',mfilename);
end

addrPrefix = '0x0000 \/\* @ECU_Address@';
addrSuffix = '@ \*\/';

% Extract contents of ASAP2 file
if ~exist(ASAP2File,'file')
    DAStudio.error('RTW:asap2:UnableFindFile',ASAP2File);
end

% Extract contents of MAP file
if ~exist(MAPFile,'file')
    DAStudio.error('RTW:asap2:UnableFindFile',MAPFile);
end

% Create symbol table from symbol names and addresses extracted from
% MAP file
MAPFileHash = getSymbolTable1(MAPFile) ;     %#ok<NASGU>

% Identify placeholder strings and replace them dynamically with symbol
% values in hash table.
% In this regular expression, the token (\w+) will be the symbol name.
% This symbol name is specified (using $1) in the dynamic regular
% expression (${....})
newASAP2FileString = '';
a2l_fid = fopen(ASAP2File);
a2l_index = 1;
str = '';
while ~feof(a2l_fid)
    a2l_line = fgetl(a2l_fid);
    findIndex = regexp(a2l_line,[addrPrefix '(\w+)' addrSuffix], 'once');
    if ~isempty(findIndex)
        try
        a2l_line = regexprep(a2l_line, [addrPrefix '(\w+)' addrSuffix], '${MAPFileHash($1)}');
        catch
            sprintf('在map文件中没有找到a2l文件的第%d行的变量',a2l_index);
        end
    end
    a2l_index = a2l_index + 1;
    str = [newASAP2FileString  a2l_line  10];       %10代表换行符
    newASAP2FileString = str;
end
fclose(a2l_fid);
% Write new content to original ASAP2 file
fid = fopen(ASAP2File, 'w');
fprintf(fid,'%s',newASAP2FileString);
fclose(fid);


% =========================================================================
% SUBFUNCTIONS
% =========================================================================    
    
 function MAPFileHash = getSymbolTable1(MAPFile)   
 % GETSYMBOLTABLE1: Extract symbol names and symbol values from
 % the linker MAP file and store them into a hash table    

 % The following regular expression assumes the following MAP file
 % format (space OR tab delimited):
 %       ----------------------------------------
 %       varName(column1)  ECU_Address(column2)
 %       ----------------------------------------
 %       a                 0xFFF0
 %       b                 0xFFF1
 %       ...
    MAPFileHash = containers.Map;
    index = 1;
    map_fid = fopen(MAPFile);
    while ~feof(map_fid)
        map_line = fgetl(map_fid);
        pairs = regexp(map_line,'^ +(0x([0-9a-fA-F]+)) +([_A-Za-z]\w*)[\s]*$','tokens');
        if ~isempty(pairs)
        MAPFileHash(pairs{1}{2}) = pairs{1}{1};
        index = index + 1;
        end
    end     

%% Sub-functions for sample linker map formats     
%     
% function MAPFileHash = getSymbolTable2(MAPFileString)
% % GETSYMBOLTABLE2: Extract symbol names and symbol values from
% % the linker MAP file and store them into a hash table
% % 
% %   Format:
% % 
% %       -------------------------------------------------------------
% %       someText(column1)  ECU_Address(column2)  varName(column3)
% %       -------------------------------------------------------------
% %       .data              FFF0                    a
% %       .data              FFF1                    b
% %       ...
% % 
%     pairs = regexp(MAPFileString, '\n\s*\S+\s+([0-9a-fA-F]+)\W+(\S+)',...
%         'tokens');
%     
%     % Store symbol names and corresponding symbol values into a hash table
%     MAPFileHash = containers.Map;
%     for i = 1:length(pairs)
%         MAPFileHash(pairs{i}{2}) = pairs{i}{1};
%     end
% 
% function MAPFileHash = getSymbolTable3(MAPFileString)
% % GETSYMBOLTABLE3: Extract symbol names and symbol values from
% % the linker MAP file and store them into a hash table
% %
% %   Format:
% %
% %      -------------------------------------------------------------
% %       varName(column1)  ECU_Address(column2)
% %      -------------------------------------------------------------
% %       | a               | 0xFFF0 |
% %       | b               | 0xFFF1 |
% %       ...
% %
%     pairs = regexp(MAPFileString, ...
%         '\n\s*\|\s+(\S+)\s+\|\s+(0x[0-9a-fA-F]+)\W', 'tokens');
%     
%     % Store symbol names and corresponding symbol values into a hash table
%     MAPFileHash = containers.Map;
%     for i = 1:length(pairs)
%         MAPFileHash(pairs{i}{1}) = pairs{i}{2};
%     end
% 
%  function MAPFileHash = getSymbolTable4(MAPFileString)
%  % GETSYMBOLTABLE4: Extract symbol names and symbol values from
%  % the linker MAP file and store them into a hash table
%  %
%  %   Format:
%  %
%  %      -------------------------------------------------------------
%  %       varName(column1)  ECU_Address(column2)
%  %      -------------------------------------------------------------
%  %       <SYMBOL name='a' address='0xFFF0'  ...
%  %       <SYMBOL name='b' address='0xFFF1'  ...
%  %       ...
%  %
%      pairs = regexp(MAPFileString, ...
%          '\n\s*<SYMBOL\sname=''(\S+)''\s+address=''0x([0-9a-fA-F]+)''\W', ...
%          'tokens');
% 
%      % Store symbol names and corresponding symbol values into a hash table
%      MAPFileHash = containers.Map;
%      for i = 1:length(pairs)
%          MAPFileHash(pairs{i}{1}) = pairs{i}{2};
%      end
     
% EOF

% LocalWords:  FFF GETSYMBOLTABLE sname
