import Examples.Pedersen

namespace PedersenExercises.Exercise01

open OracleComp OracleSpec CommitmentScheme

variable {F : Type} [Field F] [SampleableType F]
variable {G : Type} [AddCommGroup G] [Module F G] [DecidableEq G]

theorem correct (g : G) : (pedersenCommit (F := F) g).PerfectlyCorrect := by
  intro pp _hpp m cd hmem
  have hmem' : cd ∈ support (do
      let d ← ($ᵗ F); pure ((d : F) • g + m • pp, d)) := hmem
  simp only [support_bind, support_pure, Set.mem_iUnion, Set.mem_singleton_iff] at hmem'
  obtain ⟨d', -, rfl, rfl⟩ := hmem'
  change decide ((d' : F) • g + m • pp = d' • g + m • pp) = true
  simp

end PedersenExercises.Exercise01
