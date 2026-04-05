# `handbrake`

## Local changes

- Add Monterey-era macOS compatibility shims around newer VideoToolbox and
  Metal APIs.
- On macOS 12 and older:
  replace `rotate_vt.c` with a compatibility stub that disables the
  VideoToolbox rotation path cleanly.
- On newer SDKs built from older systems:
  define missing VideoToolbox constants when the active SDK headers do not
  provide them.
- Replace direct `supportsFamily:MTLGPUFamilyMetal3` checks with a local helper
  that compiles on older SDKs.

## Why

- Current HandBrake code expects newer macOS SDK symbols than legacy Intel
  Monterey systems provide.
- The local patch keeps the formula buildable by removing or guarding the code
  paths that require unavailable APIs instead of trying to emulate full newer
  framework behavior.

## Effective diff

- Inject a Monterey compatibility stub for `rotate_vt.c`.
- Remove the `replace_filter(... HB_FILTER_ROTATE_VT)` call on old macOS.
- Add compatibility macro definitions for newer VideoToolbox constants.
- Add a local `supportsHBMetal3Family` helper and swap call sites to use it.
