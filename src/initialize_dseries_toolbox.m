% Copyright (C) 2015-2017 Dynare Team
%
% This code is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare dseries submodule is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

% Check that the dates module is available.
try
    initialize_dates_toolbox;
catch
    urlwrite('https://github.com/DynareTeam/dates/archive/master.zip','master.zip');
    warning('off','MATLAB:MKDIR:DirectoryExists')
    mkdir('../externals')
    warning('on','MATLAB:MKDIR:DirectoryExists')
    unzip('master.zip','../externals')
    delete('master.zip')
    addpath([pwd() '/../externals/dates-master/src'])
    initialize_dates_toolbox;
end

% Get the path to the dseries toolbox.
dseries_src_root = strrep(which('initialize_dseries_toolbox'),'initialize_dseries_toolbox.m','');

% Set the subfolders to be added in the path.
p = {'/read'; ...
     '/utilities/is'; ...
     '/utilities/str'; ...
     '/utilities/x13'; ...
     '/utilities/insert'; ...
     '/utilities/file'; ...
     '/utilities/from'; ...
     '/utilities/print'; ...
     '/utilities/variables'; ...
     '/utilities/cumulate'; ...
     '/utilities/struct'};

% Add missing routines if dynare is not in the path
if ~exist('demean','file')
    p{end+1} = '/utilities/missing/demean';
end

if ~exist('ndim','file')
    p{end+1} = '/utilities/missing/ndim';
end

if ~exist('sample_hp_filter','file')
    p{end+1} = '/utilities/missing/sample_hp_filter';
end

if ~exist('get_file_extension','file')
    p{end+1} = '/utilities/missing/get_file_extension';
end

if isoctave && ~exist('user_has_octave_forge_package','file')
    p{end+1} = '/utilities/missing/user_has_octave_forge_package';
end

if ~exist('get_cells_id','file')
    p{end+1} = '/utilities/missing/get_cells_id';
end

if ~exist('randomstring','file')
    p{end+1} = '/utilities/missing/randomstring';
end

if ~exist('one_sided_hp_filter','file')
    p{end+1} = '/utilities/missing/one_sided_hp_filter';
end

% Install X13 binaries
opath = pwd();
try
    cd([dseries_src_root '/../externals/x13'])
    installx13();
catch
    warning('X13 is not available!')
    p(strmatch('/utilities/x13', p, 'exact')) = [];
end
cd(opath);

% Set path
P = cellfun(@(c)[dseries_src_root(1:end-1) c], p, 'uni', false);
addpath(P{:});