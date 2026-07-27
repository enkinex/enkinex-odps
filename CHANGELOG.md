# Changelog

This document tracks the history and evolution of the **Enkinex ODPS Library** for the **Open Data Product Standard**.

## v1.0.0 - First Stable Release

* Schemas
    * Pin `ApiVersionType` to `"v1.0.0"`; the upstream `v0.9.0` shape is not compatible (its root `team` is an array of
      members, not a `Team` object, and `TeamMember.username` is optional there)
    * Add failure messages to every `check` assertion, replacing the bare `Instance check failed` error
    * Reject an empty `id`, and an empty `version` when one is supplied, on the root `DataProduct`
    * Require `dateOut` whenever `TeamMember.replacedByUsername` is set
    * Document reserved-word attributes by their wire name (`type`, not `$type`), which restores the missing
      descriptions for `AuthoritativeDefinition`, `ManagementPort`, `OutputPort`, and `Sbom` in the generated reference
    * Rewrite every docstring to the shared Enkinex convention: `name: Type, default is …, required.` headers, one
      sentence per line, and `One of …` / `Examples: …` value hints for the fields upstream leaves open
    * Add an `Examples` section with valid KCL construction expressions to all 12 concrete schemas
    * Convert intra-library imports to the relative form, at package granularity throughout
* Documentation
    * Update `README.md` to the structure shared with the sibling `enkinex-odcs`
    * Update `docs/schemas/*` — `apiVersion` pinning, root invariants, the `Sbom.type` and management-port coupling
      decisions, the `replacedByUsername` rule, and a new library-conventions section under `common`
    * Regenerate the `docs/library/odps.md` schema reference
    * Align `CONTRIBUTING.md` with the `test/odps.*.yaml` fixture naming
    * Add `SECURITY.md`
* Validation
    * Rename the fixtures to `test/odps.full.example.yaml` and `test/odps.module.{common,management,product-input,product-output,support,team}.yaml`
    * Fold the standalone description fixture into `odps.module.common.yaml`, which now covers the whole `common` module
    * Annotate every fixture with the test cases it exercises
* CI/CD
    * Update `kcl.mod` version to `1.0.0` and edition to `0.12.7`

## v1.0.0-draft - Initial v1.0.0 Draft

* Schemas
    * Common Schemas
    * Management Port Schemas
    * Product Schemas (SBOM, input and output ports)
    * Support Schemas
    * Team Schemas
* Documentation
    * `README.md`
    * Schema Mapping and Architectural Decisions
    * Reference documentation generated from KCL
* Validation
    * Validate DataProduct schema
* CI/CD
    * Add `.github` test workflow and configuration
    * Add `Justfile` commands
