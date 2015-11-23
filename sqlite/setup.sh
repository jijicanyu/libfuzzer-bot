#!/bin/bash
# Copyright 2015 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
sudo apt-get update && sudo apt-get install git subversion g++ cmake ninja-build apache2 screen fossil tclsh tcl-dev -y
git clone https://github.com/google/libfuzzer-bot.git
svn co http://llvm.org/svn/llvm-project/llvm/trunk/lib/Fuzzer
wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
