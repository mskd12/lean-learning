import AeneasOtp.Code.Funs
import Examples.OneTimePad.Basic

/-!
# Aeneas ↔ VCVio OTP bridge

`oneTimePad 8` is the cryptographic model. The exercises below prove, using
Aeneas's weakest-precondition notation, that the Rust functions implement its
encryption and decryption operations.
-/

namespace AeneasOtpBridge

open OracleComp
open scoped Aeneas

/-! ## Exercise: connect the Rust functions directly to VCVio's OTP

Because `⦃ output => postcondition ⦄` uses Aeneas's `WP.spec`, each theorem
asserts successful termination (`Result.ok`) and says that the Rust output is
exactly the output of `oneTimePad 8`.
-/

@[step]
theorem encrypt_matches_oneTimePad (key message : Aeneas.Std.U8) :
    AeneasOtp.encrypt key message
      ⦃ ciphertext =>
        (oneTimePad 8).encrypt key.bv message.bv =
          (return ciphertext.bv : ProbComp (BitVec 8)) ⦄ := by
  rfl

@[step]
theorem decrypt_matches_oneTimePad (key ciphertext : Aeneas.Std.U8) :
    AeneasOtp.decrypt key ciphertext
      ⦃ message =>
        (oneTimePad 8).decrypt key.bv ciphertext.bv =
          (return some message.bv : ProbComp (Option (BitVec 8))) ⦄ := by
  rfl

/-!
After this exercise, the cryptographic results to reuse are:

* `oneTimePad.complete 8`
* `oneTimePad.perfectSecrecy 8`

The bridge lemmas establish that the Rust code implements that model; VCVio's
lemmas establish correctness and perfect secrecy of the model.
-/

end AeneasOtpBridge
