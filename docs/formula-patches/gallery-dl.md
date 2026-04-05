# `gallery-dl`

## Local changes

- Repoint `yt-dlp` dependency to `troyxmccall/legacy-intel/yt-dlp`.
- Split `virtualenv_install_with_resources` by platform so Linux keeps the
  default resource set and macOS excludes `jeepney` and `secretstorage`.

## Why

- `gallery-dl` is intended to consume the locally forked `yt-dlp`.
- The platform split keeps the old macOS behavior explicit without changing the
  Linux path.

## Effective diff

- `depends_on "yt-dlp"` -> `depends_on "troyxmccall/legacy-intel/yt-dlp"`
- `virtualenv_install_with_resources(without: ...)` changed to an explicit
  Linux/macOS branch.
