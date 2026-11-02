# 03 — إعداد الباك اند (Supabase)

> **المدة المُقدَّرة:** 5–7 أيام
> **يعتمد على:** الملف 02 (قاعدة البيانات المحلية)
> **الأولوية:** 🔴 عالية — أساس المصادقة والمزامنة والمحتوى

---

## 1. لماذا Supabase؟

| المعيار | Supabase ✅ | Firebase |
|---------|:----------:|:--------:|
| البيانات العلائقية (وصفات ↔ مكونات) | ممتاز (PostgreSQL) | ضعيف (NoSQL) |
| البحث المتقدم (pg_trgm, FTS, pgvector) | مدمج | يحتاج خدمة إضافية |
| التكلفة | متوقعة + مفتوح المصدر | قد تتصاعد |
| Edge Functions | Deno (TypeScript) | Cloud Functions |
| Auth | مدمج | مدمج ✅ |
| Storage + CDN | مدمج | مدمج ✅ |

**القرار:** Supabase للبيانات + Auth + Storage، مع FCM للإشعارات عند الحاجة.

---

## 2. إنشاء المشروع

### 2.1 خطوات الإعداد

```bash
# 1. إنشاء حساب على supabase.com
# 2. إنشاء 3 مشاريع:
#    - smart-cook-dev
#    - smart-cook-staging  
#    - smart-cook-prod

# 3. تثبيت Supabase CLI
npm install -g supabase

# 4. تهيئة المشروع محليًا
cd "d:\My Work\Flutter Projects\food app"
supabase init

# 5. ربط المشروع
supabase link --project-ref <DEV_PROJECT_REF>
```

### 2.2 هيكل المجلدات

```
supabase/
├─ config.toml
├─ migrations/
│  ├─ 20261020000001_initial_schema.sql
│  ├─ 20261020000002_rls_policies.sql
│  ├─ 20261020000003_functions.sql
│  └─ 20261020000004_seed_data.sql
├─ functions/
│  ├─ ai-extract-ingredients/
│  ├─ ai-generate-recipe/
│  ├─ content-sync/
│  └─ shared/
└─ seed.sql
```

---

## 3. الهجرة الأولى — المخطط الأساسي

### 3.1 الامتدادات

