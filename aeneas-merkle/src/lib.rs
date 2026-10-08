//! Small verification entry points into fastcrypto's Merkle implementation.
//!
//! The implementation remains in the local `fastcrypto` dependency. Charon is
//! invoked with `--include fastcrypto::merkle`, so the bodies in that module are
//! extracted rather than treated as opaque external calls.

use fastcrypto::{
    hash::HashFunction,
    merkle::{MerkleTree, Node},
};

/// Build a tree from byte strings and return its root.
pub fn build_root<T: HashFunction<32>>(leaves: &[Vec<u8>]) -> Node {
    MerkleTree::<T>::build_from_serialized_slice(leaves).root()
}

/// Generate and immediately verify the inclusion proof at `index`.
///
/// An invalid index returns `false` rather than panicking. Our first functional
/// correctness theorem will say that this returns `true` whenever the index is
/// in bounds.
pub fn inclusion_roundtrip<T: HashFunction<32>>(leaves: &[Vec<u8>], index: usize) -> bool {
    let Some(leaf) = leaves.get(index) else {
        return false;
    };

    let tree = MerkleTree::<T>::build_from_serialized_slice(leaves);
    let Ok(proof) = tree.get_proof(index) else {
        return false;
    };

    proof.verify_proof(&tree.root(), leaf, index).is_ok()
}
