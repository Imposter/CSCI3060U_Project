:: Weekly Auction Program
:: May be invoked with the following parameters: 
:: weekly.bat <optional: daily input commands path>

@echo off

:: Evaluate local variables on execution
setlocal EnableDelayedExpansion

:: Global variables
set RETURN_CODE=0

set DATA_PATH=.\\data
set ACCOUNTS_FILE=%DATA_PATH%\\accounts.txt
set ITEMS_FILE=%DATA_PATH%\\items.txt
set TRANSACTIONS_PATH=%DATA_PATH%\\transactions\\

set RUN_LIMIT=5
set WAIT_TIME=5

:: Check if files exist
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

:run_auction
    :: Create paths
    mkdir /q %TRANSACTIONS_PATH% >NUL 2>&1

    :: Run auction N times
    for /l %%i in (1,1,%RUN_LIMIT%) do (
       :: Run without commands file
        echo Running auction for day %%i without input commands file
        PING localhost -n %WAIT_TIME% >NUL

        call ".\\auction.bat" %ACCOUNTS_FILE% %ITEMS_FILE% %TRANSACTIONS_PATH%
        if errorlevel 1 (
            :: An error occurred while running the auction
            echo An error occurred while running the auction
            echo:
            set RETURN_CODE=1
            goto end
        )     
        
        :: Clear screen
        cls
    )

:end
    :: Restore local variable evaluation
    endlocal
    
    exit /b %RETURN_CODE%