```sql
-- migrations/20261020000001_initial_schema.sql

-- تفعيل الامتدادات المطلوبة
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";          -- بحث نصي ضبابي
CREATE EXTENSION IF NOT EXISTS "pgvector";          -- تضمينات (لاحقًا)

-- ===== جدول المكونات =====
CREATE TABLE ingredients (
  id            TEXT PRIMARY KEY,
  category      TEXT NOT NULL,
  parent_id     TEXT REFERENCES ingredients(id),
  is_staple     BOOLEAN NOT NULL DEFAULT FALSE,
  default_unit  TEXT,
  shelf_life_fridge_days INT,
  shelf_life_pantry_days INT,
  allergens     TEXT[] NOT NULL DEFAULT '{}',
  diet_flags    JSONB  NOT NULL DEFAULT '{}',
  nutrition_per_100g JSONB,
  image_url     TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ===== أسماء المكونات =====
CREATE TABLE ingredient_names (
  ingredient_id TEXT REFERENCES ingredients(id) ON DELETE CASCADE,
  lang          TEXT NOT NULL,
  region        TEXT,
  name          TEXT NOT NULL,
  normalized    TEXT NOT NULL,
  is_primary    BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (ingredient_id, lang, name)
);
CREATE INDEX idx_ing_names_norm ON ingredient_names
  USING gin (normalized gin_trgm_ops);

-- ===== بدائل المكونات =====
CREATE TABLE ingredient_substitutes (
  ingredient_id   TEXT REFERENCES ingredients(id),
  substitute_id   TEXT REFERENCES ingredients(id),
  ratio           NUMERIC DEFAULT 1,
  quality         TEXT CHECK (quality IN ('ideal','acceptable','avoid')),
  context_tags    TEXT[],
  note_ar         TEXT,
  PRIMARY KEY (ingredient_id, substitute_id)
);

-- ===== الوصفات =====
CREATE TABLE recipes (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug          TEXT UNIQUE NOT NULL,
  title         JSONB NOT NULL,
  description   JSONB,
  cuisine       TEXT,
  meal_type     TEXT[],
  difficulty    SMALLINT CHECK (difficulty BETWEEN 1 AND 3),
  prep_minutes  INT,
  cook_minutes  INT,
  total_minutes INT GENERATED ALWAYS AS
    (COALESCE(prep_minutes,0) + COALESCE(cook_minutes,0)) STORED,
  base_servings INT NOT NULL DEFAULT 4,
  calories_per_serving INT,
  equipment     TEXT[],
  diet_flags    JSONB NOT NULL DEFAULT '{}',
  allergens     TEXT[] NOT NULL DEFAULT '{}',
  source_type   TEXT CHECK (source_type IN ('editorial','partner','user','ai')),
  verified      BOOLEAN NOT NULL DEFAULT FALSE,
  author_id     UUID,
  hero_image_url TEXT,
  blurhash      TEXT,
  rating_avg    NUMERIC(3,2) DEFAULT 0,
  rating_count  INT DEFAULT 0,
  status        TEXT CHECK (status IN ('draft','review','published','archived'))
    DEFAULT 'draft',
  published_at  TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ===== مكونات الوصفة =====
CREATE TABLE recipe_ingredients (
  recipe_id     UUID REFERENCES recipes(id) ON DELETE CASCADE,
  ingredient_id TEXT REFERENCES ingredients(id),
  role          TEXT CHECK (role IN ('core','important','optional','staple'))
    NOT NULL,
  amount        NUMERIC,
  unit          TEXT,
  display_text  JSONB,
  group_label   JSONB DEFAULT '""',
  sort_order    INT DEFAULT 0,
  PRIMARY KEY (recipe_id, ingredient_id, group_label)
);
CREATE INDEX idx_ri_ingredient ON recipe_ingredients(ingredient_id);

-- ===== خطوات الوصفة =====
CREATE TABLE recipe_steps (
  recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
  step_no   INT,
  text      JSONB NOT NULL,
  image_url TEXT,
  timer_seconds INT,
  tip       JSONB,
  PRIMARY KEY (recipe_id, step_no)
);

-- ===== الملف الشخصي =====
CREATE TABLE profiles (
  id         UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  avatar_url TEXT,
  locale     TEXT DEFAULT 'ar',
  region     TEXT,
  measurement_system TEXT DEFAULT 'metric',
  allergens  TEXT[] DEFAULT '{}',
  diets      TEXT[] DEFAULT '{}',
  excluded_ingredients TEXT[] DEFAULT '{}',
  household_size INT DEFAULT 2,
  assume_staples BOOLEAN DEFAULT TRUE,
  equipment  TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ===== مخزون المستخدم =====
CREATE TABLE pantry_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  ingredient_id TEXT REFERENCES ingredients(id),
  quantity NUMERIC,
  unit TEXT,
  location TEXT CHECK (location IN ('fridge','freezer','pantry')),
  added_at TIMESTAMPTZ DEFAULT now(),
  expires_on DATE,
  source TEXT CHECK (source IN ('manual','voice','camera','barcode','receipt')),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, ingredient_id)
);

-- ===== المفضلة =====
CREATE TABLE favorites (
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY(user_id, recipe_id)
);

-- ===== التقييمات =====
CREATE TABLE ratings (
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
  stars SMALLINT CHECK (stars BETWEEN 1 AND 5),
  outcome TEXT,
  comment TEXT,
  photo_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY(user_id, recipe_id)
);

-- ===== جلسات الطهي =====
CREATE TABLE cook_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  recipe_id UUID REFERENCES recipes(id),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  servings INT
);

-- ===== قائمة التسوق =====
CREATE TABLE shopping_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  ingredient_id TEXT REFERENCES ingredients(id),
  custom_name TEXT,
  quantity NUMERIC,
  unit TEXT,
  checked BOOLEAN DEFAULT FALSE,
  source_recipe_id UUID REFERENCES recipes(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ===== خطة الوجبات =====
CREATE TABLE meal_plan_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  recipe_id UUID REFERENCES recipes(id),
  plan_date DATE,
  meal_type TEXT,
  servings INT
);

-- ===== Trigger لتحديث updated_at =====
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at_ingredients
  BEFORE UPDATE ON ingredients
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_recipes
  BEFORE UPDATE ON recipes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_profiles
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_pantry
  BEFORE UPDATE ON pantry_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
```

