import Lake
open Lake DSL

require aeneas from git
  "https://github.com/AeneasVerif/aeneas.git" @ "74a460a2f80ecea481bbdf1a08f881633c3bb097" / "backends/lean"
require VCVio from git
  "https://github.com/Verified-zkEVM/VCVio.git" @ "cbd4144b51d92da00dd50f05e068b2348fa6e529"

package «aeneas-otp-proofs» {}

@[default_target]
lean_lib «AeneasOtp» {}

@[default_target]
lean_lib «AeneasOtpBridge» {}
