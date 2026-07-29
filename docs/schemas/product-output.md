# Module: `product.output` (`product/output/`)

## Schema Mapping

| KCL Schema                             | Upstream ODCS Entity | Notes                                                                                 |
|----------------------------------------|----------------------|---------------------------------------------------------------------------------------|
| `OutputPort` (`product/output/port.k`) | `$defs.OutputPort`   | Inherits `common.TagsDiscoverable`; composes `product.Sbom` and `input.InputContract` |

## Architecture Decisions

- `OutputPort` imports both `product` (for `Sbom`, see [product](product.md)) and `product.input` (for `InputContract`,
  see [product-input](product-input.md)): it's the only schema in the port that reaches across three packages (`common`,
  `product`, `product.input`) for its fields. This reflects that an output port is the most composite entity in the
  standard: it's the thing that carries a contract, a version, an SBOM, and its list of upstream dependencies all at
  once. Written relative, that is `import ...common`, `import ...product`, `import ..input` — all three at **package**
  granularity, which matters for `product`: see [product](product.md) for why the file-module form breaks downstream
  consumers.
- `$type` is optional and stays open `str`: upstream provides no `examples` at all for this field (unlike
  `ManagementPort.type` or `Support.tool`, see [management](management.md)/[support](support.md)), so there was even
  less basis to close it than the other `examples`-only fields discussed elsewhere in this port.

## Open Questions

- `contractId` is optional here but required on `InputPort`: matches upstream's differing `required` lists for the two
  entities exactly. Flagged here in case a future spec revision aligns the two and the port needs a symmetric update.
