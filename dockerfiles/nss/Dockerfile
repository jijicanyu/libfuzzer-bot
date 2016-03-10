FROM libfuzzer/base-fuzzer

MAINTAINER aizatsky@google.com

ENV PROJECT "nss"

RUN apt-get install -y mercurial zlib1g-dev
RUN mkdir -p /src/nss
RUN cd /src/nss && hg clone https://hg.mozilla.org/projects/nspr
RUN cd /src/nss && hg clone https://hg.mozilla.org/projects/nss
VOLUME /src/nss

ENV FUZZERS "/work/nss/asn1_bitstring_fuzzer"
ADD asn1_bitstring_fuzzer.cc /src/nss/

ADD build.sh /src/scripts/
