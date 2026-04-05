# `php`

## Local change

- Repoint the macOS `gettext` dependency to `troyxmccall/legacy-intel/gettext`.

## Why

- The local `php` fork is meant to consume the patched `gettext` fork.
- This keeps the PHP build on the same dependency chain that carries the legacy
  Intel compatibility fixes.

## Patch

```diff
@@
-    depends_on "gettext"
+    depends_on "troyxmccall/legacy-intel/gettext"
```
