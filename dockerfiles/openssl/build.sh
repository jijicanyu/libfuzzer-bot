#!/bin/bash
set -x -e

. /work/llvm/env

cd openssl
./config $CXXFLAGS
make -j

files=$(find ./fuzz/ -name "*.c" ! -name "reproduce.c")
FUZZERS=()

find . -name "*.a"

for F in $files; do
  fuzzer=$(basename $F .c)
  FUZZERS+=("$fuzzer")

  $CXX  $CXXFLAGS \
    -o /out/openssl_${fuzzer}_fuzzer /work/libfuzzer/*.o \
    -nodefaultlibs -Wl,-Bdynamic -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc -lgcc_s -lgcc \
    -Wl,-Bstatic -lc++ -lc++abi \
    $F \
    -I./include -L. -lssl -lcrypto -I/work/libfuzzer/
done

echo "Fuzzers:  ${FUZZERS[*]}"

# $CXX $CXXFLAGS -std=c++11 ./src/tools/ftfuzzer/ftfuzzer.cc \
#    -nodefaultlibs -Wl,-Bdynamic -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc -lgcc_s -lgcc \
#    -Wl,-Bstatic -lc++ -lc++abi \
#   ./objs/*.o /work/libfuzzer/*.o \
#   -larchive -I./include -I. ./objs/.libs/libfreetype.a  \
#    -o /out/freetype2_fuzzer

# -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc -lgcc_s -lgcc
# -lc++ -lm --no-as-needed -lpthread -lrt -lm -ldl -lgcc_s -lgcc -lc -lgcc_s -lgcc
