# `aws-crt-cpp`

## Local change

- Repoint `aws-c-http` dependency to `troyxmccall/legacy-intel/aws-c-http`.

## Why

- This keeps the AWS CRT dependency chain inside the tap.
- It avoids mixing one local fork with a core dependency when we need to patch
  lower layers later.

## Effective diff

- `depends_on "aws-c-http"` -> `depends_on "troyxmccall/legacy-intel/aws-c-http"`
