FROM jenkinsci/jnlp-slave

USER root

RUN apt-get update
RUN apt-get install -y build-essential make cmake ninja-build autoconf automake autotools-dev libtool coreutils pkg-config git subversion

RUN mkdir /src /work
RUN cd /src && git clone --depth 1 http://llvm.org/git/llvm.git
RUN cd /src/llvm/tools && git clone --depth 1 http://llvm.org/git/clang.git
RUN cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/compiler-rt.git
RUN cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/libcxx.git
RUN cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/libcxxabi.git
RUN mkdir -p /work/llvm && cd /work/llvm \
  && cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release /src/llvm \
  && ninja

ADD env /work/llvm/

# compile
RUN mkdir -p /work/libfuzzer && cd /work/libfuzzer \
  && cp /src/llvm/lib/Fuzzer/*.h . \
  && /work/llvm/bin/clang++ -std=c++11 -stdlib=libc++  -c /src/llvm/lib/Fuzzer/*.cpp -I.
