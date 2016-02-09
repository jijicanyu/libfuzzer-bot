FROM ubuntu:15.10

MAINTAINER aizatsky@google.com

RUN apt-get update
RUN apt-get install -y build-essential python2.7 golang
RUN apt-get install -y cmake ninja-build autoconf automake autotools-dev libtool coreutils pkg-config gdb
RUN apt-get install -y git subversion vim

RUN mkdir -p /src
RUN mkdir -p /src/scripts

RUN mkdir -p /work
VOLUME /work
