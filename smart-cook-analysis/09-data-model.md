# 09 — نموذج البيانات

## 1. مخطط العلاقات (ERD مبسّط)

```
ingredients ─┬─< ingredient_names (مرادفات/لهجات)
             ├─< ingredient_substitutes
             └─< recipe_ingredients >─ recipes ─┬─< recipe_steps
                                                ├─< recipe_tags >─ tags
                                                ├─< ratings
                                                └─< recipe_images

users ─┬─< pantry_items >─ ingredients
       ├─< favorites >─ recipes
       ├─< shopping_items
       ├─< meal_plan_entries >─ recipes
       ├─< cook_sessions >─ recipes
       └─ user_preferences (حساسية، حمية، مستبعدات)
```

## 2. الجداول الأساسية (PostgreSQL)

```sql
-- المكونات
CREATE TABLE ingredients (
  id            TEXT PRIMARY KEY,                 -- 'ing_tomato'
  category      TEXT NOT NULL,                    -- vegetable, meat, dairy, spice...
  parent_id     TEXT REFERENCES ingredients(id),  -- تسلسل هرمي
  is_staple     BOOLEAN NOT NULL DEFAULT FALSE,
  default_unit  TEXT,
  shelf_life_fridge_days INT,
  shelf_life_pantry_days INT,
  allergens     TEXT[] NOT NULL DEFAULT '{}',     -- {'nuts','gluten'}
  diet_flags    JSONB  NOT NULL DEFAULT '{}',     -- {"vegan":true,"halal":true}
  nutrition_per_100g JSONB,
  image_url     TEXT,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- أسماء المكونات واللهجات
CREATE TABLE ingredient_names (
  ingredient_id TEXT REFERENCES ingredients(id) ON DELETE CASCADE,
  lang          TEXT NOT NULL,                    -- 'ar','en'
  region        TEXT,                             -- 'gulf','levant','egypt','maghreb' (اختياري)
  name          TEXT NOT NULL,
  normalized    TEXT NOT NULL,                    -- بعد إزالة التشكيل وتوحيد الهمزات
  is_primary    BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (ingredient_id, lang, name)
);
CREATE INDEX idx_ing_names_norm ON ingredient_names USING gin (normalized gin_trgm_ops);

-- البدائل
CREATE TABLE ingredient_substitutes (
  ingredient_id   TEXT REFERENCES ingredients(id),
  substitute_id   TEXT REFERENCES ingredients(id),
  ratio           NUMERIC DEFAULT 1,
  quality         TEXT CHECK (quality IN ('ideal','acceptable','avoid')),
  context_tags    TEXT[],                         -- {'baking','sauce_cold'}
  note_ar         TEXT,
  PRIMARY KEY (ingredient_id, substitute_id)
);

-- الوصفات
CREATE TABLE recipes (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug          TEXT UNIQUE NOT NULL,
  title         JSONB NOT NULL,                   -- {"ar":"كبسة الدجاج","en":"Chicken Kabsa"}
  description   JSONB,
  cuisine       TEXT,                             -- gulf, levant, egypt, maghreb, intl...
  meal_type     TEXT[],                           -- {'lunch','dinner'}
  difficulty    SMALLINT CHECK (difficulty BETWEEN 1 AND 3),
  prep_minutes  INT, cook_minutes INT, total_minutes INT GENERATED ALWAYS AS (COALESCE(prep_minutes,0)+COALESCE(cook_minutes,0)) STORED,
  base_servings INT NOT NULL DEFAULT 4,
  calories_per_serving INT,
  equipment     TEXT[],                           -- {'oven','blender'}
  diet_flags    JSONB NOT NULL DEFAULT '{}',
  allergens     TEXT[] NOT NULL DEFAULT '{}',     -- محسوبة آليًا من المكونات
  source_type   TEXT CHECK (source_type IN ('editorial','partner','user','ai')),
  verified      BOOLEAN NOT NULL DEFAULT FALSE,
  author_id     UUID,
  hero_image_url TEXT, blurhash TEXT,
  rating_avg    NUMERIC(3,2), rating_count INT DEFAULT 0,
  status        TEXT CHECK (status IN ('draft','review','published','archived')) DEFAULT 'draft',
  published_at  TIMESTAMPTZ,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- مكونات الوصفة
CREATE TABLE recipe_ingredients (
  recipe_id     UUID REFERENCES recipes(id) ON DELETE CASCADE,
  ingredient_id TEXT REFERENCES ingredients(id),
  role          TEXT CHECK (role IN ('core','important','optional','staple')) NOT NULL,
  amount        NUMERIC, unit TEXT,
  display_text  JSONB,                            -- "نص كيلو دجاج" بصياغة الوصفة
  group_label   JSONB,                            -- "للصلصة"
  sort_order    INT,
  PRIMARY KEY (recipe_id, ingredient_id, group_label)
);
CREATE INDEX idx_ri_ingredient ON recipe_ingredients(ingredient_id);

-- الخطوات
CREATE TABLE recipe_steps (
  recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
  step_no   INT,
  text      JSONB NOT NULL,
  image_url TEXT,
  timer_seconds INT,                              -- مؤقت مقترح
  tip       JSONB,
  PRIMARY KEY (recipe_id, step_no)
);

-- مخزون المستخدم
CREATE TABLE pantry_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  ingredient_id TEXT REFERENCES ingredients(id),
  quantity NUMERIC, unit TEXT,
  location TEXT CHECK (location IN ('fridge','freezer','pantry')),
  added_at TIMESTAMPTZ DEFAULT now(),
  expires_on DATE,
  source TEXT CHECK (source IN ('manual','voice','camera','barcode','receipt')),
  UNIQUE(user_id, ingredient_id)
);

-- تفضيلات المستخدم
CREATE TABLE user_preferences (
  user_id UUID PRIMARY KEY,
  locale TEXT, region TEXT, measurement_system TEXT,
  allergens TEXT[] DEFAULT '{}',
  diets TEXT[] DEFAULT '{}',            -- vegetarian, keto, diabetic_friendly...
  excluded_ingredients TEXT[] DEFAULT '{}',
  household_size INT DEFAULT 2,
  assume_staples BOOLEAN DEFAULT TRUE,
  equipment TEXT[] DEFAULT '{}'
);

-- المفضلة، التقييمات، جلسات الطهي، قائمة التسوق، خطة الوجبات
CREATE TABLE favorites (user_id UUID, recipe_id UUID, created_at TIMESTAMPTZ DEFAULT now(), PRIMARY KEY(user_id, recipe_id));
CREATE TABLE ratings (user_id UUID, recipe_id UUID, stars SMALLINT, outcome TEXT, comment TEXT, photo_url TEXT, created_at TIMESTAMPTZ DEFAULT now(), PRIMARY KEY(user_id, recipe_id));
CREATE TABLE cook_sessions (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), user_id UUID, recipe_id UUID, started_at TIMESTAMPTZ, completed_at TIMESTAMPTZ, servings INT);
CREATE TABLE shopping_items (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), user_id UUID, ingredient_id TEXT, quantity NUMERIC, unit TEXT, checked BOOLEAN DEFAULT FALSE, source_recipe_id UUID);
CREATE TABLE meal_plan_entries (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), user_id UUID, recipe_id UUID, plan_date DATE, meal_type TEXT, servings INT);
```

