# Homebrew Legacy Intel
This tap carries forked Homebrew formulae that I (personally) need to keep working on
legacy x86-64 Intel Macs.

The main reason this tap exists is compiler drift. Newer Homebrew formulae
increasingly assume newer Apple Clang/Xcode toolchains than older Intel
machines have available. For the affected packages, this tap keeps a patched
formula that either:

- forces the build to use Homebrew `llvm`/`clang`
- rewrites dependencies to other locally patched formulae
- pins a known-good formula revision so we can carry small compatibility fixes

## What the local overrides do

- `node` switches older macOS Intel builds to Homebrew `llvm` toolchain
  binaries and libc++/unwind linkage when Apple Clang is too old.
- `deno` is built explicitly with Homebrew `llvm` instead of relying on newer
  Xcode requirements from core.
- `gettext` carries the extra include/library flags needed by our local PHP
  stack and older Intel toolchains.
- `php` depends on `troyxmccall/legacy-intel/gettext` instead of core `gettext`.
- `yt-dlp` and `gallery-dl` are wired to other local formulae in this tap so
  the patched dependency chain stays consistent.
- `gcc` is vendored here so I can install and patch a local GCC formula
  without waiting on core changes.

In short: core remains the default, but when a formula stops building or
linking correctly on older x86_64 Macs, I will fork it here, make the minimum
targeted fix, and install the fork from `troyxmccall/legacy-intel/...`.

## How to install these forked formulae

```bash
brew install troyxmccall/legacy-intel/<formula>
```

Or tap it first:

```bash
brew tap troyxmccall/legacy-intel
brew install <formula>
```

Per-formula installs:

```bash
brew install troyxmccall/legacy-intel/gcc
brew install troyxmccall/legacy-intel/gettext
brew install troyxmccall/legacy-intel/php
brew install troyxmccall/legacy-intel/node
brew install troyxmccall/legacy-intel/deno
brew install troyxmccall/legacy-intel/handbrake
brew install troyxmccall/legacy-intel/yt-dlp
brew install troyxmccall/legacy-intel/gallery-dl
```

Or in a `Brewfile`:

```ruby
tap "troyxmccall/legacy-intel"
brew "troyxmccall/legacy-intel/<formula>"
```
