% read stl-format as written by MWS3
% [xdata,ydata,zdata, stlname] = READ_STL(file)
%
% x/y/zdata = coordinate arrays
%             (number of columns = number of patches)
% normal    = facet normal vectors
% stlname   = name of solid (including layer)
%
% to visualize solid: patch(xdata, ydata, zdata, color);
%                     axis equal;

function [xdata, ydata, zdata, normal, stlname] = read_stl(file)

    fid = fopen(file);
    if fid == -1
        error('open file failed')
    end

    try
        cline = readline(fid);
        pos = findstr(cline,'solid');
        stlname = strtok(cline(pos+6:end));
    catch
        error('cannot read name of solid')
    end

    xdata = []; ydata = []; zdata = [];
    normal = [];
    while ~feof(fid)
        cline = readline(fid);
        pos = findstr(cline,'facet normal');
        if ~isempty(pos)
            normal = [normal eval(['[' cline(pos+12:end) ']'])'];
        end

        pos = findstr(cline,'outer loop');
        if ~isempty(pos)
            xdata = [xdata [0;0;0]];
            ydata = [ydata [0;0;0]];
            zdata = [zdata [0;0;0]];
            for iv = 1:3
                cline = readline(fid);
                pos = findstr(cline,'vertex');
                if isempty(pos)
                    error('inconsistent content in stl-file')
                end
                try
                    vertex = eval(['[' cline(pos+6:end) ']']);
                catch
                    error('inconsistent content in stl-file')
                end
                xdata(iv,end)=vertex(1);
                ydata(iv,end)=vertex(2);
                zdata(iv,end)=vertex(3);
            end
        end
    end
    
    fclose(fid);

    fprintf('imported stl-object "%s" with %d patches',...
            stlname,size(xdata,2))
end

function cline = readline(fid)

    byte = 0;
    cline = [];
    while byte ~= 10
        byte = fread(fid,1);
        if byte ~= 10
            cline = [cline byte];
        end
    end
    cline = char(cline);
end







