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

## Effective diff

- `depends_on xcode: ["15.0", :build]` removed.
- Explicit LLVM environment variables added in `install`.
- Core `GN_ARGS` logic replaced with forced LLVM + LLD usage.
