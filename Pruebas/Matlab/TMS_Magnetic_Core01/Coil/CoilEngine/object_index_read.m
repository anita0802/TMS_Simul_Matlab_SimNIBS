function [name, Object, par, enclosingObjectIdx] = object_index_read(index_name)
%   This function reads an Object index file, and extracts the name, property,
%   and enclosing Object of each Object listed in the Object index file.

%   Copyright WAW/SNM 2019-2020

    %Attempt to open index file
    index_file = fopen(index_name);
    if(index_file<0)
        error(['Cannot open Object index file [' index_name ']']);
    end
    
    name = {};
    Object = {};
    par = [];
    enclosingObjectName = {};
    
    %Extract list of meshes and associated filenames from Object index file
    lineCounter = 0;
    while ~feof(index_file)
        currentLine = fgetl(index_file);
        lineCounter = lineCounter + 1;
        if(isempty(currentLine))
            continue;
        end
        if(currentLine(1) ~= '>') %Only care about lines that start with this indicator
            continue;
        end

        %Find field delimiters in the current line, check that all four fields
        %exist
        dividerIndex = find(currentLine == ':');
        if(length(dividerIndex) ~= 3)
            warning(['Entry [' currentLine '] on line ' num2str(lineCounter) ' of Object_index.txt should contain exactly four fields separated by '':''']);
            continue;
        end

        tempObjectName = strtrim(currentLine(2:dividerIndex(1)-1));
        tempFileName = strtrim(currentLine(dividerIndex(1)+1:dividerIndex(2)-1));
        temppaructivity = strtrim(currentLine(dividerIndex(2)+1:dividerIndex(3)-1));
        tempEnclosingObjectName = strtrim(currentLine(dividerIndex(3)+1:end));

        %Check that the filename itself exists
        if(isempty(tempFileName))
            error(['No file name found on line ' num2str(lineCounter) ' of Object_index.txt']);
        end
        %Check that the file exists
        if ~exist(tempFileName, 'file')
            error(['File [' tempFileName '] referenced on line ' num2str(lineCounter) ' of Object_index.txt does not exist.']);
        end

        %Check that the Object has a name associated with it
        if(isempty(tempObjectName))
            error(['No Object name found on line ' num2str(lineCounter) ' of Object_index.txt']);
        end

        %Check that the Object has a par associated with it
        if(isempty(temppaructivity))
            error(['No Object par found on line ' num2str(lineCounter) ' of Object_index.txt']);
        end
        tempObjectpaructivity = str2double(temppaructivity);
        %Check that the Object par could be parsed as a double
        if(isnan(tempObjectpaructivity))
            error(['Object par on line ' num2str(lineCounter) ' of Object_index.txt is not numeric']);
        end

        %Check that the Object has an enclosing Object associated with it
        if(isempty(tempEnclosingObjectName))
            error(['Enclosing Object is not specified on line ' num2str(lineCounter) ' of Object_index.txt']);
        end
        %At this point, all data *should* be valid
        name{end+1} = tempFileName;
        Object{end+1} = tempObjectName;
        par(end+1) = tempObjectpaructivity;
        enclosingObjectName{end+1} = tempEnclosingObjectName;
    end
    
    %Now: Check that there are no duplicate Object names
    for j=1:length(Object)
        if(any(strcmp(Object(j+1:end), Object{j})))
            error(['Multiple Objects share the name [' Object{j} ']']);
        end
    end
    
    %Now: Check that each enclosingObject is in the list of Objects, and create
    %a direct association between the enclosed Object and the enclosing Object
    enclosingObjectIdx = zeros(length(enclosingObjectName));
    for j=1:length(Object)
        if(strcmp(enclosingObjectName{j}, 'FreeSpace'))
           continue; 
        end

        if(~any(strcmp(enclosingObjectName{j}, Object)))
            error(['Object [' enclosingObjectName{j} '] was listed as an enclosing Object for Object [' Object{j} '], but this enclosing Object could not be found in the list of available Objects']);
        end

        enclosingObjectIdx(j) = find(strcmp(enclosingObjectName{j}, Object));
    end
    
end