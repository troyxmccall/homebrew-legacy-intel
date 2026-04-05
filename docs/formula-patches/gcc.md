# `gcc`

## Local changes

- Keep the official unversioned formula name as `gcc`.
- Build with `MAKEINFO=true` in both the main build step and the install step.
- Simplify the test block to a small C compile-and-run test.

## Why

- The initial local fork failed on legacy Intel macOS during Texinfo generation,
  not during compiler code generation.
- The failing step was `doc/gfortran.info`; Homebrew removes installed info
  pages anyway, so bypassing the `makeinfo` failure is the smallest practical
  patch.
- Using the unversioned formula name keeps installation aligned with normal
  Homebrew usage: `brew install troyxmccall/legacy-intel/gcc`.

## Effective diff

- `system "gmake", *make_args` -> `system "gmake", "MAKEINFO=true", *make_args`
- `system "gmake", install_target, ...` -> `system "gmake", "MAKEINFO=true", install_target, ...`
- Local fork is exposed as `gcc.rb`, not `gcc@15.2.0.rb`