---

## 4. سياسات الأمان (RLS)

```sql
-- migrations/20261020000002_rls_policies.sql

-- تفعيل RLS على جميع الجداول
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE pantry_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE cook_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE shopping_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_plan_entries ENABLE ROW LEVEL SECURITY;

-- === الملف الشخصي ===
CREATE POLICY "المستخدم يقرأ ملفه فقط"
  ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "المستخدم يُعدّل ملفه فقط"
  ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "إنشاء ملف عند التسجيل"
  ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- === المخزون ===
CREATE POLICY "المستخدم يرى مخزونه فقط"
  ON pantry_items FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "المستخدم يضيف لمخزونه"
  ON pantry_items FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "المستخدم يُعدّل مخزونه"
  ON pantry_items FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "المستخدم يحذف من مخزونه"
  ON pantry_items FOR DELETE USING (auth.uid() = user_id);

-- === المفضلة ===
CREATE POLICY "المستخدم يرى مفضلته"
  ON favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "المستخدم يضيف مفضلة"
  ON favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "المستخدم يحذف مفضلة"
  ON favorites FOR DELETE USING (auth.uid() = user_id);

-- === التقييمات ===
CREATE POLICY "الجميع يقرأ التقييمات"
  ON ratings FOR SELECT USING (true);
CREATE POLICY "المستخدم يُقيّم"
  ON ratings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "المستخدم يُعدّل تقييمه"
  ON ratings FOR UPDATE USING (auth.uid() = user_id);

-- === قائمة التسوق ===
CREATE POLICY "المستخدم يرى قائمته"
  ON shopping_items FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "المستخدم يضيف لقائمته"
  ON shopping_items FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "المستخدم يُعدّل قائمته"
  ON shopping_items FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "المستخدم يحذف من قائمته"
  ON shopping_items FOR DELETE USING (auth.uid() = user_id);

-- === المحتوى العام (وصفات + مكونات) ===
-- لا RLS — متاح للقراءة لجميع المستخدمين (مُصادق عليهم + ضيوف)
-- الكتابة محمية عبر service_role key فقط (CMS)
```

---

## 5. تهيئة المصادقة (Auth)

### 5.1 مزوّدو تسجيل الدخول

```
1. Email/Password (للتطوير)
2. Google OAuth
3. Apple Sign In (إلزامي لـ iOS)
4. مجهول (Anonymous) — للضيوف
```

### 5.2 إعداد في لوحة Supabase

```
Authentication → Providers:
  ✅ Email (تمكين)
  ✅ Google (Client ID + Secret)
  ✅ Apple (Service ID + Key)
  ✅ Anonymous sign-ins (تمكين)
```

### 5.3 Trigger لإنشاء الملف الشخصي

```sql
-- migrations/20261020000003_functions.sql

CREATE OR REPLACE FUNCTION create_profile_on_signup()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, display_name, avatar_url)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name', 'مستخدم'),
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION create_profile_on_signup();
```

---

## 6. تخزين الصور (Storage)

### 6.1 الحاويات (Buckets)

