function us = time_disaggregate(ts, new_freq, constant_or_interpol) % --*-- Unitary tests --*--

%@info:
%! @deftypefn {Function File} {@var{us} =} time_disaggregate (@var{ts}, @var{new_freq})
%! @anchor{time_disaggregate}
%! @sp 1
%! Aggregates dseries over differents frequencies.
%! @sp 2
%! @strong{Inputs}
%! @sp 1
%! @table @var
%! @item ts
%! Dynare time series object, instantiated by @ref{dseries}
%! @item new_freq
%! integer indicating the new frequency
%! @item end_or_mean
%! boolean true (1) for a "end of period" aggregation and false (0) for a
%!         "mean" aggregation
%! @end table
%! @sp 2
%! @strong{Outputs}
%! @sp 1
%! @table @var
%! @item us
%! Dynare time series object with transformed data field.
%! @end table
%! @end deftypefn
%@eod:

% Copyright (C) 2012-2015 Dynare Team
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

nobs = rows(ts.data);
old_freq = frequency(ts);
if old_freq > new_freq
  error(['the new frequency ' int2str(new_freq) ' should be greater than the current frequency ' int2str(old_freq)]);
end;
if mod(new_freq, old_freq)
  error(['the current frequency ' int(old_freq) ' should be a multiple of the new frequency ' int(old_freq)]);
end;
freq_increase = new_freq / old_freq;
if constant_or_interpol
  data = vec(kron(ts.data, ones(freq_increase, 1))');
  first_date = 1;
else 
  data = ts.data;
  data1 = kron( (data(2:nobs) - data(1:nobs-1)) / freq_increase, ones(freq_increase - 1, 1)'); 
  data = cumsum([data(1:nobs-1) data1], 2)';
  data = vec(data);
  data = [data; ts.data(end)];
  first_date = freq_increase;
end;
switch new_freq
  case 1
      error('dseries::disaggregate: I do not know yet how to compute disaggregates to yearly data!')
  case 4
	  us = dseries(data, dates([int2str(ts.dates(1).time(1)) 'Q' int2str(ceil(ts.dates(1).time(2) * first_date))]):dates([int2str(ts.dates(end).time(1)) 'Q' int2str(ceil(ts.dates(end).time(2) * freq_increase))]), ts.name);
  case 12
	  us = dseries(data, dates([int2str(ts.dates(1).time(1)) 'M' int2str(ceil(ts.dates(1).time(2) * first_date))]):dates([int2str(ts.dates(end).time(1)) 'M' int2str(ceil(ts.dates(end).time(2)*freq_increase))]), ts.name);
  case 52
      us = dseries(data, dates([int2str(ts.dates(1).time(1)) 'W' int2str(ceil(ts.dates(1).time(2) * first_date))]):dates([int2str(ts.dates(end).time(1)) 'W' int2str(ceil(ts.dates(end).time(2)*freq_increase))]), ts.name);
  otherwise
    error(['dseries::disaggregate: object ' inputname(1) ' has unknown frequency']);
end

%@test:1
%$ t = zeros(2,1);
%$
%$ try
%$     data = 3 * (1:8)';
%$     ts = dseries(data,'1950Q1');
%$     ts = ts.time_aggregate(12,1);
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     DATA = (3:24)';
%$     t(2) = dassert(ts.data,DATA,1e-15);
%$ end
%$
%$ T = all(t);
%@eof:1

%@test:2
%$ t = zeros(2,1);
%$
%$ try
%$     data = 12 * (1:2)';
%$     ts = dseries(data,'1950Y');
%$     ts = ts.time_aggregate(12,1);
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     DATA = (12:24)';
%$     t(2) = dassert(ts.data,DATA,1e-15);
%$ end
%$
%$ T = all(t);
%@eof:1


%@test:3
%$ t = zeros(2,1);
%$
%$ try
%$     data = (2:3:23)';
%$     ts = dseries(data,'1950Y');
%$     ts = ts.time_aggregate(12,0);
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     DATA = (12:24)';
%$     t(2) = dassert(ts.data,DATA,1e-15);
%$ end
%$
%$ T = all(t);
%@eof:1
