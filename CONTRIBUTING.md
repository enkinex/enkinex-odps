# Contributing to Enkinex ODPS

Thank you for your interest in contributing to **Enkinex ODPS**, the modular
[KCL](https://www.kcl-lang.io/) implementation of the
[Open Data Product Standard (ODPS) v1.0.0](https://github.com/bitol-io/open-data-product-standard/tree/v1.0.0).
This guide covers everything you need to build, validate, and submit changes.

## Prerequisites

- [KCL](https://www.kcl-lang.io/docs/user_docs/getting-started/install) `>= 0.12.4`
- [`just`](https://github.com/casey/just), the command runner used to wrap
  every development task in this repo

Check both are on your `PATH`:

```bash
kcl --version
just --version
```

## Getting started

```bash
git clone git@github.com:enkinex/enkinex-odps.git
cd enkinex-odps
just init      # kcl mod update
just check     # fmt + lint + test, the same gate CI/reviewers expect
```

Run `just` with no arguments at any point to list every available task.

## Development workflow

All day-to-day tasks are `just` recipes defined in the [`Justfile`](Justfile):

| Command      | What it does                                                                 |
|--------------|-------------------------------------------------------------------------------|
| `just init`  | Syncs module dependencies (`kcl mod update`).                                 |
| `just fmt`   | Formats every `.k` file in the project (`kcl fmt ./...`).                     |
| `just lint`  | Runs `kcl lint` against the root package and every module directory.          |
| `just test`  | Validates every fixture under [`test/`](test) against `odps.k` with `kcl vet`, failing loudly on the first error. |
| `just docs`  | Regenerates the auto-generated schema reference from schema docstrings.       |
| `just check` | Aggregate gate: formats, verifies the tree is still clean (`git diff --exit-code`), then runs `lint` and `test`. Run this before opening a PR. |

Before pushing, always run:

```bash
just fmt
just check
```

`just check` re-runs `kcl fmt` and fails if it changes anything you haven't
committed — so always run `just fmt` and commit the result first, rather than
letting `check` catch it for you.

## Branch and commit conventions

Commit messages in this repo follow a **Conventional Commits** subset. Use
one of these prefixes based on what the commit actually changes:

- `feat:` — a new schema, field, or capability
- `fix:` — a correctness fix (typing, constraints, validation behavior)
- `docs:` — documentation-only changes (README, schema docs, docstrings)
- `test:` — adding or updating `test/` fixtures
- `refactor:` — restructuring without behavior change
- `chore:` — tooling, dependency, or repo-scaffolding changes

Keep the subject line short and imperative (e.g. `fix: reject invalid status
values`), matching the existing `git log`.

Branch names follow `<type>/<short-slug>`, using the same prefixes as above,
e.g. `feat/output-port-retry-policy` or `chore/contributor-tooling`.

## Pull request process

1. Fork the repo (or branch directly if you're a collaborator) and open your
   PR against `main`.
2. Fill in the [PR template](.github/PULL_REQUEST_TEMPLATE.md) — in
   particular the **Testing** section: paste the output of `just check`.
3. Make sure CI (or your local `just check`) is green before requesting
   review.
4. A maintainer listed in [`.github/CODEOWNERS`](.github/CODEOWNERS) will
   review; address feedback with follow-up commits rather than force-pushes
   once a review is in progress, unless asked otherwise.
5. PRs are squash-merged, so the PR title should itself read as a good
   commit message.

## Where to add a new schema

The library is organized as one KCL module per group of related ODPS
entities, mirroring the upstream `$defs` groupings. If you're adding a new
field or schema, find its home in this table (see the root `README.md` for
the full rationale behind each module):

| Module               | Owns                                                              |
|-----------------------|--------------------------------------------------------------------|
| `common`               | `CustomProperty`, `Description`, `AuthoritativeDefinition`, `Tags`, and the shared `AuthoritativeCustomizable`/`TagsDiscoverable` base schemas |
| `management`           | `ManagementPort`                                                   |
| `product`               | `Sbom` (shared by `product.input` and `product.output`)            |
| `product.input`         | `InputPort`, `InputContract`                                       |
| `product.output`        | `OutputPort`                                                       |
| `support`                | `Support`                                                          |
| `team`                    | `Team`, `TeamMember`                                               |
| `odps.k` (root)           | The root `DataProduct` schema that composes every module above     |

Add a fixture under [`test/`](test) that exercises any new or changed field
(either extend `full-standard.odps.yaml` or add to the relevant
`module-*.odps.yaml` file), and run `just test` to confirm it validates.

## Docstrings and generated docs

Every schema and field should carry a docstring — it's the source of the
generated schema reference and the primary way contributors discover the
API. When you add or change a docstring:

1. Run `just docs` to regenerate the schema reference.
2. Include the regenerated file in your PR.
3. If your change affects the architectural rationale for a module, also
   update the corresponding file under [`docs/schemas/`](docs/schemas).

## Code of conduct and security

- This project follows the [Code of Conduct](CODE_OF_CONDUCT.md).
- To report a security vulnerability, see [`SECURITY.md`](SECURITY.md) —
  please do not open a public issue for security reports.

## Other references

- [`AUTHORS.md`](AUTHORS.md) — contributor list.
- [`CHANGELOG.md`](CHANGELOG.md) — notable changes per release.
- [`history.md`](history.md) — which upstream ODPS version this library tracks.
