# Module: `product` (root: `product/sbom.k`)

## Schema Mapping

| KCL Schema | Upstream ODCS Entity | Notes |
|---|---|---|
| `Sbom` (`product/sbom.k`) | `$defs.SBOM` | Name is `Sbom` (PascalCase-per-word), not `SBOM` (all-caps acronym) |

## Architecture Decisions

- Named `Sbom` rather than `SBOM` to follow the naming convention used throughout this port (PascalCase words, not preserved acronym casing): see also `InputContract`/`InputPort`/`OutputPort` in [product-input](product-input.md)/[product-output](product-output.md), none of which preserve upstream's arbitrary-case fragments verbatim either. This is purely cosmetic; upstream's `$defs.SBOM` and this port's `Sbom` are semantically identical.
- Not `TagsDiscoverable`/`AuthoritativeCustomizable` (see [common](common.md)): upstream's `$defs.SBOM` has only `type`/`url`, no `tags`/`customProperties`/`authoritativeDefinitions`, so there's nothing to inherit.
- Lives directly under `product/` (its own file, `sbom.k`, in the shared `product` package) rather than under `product/output/`, even though it's currently only referenced from `OutputPort.sbom`: this keeps `product` importable by both `product.input` and `product.output` without a circular import; see `product/output/port.k`, which does `import ...product` for `product.Sbom` alongside `import ..input` for `input.InputContract`.
- `product/output/port.k` imports the **package** (`import ...product`, giving `product.Sbom`), not the file module (`import ..sbom`, which would give `sbom.Sbom`). KCL treats those two as *distinct types*: with the file-module form, an `OutputPort.sbom` declared as `[sbom.Sbom]` rejects a `product.Sbom` value built by a downstream consumer — which is the only path a consumer has, since `Sbom` is reached as `enkinex_odps.product.Sbom`. The failure is invisible to `kcl vet` (YAML coercion is structural) and only shows up when a real KCL consumer constructs the value, so the package-level import is load-bearing, not stylistic.
- `type` stays an open `str` with its `"external"` default, following the JSON Schema, even though upstream's prose calls `external` "the default and only supported value". The declared source of truth for this port is `odps-json-schema-v1.0.0.json`, which supplies a `default` but no `enum`; closing the union would also reject `test/full-standard.odps.yaml`, which deliberately exercises a second value. The prose caveat is carried in the attribute's docstring instead.

## Open Questions

- If a future ODPS revision adds an `sbom` field to `InputPort` as well (symmetric with `OutputPort`), `Sbom`'s current placement in the shared `product` package already supports that without moving files.
- If upstream promotes its `external`-only prose into an actual `enum`, close `Sbom.type` then — and update the full-standard fixture in the same change.
