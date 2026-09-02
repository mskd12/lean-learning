import FastcryptoSigma.Spec.Defs

open Aeneas

namespace FastcryptoSigma

/-- **Spec theorem for `fastcrypto_tbls::nizk::dl_sigma::verify`**
The extracted Rust verifier returns the decision of the Sigma verification equation. -/
@[step]
theorem fastcrypto_tbls.nizk.dl_sigma.verifyRistrettoPoint.spec
    (public_key commitment : Spec.𝔾) (challenge response : Spec.𝔽) :
    fastcrypto_tbls.nizk.dl_sigma.verifyRistrettoPoint
        public_key commitment challenge response
      ⦃ (result : Bool) =>
        result = true ↔ Spec.verify public_key commitment challenge response ⦄ := by
  simp [fastcrypto_tbls.nizk.dl_sigma.verifyRistrettoPoint,
    fastcrypto_tbls.nizk.is_valid_relationRistrettoPoint,
    fastcrypto.groups.ristretto255.RistrettoPoint.Insts.FastcryptoGroupsGroupElement.generator,
    fastcrypto.groups.ristretto255.RistrettoPoint.Insts.CoreOpsArithMulSharedRistrettoScalar.mul,
    fastcrypto.groups.ristretto255.RistrettoPoint.Insts.CoreOpsArithAddRistrettoPoint.add,
    fastcrypto.groups.ristretto255.RistrettoPoint.Insts.CoreCmpPartialEqRistrettoPoint.eq,
    Spec.verify, Spec.G, eq_comm]

end FastcryptoSigma
