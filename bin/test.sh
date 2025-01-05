#!/bin/sh
set -e -u

cd "$(dirname "$0")/.."

# shellcheck disable=SC1091
. ./log.sh

export TZ=UTC LOGSH_COLOR=true LOGSH_LEVEL=0 LOGSH_TIMESTAMP_KEY=timestamp LOGSH_LEVEL_KEY=severity LOGSH_CALLER_KEY=caller LOGSH_MESSAGE_KEY=message

err=0

# begin log
LogshInfo "RUN: $0"
# end log
trap 'if [ ${err:-0} -gt 0 ]; then
  LogshError "FAIL: $0"
  exit ${err:-1}
else
  LogshInfo "PASS: $0"
  exit 0
fi
' EXIT

# local
./bin/testcases.sh || err=$((err+$?))
# debian:12
docker run --rm -v "$(pwd -P)":"$(pwd -P)" -w "$(pwd -P)" -e LOGSH_COLOR=true debian:12 ./bin/testcases.sh || err=$((err+$?))
# ubuntu:22.04 dash
docker run --rm -v "$(pwd -P)":"$(pwd -P)" -w "$(pwd -P)" -e LOGSH_COLOR=true ubuntu:22.04 dash ./bin/testcases.sh || err=$((err+$?))
# ubuntu:22.04 bash
docker run --rm -v "$(pwd -P)":"$(pwd -P)" -w "$(pwd -P)" -e LOGSH_COLOR=true ubuntu:22.04 bash ./bin/testcases.sh || err=$((err+$?))
