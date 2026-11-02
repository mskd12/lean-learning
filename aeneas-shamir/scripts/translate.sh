#!/usr/bin/env bash
# Translate the Shamir entry points with Charon, then with Aeneas.
#
# The script writes the full tool output to `logs/translate.log`.
# It needs Aeneas `74a460a2` with Charon `a1d98905`. Charon commits after
# 2026-08-26 reject `--preset=aeneas` together with `--monomorphize`.
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AENEAS_DIR="$PROJECT_DIR/../tools/aeneas"
CHARON_BIN="$AENEAS_DIR/charon/bin/charon"
AENEAS_BIN="$AENEAS_DIR/bin/aeneas"

cd "$PROJECT_DIR"
mkdir -p generated logs

{
  RUSTUP_TOOLCHAIN=nightly-2026-08-18 \
    "$CHARON_BIN" cargo \
      --preset=aeneas \
      --monomorphize \
      --start-from 'aeneas_shamir' \
      --include 'fastcrypto_tbls::polynomial' \
      --dest-file=generated/aeneas_shamir.llbc

  "$AENEAS_BIN" \
    -backend lean \
    generated/aeneas_shamir.llbc \
    -dest proofs \
    -subdir /FastcryptoShamir/Code \
    -split-files \
    -loops-to-rec \
    -namespace FastcryptoShamir \
    -emit-json
} 2>&1 | tee logs/translate.log
