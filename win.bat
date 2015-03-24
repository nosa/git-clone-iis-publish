@echo off
SET GIT="C:\Program Files (x86)\Git\bin"
SET MSBUILD="C:\Program Files (x86)\MSBuild\12.0\Bin"
SET REPO_ROOT=C:\git-iis
SET REPO_DIR=%REPO_ROOT%\repo
SET CLONE_URL=https://github.com/***.git
SET SOLUTION_NAME=example-solution
SET PROJECT_NAME=example-project

SET SOLUTION_DIR=%REPO_DIR%\%SOLUTION_NAME%
SET PROJECT_DIR=%SOLUTION_DIR%\%PROJECT_NAME%

echo === GIT CLONE ===

rd /s /q %SOLUTION_DIR%

mkdir %SOLUTION_DIR%

%GIT%\git clone %CLONE_URL% %SOLUTION_DIR%

echo === RESTORE NUGET ===

copy %REPO_ROOT%\nuget.exe %SOLUTION_DIR%\nuget.exe

cd %SOLUTION_DIR%

%SOLUTION_DIR%\nuget.exe restore

echo === BUILD ===

%MSBUILD%\MSBuild /t:Rebuild /p:Configuration=Release;VisualStudioVersion=12.0

echo === PUBLISH ===

cd %PROJECT_DIR%

%MSBUILD%\MSBuild example-project.csproj /p:Configuration=Release /p:PublishProfile=example-profile /p:DeployOnBuild=true

pause
