import Lake

open Lake DSL

package sigmaExercises where
  packagesDir := "../tools/VCVio-v4.31.0/.lake/packages"

require VCVio from "../tools/VCVio-v4.31.0"

@[default_target]
lean_lib SigmaExercises
