# Module: `management`

## Schema Mapping

| KCL Schema                             | Upstream ODCS Entity   | Notes                              |
|----------------------------------------|------------------------|------------------------------------|
| `ManagementPort` (`management/port.k`) | `$defs.ManagementPort` | Inherits `common.TagsDiscoverable` |

## Architecture Decisions

- Inherits `common.TagsDiscoverable` for the `tags`/`customProperties`/`authoritativeDefinitions` trio
  (see [common](common.md)); only `name`, `content`, `$type`, `url`, `channel`, `description` remain schema-local,
  matching exactly what upstream lists beyond that trio.
- `$type`/`content` stay open `str`: upstream gives them `examples` only (`rest`/`topic` and `discoverability`/
  `observability`/`control`/`dictionary` respectively), not an `enum`, and both are illustrative rather than exhaustive;
  new management-port content types are expected as the ecosystem matures.
- `url` is optional here (unlike `Support.url`, which is required) and is validated only when present, via
  `regex.match(url, common.urlPattern) if url`: this mirrors upstream, where `url` isn't in `ManagementPort`'s
  `required` list.

## Open Questions

- `$type` defaults to `"rest"`, matching upstream's default. If `topic`-type management ports become dominant in
  practice, whether that default should change is a spec-level question, not one this port should decide unilaterally.
- Same open item as [odps](odps.md) and [support](support.md): if `content`/`$type` should ever become closed unions, do
  it consistently with the other `examples`-only fields across the port, not in isolation.
- No `check` couples `$type` to the transport-specific field it implies — a `topic` port isn't required to set
  `channel`, and a `rest` port isn't required to set `url`. Upstream requires neither (only `name`/`content` are in
  `ManagementPort.required`), so adding the coupling would constrain documents the standard accepts. Revisit only if
  upstream tightens it; the port should not invent the rule.
