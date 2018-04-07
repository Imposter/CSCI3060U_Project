# CSCI3060U Project Integration

## Introduction

The Front End reads in a file of items available for auction and a file containing information regarding current user accounts in the system, it processes a stream of item bidding and advertising transactions one at a time, and it writes out a file of item bidding and advertising transactions at the end of the session.

At the end of the day, the Back End reads in a file of items available for auction and a file containing information regarding current user accounts in the system, it processes a stream of item bidding and advertising transactions one at a time, and it writes out an updated user account and available item file at the end of the process.

## Setup on Windows (Cygwin)
- Open a Cygwin terminal in the project root
- Run `bootstrap.bat` to download the frontend and backend repositories, this will compile both frontend and backend

## Setup on Windows (Visual Studio)
- Open a command prompt in the project root
- Run `bootstrap.bat` to download the frontend and backend repositories, this will compile the backend, but will fail to compile the frontend
- Change directories using `cd CSCI3060U_Frontend`
- Run `bin/premake5_windows.exe --file=premake5.lua vs2017` to generate the Visual Studio 2017 project files.
- Open `build/group7.sln` and build the solution.
  * Configurations:
    * debug_win32
    * release_win32
- Copy `build/frontend.exe` to the main project root `out` folder where it will reside alongside `backend.jar`

## Running
- Use the `weekly.bat` command to run the weekly script
- Use the `auction.bat <account file> <item file> <output transactions path>` command to run the daily script manually. The `output transactions path` is the directory where the temporary transaction files will be stored. The `account file` and `item file` parameters are "self-explanatory."

## Authors
- Eyaz Rehman ([GitHub](http://github.com/Imposter))
- Rishabh Patel ([GitHub](http://github.com/RPatel97))