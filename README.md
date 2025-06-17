# CS_FileBasedApp_AutoExtension
sets up auto-run extension for new dotnet v10 "file based app" scripts<br/>
<br/>
basically sortof a "shebang" for Windows<br/>
(this general approach is readily applicable to any script engine you need, not just the "dotnet run" example here)<br/>
<br/>
this enables launching .fba files
1. from file explorer double click
1. and without needing `dotnet run` in consoles (powershell, pwsh, cmd)
1. nor needing to provide the file extension in consoles

<img src="https://github.com/user-attachments/assets/d6357c27-c9d5-49f5-92a3-c96718a97052" width="500" />

# install
- just clone the repo
- and run the csfba_setup.cmd

# background
- see msft launch video: https://devblogs.microsoft.com/dotnet/announcing-dotnet-run-app/
- presenter touched on how we don't have convenience of linux "[shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))" on Windows...
- yet we actually can with a little scripted orchestration as provided here<br/><br/>
- the setup maps .fba (for file-based-app) to a runner script
  - feel free to change to your preferred extension at the top of the setup script
  - but make sure your **extension is no more than 3 characters** - otherwise a [longstanding bug in traditional powershell](https://stackoverflow.com/questions/16336512/on-windows-are-there-restrictions-on-extensions-that-can-be-used-in-pathext) opens a separate console process/window... and i believe i still saw this happening even under pwsh<br/><br/>
- the core "trick" of the runner script is very simple: **it temporarily copies the .fba file to a .cs file so dotnet run is happy to compile it** =)<br/><br/>
- arguments will be passed
- due to adding .fba to %PATHEXT%, they will execute from anywhere in your %PATH%, just like .bat, et al
- the custom extension is configured with a representative icon so our scripts stand out nicely in a folder
- <mark>the setup and the script runner each call upon cli tools (setxx.exe and pids.exe) with repo sources provided in their comments</mark>
  - setxx.exe is a more robust tool like native setx... nicely handles otherwise sticky stuff related to setting global environment variables: simple add/remove by value, user vs system (with built in UAC elevation), option to uppercase the value... bing copilot banged it into shape over a few hours... i wish i had a tool like this decades ago! =)
  - the runner leverages pids.exe to know if it was launched via file explorer so it can keep the console open via timeout as a convenience to view any output... if this isn't important to you, feel free to drop the pids.exe dependency
