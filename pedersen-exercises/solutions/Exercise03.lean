import Examples.Pedersen
import VCVio.ProgramLogic.Tactics.Relational

namespace PedersenExercises.Exercise03

open OracleComp OracleSpec CommitmentScheme
open OracleComp.ProgramLogic

variable {F : Type} [Field F] [SampleableType F]
variable {G : Type} [AddCommGroup G] [Module F G] [DecidableEq G]

theorem setup_mem (g : G) (pp : G)
    (hpp : pp ∈ support (pedersenCommit (F := F) g).setup) :
    ∃ x : F, pp = x • g := by
  simp only [pedersenCommit, support_bind, support_pure, support_uniformSample,
    Set.mem_iUnion, Set.mem_singleton_iff, Set.mem_univ, exists_true_left] at hpp
  obtain ⟨x, hx⟩ := hpp
  exact ⟨x, hx⟩

theorem commit_fst_equiv (g : G) (x m₁ m₂ : F) :
    GameEquiv
      (Prod.fst <$> (pedersenCommit (F := F) g).commit (x • g) m₁)
      (Prod.fst <$> (pedersenCommit (F := F) g).commit (x • g) m₂) := by
  simp only [pedersenCommit, map_bind, map_pure]
  apply GameEquiv.of_relTriple
  rvcstep using (fun d : F => d + (m₁ - m₂) * x)
  · apply Relational.relTriple_pure_pure
    change _ = _
    simp only [add_smul, sub_smul, mul_smul]
    abel
  · exact AddGroup.addRight_bijective _

theorem perfectlyHiding (g : G) : (pedersenCommit (F := F) g).PerfectlyHiding := by
  intro pp hpp m₁ m₂
  obtain ⟨x, rfl⟩ := setup_mem g pp hpp
  exact commit_fst_equiv g x m₁ m₂

end PedersenExercises.Exercise03
