@echo off
setlocal

set my_home=""
set my_package=""
set my_output=""

where unzip > NUL
if not errorlevel 0 (
  echo Please install unzip:
  echo $ scoop install busybox
  exit /b 1
)

where ctags > NUL
if not errorlevel 0 (
  echo Please install unzip:
  echo $ scoop install ctags
  exit /b 1
)

:parse_args
  if "%~1"=="" goto end_args

  if "%~1"=="--home" (
    set my_home=%~2
    shift
    shift
  ) else if "%~1"=="--package" (
    set my_package=%~2
    shift
    shift
  ) else (
    echo Unknow: %~1
    exit /b 1
  )

  goto parse_args

:end_args
  goto main

:main
  if "%my_home%"=="" (
    echo --home missing param
    exit /b 1
  )
  if "%my_package%"=="" (
    echo --package missing param
    exit /b 1
  )

  if not exist %my_home% (
    echo Home    : %my_home% is not exist
    exit /b 1
  ) else (
    echo Home    : %my_home%
  )

  if not exist %my_package% (
    echo Package : %my_package% is not exist
    exit /b 1
  ) else (
    echo Package : %my_package%
  )

  set my_output=%my_home%\.vim\bundle\global-6.6.9
  if not exist %my_output% (
    echo Create  : %my_output%
    MD %my_output%
    MD %my_output%\plugin
  ) else (
    echo Please remove %my_output% manually
    exit /b 1
  )

  unzip -q -d%my_output% %my_package%
  if not errorlevel 0 (
    echo Failed to uncompress %my_package% to %my_output%
    exit /b 1
  )

  COPY %my_output%\share\gtags\gtags.vim %my_output%\plugin\gtags.vim
  if not errorlevel 0 (
    echo Failed to COPY gtags.vim
    exit /b 1
  )
  
  COPY %my_output%\share\gtags\gtags-cscope.vim %my_output%\plugin\gtags-cscope.vim
  if not errorlevel 0 (
    echo Failed to COPY gtags-cscope.vim
    exit /b 1
  )

  setx PATH "%PATH%;%my_output%\bin"
  if not errorlevel 0 (
    echo Failed to setx PATH
    exit /b 1
  )

  exit /b 0

:end
  echo Done
