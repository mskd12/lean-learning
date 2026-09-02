import SigmaExercises.Spec.Defs

/-!
# Exercise 3: The deterministic core of honest-verifier zero knowledge

Special soundness extracted a witness from two accepting transcripts. We now
move in the opposite direction: construct one accepting transcript without
using a witness at all.

This exercise proves only deterministic algebraic statements. It does not yet
claim that simulated and honest transcripts have the same distribution.
-/

namespace SigmaExercises.Exercise03

open SigmaExercises.Spec

variable {𝔽 𝔾 : Type} [Field 𝔽] [AddCommGroup 𝔾] [Module 𝔽 𝔾]

/-!
## Exercise 3a: The simulated transcript is accepted

Replace `sorry` with a proof that the verifier accepts the transcript produced
from `c` and `z`. Notice that the theorem has no witness `x`.
-/

theorem simulated_transcript_accepts
    (G X : 𝔾) (c z : 𝔽) :
    verify G X (simulatedCommitment G X c z) c z := by
  simp [verify, simulatedCommitment]

/-!
## Exercise 3b: Honest and simulated commitments agree pointwise

Suppose `z` is the response of an honest prover. Replace `sorry` with a proof
that computing the commitment backwards from `c` and `z` recovers the honest
commitment.
-/

theorem simulated_commitment_eq_honest
    (G X : 𝔾) (x r c : 𝔽)
    (hX : witnessRelation G X x) :
    simulatedCommitment G X c (respond x r c) = commit G r := by
  unfold witnessRelation at hX
  simp [simulatedCommitment, respond, commit, add_smul, mul_smul, hX]

/-!
After attempting the proofs, consider these questions:

1. Why does `simulated_transcript_accepts` not need a witness?
2. Why does the simulator choose `c` and `z` before computing `R`?
3. Why is producing an accepting transcript not, by itself, a zero-knowledge
   proof?
4. Which distributional fact about `r ↦ r + c * x` would connect these
   deterministic statements to honest-verifier zero knowledge?
5. Why does this simulator naturally correspond to an honest verifier rather
   than an arbitrary malicious verifier?
-/

end SigmaExercises.Exercise03
