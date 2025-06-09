function VTK_write(VTKData,filename,ext)
% VTK_write - write a VTK file that contains multiple field data.
%
%   VTK_write(VTKData, filename,ext)
%
%   VTKData is a structure currently containing:
%       1. The vtk file headers
%       2. The grid type
%       3. Point data
%       4. Cell structure
%       5. Cell type
%       6. Size of each cell/field data
%       7. Number of field data
%       8. Each field data name, size, and number type
%   
%   The script is a complement to the VTK_read script that I also shared.
%   VTKData structure is generated from that VTK_read script. This script
%   simply reverses the process and prints out the VTK file in the exact
%   same format. If your VTK file has different amount of spaces and it is
%   important to preserve those, after changing the necessary lines in
%   VTK_read, you also need to change it here.
%
%   Copyright 2022 (c) Zhangxi Feng, University of New Hampshire

%% Write multi-data VTK file in same format
fid = fopen([filename,'_out',ext],'w');

% 4 lines of header
fprintf(fid,'%s',VTKData.header{1});
fprintf(fid,'%s',VTKData.header{2});
fprintf(fid,'%s',VTKData.header{3});
fprintf(fid,'%s',VTKData.header{4});

% Points
strPrint = ['POINTS    ',num2str(size(VTKData.points,1)),' double'];
fprintf(fid,'%s\n',strPrint);
fprintf(fid,[repmat('%18.8e',1,3),'\n'],VTKData.points');

% Cells
totCells = size(VTKData.cells,1)*size(VTKData.cells,2);
strPrint = ['CELLS    ',num2str(size(VTKData.cells,1)),'   ',num2str(totCells)];
fprintf(fid,'%s\n',strPrint);
fprintf(fid,[repmat('%10i',1,9),'\n'],VTKData.cells');

% Cell types
strPrint = ['CELL_TYPES    ',num2str(size(VTKData.cellTypes,1))];
fprintf(fid,'%s\n',strPrint);
fprintf(fid,'%5i\n',VTKData.cellTypes);

% Cell data headers
strPrint = ['CELL_DATA    ',num2str(VTKData.cellDataSize)];
fprintf(fid,'%s\n',strPrint);
strPrint = 'FIELD FieldData    ';
fprintf(fid,'%s    %6i\n',strPrint,VTKData.numFieldData);

% Each cell data
for i = 1:VTKData.numFieldData
    % print the name
    curDataCol = size(VTKData.cellData{i},2);
    strPrint = [VTKData.cellDataName{i},'  ',num2str(curDataCol),'    ',VTKData.cellDataType{i}];
    fprintf(fid,'%s',strPrint);
    if (strcmp(VTKData.cellDataType{i}(end-3:end-1),'int') == 1)
        fprintf(fid,[repmat('%10i',1,curDataCol),'\n'],VTKData.cellData{i}');
    else
        fprintf(fid,[repmat('%18.8e',1,curDataCol),'\n'],VTKData.cellData{i}');
    end
end

fclose(fid);
end