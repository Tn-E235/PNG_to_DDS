::::----------------------------------------------------::::
:::: png2dds
::::----------------------------------------------------::::
@title png2dds
@echo off
setlocal EnableDelayedExpansion
pushd
cd %~dp0

::::�f�o�b�O���[�h
::::TRUE�̏ꍇ�C�Ώۃt�@�C���𓯊K�w�Ƀt�@�C����.tmp�Ƃ����`���Ŏc���܂��D
set DEBUG_MODE=FALSE
::::�o�b�`���[�h
::::TRUE�̏ꍇ�C������u����DOS�R�}���h�݂̂ł����Ȃ��܂��D
::::PowerShell�Ɣ�r���Ď��s���x�������܂��D
set BAT_MODE=FALSE

set TARGET="png"
set RP_WORD="dds"
set quality="dxt5"
set IMAGE_DELETE=FALSE
set IMAGE_CONVERT=FALSE
set REPLACE=FALSE

:SETTING
    call :ARG %1
    call :ARG %2
    call :ARG %3
    echo -----------------------------------
    echo IMAGE_CONVERT = %IMAGE_CONVERT%
    echo IMAGE_DELETE  = %IMAGE_DELETE%
    echo REPLACE       = %REPLACE%
    echo quality       = %quality%
    echo -----------------------------------
    set STR=
    set /P STR="continue?(Y/n): "
    if "%STR%"=="n" (
        echo exit
        exit /B
    )

:MAIN
::::Read x files, replace string from 'png' to 'dds'.
::::���̃o�b�`�̊K�w����x�t�@�C����ǂݎ��C�t�@�C�����́upng�v���udds�v�ɒu�����܂��D
    if "%DEBUG_MODE%"=="TRUE" (
        echo ^^!^^!DEBUGGING^^!^^!
    )
    if "%BAT_MODE%"=="TRUE" (
        echo ^^!^^!RUNNING IN BAT MODE^^!^^!
    )
    
    if "%IMAGE_CONVERT%"=="TRUE" (
        echo Convert png to dds ...
        for /F %%i in ('dir /B /S /A:-D *.png') do (
            set PNG_PATH=%%i
            set DDS_PATH=!PNG_PATH:.png=.dds!
            echo !PNG_PATH!
            echo !DDS_PATH!
            magick.exe !PNG_PATH! -define dds:compression=%quality%,dds:cluster-fit=true,dds:weight-by-alpha=true,dds:fast-mipmaps=true !DDS_PATH!
            if "%IMAGE_DELETE%"=="TRUE" (
                del !PNG_PATH!
            )
        )
        echo Completed convert
    )

    if "%REPLACE%"==TRUE (
        for /F %%i in ('dir /B /S /A:-D *.x') do (
            echo Replacing ... %%i
            copy %%~fi %%~dpni.tmp > nul
            if "%BAT_MODE%"=="FALSE" (
                call :REPLACE_STR %%i "png" "dds"
            ) else (
                call :REPLACE_STR_BAT %%i "png" "dds"
            )
        )
        echo.
        echo Completed replace string^^!^^!
        popd
    )

    pause
    exit /B

:REPLACE_STR
::::Replace string in text file, via Get-Content command of powershell.
::::PowerShell���o�R���āC�e�L�X�g�t�@�C�����̕������u�����܂��D
::::ARG 1: file path
::::ARG 2: source string
::::ARG 3: destination string
    copy %~f1 %~dpn1.tmp > nul
    powershell -Command "(gc %~f1) -replace '%~2', '%~3' | Out-File -encoding ASCII %~f1
    if "%DEBUG_MODE%"=="FALSE" (
        del %~dpn1.tmp
    )
    exit /B

:REPLACE_STR_BAT
::::Replace string in text file, only using bat command.
::::Bat�R�}���h�݂̂��g�p���āC�e�L�X�g�t�@�C�����̕������u�����܂��D
::::ARG 1: file path
::::ARG 2: source string
::::ARG 3: destination string
    setlocal
    copy %~f1 %~dpn1.tmp > nul
    type nul > %~f1
    for /F "tokens=* delims=0123456789 eol=" %%j in ('findstr /n "^" %~dpn1.tmp') do (
        set LINE=%%j
        set REPLACED=!LINE:%~2=%~3!
        echo.!REPLACED:~1!>> %~f1
    )
    if "%DEBUG_MODE%"=="FALSE" (
        del %~dpn1.tmp
    )
    endlocal
    exit /B

:ARG
    if "%~1"=="/d" (
        set IMAGE_DELETE=TRUE
    )
    if "%~1"=="/c" (
        set IMAGE_CONVERT=TRUE
    )
    if "%~1"=="/r" (
        set REPLACE=TRUE
    )
    exit /B
::::====================================================::::
:::: USAGE:
:::: 1.DDS���������V�i���I�t�@�C�����ɂ��̃X�N���v�g�t�@�C����u��
:::: 2.�R�}���h�v�����v�g���N������
:::: 3.png2dds.bat�Ŏ��s����
:::: 
:::: option:
:::: /c png��dds�ɕϊ�����
:::: /d dds�ɕϊ���,png�t�@�C�����폜����
:::: /r .x�t�@�C����png��dds�ɒu������
::::====================================================::::
:::: @Tn_E235