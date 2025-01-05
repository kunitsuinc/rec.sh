#!/usr/bin/env bash
set -Eeuo pipefail

# LICENSE: https://github.com/hakadoriya/log.sh/blob/HEAD/LICENSE
# Common
if [ "${LOGSH_COLOR:-}" ] || [ -t 2 ] ; then LOGSH_COLOR=true; else LOGSH_COLOR=''; fi
_logshRFC3339() { date "+%Y-%m-%dT%H:%M:%S%z" | sed "s/\(..\)$/:\1/"; }
_logshCmd() { for a in "$@"; do if echo "${a:-}" | grep -Eq "[[:blank:]]"; then printf "'%s' " "${a:-}"; else printf "%s " "${a:-}"; fi; done | sed "s/ $//"; }
# Color
LogshInfo() { test "     ${LOGSH_LEVEL:-0}" -gt 200 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;32m}     INFO${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshError() { test "    ${LOGSH_LEVEL:-0}" -gt 500 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;31m}    ERROR${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshExec() { LogshInfo "$ $(_logshCmd "$@")" && "$@"; }

main () {
  # cd to the parent directory of this script
  if ! LogshExec cd "$(dirname "$0")/.."; then
    LogshError "cd failed"
    exit 1
  fi
  # copy log.sh to docs
  LogshExec cp -a ./log.sh ./docs/index.html
  # done
  LogshInfo "done"
} && main "$@"
