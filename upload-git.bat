@echo off
FOR /F %%a IN ('echo prompt $E ^| cmd') DO (
  SET "ESC=%%a"
)
SET "RESET=%ESC%[0m"
SET "YELLOW=%ESC%[33m"
SET "GREEN=%ESC%[32m"
SET "RED=%ESC%[31m"

SET DEV_BRANCH=staging
SET HOST_BRANCH=deployment

IF "%~1"=="" (
  echo.
  echo %RED%Insignificant parameters%RESET%
  echo %RED%No parameters provided%RESET%
  goto:EOF
) ELSE (
  SET REPO_NAME=%~1
  SET APP_NAME=%~2
)

FOR /F "tokens=* USEBACKQ" %%F IN (`cd`) DO (
    SET BATCH_DIR=%%F
)
SET /P USERNAME="Github Username: "
SET /P TOKEN="Github Personal Access Token: "
SET CREATE_DIR=C:\Users\wesgl\OneDrive\Desktop\git testing REACT\Batch Testing\Batch\Create\
SET BUILD_APP_DIR=%CREATE_DIR%\%APP_NAME%
SET REPO_URL=https://%TOKEN%@github.com/%USERNAME%/%REPO_NAME%.git

:: IMPORTANT, check if create directory exists
cd %BUILD_APP_DIR%
echo %RED%Are you sure you want to continue, this script will attempt to delete files and folders pointed at this directory:%RESET%
echo.
echo %RED%%BUILD_APP_DIR%%RESET%
echo.
pause

CALL git init
CALL git add .
CALL git commit -m "Initial commit"

CALL curl -H "Authorization: Bearer %TOKEN%" ^
    -H "Accept: application/vnd.github.v3+json" ^
    https://api.github.com/user/repos ^
    -d "{\"name\":\"%REPO_NAME%\",\"private\":false,\"description\":\"React + Tailwind project\"}"

timeout /t 3 /nobreak > nul

echo %BLUE%Pushing to dev branch:%RESET%
CALL git remote add origin %REPO_URL%
CALL git branch -M %DEV_BRANCH%
CALL git push -u origin %DEV_BRANCH%

CALL git checkout --orphan %HOST_BRANCH%

CALL git rm -rf .
echo.
echo deleting node_modules...
rmdir /s /q node_modules

xcopy dist\* . /E /Y
timeout /t 1 /nobreak > nul
rmdir /s /q dist

echo %BLUE%Pushing to host branch:%RESET%
CALL git add .
CALL git commit -m "Deploy built site"
CALL git push origin %HOST_BRANCH%

echo.
echo %GREEN%Success!%RESET%

cd %BATCH_DIR_DIR%
