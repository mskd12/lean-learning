import SigmaExercises.Spec.Defs

/-!
# Exercise 2: Special soundness

Exercise 1 showed that an honestly constructed transcript is accepted. This
exercise turns acceptance in the other direction: two accepting transcripts
with the same commitment and different challenges determine a valid witness.

There is still no probability, random oracle, or Fiat--Shamir transform here.
-/

namespace SigmaExercises.Exercise02

open SigmaExercises.Spec

variable {𝔽 𝔾 : Type} [Field 𝔽] [AddCommGroup 𝔾] [Module 𝔽 𝔾]

/-!
## Exercise 2a: Remove the shared commitment

Replace `sorry` with a proof that subtracting two accepting verification
equations eliminates their common commitment `R`.
-/

theorem accepting_responses_relation
    (G X R : 𝔾) (c₁ c₂ z₁ z₂ : 𝔽)
    (h₁ : verify G X R c₁ z₁)
    (h₂ : verify G X R c₂ z₂) :
    (z₁ - z₂) • G = (c₁ - c₂) • X := by
  simp [verify] at h₁
  simp [verify] at h₂
  rw [sub_smul, sub_smul]
  rw [h₁, h₂]
  rw [add_sub_add_left_eq_sub]

/-!
## Exercise 2b: Extract the witness

Replace `sorry` with a proof that the extracted scalar satisfies the witness
relation. You may use `accepting_responses_relation` after proving it.
-/

theorem extracted_witness_is_valid
    (G X R : 𝔾) (c₁ c₂ z₁ z₂ : 𝔽)
    (h₁ : verify G X R c₁ z₁)
    (h₂ : verify G X R c₂ z₂)
    (hChallenges : c₁ ≠ c₂) :
    witnessRelation G X (extractWitness c₁ c₂ z₁ z₂) := by
  unfold witnessRelation
  simp [extractWitness]
  have hInt1: (c₁ - c₂) ≠ 0 := by
    rw [sub_ne_zero]
    exact hChallenges
  have hInt2: (z₁ - z₂) • G = (c₁ - c₂) • X :=
    accepting_responses_relation G X R c₁ c₂ z₁ z₂ h₁ h₂
  rw [@div_eq_inv_mul, mul_smul, hInt2]
  rw [propext (inv_smul_eq_iff₀ hInt1)]


/-!
After attempting the proofs, consider these questions:

1. Why must both transcripts contain exactly the same commitment `R`?
2. Where is the assumption `c₁ ≠ c₂` needed?
3. Why does the extractor divide the response difference by the challenge
   difference?
4. Why is this called *special* soundness rather than ordinary soundness?
5. What is still missing before this becomes a probabilistic knowledge
   extractor against a prover?
-/

end SigmaExercises.Exercise02
