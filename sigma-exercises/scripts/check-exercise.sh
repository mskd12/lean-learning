#!/usr/bin/env bash
set -euo pipefail

EXERCISE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$EXERCISE_DIR"
lake build SigmaExercises
