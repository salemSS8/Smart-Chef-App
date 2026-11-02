param(
    [string]$Version = "v1.0.0"
)

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "   Smart Cook (طاهي ذكي) - APK Builder & Releaser    " -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan

# 1. Build Signed & Obfuscated Release APK
Write-Host "`n[1/3] جاري بناء وتشفير ملف الـ APK الرسمي..." -ForegroundColor Yellow
C:\flutter\bin\flutter.bat build apk --release --obfuscate --split-debug-info=build/debug-info

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ فشل بناء الـ APK. يرجى مراجعة الأخطاء أعلاه." -ForegroundColor Red
    exit 1
}

# 2. Rename to Smart-Cook.apk
$sourceApk = "build\app\outputs\flutter-apk\app-release.apk"
$targetApk = "build\app\outputs\flutter-apk\Smart-Cook.apk"
Copy-Item -Path $sourceApk -Destination $targetApk -Force

$apkSizeMB = [math]::Round((Get-Item $targetApk).Length / 1MB, 2)
Write-Host "✅ تم تجهيز الملف بنجاح: $targetApk ($apkSizeMB MB)" -ForegroundColor Green

# 3. Push Tag to trigger GitHub Release
Write-Host "`n[2/3] هل ترغب برفع الكود وإنشاء إصدار GitHub Release ($Version) تلقائياً؟" -ForegroundColor Yellow
git add .
git commit -m "chore(release): prepare Smart Cook $Version release"
git tag -f $Version
git push origin HEAD
git push origin $Version --force

Write-Host "`n🎉 تم الإرسال إلى GitHub بنجاح!" -ForegroundColor Green
Write-Host "🔗 رابط الإصدارات: https://github.com/salemSS8/Smart-Chef-App/releases" -ForegroundColor Cyan
Write-Host "🔗 رابط التحميل في موقعك الشخصي: https://bashnddof.vercel.app/api/mobile-apps/download?slug=smart-cook" -ForegroundColor Cyan

