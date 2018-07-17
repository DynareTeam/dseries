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

opath = path();

system('rm -f failed');

% Check that the m-unit-tests module is available.

install_unit_test_toolbox = false;

try
    initialize_unit_tests_toolbox;
catch
    urlwrite('https://github.com/DynareTeam/m-unit-tests/archive/master.zip','master.zip');
    warning('off','MATLAB:MKDIR:DirectoryExists');
    mkdir('../externals');
    warning('on','MATLAB:MKDIR:DirectoryExists');
    unzip('master.zip','../externals');
    delete('master.zip');
    addpath([pwd() '/../externals/m-unit-tests-master/src']);
    initialize_unit_tests_toolbox;
    install_unit_test_toolbox = true;
end

% Get path to the current script
unit_tests_root = strrep(which('runalltests'),'runalltests.m','');

% Initialize the dseries module
try
    initialize_dseries_toolbox;
catch
    addpath([unit_tests_root '../src']);
    initialize_dseries_toolbox;
end

warning off

if isoctave()
    pkg install -forge io
    more off;
    addpath([unit_tests_root 'fake']);
end

tmp = dseries_src_root;
tmp = tmp(1:end-1); % Remove trailing slash.
report = run_unitary_tests_in_directory(tmp);

delete('*.log');

if install_unit_test_toolbox
    rmdir('../externals/m-unit-tests-master','s');
end

if any(~[report{:,3}])
    system('touch failed');
end

warning on
path(opath);