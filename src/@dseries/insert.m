function o = insert(o, p, id) % --*-- Unitary tests --*--

% Adds a variable in a dseries object.
%
% INPUTS
% - o    [dseries]
% - p    [dseries]
% - id   [integer]   vector of indices.
%
% OUTPUTS
% - o    [dseries]

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

[n, message] = common_strings_in_cell_arrays(o.name, p.name);

if n
    if isempty(inputname(1))
        error(['dseries::insert: Variable(s) ' message ' already exist in dseries object!'])
    else
        error(['dseries::insert: Variable(s) ' message ' already exist in ''' inputname(1) '''!'])
    end
end

if ~isequal(frequency(o),frequency(p))
    if isempty(inputname(1))
        error(['dseries::insert: dseries objects must have common frequencies!'])
    else
        error(['dseries::insert: ''' inputname(1) ''' and ''' inputname(2) ''' dseries objects must have common frequencies!'])
    end
end

% Keep the second input argument constant.
p = copy(p);

[o, p] = align(o, p);

n = length(id);

if n>1
    [id, jd] = sort(id);
    p.data = p.data(:,jd);
    p.name = p.name(jd);
    p.tex = p.tex(jd);
    p.ops = p.ops(jd);
end

for i=1:n
    o.data = insert_column_vector_in_a_matrix(o.data, p.data(:,i),id(i));
    o.name = insert_object_in_a_one_dimensional_cell_array(o.name, p.name{i}, id(i));
    o.tex = insert_object_in_a_one_dimensional_cell_array(o.tex, p.tex{i}, id(i));
    o.ops = insert_object_in_a_one_dimensional_cell_array(o.ops, p.ops{i}, id(i));
    id = id+1;
end

%@test:1
%$ % Define a datasets.
%$ A = rand(10,3); B = rand(5,2);
%$
%$ % Define names.
%$ A_name = {'A1'; 'A2';'A3'};
%$ B_name = {'B1'; 'B2'};
%$
%$ % Define initial dates.
%$ A_init = '1950Q1';
%$ B_init = '1950Q3';
%$
%$ % Instantiate two dseries objects.
%$ ts1 = dseries(A, A_init, A_name,[]);
%$ ts2 = dseries(B, B_init, B_name,[]);
%$
%$ try
%$    ts1 = insert(ts1,ts2,[1,2]);
%$    t(1) = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if length(t)>1
%$    t(2) = dassert(ts1.vobs,{'B1';'A1';'B2';'A3'});
%$    t(3) = dassert(ts1.nobs,10);
%$    eB = [NaN(2,2); B; NaN(3,2)];
%$    t(4) = dassert(ts1.data,[eB(:,1), A(:,1), eB(:,2), A(:,2:3)], 1e-15);
%$ end
%$ T = all(t);
%@eof:1

%@test:2
%$ % Define a datasets.
%$ A = rand(10,3); B = rand(5,2);
%$
%$ % Define names.
%$ A_name = {'A1'; 'A2';'A3'};
%$ B_name = {'B1'; 'B2'};
%$
%$ % Define initial dates.
%$ A_init = '1950Q1';
%$ B_init = '1950Q3';
%$
%$ % Instantiate two dseries objects.
%$ ts1 = dseries(A, A_init, A_name,[]);
%$ ts2 = dseries(B, B_init, B_name,[]);
%$
%$ try
%$    ts1.insert(ts2,[1,2]);
%$    t(1) = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if length(t)>1
%$    t(2) = dassert(ts1.vobs,{'B1';'A1';'B2';'A3'});
%$    t(3) = dassert(ts1.nobs,10);
%$    eB = [NaN(2,2); B; NaN(3,2)];
%$    t(4) = dassert(ts1.data,[eB(:,1), A(:,1), eB(:,2), A(:,2:3)], 1e-15);
%$    t(5) = dassert(ts2.data, B);
%$ end
%$ T = all(t);
%@eof:2