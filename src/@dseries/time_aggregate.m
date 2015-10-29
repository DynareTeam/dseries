function us = time_aggregate(ts, new_freq, end_or_mean) % --*-- Unitary tests --*--

%@info:
%! @deftypefn {Function File} {@var{us} =} time_aggregate (@var{ts}, @var{new_freq})
%! @anchor{time_aggregate}
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
if old_freq < new_freq
  error(['the new frequency ' int2str(new_freq) ' should be less than the current frequency ' int2str(old_freq)]);
end;
if mod(old_freq, new_freq)
  error(['the current frequency ' int(old_freq) ' should be a multiple of the new frequency ' int(old_freq)]);
end;
freq_reduction = old_freq / new_freq;
if end_or_mean
  data = reshape([NaN(ts.dates(1).time(2)-1,1) ; ts.data; NaN(freq_reduction-ts.dates(end).time(2),1)], freq_reduction, round(nobs / freq_reduction));
  data = data(freq_reduction, :)';
else 
  data = nanmean(reshape([NaN(ts.dates(1).time(2)-1,1) ; ts.data; NaN(freq_reduction-ts.dates(end).time(2),1)], freq_reduction, round(nobs / freq_reduction)))';
end;
switch new_freq
  case 1
      us = dseries(data, dates([int2str(ts.dates(1).time(1)) 'Y']):dates([int2str(ts.dates(end).time(1)) 'Y']), ts.name);
  case 4
	  us = dseries(data, dates([int2str(ts.dates(1).time(1)) 'Q' int2str(ceil(ts.dates(1).time(2)/freq_reduction))]):dates([int2str(ts.dates(end).time(1)) 'Q' int2str(ceil(ts.dates(end).time(2)/freq_reduction))]), ts.name);
  case 12
	  us = dseries(data, dates([int2str(ts.dates(1).time(1)) 'M' int2str(ceil(ts.dates(1).time(2)/freq_reduction))]):dates([int2str(ts.dates(end).time(1)) 'M' int2str(ceil(ts.dates(end).time(2)/freq_reduction))]), ts.name);
  case 52
      error('dseries::time_aggregate: I do not know yet how to compute aggregates from weekly data!')
  otherwise
    error(['dseries::time_aggregate: object ' inputname(1) ' has unknown frequency']);
end

%@test:1
%$ t = zeros(2,1);
%$
%$ try
%$     data = (1:24)';
%$     ts = dseries(data,'1950M1');
%$     ts = ts.time_aggregate(4,1);
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     DATA = 3 * (1:8)';
%$     t(2) = dassert(ts.data,DATA,1e-15);
%$ end
%$
%$ T = all(t);
%@eof:1

%@test:2
%$ t = zeros(2,1);
%$
%$ try
%$     data = (1:24)';
%$     ts = dseries(data,'1950M1');
%$     ts = ts.time_aggregate(12,1);
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     DATA = 12 * (1:2)';
%$     t(2) = dassert(ts.data,DATA,1e-15);
%$ end
%$
%$ T = all(t);
%@eof:1


%@test:3
%$ t = zeros(2,1);
%$
%$ try
%$     data = (1:24)';
%$     ts = dseries(data,'1950M1');
%$     ts = ts.time_aggregate(12,0);
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     DATA = (2:3:23)';
%$     t(2) = dassert(ts.data,DATA,1e-15);
%$ end
%$
%$ T = all(t);
%@eof:1
