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


<!-- BEGIN GENERATED: enkinex-aiops/AGENTS.shared.md — do not edit here; run "just sync-opencode" in enkinex-aiops -->
## Shared enkinex rules

> GENERATED from enkinex-aiops `AGENTS.shared.md` (ADR-0005). Do not edit
> this block in a sibling repo — change the source in enkinex-aiops and run
> `just sync-opencode`.

Enkinex is an open-source **Semantic & Governance as Code** project: KCL
libraries that implement open standards (ODCS, ODPS, OKF) and platform
configuration surfaces (Databricks Asset Bundles) as typed, modular code.

### Git workflow (locked)

- Branch slug: `<type>/<scope>-<short-summary>`; `type` ∈ `feat · fix ·
  refactor · docs · chore · test · infra · proj`.
- Commits: Conventional Commits subset `<type>(<scope>): <imperative ≤72>`,
  `Refs:` footer pointing at the plan section delivered, no `Closes:`/
  `Fixes:`/`Resolves:` (there are no GitHub Issues).
- **Never push, merge, or open PRs unless the user explicitly asks.** The
  iteration ends at a local commit. `gh` CLI is the only GitHub surface
  (ADR-0002): no GitHub MCP, no Actions, no Issues/Projects/Releases.
- Never force-push to `main`; never rewrite history.
- Before any repo edit: `git fetch origin`, confirm sync with `main`,
  create the branch. Commit at the end of the iteration.

### Project lifecycle

Repos plan at the root level: `plan/` (active plans; finished work moves
to `plan/done/`), `discovery/` (analysis feeding plans), `architecture/`
(ADRs). ADRs record one-way decisions only — procedural workflows are
defined as executable artefacts (agents, commands, loop tasks, plugin
hooks), never as ADR prose (ADR-0004, executable governance). Commit
`Refs:` footers point at the delivered `plan/` section.

### Model tiers (OpenRouter)

| Tier | Models | Use |
|---|---|---|
| Free | `:free` suffixed IDs | explore/triage, formatting, titles |
| Mid | `moonshotai/kimi-k2`, `deepseek/deepseek-v3.2`, `google/gemini-3.5-flash` | code edits, docs, tests |
| Frontier | `moonshotai/kimi-k3` (default), `anthropic/claude-opus-5`, `openai/gpt-5.6` family | plans, reviews, ADRs |

Do not switch tiers silently; model pins change only via PR.

### Code standards

- KCL libraries: one module per concern, docstrings on every schema and
  field (they feed `just docs`), `check` rules for enums/constraints,
  `kcl vet` fixtures under `test/`. Gate: `just check` (fmt + lint + test).
- Stage explicit paths only — never `git add -A` / `git add .`; skip
  anything that looks like a secret.
<!-- END GENERATED -->
