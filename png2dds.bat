::::----------------------------------------------------::::
:::: png2dds
::::----------------------------------------------------::::
@title png2dds
@echo off
setlocal EnableDelayedExpansion
pushd
cd %~dp0

::::デバッグモード
::::TRUEの場合，対象ファイルを同階層にファイル名.tmpという形式で残します．
set DEBUG_MODE=FALSE
::::バッチモード
::::TRUEの場合，文字列置換をDOSコマンドのみでおこないます．
::::PowerShellと比較して実行速度が落ちます．
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
::::このバッチの階層下のxファイルを読み取り，ファイル中の「png」を「dds」に置換します．
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
::::PowerShellを経由して，テキストファイル中の文字列を置換します．
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
::::Batコマンドのみを使用して，テキストファイル中の文字列を置換します．
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
:::: 1.DDS化したいシナリオファイル内にこのスクリプトファイルを置く
:::: 2.コマンドプロンプトを起動する
:::: 3.png2dds.batで実行する
:::: 
:::: option:
:::: /c pngをddsに変換する
:::: /d ddsに変換後,pngファイルを削除する
:::: /r .xファイルのpngをddsに置換する
::::====================================================::::
:::: @Tn_E235