# Fastcrypto Merkle verification exercise

This project uses Aeneas to translate selected Fastcrypto Merkle functions from
Rust to Lean. The exercises will prove properties directly about those
translated functions.

## Current state

The Rust translation is complete. The generated Lean code includes:

- Merkle tree construction.
- Root extraction.
- Inclusion proof generation.
- Inclusion proof verification.
- Two small Rust entry points for the exercise.

The Fastcrypto changes are on branch `aeneas-merkle-loop` at commit
`d7822bf97`. Cargo pins this exact Git revision. A local Fastcrypto checkout is
not required.

The proof project is not complete yet. Seven external functions still need
concrete Lean models. There are no theorem statements or proofs yet.

## Design

We will prove properties of the Aeneas-generated Fastcrypto functions. We will
not create a second executable Merkle tree implementation in Lean.

Small proof predicates and loop invariants are allowed. They describe the
required property or the current Rust state. They must not duplicate the full
tree algorithm.

The initial exercise sequence is:

1. Prove the root of an empty tree.
2. Prove the root of a one-leaf tree.
3. Prove that an out-of-bounds proof request fails.
4. Prove that an in-bounds proof request succeeds.
5. Prove that a generated inclusion proof verifies.
6. Prove that false acceptance produces a hash collision.

Non-inclusion proofs and probabilistic security games are later extensions.

## Rust entry point

The original Fastcrypto builder accepts any Rust iterator. Aeneas does not yet
support all required iterator methods. Fastcrypto therefore has an additional
slice-based entry point named `build_from_serialized_slice`.

The slice entry point uses an explicit index loop. It calls the same private
tree builder as the original iterator entry point. The exercise verifies the
slice entry point. It does not verify the generic iterator preprocessing.

## External Lean models

The generated `FunsExternal_Template.lean` file contains seven declarations.
We will provide concrete definitions for them before the exercise starts:

- Shared-reference `AsRef`.
- Slice `AsRef`.
- `core::hint::must_use`.
- Error-message formatting.
- `Vec::reserve`.
- Vector-to-slice `AsRef`.
- `HashFunction::OUTPUT_SIZE`.

These definitions are translation infrastructure. They are not exercises.
The finished infrastructure must contain no axioms and no `sorry` definitions.

## Hash model

The translated Merkle functions are generic over Fastcrypto's
`HashFunction<32>` trait. No concrete Blake2 implementation is translated.

We will provide an adapter for an arbitrary pure function:

```text
H : List U8 -> Array U8 32
```

The adapter uses a byte list as its streaming state:

1. `default` creates an empty list.
2. `update` appends bytes to the list.
3. `finalize` applies `H` to the complete list.
4. `OUTPUT_SIZE` returns `32`.

The functional correctness exercises quantify over any `H`. They do not need a
collision-resistance assumption.

We will not assume that `H` is globally injective. Its input space is larger
than its 256-bit output space. Instead, the soundness exercise will use:

```text
HashCollision H :=
  there are distinct inputs x and y such that H x = H y
```

The target soundness result is:

```text
If Fastcrypto accepts a false inclusion proof, then HashCollision H.
```

A later VCVio exercise can connect this deterministic result to a
collision-resistance game.

## Project layout

- `src/lib.rs`: Rust entry points used by the exercise.
- `scripts/translate.sh`: Charon and Aeneas translation command.
- `proofs/FastcryptoMerkle/Code`: Generated Lean code.
- `proofs/FastcryptoMerkle/Spec`: Planned hand-written definitions.
- `proofs/FastcryptoMerkle/Properties`: Planned exercises and solutions.

## Commands

Generate the Lean translation:

```sh
make regenerate
```

The first run downloads the pinned Fastcrypto revision from GitHub.

Check the Rust wrapper:

```sh
make check
```

Build the proof project after the external models exist:

```sh
./scripts/build-proofs.sh
```

The translation currently uses Rust nightly `2026-08-18`, Lean `4.31.0`, the
local Aeneas checkout at `../tools/aeneas`, and the local VCVio checkout at
`../tools/VCVio-v4.31.0`.
