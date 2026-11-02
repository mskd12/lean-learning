//! This crate gives Charon entry points into the Shamir code in `fastcrypto_tbls::polynomial`.
//!
//! Why it exists:
//! - We want to measure how much `polynomial.rs` must change before Aeneas accepts it.
//! - The entry points are the functions in the Shamir "contracts" of the fastcrypto-specs project.
//!
//! How it works:
//! - `generic` calls the functions on `Poly<C>` for any `C: GroupElement`.
//!   Charon translates it without monomorphization.
//! - `ristretto` calls the same functions on `Poly<RistrettoScalar>`.
//!   Charon translates it with `--monomorphize`, as in `aeneas-sigma`.
//! - `scripts/translate.sh` selects one module.

use fastcrypto::error::FastCryptoResult;
use fastcrypto::groups::GroupElement;
use fastcrypto_tbls::polynomial::{Eval, Poly};
use fastcrypto_tbls::types::ShareIndex;

/// Entry points for any coefficient type `C`.
pub mod generic {
    use super::*;

    /// Evaluate `p` at index `i`.
    pub fn eval<C: GroupElement>(p: &Poly<C>, i: ShareIndex) -> Eval<C> {
        p.eval(i)
    }

    /// Add two polynomials.
    pub fn add<C: GroupElement>(mut p: Poly<C>, q: &Poly<C>) -> Poly<C> {
        p.add_in_place(q);
        p
    }

    /// Return the constant term of `p`.
    pub fn c0<C: GroupElement>(p: &Poly<C>) -> C {
        p.c0()
    }

    /// Return the degree bound of `p`.
    pub fn degree_bound<C: GroupElement>(p: &Poly<C>) -> usize {
        p.degree_bound()
    }

    /// Recover the constant term from exactly `t` shares.
    pub fn recover_c0<C: GroupElement>(t: u16, shares: &[Eval<C>]) -> FastCryptoResult<C> {
        Poly::<C>::recover_c0_from_slice(t, shares)
    }
}

/// Entry points for coefficients in the Ristretto scalar field.
pub mod ristretto {
    use super::*;
    use fastcrypto::groups::ristretto255::RistrettoScalar;

    /// Evaluate `p` at index `i`.
    pub fn eval(p: &Poly<RistrettoScalar>, i: ShareIndex) -> Eval<RistrettoScalar> {
        generic::eval(p, i)
    }

    /// Add two polynomials.
    pub fn add(p: Poly<RistrettoScalar>, q: &Poly<RistrettoScalar>) -> Poly<RistrettoScalar> {
        generic::add(p, q)
    }

    /// Return the constant term of `p`.
    pub fn c0(p: &Poly<RistrettoScalar>) -> RistrettoScalar {
        generic::c0(p)
    }

    /// Return the degree bound of `p`.
    pub fn degree_bound(p: &Poly<RistrettoScalar>) -> usize {
        generic::degree_bound(p)
    }

    /// Recover the constant term from exactly `t` shares.
    pub fn recover_c0(
        t: u16,
        shares: &[Eval<RistrettoScalar>],
    ) -> FastCryptoResult<RistrettoScalar> {
        generic::recover_c0(t, shares)
    }
}
