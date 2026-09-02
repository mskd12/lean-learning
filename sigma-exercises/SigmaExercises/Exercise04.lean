import SigmaExercises.Spec.Defs
import VCVio.ProgramLogic.NotationCore

/-!
# Exercise 4: The honest response is uniformly distributed

We now make our first probability-distribution statement.

Fix the witness `x` and challenge `c`. An honest prover samples `r` uniformly
and returns

```text
                     respond x · c
        uniform r  -------------------->  z = r + c * x
```

The notation `$ᵗ 𝔽` is VCVio's uniform sampler on `𝔽`. If `f : 𝔽 → 𝔽`
and `d : ProbComp 𝔽`, then `f <$> d` samples from `d` and applies `f`.
Thus `honestResponseGame x c` is the distribution obtained by uniformly
sampling `r` and returning `respond x r c`.

`GameEquiv g₁ g₂` means that `g₁` and `g₂` have exactly the same output
distribution. This is equality, not merely computational indistinguishability.
-/

namespace SigmaExercises.Exercise04

open OracleComp
open OracleComp.ProgramLogic
open SigmaExercises.Spec

variable {𝔽 : Type} [Field 𝔽]

/-!
## Exercise 4a: The response map is a bijection

For fixed `x` and `c`, prove that `r ↦ r + c * x` is a bijection.

There are no assumptions such as `x ≠ 0` or `c ≠ 0`: this map is simply
translation by the fixed scalar `c * x`.
-/

theorem responseMap_bijective (x c : 𝔽) :
    Function.Bijective (fun r : 𝔽 => respond x r c) := by
  simpa [respond] using AddGroup.addRight_bijective (c * x)

variable [SampleableType 𝔽]

/-- Sample an honest nonce and turn it into the prover's response. -/
def honestResponseGame (x c : 𝔽) : ProbComp 𝔽 := do
  let r ← $ᵗ 𝔽
  return respond x r c

/-!
## Exercise 4b: A uniform nonce gives a uniform response

Prove that the honest response game has the same output distribution as a
fresh uniform sample. VCVio's theorem `GameEquiv.map_uniformSample_bij` is the
distributional bridge: it says that mapping a uniform sample through a
bijection preserves the uniform distribution.
-/

theorem honestResponseGame_equiv_uniform (x c : 𝔽) :
    GameEquiv (honestResponseGame x c) ($ᵗ 𝔽 : ProbComp 𝔽) := by
  unfold honestResponseGame
  exact GameEquiv.map_uniformSample_bij (responseMap_bijective x c)

/-!
After attempting the proofs, consider these questions:

1. Which line is algebra, and which line turns that algebra into a statement
   about distributions?
2. Why are `x` and `c` fixed in this theorem?
3. Does this theorem say that the complete transcript `(R, c, z)` has the
   simulated distribution yet?
4. Why is exact `GameEquiv` stronger than computational indistinguishability?
-/

end SigmaExercises.Exercise04
