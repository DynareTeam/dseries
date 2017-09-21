function checkoptioncompatibility(o)

% Checks for compatibility of options in different X13 commands.

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

if ~isempty(o.estimate.file)
    if ~isempty(o.arima.model)
        error('Options ARIMA.model and ESTIMATE.file not compatible!');
    elseif ~isempty(o.arima.ar)
        error('Options ARIMA.ar and ESTIMATE.file not compatible!');
    elseif ~isempty(o.arima.model)
        error('Options ARIMA.ma and ESTIMATE.file not compatible!');
    elseif ~isempty(o.regression.user)
        error('Options REGRESSION.user and ESTIMATE.file not compatible!');
    elseif ~isempty(o.regression.b)
        error('Options REGRESSION.b and ESTIMATE.file not compatible!');
    elseif ~isempty(o.regression.variables)
        error('Options REGRESSION.variables and ESTIMATE.file not compatible!');
    elseif ismember('automdl',o.commands)
        error('Command AUTOMDL not compatible with ESTIMATE.file option!');
    elseif ismember('pickmdl',o.commands)
        error('Command PICKMDL not compatible with ESTIMATE.file option!');
    end    
end