# Module: `support`

## Schema Mapping

| KCL Schema                      | Upstream ODCS Entity | Notes                              |
|---------------------------------|----------------------|------------------------------------|
| `Support` (`support/support.k`) | `$defs.Support`      | Inherits `common.TagsDiscoverable` |

## Architecture Decisions

- Inherits `common.TagsDiscoverable` (see [common](common.md)). `url` is required (matches upstream's
  `required: [channel, url]`) and always validated; `invitationUrl` is optional and validated only when present.
- Both `url` and `invitationUrl` are validated against the shared `common.urlPattern`: this schema's docstring is the
  one that names `mailto` as a valid scheme upstream ("Access URL using normal URL scheme (https, mailto, etc.)"), so
  `Support` is the schema that motivates accepting `scheme:opaque-part` URIs and not only `scheme://authority`.
- `tool`/`scope` stay open `str`; upstream lists them as `examples` (`email`/`slack`/`teams`/`discord`/`ticket`/`other`
  and `interactive`/`announcements`/`issues`), and in practice support tooling varies per organization more freely than
  the lifecycle `status` field on `DataProduct` does.

## Open Questions

- Same open item as [odps](odps.md) and [management](management.md): if `tool`/`scope` should ever be closed unions, do
  it consistently with the other `examples`-only fields across the port, not in isolation.
