# 11 — Roadmap and Delivery Plan

## 1. Delivery strategy

Prioritize a reliable cooking core first, then build creator publishing as a governed platform capability. Community publishing must not be enabled before rights and moderation foundations are operational.

## 2. Phases

### Phase 0 — Repository and product audit
- inspect current Flutter project;
- inspect Drift schema and migrations;
- inspect authentication and sync behavior;
- verify tests and CI;
- reconcile documentation with actual implementation;
- identify technical debt and release blockers.

**Exit criteria:** verified implementation inventory and prioritized gap list.

### Phase 1 — Product and legal foundations
- finalize creator agreement;
- finalize content policy and review rules;
- define cuisine and ingredient taxonomy;
- finalize recipe versioning and provenance;
- approve moderation roles and escalation paths.

**Exit criteria:** signed-off product/legal specifications.

### Phase 2 — Backend community foundation
- recipe/version APIs;
- rights agreement records;
- asset rights declarations;
- private media upload pipeline;
- automated validation;
- submission and review queue;
- server authorization and audit log.

**Exit criteria:** end-to-end submission and human review in staging; no public bypass.

### Phase 3 — Creator experience
- recipe editor;
- draft management;
- rights disclosure and acceptance;
- submission status;
- reviewer feedback;
- revision and resubmission;
- approved private/public visibility.

**Exit criteria:** invited creators can complete the full workflow.

### Phase 4 — Community launch readiness
- reports and appeals;
- specialist review;
- takedown/withdrawal handling;
- creator profiles and attribution;
- analytics;
- moderation staffing and operating procedures.

**Exit criteria:** pilot metrics meet thresholds set by product and operations owners.

### Phase 5 — Global expansion
- additional languages;
- translation correction workflow;
- cuisine discovery improvements;
- creator tools and editorial features;
- community groups/following only when moderation capacity supports them.

## 3. Suggested release grouping

| Release | Scope |
|---|---|
| Existing foundation | Pantry, local matching, cook mode, shopping, offline-aware base — verify current code |
| MVP refinement | Reliable recipe catalog, localization, core cooking journeys |
| Creator V1 | Drafts, submission, automated checks, human review, rights acceptance |
| Community V1.5 | Ratings, reports, appeals, creator profiles, attribution |
| Community V2 | Following, collections, groups, advanced discovery |

## 4. Dependencies

- Creator publishing depends on legal agreement and rights evidence.
- Public media depends on quarantine, scanning, and review.
- Community scale depends on reviewer tooling and moderation staffing.
- AI translation depends on provider no-training controls.
- Public discovery depends on server-authoritative publication status.

## 5. Delivery management

For each feature:
- write acceptance criteria;
- identify owner;
- identify backend/mobile dependencies;
- add migration plan;
- add automated tests;
- define telemetry;
- document rollback strategy;
- release behind a feature flag where appropriate.

## 6. Rollout

1. Internal testing.
2. Closed pilot with invited creators and reviewers.
3. Limited public beta with capped submissions.
4. Review operational metrics and safety/rights incidents.
5. Expand by language/cuisine only when staffing and quality are sufficient.

Avoid committing to calendar durations before repository audit and team capacity are known.
