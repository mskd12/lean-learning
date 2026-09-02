import Aeneas
import FastcryptoSigma.Code.Types

open Aeneas Aeneas.Std Result ControlFlow Error
open FastcryptoSigma

noncomputable section

namespace fastcrypto.groups.ristretto255.RistrettoPoint.Insts

def CoreOpsArithMulSharedRistrettoScalar.mul
    (point : RistrettoPoint) (scalar : RistrettoScalar) :
    Result RistrettoPoint :=
  ok (scalar • point)

noncomputable def CoreCmpPartialEqRistrettoPoint.eq
    (left right : RistrettoPoint) : Result Bool :=
  by
    classical
    exact ok (decide (left = right))

def CoreOpsArithAddRistrettoPoint.add
    (left right : RistrettoPoint) : Result RistrettoPoint :=
  ok (left + right)

def FastcryptoGroupsGroupElement.zero : Result RistrettoPoint :=
  ok 0

def FastcryptoGroupsGroupElement.generator : Result RistrettoPoint :=
  ok RistrettoPoint.generator

end fastcrypto.groups.ristretto255.RistrettoPoint.Insts

namespace fastcrypto.groups.ristretto255.RistrettoScalar.Insts

def CoreOpsArithMulSharedRistrettoScalar.mul
    (left right : RistrettoScalar) : Result RistrettoScalar :=
  ok (left * right)

def CoreOpsArithAddRistrettoScalar.add
    (left right : RistrettoScalar) : Result RistrettoScalar :=
  ok (left + right)

end fastcrypto.groups.ristretto255.RistrettoScalar.Insts
