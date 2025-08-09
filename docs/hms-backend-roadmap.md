# HMS Backend – Task Map & Roadmap

**Scope:** Backend-only (.NET, Clean Architecture). Frontend explicitly out-of-scope.

**Import tip:** In GitHub → Issues → Import → upload the CSV to create issues with milestones.


## Milestones

- **M0 – Repo & DevEx** — Initialize solution, tooling, and developer experience.
- **M1 – Auth & RBAC** — JWT auth, user/role management, policies.
- **M2 – Core Domain (Patients/Doctors)** — CRUD, validation, search, pagination.
- **M3 – Scheduling & Appointments** — Slots, booking, conflicts, reminders (stub).
- **M4 – Admissions & Beds** — Wards/beds, admissions lifecycle, transfers.
- **M5 – Clinical (Encounters/Vitals/Rx)** — Encounters, vitals, prescriptions.
- **M6 – Pharmacy** — Drugs, stock, dispensing, reorder levels.
- **M7 – Laboratory** — Test catalog, orders, results.
- **M8 – Billing & Payments** — Invoices, payments, voids, idempotency.
- **M9 – Insurance** — Payers, claims, statuses.
- **M10 – Notifications** — Provider abstraction, templates, send pipeline (stub).
- **M11 – Reporting** — Aggregations for admissions, revenue, occupancy, TAT.
- **M12 – Audit & Config** — Audit trail and system config endpoints.
- **M13 – NFR: Security/Perf/Obs** — Hardening, perf budgets, logging/metrics/tracing.
- **M14 – CI/CD & Deploy** — GitHub Actions, migrations, environment configs.
- **M15 – Seed Data & Fixtures** — Minimal seeds and sample fixtures for demos/tests.
- **M16 – OpenAPI Sync & Docs** — Spec sync, Swagger UI, Postman.
- **M17 – UAT & Hardening** — Bug triage, polish, release checklist.

---

## Definition of Done (per module)

- API endpoints match OpenAPI 3.1 spec (req/resp bodies).
- RBAC enforced; negative tests added.
- Validation -> RFC7807 ProblemDetails; global exception handling.
- EF migrations created/applied; indexes where needed.
- Unit tests for services; integration tests for controllers.
- Structured logs & audit on writes where applicable.
- Swagger UI updated; examples added; Postman tests updated.

---

## Risk Register

- **Data model churn:** Stabilize entities early; version endpoints; careful migrations.
- **Auth complexity:** Keep roles minimal; centralize policies; integration tests.
- **Scheduling conflicts:** Centralize detection; deterministic tests.
- **Pharmacy concurrency:** Transactions/row version; race condition tests.
- **Report perf:** Pre-aggregate; indexes; volume testing.

---


### M0 – Repo & DevEx

- [ ] **Create .NET solution with Clean Architecture skeleton** (4h, P0)
  Projects: Api, Application, Domain, Infrastructure, Tests. Add Directory.Build.props, analyzers, nullable, implicit usings.
  _Labels:_ backend,setup
  _Depends on:_ —

- [ ] **Add EF Core + Sqlite dev database** (3h, P0)
  Install EF Core packages; add DbContext; configure connection string; health check endpoint.
  _Labels:_ backend,db
  _Depends on:_ —

- [ ] **Add initial migration & apply** (2h, P0)
  Create migration, ensure created on startup in Dev; add tooling scripts.
  _Labels:_ backend,db
  _Depends on:_ Add EF Core + Sqlite dev database

- [ ] **Wire Serilog + minimal structured logging** (2h, P1)
  Request logging, correlation IDs, console sink; dev-friendly template.
  _Labels:_ backend,observability
  _Depends on:_ —


### M1 – Auth & RBAC

- [ ] **Implement JWT auth** (6h, P0)
  Endpoints: /auth/login, /auth/refresh, /auth/logout. Store refresh tokens (DB).
  _Labels:_ backend,auth
  _Depends on:_ Create .NET solution with Clean Architecture skeleton

- [ ] **Seed roles and admin user** (2h, P0)
  Roles: Admin, Doctor, Nurse, Receptionist, Pharmacist. Admin bootstrap via config.
  _Labels:_ backend,auth,seed
  _Depends on:_ Implement JWT auth

