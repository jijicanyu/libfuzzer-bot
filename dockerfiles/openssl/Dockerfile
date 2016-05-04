FROM libfuzzer/base-fuzzer

MAINTAINER aizatsky@google.com

RUN apt-get install -y autoconf libtool libarchive-dev 

ADD build.sh /src/scripts/
CMD /src/scripts/build.sh
