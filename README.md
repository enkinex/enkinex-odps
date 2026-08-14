[![Enkinex — Semantic & Governance as Code](docs/images/enkinex-github-banner.png)](https://enkinex.org)

# Enkinex ODPS — Data Product as Code Library

[![Standard](https://img.shields.io/badge/ODPS-v1.0.0-blue)](https://github.com/bitol-io/open-data-product-standard/tree/v1.0.0)
[![KCL](https://img.shields.io/badge/KCL-%E2%89%A5%200.12.8-7B68EE)](https://www.kcl-lang.io/)
[![Version](https://img.shields.io/badge/version-v1.0.0-green)](./CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](./LICENSE)

> A modular [KCL](https://www.kcl-lang.io/) implementation of the
> [Open Data Product Standard (ODPS) v1.0.0](https://github.com/bitol-io/open-data-product-standard/tree/v1.0.0),
> built to author, type-check, and validate data products as **Governance-as-Code**.

---

## Project Summary

The Open Data Product Standard (ODPS), a [Linux Foundation AI & Data Incubation project](https://bitol.io/), is a
community-driven standard distributed as a JSON schema definition and usually authored as a single YAML document. While
YAML is a popular format for organizing data, configuring applications, and controlling automation scripts, it has major
maintainability challenges.

**Enkinex ODPS** complements the standard by expressing it as a modular KCL schema library. It defines an engineering
layer on top of ODPS that keeps the standard intact while adding code-level ergonomics. By defining the data product as
a code project, we are able to mitigate specific challenges:

* Modularity & reuse: schemas, imports, and packages instead of copy-paste YAML.
* Type safety & constraints: invalid data products fail at compile time, not in production.
* Two-way validation: validate existing ODPS YAML and author new data products in typed KCL.
* Living documentation: a schema reference generated straight from the code.

---

> [!IMPORTANT]
> **Backward Compatibility Disclaimer.**
> - **Enkinex ODPS `v1.0.0`** implements the current **ODPS v1.0.0** and does **not** aim to provide earlier ODPS
    versions.
> - **`apiVersion` is pinned to `v1.0.0`**.

---

## Table of Contents

- [Why KCL as a Governance-as-Code DSL](#why-kcl-as-a-governance-as-code-dsl)
- [How the ODPS standard was mapped to KCL schemas](#how-the-odps-standard-was-mapped-to-kcl-schemas)
- [Getting Started with Enkinex ODPS](#getting-started-with-enkinex-odps)
- [Schema Library Reference](#schema-library-reference)
- [Schema Library Commands](#schema-library-commands)
- [External References and Resources](#external-references-and-resources)
- [Contributing](#contributing)
- [License](#license)

---

## Why KCL as a Governance-as-Code DSL

The **Enkinex ODPS** library was created to solve a real problem: organizations running many **data products** across
many teams, each product with its own input ports, output ports, and ownership records. YAML does not scale well and
does not provide **computational governance** on its own. Tools that read and lint ODPS documents validate them well,
but they do not provide the ability to scale **governance-as-code** in a GitOps operation using a DSL made for that
purpose.

The idea came from earlier experience using KCL to model Kubernetes applications deployed with Crossplane and Argo CD:
KCL behaved for configuration and policy the way HCL does for IaC. Applied to data products, KCL opens up possibilities
that flat YAML cannot:

- **Reusable Domain Libraries**: package common input/output port definitions, support channels, and team-ownership
  records into shared schema modules that many data products import and specialize.
- **Reusable Port Catalogs**: define organization-wide, domain-specific management and output port conventions once, and
  reference them across every data product in the domain.
- **Enterprise Conventions Enforced in CI/CD**: use custom settings and `check` rules to enforce naming conventions and
  create standard, organized, machine-readable IDs for data products, ports, contracts, and teams.
- **Export to the wider toolchain**: export dynamically generated governance parameters to Terraform, Argo CD, or
  Crossplane, lowering IaC complexity and removing the need for extra parsers and custom CLIs.
- **Better AI & Spec-Driven Workflows**: a well-typed, well-documented KCL schema adds a layer of declarative semantics
  that improves AI code assistants, spec-driven design, and overall project-lifecycle management.

---

## How the ODPS standard was mapped to KCL schemas

The standard ODPS JSON Schema already organizes its definitions into sections (fundamentals, input and output ports,
management ports, support, team, …). **Enkinex ODPS** keeps that grouping, but treats it as an **opinionated** software
engineering decision: the data product is designed as a **library** where **modularity** and **maintainability** are
first-class requirements, so each section becomes a KCL module (a directory of related schemas) that other modules
import.

The library is composed of seven modules plus a root data product:

| Module                | Purpose                                                                                                                                          | Detailed docs                                                 |
|-----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| **`common`**          | Cross-cutting building blocks reused everywhere. Most code-reuse decisions live here and are inherited by the other modules.                     | [docs/schemas/common](docs/schemas/common.md)                 |
| **`management`**      | Access points for managing the data product itself: REST endpoints and topics for discoverability, observability, and control.                   | [docs/schemas/management](docs/schemas/management.md)         |
| **`product`**         | The Software Bill of Materials, kept in its own package so both `product.input` and `product.output` can depend on it without a circular import. | [docs/schemas/product](docs/schemas/product.md)               |
| **`product.input`**   | What a data product consumes: the input port and the contract dependencies an output port declares.                                              | [docs/schemas/product-input](docs/schemas/product-input.md)   |
| **`product.output`**  | What a data product produces: the output port, composing the SBOM and its input contracts.                                                       | [docs/schemas/product-output](docs/schemas/product-output.md) |
| **`support`**         | Support and communication channels: email, chat, ticketing, and announcement feeds.                                                              | [docs/schemas/support](docs/schemas/support.md)               |
| **`team`**            | Ownership: the team and its members, including the joined/left lifecycle.                                                                        | [docs/schemas/team](docs/schemas/team.md)                     |
| **`odps.k`** *(root)* | The root **`DataProduct`** schema. It imports from every module and composes them into the final ODPS data product definition.                   | [docs/schemas/odps](docs/schemas/odps.md)                     |

---

## Getting Started with Enkinex ODPS

Learn from the **[Enkinex ODPS Tutorial](https://enkinex.org/docs/governance/odps/tutorial/)** how to write a data
product as a code project and export it to a YAML document.

**What you are going to learn:**

1. **Installing KCL**: set up the KCL CLI on your machine.
2. **Creating the Data Product Project Module**: initialize a KCL module, depend on [enkinex-odps](https://github.com/enkinex/enkinex-odps/tree/v1.0.0), and lay out a
   modular project.
3. **Declare the Data Product KCL Code**: author the data product as small, reusable typed KCL sources.
4. **Parse and Export to YAML**: validate, print, and export the data product to YAML or JSON.

---

## Schema Library Reference

The complete, per-schema API reference is **auto-generated by the KCL CLI**
from the schema docstrings and property definitions:

**➡ [Enkinex ODPS Schemas Reference](docs/library/odps.md)**

Regenerate it after any schema change with:

```bash
just docs      # runs: kcl doc generate --escape-html
```

---

## Schema Library Commands

Common tasks are wrapped in the [`Justfile`](Justfile):

```bash
just init      # sync library module dependencies
just test      # kcl vet the data product + fixtures against the schemas
just docs      # regenerate docs/library/odps.md from the schema docstrings
```

---

## External References and Resources

- **[Enkinex ODPS Tutorial](https://github.com/enkinex/enkinex-odps-tutorial)**: the companion sample project — the
  ODPS customer data product example authored as a modular KCL project on top of this library.
- **Open Data Product Standard (ODPS) v1.0.0**: the
  standard [GitHub project](https://github.com/bitol-io/open-data-product-standard/tree/v1.0.0).
    - Standard JSON Schema: [`odps-json-schema-v1.0.0.json`](odps-json-schema-v1.0.0.json)
- **[KCL Language](https://www.kcl-lang.io/)**: the configuration & policy DSL used for the implementation.
- **[Enkinex ODCS](https://github.com/enkinex/enkinex-odcs)**: the sibling library for the Open Data Contract Standard,
  referenced by `InputPort.contractId` and `OutputPort.contractId`.

---

## Contributing

Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) and the contributor list in [AUTHORS.md](AUTHORS.md).

---

## License

Licensed under the Apache License 2.0 — see [LICENSE](LICENSE).
