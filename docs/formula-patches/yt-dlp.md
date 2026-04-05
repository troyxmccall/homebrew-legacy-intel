# `yt-dlp`

## Local changes

- Repoint the build/runtime dependency from core `deno` to
  `troyxmccall/legacy-intel/deno`.
- Carry a local revision bump.

## Why

- The local `yt-dlp` fork depends on the local `deno` fork so the JavaScript
  tooling chain stays on the same legacy-compatible build stack.
- The revision bump distinguishes the local rebuild from the matching core
  formula revision.

## Patch

```diff
@@
-  revision 1
+  revision 2
@@
-  depends_on "deno"
+  depends_on "troyxmccall/legacy-intel/deno"
```
