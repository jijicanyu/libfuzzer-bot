#!/bin/bash
# Copyright 2015 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
P=$(cd $(dirname $0) && pwd)
export PATH="$HOME/llvm-inst/bin:$PATH"
COMMON=$P/../common

MAX_LEN=21480
MAX_TOTAL_TIME=7200
USE_COUNTERS=0
BUCKET=gs://freetype-fuzzing-corpora
CORPUS=CORPORA/C2
ARTIFACTS=CORPORA/ARTIFACTS
BUILD_SH=$P/build.sh

SAN=-fsanitize=address
COV=-fsanitize-coverage=edge,8bit-counters,trace-cmp
LIBFUZZER_EXTRA_FLAGS="-use_value_profile=1 -rss_limit_mb=3200"

TARGET_NAME=freetype2

update_trunk() {
  if [ -d freetype2 ]; then
    (cd freetype2 && git pull)
  else
    (
    rm -rf freetype2
    git clone git://git.sv.nongnu.org/freetype/freetype2.git
    )
  fi
}

source $COMMON/loop_body.sh
