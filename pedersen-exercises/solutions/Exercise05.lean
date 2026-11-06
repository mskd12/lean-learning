import Examples.Pedersen
import Mathlib.Algebra.Field.ZMod

namespace PedersenExercises.Exercise05

open OracleComp OracleSpec CommitmentScheme DiffieHellman

variable (p : ℕ) [Fact p.Prime]

noncomputable instance : SampleableType (ZMod p) := SampleableType.ofFintype (ZMod p)

theorem one_bijective : Function.Bijective (· • (1 : ZMod p) : ZMod p → ZMod p) := by
  simp [smul_eq_mul]

theorem perfectlyHiding : (pedersenCommit (F := ZMod p) (1 : ZMod p)).PerfectlyHiding :=
  pedersenCommit.perfectlyHiding (one_bijective p)

theorem binding_le_dlog (binder : BindingAdv (ZMod p) (ZMod p) (ZMod p) (ZMod p)) :
    Pr[= true | (pedersenCommit (1 : ZMod p)).bindingExp binder] ≤
    Pr[= true | dlogExp (1 : ZMod p) (pedersenCommit.dlogReduction binder)] :=
  pedersenCommit.binding_le_dlog (one_bijective p) binder

end PedersenExercises.Exercise05
