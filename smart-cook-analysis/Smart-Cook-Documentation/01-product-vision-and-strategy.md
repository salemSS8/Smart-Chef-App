# 01 — Product Vision and Strategy

## 1. Vision

Make cooking easier and more inspiring for people everywhere by connecting ingredients, recipes, culinary cultures, creators, and practical cooking tools in one global platform.

## 2. Mission

Help users answer four recurring questions:
1. What can I cook with what I have?
2. What new dishes and cuisines can I discover?
3. How can I create, improve, and share my own recipes?
4. How can I prepare a meal successfully, step by step?

## 3. Product promise

**Discover. Create. Share. Cook.**

- Discover recipes across local and international cuisines.
- Create structured recipes manually or with AI assistance.
- Share approved recipes with a global cooking community.
- Cook with guided steps, timers, serving adjustments, and ingredient tools.

## 4. Global-by-design experience

Smart Cook is global from launch, not an Arabic-only product with later localization.

### First-run onboarding
- Select application language.
- Select one or more preferred cuisines.
- Optionally select dietary preferences, allergies, household size, and measurement system.
- Explain that all preferences can be changed later.

### Examples
- A user in Denmark may choose Danish as the interface language and Danish/Nordic cuisines as preferences.
- A user in Japan may choose Japanese and Japanese cuisine.
- Both users can explore other cuisines without changing their preferred-cuisine settings.

### Preference model
Keep these concepts separate:
- `locale`: interface language.
- `preferred_cuisines`: personalized feed preferences.
- `exploration_settings`: discovery breadth and exclusions.
- `measurement_system`: metric, US customary, or other supported system.
- `region`: optional region used for ingredient naming and cultural context; do not infer precise location unnecessarily.

## 5. Target audiences

### Primary
People who enjoy cooking, discovering cuisines, and experimenting with ingredients.

### Secondary
- Beginners who need clear steps and confidence.
- Families and household kitchen managers.
- Creators who want to publish and build a recipe portfolio.
- Experienced cooks who want to document and share variations.

## 6. Core product pillars

| Pillar | User value | Product capabilities |
|---|---|---|
| Discover | Find relevant and inspiring food | Search, filters, cuisine feeds, recommendations |
| Create | Turn cooking knowledge into structured recipes | Recipe editor, drafts, ingredient mapping, AI assistance |
| Share | Publish work with attribution and clear rights | Review, creator profile, sharing, moderation |
| Cook | Successfully execute a recipe | Cook mode, timers, servings, substitutions |
| Organize | Reduce household cooking friction | Pantry, shopping list, meal planning |
| Understand | Make recipes usable across languages | Original-language preservation, translations, units |

## 7. Recipe as a reusable product object

A recipe should not be treated as a plain social post. It should be structured enough to support:
- ingredient matching against pantry inventory;
- shopping list generation;
- serving-size scaling;
- meal planning;
- step-by-step cook mode;
- timers;
- translation;
- ingredient substitutions;
- ratings and cooking outcomes;
- provenance, creator attribution, and rights enforcement.

## 8. Product principles

1. **Global, culturally respectful:** do not assume one cuisine or language is the default for all users.
2. **Structured, not merely textual:** recipes need normalized ingredients and ordered steps.
3. **Human accountability:** AI may assist, but humans own publication decisions.
4. **Safety before engagement:** allergy and food-safety information must not be sacrificed for growth.
5. **Creator transparency:** explain ownership, exclusivity, commercial use, withdrawal, and AI restrictions before submission.
6. **Offline-aware:** core personal cooking workflows should remain useful without a connection where feasible.
7. **Privacy by design:** collect only data required for product functionality.
8. **Attribution integrity:** translations, edits, and derivative versions must preserve provenance.

## 9. North Star metric

**Weekly Cooked Meals:** the number of cooking sessions users mark as completed each week.

Supporting metrics:
- recipe-to-cook conversion;
- weekly active cooks;
- successful recipe completion rate;
- repeat cooking rate;
- recipe saves and meal-plan additions;
- community submission and approval rates;
- moderation turnaround time;
- safety and rights report rates.

## 10. Out of scope for initial delivery

Unless separately approved:
- direct creator revenue sharing;
- public recipe publishing without human review;
- training AI models on community content;
- unrestricted scraping/import of third-party recipe websites;
- complex creator subscriptions or paid recipe marketplaces;
- microservices architecture before scale justifies it.
