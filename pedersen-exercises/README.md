# Pedersen Commitment Exercises

These exercises walk through VCVio's Pedersen commitment example end to end:
the scheme, correctness, perfect hiding, and the reduction from computational
binding to discrete log.

Open this directory itself as the VS Code workspace:

```sh
code .
```

The project uses Lean and Mathlib 4.31.0, the same as the Sigma exercises.
Lake gets VCVio `v4.31.0` from git. The reference file is
`.lake/packages/VCVio/Examples/Pedersen.lean`. The generic commitment
structure is in `VCVio/CryptoFoundations/CommitmentScheme.lean`, and the DLog
game is in `VCVio/CryptoFoundations/HardnessAssumptions/DiffieHellman.lean`.

## Notation

| Symbol | Type | Meaning |
| --- | --- | --- |
| `F` | `Type` | Scalar field |
| `G` | `Type` | Additive group of points |
| `g` | `G` | Public generator |
| `x` | `F` | Setup secret, with `h = x • g` |
| `h`, `pp` | `G` | Public parameter |
| `m` | `F` | Message |
| `d` | `F` | Commitment randomness, also the opening |
| `c` | `G` | Commitment, with `c = d • g + m • h` |

## Exercises

Each theorem is stated and its proof is replaced by `sorry`. Each file ends
with questions to answer in your own words. Reference proofs are in
`solutions/`; they are not part of the build.

1. **Exercise 1: Correctness.** The scheme as a `CommitmentScheme` and a
   `support`-based proof that honest commitments verify.
2. **Exercise 2: Perfect hiding via pushforward.** The commitment map is a
   bijection, so the commitment is uniform for every message. This is the
   VCVio proof and it needs `· • g` to be a bijection.
3. **Exercise 3: Perfect hiding via coupling.** The same theorem by a
   relational coupling in the style of the Schnorr HVZK proof. This proof does
   not need the generator hypothesis.
4. **Exercise 4: Binding reduces to DLog.** The extractor algebra, then the
   reduction `Pr[binding wins] ≤ Pr[dlog wins]` through a shared sample space
   and `probEvent_mono`.
5. **Exercise 5: A concrete instance.** `F = G = ZMod p` with `g = 1`, to
   check that the abstract assumptions are satisfiable.

Do not change the theorem statements during the first attempt.

Check the project from this directory with:

```sh
bash scripts/check-exercise.sh
```

The checker builds the exercise project using the pinned toolchain. A `sorry`
produces a warning, not an error.
