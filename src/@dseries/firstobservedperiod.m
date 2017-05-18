function d = firstobservedperiod(o) % --*-- Unitary tests --*--

% Returns the first period where all the variables are observed (first period without NaNs).
%
% INPUTS
% - o [dseries]    with N variables and T periods.
%
% OUTPUTS
% - b [dates]      First period where the N variables are observed (without NaNs).

% Copyright (C) 2016-2017 Dynare Team
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

b = ~isnan(o);
c = find(prod(b, 2));
if isempty(c)
    error('No overlapping non-NaN data points found in dseries.');
end
d = firstdate(o)+(c(1)-1);

%@test:1
%$ try
%$     ts = dseries([NaN, NaN; NaN, 1; 2, 2; 3, 3; 4, NaN; 5, 5]);
%$     dd = ts.firstobservedperiod();
%$     t(1) = true;
%$ catch
%$     t(1) = false;
%$ end
%$
%$ if t(1)
%$     t(2) = isequal(dd, dates('3Y'));
%$ end
%$
%$ T = all(t);
%@eof:1

%@test:2
%$ try
%$     ts = dseries([0, 0; NaN, 1; 2, 2; 3, 3; 4, NaN; 5, 5]);
%$     dd = ts.firstobservedperiod();
%$     t(1) = true;
%$ catch
%$     t(1) = false;
%$ end
%$
%$ if t(1)
%$     t(2) = isequal(dd, dates('1Y'));
%$ end
%$
%$ T = all(t);
%@eof:2
