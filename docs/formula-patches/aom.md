# `aom`

## Local change

- Repoint `libvmaf` dependency to `troyxmccall/legacy-intel/libvmaf`.

## Why

- `aom` is part of a local dependency chain that needs to stay inside this tap.
- Using the local `libvmaf` fork keeps downstream multimedia builds on the same
  formula set.

## Effective diff

- `depends_on "libvmaf"` -> `depends_on "troyxmccall/legacy-intel/libvmaf"`
