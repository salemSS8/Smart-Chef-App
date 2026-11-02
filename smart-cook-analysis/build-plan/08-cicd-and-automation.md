# 08 — CI/CD والأتمتة

> **المدة المُقدَّرة:** 3–4 أيام
> **يعتمد على:** الملف 07 (الاختبارات)
> **الأولوية:** 🟠 متوسطة — مهمة للجودة المستمرة

---

## 1. نظرة عامة على الخط الأنبوبي (Pipeline)

```
Push/PR → التحليل → الاختبارات → البناء → التوقيع → التوزيع
   │         │          │          │         │          │
   │     dart analyze  unit tests  APK/IPA  keystore  TestFlight
   │     dart format   widget     AAB      signing   Play Internal
   │     lint          golden               profiles
   │                   integration
```

---

## 2. GitHub Actions — الإعداد

### 2.1 Workflow: التحليل والاختبار (كل PR)

```yaml
# .github/workflows/ci.yml

name: CI - Analysis & Tests

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [develop]

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  analyze:
    name: 🔍 Analyze
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.x'   # ← ثبّت الإصدار
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Check formatting
        run: dart format --set-exit-if-changed .

      - name: Analyze
        run: flutter analyze --fatal-infos

  test:
    name: 🧪 Tests
    runs-on: ubuntu-latest
    needs: analyze
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.x'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Run unit & widget tests
        run: flutter test --coverage

      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | sed 's/%//')
          echo "Coverage: $COVERAGE%"
          if (( $(echo "$COVERAGE < 70" | bc -l) )); then
            echo "❌ Coverage below 70%!"
            exit 1
          fi

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          file: coverage/lcov.info
```

### 2.2 Workflow: البناء (عند الدمج في main)

```yaml
# .github/workflows/build.yml

name: Build & Deploy

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  build-android:
    name: 🤖 Android Build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.x'
          cache: true

      - uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Decode keystore
        env:
          KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}
        run: echo "$KEYSTORE_BASE64" | base64 -d > android/app/keystore.jks

      - name: Build AAB (Production)
        env:
          STORE_PASSWORD: ${{ secrets.ANDROID_STORE_PASSWORD }}
          KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
          KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
        run: |
          flutter build appbundle \
            --flavor prod \
            -t lib/main_prod.dart \
            --release \
            --obfuscate \
            --split-debug-info=build/debug-info

      - name: Upload AAB
        uses: actions/upload-artifact@v4
        with:
          name: android-release
          path: build/app/outputs/bundle/prodRelease/app-prod-release.aab

      - name: Upload debug symbols
        uses: actions/upload-artifact@v4
        with:
          name: debug-symbols
          path: build/debug-info/

  build-ios:
    name: 🍎 iOS Build
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.x'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Install CocoaPods
        run: cd ios && pod install

      - name: Build IPA
        run: |
          flutter build ipa \
            --flavor prod \
            -t lib/main_prod.dart \
            --release \
            --obfuscate \
            --split-debug-info=build/debug-info \
            --export-options-plist=ios/ExportOptions.plist

      - name: Upload IPA
        uses: actions/upload-artifact@v4
        with:
          name: ios-release
          path: build/ios/ipa/*.ipa
```

---

## 3. Fastlane — التوزيع

### 3.1 إعداد Android

```ruby
# android/fastlane/Fastfile

default_platform(:android)

platform :android do
  desc "رفع إلى Google Play Internal Testing"
  lane :internal do
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/prodRelease/app-prod-release.aab',
      json_key_data: ENV['PLAY_STORE_JSON_KEY'],
      package_name: 'com.smartcook.app',
    )
  end

  desc "ترقية من Internal إلى Beta"
  lane :beta do
    upload_to_play_store(
      track: 'beta',
      track_promote_to: 'beta',
      json_key_data: ENV['PLAY_STORE_JSON_KEY'],
      package_name: 'com.smartcook.app',
    )
  end

  desc "ترقية من Beta إلى Production (إطلاق تدريجي)"
  lane :production do
    upload_to_play_store(
      track: 'production',
      rollout: '0.1',  # 10% أولًا
      json_key_data: ENV['PLAY_STORE_JSON_KEY'],
      package_name: 'com.smartcook.app',
    )
  end
end
```

### 3.2 إعداد iOS

```ruby
# ios/fastlane/Fastfile

default_platform(:ios)

platform :ios do
  desc "رفع إلى TestFlight"
  lane :testflight_upload do
    upload_to_testflight(
      ipa: '../build/ios/ipa/SmartCook.ipa',
      api_key_path: 'fastlane/AuthKey.json',
      skip_waiting_for_build_processing: true,
    )
  end

  desc "رفع إلى App Store"
  lane :release do
    upload_to_app_store(
      ipa: '../build/ios/ipa/SmartCook.ipa',
      api_key_path: 'fastlane/AuthKey.json',
      submit_for_review: true,
      automatic_release: false,
      phased_release: true,
    )
  end
end
```

