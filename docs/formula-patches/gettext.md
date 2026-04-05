# `gettext`

## Local changes

- Add a dependency on `json-c`.
- Add `json-c` include and library paths to the build flags.

## Why

- The local PHP stack depends on this forked `gettext`.
- On the legacy Intel target, the extra include and linker paths keep the build
  finding the required `json-c` headers and libraries reliably.
- The formula also carries the upstream-style Clang workaround already present
  in core.

## Patch

```diff
@@
+  depends_on "json-c"
@@
+    ENV.append_to_cflags "-I#{Formula["json-c"].opt_include}/json-c"
+    ENV.append "LDFLAGS", "-L#{Formula["json-c"].opt_lib}"
```
