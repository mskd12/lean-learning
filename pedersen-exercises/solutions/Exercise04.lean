import Examples.Pedersen

namespace PedersenExercises.Exercise04

open OracleComp OracleSpec CommitmentScheme DiffieHellman

section Algebra

variable {F : Type} [Field F]
variable {G : Type} [AddCommGroup G] [Module F G]

theorem extractedLog_eq_dlog (g : G) (hg : Function.Bijective (· • g : F → G))
    {x m₁ d₁ m₂ d₂ : F} {c : G}
    (hm : m₁ ≠ m₂)
    (h₁ : d₁ • g + m₁ • (x • g) = c)
    (h₂ : d₂ • g + m₂ • (x • g) = c) :
    (d₁ - d₂) / (m₂ - m₁) = x := by
  have hcoeff : d₁ + m₁ * x = d₂ + m₂ * x := by
    apply hg.1
    calc
      (d₁ + m₁ * x) • g = d₁ • g + m₁ • (x • g) := by rw [add_smul, mul_smul]
      _ = c := h₁
      _ = d₂ • g + m₂ • (x • g) := h₂.symm
      _ = (d₂ + m₂ * x) • g := by rw [add_smul, mul_smul]
  have hmul : d₁ - d₂ = (m₂ - m₁) * x := by linear_combination hcoeff
  have hneq : m₂ - m₁ ≠ 0 := sub_ne_zero.mpr hm.symm
  rw [hmul, mul_div_cancel_left₀ x hneq]

variable [DecidableEq F] [DecidableEq G]

theorem bindingWin_implies_dlogWin (g : G) (hg : Function.Bijective (· • g : F → G))
    {x m₁ d₁ m₂ d₂ : F} {c : G}
    (hwin : m₁ ≠ m₂ ∧ d₁ • g + m₁ • (x • g) = c ∧ d₂ • g + m₂ • (x • g) = c) :
    (if decide (m₁ ≠ m₂ ∧ d₁ • g + m₁ • (x • g) = c ∧ d₂ • g + m₂ • (x • g) = c) then
      (d₁ - d₂) / (m₂ - m₁)
    else 0) = x := by
  rcases hwin with ⟨hm, h₁, h₂⟩
  simp [hm, h₁, h₂, extractedLog_eq_dlog g hg hm h₁ h₂]

end Algebra

section Reduction

variable {F : Type} [Field F] [DecidableEq F] [SampleableType F]
variable {G : Type} [AddCommGroup G] [Module F G] [DecidableEq G]

theorem binding_le_dlog (g : G) (hg : Function.Bijective (· • g : F → G))
    (binder : BindingAdv G F G F) :
    Pr[= true | (pedersenCommit g).bindingExp binder] ≤
    Pr[= true | dlogExp g (pedersenCommit.dlogReduction binder)] := by
  let base : ProbComp (F × (G × F × F × F × F)) := do
    let x ← $ᵗ F
    let out ← binder (x • g)
    return (x, out)
  let bindingWin : F × (G × F × F × F × F) → Prop := fun
    | (x, (c, m₁, d₁, m₂, d₂)) =>
        m₁ ≠ m₂ ∧ d₁ • g + m₁ • (x • g) = c ∧ d₂ • g + m₂ • (x • g) = c
  let dlogWin : F × (G × F × F × F × F) → Prop := fun
    | (x, (c, m₁, d₁, m₂, d₂)) =>
        (if decide (m₁ ≠ m₂ ∧ d₁ • g + m₁ • (x • g) = c ∧ d₂ • g + m₂ • (x • g) = c) then
          (d₁ - d₂) / (m₂ - m₁)
        else 0) = x
  have hbinding :
      Pr[= true | (pedersenCommit g).bindingExp binder] = Pr[ bindingWin | base] := by
    rw [show (pedersenCommit g).bindingExp binder = (fun z => decide (bindingWin z)) <$> base by
      simp [CommitmentScheme.bindingExp, pedersenCommit, base, bindingWin, Bool.and_assoc]]
    grind
  have hdlog :
      Pr[= true | dlogExp g (pedersenCommit.dlogReduction binder)] = Pr[ dlogWin | base] := by
    rw [show dlogExp g (pedersenCommit.dlogReduction binder) =
        (fun z => decide (dlogWin z)) <$> base by
      simp [DiffieHellman.dlogExp, pedersenCommit.dlogReduction, base, dlogWin]]
    grind
  rw [hbinding, hdlog]
  exact OracleComp.ProgramLogic.probEvent_mono base (fun z hwin => by
    rcases z with ⟨x, ⟨c, m₁, d₁, m₂, d₂⟩⟩
    simpa [bindingWin, dlogWin] using bindingWin_implies_dlogWin g hg hwin)

end Reduction

end PedersenExercises.Exercise04
