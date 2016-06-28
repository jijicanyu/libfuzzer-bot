#!/bin/bash -eu
#
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

set -e

. /work/llvm/env

cd libxml2

./autogen.sh
echo =========== MAKE
make -j 16

$CXX $CXXFLAGS -std=c++11 /workspace/libfuzzer-bot/dockerfiles/libxml2/libxml2_read_memory_fuzzer.cc \
  /work/libfuzzer/*.o -Iinclude ./.libs/libxml2.a \
  -nodefaultlibs -Wl,-Bdynamic -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc \
  -Wl,-Bstatic -lc++ -lc++abi -llzma \
  -o /out/libxml2_read_memory_fuzzer

cp /workspace/libfuzzer-bot/dockerfiles/libxml2/*.{dict,options} /out
chmod +r /out/*
