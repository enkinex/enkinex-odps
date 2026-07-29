# Module: `product.input` (`product/input/`)

## Schema Mapping

| KCL Schema                                   | Upstream ODCS Entity  | Notes                              |
|----------------------------------------------|-----------------------|------------------------------------|
| `InputContract` (`product/input/contract.k`) | `$defs.InputContract` | 1:1                                |
| `InputPort` (`product/input/port.k`)         | `$defs.InputPort`     | Inherits `common.TagsDiscoverable` |

## Architecture Decisions

- `input` is its own KCL sub-package (`product.input`) rather than flat files in `product/`, mirroring the upstream
  split between `$defs.InputPort` (what a data product consumes) and `$defs.OutputPort` (what it produces):
  see [product-output](product-output.md). The two have different `required` fields and different downstream consumers
  (`InputContract` is referenced only from `OutputPort.inputContracts`, not from `InputPort` itself), so keeping them in
  separate packages keeps each package's public surface focused on one concern.
- `InputContract` is *not* `TagsDiscoverable` (see [common](common.md)): upstream's `$defs.InputContract` is a bare
  `{id, version}` dependency pointer with no `tags`/`customProperties`/`authoritativeDefinitions`, so there's nothing to
  inherit.

## Open Questions

- `InputContract.id` is documented upstream as "Contract ID or contractId": ambiguous phrasing in the spec itself. The
  port takes it as a plain `str` with no further constraint; if upstream clarifies the expected ID format (UUID? URN?),
  a stricter type could be added here.
