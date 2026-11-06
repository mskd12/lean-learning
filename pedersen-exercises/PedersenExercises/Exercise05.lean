import Examples.Pedersen
import Mathlib.Algebra.Field.ZMod

/-!
# Exercise 5: A concrete instance

Every theorem so far is about an abstract `Module F G` with a generator `g`
whose action `· • g` is a bijection. This exercise checks that the
assumptions are satisfiable. Take `F = G = ZMod p` for a prime `p` and
`g = 1`. Then `x • 1 = x`, so the generator hypothesis is trivial.

This is the same move as `FastcryptoSigma.Spec.VCVioBridge`: specialise a
generic VCVio theorem to a concrete choice of types.
-/

namespace PedersenExercises.Exercise05

open OracleComp OracleSpec CommitmentScheme DiffieHellman

variable (p : ℕ) [Fact p.Prime]

/-- VCVio needs a uniform sampler on the scalar type. -/
noncomputable instance : SampleableType (ZMod p) := SampleableType.ofFintype (ZMod p)

/-!
## Exercise 5a: The generator hypothesis

Hint. `smul_eq_mul` turns `x • 1` into `x * 1`, and `simp` knows the identity
map is a bijection.
-/

theorem one_bijective : Function.Bijective (· • (1 : ZMod p) : ZMod p → ZMod p) := by
  sorry

/-!
## Exercise 5b: Both security theorems for the concrete scheme

Apply the VCVio theorems `pedersenCommit.perfectlyHiding` and
`pedersenCommit.binding_le_dlog` with 5a.
-/

theorem perfectlyHiding : (pedersenCommit (F := ZMod p) (1 : ZMod p)).PerfectlyHiding := by
  sorry

theorem binding_le_dlog (binder : BindingAdv (ZMod p) (ZMod p) (ZMod p) (ZMod p)) :
    Pr[= true | (pedersenCommit (1 : ZMod p)).bindingExp binder] ≤
    Pr[= true | dlogExp (1 : ZMod p) (pedersenCommit.dlogReduction binder)] := by
  sorry

/-!
After the proofs, answer these questions:

1. Is DLog hard in `ZMod p` with generator `1`? What does that say about the
   gap between "the theorem applies" and "the scheme is secure"?
2. Which `Fintype`, `Finite`, and `SampleableType` instances did Lean find on
   its own, and which did you have to provide?
-/

end PedersenExercises.Exercise05
