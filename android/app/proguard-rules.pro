# Flutter Wrapper Keep Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Drift SQLite native bindings & reflection
-keep class com.simolus3.drift.** { *; }
-keep class **.AppDatabase { *; }
-keep class **.*Dao { *; }
-dontwarn com.simolus3.drift.**

# Supabase & GoTrue serialization
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod
-keep class io.github.jan.supabase.** { *; }
-dontwarn io.github.jan.supabase.**

# Android Desugaring
-keep class java.time.** { *; }

# Workmanager & Notifications
-keep class androidx.work.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Google Play Core Deferred Components
-dontwarn com.google.android.play.core.**

