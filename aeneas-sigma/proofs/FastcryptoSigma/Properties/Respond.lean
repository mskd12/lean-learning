import FastcryptoSigma.Spec.Defs

open Aeneas

namespace FastcryptoSigma

/-- **Spec theorem for `fastcrypto_tbls::nizk::dl_sigma::respond`**
The extracted Rust response equals the deterministic Sigma response `r + c * x`. -/
@[step]
theorem fastcrypto_tbls.nizk.dl_sigma.respondRistrettoPoint.spec
    (witness nonce challenge : Spec.𝔽) :
    fastcrypto_tbls.nizk.dl_sigma.respondRistrettoPoint witness nonce challenge
      ⦃ (result : Spec.𝔽) =>
        result = Spec.respond witness nonce challenge ⦄ := by
  simp [fastcrypto_tbls.nizk.dl_sigma.respondRistrettoPoint,
    fastcrypto.groups.ristretto255.RistrettoScalar.Insts.CoreOpsArithMulSharedRistrettoScalar.mul,
    fastcrypto.groups.ristretto255.RistrettoScalar.Insts.CoreOpsArithAddRistrettoScalar.add,
    Spec.respond, add_comm]

end FastcryptoSigma
