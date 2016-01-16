FROM libfuzzer/base

MAINTAINER aizatsky@google.com

RUN cd /src && git clone --depth 1 http://llvm.org/git/llvm.git
RUN cd /src/llvm/tools && git clone --depth 1 http://llvm.org/git/clang.git
RUN cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/compiler-rt.git
RUN cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/libcxx.git
RUN cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/libcxxabi.git

ADD build_clang.sh /src/scripts/

ENV CC="/work/llvm/bin/clang"
ENV CXX="/work/llvm/bin/clang++"
ENV PATH="/work/llvm/bin:$PATH"
ENV LD="/work/llvm/bin/ld.gold"

VOLUME /src/llvm
