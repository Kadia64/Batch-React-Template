@echo off
for /F %%a in ('echo prompt $E ^| cmd') do (
  SET "ESC=%%a"
)
FOR /F "tokens=* USEBACKQ" %%F IN (`cd`) DO (
    SET BATCH_DIR=%%F
)

SET "RESET=%ESC%[0m"
SET "YELLOW=%ESC%[33m"
SET "GREEN=%ESC%[32m"
SET "RED=%ESC%[31m"

IF "%~1"=="" (
    echo.
    echo %RED%Insignificant parameters%RESET%
    echo %RED%No parameters provided!%RESET%
    goto:EOF

) ELSE (
    :: else get the parameters from create-react-template.bat
    SET REPO_NAME=%~1
)

SET DEV_BRANCH=staging
SET HOST_BRANCH=deployment
SET USERNAME=Kadia64
SET EDITING_DIR=C:\Users\wesgl\OneDrive\Desktop\git testing REACT\Batch Testing\Batch\Edit
SET /P TOKEN="Github Personal Access Token: "
SET GIT_REPO=https://%TOKEN%@github.com/%USERNAME%/%REPO_NAME%.git

:: check if editing directory exists
cd %EDITING_DIR%
CALL git clone -b %DEV_BRANCH% %GIT_REPO%
cd %REPO_NAME%

echo.
echo %BLUE%--- instlaling npm ---%RESET%
CALL npm install

echo.
echo %YELLOW%Please make your changes...%RESET%
pause

:: MAKE CHANGES HERE

echo %GREEN%~~~about to build your project~~~%RESET%
CALL npm run build

cd %EDITING_DIR%\%REPO_NAME%

echo.
echo %BLUE%Pushing to dev branch:%RESET%
CALL git add .
CALL git commit -m "Updated the source code"
CALL git push origin %DEV_BRANCH%

CALL git fetch origin %HOST_BRANCH%:%HOST_BRANCH%
CALL git checkout %HOST_BRANCH%

echo.
echo deleting node_modules...
:: check if node_modules folder exist
rmdir /s /q node_modules

:: check if assets folder exists
rmdir /s /q assets
timeout /t 1 /nobreak > nul
xcopy dist\* . /E /Y
timeout /t 1 /nobreak > nul
:: check if dist folder exists
rmdir /s /q dist

echo %BLUE%Pushing to host branch:%RESET%
CALL git add .
CALL git commit -m "Updated the deploy code"
CALL git push origin %HOST_BRANCH%

::CALL git checkout %DEV_BRANCH%

echo %GREEN%Successfully upated your github repoistory!%RESET%

cd %BATCH_DIR%