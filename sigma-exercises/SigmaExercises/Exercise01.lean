import SigmaExercises.Spec.Defs

/-!
# Exercise 1: Honest transcript acceptance

This exercise isolates the deterministic algebra at the heart of the Schnorr
Sigma protocol. There is no probability, random oracle, Fiat--Shamir transform,
or Rust implementation in scope yet.

The notation table and protocol diagram live in `SigmaExercises.Spec.Defs`.
-/

namespace SigmaExercises.Exercise01

open SigmaExercises.Spec

variable {𝔽 𝔾 : Type} [Field 𝔽] [AddCommGroup 𝔾] [Module 𝔽 𝔾]

/-- An honestly constructed transcript is accepted when `X` corresponds to
the witness `x`.

Replace `sorry` with your proof. -/
theorem honest_accepts
    (G X : 𝔾) (x r c : 𝔽)
    (hX : witnessRelation G X x) :
    verify G X (commit G r) c (respond x r c) := by
  unfold witnessRelation at hX
  simp [verify, commit, respond]
  rw [← hX, add_smul, mul_smul]

/-!
After attempting the proof, consider these questions:

1. At what point does the proof use the witness relation `x • G = X`?
2. Which statement in the theorem represents the prover's commitment?
3. Why does this theorem not need to know how `r` or `c` was chosen?
4. What security property is not established by this theorem?
-/

end SigmaExercises.Exercise01
