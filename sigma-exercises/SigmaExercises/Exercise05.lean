import SigmaExercises.Exercise03
import SigmaExercises.Exercise04
import VCVio.ProgramLogic.Tactics.Relational

/-!
# Exercise 5: Full honest-verifier zero knowledge

Exercise 4 proved the distributional core: for fixed `x` and `c`, sampling a
uniform nonce `r` and computing `z = r + c * x` gives a uniform `z`.

We now state the full result. Both games return the public transcript
`(R, c, z)`.

```text
real transcript game                   simulated transcript game

c ← uniform 𝔽                         c ← uniform 𝔽
r ← uniform 𝔽                         z ← uniform 𝔽
R := r • G                               R := z • G - c • X
z := r + c * x
return (R, c, z)                       return (R, c, z)
```

The real interactive protocol sends `R` before the honest verifier samples
`c`. Here we sample `c` first because the two uniform draws are independent;
this is a distributional presentation of the same transcript, chosen to line
up with the simulator.

The theorem below is *perfect honest-verifier zero knowledge*: the two
distributions are equal exactly, not just computationally indistinguishable.
-/

namespace SigmaExercises.Exercise05

open OracleComp
open OracleComp.ProgramLogic
open SigmaExercises.Spec

variable {𝔽 𝕊 : Type}
variable [Field 𝔽] [AddCommGroup 𝕊] [Module 𝔽 𝕊]
variable [SampleableType 𝔽]

/-- The honest transcript, written with its two independent random choices first. -/
def realTranscriptGame (G : 𝕊) (x : 𝔽) : ProbComp (𝕊 × 𝔽 × 𝔽) := do
  let c ← $ᵗ 𝔽
  let r ← $ᵗ 𝔽
  let R := commit G r
  let z := respond x r c
  return (R, c, z)

/-- The simulator samples a challenge and response, then solves backwards for `R`. -/
def simulatedTranscriptGame (G X : 𝕊) : ProbComp (𝕊 × 𝔽 × 𝔽) := do
  let c ← $ᵗ 𝔽
  let z ← $ᵗ 𝔽
  let R := simulatedCommitment G X c z
  return (R, c, z)

/-!
## Exercise 5: The full transcript distributions agree

Before attempting Lean, explain this theorem in your own words. The intended
paper proof has two ingredients:

1. With `z = r + c * x` and `X = x • G`, the simulator's backwards
   commitment is the honest commitment: `z • G - c • X = r • G`.
2. For each fixed challenge `c`, the map `r ↦ r + c * x` is a bijection of
   `𝔽`, so replacing uniform `r` by uniform `z` does not change the
   transcript distribution.

The VCVio proof of the corresponding Schnorr theorem uses a relational
coupling: it samples the same `c` on both sides, pairs `r` on the real side
with `z = r + c * x` on the simulated side, and then proves the two returned
triples are equal.
-/

theorem realTranscriptGame_equiv_simulated
    (G X : 𝕊) (x : 𝔽)
    (hX : witnessRelation G X x) :
    GameEquiv (realTranscriptGame G x) (simulatedTranscriptGame G X) := by
  unfold realTranscriptGame simulatedTranscriptGame simulatedCommitment respond commit
  apply GameEquiv.of_relTriple
  rvcstep
  intro c _ hc
  subst hc
  rvcstep using (fun r : 𝔽 => r + c * x)
  · apply OracleComp.ProgramLogic.Relational.relTriple_pure_pure
    change _ = _
    unfold witnessRelation at hX
    simp [hX, add_smul, mul_smul]
  · exact SigmaExercises.Exercise04.responseMap_bijective x c


/-!
After reading the theorem, answer these before we work on its Lean proof:

1. Which random values are paired by the coupling?
2. Why must the same `c` be used on both sides of that coupling?
3. Where is the witness relation `x • G = X` needed?
4. Which part of the argument would fail if the verifier chose `c` as a
   function of `R` rather than uniformly and independently?
-/

end SigmaExercises.Exercise05