---

## 4. الأسرار (Secrets)

### 4.1 ما يُخزَّن في GitHub Secrets

```
# Android
ANDROID_KEYSTORE_BASE64     # Keystore مشفر بـ Base64
ANDROID_STORE_PASSWORD      # كلمة مرور المخزن
ANDROID_KEY_PASSWORD         # كلمة مرور المفتاح
ANDROID_KEY_ALIAS           # اسم المفتاح
PLAY_STORE_JSON_KEY         # مفتاح API لـ Google Play

# iOS
APP_STORE_CONNECT_API_KEY   # مفتاح App Store Connect
MATCH_PASSWORD              # إن استخدمت fastlane match

# Supabase
SUPABASE_URL_PROD           # URL الإنتاج
SUPABASE_ANON_KEY_PROD      # مفتاح مجهول للإنتاج

# أخرى
CODECOV_TOKEN               # لرفع تقرير التغطية
```

---

## 5. Feature Flags (Remote Config)

### 5.1 باستخدام Supabase

```sql
-- جدول بسيط لـ Feature Flags
CREATE TABLE feature_flags (
  key TEXT PRIMARY KEY,
  enabled BOOLEAN DEFAULT FALSE,
  rollout_percent INT DEFAULT 0,      -- 0-100
  platforms TEXT[] DEFAULT '{all}',    -- android, ios, all
  min_version TEXT,
  description TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);

INSERT INTO feature_flags VALUES
  ('ai_inspire', false, 0, '{all}', '1.5.0', 'ميزة ألهمني بالذكاء الاصطناعي'),
  ('fridge_camera', false, 0, '{all}', '1.5.0', 'تصوير الثلاجة'),
  ('meal_plan', false, 0, '{all}', '2.0.0', 'مخطط الوجبات');
```

### 5.2 استخدام في الكود

```dart
// core/services/feature_flags.dart

@riverpod
class FeatureFlags extends _$FeatureFlags {
  @override
  Future<Map<String, bool>> build() async {
    try {
      final response = await ref.read(supabaseProvider)
          .from('feature_flags')
          .select()
          .eq('enabled', true);

      return {
        for (final flag in response)
          flag['key'] as String: _shouldEnable(flag),
      };
    } catch (_) {
      return {}; // افتراضي: كل شيء معطل
    }
  }

  bool isEnabled(String key) => state.value?[key] ?? false;
}

// الاستخدام في الشاشات:
if (ref.watch(featureFlagsProvider).isEnabled('ai_inspire')) {
  // عرض زر «ألهمني»
}
```

---

## 6. إدارة الإصدارات

### 6.1 قاعدة Semantic Versioning

```
MAJOR.MINOR.PATCH+BUILD
  │     │     │      │
  │     │     │      └── رقم البناء (يزيد دائمًا): 1, 2, 3...
  │     │     └── إصلاحات أخطاء: 1.0.1
  │     └── ميزات جديدة: 1.1.0
  └── تغييرات كبيرة: 2.0.0
```

### 6.2 سكربت تحديث الإصدار

```powershell
# scripts/bump_version.ps1
param(
    [Parameter(Mandatory)][ValidateSet('major','minor','patch')]
    [string]$BumpType
)

$pubspec = Get-Content "pubspec.yaml" -Raw
$currentVersion = [regex]::Match($pubspec, 'version: (\d+)\.(\d+)\.(\d+)\+(\d+)')

$major = [int]$currentVersion.Groups[1].Value
$minor = [int]$currentVersion.Groups[2].Value
$patch = [int]$currentVersion.Groups[3].Value
$build = [int]$currentVersion.Groups[4].Value + 1

switch ($BumpType) {
    'major' { $major++; $minor = 0; $patch = 0 }
    'minor' { $minor++; $patch = 0 }
    'patch' { $patch++ }
}

$newVersion = "$major.$minor.$patch+$build"
$pubspec = $pubspec -replace 'version: \d+\.\d+\.\d+\+\d+', "version: $newVersion"
Set-Content "pubspec.yaml" $pubspec

Write-Host "✅ Version bumped to $newVersion"
```

---

## 7. قائمة تحقق المرحلة

- [ ] إنشاء `.github/workflows/ci.yml`
- [ ] إنشاء `.github/workflows/build.yml`
- [ ] إعداد GitHub Secrets (keystore, API keys)
- [ ] إنشاء Android keystore (إنتاج)
- [ ] إعداد Fastlane لـ Android (internal → beta → production)
- [ ] إعداد Fastlane لـ iOS (TestFlight → App Store)
- [ ] إنشاء جدول Feature Flags في Supabase
- [ ] إنشاء `FeatureFlags` provider
- [ ] إنشاء سكربت `bump_version`
- [ ] اختبار: PR → CI يشتغل → تحليل + اختبارات
- [ ] اختبار: دمج في main → بناء AAB + IPA
- [ ] اختبار: Fastlane يرفع لـ Play Internal / TestFlight
