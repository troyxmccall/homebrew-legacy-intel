# `php`

## Local change

- Set `CURL_CFLAGS` and `CURL_LIBS` in the formula so PHP configure uses the
  Homebrew `curl` keg directly instead of `pkg-config`.

## Why

- On older macOS systems, `pkg-config` can resolve `libcurl` metadata that
  references optional dependencies like `librtmp`. When those `.pc` files are
  absent, PHP's `./configure` aborts even though the actual `curl` library is
  installed and usable.

## Patch

```diff
@@
+    ENV["CURL_CFLAGS"] = "-I#{Formula["curl"].opt_include}"
+    ENV["CURL_LIBS"] = "-L#{Formula["curl"].opt_lib} -lcurl"
```
