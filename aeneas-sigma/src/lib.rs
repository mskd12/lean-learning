//! Verification entry points for fastcrypto's discrete-log Sigma protocol.
//!
//! The implementation is the local `fastcrypto-tbls` dependency. Charon extracts
//! `fastcrypto_tbls::nizk`, including the explicit-challenge operations introduced
//! for this project. Fiat-Shamir is intentionally not part of this first port.

use fastcrypto::groups::ristretto255::{RistrettoPoint, RistrettoScalar};
use fastcrypto_tbls::nizk::dl_sigma;

/// Compute the prover's first message A = rG.
pub fn commit(nonce: &RistrettoScalar) -> RistrettoPoint {
    dl_sigma::commit::<RistrettoPoint>(nonce)
}

/// Compute the prover's response z = r + cx.
pub fn respond(
    witness: &RistrettoScalar,
    nonce: &RistrettoScalar,
    challenge: &RistrettoScalar,
) -> RistrettoScalar {
    dl_sigma::respond::<RistrettoPoint>(witness, nonce, challenge)
}

/// Check the verifier equation zG = A + cX.
pub fn verify(
    public_key: &RistrettoPoint,
    commitment: &RistrettoPoint,
    challenge: &RistrettoScalar,
    response: &RistrettoScalar,
) -> bool {
    dl_sigma::verify::<RistrettoPoint>(public_key, commitment, challenge, response)
}
