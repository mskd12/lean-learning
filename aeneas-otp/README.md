# Rust OTP through Aeneas and Lean

This learning project follows one byte of one-time-pad encryption through:

1. executable safe Rust;
2. Charon's LLBC intermediate representation;
3. Aeneas-generated Lean;
4. functional-correctness theorems; and
5. a bridge to VCVio's probabilistic one-time-pad model.

The toolchain is kept local to this directory so it does not alter the existing
VCVio project.

## Pipeline

```text
src/lib.rs
    -- Charon --> generated/aeneas_otp.llbc
    -- Aeneas --> proofs/AeneasOtp/Code/{Types,Funs}.lean
    -- Lake ----> checked Lean modules
```

The generated implementation is deliberately kept separate from the proofs we
will write. Regenerating `Code/Funs.lean` should therefore not overwrite any
hand-written theorem.

## Everyday commands

Regenerate LLBC and Lean from the Rust source:

```bash
./scripts/translate.sh
```

Compile the generated Lean:

```bash
./scripts/build-proofs.sh
```

Run the ordinary Rust test:

```bash
cargo test
```

## Pinned toolchain

- Aeneas: `74a460a2f80ecea481bbdf1a08f881633c3bb097`
- Charon: `a1d989057b50b0429ccd96c5b4c4428b9b218b21`
- Charon Rust nightly: `nightly-2026-08-18`
- Aeneas Lean: `v4.31.0`
- Local OCaml switch: `5.3.0`

The compatible local VCVio checkout and the Aeneas proof project both use Lean
`v4.31.0`.
