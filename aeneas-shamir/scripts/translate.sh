#!/usr/bin/env bash
# Translate the Shamir entry points with Charon, then with Aeneas.
#
# Usage: ./scripts/translate.sh generic|ristretto
# - `generic` starts from `aeneas_shamir::generic` without monomorphization.
# - `ristretto` starts from `aeneas_shamir::ristretto` with `--monomorphize`.
# The script writes the full tool output to `logs/<mode>.log`.
set -euo pipefail

MODE="${1:?usage: translate.sh generic|ristretto}"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AENEAS_DIR="$PROJECT_DIR/../tools/aeneas"
CHARON_BIN="$AENEAS_DIR/charon/bin/charon"
AENEAS_BIN="$AENEAS_DIR/bin/aeneas"
LOG="$PROJECT_DIR/logs/$MODE.log"

# This script needs Aeneas `74a460a2` with Charon `a1d98905`. Charon commits
# after 2026-08-26 reject `--preset=aeneas` together with `--monomorphize`.
case "$MODE" in
  generic) MONO_FLAG="" ;;
  ristretto) MONO_FLAG="--monomorphize" ;;
  *) echo "unknown mode: $MODE" >&2; exit 2 ;;
esac

cd "$PROJECT_DIR"
mkdir -p generated logs

{
  echo "== charon ($MODE) =="
  RUSTUP_TOOLCHAIN=nightly-2026-08-18 \
    "$CHARON_BIN" cargo \
      --preset=aeneas \
      $MONO_FLAG \
      --start-from "aeneas_shamir::$MODE" \
      --include 'fastcrypto_tbls::polynomial' \
      --dest-file="generated/aeneas_shamir_$MODE.llbc"

  echo "== aeneas ($MODE) =="
  "$AENEAS_BIN" \
    -backend lean \
    "generated/aeneas_shamir_$MODE.llbc" \
    -dest proofs \
    -subdir /FastcryptoShamir/Code \
    -split-files \
    -loops-to-rec \
    -namespace FastcryptoShamir \
    -emit-json
} 2>&1 | tee "$LOG"
