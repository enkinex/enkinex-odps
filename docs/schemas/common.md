# Module: `common`

## Schema Mapping

| KCL Schema / Type | Upstream ODCS Entity | Notes |
|---|---|---|
| `CustomProperty` (`common/property.k`) | `$defs.CustomProperty` | 1:1 |
| `Description` (`common/description.k`) | `$defs.Description` | Inherits `AuthoritativeCustomizable`; upstream has no `tags` on `Description`, matched exactly |
| `AuthoritativeDefinition` (`common/authoritative.k`) | `$defs.AuthoritativeDefinition` | 1:1; `check` validates `url` against `urlPattern` |
| `urlPattern` (`common/url.k`) | `format: "uri"` (applied to `AuthoritativeDefinition.url`, `SBOM.url`, `ManagementPort.url`, `Support.url`/`.invitationUrl`) | Bare module-level regex constant, not a `$defs` entity |
| `Tags` (`common/discovery.k`) | `$defs.Tags` | 1:1: `type Tags = [str]` |
| `datePattern` (`common/date.k`) | `format: "date"` (applied to `team.TeamMember.dateIn`/`.dateOut`) | Bare module-level regex constant, not a `$defs` entity |
| `AuthoritativeCustomizable` (`common/custom.k`) | no upstream equivalent | Synthesized base schema: see below |
| `TagsDiscoverable` (`common/discovery.k`) | no upstream equivalent | Synthesized base schema: see below |

## Architecture Decisions

- `AuthoritativeCustomizable`/`TagsDiscoverable` were introduced to eliminate the `tags`/`customProperties`/`authoritativeDefinitions` trio that was duplicated across `InputPort`, `OutputPort`, `ManagementPort`, `Support`, `TeamMember`, `Team`, and the root `DataProduct`. JSON Schema has no inheritance mechanism, so upstream repeats this trio in every `$defs` entry that needs it; KCL does, so this port doesn't have to. The names, and the `common/custom.k`/`common/discovery.k` file split, mirror the equivalent `Customizable`/`AuthoritativeCustomizable` and `StableIdDiscoverable`/`TagsDiscoverable` base-schema families in `enkinex-odcs`, so the two sibling libraries describe the same capability with the same vocabulary.
- Split into two schemas, not one, because upstream's own entities aren't uniform: `$defs.Description` has `customProperties` + `authoritativeDefinitions` but deliberately **no** `tags`. Rather than give `Description` an unused `tags` field, or duplicate the pair a second time, `AuthoritativeCustomizable` holds the pair and `TagsDiscoverable(AuthoritativeCustomizable)` layers `tags` on top: every consumer inherits from whichever base matches its actual upstream shape.
- `Tags` is a `type` alias (`[str]`), not a `schema`, because `$defs.Tags` upstream is a bare array with no internal structure: a schema wrapper would add nothing.
- `urlPattern` lives as a bare regex string in its own file (`common/url.k`) rather than inside `AuthoritativeDefinition` (its original, single consumer at the time), because it's reused by 4 schemas across 4 different packages (`common`, `product`, `management`, `support`). A package-level constant avoids a circular or awkward cross-import just to reach one string.
- The regex accepts any RFC-3986-style `scheme:opaque-part`, not only `scheme://authority`, specifically so `mailto:`/`tel:`-style URIs pass. `Support.url`'s docstring explicitly names `mailto` as a valid scheme upstream, but the pattern this port inherited required `://` and silently rejected it: fixed in this pass.

## Library Conventions

These apply to every module, not just `common`; they live here because `common` is where the library's shared decisions
are recorded. All of them are held in common with the sibling `enkinex-odcs`, so a reader moving between the two
libraries sees one style.

### Docstrings

Attribute headers follow numpydoc as `name: Type, default is <literal|Undefined>, <required|optional>.` — no space
before the colon, an explicit `default is Undefined` when there is no default, and a trailing period. Descriptions are
wrapped one sentence per line. Two optional trailing lines carry vocabulary:

- `One of "a", "b", "c".` — for fields typed as a closed union (`DataProduct.status`).
- `Examples: "a", "b", "c".` — for open `str` fields where upstream supplies `examples` but no `enum`
  (`AuthoritativeDefinition.type`, `ManagementPort.content`/`.type`, `Support.tool`/`.scope`).

**Docstrings name the wire key; declarations use the KCL identifier.** Four attributes collide with the reserved word
`type` and are declared `$type`, but their docstring header is written `type:`. This is load-bearing rather than
cosmetic: `kcl doc generate` matches attribute descriptions by wire name, so a `$type:` header silently produces an
attribute with an *empty* description in `docs/library/odps.md`. Any future reserved-word attribute must follow the
same rule.

### Examples

Every concrete schema carries a numpydoc `Examples` section holding valid KCL construction expressions (not YAML);
`kcl doc generate` renders them verbatim into the reference documentation. The two synthesized base schemas
(`AuthoritativeCustomizable`, `TagsDiscoverable`) have none, since they are never instantiated directly. Example
values are drawn from the upstream ODPS reference examples with hostnames rewritten to `*.example`.

### Checks

Every `check` assertion carries a failure message naming the attribute and stating the expectation
(`"dateIn must be an ISO-8601 date (YYYY-MM-DD)"`). Without one, KCL reports only `Instance check failed`, which
identifies neither the field nor the rule. Assertions over optional attributes are guarded — either `... if attr` or
`attr == Undefined or ...` — so an absent value is never itself an error.

### Imports

Intra-library imports are relative (`import .common` from the root, `import ..common` one level down,
`import ...common` two), matching the sibling. They are also always at **package** granularity, never file-module
granularity: KCL gives `product.Sbom` and `product.sbom.Sbom` distinct identities, and only the former is reachable by
a downstream consumer. See [product](product.md) for the concrete failure this avoids.

## Open Questions

- `urlPattern` is a best-effort regex, not a full RFC 3986 validator. If KCL ever ships a native URI-checking builtin, this constant should be replaced rather than hand-maintained further.
- If KCL gains structural/duck-typed schema composition (satisfying a shape without nominal inheritance), the `AuthoritativeCustomizable`/`TagsDiscoverable` split could potentially collapse into a single schema with an optional `tags` field: revisit if that lands.
- `team.TeamMember.dateIn`/`.dateOut` share a centralized `datePattern` (`common/date.k`), the same pattern as `urlPattern`. `odps.DataProduct.productCreatedTs` still keeps its own inline date-*time* regex rather than reusing `datePattern`, since the two formats differ (date-time vs. date-only): see [odps](odps.md).
