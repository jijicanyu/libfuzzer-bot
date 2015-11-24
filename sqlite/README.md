This page describes an [experimental fuzzer bot](http://104.197.183.249/) for [SQLite](https://www.sqlite.org/).

The bot uses [libFuzzer](http://llvm.org/docs/LibFuzzer.html) and
[AddressSanitizer](http://clang.llvm.org/docs/AddressSanitizer.html) to find existing
bugs in SQLite and possible new regressions.
Currently, the [target function](./sqlite_fuzzer.c) is *very* simple, we'll be extending it in future.

The test corpus is synthesised from the existing sqlite tests.
