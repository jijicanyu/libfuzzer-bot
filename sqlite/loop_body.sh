#!/bin/bash
# Copyright 2015 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
P=$(cd $(dirname $0) && pwd)
export PATH="$HOME/llvm-inst/bin:$PATH"
COMMON=$P/../common

MAX_LEN=10000
MAX_TOTAL_TIME=3600
BUCKET=gs://sql-fuzzing-corpora
CORPUS=CORPORA/C1
ARTIFACTS=CORPORA/ARTIFACTS
BUILD_SH=$P/build.sh

SAN=-fsanitize=bool
COV=-fsanitize-coverage=edge
USE_COUNTERS=0
# LIBFUZZER_EXTRA_FLAGS=-drill=1

TARGET_NAME=sqlite

update_trunk() {
  if [ -d sqlite ]; then
    (cd sqlite && fossil update)
  else
    (
    rm -rf sqlite
    mkdir sqlite
    cd sqlite
    fossil clone https://www.sqlite.org/src sqlite.fossil
    fossil open sqlite.fossil trunk
    )
  fi
}

DRY_RUN=0

source $COMMON/loop_body.sh
