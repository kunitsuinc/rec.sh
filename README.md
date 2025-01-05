# log.sh - JSON logger for POSIX Shell Script

[![license](https://img.shields.io/github/license/hakadoriya/log.sh)](LICENSE)
[![workflow](https://github.com/hakadoriya/log.sh/workflows/sh-test/badge.svg)](https://github.com/hakadoriya/log.sh/tree/main)

log.sh is a lightweight and no dependencies JSON logger for POSIX Shell Script.  

This logger has been minimized as much as possible for copy-and-paste portability, at the expense of readability.  

**NOTE:** log.sh only supports JSON with string values. JSON such as `{"number":123}` cannot be output. In the case of log.sh, it will be `{"number":"123"}`.  

**NOTE:** log.sh cannot output any control characters other than `\n` `\r` `\t`.  

## HOW TO USE

There are two ways.  

### 1. Vendoring (recommended)

Copy the log.sh functions in the shell script file ([`index.html`](/index.html)) and paste them where you want to use them.  
(file name `index.html` may seem strange, but it's necessary for me to serve Shell Script file in GitHub Pages with as short URL [`https://hakadoriya.github.io/log.sh/`](https://hakadoriya.github.io/log.sh/) as possible)  

### 2. Use via HTTP

You can load a shell script function via the Internet as follows:  

```console
$ eval "$(curl -fLSs --tlsv1.2 https://hakadoriya.github.io/log.sh/)"

$ LogshInfoJSON hello foo bar HOSTNAME ${HOSTNAME}
{"timestamp":"2021-11-26T08:02:08+09:00","severity":"INFO","caller":"-bash","message":"hello","foo":"bar","HOSTNAME":"localhost"}  # <- NOTE: stderr

$ # And so on...
```

## Examples of usage

```console
$ # LogshDefaultJSON, LogshDebugJSON, LogshInfoJSON, LogshNoticeJSON, LogshWarningJSON, LogshErrorJSON, LogshCriticalJSON, LogshAlertJSON and LogshEmergencyJSON
$ LogshInfoJSON hello foo bar HOSTNAME ${HOSTNAME} ctrl "$(printf "\n\t\r")" cannot-tail-lf "$(printf "\t\r\n")" cannot-other-ctrl-chars "$(printf "\x01\x7F")"
{"timestamp":"2021-11-26T08:02:08+09:00","severity":"INFO","caller":"-bash","message":"hello","foo":"bar","HOSTNAME":"localhost","ctrl":"\n\t\r","cannot-tail-lf":"\t\r","cannot-other-ctrl-chars":""}  # <- NOTE: stderr

$ LogshInfoJSON hello foo bar HOSTNAME ${HOSTNAME} ctrl "$(printf "\n\t\r")" cannot-tail-lf "$(printf "\t\r\n")" cannot-other-ctrl-chars "$(printf "\x01\x7F")" 2>&1 | jq .
{
  "timestamp": "2021-11-26T08:02:34+09:00",
  "severity": "INFO",
  "caller": "-bash",
  "message": "hello",
  "foo": "bar",
  "HOSTNAME": "localhost",
  "ctrl": "\n\t\r",
  "cannot-tail-lf": "\t\r"       # <- NOTE: log.sh can't output field value tail '\n'
  "cannot-other-ctrl-chars": ""  # <- NOTE: log.sh can't output other control characters
}
```

```console
$ # Severity threshold
$ export LOGSH_LEVEL=0; LogshDefaultJSON "output"; LogshDebugJSON "output"; LogshInfoJSON "output"
{"timestamp":"2021-11-28T10:28:24+09:00","severity":"DEFAULT","caller":"-bash","message":"output"}
{"timestamp":"2021-11-28T10:28:24+09:00","severity":"DEBUG","caller":"-bash","message":"output"}
{"timestamp":"2021-11-28T10:28:24+09:00","severity":"INFO","caller":"-bash","message":"output"}

$ export LOGSH_LEVEL=1; LogshDefaultJSON "NO OUTPUT"; LogshDebugJSON "output"; LogshInfoJSON "output"
{"timestamp":"2021-11-28T10:28:24+09:00","severity":"DEBUG","caller":"-bash","message":"output"}
{"timestamp":"2021-11-28T10:28:24+09:00","severity":"INFO","caller":"-bash","message":"output"}

$ export LOGSH_LEVEL=101; LogshDefaultJSON "NO OUTPUT"; LogshDebugJSON "NO OUTPUT"; LogshInfoJSON "output"
{"timestamp":"2021-11-28T10:28:24+09:00","severity":"INFO","caller":"-bash","message":"output"}

$ # +------------------+------------------------+
$ # | Function         | LOGSH_LEVEL threshold |
$ # +------------------+------------------------+
$ # | LogshDefaultJSON   |                      0 |
$ # | LogshDebugJSON     |                    100 |
$ # | LogshInfoJSON      |                    200 |
$ # | LogshNoticeJSON    |                    300 |
$ # | LogshWarningJSON   |                    400 |
$ # | LogshErrorJSON     |                    500 |
$ # | LogshCriticalJSON  |                    600 |
$ # | LogshAlertJSON     |                    700 |
$ # | LogshEmergencyJSON |                    800 |
$ # +------------------+------------------------+
```

```console
$ # Change timestamp timezone
$ TZ=UTC LogshInfoJSON hello foo bar 2>&1 | jq .
{
  "timestamp": "2021-11-27T11:19:15+00:00",  # <- NOTE: TZ=UTC
  "severity": "INFO",
  "caller": "-bash",
  "message": "hello",
  "foo": "bar"
}
```

```console
$ # Change field key name
$ export LOGSH_TIMESTAMP_KEY=ts LOGSH_LEVEL_KEY=lv LOGSH_CALLER_KEY=file LOGSH_MESSAGE_KEY=msg
$ LogshInfoJSON hello foo bar 2>&1 | jq .
{
  "ts": "2021-11-27T20:21:55+09:00",  # <- NOTE: LOGSH_TIMESTAMP_KEY
  "lv": "INFO",                       # <- NOTE: LOGSH_LEVEL_KEY
  "file": "-bash",                    # <- NOTE: LOGSH_CALLER_KEY
  "msg": "hello",                     # <- NOTE: LOGSH_MESSAGE_KEY
  "foo": "bar"
}
```

```console
$ # LogshExecJSON
$ LogshExecJSON date +%F
{"timestamp":"2021-11-27T20:25:03+09:00","severity":"INFO","caller":"-bash","message":"$ date +%F"}  # <- NOTE: stderr
2021-11-25
```

```console
$ # LogshRunJSON
$ LogshRunJSON sh -c "echo out; echo err 1>&2; exit 1"
{"timestamp":"2021-11-27T20:25:27+09:00","severity":"INFO","caller":"-bash","message":"$ date +%F","command":"date +%F","stdout":"2021-11-27","stderr":"","return":"1"}  # <- NOTE: stderr

$ LogshRunJSON sh -c "echo out; echo err 1>&2; exit 1" 2>&1 | jq .
{
  "timestamp": "2021-11-27T20:26:46+09:00",
  "severity": "INFO",
  "caller": "-bash",
  "message": "$ sh -c 'echo out; echo err 1>&2'",
  "command": "sh -c 'echo out; echo err 1>&2'",
  "stdout": "out",
  "stderr": "err",
  "return": "1"
}
```

## Thanks

The following tools are used for development.  

- formatter ... [`github.com/mvdan/sh`](https://github.com/mvdan/sh)
- linter    ... [`github.com/koalaman/shellcheck`](https://github.com/koalaman/shellcheck)
