#!/bin/bash
# Copyright 2015 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
P=$(cd $(dirname $0) && pwd)
COMMON=$P/../common
MAX_LEN=512
MAX_TOTAL_TIME=3600
BUCKET=gs://xml-fuzzing-corpora
CORPUS=CORPORA/C7
ARTIFACTS=CORPORA/ARTIFACTS
BUILD_SH=$P/build.sh
LIBFUZZER_EXTRA_FLAGS="-only_ascii=1 -timeout=300 -dict=libfuzzer-bot/libxml/xml.dict -drill=0"
ASAN_OPTIONS=detect_leaks=0
SAN=-fsanitize=address
COV=-fsanitize-coverage=edge,8bit-counters
USE_COUNTERS=1
TARGET_NAME=libxml2
update_trunk() {
  if [ -d libxml2 ]; then
    (cd libxml2 && git pull)
  else
    git clone git://git.gnome.org/libxml2 
  fi
}
DRY_RUN=0
source $COMMON/loop_body.sh
