#!/usr/bin/env bash
# Build the pinned Aeneas and Charon binaries in `.tools/aeneas`.
#
# Why it exists:
# - The `translate.sh` scripts need Aeneas and Charon at fixed commits.
# - The Lean projects get the Aeneas Lean library from git at the same commit.
#
# How it works:
# 1. Clone Aeneas into `.tools/aeneas` if it is not there.
# 2. Check out `AENEAS_REV`.
# 3. `make setup-charon` clones Charon at the commit in `charon-pin` and builds it.
# 4. `make build` builds Aeneas.
#
# Assumptions:
# - opam with OCaml, rustup, and GNU make are installed.
# - On macOS, GNU make is `gmake`. The macOS `make` is too old.
# - `AENEAS_REV` is the same commit as the `aeneas` require in each lakefile.
set -euo pipefail

AENEAS_REV=74a460a2f80ecea481bbdf1a08f881633c3bb097

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AENEAS_DIR="$REPO_DIR/.tools/aeneas"

if command -v gmake >/dev/null; then
  MAKE=gmake
else
  MAKE=make
fi

if [ ! -d "$AENEAS_DIR/.git" ]; then
  git clone https://github.com/AeneasVerif/aeneas.git "$AENEAS_DIR"
fi

cd "$AENEAS_DIR"
git fetch --quiet origin
git checkout --quiet "$AENEAS_REV"
"$MAKE" setup-charon
"$MAKE" build
