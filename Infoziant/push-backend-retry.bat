@echo off
REM Auto-retry Docker push with timeout handling

set IMAGE=venkatarupesh123/vehiclevault-backend:latest
set MAX_RETRIES=5
set RETRY_COUNT=0

echo 🚀 Pushing %IMAGE% with auto-retry...
echo.

:retry
set /a RETRY_COUNT+=1
echo [Attempt %RETRY_COUNT%/%MAX_RETRIES%] Pushing to Docker Hub...
echo.

docker push %IMAGE%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ SUCCESS! Image pushed to Docker Hub!
    echo View at: https://hub.docker.com/r/venkatarupesh123/vehiclevault-backend
    goto :end
)

if %RETRY_COUNT% GEQ %MAX_RETRIES% (
    echo.
    echo ❌ FAILED after %MAX_RETRIES% attempts
    echo.
    echo Troubleshooting tips:
    echo 1. Check your internet connection
    echo 2. Restart Docker Desktop
    echo 3. Try again later
    goto :end
)

echo.
echo ⚠️ Push failed. Retrying in 10 seconds...
timeout /t 10 /nobreak >nul
echo.
goto :retry

:end
pause
