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

% Add some subfolders to the path.
addpath([dseries_src_root '/read'])
addpath([dseries_src_root '/utilities/is'])
addpath([dseries_src_root '/utilities/str'])
addpath([dseries_src_root '/utilities/insert'])
addpath([dseries_src_root '/utilities/file'])
addpath([dseries_src_root '/utilities/from'])
addpath([dseries_src_root '/utilities/variables'])
addpath([dseries_src_root '/utilities/cumulate'])

% Add missing routines if dynare is not in the path
if ~exist('demean','file')
    addpath([dseries_src_root '/utilities/missing/demean'])
end

if ~exist('ndim','file')
    addpath([dseries_src_root '/utilities/missing/ndim'])
end

if ~exist('sample_hp_filter','file')
    addpath([dseries_src_root '/utilities/missing/sample_hp_filter'])
end

if ~exist('get_file_extension','file')
    addpath([dseries_src_root '/utilities/missing/get_file_extension'])
end

if isoctave && ~exist('user_has_octave_forge_package','file')
    addpath([dseries_src_root '/utilities/missing/user_has_octave_forge_package'])
end

% Add matlab-fame-io (fame connector toolbox) if available.
if exist([dseries_src_root '/modules/matlab-fame-io'])
    addpath([dseries_src_root '/modules/matlab-fame-io'])
    if exist([dseries_src_root '/modules/matlab-fame-io/locals.m'])
        initialize_fame_toolbox();
    else
        warning('matlab-fame-io submodule is not properly configured!')
    end
end