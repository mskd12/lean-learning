# Aeneas + VCVio verification of fastcrypto's Sigma protocol

This project verifies the explicit-challenge discrete-log Sigma core exposed by
the local `../../fastcrypto` checkout on branch `aeneas-sigma-interactive`.
The production implementation remains in `fastcrypto-tbls/src/nizk.rs`; it is
not copied here.

The first scope is deliberately interactive and concrete: it refines the
`RistrettoPoint` instantiation. The fastcrypto API itself remains generic; Aeneas
currently cannot translate its full `GroupElement` associated-type hierarchy.

```text
commit(r)           = rG
respond(x, r, c)    = r + cx
verify(X, A, c, z)  = zG = A + cX
```

`DLNizk::create` and `DLNizk::verify` use this core after deriving `c` through
Fiat-Shamir. The random-oracle and Fiat-Shamir security argument is therefore
outside this first port, rather than assumed implicitly.

The Lean development proves that all three extracted functions refine the
deterministic specification. `FastcryptoSigma.Spec.VCVioBridge` then packages
that specification as VCVio's Schnorr protocol and directly reuses VCVio's
perfect-completeness, special-soundness, and perfect-HVZK theorems. This bridge
is conditional on the explicit abstract Ristretto algebra and finiteness
assumptions recorded in the model.

## Commands

```sh
./scripts/translate.sh
./scripts/build-proofs.sh
```

Generated Lean code belongs in `proofs/FastcryptoSigma/Code`. Hand-written
algebraic specifications and refinement proofs belong in `Spec` and
`Properties` respectively.
