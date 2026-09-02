#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AENEAS_DIR="$PROJECT_DIR/../tools/aeneas"
CHARON_BIN="$AENEAS_DIR/charon/bin/charon"
AENEAS_BIN="$AENEAS_DIR/bin/aeneas"

cd "$PROJECT_DIR"

RUSTUP_TOOLCHAIN=nightly-2026-08-18 \
  "$CHARON_BIN" cargo \
    --preset=aeneas \
    --monomorphize \
    --start-from 'aeneas_sigma::commit' \
    --start-from 'aeneas_sigma::respond' \
    --start-from 'aeneas_sigma::verify' \
    --include 'fastcrypto_tbls::nizk' \
    --dest-file=generated/aeneas_sigma.llbc

"$AENEAS_BIN" \
  -backend lean \
  generated/aeneas_sigma.llbc \
  -dest proofs \
  -subdir /FastcryptoSigma/Code \
  -split-files \
  -loops-to-rec \
  -namespace FastcryptoSigma \
  -emit-json
