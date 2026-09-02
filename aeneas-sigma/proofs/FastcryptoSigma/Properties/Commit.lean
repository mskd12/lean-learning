import FastcryptoSigma.Spec.Defs

open Aeneas

namespace FastcryptoSigma

/-- **Spec theorem for `fastcrypto_tbls::nizk::dl_sigma::commit`**
The extracted Rust commitment equals the deterministic Sigma commitment `r • G`. -/
@[step]
theorem fastcrypto_tbls.nizk.dl_sigma.commitRistrettoPoint.spec
    (nonce : Spec.𝔽) :
    fastcrypto_tbls.nizk.dl_sigma.commitRistrettoPoint nonce
      ⦃ (result : Spec.𝔾) =>
        result = Spec.commit nonce ⦄ := by
  simp [fastcrypto_tbls.nizk.dl_sigma.commitRistrettoPoint,
    fastcrypto.groups.ristretto255.RistrettoPoint.Insts.FastcryptoGroupsGroupElement.generator,
    fastcrypto.groups.ristretto255.RistrettoPoint.Insts.CoreOpsArithMulSharedRistrettoScalar.mul,
    Spec.commit, Spec.G]

end FastcryptoSigma
