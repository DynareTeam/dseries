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

% Initialize the dseries module
try
    initialize_dseries_toolbox;
catch
    unit_tests_root = strrep(which('runalltests'),'runalltests.m','');
    addpath([unit_tests_root '../src']);
    initialize_dseries_toolbox;
end

warning off

if isoctave
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

delete('data_ca1_csv.csv', 'dynare_series.m', 'dynare_series.mat', 'dynare_series.m.csv', 'dynare_series.old.csv', 'dynare_series.old.mat')