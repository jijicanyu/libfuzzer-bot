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

set -x -e

. /work/llvm/env

cd libarchive
/bin/sh build/autogen.sh
./configure
make AM_DEFAULT_VERBOSITY=1 DEV_CFLAGS="-Wextra -Wunused -Wshadow -Wmissing-prototypes -Wcast-qual -g" -j

$CXX $CXXFLAGS -std=c++11 /workspace/libfuzzer-bot/dockerfiles/libarchive/libarchive_fuzzer.cc \
  /work/libfuzzer/*.o -Ilibarchive ./.libs/libarchive.a \
   -nodefaultlibs -Wl,-Bdynamic -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc \
   -Wl,-Bstatic -lc++ -lc++abi \
   -o /out/libarchive_fuzzer
