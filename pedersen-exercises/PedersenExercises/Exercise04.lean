import Examples.Pedersen

/-!
# Exercise 4: Computational binding reduces to discrete log

This is the first *reduction* in these exercises. The statement has three
parts that every reduction has.

1. An adversary type. `BindingAdv G F G F` is a function from the public
   parameter to a probabilistic output `(c, m₁, d₁, m₂, d₂)`.
2. A named reduction. `pedersenCommit.dlogReduction binder` is a program. It
   runs the binder on `h`, checks the win condition, and extracts
   `(d₁ - d₂) / (m₂ - m₁)`.
3. An inequality on probabilities.

```text
Pr[ binder wins bindingExp ]  ≤  Pr[ dlogReduction binder wins dlogExp ]
```

The proof idea: both experiments start by sampling `x` and running `binder`
on `x • g`. So they are one shared program `base` followed by two different
post-processing predicates. The binding predicate implies the DLog predicate
pointwise, so `probEvent_mono` gives the inequality.

The algebra in 4a is the same computation as Schnorr special soundness:
two openings of one commitment reveal the discrete log.
-/

namespace PedersenExercises.Exercise04

open OracleComp OracleSpec CommitmentScheme DiffieHellman

section Algebra

variable {F : Type} [Field F]
variable {G : Type} [AddCommGroup G] [Module F G]

/-!
## Exercise 4a: Two openings reveal the discrete log

Hints. Use `hg.1` (injectivity) to pass from `(d₁ + m₁ * x) • g = (d₂ + m₂ * x) • g`
to the scalar equation. Then `linear_combination` and `mul_div_cancel_left₀`.
Compare with `Schnorr.sigma_speciallySound`.
-/

theorem extractedLog_eq_dlog (g : G) (hg : Function.Bijective (· • g : F → G))
    {x m₁ d₁ m₂ d₂ : F} {c : G}
    (hm : m₁ ≠ m₂)
    (h₁ : d₁ • g + m₁ • (x • g) = c)
    (h₂ : d₂ • g + m₂ • (x • g) = c) :
    (d₁ - d₂) / (m₂ - m₁) = x := by
  sorry

variable [DecidableEq F] [DecidableEq G]

/-!
## Exercise 4b: A binding win is a DLog win

This is glue. When the win condition holds, the `if` in the reduction takes
its first branch and 4a applies.
-/

theorem bindingWin_implies_dlogWin (g : G) (hg : Function.Bijective (· • g : F → G))
    {x m₁ d₁ m₂ d₂ : F} {c : G}
    (hwin : m₁ ≠ m₂ ∧ d₁ • g + m₁ • (x • g) = c ∧ d₂ • g + m₂ • (x • g) = c) :
    (if decide (m₁ ≠ m₂ ∧ d₁ • g + m₁ • (x • g) = c ∧ d₂ • g + m₂ • (x • g) = c) then
      (d₁ - d₂) / (m₂ - m₁)
    else 0) = x := by
  sorry

end Algebra

section Reduction

variable {F : Type} [Field F] [DecidableEq F] [SampleableType F]
variable {G : Type} [AddCommGroup G] [Module F G] [DecidableEq G]

/-!
## Exercise 4c: The reduction

Before writing Lean, write the proof on paper in three sentences.

Hints. Define `base : ProbComp (F × (G × F × F × F × F))` that samples `x`
and runs `binder (x • g)`. Define the two win predicates on its output.
Prove that each experiment equals `decide ∘ predicate <$> base`; `simp` with
the definitions followed by `grind` does this. Finish with
`OracleComp.ProgramLogic.probEvent_mono` and 4b.
-/

theorem binding_le_dlog (g : G) (hg : Function.Bijective (· • g : F → G))
    (binder : BindingAdv G F G F) :
    Pr[= true | (pedersenCommit g).bindingExp binder] ≤
    Pr[= true | dlogExp g (pedersenCommit.dlogReduction binder)] := by
  sorry

end Reduction

/-!
After the proofs, answer these questions:

1. Why does `dlogReduction` return `0` when the binder fails? Does the
   theorem depend on that choice?
2. Hiding is perfect and binding is computational. Point to the exact line
   in each proof where the group structure enters.
3. Is the bound tight? Could a reduction lose a factor here?
4. Where does the statement record that the reduction runs in about the
   same time as the binder? Hint: it does not. What would have to change in
   the types to record it?
-/

end PedersenExercises.Exercise04
