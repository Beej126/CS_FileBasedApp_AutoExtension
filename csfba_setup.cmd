@echo off

rem ENABLEDELAYEDEXPANSION so we can use !path! below which avoids a weird error from expanding path prematurely
setlocal ENABLEDELAYEDEXPANSION

rem **** very important: extension must be 3 characters or powershell will open a new console!!
set newextension=.fba
set newfiletype=CS_FileBasedApp_Script

echo,
echo adding HKEY_CURRENT_USER registry entries to define new %newextension% file extension...
echo,

echo creating new file type "%newfiletype%"
:: this description shows up in file explorer properties, hover, etc
reg add "HKEY_CURRENT_USER\Software\Classes\%newfiletype%" /f /ve /t REG_SZ /d "dotnet v10 scripted c#"
echo,

echo setting icon for new file type
reg add "HKEY_CURRENT_USER\Software\Classes\%newfiletype%\DefaultIcon" /f /ve /t REG_SZ /d "%~dp0csfba.ico,0"
echo,

echo setting shell open command for new file type
reg add "HKEY_CURRENT_USER\Software\Classes\%newfiletype%\shell\open\command" /f /ve /t REG_SZ /d "\"%~dp0csfba_runner.cmd\" \"%%1\" \"%%*\""
echo,

echo creating %newextension% file extension mapped to new file type
reg add "HKEY_CURRENT_USER\Software\Classes\%newextension%" /f /ve /t REG_SZ /d %newfiletype%
echo,

echo adding %newextension% to system %%PATHEXT%% variable ^(i.e. auto execute without providing extension, just like .bat, etc^)
echo   apparently PATHEXT doesn't auto-combine like PATH so we modify the singular system version
rem setxx is a safe windows variable setting tool i whipped up with copilot in golang, could've used this years ago!!
rem github repo: https://github.com/Beej126/setxx/releases
rem -s means system var
rem -u upper cases the value
setxx -s -u add %newextension% pathext
echo,

echo adding this folder to user %%PATH%% so ProcessInfo.exe can be found by runner script
setxx add %~dp0 path
echo,

echo,
echo to enable vscode to recognize %newextension% files as csharp ^(syntax highlighting, etc^)
echo add this to your vscode settings.json:
echo,
echo     "files.associations": {
echo        "*%newextension%": "csharp"
echo    }
echo,

echo DONE =)
pause
