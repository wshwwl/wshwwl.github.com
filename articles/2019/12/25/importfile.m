function [VarName1,VarName2] = importfile(filename, startRow, endRow)
%IMPORTFILE1 将文本文件中的数值数据作为列向量导入。
%   [VARNAME1,VARNAME2] = IMPORTFILE1(FILENAME) 读取文本文件 FILENAME 中默认选定范围的数据。
%
%   [VARNAME1,VARNAME2] = IMPORTFILE1(FILENAME, STARTROW, ENDROW) 读取文本文件
%   FILENAME 的 STARTROW 行到 ENDROW 行中的数据。
%
% Example:
%   [VarName1,VarName2] = importfile1('aaa.csv',1, 23);
%
%    另请参阅 TEXTSCAN。

% 由 MATLAB 自动生成于 2019/11/10 20:16:27

%% 初始化变量。
delimiter = {'\t',',',' '};
if nargin<2
    startRow = 1;
    endRow = inf;
elseif nargin==2
    endRow=inf;
end

%% 每个文本行的格式:
%   列1: 双精度值 (%f)
%	列2: 双精度值 (%f)
% 有关详细信息，请参阅 TEXTSCAN 文档。
formatSpec = '%f%f%[^\n\r]';

%% 打开文本文件。
fileID = fopen(filename,'r');

%% 根据格式读取数据列。
% 该调用基于生成此代码所用的文件的结构。如果其他文件出现错误，请尝试通过导入工具重新生成代码。
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% 关闭文本文件。
fclose(fileID);

%% 对无法导入的数据进行的后处理。
% 在导入过程中未应用无法导入的数据的规则，因此不包括后处理代码。要生成适用于无法导入的数据的代码，请在文件中选择无法导入的元胞，然后重新生成脚本。

%% 将导入的数组分配给列变量名称
VarName1 = dataArray{:, 1};
VarName2 = dataArray{:, 2};


