@echo off

:: Global variables
set RETURN_CODE=0

:: Clear screen
cls

:: Print information
echo "Cloning Frontend and Backend from remote git repositories"
echo "Credentials may be required if the repositories are private!"

:: Remove any previous copies of the frontend or backend
rmdir /s /q CSCI3060U_Frontend >NUL 2>&1
rmdir /s /q CSCI3060U_Backend >NUL 2>&1

:: Clone repositories
git clone https://github.com/Imposter/CSCI3060U_Frontend
git clone https://github.com/Imposter/CSCI3060U_Backend

:: Build Frontend
echo "Building Frontend using Cygwin/Clang..."
cd CSCI3060U_Frontend
".\\bin\\premake5_windows.exe" --file=premake5.lua gmake
cd build
make config=release all
if errorlevel 1 (
    :: An error occurred while building the frontend
    echo "The frontend failed to build"
    echo:
    set RETURN_CODE=1
    goto end
)
echo "The frontend build completed successfully!"
cd ../..

:: Build Backend
echo "Building Backend using Gradle/Java..."
cd CSCI3060U_Backend
call ".\\gradlew.bat" build
if errorlevel 1 (
    :: An error occurred while building the backend
    echo "The backend failed to build"
    echo:
    set RETURN_CODE=1
    goto end
)
echo "The backend build completed successfully!"
cd ..

:: Remove any previous copies of the frontend or backend
rmdir /s /q out >NUL 2>&1
mkdir out

:: Copy programs
copy /b "CSCI3060U_Frontend\\build\\frontend.exe" "out\\frontend.exe" >NUL 2>&1
copy /b "CSCI3060U_Backend\\build\\libs\\CSCI3060U_Backend.jar" "out\\backend.jar" >NUL 2>&1

echo "The programs can be found in the 'out' directory"

:end
    :: Return to project root folder
    cd ..

    :: Exit with specified code
    exit /b %RETURN_CODE%