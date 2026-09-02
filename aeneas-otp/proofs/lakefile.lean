import Lake
open Lake DSL

require aeneas from "../../tools/aeneas/backends/lean"
require VCVio from "../../tools/VCVio-v4.31.0"

package «aeneas-otp-proofs» {}

@[default_target]
lean_lib «AeneasOtp» {}

@[default_target]
lean_lib «AeneasOtpBridge» {}
