# 10 — Security, Privacy, and Compliance

## 1. Security objectives

Protect:
- user accounts and personal preferences;
- private recipes and drafts;
- unpublished media;
- creator-rights agreements;
- moderation decisions and reviewer identities;
- pantry, shopping, and meal-planning data;
- AI provider credentials and usage.

## 2. Authorization model

Use server-side role and ownership checks.

Roles:
- Guest
- Registered User
- Creator
- Moderator
- Culinary Reviewer
- Rights Reviewer
- Content Manager
- Administrator

A user may hold multiple roles, but permissions should be explicit and least-privilege.

## 3. Critical controls

- Deny public access to drafts and pending submissions.
- Deny public access to unapproved media.
- Enforce ownership checks on creator endpoints.
- Prevent self-review and self-approval.
- Require step-up authorization for sensitive admin actions where appropriate.
- Record immutable audit events for rights and moderation changes.
- Apply rate limits to login, submissions, uploads, reports, and AI endpoints.
- Validate file signatures, not only filename extensions.
- Scan uploaded files and restrict executable content.
- Use short-lived signed URLs for private media.
- Store secrets only in backend secret management.
- Rotate credentials and separate environments.

## 4. Privacy principles

- Collect only data needed for a stated feature.
- Do not request precise location by default.
- Make analytics and notification choices clear.
- Explain retention and deletion behavior.
- Provide account deletion and data export paths where required.
- Avoid collecting contacts or unrelated device data.
- Redact personal data from logs.
- Keep private recipe content private, including in analytics and support tooling.

## 5. AI data handling

Community recipe content is **never** used for model training or fine-tuning.

Operational AI processing must:
- be purpose-limited;
- use an approved provider configuration;
- disable provider training on submitted content;
- minimize retention;
- avoid unnecessary personal data;
- be disclosed in privacy documentation;
- be logged at a metadata level without storing more content than needed.

If provider terms/configuration cannot satisfy these conditions, do not send community content to that provider.

## 6. Food safety and allergy controls

- Derive known allergens from normalized ingredient metadata.
- Preserve uncertainty when ingredient mapping is incomplete.
- Do not claim a recipe is allergen-free solely because no allergen was detected.
- Provide clear warnings for cross-contact and substitutions where appropriate.
- Escalate dangerous instructions and medical claims.
- Keep safety review separate from popularity ranking.
- Provide reporting and urgent restriction mechanisms.

## 7. Legal and compliance review

The product is intended for a global audience. Requirements may differ by jurisdiction, including privacy, consumer protection, copyright, platform rules, and food-related claims.

Before launch:
- obtain legal review of creator exclusivity and commercial license;
- review withdrawal and sublicensing clauses;
- review privacy notice and consent flows;
- review age and user-generated-content policy;
- review platform store policies;
- review AI provider data processing terms;
- define regional response process for rights and safety complaints.

This document is not legal advice.
