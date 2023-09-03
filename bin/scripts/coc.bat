@echo off
setlocal

set my_install_path=""
set "file_path=%TEMP%\coc_version_check"

goto parse_args

:command_check
  where node > NUL
  if not errorlevel 0 (
    echo Please install nodejs:
    echo $ scoop install nodejs
    echo ..
    echo then restart your terminal
    echo ..
    exit /b 1
  )

  where npm > NUL
  if not errorlevel 0 (
    echo Please install npm:
    echo $ scoop install nodejs
    echo ..
    echo then restart your terminal
    echo ..
    exit /b 1
  )

  where yarn > NUL
  if not errorlevel 0 (
    echo Please install yarn:
    echo $ npm install yarn@latest -g --force
    exit /b 1
  )

  where semver > NUL
  if not errorlevel 0 (
    echo Please install semver:
    echo $ npm install semver@latest -g --force
    exit /b 1
  )

  exit /b 0

:node_check
  set check_pass="false"
  for /f %%i in ('node --version 2^>^&1') do (
    semver -r ">=v16.7.0" %%i > %file_path%

    for /f %%j in (%file_path%) do (
      set check_pass="true"
    )

    if "%check_pass%"=="false" (
      exit /b 1
    )
  )
  exit /b 0

:npm_check
  set check_pass="false"
  for /f %%i in ('npm --version 2^>^&1') do (
    semver -r ">=8.0.0" %%i > %file_path%

    for /f %%j in (%file_path%) do (
      set check_pass="true"
    )

    if "%check_pass%"=="false" (
      exit /b 1
    )
  )
  exit /b 0

:yarn_check
  set check_pass="false"
  for /f %%i in ('yarn --version 2^>^&1') do (
    semver -r ">=1.22.0" %%i > %file_path%

    for /f %%j in (%file_path%) do (
      set check_pass="true"
    )

    if "%check_pass%"=="false" (
      exit /b 1
    )
  )
  exit /b 0

:parse_args
  if "%~1"=="" goto end_args

  if "%~1"=="--install_path" (
    set my_install_path=%~2
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
  call :command_check
  if errorlevel 1 (
    exit /b 1
  )

  call :node_check
  if errorlevel 1 (
    echo Please update node [require -gt v16.17]
    echo $ scoop update nodejs
    exit /b 1
  )

  call :npm_check
  if errorlevel 1 (
    echo Please update npm [require -gt v8.0.0]
    echo $ scoop update nodejs
    exit /b 1
  )

  call :yarn_check
  if errorlevel 1 (
    echo Please update yarn [require -gt v1.22.0]:
    echo $ npm install yarn@latest -g --force
    exit /b 1
  )

  if "%my_install_path%"=="" (
    echo --install_path missing param
    exit /b 1
  )

  if not exist %my_install_path% (
    echo Install Path    : %my_install_path% is not exist
    exit /b 1
  ) else (
    echo Install Path    : %my_install_path%
  )

  if not exist %my_install_path%\plugin\coc.vim (
    echo %my_install_path% is not a coc path
    exit /b 1
  )

  yarn --cwd %my_install_path% install
  if not errorlevel 0 (
    echo yarn install coc failed
    exit /b 1
  )

  yarn --cwd %my_install_path% build
  if not errorlevel 0 (
    echo yarn build coc failed
    exit /b 1
  )

  exit /b 0

:end
  echo Done
