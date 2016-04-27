FROM jenkinsci/jnlp-slave

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y build-essential make cmake ninja-build autoconf automake autotools-dev libtool coreutils pkg-config git subversion zip

# Checkout & build llvm+clang+deps
# -DLIBCXX_ENABLE_SHARED=OFF  -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON
RUN mkdir /src /work
RUN cd /src && git clone --depth 1 http://llvm.org/git/llvm.git
RUN cd /src/llvm/tools && git clone --depth 1 http://llvm.org/git/clang.git
RUN cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/compiler-rt.git
RUN cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/libcxx.git
RUN cd /src/llvm/projects && git clone --depth 1 http://llvm.org/git/libcxxabi.git
RUN mkdir -p /work/llvm && cd /work/llvm \
  && cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release /src/llvm \
  && ninja

# compile libfuzzer
RUN mkdir -p /work/libfuzzer && cd /work/libfuzzer \
  && cp /src/llvm/lib/Fuzzer/*.h . \
  && /work/llvm/bin/clang++ -g -std=c++11 -stdlib=libc++ -fsanitize=address -c /src/llvm/lib/Fuzzer/*.cpp -I.

RUN mkdir /var/secrets
VOLUME /var/secrets

# install gsutil to upload binaries
# RUN cd /root && \
#    wget --no-verbose "https://storage.googleapis.com/pub/gsutil.tar.gz" && \
#    tar -xf gsutil.tar.gz
# ENV GSUTIL="/root/gsutil/gsutil"

RUN cd /root \
  && wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip \
  && unzip google-cloud-sdk.zip \
  && rm google-cloud-sdk.zip \
  && ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true --bash-completion=false --additional-components kubectl gsutil

ENV PATH="/root/google-cloud-sdk/bin/:$PATH"
ENV GCLOUD="/root/google-cloud-sdk/bin/gcloud"

RUN gcloud config set --installation component_manager/disable_update_check true

ADD env /work/llvm
