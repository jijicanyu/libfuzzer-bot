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

mkdir -p /work/nss

cp -u -r /src/nss/* /work/nss/

cd /work/nss/nss/
make BUILD_OPT=1 USE_64=1 NSS_DISABLE_GTESTS=1 CC="$CC $CFLAGS" CXX="$CXX $CXXFLAGS" LD="$CC $CFLAGS" ZDEFS_FLAG= nss_build_all

mkdir -p /work/nss/include

# install libraries to /usr/lib and includes to /work/nss/include
cd /work/nss/dist
cp Linux*/lib/*.so /usr/lib
cp Linux*/lib/{*.chk,libcrmf.a} /usr/lib
cp -rL Linux*/include/* /work/nss/include
cp -rL {public,private}/nss/* /work/nss/include

# -Iinclude -L.libs -lxml2 -llzma \
for fuzzer in $FUZZERS; do
  fuzzer_name=$(basename $fuzzer)
  $CXX $CXXFLAGS -std=c++11 /src/nss/$fuzzer_name.cc \
     -I/work/nss/include \
     -lnss3 -lnssutil3 -lnspr4 -lplc4 -lplds4 \
      $LIBFUZZER_OBJS \
     -o $fuzzer
done

export LD_LIBRARY_PATH=/work/nss/lib:$LD_LIBRARY_PATH

echo $(umask -S)
