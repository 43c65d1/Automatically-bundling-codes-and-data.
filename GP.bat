@REM @REM @echo off
@REM @REM setlocal enabledelayedexpansion
@REM @REM 
@REM @REM REM ===== Configuration =====
@REM @REM set "date_format=%date:~0,4%%date:~5,2%%date:~8,2%"
@REM @REM set "script_dir=%~dp0"
@REM @REM set "output_dir=%script_dir%Zips"
@REM @REM 
@REM @REM REM ===== Create Output Directory =====
@REM @REM if not exist "%output_dir%" (
@REM @REM     mkdir "%output_dir%" >nul 2>&1 || (
@REM @REM         echo Error: Failed to create directory "%output_dir%"
@REM @REM         pause
@REM @REM         exit /b 1
@REM @REM     )
@REM @REM )
@REM @REM 
@REM @REM REM ===== Package Structured Version =====
@REM @REM set "std_zip=0_std_%date_format%.zip"
@REM @REM powershell -Command "$tempDir = New-Item -Type Directory -Path (Join-Path $env:temp ('TempZip_'+ (Get-Random))) -Force; try { $files = @(Get-ChildItem -Recurse -Include *.in, *.out, std.cpp , spj.cpp , gen.cpp, validator.cpp); if ($files.Count -gt 0) { $files | Copy-Item -Destination $tempDir.FullName -Force; $stdDir = New-Item -Path ($tempDir.FullName+'\std') -Type Directory -Force; Copy-Item 'std.cpp', 'spj.cpp' , 'gen.cpp', 'validator.cpp' -Destination $stdDir.FullName -ErrorAction 0; Compress-Archive -Path ($tempDir.FullName+'\*') -DestinationPath ('%output_dir%\%std_zip%') -Force; echo [OK] Structured ZIP: %output_dir%\%std_zip% } else { echo [ERROR] No files found } } finally { Remove-Item $tempDir -Recurse -Force -ErrorAction 0 }"
@REM @REM 
@REM @REM REM ===== Package Data Version =====
@REM @REM set "data_zip=0_Data_%date_format%.zip"
@REM @REM powershell -Command "$files = @(Get-ChildItem -Recurse -Include *.in, *.out); if ($files.Count -gt 0) { Compress-Archive -Path $files -DestinationPath ('%output_dir%\%data_zip%') -Force; echo [OK] Data ZIP: %output_dir%\%data_zip% } else { echo [ERROR] No .in/.out files found }"
@REM 
@REM @echo off
@REM setlocal enabledelayedexpansion
@REM 
@REM REM ===== Configuration =====
@REM set "date_format=%date:~0,4%%date:~5,2%%date:~8,2%"
@REM set "script_dir=%~dp0"
@REM set "output_dir=%script_dir%Zips"
@REM 
@REM REM ===== Create Output Directory =====
@REM if not exist "%output_dir%" (
@REM     mkdir "%output_dir%" >nul 2>&1 || (
@REM         echo Error: Failed to create directory "%output_dir%"
@REM         pause
@REM         exit /b 1
@REM     )
@REM )
@REM 
@REM REM ===== Package Structured Version =====
@REM set "std_zip=0_std_%date_format%.zip"
@REM powershell -Command "$tempDir = New-Item -Type Directory -Path (Join-Path $env:temp ('TempZip_'+ (Get-Random))) -Force; try { $stdDir = New-Item -Path (Join-Path $tempDir 'std') -ItemType Directory -Force; $dataDir = New-Item -Path (Join-Path $tempDir 'data') -ItemType Directory -Force; $cppFiles = Get-ChildItem -Recurse -Include std.cpp , 'spj.cpp' , gen.cpp, validator.cpp; $dataFiles = Get-ChildItem -Recurse -Include *.in, *.out; if ($cppFiles.Count -gt 0) { $cppFiles | Copy-Item -Destination $stdDir.FullName -Force }; if ($dataFiles.Count -gt 0) { $dataFiles | Copy-Item -Destination $dataDir.FullName -Force }; if ((Get-ChildItem $tempDir -Recurse).Count -gt 0) { Compress-Archive -Path (Join-Path $tempDir '*') -DestinationPath ('%output_dir%\%std_zip%') -Force; echo [OK] Structured ZIP: %output_dir%\%std_zip% } else { echo [ERROR] No files found for structured ZIP } } finally { Remove-Item $tempDir -Recurse -Force -ErrorAction 0 }"
@REM 
@REM REM ===== Package Data Version =====
@REM set "data_zip=0_Data_%date_format%.zip"
@REM powershell -Command "$files = @(Get-ChildItem -Recurse -Include *.in, *.out); if ($files.Count -gt 0) { Compress-Archive -Path $files -DestinationPath ('%output_dir%\%data_zip%') -Force; echo [OK] Data ZIP: %output_dir%\%data_zip% } else { echo [ERROR] No .in/.out files found }"

@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

REM ===== Configuration =====
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value ^| find "="') do set "datetime=%%a"
set "date_format=%datetime:~0,8%"
set "script_dir=%~dp0"
set "output_dir=%script_dir%Zips"
set "include_spj=0"

REM ===== Parameter Handling =====
if "%1" == "-s" (
    set "include_spj=1"
    echo [INFO] Including spj.cpp
) else (
    echo [INFO] Excluding spj.cpp
)

REM ===== Create Output Directory =====
if not exist "%output_dir%" (
    mkdir "%output_dir%" >nul 2>&1 || (
        echo Error: Failed to create directory "%output_dir%"
        pause
        exit /b 1
    )
)

REM ===== Structured Packaging =====
set "std_zip=0_std_%date_format%.zip"
powershell -Command "$tempDir = New-Item -Type Directory -Path (Join-Path $env:temp \"TempZip_$(Get-Random)\") -Force; try { $stdDir = New-Item -Path (Join-Path $tempDir.FullName 'std') -ItemType Directory -Force; $dataDir = New-Item -Path (Join-Path $tempDir.FullName 'data') -ItemType Directory -Force; $cppIncludes = @('std.cpp', 'gen.cpp', 'validator.cpp'); if ($env:include_spj -eq '1') { $cppIncludes += 'spj.cpp' }; $cppFiles = Get-ChildItem -Recurse -Include $cppIncludes; $dataFiles = Get-ChildItem -Recurse -Include '*.in', '*.out'; if ($cppFiles) { $cppFiles | Copy-Item -Destination $stdDir.FullName -Force }; if ($dataFiles) { $dataFiles | Copy-Item -Destination $dataDir.FullName -Force }; if ((Get-ChildItem $tempDir -Recurse).Count -gt 0) { Compress-Archive -Path (Join-Path $tempDir.FullName '*') -DestinationPath \"%output_dir%\%std_zip%\" -Force; Write-Host '[OK] Structured ZIP created: %output_dir%\%std_zip%' } else { Write-Host '[ERROR] No files found for packaging' } } finally { Remove-Item $tempDir -Recurse -Force -ErrorAction 0 }"

REM ===== Data Packaging =====
set "data_zip=0_Data_%date_format%.zip"
powershell -Command "$files = @(Get-ChildItem -Recurse -Include '*.in', '*.out'); if ($files.Count -gt 0) { Compress-Archive -Path $files -DestinationPath \"%output_dir%\%data_zip%\" -Force;  Write-Host '[OK] Data ZIP created: %output_dir%\%data_zip%' } else {  Write-Host '[ERROR] No .in/.out files found' }"
