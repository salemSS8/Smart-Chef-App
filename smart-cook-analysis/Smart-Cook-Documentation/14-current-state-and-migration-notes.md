# 14 — Current State and Migration Notes

## 1. Reported implementation baseline

The available project completion report describes the following work as completed:

| Area | Reported status | Verification needed |
|---|---|---|
| Flutter app foundation | Seven sprints reported | Inspect branches, build, and release configuration |
| Feature-first / Clean Architecture | Reported | Inspect current folder structure |
| Drift local database | 10 tables, 5 DAOs reported | Inspect schema and migrations |
| Seed data | 50+ recipes and 150+ Arabic ingredients reported | Count actual records and validate quality |
| Recipe matching | Arabic normalization and Isolate matching reported | Re-run unit and performance tests |
| Cook mode | Wakelock and timers reported | Test lifecycle and device behavior |
| Shopping list | Reported | Verify aggregation and pantry transfer |
| Auth and sync | Guest auth and LWW sync reported | Inspect backend integration and conflict handling |
| Automated tests | 39 passing reported | Re-run current test suite |
| Static analysis | 0 issues reported | Re-run `flutter analyze` |
| CI/CD | GitHub Actions workflow reported | Inspect workflow and run current pipeline |
| Production readiness | Claimed by completion report | Independently verify store, security, backend, and operations readiness |

## 2. Data-count discrepancy

Earlier documents contain different content targets:
- completion report: 50+ recipes and 150+ Arabic ingredients reportedly seeded;
- product requirements: target of 300–500 curated recipes and a larger ingredient vocabulary.

These are not contradictory if one is current inventory and the other is a target. Preserve the distinction:
- **implemented inventory:** verify actual database count;
- **target inventory:** define editorial coverage and quality threshold.

Do not claim the target has been achieved until measured.

## 3. Architectural changes required for community

The existing local-first design is appropriate for personal cooking data, but community publishing needs server authority.

Required additions:
1. immutable recipe versions;
2. submission and review entities;
3. creator agreement and acceptance evidence;
4. per-asset rights declarations;
5. private media quarantine;
6. server-side publication state;
7. reviewer roles and segregation of duties;
8. moderation audit log;
9. report, appeal, and withdrawal workflows;
10. AI no-training enforcement.

## 4. Migration sequence

1. Create a branch and backup current database.
2. Inspect all existing recipe and user schemas.
3. Identify editorial versus user-created records.
4. Preserve existing IDs where possible.
5. Create version 1 records for legacy recipes.
6. Mark unknown provenance explicitly; do not fabricate license evidence.
7. Keep existing local drafts local until the new workflow is ready.
8. Add backend tables and APIs in staging.
9. Add mobile UI behind a feature flag.
10. Run authorization, privacy, and migration tests.
11. Pilot with invited creators.
12. Enable public publishing only after release gates pass.

## 5. Commands to run during audit

```bash
flutter --version
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test --coverage
```

Also inspect:
- `pubspec.yaml`;
- `lib/` structure;
- `test/`;
- Drift database definitions and migrations;
- auth and sync implementation;
- `.github/workflows/`;
- Android signing setup;
- iOS bundle configuration;
- backend schema and security policies;
- environment variable references.

## 6. Status vocabulary

Use only:
- `Implemented and verified`
- `Implemented but not recently verified`
- `Partially implemented`
- `Planned`
- `Blocked`
- `Not applicable`

Avoid blanket claims such as “100% production-ready” without evidence for backend, privacy, store compliance, monitoring, and operations.
