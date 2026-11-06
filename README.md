# Lean learning

Personal notes, exercises, and small verification projects from learning Lean,
Aeneas, and VCVio through cryptographic examples.

## Contents

- `lean-playground`: early Lean experiments, including Fibonacci and a small
  one-time-pad model.
- `aeneas-otp`: follows a byte-oriented Rust one-time pad through Charon and
  Aeneas, then connects the extracted functions to VCVio's OTP model.
- `sigma-exercises`: guided proofs of completeness, special soundness,
  deterministic simulation, and perfect honest-verifier zero knowledge for
  the Schnorr Sigma protocol.
- `pedersen-exercises`: guided proofs of correctness, perfect hiding (by
  pushforward and by coupling), and the binding-to-DLog reduction for
  VCVio's Pedersen commitment.
- `aeneas-sigma`: verifies fastcrypto's interactive `commit`, `respond`, and
  `verify` core against a Lean specification and specializes VCVio's existing
  completeness, special-soundness, and perfect-HVZK theorems to that model.

`aeneas-merkle` remains a work in progress and is intentionally not included
in this repository yet.

## Local setup

The Lean projects do not need files outside this repository. Each lakefile
gets VCVio and the Aeneas Lean library from git at a fixed commit:

- VCVio `cbd4144b` (tag `v4.31.0`).
- Aeneas `74a460a2`, subdirectory `backends/lean`.

To build a Lean project, go to its directory and run `lake build`. Lake
clones the dependencies into `.lake/packages`. Mathlib downloads its build
cache during `lake update`.

The `translate.sh` scripts also need the Aeneas and Charon binaries. Run
`scripts/setup-tools.sh` one time to build them. The script puts them in
`.tools/aeneas`. Git ignores `.tools/`. The script uses the same Aeneas
commit as the lakefiles.

```text
lean-learning/
  .tools/
    aeneas/
  aeneas-otp/
  aeneas-sigma/
  sigma-exercises/
  pedersen-exercises/
```

The Rust crates get fastcrypto from git. `aeneas-shamir` uses commit
`878842e9` on branch `aeneas-shamir-loop`. You do not need a local clone.

The Aeneas-backed projects use Lean 4.31.0. The standalone playground remains
on its original Lean 4.32.2 setup.

The fastcrypto Sigma extraction targets branch `aeneas-sigma-interactive` at
commit `314f67aefd31b8a53e516ca0c8860ac6744101e8`.
