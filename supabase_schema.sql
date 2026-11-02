-- ====================================================================
-- سكربت إنشاء جداول لوحة التحكم وتطبيق "طاهي ذكي"
-- قم بنسخ هذا الكود ولصقه في Supabase SQL Editor واضغط Run
-- ====================================================================

-- 1. جدول الإعدادات عن بُعد والتحكم بالإعلانات
CREATE TABLE IF NOT EXISTS public.app_remote_config (
    id TEXT PRIMARY KEY DEFAULT 'global_config',
    maintenance_mode BOOLEAN DEFAULT FALSE,
    min_app_version TEXT DEFAULT '1.0.0',
    announcement_message TEXT DEFAULT '',
    is_announcement_active BOOLEAN DEFAULT FALSE,
    
    -- إعدادات إعلانات AdMob
    ads_enabled BOOLEAN DEFAULT TRUE,
    android_banner_id TEXT DEFAULT 'ca-app-pub-3940256099942544/6300978111',
    android_interstitial_id TEXT DEFAULT 'ca-app-pub-3940256099942544/1033173712',
    android_rewarded_id TEXT DEFAULT 'ca-app-pub-3940256099942544/5224354917',
    interstitial_interval INT DEFAULT 3,
    
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إدراج الصف الافتراضي في حال عدم وجوده
INSERT INTO public.app_remote_config (id, ads_enabled)
VALUES ('global_config', TRUE)
ON CONFLICT (id) DO NOTHING;

-- 2. جدول ملفات المستخدمين وحالة الـ Pro
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT,
    display_name TEXT,
    is_pro BOOLEAN DEFAULT FALSE,
    pro_source TEXT DEFAULT 'none', -- (google_play, app_store, manual_admin)
    pro_expires_at TIMESTAMP WITH TIME ZONE,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. جدول الوصفات (Recipes CMS)
CREATE TABLE IF NOT EXISTS public.recipes (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    cuisine TEXT DEFAULT 'خليجي',
    difficulty TEXT DEFAULT 'سهل',
    prep_minutes INT DEFAULT 15,
    cook_minutes INT DEFAULT 30,
    servings INT DEFAULT 4,
    calories INT DEFAULT 400,
    hero_image_url TEXT,
    tags TEXT[] DEFAULT ARRAY[]::TEXT[],
    verified BOOLEAN DEFAULT TRUE,
    ingredients JSONB DEFAULT '[]'::jsonb,
    steps JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. تفعيل الأمان (Row Level Security - RLS)
ALTER TABLE public.app_remote_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipes ENABLE ROW LEVEL SECURITY;

-- سياسات قراءة وكتابة الوصفات
CREATE POLICY "Allow public read access to recipes"
    ON public.recipes FOR SELECT
    USING (true);

CREATE POLICY "Allow public/anon insert to recipes"
    ON public.recipes FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Allow public/anon update to recipes"
    ON public.recipes FOR UPDATE
    USING (true);

CREATE POLICY "Allow public/anon delete to recipes"
    ON public.recipes FOR DELETE
    USING (true);

-- سياسات app_remote_config
CREATE POLICY "Allow public read access to app_remote_config"
    ON public.app_remote_config FOR SELECT
    USING (true);

CREATE POLICY "Allow public update to app_remote_config"
    ON public.app_remote_config FOR UPDATE
    USING (true);

-- سياسات profiles
CREATE POLICY "Users can read own profile or admin reads all"
    ON public.profiles FOR SELECT
    TO authenticated
    USING (
        auth.uid() = id OR 
        EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = TRUE)
    );


-- ====================================================================
-- 5. جدول سجلات وأخطاء التطبيق (Telemetry & Remote Error Logs)
-- ====================================================================
CREATE TABLE IF NOT EXISTS public.app_error_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    level TEXT DEFAULT 'error', -- error, warning, fatal
    tag TEXT DEFAULT 'General',
    message TEXT NOT NULL,
    stack_trace TEXT,
    app_version TEXT DEFAULT '1.0.0',
    platform TEXT,
    device_info TEXT,
    user_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.app_error_logs ENABLE ROW LEVEL SECURITY;

-- السماح لتطبيقات الهواتف بتسجيل الأخطاء فور حدوثها
CREATE POLICY "Allow public insert to app_error_logs"
    ON public.app_error_logs FOR INSERT
    WITH CHECK (true);

-- السماح للوحة التحكم بقراءة سجل الأخطاء
CREATE POLICY "Allow read access to app_error_logs"
    ON public.app_error_logs FOR SELECT
    USING (true);
