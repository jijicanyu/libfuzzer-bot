#!/bin/bash
# Copyright 2015 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
export PATH="$HOME/llvm-inst/bin:$PATH"
NAME=$1 # E.g. asan
SAN=$2  # E.g. -fsanitize=address
COV=$3  # E.g. -fsanitize-coverage=edge,8bit-counters
(
rm -rf $NAME
cp -rf sqlite $NAME
cd $NAME
./configure
make -j
)
for f in Fuzzer/*cpp; do clang++ -std=c++11 -c $f -IFuzzer & done
wait
ar ruv libFuzzer.a Fuzzer*.o
rm -f Fuzzer*.o
clang   -g -fno-omit-frame-pointer -I ${NAME}                 -O1 $SAN $COV -c $NAME/sqlite3.c                      -o sqlite3_$NAME.o
clang   -g -fno-omit-frame-pointer -I ${NAME} -DSQLITE_DEBUG  -O2 $SAN $COV -c libfuzzer-bot/sqlite/sqlite_fuzzer.c -o sqlite_fuzzer_$NAME.o
clang++  -o sqlite_${NAME}_fuzzer $SAN $COV sqlite_fuzzer_$NAME.o sqlite3_$NAME.o libFuzzer.a