- [ ] **Add policy-based authorization** (4h, P0)
  RBAC policies for each resource; secure controllers by role; add unit tests for auth policies.
  _Labels:_ backend,auth
  _Depends on:_ Implement JWT auth; Seed roles and admin user

- [ ] **Rate limiting & CORS** (2h, P2)
  Add ASP.NET rate limiting middleware; configure CORS for localhost dev.
  _Labels:_ backend,security
  _Depends on:_ —


### M2 – Core Domain (Patients/Doctors)

- [ ] **Patients module (CRUD + search + soft delete)** (8h, P0)
  Endpoints: GET/POST/PATCH/DELETE /patients, /patients/{id}, filters & pagination.
  _Labels:_ backend,patients
  _Depends on:_ Add EF Core + Sqlite dev database

- [ ] **Doctors module (CRUD + schedule view stub)** (6h, P0)
  Endpoints: /doctors, /doctors/{id}, /doctors/{id}/schedule (stub).
  _Labels:_ backend,doctors
  _Depends on:_ Add EF Core + Sqlite dev database

- [ ] **Validation & problem details middleware** (3h, P0)
  FluentValidation; RFC7807 problem responses; global exception handling.
  _Labels:_ backend,quality
  _Depends on:_ Patients module (CRUD + search + soft delete)


### M3 – Scheduling & Appointments

- [ ] **Schedules & resources model** (6h, P0)
  Entities for resource slots; APIs /schedules (GET/POST). Conflict detection utilities.
  _Labels:_ backend,schedules
  _Depends on:_ Doctors module (CRUD + schedule view stub)

- [ ] **Appointments booking with conflict detection** (8h, P0)
  Endpoints: /appointments (GET/POST/PATCH), idempotent POST via Idempotency-Key.
  _Labels:_ backend,appointments
  _Depends on:_ Schedules & resources model

- [ ] **Appointment reminders (adapter stub)** (2h, P2)
  Endpoint: /appointments/{id}/remind -> send via notifications pipeline (no external provider).
  _Labels:_ backend,appointments,notifications
  _Depends on:_ Appointments booking with conflict detection


### M4 – Admissions & Beds

- [ ] **Departments/Wards/Beds data model** (6h, P0)
  Endpoints: /departments, /wards, /beds. Bed status transitions.
  _Labels:_ backend,admissions
  _Depends on:_ Add EF Core + Sqlite dev database

- [ ] **Admissions lifecycle** (8h, P0)
  Endpoints: /admissions (POST/GET/PATCH), /admissions/{id}/discharge. Transfers & validations.
  _Labels:_ backend,admissions
  _Depends on:_ Departments/Wards/Beds data model


### M5 – Clinical (Encounters/Vitals/Rx)

- [ ] **Encounters & Vitals** (6h, P1)
  Endpoints: /encounters, /patients/{id}/vitals (GET/POST).
  _Labels:_ backend,clinical
  _Depends on:_ Patients module (CRUD + search + soft delete)

- [ ] **Prescriptions** (6h, P1)
  Endpoints: /prescriptions (GET/POST/PATCH), /prescriptions/{id}/cancel.
  _Labels:_ backend,clinical,pharmacy
  _Depends on:_ Encounters & Vitals


### M6 – Pharmacy

- [ ] **Pharmacy inventory** (6h, P1)
  Endpoints: /drugs (GET/POST/PATCH); low stock filters; expiries.
  _Labels:_ backend,pharmacy
  _Depends on:_ Prescriptions

- [ ] **Dispensing & stock decrement** (6h, P1)
  Endpoint: /dispense. Atomic stock updates; basic locking.
  _Labels:_ backend,pharmacy
  _Depends on:_ Pharmacy inventory


### M7 – Laboratory

- [ ] **Lab test catalog** (4h, P1)
  Endpoints: /lab/tests (GET/POST).
  _Labels:_ backend,laboratory
  _Depends on:_ —

- [ ] **Lab orders & results** (8h, P1)
  Endpoints: /lab/orders (GET/POST/PATCH), /lab/orders/{id}/results.
  _Labels:_ backend,laboratory
  _Depends on:_ Lab test catalog


### M8 – Billing & Payments

- [ ] **Invoices** (6h, P0)
  Endpoints: /billing/invoices (GET/POST/PATCH), totals & balances.
  _Labels:_ backend,billing
  _Depends on:_ Patients module (CRUD + search + soft delete)