```sql
-- إنشاء الحاويات
INSERT INTO storage.buckets (id, name, public) VALUES
  ('recipe-images', 'recipe-images', true),    -- صور الوصفات (عام)
  ('ingredient-images', 'ingredient-images', true),
  ('user-uploads', 'user-uploads', false);      -- صور المستخدمين (خاص)

-- سياسات التخزين
CREATE POLICY "صور الوصفات عامة للقراءة"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'recipe-images');

CREATE POLICY "المستخدم يرفع صوره"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'user-uploads' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "المستخدم يحذف صوره"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'user-uploads' AND auth.uid()::text = (storage.foldername(name))[1]);
```

### 6.2 تحويل الصور (Image Transformation)

```
Supabase يدعم تحويل الصور عبر URL:
/storage/v1/render/image/public/recipe-images/kabsa.webp
  ?width=400
  &height=300
  &resize=cover
  &quality=80
  &format=webp
```

---

## 7. Edge Functions

### 7.1 مزامنة المحتوى

```typescript
// supabase/functions/content-sync/index.ts

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  const { last_sync_at, content_version } = await req.json();
  
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  // جلب المحتوى المُحدَّث منذ آخر مزامنة
  const { data: recipes } = await supabase
    .from("recipes")
    .select("*, recipe_ingredients(*), recipe_steps(*)")
    .eq("status", "published")
    .gt("updated_at", last_sync_at || "1970-01-01");

  const { data: ingredients } = await supabase
    .from("ingredients")
    .select("*, ingredient_names(*)")
    .gt("updated_at", last_sync_at || "1970-01-01");

  return new Response(
    JSON.stringify({
      recipes: recipes || [],
      ingredients: ingredients || [],
      sync_at: new Date().toISOString(),
      content_version: content_version + 1,
    }),
    { headers: { "Content-Type": "application/json" } }
  );
});
```

### 7.2 واجهة AI (لاحقًا)

```typescript
// supabase/functions/ai-extract-ingredients/index.ts
// هذه الدالة تُنفَّذ في مرحلة V1

serve(async (req) => {
  // التحقق من المصادقة
  // تحديد المعدل (Rate limiting)
  // استدعاء نموذج الرؤية
  // إرجاع المكونات المُستخرجة
});
```

---

## 8. إعداد Flutter Client

### 8.1 تهيئة Supabase في التطبيق

```dart
// data/remote/supabase_client.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
  static GoTrueClient get auth => client.auth;
}
```

### 8.2 تحديث `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Supabase
  await SupabaseConfig.initialize(
    url: EnvConfig.current.supabaseUrl,
    anonKey: EnvConfig.current.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: SmartCookApp()));
}
```

---

## 9. نشر الهجرات

```bash
# تطبيق الهجرات على المشروع البعيد
supabase db push

# التحقق
supabase db diff

# إنشاء هجرة جديدة من التغييرات المحلية
supabase migration new add_some_feature
```

---

## 10. قائمة تحقق المرحلة

- [ ] إنشاء 3 مشاريع Supabase (dev, staging, prod)
- [ ] تثبيت Supabase CLI و`supabase init`
- [ ] كتابة وتطبيق الهجرة الأولى (المخطط)
- [ ] كتابة وتطبيق سياسات RLS
- [ ] إعداد Auth (Google + Apple + Anonymous)
- [ ] إنشاء Trigger إنشاء الملف الشخصي
- [ ] إنشاء Storage Buckets + سياسات
- [ ] كتابة Edge Function للمزامنة
- [ ] إعداد `supabase_flutter` في التطبيق
- [ ] اختبار: تسجيل مستخدم → إنشاء ملف ← صحيح
- [ ] اختبار: RLS — مستخدم لا يرى بيانات غيره
- [ ] اختبار: رفع صورة → جلبها بأحجام مختلفة
- [ ] ربط البيئات الثلاث بالـ Flavors
