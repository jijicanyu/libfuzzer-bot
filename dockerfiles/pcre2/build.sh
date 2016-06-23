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

cd /src/pcre2/
if [ ! -f configure ]
then
  ./autogen.sh
fi

# pcre2 doesn't build outside of source directory
./configure
make -j 16

mkdir -p /work/pcre2
cd /work/pcre2
$CXX $CXXFLAGS /src/pcre2/pcre2_fuzzer.cc /work/libfuzzer/*.o -o pcre2_fuzzer \
  -std=c++11 -I/src/pcre2/src
