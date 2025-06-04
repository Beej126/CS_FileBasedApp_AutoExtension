# CS_FileBasedApp_AutoExtension
sets up auto-run extension for new dotnet v10 "file based app" scripts<br/>
<br/>
basically sortof a "shebang" for Windows (easily adapted to script engines other than "dotnet run" demonstrated here)

# install
- just clone the repo
- and run the csfba_setup.cmd

# background
- see msft launch video: https://devblogs.microsoft.com/dotnet/announcing-dotnet-run-app/
- presenter touched on how we don't have "shebang" on Windows...
- with a little scripting orchestration provided here, we can have that basic convenience
- the setup maps .fba (for file-based-app) to a runner script
  - feel free to change to your preferred extension at the top of the setup
  - but it's very important that the **extension must be no more than 3 characters**! otherwise a longstanding powershell bug (looking at you msft =) opens a separate console window
- the runner script is the basic trick and it's very simple: **it merely copies the .fba to a .cs file so dotnet run is happy to compile it**
- this enables launching .fba files without `dotnet run` boilerplate nor file extension from console (powershell, pwsh, cmd) as well as file explorer double click
- arguments will be passed
- the custom extension is configured with a representative icon so our scripts stand out nicely in a folder
- <mark>the setup and the script runner each call upon cli tools (setxx.exe and pids.exe) with repo sources provided in their comments</mark>
  - setxx.exe is a more robust tool like native setx... nicely handles otherwise sticky stuff related to setting global environment variables: simple add/remove by value, user vs system (with built in UAC elevation), option to uppercase the value... bing copilot banged it into shape over a few hours... i wish i had a tool like this decades ago! =)
  - the runner leverages pids.exe to know if it was launched via file explorer so it can keep the console open via timeout as a convenience to view any output... if this isn't important to you, feel free to drop the pids.exe dependency

![image](https://github.com/user-attachments/assets/d6357c27-c9d5-49f5-92a3-c96718a97052)
