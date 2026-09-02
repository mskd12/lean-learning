import FastcryptoSigma.Code.Funs

namespace FastcryptoSigma.Spec

noncomputable section

abbrev 𝔽 := fastcrypto.groups.ristretto255.RistrettoScalar
abbrev 𝔾 := fastcrypto.groups.ristretto255.RistrettoPoint

def G : 𝔾 := fastcrypto.groups.ristretto255.RistrettoPoint.generator

def commit (r : 𝔽) : 𝔾 := r • G

def respond (x r c : 𝔽) : 𝔽 := r + c * x

def verify (X R : 𝔾) (c z : 𝔽) : Prop :=
  z • G = R + c • X

def witnessRelation (X : 𝔾) (x : 𝔽) : Prop :=
  x • G = X

end

end FastcryptoSigma.Spec
