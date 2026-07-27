# Module: `team`

## Schema Mapping

| KCL Schema | Upstream ODCS Entity | Notes |
|---|---|---|
| `TeamMember` (`team/member.k`) | `$defs.TeamMember` | Inherits `common.TagsDiscoverable`; adds its own `check` for `dateIn`/`dateOut` |
| `Team` (`team/team.k`) | `$defs.Team` | Inherits `common.TagsDiscoverable`; `members: [TeamMember]` |

## Architecture Decisions

- `TeamMember` keeps its own `check` block for `dateIn`/`dateOut` rather than folding date validation into a shared base, because `AuthoritativeCustomizable`/`TagsDiscoverable` (see [common](common.md)) only model the trio that's identical across *every* consumer. `dateIn`/`dateOut` are unique to `TeamMember` and don't belong in a shared base that only one schema uses.
- Added in this pass: `dateIn`/`dateOut` are now validated against `^\d{4}-\d{2}-\d{2}$` (ISO 8601 date), mirroring upstream's `format: "date"` on both fields. Previously they were unvalidated `str`, silently accepting any string.
- `Team.members` stays a plain `[TeamMember]` list with no uniqueness check on `username`: matches upstream, which has no `uniqueItems` constraint on `members` either.
- `replacedByUsername` requires `dateOut` to be set (`replacedByUsername == Undefined or dateOut != Undefined`). Upstream states no such constraint, but a member who has been replaced and has no departure date is self-contradictory, and the standard offers no other way to express "replaced". This recovers the field's intent without hard-failing on the far more common case where both are simply absent. The sibling `enkinex-odcs` enforces the same rule on its `TeamMember`.

## Open Questions

- `dateOut` isn't checked against `dateIn` for ordering (e.g. `dateOut >= dateIn`). Upstream doesn't require it either, but it's a plausible future tightening if bad data shows up in practice.
- `replacedByUsername` isn't cross-checked against any other member's `username` in the same `Team.members` list (doing so would require a `check` with access to sibling list context, which is awkward in KCL's per-schema `check` model): left as an open `str`, same as upstream.
