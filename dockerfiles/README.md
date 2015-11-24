# Dockerized LibFuzzer Tests

This folder contains files used to build self-contained LibFuzzer tests
for a variety of open source projects. The goal is to provide 0-friction
environment to run tests, create new fuzzers and experiment with LibFuzzer
development.


## Prerequisites

The only requirement is to have docker running on the system.
Check [https://docs.docker.com/] for docker installation guide.

## Available Images
* libfuzzer/boringssl
* libfuzzer/freetype2
* libfuzzer/pcre2

## Running Fuzzers
*Operations with all tests are similar. Boringssl would be used for demonstration.*

Create a directory to hold compilation/run artifacts:
```
mdkir ~/tmp/work
```

To compile everything and run library tests do:
```
docker run -ti -v ~/tmp/work:/work libfuzzer/boringssl
```

This will:
- (`-ti`) attach terminal to running process
- (`-v`) mount `~/tmp/work` host directory to container's `/work`
- (`libfuzzer/boringssl`) use this image to start new container.

### Benchmarking Fuzzers

Add `benchmark` command to docker run:

```
docker run -ti -v ~/tmp/work:/work libfuzzer/boringssl benchmark
```

This will run multiple fuzzers in parallel and will produce PDF
report. By specifying different `FUZZER_OPTIONS` (see next section)
or making changes to source code you can compare fuzzers performance.

### Environment variables
A set of environment variables controls test compilation and execution mode.
Environment variables could be specified using `-e` docker option:

```
docker run -e SANITIZER_OPTIONS="-fsanitize=memory"
```

Variable    | Default | Description
----------- | ------- | -----
SANITIZER_OPTIONS | -fsanitize=address | Compiler's sanitizer options.
COVERAGE_OPTIONS | -fsanitize-coverage=edge,indirect-calls,8bit-counters,trace-cmp | Compiler's coverage options.
FUZZER_OPTIONS | -use_traces=1 -max_total_time=120 | Fuzzer's running options
ASAN_OPTIONS | quarantine_size_mb=10:symbolize=1:abort_on_error=1:handle_abort=1 | Asan's running options

### Using custom LLVM sources
When working on LLVM/LibFuzzer, you can mount your local source tree into container's `/src/llvm`. It would be used instead of image sources.

```
docker run -v ~/src/lvvm:/src/llvm libfuzzer/boringssl
```

### Using custom library sources
While working on a library itself, you can mount your local source tree into
containers `/src/<library_name>`:

```
docker run -v ~/src/boringssl:/src/boringssl libfuzzer/boringssl
```

## Adding New Projects
To create image for a new project, follow these instructions: [base-fuzzer/README.md]
