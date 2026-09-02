import FastcryptoSigma.Spec.Defs
import Examples.Schnorr.SigmaProtocol

open OracleSpec OracleComp SigmaProtocol

namespace FastcryptoSigma.VCVioBridge

noncomputable section

/- VCVio's protocol samples uniformly from these types. Finiteness is kept as
   an explicit bridge assumption because the Aeneas model treats both Rust
   Ristretto types abstractly. -/
axiom scalarFinite : Finite Spec.𝔽
axiom pointFinite : Finite Spec.𝔾

local instance : Finite Spec.𝔽 := scalarFinite
local instance : Finite Spec.𝔾 := pointFinite
local instance : Fintype Spec.𝔽 := Fintype.ofFinite Spec.𝔽
local instance : Fintype Spec.𝔾 := Fintype.ofFinite Spec.𝔾
local instance : DecidableEq Spec.𝔽 := Classical.decEq Spec.𝔽
local instance : DecidableEq Spec.𝔾 := Classical.decEq Spec.𝔾
local instance : SampleableType Spec.𝔽 := SampleableType.ofFintype Spec.𝔽
local instance : SampleableType Spec.𝔾 := SampleableType.ofFintype Spec.𝔾

/-- The Boolean form of our witness relation, as required by `SigmaProtocol`. -/
def relation (X : Spec.𝔾) (x : Spec.𝔽) : Bool :=
  decide (x • Spec.G = X)

/-- Our deterministic equations packaged as VCVio's Schnorr protocol. -/
def protocol : SigmaProtocol Spec.𝔾 Spec.𝔽 Spec.𝔾 Spec.𝔽 Spec.𝔽 Spec.𝔽 relation :=
  Schnorr.sigma Spec.𝔽 Spec.𝔾 Spec.G

/-- VCVio's standard full-transcript simulator for our protocol. -/
def simulator (X : Spec.𝔾) : ProbComp (Spec.𝔾 × Spec.𝔽 × Spec.𝔽) :=
  Schnorr.simTranscript Spec.𝔽 Spec.𝔾 Spec.G X

theorem relation_accepts_iff (X : Spec.𝔾) (x : Spec.𝔽) :
    relation X x = true ↔ Spec.witnessRelation X x := by
  simp [relation, Spec.witnessRelation]

theorem commit_eq (X : Spec.𝔾) (x : Spec.𝔽) :
    protocol.commit X x =
      (do
        let r ← $ᵗ Spec.𝔽
        pure (Spec.commit r, r) : ProbComp (Spec.𝔾 × Spec.𝔽)) := by
  rfl

theorem respond_eq (X : Spec.𝔾) (x r c : Spec.𝔽) :
    protocol.respond X x r c = pure (Spec.respond x r c) := by
  rfl

theorem verify_accepts_iff (X R : Spec.𝔾) (c z : Spec.𝔽) :
    protocol.verify X R c z = true ↔ Spec.verify X R c z := by
  simp [protocol, Schnorr.sigma, Spec.verify]

/-- VCVio's perfect-completeness theorem, specialized to our specification. -/
theorem perfectlyComplete : PerfectlyComplete protocol := by
  exact Schnorr.sigma_complete Spec.𝔽 Spec.𝔾 Spec.G

/-- VCVio's special-soundness theorem, specialized to our specification. -/
theorem speciallySound : SpeciallySound protocol := by
  exact Schnorr.sigma_speciallySound Spec.𝔽 Spec.𝔾 Spec.G

/-- VCVio's perfect honest-verifier zero-knowledge theorem, specialized to our specification. -/
theorem perfectHVZK : PerfectHVZK protocol simulator := by
  exact Schnorr.sigma_hvzk Spec.𝔽 Spec.𝔾 Spec.G

end

end FastcryptoSigma.VCVioBridge
