# 12 — Quality Assurance and Acceptance

## 1. Test layers

- Unit tests: domain rules, matching, validation, permissions.
- Widget tests: forms, states, RTL/LTR, accessibility.
- Integration tests: onboarding-to-cook journey and creator submission.
- API tests: contracts, auth, roles, idempotency, state transitions.
- Database tests: migrations, constraints, version immutability.
- Security tests: authorization bypass, IDOR, upload abuse, rate limits.
- Content tests: recipe structure, allergens, duplicate detection.
- Operational tests: review queue, escalation, withdrawal, audit trail.

## 2. Critical acceptance criteria

### Publishing
- Given an unreviewed user recipe, public API and feed must not return it.
- Given an automated pass, the recipe remains pending until a human decision.
- Given a private visibility request, the recipe still requires human review.
- Given a reviewer who is also the creator, approval is rejected.
- Given a recipe revision, the prior version remains immutable.
- Given a rejected recipe, the creator can see the permitted reason and next action.

### Rights
- Submission is blocked without required agreement acceptance.
- Historical agreement acceptance cannot be edited or deleted through normal creator APIs.
- Media cannot become public without a completed rights declaration and required review.
- Withdrawal request creates an auditable case and follows the approved notice policy.
- Community content is not sent to AI training/fine-tuning pipelines.

### Privacy
- User A cannot read User B's pantry, private drafts, or private recipe data.
- Pending media is inaccessible through public URLs.
- Logs do not expose tokens, passwords, or unnecessary recipe content.
- Account deletion follows documented retention and legal-hold exceptions.

### Cooking
- Ingredient matching handles aliases and normalized names.
- Serving scaling updates quantities consistently.
- Cook mode preserves progress across app backgrounding where feasible.
- Offline changes synchronize without silently duplicating shopping or pantry items.

## 3. Existing test report — verification required

The project completion report states:
- 39 automated tests passed;
- static analysis reported zero issues;
- 1,000-recipe matching benchmark completed in 3 ms;
- seven sprints were reported complete.

These figures are historical claims from the report, not a current CI result. Re-run tests and benchmarks from the current repository and record device, build mode, dataset, and environment.

## 4. Test data

Create fixtures for:
- complete and incomplete recipes;
- multiple languages and mixed RTL/LTR;
- common allergens and ambiguous ingredient mappings;
- media with valid/invalid rights declarations;
- duplicate submissions;
- malicious or oversized uploads;
- low/medium/high risk recipes;
- reviewers with conflicting ownership;
- withdrawal during pending review and after publication.

## 5. Release gates

Do not enable community publishing unless:
- all critical authorization tests pass;
- public reads exclude every non-published recipe;
- no self-approval is possible;
- agreement evidence is immutable;
- pending media is private;
- AI no-training policy is enforced contractually and technically;
- reviewer queue and escalation process are staffed;
- urgent report and restriction paths work;
- rollback and incident response are documented.
