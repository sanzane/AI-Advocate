# One-time setup: verifies tools, generates Android scaffold if needed, and fetches packages.
# Run from the project root: powershell -ExecutionPolicy Bypass -File .\setup.ps1
$ErrorActionPreference = "Stop"

Write-Host "=== AI Advocate - Environment Setup ===" -ForegroundColor Cyan

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter is not on PATH. Please install Flutter from https://docs.flutter.dev/get-started/install and reopen the terminal."
}

# Ensure Android platform files exist without overwriting lib or existing config
if (-not (Test-Path "android")) {
    Write-Host "Creating Android scaffold..." -ForegroundColor Yellow
    flutter create . --platforms=android --project-name ai_advocate --org in.aiadvocate
}

# Verify permissions in AndroidManifest.xml
$manifest = "android\app\src\main\AndroidManifest.xml"
if (Test-Path $manifest) {
    $xml = Get-Content $manifest -Raw
    $changed = $false
    if ($xml -notmatch "android.permission.INTERNET") {
        $xml = $xml -replace "(<manifest[^>]*>)", "`$1`n    <uses-permission android:name=`"android.permission.INTERNET`"/>"
        $changed = $true
    }
    if ($xml -notmatch "usesCleartextTraffic") {
        $xml = $xml -replace "<application", "<application`n        android:usesCleartextTraffic=`"true`""
        $changed = $true
    }
    if ($changed) {
        Set-Content $manifest $xml -Encoding UTF8
        Write-Host "Configured AndroidManifest.xml for internet & local dev traffic." -ForegroundColor Green
    }
}

Write-Host "Fetching Flutter dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "Running Flutter static analysis..." -ForegroundColor Yellow
flutter analyze

Write-Host "Running unit and widget tests..." -ForegroundColor Yellow
flutter test

Write-Host "`nSetup complete! You can now run the app on an Android device or emulator:" -ForegroundColor Green
Write-Host "  flutter run" -ForegroundColor Cyan