- [ ] **Payments (idempotent)** (6h, P0)
  Endpoint: /billing/invoices/{id}/payments (POST); Idempotency-Key support.
  _Labels:_ backend,billing
  _Depends on:_ Invoices

- [ ] **Void invoice** (3h, P1)
  Endpoint: /billing/invoices/{id}/void (POST).
  _Labels:_ backend,billing
  _Depends on:_ Invoices


### M9 – Insurance

- [ ] **Insurance payers & claims** (6h, P2)
  Endpoints: /insurance/payers (GET), /insurance/claims (GET/POST/PATCH).
  _Labels:_ backend,insurance
  _Depends on:_ Invoices


### M10 – Notifications

- [ ] **Notifications pipeline (provider-agnostic)** (6h, P2)
  Abstraction + in-memory provider; /notifications (GET), /notifications/test (POST).
  _Labels:_ backend,notifications
  _Depends on:_ —


### M11 – Reporting

- [ ] **Reports** (8h, P1)
  Endpoints: /reports/* (admissions, revenue, occupancy, lab-turnaround). Query-optimized reads.
  _Labels:_ backend,reporting
  _Depends on:_ Invoices; Admissions lifecycle; Lab orders & results


### M12 – Audit & Config

- [ ] **Audit trail** (6h, P0)
  Save actor, action, entity, timestamp. /audit (GET). Middleware/hook for writes.
  _Labels:_ backend,audit
  _Depends on:_ —

- [ ] **System config endpoints** (4h, P2)
  GET/PATCH /config. Feature toggles e.g., appointment slot length, low-stock threshold.
  _Labels:_ backend,config
  _Depends on:_ —


### M13 – NFR: Security/Perf/Obs

- [ ] **Security hardening** (6h, P0)
  OWASP checks: headers, HTTPS enforcement (behind proxy), input size limits, model binding limits.
  _Labels:_ backend,security
  _Depends on:_ Add policy-based authorization

- [ ] **Performance budgets & profiling** (6h, P1)
  Define latency SLAs; add minimal caching where safe; EF query tuning; indexes.
  _Labels:_ backend,performance
  _Depends on:_ Patients module (CRUD + search + soft delete)

- [ ] **Observability (metrics & tracing)** (6h, P1)
  Prometheus/OpenTelemetry exporters; request metrics; DB timings; correlation IDs plumbed.
  _Labels:_ backend,observability
  _Depends on:_ Wire Serilog + minimal structured logging


### M14 – CI/CD & Deploy

- [ ] **GitHub Actions CI** (6h, P0)
  Build, test, lint; cache NuGet; artifacts for API spec & swagger. Fail build if OpenAPI drift detected.
  _Labels:_ backend,ci
  _Depends on:_ —

- [ ] **Containerization & compose** (6h, P0)
  Dockerfile (release+dev), docker-compose for API + DB; healthchecks.
  _Labels:_ backend,devops
  _Depends on:_ Add EF Core + Sqlite dev database

- [ ] **Environment configs & migrations** (4h, P1)
  Appsettings per env; automatic migrations gated by env var; secrets via env.
  _Labels:_ backend,devops
  _Depends on:_ Add initial migration & apply


### M15 – Seed Data & Fixtures

- [ ] **Seed data & fixtures** (4h, P1)
  Minimal realistic data for demo & tests. Factories/builders for tests.
  _Labels:_ backend,seed
  _Depends on:_ Patients module (CRUD + search + soft delete)


### M16 – OpenAPI Sync & Docs

- [ ] **OpenAPI sync & Swagger UI** (4h, P0)
  Expose /swagger with the 3.1 spec; keep in sync with controllers; add example payloads.
  _Labels:_ backend,docs
  _Depends on:_ —

- [ ] **Postman collection export** (2h, P2)
  Export from OpenAPI; include environment with baseUrl + auth token variable.
  _Labels:_ backend,docs
  _Depends on:_ OpenAPI sync & Swagger UI


### M17 – UAT & Hardening

- [ ] **UAT checklist & release notes** (4h, P0)
  Smoke tests across modules; verify RBAC; prepare v1.0.0 notes and migration guide.
  _Labels:_ backend,release
  _Depends on:_ Reports; Audit trail; Security hardening
