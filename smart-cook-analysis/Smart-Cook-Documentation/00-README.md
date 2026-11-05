# Smart Cook — Documentation Hub

**Product:** Smart Cook  
**Positioning:** Global recipe discovery, creation, sharing, and cooking platform  
**Product tagline:** Discover. Create. Share. Cook.  
**Document baseline:** 2026-11-05  
**Status:** Product and engineering blueprint; implementation status must be verified against the repository before execution.

## 1. Product summary

Smart Cook is a global cooking platform that helps people discover recipes from cuisines around the world, create and publish their own recipes, manage kitchen ingredients, plan meals, shop for missing ingredients, and follow guided cooking sessions.

It is not only a recipe-reading application. A recipe is a structured, reusable product object that can power discovery, ingredient matching, shopping lists, meal planning, cooking mode, translations, and community participation.

## 2. Approved product decisions

| Area | Approved decision |
|---|---|
| Product scope | Global from launch |
| First-run setup | User selects language and preferred cuisines |
| Preferences | Language and cuisines can be changed later |
| Cuisine discovery | Both preferred cuisines and global exploration |
| Core promise | Broad cooking experience: discover, create, share, and cook |
| Brand personality | Hybrid: practical, friendly, and inspiring |
| Primary audience | People who enjoy cooking and culinary exploration |
| Secondary audiences | Beginners, families, and household kitchen managers |
| Community publishing | Human review is required before public publication |
| Automated review | Automated checks run before human review |
| Final publication authority | Human reviewer; AI cannot approve or publish |
| Private user-created recipes | No bypass of human review; private user-created recipe submissions are also subject to review |
| Creator ownership | Creator retains original ownership |
| Smart Cook license | Exclusive, worldwide license for explicitly enumerated rights, subject to final legal drafting |
| Creator earnings | Community model; no automatic direct payment for submitting a recipe |
| Withdrawal | Notice-based request process; exact notice period remains to be approved |
| AI training | Never use community recipe content to train or fine-tune AI models |
| Translation | Preserve source language; machine translation may be offered and corrected |

## 3. Important interpretation of the recipe review decision

No user-created recipe may bypass human review merely because it is private or not intended for public discovery.

The product must distinguish:
- **Draft:** an incomplete working copy not submitted for review.
- **Submitted/private-pending:** submitted for review but not publicly discoverable.
- **Approved/private:** human-approved content kept private by its creator, if private visibility is supported.
- **Published:** human-approved and publicly available.
- **Needs changes / Rejected / Restricted:** moderation outcomes.

Drafts are not published recipes. If the product later permits local-only notes that are not represented as recipes in the platform, that must be treated as a separate feature and must not silently bypass the approved recipe policy.

## 4. Documentation index

| File | Purpose |
|---|---|
| `01-product-vision-and-strategy.md` | Vision, value proposition, scope, positioning |
| `02-market-and-user-analysis.md` | Market assumptions, personas, user journeys |
| `03-product-requirements.md` | Functional and non-functional requirements |
| `04-content-and-creator-rights.md` | Content sources, ownership, licensing, withdrawal, AI restrictions |
| `05-recipe-review-and-moderation.md` | Review workflow, risk tiers, permissions, states |
| `06-ux-ui-and-localization.md` | Screens, onboarding, multilingual and RTL rules |
| `07-technical-architecture.md` | Flutter architecture, backend boundaries, offline-first strategy |
| `08-data-model.md` | Proposed entities, relationships, data ownership |
| `09-api-contracts.md` | Proposed API surface and response conventions |
| `10-security-privacy-and-compliance.md` | Security, privacy, moderation safety controls |
| `11-roadmap-and-delivery-plan.md` | Phases, dependencies, milestones |
| `12-quality-assurance-and-acceptance.md` | Test strategy and acceptance criteria |
| `13-operations-and-environment.md` | Environment variables, secrets, operations |
| `14-current-state-and-migration-notes.md` | Known implemented state, gaps, reconciliation checklist |
| `15-decisions-and-open-questions.md` | Decision register and unresolved items |

## 5. Source-of-truth rules

1. Product decisions in this package supersede conflicting assumptions in earlier drafts.
2. Existing implementation claims are not proof of current repository state; verify them against code, tests, CI, and deployed infrastructure.
3. Proposed tables, endpoints, services, and workflows are designs, not claims that they already exist.
4. Keep creator-rights agreement versions immutable and retain evidence of acceptance.
5. Never place real secrets in Markdown, source control, issue trackers, or client applications.
6. Update this index whenever files are added, renamed, or removed.

## 6. Recommended implementation sequence

1. Audit the current Flutter repository and reconcile `14-current-state-and-migration-notes.md`.
2. Freeze product requirements and the creator-rights agreement with qualified legal review.
3. Design the server-authoritative recipe, version, review, and license data model.
4. Implement backend authorization and review workflow before exposing public community publishing.
5. Implement creator submission and reviewer tooling.
6. Add translations, attribution, reporting, appeals, and creator analytics.
7. Expand community discovery only after moderation operations are measurable and sustainable.
