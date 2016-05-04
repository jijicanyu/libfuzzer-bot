#!/bin/bash
set -e

. /work/llvm/env

./autogen.sh
./configure
make

$CXX $CXXFLAGS -std=c++11 ./src/tools/ftfuzzer/ftfuzzer.cc \
   -nodefaultlibs -Wl,-Bdynamic -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc -lgcc_s -lgcc \
   -Wl,-Bstatic -lc++ -lc++abi \
  ./objs/*.o /work/libfuzzer/*.o \
  -larchive -I./include -I. ./objs/.libs/libfreetype.a  \
   -o /out/freetype2_fuzzer
