//! This crate gives Charon entry points into the Shamir code in `fastcrypto_tbls::polynomial`.
//!
//! Why it exists:
//! - We want to measure how much `polynomial.rs` must change before Aeneas accepts it.
//! - The entry points are the functions in the Shamir "contracts" of the fastcrypto-specs project.
//!
//! How it works:
//! - Each function calls fastcrypto on `Poly<RistrettoScalar>`.
//! - Charon translates them with `--monomorphize`, as in `aeneas-sigma`.
//!
//! Assumptions:
//! - Aeneas cannot translate the generic `Poly<C>` code. The cyclic bound
//!   `Scalar: GroupElement<ScalarType = Self>` crashes it.

use fastcrypto::error::FastCryptoResult;
use fastcrypto::groups::ristretto255::RistrettoScalar;
use fastcrypto_tbls::polynomial::{Eval, Poly};
use fastcrypto_tbls::types::ShareIndex;

/// Evaluate `p` at index `i`.
pub fn eval(p: &Poly<RistrettoScalar>, i: ShareIndex) -> Eval<RistrettoScalar> {
    p.eval(i)
}

/// Add two polynomials.
pub fn add(mut p: Poly<RistrettoScalar>, q: &Poly<RistrettoScalar>) -> Poly<RistrettoScalar> {
    p.add_in_place(q);
    p
}

/// Return the constant term of `p`.
pub fn c0(p: &Poly<RistrettoScalar>) -> RistrettoScalar {
    p.c0()
}

/// Return the degree bound of `p`.
pub fn degree_bound(p: &Poly<RistrettoScalar>) -> usize {
    p.degree_bound()
}

/// Recover the constant term from exactly `t` shares.
pub fn recover_c0(t: u16, shares: &[Eval<RistrettoScalar>]) -> FastCryptoResult<RistrettoScalar> {
    Poly::<RistrettoScalar>::recover_c0_from_slice(t, shares)
}
