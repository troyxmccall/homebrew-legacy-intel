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

## Effective diff

- New `def llvm` helper added.
- New conditional LLVM toolchain override for
  `DevelopmentTools.clang_build_version <= 1699`.
