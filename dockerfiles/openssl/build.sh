#!/bin/bash
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
