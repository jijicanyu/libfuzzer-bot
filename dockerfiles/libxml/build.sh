#!/bin/bash
set -e

cd /src/libxml2/
if [ ! -f configure ]
then
  ./autogen.sh
fi

echo =========== MAKE
make -j 16

$CXX $CXXFLAGS -std=c++11 libxml2_fuzzer.cc \
  -Iinclude -L.libs -lxml2 -llzma $LIBFUZZER_OBJS \
   -o /work/libxml2/libxml2_fuzzer
