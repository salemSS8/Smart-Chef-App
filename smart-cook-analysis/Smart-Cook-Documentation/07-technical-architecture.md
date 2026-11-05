# 07 — Technical Architecture

## 1. Architecture goals

- Keep the existing Flutter application maintainable.
- Preserve offline utility for personal cooking workflows.
- Make community publishing, rights, and moderation server-authoritative.
- Start with a modular monolith rather than premature microservices.
- Keep AI provider credentials and policy enforcement on the backend.

## 2. Mobile application

The existing project report describes:
- Flutter;
- Riverpod;
- go_router;
- Drift / SQLite;
- Dio;
- feature-first organization and Clean Architecture;
- local recipe matching;
- pantry, shopping list, and cook mode.

These are reported capabilities and must be verified against the current repository before implementation planning.

### Proposed feature structure

```text
lib/
  app/
  core/
    auth/
    config/
    database/
    design_system/
    errors/
    localization/
    network/
    security/
    telemetry/
  features/
    onboarding/
    discover/
    recipe_detail/
    recipe_editor/
    creator_dashboard/
    moderation_status/
    pantry/
    matching/
    cook_mode/
    meal_plan/
    shopping/
    profile/
    settings/
```

Keep presentation, domain, and data boundaries. Business rules should be testable without Flutter widgets or network access.

## 3. Backend recommendation

A relational backend is suitable for recipes, ingredients, translations, versions, creator agreements, review decisions, and attribution.

The previous architecture considered Supabase (PostgreSQL, Auth, Storage, Edge Functions). This remains a candidate, not a confirmed deployed dependency.

### Proposed logical modules
- Identity and profiles
- Recipe catalog
- Recipe versions and translations
- Creator rights and agreements
- Submission and moderation
- Media storage and processing
- Discovery and search
- Pantry and user data sync
- AI orchestration
- Notifications and analytics

These are logical modules inside a modular monolith initially.

## 4. Source-of-truth boundaries

| Data | Authoritative source |
|---|---|
| Public recipes and publication status | Backend |
| Recipe versions and review decisions | Backend |
| Creator agreements and rights evidence | Backend |
| Media access policy | Backend/object storage policy |
| Personal pantry while offline | Local database, synchronized to backend when signed in |
| Personal shopping list while offline | Local database, synchronized to backend when signed in |
| Local cache of public recipes | Device cache; never authoritative |
| AI provider secrets | Backend secret manager |

The local Drift database must never decide that a community recipe is approved or public.

## 5. Offline-first strategy

Continue using a local database for:
- pantry;
- favorites;
- shopping list;
- cached recipes;
- cook-session progress;
- local drafts where appropriate.

Use a durable sync queue with:
- operation ID;
- entity ID;
- operation type;
- payload version;
- created timestamp;
- retry count;
- last error;
- idempotency key.

Last-Write-Wins is not sufficient for recipe versioning, rights, moderation, or public content. Use server-side version checks and explicit conflict resolution for those domains.

## 6. Media pipeline

1. Client requests a scoped upload authorization.
2. Backend validates user role, file size, type, and upload limits.
3. Client uploads to a private quarantine location.
4. Server validates file signature, scans, strips unsafe metadata where appropriate, and generates derivatives.
5. Rights declaration and moderation review are associated with the asset.
6. Approved public media is distributed through controlled public/CDN paths.
7. Pending/rejected media remains private and inaccessible to public clients.

Never expose an unreviewed recipe image through a predictable public URL.

## 7. AI gateway

All AI calls must pass through a backend gateway.

Responsibilities:
- authenticate user and enforce rate limits;
- choose provider/model;
- enforce no-training and retention requirements;
- redact unnecessary personal data;
- validate structured outputs;
- record purpose and cost metadata;
- prevent secrets from reaching the client;
- reject prohibited uses of community content.

AI features may include ingredient extraction, recipe formatting, translation, and substitution suggestions. AI output is not a substitute for human publication review or qualified food-safety advice.

## 8. Security architecture

- server-side authorization for every privileged action;
- row-level security where supported;
- private-by-default media storage;
- short-lived upload/download authorization;
- audit logging for rights and moderation events;
- rate limits and abuse detection;
- encrypted transport;
- secure token storage on mobile;
- dependency and secret scanning;
- environment separation (development, staging, production).

## 9. Observability

Track:
- API latency and error rates;
- upload failures;
- sync queue age and retry rates;
- review queue depth and age;
- moderation outcomes;
- AI usage and cost;
- crash-free sessions;
- recipe discovery-to-cook conversion.

Do not log recipe content or personal data by default. Define explicit redaction and retention rules.

## 10. Deployment strategy

- CI checks formatting, static analysis, tests, and build.
- Use separate dev/staging/prod projects and credentials.
- Database migrations are versioned and reviewed.
- Use feature flags for staged rollout.
- Public community publishing remains disabled until moderation, rights, and audit controls pass release gates.
