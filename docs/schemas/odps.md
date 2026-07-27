# Module: `odps` (root package: `odps.k`)

## Schema Mapping

| KCL Schema / Type | Upstream ODCS Entity | Notes |
|---|---|---|
| `DataProduct` | root document object (top-level `properties`, not a `$defs` entry) | The whole descriptor |
| `KindType` | `properties.kind.enum` | Single-value enum promoted to a named literal union |
| `ApiVersionType` | `properties.apiVersion.enum` | Pinned to `"v1.0.0"`; upstream's `"v0.9.0"` alternative is deliberately dropped: see below |
| `StatusType` | `properties.status.examples` | Upstream leaves `status` open (`examples`, not `enum`); the port closes it: see below |

## Architecture Decisions

- `DataProduct` inherits `common.TagsDiscoverable` (see [common](common.md)) instead of repeating `tags`/`customProperties`/`authoritativeDefinitions` inline.
- `status` was promoted from an open `str` to the closed `StatusType` union, even though upstream only gives it `examples`, not an `enum`: unlike `ManagementPort.type`/`.content`, `Support.tool`/`.scope`, and `AuthoritativeDefinition.type`, which stay open `str` despite being `examples`-only too. This is a deliberate, non-uniform call: `status` is a small, stable lifecycle enum that most consumers branch on, so closing it catches typos early. The other `examples` fields are open-ended vocabularies (support tool names, management-port content types) where new values are expected to appear in practice before the spec (or this port) catches up.
- `productCreatedTs` keeps its own inline ISO-8601 date-time regex `check` rather than sharing a "Timestamp" alias with `team.TeamMember`'s date-only checks: the two formats differ (date-time vs. date-only) and there was only one date-time consumer, so a shared abstraction wasn't justified yet. The pattern requires the UTC offset (`Z` or `±HH:MM`), matching RFC 3339 — which is what upstream's `format: "date-time"` means.
- `ApiVersionType` is pinned to `"v1.0.0"` rather than mirroring upstream's `["v0.9.0", "v1.0.0"]` enum, because the two versions are **not shape-compatible** and this port models only the v1.0.0 shape. In v0.9.0 the root `team` is an *array* of team members; in v1.0.0 it is a `Team` *object* (v0.9.0 has no `$defs.Team` at all), and `TeamMember.username` went from optional to required. Accepting `apiVersion: v0.9.0` would therefore let a document type-check at the version field and then fail several fields later with a confusing `expected Team, got [...]` error. Pinning turns that into an immediate, accurate error at the `apiVersion` line. This mirrors the sibling `enkinex-odcs`, which pins `ApiVersionType = "v3.1.0"`. Note upstream's own `docs/examples/customer-data-product.odps.yaml` declares `v0.9.0` while using the v1.0.0 `team` object shape, so it does not validate against its own v0.9.0 schema; this port does not inherit that inconsistency.
- Root invariants are enforced as `check`s with explicit failure messages: `id` must be non-empty, `version` must be non-empty when supplied. Upstream's JSON Schema types both as plain strings, so `""` would otherwise validate — the same guard the sibling applies at its root.

## Open Questions

- If a future revision needs `ManagementPort.type`/`.content`, `Support.tool`/`.scope`, or `AuthoritativeDefinition.type` closed too, revisit `status`'s precedent: either close all `examples`-only fields consistently, or reopen `status` to match the rest.
- If a future ODPS revision ships a v1.1.0 (or later) that *is* shape-compatible with v1.0.0, `ApiVersionType` can widen back into a union rather than being re-pinned; the incompatibility that forced the pin is specific to the v0.9.0 → v1.0.0 `team` change.
