#!/bin/sh
# shellcheck disable=SC2317
cat >/dev/null <<'#https://hakadoriya.github.io/log.sh/'
<style>body{font-size:0;margin:0}code,pre{font-size:1rem;font-family:'Ricty Diminished',Osaka-Mono,Menlo,Monaco,Consolas,'Courier New','Andale Mono','Ubuntu Mono',monospace}</style><pre><code>
#https://hakadoriya.github.io/log.sh/

# LICENSE: https://github.com/hakadoriya/log.sh/blob/HEAD/LICENSE
# Common
if [ "${LOGSH_COLOR:-}" ] || [ -t 2 ] ; then LOGSH_COLOR=true; else LOGSH_COLOR=''; fi
_logshRFC3339() { date "+%Y-%m-%dT%H:%M:%S%z" | sed "s/\(..\)$/:\1/"; }
_logshCmd() { for a in "$@"; do if echo "${a:-}" | grep -Eq "[[:blank:]]"; then printf "'%s' " "${a:-}"; else printf "%s " "${a:-}"; fi; done | sed "s/ $//"; }
# Color
LogshDefault() { test "  ${LOGSH_LEVEL:-0}" -gt 000 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;35m}  DEFAULT${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshDebug() { test "    ${LOGSH_LEVEL:-0}" -gt 100 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;34m}    DEBUG${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshInfo() { test "     ${LOGSH_LEVEL:-0}" -gt 200 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;32m}     INFO${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshNotice() { test "   ${LOGSH_LEVEL:-0}" -gt 300 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;36m}   NOTICE${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshWarn() { test "     ${LOGSH_LEVEL:-0}" -gt 400 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;33m}     WARN${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshWarning() { test "  ${LOGSH_LEVEL:-0}" -gt 400 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;33m}  WARNING${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshError() { test "    ${LOGSH_LEVEL:-0}" -gt 500 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;31m}    ERROR${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshCritical() { test " ${LOGSH_LEVEL:-0}" -gt 600 || echo "$*" | awk "{print \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;1;31m} CRITICAL${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshAlert() { test "    ${LOGSH_LEVEL:-0}" -gt 700 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;41m}    ALERT${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshEmergency() { test "${LOGSH_LEVEL:-0}" -gt 800 || echo "$*" | awk "{print \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;1;41m}EMERGENCY${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshExec() { LogshInfo "$ $(_logshCmd "$@")" && "$@"; }
LogshRun() { _dlm="####R#E#C#D#E#L#I#M#I#T#E#R####" && _all=$({ _out=$("$@") && _rtn=$? || _rtn=$? && printf "\n%s" "${_dlm:?}${_out:-}" && return "${_rtn:-0}"; } 2>&1) && _rtn=$? || _rtn=$? && _dlmno=$(echo "${_all:-}" | sed -n "/${_dlm:?}/=") && _cmd=$(_logshCmd "$@") && _stdout=$(echo "${_all:-}" | tail -n +"${_dlmno:-1}" | sed "s/^${_dlm:?}//") && _stderr=$(echo "${_all:-}" | head -n "${_dlmno:-1}" | grep -v "^${_dlm:?}") && LogshInfo "$ ${_cmd:-}" && LogshInfo "${_stdout:-}" && { [ -z "${_stderr:-}" ] || LogshWarning "${_stderr:?}"; } && return "${_rtn:-0}"; }
# export functions for bash
# shellcheck disable=SC3045
echo "${SHELL-}" | grep -q "/?bash" && export -f _logshRFC3339 _logshCmd LogshDefault LogshDebug LogshInfo LogshWarning LogshError LogshCritical LogshAlert LogshEmergency LogshExec LogshRun || true

# LICENSE: https://github.com/hakadoriya/log.sh/blob/HEAD/LICENSE
# Common
_logshRFC3339() { date "+%Y-%m-%dT%H:%M:%S%z" | sed "s/\(..\)$/:\1/"; }
_logshCmd() { for a in "$@"; do if echo "${a:-}" | grep -Eq "[[:blank:]]"; then printf "'%s' " "${a:-}"; else printf "%s " "${a:-}"; fi; done | sed "s/ $//"; }
# JSON
_logshEscape() { printf %s "${1:-}" | sed "s/\"/\\\"/g; s/\r/\\\r/g; s/\t/\\\t/g; s/$/\\\n/g" | tr -d "[:cntrl:]" | sed "s/\\\n$/\n/"; }
# NOTE: shift 2 -> ${1+shift} && ${1+shift} ... avoid "shift: can't shift that many" error
_logshJSON() { _svr="${1:?}" && _msg="$(_logshEscape "${2:-}")" && unset _fld _val && ${1+shift} && ${1+shift} && for a in "$@"; do if [ "${_val:-}" ]; then _fld="${_fld:?}:\"$(_logshEscape "${a:-}")\"" && unset _val && continue; fi && _fld="${_fld:-}${_fld:+,}\"${a:?"json key is not set"}\"" && _val=1; done && test $(($# % 2)) = 1 && _fld="${_fld:?}:\"\"" || true && printf "{%s}\n" "\"${LOGSH_TIMESTAMP_KEY:-timestamp}\":\"$(_logshRFC3339)\",\"${LOGSH_LEVEL_KEY:-severity}\":\"${_svr:?}\",\"${LOGSH_CALLER_KEY:-caller}\":\"$0\",\"${LOGSH_MESSAGE_KEY:-message}\":\"${_msg:-}\"${_fld:+,}${_fld:-}"; }
LogshDefaultJSON() { test "  ${LOGSH_LEVEL:-0}" -gt 000 2>/dev/null || _logshJSON DEFAULT "$@" 1>&2; }
LogshDebugJSON() { test "    ${LOGSH_LEVEL:-0}" -gt 100 2>/dev/null || _logshJSON DEBUG "$@" 1>&2; }
LogshInfoJSON() { test "     ${LOGSH_LEVEL:-0}" -gt 200 2>/dev/null || _logshJSON INFO "$@" 1>&2; }
LogshNoticeJSON() { test "   ${LOGSH_LEVEL:-0}" -gt 300 2>/dev/null || _logshJSON NOTICE "$@" 1>&2; }
LogshWarnJSON() { test "     ${LOGSH_LEVEL:-0}" -gt 400 2>/dev/null || _logshJSON WARN "$@" 1>&2; }
LogshWarningJSON() { test "  ${LOGSH_LEVEL:-0}" -gt 400 2>/dev/null || _logshJSON WARNING "$@" 1>&2; }
LogshErrorJSON() { test "    ${LOGSH_LEVEL:-0}" -gt 500 2>/dev/null || _logshJSON ERROR "$@" 1>&2; }
LogshCriticalJSON() { test " ${LOGSH_LEVEL:-0}" -gt 600 2>/dev/null || _logshJSON CRITICAL "$@" 1>&2; }
LogshAlertJSON() { test "    ${LOGSH_LEVEL:-0}" -gt 700 2>/dev/null || _logshJSON ALERT "$@" 1>&2; }
LogshEmergencyJSON() { test "${LOGSH_LEVEL:-0}" -gt 800 2>/dev/null || _logshJSON EMERGENCY "$@" 1>&2; }
LogshExecJSON() { LogshInfoJSON "$ $(_logshCmd "$@")" && "$@"; }
LogshRunJSON() { _dlm='####R#E#C#D#E#L#I#M#I#T#E#R####' && _all=$({ _out=$("$@") && _rtn=$? || _rtn=$? && printf "\n%s" "${_dlm:?}${_out:-}" && return "${_rtn:-0}"; } 2>&1) && _rtn=$? || _rtn=$? && _dlmno=$(echo "${_all:-}" | sed -n "/${_dlm:?}/=") && _cmd=$(_logshCmd "$@") && _stdout=$(echo "${_all:-}" | tail -n +"${_dlmno:-1}" | sed "s/^${_dlm:?}//") && _stderr=$(echo "${_all:-}" | head -n "${_dlmno:-1}" | grep -v "^${_dlm:?}") && LogshInfoJSON "$ ${_cmd:-}" command "${_cmd:-}" stdout "${_stdout:-}" stderr "${_stderr:-}" return "${_rtn:-0}" && return "${_rtn:-0}"; }
# export functions for bash
# shellcheck disable=SC3045
echo "${SHELL-}" | grep -q "/?bash" && export -f _logshRFC3339 _logshCmd _logshEscape _logshJSON LogshDefaultJSON LogshDebugJSON LogshInfoJSON LogshNoticeJSON LogshWarningJSON LogshErrorJSON LogshCriticalJSON LogshAlertJSON LogshEmergencyJSON LogshExecJSON LogshRunJSON || true

# (C) 2022 hakadoriya </code></pre>
