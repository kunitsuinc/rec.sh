#!/usr/bin/env bash
set -E -e -o pipefail -u

# benchmark sample on commit 'init'
# -------------------------------------------------------------------------------------------------
# $ docker run -it --rm -v "$(pwd -P)":"$(pwd -P)" -w "$(pwd -P)" --env-file <(env) ubuntu:20.04 ./benchmark.sh
# {"timestamp":"2021-11-28T02:40:48+00:00","severity":"INFO","caller":"./benchmark.sh","message":"$ sh -c 'uname -s -v -m; grep model.name /proc/cpuinfo | sort -u'"}
# Linux #1 SMP Sat Jul 3 21:51:47 UTC 2021 x86_64
# model name      : Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
#
# BenchmarkLogshDebug_001
# LogshDebug(message only) * 100
# real    0m0.596s
# user    0m0.397s
# sys     0m0.556s
#
# BenchmarkLogshDebug_002
# LogshDebug(with 1 field) * 100
# real    0m0.878s
# user    0m0.608s
# sys     0m0.876s
# -------------------------------------------------------------------------------------------------
# $ ./benchmark.sh
# {"timestamp":"2021-11-28T02:39:38+00:00","severity":"INFO","caller":"./benchmark.sh","message":"$ sh -c 'uname -s -v -m; sysctl -a machdep.cpu.brand_string'"}
# Darwin Darwin Kernel Version 20.6.0: Mon Aug 30 06:12:21 PDT 2021; root:xnu-7195.141.6~3/RELEASE_X86_64 x86_64
# machdep.cpu.brand_string: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
#
# BenchmarkLogshDebug_001
# LogshDebug(message only) * 100
# real    0m3.694s
# user    0m0.702s
# sys     0m2.035s
#
# BenchmarkLogshDebug_002
# LogshDebug(with 1 field) * 100
# real    0m5.973s
# user    0m1.154s
# sys     0m3.422s
# -------------------------------------------------------------------------------------------------
# $ ./benchmark.sh
# 2022-04-09T07:30:54+00:00 [     INFO] $ sh -c 'uname -s -v -m; sysctl -a machdep.cpu.brand_string'
# Darwin Darwin Kernel Version 21.4.0: Fri Mar 18 00:45:05 PDT 2022; root:xnu-8020.101.4~15/RELEASE_X86_64 x86_64
# machdep.cpu.brand_string: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
#
# BenchmarkLogshDebugJSON_001
# LogshDebugJSON(message only) * 100
# real	0m1.890s
# user	0m0.730s
# sys	0m1.639s
#
# BenchmarkLogshDebugJSON_002
# LogshDebugJSON(with 1 field) * 100
# real	0m3.108s
# user	0m1.219s
# sys	0m2.855s
# -------------------------------------------------------------------------------------------------
# $ ./benchmark.sh
# 2023-08-26T19:23:55+00:00 [     INFO] $ sh -c 'uname -s -v -m; sysctl -a machdep.cpu.brand_string'
# Darwin Darwin Kernel Version 22.6.0: Wed Jul  5 22:22:05 PDT 2023; root:xnu-8796.141.3~6/RELEASE_ARM64_T6000 arm64
# machdep.cpu.brand_string: Apple M1 Max
#
# BenchmarkLogshDebugJSON_001
# LogshDebugJSON(message only) * 100
# real    0m1.132s
# user    0m0.198s
# sys     0m0.748s
#
# BenchmarkLogshDebugJSON_002
# LogshDebugJSON(with 1 field) * 100
# real    0m1.800s
# user    0m0.320s
# sys     0m1.225s
# -------------------------------------------------------------------------------------------------

cd "$(dirname "$0")"

# shellcheck disable=SC1091
. ./log.sh

export TZ=UTC LOGSH_LEVEL=0 LOGSH_TIMESTAMP_KEY=timestamp LOGSH_LEVEL_KEY=severity LOGSH_CALLER_KEY=caller LOGSH_MESSAGE_KEY=message

DisplayRuntimeInfo() {
  LogshRun uname -s -v -m
  __system=$(uname -s)
  if [ "${__system:-}" = Linux ]; then
    LogshRun sh -c "grep model.name /proc/cpuinfo | sort -u"
  elif [ "${__system:-}" = Darwin ]; then
    LogshRun sysctl -a machdep.cpu.brand_string
  else
    LogshWarning unknown system
  fi
  echo
} && DisplayRuntimeInfo

BenchmarkLogshDebugJSON_001() {
  echo "BenchmarkLogshDebugJSON_001"
  printf %s 'LogshDebugJSON(message only) * 100'
  time : "$(for _ in $(seq 1 100); do LogshDebugJSON "$(printf "\t\nA\t\nB\t\nC\t\n")"; done >/tmp/log.sh_BenchmarkLogshDebugJSON_001.log 2>&1)"
  echo
} && BenchmarkLogshDebugJSON_001

BenchmarkLogshDebugJSON_002() {
  echo "BenchmarkLogshDebugJSON_002"
  printf %s 'LogshDebugJSON(with 1 field) * 100'
  time : "$(for _ in $(seq 1 100); do LogshDebugJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")"; done >/tmp/log.sh_BenchmarkLogshDebugJSON_002.log 2>&1)"
  echo
} && BenchmarkLogshDebugJSON_002
