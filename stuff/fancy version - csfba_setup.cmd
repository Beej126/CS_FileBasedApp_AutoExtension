@echo off

setlocal
set newextension=.csfba
set newfiletype=CS_FileBasedApp_Script

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

(for /f "delims=" %%v in ('where ProcessInfo.exe') do set pinfopath=%%v) || (call :pinfo_not_found & (call findbin && set pinfopath=%bin% || (echo aborting & goto :EOF)) )
echo downloading latest ProcessInfo.exe to %pinfopath%
curl -L -o "ProcessInfo.exe" $downloadUrl


echo,
echo to enable vscode to recognize .cscr files as csharp (syntax highlighting, etc)
echo add this to your vscode settings.json:
echo,
echo     "files.associations": {
echo        "*%newextension%": "csharp"
echo    }
echo,

echo DONE =)
pause

goto :EOF

:pinfo_not_found
  echo,
  echo ProcessInfo.exe not found in path.
  echo,
  echo the "csfba_runner.cmd" script leverages a free tool called ProcessInfo.exe
  echo   github repo: 
  echo   this faciltates the script determining whether it was launched from file explorer (vs interactive command line)
  echo   and therefore it can include a timeout before closing the terminal window, to provide a convenient pause for viewing any output
  echo,
  echo of course if you're not interested just patch these scripts up however you prefer
  echo,
  echo otherwise please choose an appropriate "bin" folder where ProcessInfo.exe will be placed
  echo and this will also be added to your user's global %%PATH%%
  echo,
  echo subsequent runs of this script will download the latest ProcessInfo.exe build to that location
return