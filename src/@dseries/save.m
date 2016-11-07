function save(A,basename,format) % --*-- Unitary tests --*--

% Saves a dseries object on disk.

% Copyright (C) 2013-2016 Dynare Team
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
    fprintf(fid,'FREQ__ = %s;\n',num2str(frequency(A)));
    fprintf(fid,'INIT__ = ''%s'';\n',date2string(firstdate(A)));
    fprintf(fid,'\n');
    fprintf(fid,'NAMES__ = {');
    for i=1:vobs(A)
        fprintf(fid,[ '''' A.name{i}  '''']);
        if i<vobs(A)
            fprintf(fid,'; ');
        end
    end
    fprintf(fid,'};\n');
    str = 'TEX__ = {';
    for i=1:vobs(A)-1
        str = [str, '''%s''; '];
    end
    str = [str, '''%s''};'];
    str = sprintf(str, A.tex{:});
    pattern = '(\w*)(\\\_)';
    str = regexprep(str, pattern, '$1\\\\_');
    fprintf(fid,str);
    fprintf(fid,'\n\n');
    for v=1:vobs(A)
        fprintf(fid,'%s = [\n', A.name{v});
        fprintf(fid,'%15.8g\n',A.data(1:end-1,v));
        fprintf(fid,'%15.8g];\n\n',A.data(end,v));
    end
    fclose(fid);
  case 'mat'
    FREQ__ = frequency(A);
    INIT__ = date2string(firstdate(A));
    NAMES__ = A.name;
    TEX__ = A.tex;
    str = [];
    for v=1:vobs(A)
        str = [str, A.name{v} ' = A.data(:,' num2str(v) ');' ];
    end
    eval(str);
    currentdirectorycontent = dir();
    if ismember([basename, '.mat'],{currentdirectorycontent.name})
        copyfile([basename, '.mat'],[basename, '.old.mat']);
    end
    save([basename '.mat'],'INIT__','FREQ__','NAMES__','TEX__',A.name{:});
  case 'csv'
    currentdirectorycontent = dir();
    if ismember([basename, '.csv'],{currentdirectorycontent.name})
        copyfile([basename, '.csv'],[basename, '.old.csv']);
    end
    fid = fopen([basename, '.csv'],'w');
    fprintf(fid,',%s', A.name{:});
    fprintf(fid,'\n');
    for t=1:nobs(A)
        str = sprintf(', %15.8g',A.data(t,:));
        fprintf(fid, '%s%s\n',date2string(A.dates(t)),str);
    end
    fclose(fid);
  case 'fame'
    fame.write([basename '.db'], A);
  otherwise
    error('Unknown format!')
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
%$    save(ts1,[],'csv');
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
%$    save(ts1,[],'m');
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
%$    save(ts1,[],'mat');
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
