#!/usr/bin/env bash
set -euo pipefail

OTP_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$OTP_PROJECT_DIR/proofs"
lake build
