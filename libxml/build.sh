#!/bin/bash
# Copyright 2015 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
export PATH="$HOME/llvm-build/bin:$PATH"
NAME=$1 # E.g. asan
SAN=$2  # E.g. -fsanitize=address
COV=$3  # E.g. -fsanitize-coverage=edge,8bit-counters
(
rm -rf $NAME
cp -rf libxml2 $NAME
cd $NAME
./autogen.sh
CXX="clang++ $SAN $COV" CC="clang $SAN $COV" CCLD="clang++ $SAN $COV" ./configure
make -j
)
ln -sf $HOME/llvm/lib/Fuzzer .
for f in Fuzzer/*cpp; do clang++ -std=c++11 -c $f -IFuzzer & done
wait
clang++ -std=c++11  libfuzzer-bot/libxml/libxml_fuzzer.cc  $SAN $COV  -I $NAME/include $NAME/.libs/libxml2.a Fuzzer*.o -o libxml2_${NAME}_fuzzer  -lz
