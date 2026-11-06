import Examples.Pedersen

/-!
# Exercise 1: The commitment scheme and its correctness

VCVio packages a non-interactive commitment scheme as a structure with three
fields. For Pedersen the four type parameters are:

| Parameter | Meaning | Pedersen |
| --- | --- | --- |
| `PP` | public parameters | `G`, the element `h = x • g` |
| `M` | message space | `F`, the scalar field |
| `C` | commitment space | `G` |
| `D` | opening space | `F`, the randomness `d` |

```text
setup           : x ← $ᵗ F;  return h := x • g
commit h m      : d ← $ᵗ F;  return (d • g + m • h, d)
verify h m c d  : decide (d • g + m • h = c)
```

`PerfectlyCorrect` says: for every `pp` that `setup` can output and every
`(c, d)` that `commit pp m` can output, `verify pp m c d = true`. Note that it
is stated with `support`, the set of possible outputs, not with probabilities.
-/

namespace PedersenExercises.Exercise01

open OracleComp OracleSpec CommitmentScheme

variable {F : Type} [Field F] [SampleableType F]
variable {G : Type} [AddCommGroup G] [Module F G] [DecidableEq G]

/-!
## Exercise 1: Honest commitments verify

Hints. `intro` the public parameter, the message, the pair `cd`, and the
membership proof. Rewrite the membership through `support_bind` and
`support_pure`, then `obtain` the sampled `d`. The remaining goal is a
`decide` of a true equation.
-/

theorem correct (g : G) : (pedersenCommit (F := F) g).PerfectlyCorrect := by
  intro pp h1 m (c, d) h2
  simp only [pedersenCommit, decide_eq_true_eq]
  simp only [pedersenCommit, bind_pure_comp, support_map, support_uniformSample, Set.image_univ,
    Set.mem_range, Prod.mk.injEq, exists_eq_right] at h2
  rw [h2]

/-!
After the proof, answer these questions:

1. Why is `verify` a plain `Bool` and not a `ProbComp Bool`?
2. Why does `PerfectlyCorrect` quantify over `pp ∈ support cs.setup` instead
   of over every `pp : G`?
3. `Schnorr.sigma_complete` states "always accepts" as probability one. This
   theorem states it as a fact about `support`. When is each form easier?
-/

end PedersenExercises.Exercise01
