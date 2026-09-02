import Aeneas

/- Ristretto arithmetic is the deliberate external boundary of this first port.
   We model its scalar type as a field and its point type as a module over that
   field. The generated Rust code below is then verified relative to these laws. -/

@[rust_type "fastcrypto::groups::ristretto255::RistrettoScalar"]
axiom fastcrypto.groups.ristretto255.RistrettoScalar : Type

@[rust_type "fastcrypto::groups::ristretto255::RistrettoPoint"]
axiom fastcrypto.groups.ristretto255.RistrettoPoint : Type

axiom fastcrypto.groups.ristretto255.RistrettoScalar.field :
  Field fastcrypto.groups.ristretto255.RistrettoScalar

noncomputable instance : Field fastcrypto.groups.ristretto255.RistrettoScalar :=
  fastcrypto.groups.ristretto255.RistrettoScalar.field

axiom fastcrypto.groups.ristretto255.RistrettoPoint.addCommGroup :
  AddCommGroup fastcrypto.groups.ristretto255.RistrettoPoint

noncomputable instance : AddCommGroup fastcrypto.groups.ristretto255.RistrettoPoint :=
  fastcrypto.groups.ristretto255.RistrettoPoint.addCommGroup

axiom fastcrypto.groups.ristretto255.RistrettoPoint.module :
  Module fastcrypto.groups.ristretto255.RistrettoScalar
    fastcrypto.groups.ristretto255.RistrettoPoint

noncomputable instance :
    Module fastcrypto.groups.ristretto255.RistrettoScalar
      fastcrypto.groups.ristretto255.RistrettoPoint :=
  fastcrypto.groups.ristretto255.RistrettoPoint.module

axiom fastcrypto.groups.ristretto255.RistrettoPoint.generator :
  fastcrypto.groups.ristretto255.RistrettoPoint
