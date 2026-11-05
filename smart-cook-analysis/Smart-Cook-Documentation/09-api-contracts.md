# 09 — Proposed API Contracts

> Endpoint names are illustrative. Confirm the chosen backend framework and routing conventions before implementation.

## 1. API conventions

- Base path: `/api/v1`
- JSON request/response.
- Authenticated routes require a valid access token.
- Use UUIDs for public resource identifiers.
- Use idempotency keys for submissions and uploads where duplicate requests are possible.
- Use server timestamps.
- Return structured validation errors.
- Never accept publication status or reviewer identity as trusted client input.

### Standard success response

```json
{
  "success": true,
  "data": {},
  "meta": {
    "request_id": "req_..."
  }
}
```

### Standard error response

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The submitted data is invalid.",
    "details": []
  },
  "meta": {
    "request_id": "req_..."
  }
}
```

## 2. Discovery

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/recipes` | Search and filter approved recipes |
| GET | `/recipes/{recipeId}` | Read a public/authorized recipe |
| GET | `/recipes/{recipeId}/versions/{versionId}` | Read a version if authorized |
| GET | `/cuisines` | List cuisine taxonomy |
| GET | `/ingredients` | Search normalized ingredients |

Public listing must return only approved public recipes.

## 3. Creator endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/creator/recipes` | Create a draft |
| PATCH | `/creator/recipes/{recipeId}` | Update owned draft |
| POST | `/creator/recipes/{recipeId}/versions` | Create a new immutable version |
| POST | `/creator/recipes/{recipeId}/submit` | Submit a version for review |
| GET | `/creator/submissions` | List creator submissions |
| GET | `/creator/submissions/{submissionId}` | View status and feedback |
| POST | `/creator/submissions/{submissionId}/appeal` | Request reconsideration |
| POST | `/creator/recipes/{recipeId}/withdrawal-requests` | Request withdrawal |

Submission must verify that:
- creator owns the recipe;
- required fields are complete;
- rights agreement version is accepted;
- asset rights declarations exist;
- idempotency key is valid;
- no conflicting pending submission exists.

## 4. Media endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/media/upload-intents` | Request scoped upload authorization |
| POST | `/media/{mediaId}/complete` | Confirm upload completion |
| GET | `/media/{mediaId}` | Resolve media if authorized |
| DELETE | `/creator/media/{mediaId}` | Remove unattached/unpublished asset where permitted |

Uploads should go to quarantine/private storage. Public delivery is enabled only after relevant approval.

## 5. Review endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/review/queue` | Fetch permitted review tasks |
| GET | `/review/submissions/{submissionId}` | Read review package |
| POST | `/review/submissions/{submissionId}/decision` | Approve, request changes, reject, or escalate |
| POST | `/review/reports/{reportId}/resolve` | Resolve a report |

The server derives reviewer identity from authentication. It must reject self-review and unauthorized role actions.

## 6. Rights endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/creator/agreements/current` | Read current agreement |
| POST | `/creator/agreements/accept` | Record acceptance |
| GET | `/creator/agreements/history` | Read historical acceptances |
| GET | `/creator/rights/{contentId}` | Read rights status |
| POST | `/creator/rights/{contentId}/withdrawal` | Request withdrawal |

Acceptance endpoint must store immutable agreement version and evidence. Do not allow clients to edit historical records.

## 7. AI gateway endpoints

Potential endpoints:
- `POST /ai/ingredient-extraction`
- `POST /ai/recipe-assist`
- `POST /ai/translation`
- `POST /ai/substitution-suggestions`

Every request must declare purpose and content provenance. The backend must enforce the no-training restriction for community content and select only providers/configurations that meet the policy.

## 8. Example submission payload

```json
{
  "recipe_version_id": "00000000-0000-0000-0000-000000000000",
  "visibility_requested": "public",
  "agreement_id": "00000000-0000-0000-0000-000000000000",
  "asset_declarations_complete": true
}
```

The server must not accept `approved`, `published`, `reviewer_id`, or `risk_tier` as authoritative client fields.

## 9. HTTP status guidance

- `200`: successful read/update.
- `201`: resource created.
- `202`: accepted for asynchronous processing/review.
- `400`: malformed request.
- `401`: unauthenticated.
- `403`: authenticated but not authorized.
- `404`: resource absent or intentionally concealed.
- `409`: version conflict or duplicate state transition.
- `422`: validation failure.
- `429`: rate limited.
- `500`: unexpected server failure.

## 10. API release gates

- contract tests;
- authorization tests for every role;
- no public read of pending/rejected/private content;
- no self-approval;
- immutable agreement evidence;
- idempotent submission;
- upload quarantine and public media access tests;
- audit event verification.
