# Service Boundaries and Data Ownership

This design is based on the entities and endpoints documented in repository markdown files.

## Bounded Contexts

1. Identity and Access (`auth-service`)
- Owns: `users`, `roles`, token/credential artifacts.
- APIs: login, register, refresh token, password management.
- Publishes events: `UserRegistered`, `UserRoleChanged`, `PasswordChanged`.

2. Patient Domain (`patient-service`)
- Owns: `patients`, `patient_allergies`, `patient_emergency_contacts`, `patient_vitals`, `patient_insurance` (profile-level ownership).
- APIs: patient CRUD, patient search, allergies/contacts/vitals management.
- Consumes: identity claims from `auth-service`.

3. Doctor Domain (`doctor-service`)
- Owns: `doctors`, `doctor_qualifications`, `doctor_availability`, `doctor_ratings`.
- APIs: doctor CRUD, specializations, availability.

4. Scheduling (`appointment-service`)
- Owns: `appointments`, `appointment_symptoms`, `appointment_prescriptions`.
- APIs: schedule, conflict check, status transitions, cancellation.
- Depends on: patient and doctor existence (by IDs/events).

5. Clinical Records (`medical-records-service`)
- Owns: `medical_records`, `patient_medical_history`.
- APIs: record creation, retrieval, timeline view.

6. Hospital Operations (`department-service`, `staff-service`)
- Department owns: `departments`, `department_contact_info`, `department_locations`, `department_services`.
- Staff owns: `staff`, `staff_qualifications`, `staff_shift_schedules`, `staff_type` lookup.

7. Communication (`notification-service`)
- Owns templates, outbound messages, delivery state.
- Consumes domain events to notify users/patients/doctors.

## API Gateway Rules

- External clients only call `api-gateway`.
- Internal service-to-service calls use private DNS via ECS service discovery.
- Gateway applies JWT auth and propagates identity headers.

## Database Migration Strategy

Stage 1: Shared database with schema ownership rules
- Keep existing schema in one SQL Server instance.
- Enforce per-service schema namespaces and ownership contracts.

Stage 2: Split critical stores
- Move Identity and Appointments into dedicated databases.
- Introduce outbox/event relay to avoid distributed transactions.

Stage 3: Full decomposition
- Each service owns its persistence and migration pipeline.
- Cross-service reads through APIs/read models/events only.

## Event Contracts (initial)

- `AppointmentCreated`
- `AppointmentCancelled`
- `DoctorAvailabilityUpdated`
- `PatientAllergyUpdated`
- `MedicalRecordCreated`

## Non-Functional Standards

- Correlation ID required on all HTTP requests.
- OpenTelemetry tracing from gateway to services.
- Backward compatible API evolution with versioned endpoints (`/v1`, `/v2`).
