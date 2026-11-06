import Examples.Pedersen
import VCVio.ProgramLogic.Tactics.Relational

/-!
# Exercise 3: Perfect hiding by a relational coupling

Exercise 2 compared both commitment distributions to a third thing, uniform
on `G`. This exercise compares them to each other directly, in the style of
the Schnorr HVZK proof.

The key observation: an honest `pp` has the form `x • g`. Then

```text
d • g + m • (x • g)  =  (d + m * x) • g
```

so both commitments are `(scalar) • g` for a uniform scalar. Couple the
left-hand `d` with the right-hand `d + (m₁ - m₂) * x`:

```text
left:   (d + m₁ * x) • g
right:  (d + (m₁ - m₂) * x + m₂ * x) • g  =  (d + m₁ * x) • g
```

The outputs agree, and the coupling map is a bijection of `F`. This proof
never needs `· • g` to be a bijection. In VCVio 4.31.0, `GameEquiv g₁ g₂`
unfolds to `𝒟[g₁] = 𝒟[g₂]`, so no bridge lemma is needed at the end.
-/

namespace PedersenExercises.Exercise03

open OracleComp OracleSpec CommitmentScheme
open OracleComp.ProgramLogic

variable {F : Type} [Field F] [SampleableType F]
variable {G : Type} [AddCommGroup G] [Module F G] [DecidableEq G]

/-!
## Exercise 3a: Honest parameters are multiples of `g`

Hint. `simp only` with `pedersenCommit`, `support_bind`, `support_pure`,
`support_uniformSample`, and the `Set.mem_*` lemmas.
-/

theorem setup_mem (g : G) (pp : G)
    (hpp : pp ∈ support (pedersenCommit (F := F) g).setup) :
    ∃ x : F, pp = x • g := by
  sorry

/-!
## Exercise 3b: The coupling

Hints. First normalise both programs with `simp only [pedersenCommit,
map_bind, map_pure]`. Then `apply GameEquiv.of_relTriple` and
`rvcstep using (fun d : F => d + (m₁ - m₂) * x)`. Two goals remain: the
returned values are equal, and the coupling map is a bijection. Compare with
`SigmaExercises.Exercise05`.
-/

theorem commit_fst_equiv (g : G) (x m₁ m₂ : F) :
    GameEquiv
      (Prod.fst <$> (pedersenCommit (F := F) g).commit (x • g) m₁)
      (Prod.fst <$> (pedersenCommit (F := F) g).commit (x • g) m₂) := by
  sorry

/-!
## Exercise 3c: Perfect hiding, without `hg`

Combine 3a and 3b.
-/

theorem perfectlyHiding (g : G) : (pedersenCommit (F := F) g).PerfectlyHiding := by
  sorry

/-!
After the proofs, answer these questions:

1. Exercise 2 needed `hg`. This proof does not. What does that tell you
   about which property of the group hiding depends on?
2. Which random values are paired by the coupling? Why must `x` be the same
   on both sides?
3. Write the paper version of this proof in two sentences. Then match each
   sentence to one tactic block.
-/

end PedersenExercises.Exercise03
