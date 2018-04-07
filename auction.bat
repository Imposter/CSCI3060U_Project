:: Daily Auction Program
:: Must be invoked with the following parameters: 
:: auction.bat <account file> <item file> <output transactions path>

@echo off

:: Global variables
set RETURN_CODE=0

set ACCOUNTS_FILE=%1
set ITEMS_FILE=%2
set TRANSACTIONS_PATH=%3

set RUN_COUNT=0

:: Check if the parameters are valid
if not exist %ACCOUNTS_FILE% (
    echo Accounts file %ACCOUNTS_FILE% does not exist
    set RETURN_CODE=1
    goto end
)

if not exist %ITEMS_FILE% (
    echo Items file %ITEMS_FILE% does not exist
    set RETURN_CODE=1
    goto end
)

if not exist %TRANSACTIONS_PATH% (
    echo Transactions path %TRANSACTIONS_PATH% does not exist
    set RETURN_CODE=1
    goto end
)

:: Empty transactions directory
del /s /q "%TRANSACTIONS_PATH%\\*" >NUL 2>&1

:: Wait for a session to begin
:wait_for_session
    :: Clear screen
    cls

    echo To proceed to begin a session:
    pause

    :: Clear screen
    cls

    :: Print information
    echo Welcome to the Auction Service System!
    echo Use the '?' command to get a list of available commands
    echo Use the 'exit' command once you have finished with your session
    echo:

    :: Start frontend
    set /a RUN_COUNT=RUN_COUNT+1
    ".\\out\\frontend.exe" %ACCOUNTS_FILE% %ITEMS_FILE% "%TRANSACTIONS_PATH%\\transaction_%RUN_COUNT%.ftf"

:: Ask if another session should be run or is it the end of the day
:ask_again
    set INPUT=
    set /p INPUT="Is it the end of the day? [y/N]: "
    if "%INPUT%"=="" (
        :: Default, start a new session
        goto wait_for_session
    ) else if /i "%INPUT%"=="n" (
        :: Start a new session
        goto wait_for_session
    ) else if /i "%INPUT%"=="y" (
        :: Run the backend
        goto run_backend
    ) else (
        :: Invalid input, ask again
        goto ask_again
    )

:run_backend
    :: Clear screen
    cls

    echo Merging transaction files

    :: Merge every file
    copy /b "%TRANSACTIONS_PATH%\\*.ftf" "%TRANSACTIONS_PATH%\\out.ftf" >NUL 2>&1

    :: Run backend
    echo Running backend
    java -jar ".\\out\\backend.jar" %ACCOUNTS_FILE% %ITEMS_FILE% "%TRANSACTIONS_PATH%\\out.ftf"
    if errorlevel 1 (
        :: An error occurred while running the backend
        echo An error occurred while running the backend
        echo:
        set RETURN_CODE=1
        goto end
    )

:end
    exit /b %RETURN_CODE%