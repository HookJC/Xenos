@echo off
rem ============================================================
rem  Xenos - build all configurations with Visual Studio 2019
rem  Output: build\Win32\Debug, build\Win32\Release,
rem          build\x64\Debug,   build\x64\Release
rem ============================================================
setlocal

rem System32 must be on PATH for the BlackBone post-build xcopy step
set "PATH=C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem;%PATH%"
set "MSBUILD=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe"
set "SLN=%~dp0Xenos.sln"

if not exist "%MSBUILD%" goto :no_msbuild

for %%C in (Debug Release) do call :build_config %%C
if errorlevel 1 exit /b 1

echo.
echo All four configurations built successfully.
echo   build\Win32\Debug\Xenos.exe
echo   build\x64\Debug\Xenos64.exe
echo   build\Win32\Release\Xenos.exe
echo   build\x64\Release\Xenos64.exe
exit /b 0

:build_config
for %%P in (Win32 x64) do (
    echo === Build %%P %1 ===
    "%MSBUILD%" "%SLN%" /m /p:Configuration=%1 /p:Platform=%%P /v:minimal /nologo
    if errorlevel 1 exit /b 1
)
exit /b 0

:no_msbuild
echo [ERROR] MSBuild of VS2019 not found:
echo         %MSBUILD%
exit /b 1
