#!/usr/bin/env bash
set -euo pipefail

OTP_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AENEAS_DIR="$OTP_PROJECT_DIR/../tools/aeneas"
CHARON_BIN="$AENEAS_DIR/charon/bin/charon"
AENEAS_BIN="$AENEAS_DIR/bin/aeneas"

cd "$OTP_PROJECT_DIR"

RUSTUP_TOOLCHAIN=nightly-2026-08-18 \
  "$CHARON_BIN" cargo \
    --preset=aeneas \
    --dest-file=generated/aeneas_otp.llbc

"$AENEAS_BIN" \
  -backend lean \
  generated/aeneas_otp.llbc \
  -dest proofs \
  -subdir /AeneasOtp/Code \
  -split-files \
  -namespace AeneasOtp \
  -emit-json
