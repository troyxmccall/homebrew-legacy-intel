# `deno`

## Local changes

- Remove the core Xcode 15 build requirement.
- Force the build to use Homebrew `llvm` toolchain binaries:
  `clang`, `clang++`, `llvm-ar`, `llvm-ranlib`, and `ld.lld`.
- Add explicit `CPPFLAGS`, `LDFLAGS`, and `PATH` entries for the Homebrew LLVM
  prefix.
- Set `GN_ARGS` to `clang_version=#{llvm.version.major} use_lld=true`.
- Carry the bottle stanza from the working local fork state.

## Why

- On legacy Intel Macs, the system Apple Clang/Xcode stack is older than what
  current `deno` builds expect.
- The local fork moves the build to Homebrew LLVM so `deno` can still be built
  on older macOS Intel systems.
- Keeping `use_lld=true` and using the Homebrew linker makes the toolchain
  choice consistent instead of mixing Apple and Homebrew pieces.

## Patch

```diff
@@
-  depends_on xcode: ["15.0", :build] # v8 12.9+ uses linker flags introduced in xcode 15
@@
-    ENV["GN_ARGS"] = "clang_version=#{llvm.version.major} use_lld=#{OS.linux?}"
+    ENV["CC"] = llvm.opt_bin/"clang"
+    ENV["CXX"] = llvm.opt_bin/"clang++"
+    ENV["AR"] = llvm.opt_bin/"llvm-ar"
+    ENV["RANLIB"] = llvm.opt_bin/"llvm-ranlib"
+    ENV["LD"] = llvm.opt_bin/"ld.lld"
+    ENV["LDFLAGS"] = "-L#{llvm.opt_lib} -Wl,-rpath,#{llvm.opt_lib}"
+    ENV["CPPFLAGS"] = "-I#{llvm.opt_include}"
+    ENV.prepend_path "PATH", llvm.opt_bin
+    ENV["GN_ARGS"] = "clang_version=#{llvm.version.major} use_lld=true"
```
