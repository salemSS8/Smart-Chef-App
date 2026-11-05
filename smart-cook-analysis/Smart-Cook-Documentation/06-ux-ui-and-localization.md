# 06 — UX/UI and Localization

## 1. Experience principles

- Cooking context first: users may have wet hands, limited attention, or a small screen.
- Clear hierarchy: recipe title, time, servings, ingredients, and steps should be easy to scan.
- Global by design: language and cuisine preferences are separate settings.
- Trust: show provenance, review status, creator attribution, and AI assistance clearly.
- Accessible: scalable text, contrast, screen-reader labels, and large touch targets.

## 2. Primary navigation proposal

1. Home / Today
2. Discover
3. Create
4. Kitchen / Pantry
5. Profile

Shopping list and meal plan can be surfaced contextually and/or as secondary destinations.

## 3. Core screens

### Onboarding
- language selection;
- preferred cuisine selection;
- optional dietary and allergy settings;
- measurement system;
- clear explanation that preferences are editable later.

### Home / Today
- recipe suggestions based on pantry and preferences;
- continue cooking;
- planned meals;
- recently viewed or saved recipes;
- global discovery entry points.

### Discover
- search;
- cuisine filters;
- preferred and global feeds;
- meal type, time, difficulty, dietary filters;
- provenance labels.

### Recipe details
- hero image and attribution;
- cuisine, time, servings, difficulty;
- ingredients and quantities;
- allergens and safety information;
- steps and equipment;
- save, plan, shop, cook, and share actions;
- translation indicator and original language.

### Recipe editor
- title and description;
- cuisine and tags;
- ingredient picker with quantities and units;
- ingredient groups;
- ordered steps and timers;
- media upload;
- AI assistance with disclosure;
- rights declarations;
- preview and submit.

### Creator dashboard
- drafts;
- submitted recipes;
- review feedback;
- approved private recipes;
- published recipes;
- withdrawal requests;
- profile and analytics.

### Reviewer workspace
- review queue;
- risk tier;
- structured checklist;
- media and rights evidence;
- prior decisions;
- approve / request changes / reject / escalate;
- audit history.

## 4. Localization rules

- Use locale-aware date, number, and unit formatting.
- Store canonical ingredient identifiers separately from translated display names.
- Preserve the original recipe language and source text.
- Store translations as separate records with language, revision, status, and provenance.
- Label machine-generated translations.
- Do not overwrite the original when a translation is corrected.
- Support RTL and LTR layouts and mixed-direction content.

## 5. Cuisine taxonomy

Cuisine taxonomy should support:
- broad regions;
- national and regional cuisines;
- sub-cuisines and culinary traditions;
- user-selected preferred cuisines;
- editorial taxonomy review.

Do not force every recipe into only one country category. Allow multiple cuisine tags and cultural context where appropriate.

## 6. Accessibility and cook mode

Cook mode should:
- show one primary step at a time;
- offer large next/back controls;
- expose timers with accessible labels;
- prevent accidental step loss;
- support screen-awake behavior only while active and with clear lifecycle cleanup;
- support voice/TTS as optional features;
- preserve progress locally during temporary disconnection.

## 7. UX states to design

Every data-driven screen must include:
- loading;
- empty;
- error;
- offline;
- retry;
- permission denied;
- restricted content;
- pending review;
- needs changes;
- successful completion.

## 8. Design-system deliverables

- typography scale per supported script;
- spacing and sizing tokens;
- color tokens with contrast validation;
- semantic status colors;
- RTL/LTR component behavior;
- form validation patterns;
- image aspect ratios and placeholders;
- reusable recipe cards and ingredient rows;
- accessibility and golden-test guidelines.
