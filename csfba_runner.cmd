@echo off

:: setlocal creates variables without polluting the outside environment
:: ENABLEDELAYEDEXPANSION allows us to use !var! syntax for variables, which comes in handy here so we can use %1 inside of !input:search=replace!
setlocal ENABLEDELAYEDEXPANSION

::all this does is copy the specialized extension to a temporary .cs file just so dotnet run recognizes it needs to compile
set runfile=run_%RANDOM%.cs
cp %1 %runfile%

:: skip the first argument, which will be the file name of the script that launched this runner
set "_args=%*"
:: !input:search=replace! 
set "_args=!_args:*%1 =!"

:: here's the beef
dotnet run %runfile% %_args%

:: clean up the temporary file
rm %runfile%

:: pids.exe is a quick util whipped up with copilot to get nested process ancestor names
:: so scripting can know whether launched from explorer.exe and hold the console open to view any output
:: github repo: https://github.com/Beej126/pids/releases
for /f %%v in ('pids.exe -name -level 3') do if "%%v" == "explorer.exe" timeout /t 5