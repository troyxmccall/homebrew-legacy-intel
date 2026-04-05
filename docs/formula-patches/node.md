# `node`

## Local changes

- Add a small `llvm` helper method.
- On macOS with older Apple Clang builds, force the build to use Homebrew LLVM
  tool binaries:
  `clang`, `clang++`, `llvm-ar`, `llvm-nm`, `llvm-ranlib`.
- Prepend the LLVM bin directory to `PATH`.
- Add `_LIBCPP_DISABLE_AVAILABILITY` to `CPPFLAGS`.
- Add explicit libc++ and unwind search/rpath flags from the Homebrew LLVM
  prefix.

## Why

- Legacy Intel Macs often have Apple Clang versions that are too old for the
  current `node` build.
- The local patch moves those systems onto Homebrew LLVM while keeping the rest
  of the formula as close to core as possible.

## Patch

```diff
@@
+  def llvm
+    Formula["llvm"]
+  end
@@
+    if OS.mac? && DevelopmentTools.clang_build_version <= 1699
+      ENV["CC"] = llvm.opt_bin/"clang"
+      ENV["CXX"] = llvm.opt_bin/"clang++"
+      ENV["AR"] = llvm.opt_bin/"llvm-ar"
+      ENV["NM"] = llvm.opt_bin/"llvm-nm"
+      ENV["RANLIB"] = llvm.opt_bin/"llvm-ranlib"
+      ENV.prepend_path "PATH", llvm.opt_bin
+      ENV.append "CPPFLAGS", "-D_LIBCPP_DISABLE_AVAILABILITY"
+      ENV.append "LDFLAGS", "-L#{llvm.opt_lib}/c++ -L#{llvm.opt_lib}/unwind -Wl,-rpath,#{llvm.opt_lib}/c++ -Wl,-rpath,#{llvm.opt_lib}/unwind -lunwind"
+    end
```
