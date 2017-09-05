function q = merge(o, p) % --*-- Unitary tests --*--

% Merge method for dseries objects.
%
% INPUTS
% - o  [dseries]
% - p  [dseries]
%
% OUTPUTS
% - q  [dseries]
%
% REMARKS
% If dseries objects o and p have common variables, the variables in p take precedence.

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

if ~isdseries(p)
    error('dseries::merge: Both inputs must be dseries objects!')
end

if ~isequal(frequency(o), frequency(p))
    if isempty(inputname(1))
        error(['dseries::merge: Cannot merge dseries objects (frequencies are different)!'])
    else
        error(['dseries::merge: Cannot merge ' inputname(1) ' and ' inputname(2) ' (frequencies are different)!'])
    end
end

q = dseries();
[q.name, IBC, junk] = unique([o.name; p.name], 'last');
tex = [o.tex; p.tex];
q.tex = tex(IBC);
ops = [o.ops; p.ops];
q.ops = ops(IBC);

if nobs(o) == 0
    q = copy(p);
elseif nobs(p) == 0
    q = copy(o);
elseif firstdate(o) >= firstdate(p)
    diff = firstdate(o) - firstdate(p);
    q_nobs = max(nobs(o) + diff, nobs(p));
    q.data = NaN(q_nobs, vobs(q));
    Z1 = [NaN(diff, vobs(o));o.data];
    if nobs(q) > nobs(o) + diff
        Z1 = [Z1; NaN(nobs(q)-(nobs(o) + diff), vobs(o))];
    end;
    Z2 = p.data;
    if nobs(q) > nobs(p)
        Z2 = [Z2; NaN(nobs(q) - nobs(p), vobs(p))];
    end;
    Z = [Z1 Z2];
    q.data = Z(:,IBC);
    q_init = firstdate(p);
else
    diff = firstdate(p) - firstdate(o);
    q_nobs = max(nobs(p) + diff, nobs(o));
    q.data = NaN(q_nobs, vobs(q));
    Z1 = [NaN(diff, vobs(p)); p.data];
    if nobs(q) > nobs(p) + diff
        Z1 = [Z1; NaN(nobs(q)-(nobs(p) + diff), vobs(p))];
    end
    Z2 = o.data;
    if nobs(q) > nobs(o)
        Z2 = [Z2; NaN(nobs(q) - nobs(o), vobs(o))];
    end;
    Z = [Z2 Z1];
    q.data = Z(:,IBC);
    q_init = firstdate(o);
end

q.dates = q_init:q_init+(nobs(q)-1);

%@test:1
%$ % Define a datasets.
%$ A = rand(10,2); B = randn(10,1);
%$
%$ % Define names
%$ A_name = {'A1';'A2'}; B_name = {'A1'};
%$
%$ t = zeros(4,1);
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts2 = dseries(B,[],B_name,[]);
%$    ts3 = merge(ts1,ts2);
%$    t(1) = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if length(t)>1
%$    t(2) = dassert(ts3.vobs,2);
%$    t(3) = dassert(ts3.nobs,10);
%$    t(4) = dassert(ts3.data,[B, A(:,2)],1e-15);
%$ end
%$ T = all(t);
%@eof:1

%@test:2
%$ % Define a datasets.
%$ A = rand(10,2); B = randn(10,1);
%$
%$ % Define names
%$ A_name = {'A1';'A2'}; B_name = {'B1'};
%$
%$ t = zeros(4,1);
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts2 = dseries(B,[],B_name,[]);
%$    ts3 = merge(ts1,ts2);
%$    t(1) = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if length(t)>1
%$    t(2) = dassert(ts3.vobs,3);
%$    t(3) = dassert(ts3.nobs,10);
%$    t(4) = dassert(ts3.data,[A, B],1e-15);
%$ end
%$ T = all(t);
%@eof:2
