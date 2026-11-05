# 13 — Operations and Environment Configuration

## 1. Secret-handling rules

- Never commit real API keys, passwords, private keys, signing credentials, or service-role tokens.
- Never embed privileged backend keys in Flutter.
- Use secret management for production.
- Use separate credentials for development, staging, and production.
- Rotate secrets after exposure or staff changes.
- Keep `.env.example` values blank or clearly fake.
- Restrict access to production secrets by role.

## 2. Environment variable template

The following names are proposed placeholders. Confirm exact names against the selected backend and deployment implementation.

```dotenv
# Application
APP_ENV=
APP_URL=
APP_DEBUG=

# Backend / API
API_BASE_URL=
API_TIMEOUT_SECONDS=

# Supabase candidate configuration (if selected)
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Database (server-side only)
DATABASE_URL=

# Object storage
STORAGE_ENDPOINT=
STORAGE_BUCKET_PRIVATE=
STORAGE_BUCKET_PUBLIC=
STORAGE_ACCESS_KEY_ID=
STORAGE_SECRET_ACCESS_KEY=
CDN_BASE_URL=

# AI gateway (server-side only)
AI_PROVIDER=
AI_API_KEY=
AI_MODEL_TRANSLATION=
AI_MODEL_RECIPE_ASSIST=
AI_PROVIDER_TRAINING_DISABLED=
AI_PROVIDER_RETENTION_POLICY=

# Authentication providers
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
APPLE_SERVICE_ID=
APPLE_TEAM_ID=
APPLE_KEY_ID=
APPLE_PRIVATE_KEY=

# Notifications
FCM_PROJECT_ID=
FCM_SERVICE_ACCOUNT_JSON=

# Analytics / monitoring
SENTRY_DSN=
POSTHOG_PROJECT_KEY=
POSTHOG_HOST=

# Subscription system (if enabled)
REVENUECAT_PUBLIC_ANDROID_KEY=
REVENUECAT_PUBLIC_IOS_KEY=
REVENUECAT_WEBHOOK_SECRET=

# Upload safety
MAX_RECIPE_IMAGE_BYTES=
MAX_RECIPE_VIDEO_BYTES=
UPLOAD_ALLOWED_MIME_TYPES=
```

## 3. Client versus server variables

Client-exposed configuration may include only public identifiers and publishable keys intended for untrusted clients.

Never expose:
- database passwords;
- Supabase service role key;
- AI provider secret;
- object storage secret;
- OAuth client secret;
- webhook signing secret;
- private signing keys.

## 4. Environments

| Environment | Purpose | Data |
|---|---|---|
| Development | Local engineering | Synthetic/test data |
| Staging | QA and pilot | Sanitized or synthetic data |
| Production | Real users | Protected production data |

Do not copy production personal data into development without an approved sanitization process.

## 5. Operational runbooks required

Create separate runbooks for:
- failed recipe submission;
- review queue backlog;
- urgent food-safety report;
- copyright/media takedown;
- suspected account compromise;
- AI provider incident or policy change;
- storage exposure;
- database migration rollback;
- sync queue backlog;
- creator withdrawal request.

## 6. Backups and retention

Define:
- database backup frequency;
- point-in-time recovery;
- object storage backup/versioning;
- retention periods;
- deletion propagation;
- legal hold exceptions;
- disaster recovery owner and recovery objectives.

Do not promise deletion from immutable backups until the retention design supports it.
