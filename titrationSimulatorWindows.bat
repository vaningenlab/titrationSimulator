Rem Windows batch file to startup OCTAVE and start titration simulator
Rem this versions calls octave-cli directly to avoid using 8.3 format names
Rem this version thus needs to tolerate spaces!
Rem includes all settings from octave-7.2.0.bat to make sure file copy works!
Rem see https://lists.libreplanet.org/archive/html/octave-bug-tracker/2021-04/msg00373.html
Rem without using --gui will force --cli and default to fltk toolkit

Rem User needs to asjust ROOT_PATH if Octave is not installed in default location
Rem spaces in variable is OK

set ROOT_PATH=C:\Program Files\GNU Octave\Octave-8.4.0

Rem titration simulator script dir extracted from current working dir -- could contain spaces
Rem should not be necessary since current dir is already main dir of simulator
set SCRIPTS_DIR=%~dp0\scripts

Rem set home if not already set
if "%HOME%"=="" set HOME=%USERPROFILE%
if "%HOME%"=="" set HOME=%HOMEDRIVE%%HOMEPATH%

Rem check if Octave is 32 or 64 bit -- need quotes to tolerate spaces
if EXIST "%ROOT_PATH%\mingw32\bin\octave.exe" set OCTAVE_HOME=%ROOT_PATH%\mingw32
if EXIST "%ROOT_PATH%\mingw64\bin\octave.exe" set OCTAVE_HOME=%ROOT_PATH%\mingw64

echo %OCTAVE_HOME%

set MSYSTEM=MSYS
set MSYSPATH=%OCTAVE_HOME%
IF EXIST "%ROOT_PATH%\mingw64\bin\octave.bat" (
  set MSYSTEM=MINGW64
  set MSYSPATH=%ROOT_PATH%\usr\
) ELSE (
  IF EXIST "%ROOT_PATH%\mingw32\bin\octave.bat" (
    set MSYSTEM=MINGW64
    set MSYSPATH=%ROOT_PATH%\usr\
  )
)
 
Rem Set up PATH.  Make sure the octave bin dir comes first.
set PATH=%OCTAVE_HOME%\qt5\bin;%OCTAVE_HOME%\bin;%MSYSPATH%\bin;%PATH%

Rem Set up any environment vars we may need.
set TERM=cygwin
set GNUTERM=wxt
set GS=gs.exe

Rem QT_PLUGIN_PATH must be set to avoid segfault (bug #53419).
IF EXIST "%OCTAVE_HOME%\qt5\bin\" (
  set QT_PLUGIN_PATH=%OCTAVE_HOME%\qt5\plugins
) ELSE (
  set QT_PLUGIN_PATH=%OCTAVE_HOME%\plugins
)

Rem pkgconfig .pc files path
set PKG_CONFIG_PATH=%OCT_HOME%\lib\pkgconfig

IF NOT x%OPENBLAS_NUM_THREADS%==x GOTO openblas_num_threads_set

Rem Set OPENBLAS_NUM_THREADS to number of physical processor cores.
SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic CPU Get NumberOfCores`) DO (
  SET line!count!=%%F
  SET /a count=!count!+1
)
Rem Check that first line contains "NumberOfCores".
IF x%line1%==xNumberOfCores (
  Rem The next line should contain the number of cores.
  SET OPENBLAS_NUM_THREADS=%line2%
)
ENDLOCAL & SET OPENBLAS_NUM_THREADS=%OPENBLAS_NUM_THREADS%

:openblas_num_threads_set

Rem since we should be in main directory, just cd('scripts') should be sufficient
Rem octave-cli has old-fashioned fltk toolkit but much more responsive than qt in my testing
call "%OCTAVE_HOME%\bin\octave-cli.exe" --eval "cd('scripts'); ini" --persist