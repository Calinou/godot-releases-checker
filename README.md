# Godot releases checker

Downloads and verifies official Godot binaries against known SHA-512 checksums
to make sure they haven't been tampered with.

## How it works

- SHA-512 checksum files are committed in this repository for this each release.
  Each file is a concatenation of the standard and Mono release checksum files.
  - For example, for 3.4.2, the checksum URLs used are:
    - <https://downloads.tuxfamily.org/godotengine/3.4.2/SHA512-SUMS.txt>
    - <https://downloads.tuxfamily.org/godotengine/3.4.2/mono/SHA512-SUMS.txt>
- Every day at midnight (UTC), a scheduled GitHub Actions workflow is run.
  - The workflow [downloads all files](/download-all.sh) for some given
    releases, then verifies their checksums.
- If any file is missing or its checksum does not match the one stored in this
  repository, then CI will fail.

## License

Copyright © 2022 Hugo Locurcio and contributors

Unless otherwise specified, files in this repository are licensed under the
MIT license. See [LICENSE.md](LICENSE.md) for more information.
