
@echo off
if /i "%~1"=="p" (
    shift
    node "%~dp0curlp.js" %*
) else (
    curl.exe %*
)
