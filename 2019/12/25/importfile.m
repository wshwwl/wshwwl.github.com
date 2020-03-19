function [VarName1,VarName2] = importfile(filename, startRow, endRow)
%IMPORTFILE1 ���ı��ļ��е���ֵ������Ϊ���������롣
%   [VARNAME1,VARNAME2] = IMPORTFILE1(FILENAME) ��ȡ�ı��ļ� FILENAME ��Ĭ��ѡ����Χ�����ݡ�
%
%   [VARNAME1,VARNAME2] = IMPORTFILE1(FILENAME, STARTROW, ENDROW) ��ȡ�ı��ļ�
%   FILENAME �� STARTROW �е� ENDROW ���е����ݡ�
%
% Example:
%   [VarName1,VarName2] = importfile1('aaa.csv',1, 23);
%
%    ������� TEXTSCAN��

% �� MATLAB �Զ������� 2019/11/10 20:16:27

%% ��ʼ��������
delimiter = {'\t',',',' '};
if nargin<2
    startRow = 1;
    endRow = inf;
elseif nargin==2
    endRow=inf;
end

%% ÿ���ı��еĸ�ʽ:
%   ��1: ˫����ֵ (%f)
%	��2: ˫����ֵ (%f)
% �й���ϸ��Ϣ������� TEXTSCAN �ĵ���
formatSpec = '%f%f%[^\n\r]';

%% ���ı��ļ���
fileID = fopen(filename,'r');

%% ���ݸ�ʽ��ȡ�����С�
% �õ��û������ɴ˴������õ��ļ��Ľṹ����������ļ����ִ����볢��ͨ�����빤���������ɴ��롣
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% �ر��ı��ļ���
fclose(fileID);

%% ���޷���������ݽ��еĺ���
% �ڵ��������δӦ���޷���������ݵĹ�����˲�����������롣Ҫ�����������޷���������ݵĴ��룬�����ļ���ѡ���޷������Ԫ����Ȼ���������ɽű���

%% ����������������б�������
VarName1 = dataArray{:, 1};
VarName2 = dataArray{:, 2};


