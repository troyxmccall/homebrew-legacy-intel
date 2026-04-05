# Unchanged Vendored Formulae

These formulae are currently copied into this tap without a local diff relative
to the matching `homebrew/core` formula:

- `aws-c-http`
- `libvmaf`

Why keep them here anyway:

- They provide a stable base for other local dependency rewrites.
- They let us add a patch later without changing the dependency graph again.
- They keep the tap self-contained when a patched formula already depends on a
  local fork.
