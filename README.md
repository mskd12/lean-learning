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
- `aeneas-sigma`: verifies fastcrypto's interactive `commit`, `respond`, and
  `verify` core against a Lean specification and specializes VCVio's existing
  completeness, special-soundness, and perfect-HVZK theorems to that model.

`aeneas-merkle` remains a work in progress and is intentionally not included
in this repository yet.

## Local setup

This is a learning snapshot, not a self-contained installer. Build caches,
toolchains, Aeneas, Charon, VCVio, and fastcrypto are not vendored. The Aeneas
projects currently expect the same sibling layout used during development:

```text
lean-learning/
  tools/
    aeneas/
    VCVio-v4.31.0/
  aeneas-otp/
  aeneas-sigma/
  sigma-exercises/
../fastcrypto/
```

The Aeneas-backed projects use Lean 4.31.0. The standalone playground remains
on its original Lean 4.32.2 setup.

The fastcrypto Sigma extraction targets branch `aeneas-sigma-interactive` at
commit `314f67aefd31b8a53e516ca0c8860ac6744101e8`.