**ملاحظات:**
- `allergens` و`diet_flags` للوصفة **تُحسب آليًا** من المكونات عبر Trigger/وظيفة، لتجنب الأخطاء البشرية.
- سياسات **RLS**: جداول المستخدم تُقيَّد بـ `user_id = auth.uid()`.
- نظام البحث: `pg_trgm` + FTS للعربية (مع تطبيع)، و`pgvector` للتضمينات (لاحقًا).

## 3. نسخة محلية (Drift/SQLite) — ما يُخزَّن على الجهاز

| الجدول المحلي | الغرض |
|---------------|-------|
| `ingredients`, `ingredient_names`, `ingredient_substitutes` | القاموس كامل للعمل دون اتصال |
| `recipes` (مخففة) + `recipe_ingredients` + `recipe_steps` | الوصفات المنزّلة |
| `inverted_index` (ingredient → recipes) | سرعة المطابقة |
| `pantry_items`, `favorites`, `shopping_items`, `sync_queue` | بيانات المستخدم وطابور المزامنة |
| FTS5 على أسماء الوصفات والمكونات | بحث فوري |

## 4. مثال JSON لوصفة (للمزامنة)

```json
{
  "id": "6f1c...",
  "slug": "chicken-kabsa",
  "title": {"ar": "كبسة الدجاج", "en": "Chicken Kabsa"},
  "cuisine": "gulf",
  "meal_type": ["lunch", "dinner"],
  "difficulty": 2,
  "total_minutes": 75,
  "base_servings": 4,
  "verified": true,
  "ingredients": [
    {"id": "ing_chicken", "role": "core", "amount": 1000, "unit": "g", "display": {"ar": "دجاج مقطّع (1 كغ)"}},
    {"id": "ing_rice_basmati", "role": "core", "amount": 3, "unit": "cup"},
    {"id": "ing_onion", "role": "important", "amount": 2, "unit": "piece"},
    {"id": "ing_tomato", "role": "important", "amount": 2, "unit": "piece"},
    {"id": "ing_kabsa_spices", "role": "important", "amount": 2, "unit": "tbsp"},
    {"id": "ing_salt", "role": "staple"},
    {"id": "ing_oil", "role": "staple"},
    {"id": "ing_cilantro", "role": "optional"}
  ],
  "steps": [
    {"no": 1, "text": {"ar": "قلّب البصل في الزيت حتى يصبح ذهبيًا."}, "timer_seconds": 420}
  ],
  "allergens": [],
  "diet_flags": {"halal": true}
}
```

## 5. استراتيجية المزامنة

| العنصر | الاتجاه | الأسلوب |
|--------|---------|---------|
| المحتوى (وصفات، مكونات) | خادم → جهاز | Delta بحسب `updated_at`، حزم مضغوطة، إصدار قاعدة المحتوى |
| بيانات المستخدم | ثنائي | طابور عمليات محلي، معرّفات UUID من العميل، حل تعارض بقاعدة واضحة |
| الصور | عند الطلب | CDN + تخزين مؤقت |
| الحذف | ناعم (soft delete) مع `deleted_at` | لتجنب «عودة» العناصر |

## 6. النسخ الاحتياطي والتصدير

- تصدير JSON/CSV لبيانات المستخدم (مفضلة، مخزون، ملاحظات) من الإعدادات.
- استيراد من ملف.
- يخفف مخاطر فقدان البيانات (درس من إغلاق Yummly) ويعزز الثقة.
