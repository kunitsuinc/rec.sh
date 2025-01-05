#!/bin/sh
set -e -u

cd "$(dirname "$0")/.."

# shellcheck disable=SC1091
. ./log.sh

export TZ=UTC LOGSH_COLOR=true LOGSH_LEVEL=0 LOGSH_TIMESTAMP_KEY=timestamp LOGSH_LEVEL_KEY=severity LOGSH_CALLER_KEY=caller LOGSH_MESSAGE_KEY=message

err=0

# begin log
LogshRun uname -a
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

#
# LogshDefault
#

TestLogshDefault_001() {
  LogshInfo "    RUN: TestLogshDefault_001"
  export LOGSH_LEVEL=0
  expect='^[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00 \[.*DEFAULT.*\] LOG$'
  actual=$(LogshDefault "LOG" 2>&1)
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshDefault_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshDefault_001"
} && TestLogshDefault_001 || err=$((err+$?))

TestLogshDefault_002() {
  LogshInfo "    RUN: TestLogshDefault_002"
  export LOGSH_LEVEL=1
  actual=$(LogshDefault "LOG" 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshDefault_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshDefault_002"
} && TestLogshDefault_002 || err=$((err+$?))

#
# LogshDefaultJSON
#

TestLogshDefaultJSON_001() {
  LogshInfo "    RUN: TestLogshDefaultJSON_001"
  export LOGSH_LEVEL=0
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"DEFAULT","caller":".+/testcases.sh","message":"\\t\\nA\\t\\nB\\t\\nC\\t","test":"\\t\\nA\\t\\nB\\t\\nC\\t"}$'
  actual=$(LogshDefaultJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshDefaultJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshDefaultJSON_001"
} && TestLogshDefaultJSON_001 || err=$((err+$?))

TestLogshDefaultJSON_002() {
  LogshInfo "    RUN: TestLogshDefaultJSON_002"
  export LOGSH_LEVEL=1
  actual=$(LogshDefaultJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshDefaultJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshDefaultJSON_002"
} && TestLogshDefaultJSON_002 || err=$((err+$?))

#
# LogshDebugJSON
#

TestLogshDebugJSON_001() {
  LogshInfo "    RUN: TestLogshDebugJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=100
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"DEBUG","caller":".+/testcases.sh","message":"\\t\\nA\\t\\nB\\t\\nC\\t","test":"\\t\\nA\\t\\nB\\t\\nC\\t"}$'
  actual=$(LogshDebugJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshDebugJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshDebugJSON_001"
} && TestLogshDebugJSON_001 || err=$((err+$?))

TestLogshDebugJSON_002() {
  LogshInfo "    RUN: TestLogshDebugJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=101
  actual=$(LogshDebugJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshDebugJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshDebugJSON_002"
} && TestLogshDebugJSON_002 || err=$((err+$?))

#
# LogshInfoJSON
#

TestLogshInfoJSON_001() {
  LogshInfo "    RUN: TestLogshInfoJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=200
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"INFO","caller":".+/testcases.sh","message":"\\t\\nA\\t\\nB\\t\\nC\\t","test":"\\t\\nA\\t\\nB\\t\\nC\\t"}$'
  actual=$(LogshInfoJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshInfoJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshInfoJSON_001"
} && TestLogshInfoJSON_001 || err=$((err+$?))

TestLogshInfoJSON_002() {
  LogshInfo "    RUN: TestLogshInfoJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=201
  actual=$(LogshInfoJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshInfoJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshInfoJSON_002"
} && TestLogshInfoJSON_002 || err=$((err+$?))

#
# LogshNoticeJSON
#

TestLogshNoticeJSON_001() {
  LogshInfo "    RUN: TestLogshNoticeJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=300
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"NOTICE","caller":".+/testcases.sh","message":"\\t\\nA\\t\\nB\\t\\nC\\t","test":"\\t\\nA\\t\\nB\\t\\nC\\t"}$'
  actual=$(LogshNoticeJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshNoticeJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshNoticeJSON_001"
} && TestLogshNoticeJSON_001 || err=$((err+$?))

TestLogshNoticeJSON_002() {
  LogshInfo "    RUN: TestLogshNoticeJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=301
  actual=$(LogshNoticeJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshNoticeJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshNoticeJSON_002"
} && TestLogshNoticeJSON_002 || err=$((err+$?))

#
# LogshWarningJSON
#

TestLogshWarningJSON_001() {
  LogshInfo "    RUN: TestLogshWarningJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=400
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"WARNING","caller":".+/testcases.sh","message":"\\t\\nA\\t\\nB\\t\\nC\\t","test":"\\t\\nA\\t\\nB\\t\\nC\\t"}$'
  actual=$(LogshWarningJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshWarningJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshWarningJSON_001"
} && TestLogshWarningJSON_001 || err=$((err+$?))

TestLogshWarningJSON_002() {
  LogshInfo "    RUN: TestLogshWarningJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=401
  actual=$(LogshWarningJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshWarningJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshWarningJSON_002"
} && TestLogshWarningJSON_002 || err=$((err+$?))

#
# LogshErrorJSON
#

TestLogshErrorJSON_001() {
  LogshInfo "    RUN: TestLogshErrorJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=500
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"ERROR","caller":".+/testcases.sh","message":"\\t\\nA\\t\\nB\\t\\nC\\t","test":"\\t\\nA\\t\\nB\\t\\nC\\t"}$'
  actual=$(LogshErrorJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshErrorJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshErrorJSON_001"
} && TestLogshErrorJSON_001 || err=$((err+$?))

TestLogshErrorJSON_002() {
  LogshInfo "    RUN: TestLogshErrorJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=501
  actual=$(LogshErrorJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshErrorJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshErrorJSON_002"
} && TestLogshErrorJSON_002 || err=$((err+$?))

#
# LogshCriticalJSON
#

TestLogshCriticalJSON_001() {
  LogshInfo "    RUN: TestLogshCriticalJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=600
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"CRITICAL","caller":".+/testcases.sh","message":"\\t\\nA\\t\\nB\\t\\nC\\t","test":"\\t\\nA\\t\\nB\\t\\nC\\t"}$'
  actual=$(LogshCriticalJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshCriticalJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshCriticalJSON_001"
} && TestLogshCriticalJSON_001 || err=$((err+$?))

TestLogshCriticalJSON_002() {
  LogshInfo "    RUN: TestLogshCriticalJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=601
  actual=$(LogshCriticalJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshCriticalJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshCriticalJSON_002"
} && TestLogshCriticalJSON_002 || err=$((err+$?))

#
# LogshAlertJSON
#

TestLogshAlertJSON_001() {
  LogshInfo "    RUN: TestLogshAlertJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=700
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"ALERT","caller":".+/testcases.sh","message":"\\t\\nA\\t\\nB\\t\\nC\\t","test":"\\t\\nA\\t\\nB\\t\\nC\\t"}$'
  actual=$(LogshAlertJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshAlertJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshAlertJSON_001"
} && TestLogshAlertJSON_001 || err=$((err+$?))

TestLogshAlertJSON_002() {
  LogshInfo "    RUN: TestLogshAlertJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=701
  actual=$(LogshAlertJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshAlertJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshAlertJSON_002"
} && TestLogshAlertJSON_002 || err=$((err+$?))

#
# LogshEmergencyJSON
#

TestLogshEmergencyJSON_001() {
  LogshInfo "    RUN: TestLogshEmergencyJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=800
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"EMERGENCY","caller":".+/testcases.sh","message":"\\t\\nA\\t\\nB\\t\\nC\\t","test":"\\t\\nA\\t\\nB\\t\\nC\\t"}$'
  actual=$(LogshEmergencyJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshEmergencyJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshEmergencyJSON_001"
} && TestLogshEmergencyJSON_001 || err=$((err+$?))

TestLogshEmergencyJSON_002() {
  LogshInfo "    RUN: TestLogshEmergencyJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=801
  actual=$(LogshEmergencyJSON "$(printf "\t\nA\t\nB\t\nC\t\n")" "test" "$(printf "\t\nA\t\nB\t\nC\t\n")" 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshEmergencyJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshEmergencyJSON_002"
} && TestLogshEmergencyJSON_002 || err=$((err+$?))

#
# LogshExecJSON
#

TestLogshExecJSON_001() {
  LogshInfo "    RUN: TestLogshExecJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=100
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"INFO","caller":".+/testcases.sh","message":". true"}$'
  actual=$(LogshExecJSON true 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshExecJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshExecJSON_001"
} && TestLogshExecJSON_001 || err=$((err+$?))

TestLogshExecJSON_002() {
  LogshInfo "    RUN: TestLogshExecJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=201
  actual=$(LogshExecJSON true 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshExecJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshExecJSON_002"
} && TestLogshExecJSON_002 || err=$((err+$?))

#
# LogshRunJSON
#

TestLogshRunJSON_001() {
  LogshInfo "    RUN: TestLogshRunJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=100
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"INFO","caller":".+/testcases.sh","message":". date .%Y-%m-%d","command":"date .%Y-%m-%d","stdout":"[0-9]+-[0-9]+-[0-9]+","stderr":"","return":"0"}$'
  actual=$(LogshRunJSON date +%Y-%m-%d 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestLogshRunJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestLogshRunJSON_001"
} && TestLogshRunJSON_001 || err=$((err+$?))

TestLogshRunJSON_002() {
  LogshInfo "    RUN: TestLogshRunJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=201
  actual=$(LogshRunJSON date +%Y-%m-%d 2>&1)
  unset LOGSH_LEVEL
  if [ "${actual:-}" ]; then
    LogshError "        FAIL: TestLogshRunJSON_002"
    return 1
  fi
  LogshInfo "        PASS: TestLogshRunJSON_002"
} && TestLogshRunJSON_002 || err=$((err+$?))

#
# common
#

TestCommonLogshJSON_001() {
  LogshInfo "    RUN: TestCommonLogshJSON_001"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=0
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"DEFAULT","caller":".+/testcases.sh","message":""}$'
  actual=$(LogshDefaultJSON 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestCommonLogshJSON_001"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestCommonLogshJSON_001"
} && TestCommonLogshJSON_001 || err=$((err+$?))

TestCommonLogshJSON_002() {
  LogshInfo "    RUN: TestCommonLogshJSON_002"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=0
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"DEFAULT","caller":".+/testcases.sh","message":"","testKey":""}$'
  actual=$(LogshDefaultJSON "" testKey 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestCommonLogshJSON_002"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestCommonLogshJSON_002"
} && TestCommonLogshJSON_002 || err=$((err+$?))

TestCommonLogshJSON_003() {
  LogshInfo "    RUN: TestCommonLogshJSON_003"
  unset LOGSH_LEVEL
  export LOGSH_LEVEL=0
  expect='^{"timestamp":"[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.00:00","severity":"DEFAULT","caller":".+/testcases.sh","message":"","testKey":"testValue"}$'
  actual=$(LogshDefaultJSON "" testKey testValue 2>&1)
  unset LOGSH_LEVEL
  if ! printf "%s" "${actual-}" | grep -Eq "$(printf "%s" "${expect}")" ; then
    LogshError "        FAIL: TestCommonLogshJSON_003"
    printf "    expect: %s\n" "${expect}"
    printf "    actual: %s\n" "${actual-}"
    return 1
  fi
  LogshInfo "        PASS: TestCommonLogshJSON_003"
} && TestCommonLogshJSON_003
