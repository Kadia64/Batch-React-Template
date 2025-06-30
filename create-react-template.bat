@echo off
for /F %%a in ('echo prompt $E ^| cmd') do (
  SET "ESC=%%a"
)
FOR /F "tokens=* USEBACKQ" %%F IN (`cd`) DO (
    SET BATCH_DIR=%%F
)

:: DEFINE VARIABLES
SET "RESET=%ESC%[0m"
SET "BOLD=%ESC%[1m"
SET "UNDERLINE=%ESC%[4m"
SET "INVERSE=%ESC%[7m"
SET "RED=%ESC%[31m"
SET "GREEN=%ESC%[32m"
SET "BLUE=%ESC%[34m"
SET "YELLOW=%ESC%[33m"
SET "CYAN=%ESC%[36m"

SET POSTCSS_FILENAME=postcss.config.js
SET TEMPLATE_DIR=C:\Users\wesgl\OneDrive\Desktop\git testing REACT\Batch Testing\Batch Templates\Template
SET CREATE_DIR=C:\Users\wesgl\OneDrive\Desktop\git testing REACT\Batch Testing\Batch\Create
SET APP_JSX=%TEMPLATE_DIR%\App.jsx
SET INDEX_CSS=%TEMPLATE_DIR%\index.css
SET MAIN_JSX=%TEMPLATE_DIR%\main.jsx
SET POSTCSS=%TEMPLATE_DIR%\postcss.config.js
SET TAILWIND=%TEMPLATE_DIR%\tailwind.config.js

echo.
echo Please use all lowercase letters with no spaces
SET /P APP_NAME="Application Name: "


:: somehow check if the github repo already exists, or have ai do that
echo.
echo Non-case-sensitive, no spaces
SET /P REPO_NAME="Github Repository Name: "
FOR /f "usebackq" %%i in (`powershell -command "'%APP_NAME%'.ToLower()"`) DO SET APP_NAME=%%i
echo  %YELLOW%React Application Name: %APP_NAME%%RESET%
echo  %YELLOW%Github Repository Name: %REPO_NAME%%RESET%

SET APP_DIR=%CREATE_DIR%\%APP_NAME%

:: make sure create directory exists
cd %CREATE_DIR%

echo.
echo %BLUE%--- creating the react template ---%RESET%
CALL npm create vite@latest %APP_NAME% -- --template react
cd %APP_NAME%

echo.
echo %BLUE%--- instlaling npm ---%RESET%
CALL npm install

echo.
echo %BLUE%--- installing lucide library ---%RESET%
CALL npm install lucide-react

echo.
echo %BLUE%--- instlling tailwind framework ---%RESET%
CALL npm install -D tailwindcss@3 postcss autoprefixer

echo.
echo %BLUE%--- creating tailwind config file ---%RESET%
CALL npx tailwindcss init


:: COPY AND PASTE FROM TEMPLATES

echo Creating postcss.config.js
cd %APP_DIR%
type nul > postcss.config.js
(
echo import { defineConfig } from 'vite'
echo import react from '@vitejs/plugin-react'
echo.
echo export default defineConfig^(^{
echo   plugins: [react^(^)],
echo   base: '/%REPO_NAME%/'
echo }^)
) > vite.config.js

:: make sure template folder exists
:: make sure each template file exists
echo %GREEN%Copying tailwind.config.js%RESET%
COPY /Y "%TAILWIND%" "%APP_DIR%\tailwind.config.js"

echo %GREEN%Copying postcss.config.js%RESET%
COPY /Y "%POSTCSS%" "%APP_DIR%\postcss.config.js"

echo %GREEN%Copying main.jsx%RESET%
COPY /Y "%MAIN_JSX%" "%APP_DIR%\src\main.jsx"

echo %GREEN%Copying index.css%RESET%
COPY /Y "%INDEX_CSS%" "%APP_DIR%\src\index.css"

echo %GREEN%Copying app.jsx%RESET%
COPY /Y "%APP_JSX%" "%APP_DIR%\src\App.jsx"

:: UPLOAD YOUR CODE HERE

echo.
echo %YELLOW%Please make your changes%RESET%
echo %YELLOW%Waiting for confirmation...%RESET%
pause

echo %GREEN%~~~building your project~~~%RESET%
CALL npm run build

cd %BATCH_DIR%
CALL upload-git.bat "%REPO_NAME%" "%APP_NAME%"

cd %BATCH_DIR%

GOTO:EOF