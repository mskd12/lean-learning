# Aeneas translation of the fastcrypto Shamir code

This project translates five Shamir functions from `fastcrypto-tbls` to Lean
with Aeneas: `eval`, `add`, `c0`, `degree_bound`, and `recover_c0`.

## Requirements

- Aeneas `74a460a2` and Charon `a1d98905` in `../.tools/aeneas`. Run
  `../scripts/setup-tools.sh` to build them.
- Rust `nightly-2026-08-18`.
- Cargo gets fastcrypto from git at commit `878842e9` on branch
  `aeneas-shamir-loop`.

Later Charon versions reject `--preset=aeneas` together with
`--monomorphize`.

## Generic code fails

Aeneas cannot translate the generic `Poly<C: GroupElement>` code. It crashes
with "Internal error" at `fastcrypto/src/groups/mod.rs:62`. That line is the
cyclic bound `Scalar: GroupElement<ScalarType = Self>`. See Aeneas issue
#1493. The latest Aeneas (`ab34bd28`) has the same crash.

The entry points therefore use `Poly<RistrettoScalar>`, and Charon runs with
`--monomorphize`.

## Commands

```sh
./scripts/translate.sh
```

The generated Lean code is in `proofs/FastcryptoShamir/Code`. The external
functions do not have Lean models yet.
