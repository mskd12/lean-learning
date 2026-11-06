import Lake

open Lake DSL

package pedersenExercises {}

require VCVio from git
  "https://github.com/Verified-zkEVM/VCVio.git" @ "cbd4144b51d92da00dd50f05e068b2348fa6e529"

@[default_target]
lean_lib PedersenExercises
