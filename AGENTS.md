# enkinex-odps

KCL library implementing the **Open Data Product Standard (ODPS)
v1.0.0** as Governance-as-Code. Published; tracks the standard's JSON
schema (`odps-json-schema-v1.0.0.json`).

## Repo map

| Path | Purpose |
|---|---|
| `odps.k` | Root `DataProduct` schema composing all modules |
| `common/` `management/` `product/` `product/input/` `product/output/` `support/` `team/` | One KCL module per ODPS section (`product/` holds the SBOM, split to avoid a circular import) |
| `test/*.yaml` | `kcl vet` fixtures validated against the schemas |
| `docs/library/odps.md` | Generated schema reference (`just docs`) — regenerate on docstring change |
| `docs/schemas/` | Per-module design rationale |

## Commands

`just init` (kcl mod update) · `just fmt` · `just lint` · `just test` ·
`just docs` · **`just check` — the gate every change must pass** (fmt +
clean-tree + lint + test). Run `just fmt` and commit before `just check`.

## Standards

- Docstrings on every schema and field (they feed `just docs`): attribute
  line format, `required`/`optional` fidelity with the standard, inline
  `Examples:`.
- `check` rules for enums/constraints; mixins for repeated shapes
  (`common/`). `apiVersion` is pinned to `v1.0.0`.
- Contributing rules: [CONTRIBUTING.md](CONTRIBUTING.md) — branch
  `<type>/<short-slug>`, Conventional Commits subset, squash-merge.

Shared enkinex workflow/git rules: [AGENTS.shared.md](AGENTS.shared.md)
(synced from enkinex-aiops per ADR-0005 — do not edit here).
