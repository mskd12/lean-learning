#![no_std]

/// Encrypt one byte with a one-time-pad key.
pub fn encrypt(key: u8, message: u8) -> u8 {
    key ^ message
}

/// Decrypt one byte with the same one-time-pad key.
pub fn decrypt(key: u8, ciphertext: u8) -> u8 {
    key ^ ciphertext
}

#[cfg(test)]
mod tests {
    use super::{decrypt, encrypt};

    #[test]
    fn round_trip() {
        let key = 0b1010_1100;
        let message = 0b0110_1001;
        assert_eq!(decrypt(key, encrypt(key, message)), message);
    }
}
