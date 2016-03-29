#!/bin/bash
# Copyright 2015 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");

export PATH="$HOME/llvm-inst/bin:$PATH"

get_fresh_llvm() {
  if [ "$DRY_RUN" != "1" ]; then
    mkdir -p llvm-prebuild
    gsutil rsync gs://libfuzzer-bot-binaries/llvm-prebuild llvm-prebuild
    rm -rf llvm-inst
    tar xf llvm-prebuild/llvm-inst.tgz
  fi
}

mkindex() {
  sudo mv $1.log /var/www/html/$prefix-$1.log
  sudo rm /var/www/html/201*.html
  sudo mv $1.html /var/www/html/$1.html
  (cd /var/www/html/; sudo $P/../common/mkindex.sh index.html *log)
}

dump_coverage() {
  echo ===================================================================
  echo ==== FUNCTION-LEVEL COVERAGE: THESE FUNCTIONS ARE *NOT* COVERED ===
  echo ===================================================================
  sancov.py print *sancov  2> /dev/null |\
    sancov.py missing $1 2> /dev/null |\
    llvm-symbolizer -obj $1 -inlining=0 -functions=none |\
    grep /func/ |\
    sed "s#.*func/##g" |\
    sort --field-separator=: --key=1,1 --key=2n,2 --key=3n,3 | cat -n
}

# Make asan less memory-hungry, strip paths, intercept abort().
export ASAN_OPTIONS=quarantine_size_mb=10:strip_path_prefix=$HOME/:handle_abort=1:coverage=1:coverage_pcs=1:$ASAN_OPTIONS
J=$(grep CPU /proc/cpuinfo | wc -l )

DATE=$(date +%Y-%m-%d-%H-%M-%S)
L=$DATE.log
HTML=$DATE.html
echo =========== STARTING $L ==========================
echo =========== GET LLVM  &&  get_fresh_llvm
echo =========== PULL libFuzzer && (cd Fuzzer; svn up)
echo =========== UPDATE TRUNK   && update_trunk
echo =========== SYNC CORPORA and BUILD
mkdir -p $ARTIFACTS $CORPUS
# These go in parallel.
if [ "$DRY_RUN" != "1" ]; then
  (gsutil -m rsync -r $BUCKET/CORPORA CORPORA; gsutil -m rsync -r CORPORA $BUCKET/CORPORA) &
fi
$BUILD_SH san_cov $SAN $COV > san_cov_build.log 2>&1 &
wait

echo =========== FUZZING
rm -f *.sancov
./${TARGET_NAME}_san_cov_fuzzer \
  -max_len=$MAX_LEN $CORPUS  -artifact_prefix=$ARTIFACTS/ -jobs=$J \
  -workers=$J -max_total_time=$MAX_TOTAL_TIME -use_counters=$USE_COUNTERS $LIBFUZZER_EXTRA_FLAGS >> $L 2>&1
exit_code=$?
case $exit_code in
  0) prefix=pass
    ;;
  *) prefix=FAIL
    ;;
esac
echo =========== DUMP COVERAGE
sancov -strip_path_prefix /san_cov/ -not-covered-functions ./${TARGET_NAME}_san_cov_fuzzer *.sancov  | grep -v /usr/include/c++/ > notcov
sancov  -html-report  -strip_path_prefix=$HOME/san_cov/ ./${TARGET_NAME}_san_cov_fuzzer *.sancov > $HTML
echo ================== NOT COVERED FUNCTIONS: >> $L
cat -n notcov >> $L
echo =========== UPDATE WEB PAGE
if [ "$DRY_RUN" != "1" ]; then
  mkindex $DATE
fi
echo =========== DONE
echo
echo
