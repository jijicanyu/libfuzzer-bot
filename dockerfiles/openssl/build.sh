##!/bin/bash -eu
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

cd openssl
./config $CFLAGS
make -j

files=$(find ./fuzz/ -name "*.c")
FUZZERS=()

find . -name "*.a"

for F in $files; do
  fuzzer=$(basename $F .c)
  FUZZERS+=("$fuzzer")

  $CC $CFLAGS \
    -o /out/openssl_${fuzzer}_fuzzer /work/libfuzzer/*.o  $F \
    -nodefaultlibs -Wl,-Bdynamic -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc -lgcc_s -lgcc \
    -Wl,-Bstatic -lc++ -lc++abi \
    -I./include -L. -lssl -lcrypto -I/work/libfuzzer/
done
