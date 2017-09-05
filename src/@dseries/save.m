function save(o, basename, format) % --*-- Unitary tests --*--

% Saves a dseries object on disk.

% Copyright (C) 2013-2017 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

if nargin<3 || isempty(format)
    format = 'csv';
end

if nargin<2 || isempty(basename)
    basename = 'dynare_series';
end

switch format
  case 'm'
    currentdirectorycontent = dir();
    if ismember([basename, '.m'],{currentdirectorycontent.name})
        copyfile([basename, '.m'],[basename, '.m.csv']);
    end
    fid = fopen([basename, '.m'],'w');
    fprintf(fid,'%% File created on %s.\n',datestr(now));
    fprintf(fid,'\n');
    fprintf(fid,'FREQ__ = %s;\n',num2str(frequency(o)));
    fprintf(fid,'INIT__ = ''%s'';\n',date2string(firstdate(o)));
    fprintf(fid,'\n');
    fprintf(fid,'NAMES__ = {');
    for i = 1:vobs(o)
        fprintf(fid,[ '''' o.name{i}  '''']);
        if i<vobs(o)
            fprintf(fid,'; ');
        end
    end
    fprintf(fid,'};\n');
    str = 'TEX__ = {';
    for i=1:vobs(o)-1
        str = [str, '''%s''; '];
    end
    str = [str, '''%s''};'];
    str = sprintf(str, o.tex{:});
    pattern = '(\w*)(\\\_)';
    str = regexprep(str, pattern, '$1\\\\_');
    fprintf(fid,str);
    fprintf(fid,'\n');
    fprintf(fid,'OPS__ = {');
    for i = 1:vobs(o)
        if isempty(o.ops{i})
            fprintf(fid,[ '[]']);
        else
            fprintf(fid,[ '''' o.ops{i}  '''']);
        end
        if i<vobs(o)
            fprintf(fid,'; ');
        end
    end
    fprintf(fid,'};\n\n');
    for v = 1:vobs(o)
        fprintf(fid,'%s = [\n', o.name{v});
        fprintf(fid,'%15.8g\n', o.data(1:end-1,v));
        fprintf(fid,'%15.8g];\n\n', o.data(end,v));
    end
    fclose(fid);
  case 'mat'
    FREQ__ = frequency(o);
    INIT__ = date2string(firstdate(o));
    NAMES__ = o.name;
    TEX__ = o.tex;
    OPS__ = o.ops;
    str = [];
    for v = 1:vobs(o)
        str = sprintf('%s %s = o.data(:,%s);', str, o.name{v}, num2str(v));
    end
    eval(str);
    currentdirectorycontent = dir();
    if ismember([basename, '.mat'], {currentdirectorycontent.name})
        copyfile([basename, '.mat'], [basename, '.old.mat']);
    end
    save([basename '.mat'], 'INIT__', 'FREQ__', 'NAMES__', 'TEX__', 'OPS__', o.name{:});
  case 'csv'
    currentdirectorycontent = dir();
    if ismember([basename, '.csv'],{currentdirectorycontent.name})
        copyfile([basename, '.csv'],[basename, '.old.csv']);
    end
    fid = fopen([basename, '.csv'],'w');
    fprintf(fid,',%s', o.name{:});
    fprintf(fid,'\n');
    for t = 1:nobs(o)
        str = sprintf(', %15.8g',o.data(t,:));
        fprintf(fid, '%s%s\n',date2string(o.dates(t)), str);
    end
    fclose(fid);
end

%@test:1
%$ % Define a data set.
%$ A = [transpose(1:10),2*transpose(1:10)];
%$
%$ % Define names
%$ A_name = {'A1';'A2'};
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    save(ts1,'ts1','csv');
%$    t = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ delete('ts1.csv');
%$
%$ T = all(t);
%@eof:1

%@test:2
%$ % Define a data set.
%$ A = [transpose(1:10),2*transpose(1:10)];
%$
%$ % Define names
%$ A_name = {'A1';'A2'};
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    save(ts1,'ts1','m');
%$    t = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ delete('ts1.m');
%$
%$ T = all(t);
%@eof:2

%@test:3
%$ % Define a data set.
%$ A = [transpose(1:10),2*transpose(1:10)];
%$
%$ % Define names
%$ A_name = {'A1';'A2'};
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    save(ts1,'ts1','mat');
%$    t = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ delete('ts1.mat');
%$
%$ T = all(t);
%@eof:3

%@test:4
%$ % Define a data set.
%$ A = [transpose(1:10),2*transpose(1:10)];
%$
%$ % Define names
%$ A_name = {'A1';'A2'};
%$
%$ % Instantiate and save a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts1.save;
%$    t = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ delete('dynare_series.csv');
%$
%$ T = all(t);
%@eof:4
