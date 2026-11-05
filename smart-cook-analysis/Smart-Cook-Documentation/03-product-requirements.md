# 03 — Product Requirements

## 1. Requirement conventions

- `MUST`: mandatory for the stated release.
- `SHOULD`: strongly recommended.
- `COULD`: optional / later.
- `PROPOSED`: design proposal that requires implementation validation.

## 2. Accounts and onboarding

| ID | Requirement | Priority |
|---|---|---|
| ACC-01 | App supports guest use for eligible core personal features | MUST |
| ACC-02 | User can register and sign in using supported providers | MUST |
| ONB-01 | First run asks for interface language | MUST |
| ONB-02 | First run allows selecting multiple preferred cuisines | MUST |
| ONB-03 | Language and cuisine preferences can be changed later | MUST |
| ONB-04 | User can configure measurement system and household size | SHOULD |
| ONB-05 | User can configure allergies and dietary preferences | MUST before personalized safety filtering |

## 3. Recipe discovery

| ID | Requirement | Priority |
|---|---|---|
| REC-01 | Search recipes by title and normalized ingredients | MUST |
| REC-02 | Filter by cuisine, meal type, time, difficulty, and dietary attributes | MUST |
| REC-03 | Distinguish editorial, partner, community, and AI-assisted provenance | MUST |
| REC-04 | Display creator attribution and verification/review status | MUST |
| REC-05 | Support preferred-cuisine feed and global exploration | MUST |
| REC-06 | Paginate feeds and search results | MUST |

## 4. Recipe creation and publishing

| ID | Requirement | Priority |
|---|---|---|
| CRT-01 | User can create and edit a draft | MUST |
| CRT-02 | Recipe editor supports structured ingredients, quantities, units, groups, and ordered steps | MUST |
| CRT-03 | User can attach media and confirm rights to each uploaded asset | MUST |
| CRT-04 | User must review and accept the applicable creator-rights agreement before submission | MUST |
| CRT-05 | Submission triggers automated validation | MUST |
| CRT-06 | Every submitted user-created recipe requires human review, including recipes intended to remain private | MUST |
| CRT-07 | AI cannot grant final approval or publish a recipe | MUST |
| CRT-08 | Creator can see status, review feedback, and required changes | MUST |
| CRT-09 | Creator can revise and resubmit | MUST |
| CRT-10 | Approved recipe can be private or public if visibility controls are supported | SHOULD |
| CRT-11 | Public recipe pages preserve creator attribution and version provenance | MUST |
| CRT-12 | Creator can request withdrawal under the notice-based process | MUST |

## 5. Cooking and organization

| ID | Requirement | Priority |
|---|---|---|
| KIT-01 | User can manage pantry ingredients | MUST |
| KIT-02 | Recipe matcher compares pantry contents with recipe ingredients | MUST |
| KIT-03 | Missing ingredients can be added to shopping list | MUST |
| KIT-04 | User can scale recipe servings | MUST |
| KIT-05 | Cook mode presents one step at a time and supports timers | MUST |
| KIT-06 | Completed cooking session can be recorded | SHOULD |
| KIT-07 | Meal planning supports date and meal type | SHOULD |
| KIT-08 | Shopping list can group duplicate ingredients | SHOULD |

## 6. Localization and translation

| ID | Requirement | Priority |
|---|---|---|
| LOC-01 | Interface supports localized strings and locale switching | MUST |
| LOC-02 | Recipe retains its original language | MUST |
| LOC-03 | Translations are stored as separate versioned records | MUST |
| LOC-04 | Machine translations are labeled as such | MUST |
| LOC-05 | Corrected translations retain editor and revision history | SHOULD |
| LOC-06 | RTL and LTR layouts are supported | MUST |

## 7. Moderation and safety

| ID | Requirement | Priority |
|---|---|---|
| MOD-01 | Automated checks run before human review | MUST |
| MOD-02 | Human reviewer approval is mandatory before any user recipe becomes available as an approved recipe | MUST |
| MOD-03 | Reviewer cannot approve their own submission | MUST |
| MOD-04 | Risk tier determines reviewer specialization and checklist | MUST |
| MOD-05 | Reports and urgent restriction are supported | MUST before public community scale |
| MOD-06 | All moderation decisions are auditable | MUST |
| MOD-07 | Allergy and food-safety warnings are not generated solely from free-form AI text | MUST |

## 8. Non-functional requirements

- Security: enforce server-side authorization; never trust client state for publishing or rights.
- Reliability: failed uploads and submissions must be retryable without duplicate records.
- Performance: recipe discovery and local matching should remain responsive on supported low/mid-range devices.
- Accessibility: support screen readers, scalable text, contrast, and touch targets.
- Localization: avoid hard-coded language assumptions and layout-direction bugs.
- Privacy: data collection and retention must be documented and minimized.
- Observability: log operational events without exposing credentials or unnecessary personal data.
- Scalability: begin with a modular backend; split services only when measurable needs justify it.

## 9. Release scope

### Existing app foundation — verify in repository
The completion report describes Flutter, Drift, local pantry, recipe matching, cook mode, shopping list, guest/auth, sync, and automated tests. See `14-current-state-and-migration-notes.md`.

### Community release prerequisites
- server-authoritative recipe workflow;
- creator rights acceptance;
- media rights declarations;
- moderation queue and reviewer roles;
- audit log;
- public visibility enforcement;
- takedown/withdrawal operations;
- reporting and abuse controls.

Do not expose public recipe submission until these prerequisites are implemented and tested.
