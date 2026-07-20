[![Enkinex — Semantic & Governance as Code](docs/images/enkinex-github-banner.png)](https://enkinex.org)

# Enkinex ODPS — Data Product as Code Library

[![Standard](https://img.shields.io/badge/ODPS-v1.0.0-blue)](https://github.com/bitol-io/open-data-product-standard/tree/v1.0.0)
[![KCL](https://img.shields.io/badge/KCL-%E2%89%A5%200.12.4-7B68EE)](https://www.kcl-lang.io/)
[![Version](https://img.shields.io/badge/version-v1.0.0--draft-orange)](./CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](./LICENSE)

> A modular [KCL](https://www.kcl-lang.io/) implementation of the
> [Open Data Product Standard (ODPS) v1.0.0](https://github.com/bitol-io/open-data-product-standard/tree/v1.0.0),
> built to author, type-check, and validate data products as
> **Governance-as-Code**.

## Project Summary

The Open Data Product Standard (ODPS), a Bitol / Linux Foundation AI & Data project, is a community-driven standard
distributed as a YAML/JSON document. While YAML is a popular format for data serialization, application configuration,
and parameterization of automation scripts, it poses significant maintainability challenges.

As organizations adopt ODPS across many teams and begin treating data products as **governed**, **versioned code**,
they naturally reach for software-engineering affordances that a serialization format was never meant to provide on
its own: modularity, typing, and reuse. Plain YAML lacks modules and packages, so shared logic is often copied and
pasted across data products, leading to runtime errors rather than authoring errors.

**Enkinex ODPS** complements the standard by expressing it as a modular KCL schema library. It defines an engineering
layer on top of ODPS that keeps the standard intact while adding code-level ergonomics.

The [KCL language](https://www.kcl-lang.io/) emerges as an interesting alternative for developing "governance-as-code"
libraries, as it is open-source and multi-paradigm (functional, with some object-oriented and constraint-based
features).
In addition, it provides a static type system, strong immutability, and modular abstractions that incorporate logic and
policy.

By defining the data product as a code project, we are able to mitigate specific challenges:

- **Modularity & reuse**: schemas, imports, and packages instead of copy-paste YAML.
- **Type safety & constraints**: invalid data products fail at compile time, not in production.
- **Two-way validation**: validate existing ODPS YAML *and* author new data products in typed KCL.
- **Living documentation**: a schema reference generated straight from the code.

Each of these is expanded in the sections below.

> [!IMPORTANT]
> **Version disclaimer.** This is the KCL **`v1.0.0-draft`** implementation, tracking the current **ODPS v1.0.0**.
>
> The root `apiVersion` field accepts both `v0.9.0` and `v1.0.0`, matching the closed union the upstream standard
> declares for that field: but the schemas themselves model the **v1.0.0** shape of the standard.

## Table of Contents

- [Why KCL as a Governance-as-Code DSL](#why-kcl-as-a-governance-as-code-dsl)
- [How the ODPS standard was mapped to KCL schemas](#how-the-odps-standard-was-mapped-to-kcl-schemas)
- [How to use the Enkinex ODPS KCL library](#how-to-use-the-enkinex-odps-kcl-library)
- [Getting Started with Enkinex ODPS](#getting-started-with-enkinex-odps)
- [Enkinex ODPS Library Reference](#enkinex-odps-library-reference)
- [External References and Resources](#external-references-and-resources)
- [What's Next](#whats-next)
- [Contributing](#contributing)
- [License](#license)

## Why KCL as a Governance-as-Code DSL

This library grew out of a concrete problem: organizations running many data products across many teams, each
product with its own input ports, output ports, and ownership records. **YAML does not scale** to that: and, being
pure data, it offers **no computational governance** out of the box.

The insight came from a prior experience using KCL to model Kubernetes applications deployed with Crossplane and
Argo CD: KCL behaved for configuration and policy the way HCL does for infrastructure-as-code. Applied
to data products, KCL opens up possibilities that flat YAML cannot:

- **Reusable domain libraries**: factor common input/output port definitions, support channels, and team-ownership
  records into shared schemas that many data products import and specialize.
- **Enterprise conventions enforced in CI/CD**: apply custom parameters and `check` rules to enforce naming
  conventions and establish standardized, hierarchical, machine-readable identifiers for data products, ports, and
  teams.
- **Export to the wider toolchain**: emit dynamically generated governance parameters to Terraform, Argo CD,
  or Crossplane, reducing IaC complexity and removing the need for intermediate parsers and bespoke CLIs.
- **Better AI & spec-driven workflows**: a well-typed, well-documented KCL schema adds a layer of declarative
  semantics that improves AI code assistants, spec-driven design, and overall project-lifecycle management.

## How the ODPS standard was mapped to KCL schemas

The upstream ODPS JSON Schema organizes its `$defs` into a flatter set of entities than a multi-domain standard would
(`InputPort`, `OutputPort`, `SBOM`, `InputContract`, `ManagementPort`, `Support`, `Team`, `TeamMember`, plus the
shared `Tags`/`Description`/`CustomProperty`/`AuthoritativeDefinition` building blocks). Enkinex ODPS keeps that
grouping, but treats it as an **opinionated software-engineering decision**: the KCL port is designed as a
**library** where **modularity and maintainability are first-class requirements**, so each group becomes a KCL
**module** (a directory of related schemas) that other modules import.

The library is composed of seven modules plus a root data product:

| Module                | Purpose                                                                                                                                                                                                  | Detailed docs                                                    |
|------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| **`common`**           | Cross-cutting building blocks reused everywhere: `CustomProperty`, `Description`, `AuthoritativeDefinition`, `Tags`, and the `AuthoritativeCustomizable`/`TagsDiscoverable` base schemas that other modules inherit from.      | [docs/schemas/common.md](docs/schemas/common.md)                  |
| **`management`**       | `ManagementPort`: access points for managing the data product itself (e.g. REST or topic endpoints).                                                                                                   | [docs/schemas/management.md](docs/schemas/management.md)          |
| **`product`**          | `Sbom`: a shared building block (Software Bill of Materials) kept in its own package so both `product.input` and `product.output` can depend on `product` without a circular import.                  | [docs/schemas/product.md](docs/schemas/product.md)                |
| **`product.input`**    | `InputPort` and `InputContract`: what a data product consumes.                                                                                                                                          | [docs/schemas/product-input.md](docs/schemas/product-input.md)    |
| **`product.output`**   | `OutputPort`: what a data product produces; composes `product.Sbom` and `product.input.InputContract`.                                                                                                 | [docs/schemas/product-output.md](docs/schemas/product-output.md)  |
| **`support`**          | `Support`: support and communication channels.                                                                                                                                                          | [docs/schemas/support.md](docs/schemas/support.md)                |
| **`team`**             | `Team` and `TeamMember`: ownership and team information.                                                                                                                                                | [docs/schemas/team.md](docs/schemas/team.md)                      |
| **`odps.k`** *(root)*  | The root **`DataProduct`** schema. It imports from every module and composes them into the final ODPS data product definition.                                                                         | [docs/schemas/odps.md](docs/schemas/odps.md)                      |

The root `DataProduct` in [`odps.k`](odps.k) defaults `apiVersion` to `"v1.0.0"` and pins `kind = "DataProduct"`,
closes `status` to a fixed lifecycle set (`proposed`/`draft`/`active`/`deprecated`/`retired`), and wires in the
module schemas (`inputPorts`, `outputPorts`, `managementPorts`, `support`, `team`): while inheriting the shared
`tags`, `customProperties`, and `authoritativeDefinitions` blocks from the `common` module via `common.TagsDiscoverable`.

> The **design decisions and trade-offs** behind each module are
> documented per module under [`docs/schemas/`](docs/schemas/).

## How to use the Enkinex ODPS KCL library

### Install / import via `kcl.mod`

Add the package to your KCL module's `kcl.mod` dependencies (Git or OCI source,
per your setup), then import the schemas you need:

```kcl
import enkinex_odps.odps

product = odps.DataProduct {
    id = "53581432-6c55-4ba2-a65f-72344a91553a"
    name = "checkout_events"
    version = "1.1.0"
    status = "active"
    domain = "checkout"
}
```

### Validate an existing YAML data product

You do not have to rewrite anything to get validation: point `kcl vet` at an
existing ODPS YAML file and the root schema:

```bash
kcl vet path/to/product.yaml odps.k --format yaml -s DataProduct
```

The YAML is coerced into the typed schemas, so the `productCreatedTs`/`dateIn`/`dateOut` date checks, the URL checks
on `AuthoritativeDefinition`/`Support`/`ManagementPort`/`Sbom`, and the closed `status`/`kind`/`apiVersion` unions all
fire on the validation path.

### Justfile targets

Common tasks are wrapped in the [`Justfile`](Justfile):

```bash
just init      # sync module dependencies (kcl mod update)
just test      # kcl vet every test/*.yaml fixture against odps.k -s DataProduct
just docs      # regenerate docs/library/odps.md from the schema docstrings
```

## Getting Started with Enkinex ODPS

There isn't a separate tutorial project yet: the fastest way to see the library in action is the [`test/`](test)
fixtures, which double as reference documents:

- [`test/full-standard.odps.yaml`](test/full-standard.odps.yaml) exercises every field on the root `DataProduct`
  schema.
- The `test/module-*.odps.yaml` files (`module-core`, `module-description`, `module-input-port`,
  `module-management-port`, `module-output-port`, `module-support`, `module-team`) isolate one module each.

Run `just test` to validate all of them against the schemas in one pass, or point `kcl vet` at any single fixture as
shown above. For the reasoning behind each schema's shape, see the per-module docs under
[`docs/schemas/`](docs/schemas/).

## Enkinex ODPS Library Reference

The complete, per-schema API reference is **auto-generated by the KCL CLI**
from the schema docstrings and property definitions:

**➡ [docs/library/odps.md](docs/library/odps.md)**

Regenerate it after any schema change with:

```bash
just docs      # runs: kcl doc generate --escape-html
```

## External References and Resources

- **Open Data Product Standard (ODPS) v1.0.0**: the upstream standard this
  library mirrors:
  <https://github.com/bitol-io/open-data-product-standard/tree/v1.0.0>
    - Source JSON Schema mirrored here: [`odps-json-schema-v1.0.0.json`](odps-json-schema-v1.0.0.json)
- **KCL language**: the configuration & policy DSL used for the
  implementation: <https://www.kcl-lang.io/>

## What's Next

- **Published module distribution**: cut the final **`v1.0.0`** release (from
  this `v1.0.0-draft`) once the draft has been reviewed, and publish it as an
  installable KCL module.
- **Worked examples**: a gallery of full sample data-product projects
  beyond the current `test/` fixtures.
- **CI validation**: automated `kcl vet` / `kcl test` checks on every change
  to keep the library and the standard in lockstep.

## Contributing

Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md), the
contributor list in [AUTHORS.md](AUTHORS.md), and our
[Code of Conduct](CODE_OF_CONDUCT.md).

For notable changes per release and which upstream ODPS version this
library tracks, see [CHANGELOG.md](CHANGELOG.md) and
[history.md](history.md).

## License

Licensed under the terms in [LICENSE](LICENSE).
