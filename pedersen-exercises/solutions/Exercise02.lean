import Examples.Pedersen

namespace PedersenExercises.Exercise02

open OracleComp OracleSpec CommitmentScheme

section Algebra

variable {F : Type} [Field F]
variable {G : Type} [AddCommGroup G] [Module F G]

theorem commitMap_bijective (g : G) (hg : Function.Bijective (· • g : F → G))
    (pp : G) (m : F) :
    Function.Bijective (fun d : F => d • g + m • pp) := by
  change Function.Bijective ((· + m • pp) ∘ (· • g : F → G))
  exact (AddGroup.addRight_bijective (m • pp)).comp hg

end Algebra

section Distribution

variable {F : Type} [Field F] [SampleableType F]
variable {G : Type} [AddCommGroup G] [Module F G] [DecidableEq G]

theorem commit_fst_eq_map (g : G) (pp : G) (m : F) :
    Prod.fst <$> (pedersenCommit (F := F) g).commit pp m =
      (fun d : F => d • g + m • pp) <$> ($ᵗ F) := by
  simp [pedersenCommit]

theorem perfectlyHiding [SampleableType G] [Finite F]
    (g : G) (hg : Function.Bijective (· • g : F → G)) :
    (pedersenCommit (F := F) g).PerfectlyHiding := by
  intro pp _hpp m₁ m₂
  rw [commit_fst_eq_map, commit_fst_eq_map]
  have h₁ := evalDist_map_bijective_uniform_cross (α := F) (β := G)
    (fun d => d • g + m₁ • pp) (commitMap_bijective g hg pp m₁)
  have h₂ := evalDist_map_bijective_uniform_cross (α := F) (β := G)
    (fun d => d • g + m₂ • pp) (commitMap_bijective g hg pp m₂)
  exact h₁.trans h₂.symm

end Distribution

end PedersenExercises.Exercise02
