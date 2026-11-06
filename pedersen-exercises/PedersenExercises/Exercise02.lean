import Examples.Pedersen

/-!
# Exercise 2: Perfect hiding as a pushforward of uniform

`PerfectlyHiding` says: for every honest `pp` and every two messages, the
distribution of the commitment alone is the same.

```text
𝒟[ Prod.fst <$> commit pp m₁ ]  =  𝒟[ Prod.fst <$> commit pp m₂ ]
```

The VCVio proof has three steps.

1. The map `d ↦ d • g + m • pp` is a bijection `F → G`, provided `· • g` is.
2. The commitment distribution is that map applied to a uniform `d`.
3. A bijection pushes uniform on `F` to uniform on `G`. Both sides are
   therefore uniform on `G`, so they are equal.

Step 3 is the lemma `evalDist_map_bijective_uniform_cross`. It is the same
fact that makes the one-time pad perfectly secret.
-/

namespace PedersenExercises.Exercise02

open OracleComp OracleSpec CommitmentScheme

section Algebra

variable {F : Type} [Field F]
variable {G : Type} [AddCommGroup G] [Module F G]

/-!
## Exercise 2a: The commitment map is a bijection

Hint. The map is the composition of `· • g` with the translation
`· + m • pp`. `AddGroup.addRight_bijective` and `Function.Bijective.comp`
finish it.
-/

theorem commitMap_bijective (g : G) (hg : Function.Bijective (· • g : F → G))
    (pp : G) (m : F) :
    Function.Bijective (fun d : F => d • g + m • pp) := by
  change Function.Bijective ((· + m • pp) ∘ (· • g : F → G))
  exact (AddGroup.addRight_bijective (m • pp)).comp hg

end Algebra

section Distribution

variable {F : Type} [Field F] [SampleableType F]
variable {G : Type} [AddCommGroup G] [Module F G] [DecidableEq G]

/-!
## Exercise 2b: The commitment is a mapped uniform sample

This is the step that turns a scheme into a distribution. `simp` with the
definition of `pedersenCommit` closes it. Step through to see what the monad
laws do.
-/

theorem commit_fst_eq_map (g : G) (pp : G) (m : F) :
    Prod.fst <$> (pedersenCommit (F := F) g).commit pp m =
      (fun d : F => d • g + m • pp) <$> ($ᵗ F) := by
  simp [pedersenCommit]

/-!
## Exercise 2c: Perfect hiding

Rewrite both sides with 2b. Then apply `evalDist_map_bijective_uniform_cross`
to each side with the bijection from 2a.
-/

theorem perfectlyHiding [SampleableType G] [Finite F]
    (g : G) (hg : Function.Bijective (· • g : F → G)) :
    (pedersenCommit (F := F) g).PerfectlyHiding := by
  intro pp h m₁ m₂
  rw [commit_fst_eq_map, commit_fst_eq_map]
  have h₁ := evalDist_map_bijective_uniform_cross (α := F) (β := G)
    (fun d => d • g + m₁ • pp) (commitMap_bijective g hg pp m₁)
  have h₂ := evalDist_map_bijective_uniform_cross (α := F) (β := G)
    (fun d => d • g + m₂ • pp) (commitMap_bijective g hg pp m₂)
  rw [h₁, h₂]

end Distribution

/-!
After the proofs, answer these questions:

1. Where is `hg`, the bijectivity of `· • g`, used? What breaks without it?
2. Why does the theorem never use the fact that `pp` came from `setup`?
3. `[Finite F]` and `[SampleableType G]` are needed here but not in
   Exercise 1. Which step needs each one?
-/

end PedersenExercises.Exercise02
