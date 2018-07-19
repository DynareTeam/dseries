OCTAVE=octave-cli
MATLAB=`which matlab`

all: check-octave check-matlab

check-octave:
	@cd tests ;\
	$(OCTAVE) --no-init-file --silent --no-history --eval "runalltests(true)"

check-matlab:
	@$(MATLAB)  -nosplash -nodisplay -r "cd tests; runalltests; quit"

check-clean:
	rm -f tests/*_test_*.m tests/*.csv tests/*.xls tests/*.xlsx tests/*.mat tests/failed tests/datafile_for_test
