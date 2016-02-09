FROM libfuzzer/base-fuzzer

MAINTAINER aizatsky@google.com

RUN apt-get install -y liblzma-dev
RUN cd /src && git clone git://git.gnome.org/libxml2
ADD libxml2_fuzzer.cc /src/libxml2/
VOLUME /src/libxml2

ENV FUZZERS "/work/libxml2/libxml2_fuzzer"
ADD build.sh /src/scripts/
ADD xml.dict /src/libxml2/
ENV FUZZER_DICTIONARY "/src/libxml2/xml.dict"
