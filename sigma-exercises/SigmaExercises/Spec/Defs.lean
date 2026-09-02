import Mathlib.Algebra.Module.Basic

/-!
# Sigma protocol specification and notation

This module is the single reference for the deterministic Schnorr Sigma
protocol used throughout the exercises.

## Notation

| Symbol | Lean input | Type | Meaning |
| --- | --- | --- | --- |
| `𝔽` | `\bbF` | `Type` | Scalar field |
| `𝔾` | `\bbG` | `Type` | Additive group of points |
| `G` | `G : 𝔾` | group element | Public generator or base point |
| `x` | `x : 𝔽` | scalar | Secret witness |
| `X` | `X : 𝔾` | group element | Public statement, with `X = x • G` |
| `r` | `r : 𝔽` | scalar | Fresh prover nonce |
| `R` | `R : 𝔾` | group element | Commitment, with `R = r • G` |
| `c` | `c : 𝔽` | scalar | Verifier challenge |
| `z` | `z : 𝔽` | scalar | Response, with `z = r + c * x` |

Group elements are always uppercase; scalars are lowercase. In VCVio, `X`
and `x` are often called `pk` and `sk`. Fastcrypto calls `X` `x_g` and calls
the commitment `R` `A`.

## Interactive protocol

```text
Prover (knows x)                         Verifier (knows G, X)

choose r : 𝔽
R := r • G              -------------------------->

                        <--------------------------  choose c : 𝔽

z := r + c * x          -------------------------->

                                      check z • G = R + c • X
```

The public claim is knowledge of an `x` satisfying `x • G = X`. The complete
transcript is `(R, c, z)`.
-/

namespace SigmaExercises.Spec

variable {𝔽 𝔾 : Type} [Field 𝔽] [AddCommGroup 𝔾] [Module 𝔽 𝔾]

/-- The relation between the public statement `X` and its witness `x`. -/
def witnessRelation (G X : 𝔾) (x : 𝔽) : Prop :=
  x • G = X

/-- Compute the prover's commitment from its nonce. -/
def commit (G : 𝔾) (r : 𝔽) : 𝔾 :=
  r • G

/-- Compute the prover's response to a challenge. -/
def respond (x r c : 𝔽) : 𝔽 :=
  r + c * x

/-- The verifier's acceptance equation. -/
def verify (G X R : 𝔾) (c z : 𝔽) : Prop :=
  z • G = R + c • X

/-- A complete interactive transcript `(R, c, z)`. -/
structure Transcript (𝔽 𝔾 : Type) where
  commitment : 𝔾
  challenge : 𝔽
  response : 𝔽

/-- Whether a complete transcript is accepted for the statement `(G, X)`. -/
def Transcript.accepts (G X : 𝔾) (t : Transcript 𝔽 𝔾) : Prop :=
  verify G X t.commitment t.challenge t.response

/-- Recover a candidate witness from responses to two different challenges. -/
def extractWitness (c₁ c₂ z₁ z₂ : 𝔽) : 𝔽 :=
  (z₁ - z₂) / (c₁ - c₂)

/-- Compute a commitment backwards from a desired challenge and response. -/
def simulatedCommitment (G X : 𝔾) (c z : 𝔽) : 𝔾 :=
  z • G - c • X

end SigmaExercises.Spec
