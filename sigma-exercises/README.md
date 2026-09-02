# Sigma Protocol Exercises

These exercises build the Lean-side specification and security argument before
introducing Aeneas or the Rust implementation.

Open this directory itself as the VS Code workspace:

```sh
code .
```

The exercise project uses the known-compatible Lean and Mathlib 4.31.0
baseline shared by the local VCVio and Aeneas checkouts.

The shared notation table, protocol diagram, transcript type, and deterministic
definitions are in `SigmaExercises/Spec/Defs.lean`. We consistently write `𝔽`
and `𝔾` for the scalar-field and group types, uppercase letters for group
elements, and lowercase letters for scalars.

## Exercise 1: Honest transcript acceptance (completed)

Exercise 1 establishes perfect completeness: every honestly constructed
transcript is accepted.

## Exercise 2: Special soundness (completed)

Exercise 2 established two connected facts:

1. Eliminate the shared commitment from two accepting transcripts.
2. Use the resulting equation to prove that the extracted scalar is a valid
   witness.

## Exercise 3: Deterministic simulation (completed)

Open `SigmaExercises/Exercise03.lean`. It asks you to construct an accepting
transcript without a witness and relate that construction to an honest
transcript. Equality of transcript distributions is deliberately postponed.

## Exercise 4: Uniform response distribution (completed)

Open `SigmaExercises/Exercise04.lean`. It introduces VCVio's uniform sampler,
probabilistic computations, and exact game equivalence. The goal is to prove
that, for fixed `x` and `c`, an honest response generated from a uniform nonce
is itself uniformly distributed.

## Exercise 5: Full honest-verifier zero knowledge (completed)

Exercise 5 proves exact equality between the real transcript distribution and
the simulator transcript distribution using a relational coupling and the
response-map bijection from Exercise 4.

Do not change the definitions or theorem statements during the first attempt.

Check the file from this directory with:

```sh
bash scripts/check-exercise.sh
```

The checker builds the exercise project using the pinned toolchain.
