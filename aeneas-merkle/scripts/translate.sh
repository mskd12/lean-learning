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
    --include 'fastcrypto::merkle' \
    --dest-file=generated/aeneas_merkle.llbc

"$AENEAS_BIN" \
  -backend lean \
  generated/aeneas_merkle.llbc \
  -dest proofs \
  -subdir /FastcryptoMerkle/Code \
  -split-files \
  -loops-to-rec \
  -namespace FastcryptoMerkle \
  -emit-json
