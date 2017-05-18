function a = isglobalinbase(var)

% Returns true iff ```var``` is a global variable in the main workspace.
%
% INPUTS
% - var [any]
%
% OUTPUTS
% - a   [bool]

% Copyright (C) 2013-2015 Dynare Team
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

tmp = whos('global');
if isempty(strmatch(var,{tmp.name}))
    a = 0;
else
    a = 1;
end