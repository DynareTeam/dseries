function x13_binary = select_x13_binary()

% Copyright (C) 2017 Dynare Team
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

dseries_src_root = strrep(which('initialize_dseries_toolbox'),'initialize_dseries_toolbox.m','');
dseries_x13_root = sprintf('%s%s%s%s%s%s%s', dseries_src_root, '..', filesep(), 'externals', filesep(), 'x13', filesep());

if ismac()
    x13_binary = sprintf('%s%s%s', dseries_x13_root, 'osx', filesep());
    if is64bit()
        x13_binary = sprintf('%s%s%s%s', x13_binary, '64', filesep(), 'x13');
    else
        x13_binary = sprintf('%s%s%s%s', x13_binary, '32', filesep(), 'x13');
    end
elseif isunix()
    x13_binary = sprintf('%s%s%s', dseries_x13_root, 'linux', filesep());
    if is64bit()
        x13_binary = sprintf('%s%s%s%s', x13_binary, '64', filesep(), 'x13');
    else
        x13_binary = sprintf('%s%s%s%s', x13_binary, '32', filesep(), 'x13');
    end
elseif ispc()
    x13_binary = sprintf('%s%s%s', dseries_x13_root, 'windows', filesep());
    if is64bit()
        x13_binary = sprintf('%s%s%s%s', x13_binary, '64', filesep(), 'x13.exe');
    else
        x13_binary = sprintf('%s%s%s%s', x13_binary, '32', filesep(), 'x13.exe');
    end
else
    error('X13 binary is not available for this plateform')
end