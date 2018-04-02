#ifndef BAN_INTERFACE_H
#define BAN_INTERFACE_H

#if __cplusplus
extern "C" {
#endif

typedef unsigned char * blt_uint256; // 32byte array for public and private keys
typedef unsigned char * blt_uint512; // 64byte array for signatures
typedef void * blt_transaction;

// Convert public/private key bytes 'source' to a 64 byte not-null-terminated hex string 'destination'
void blt_uint256_to_string (const blt_uint256 source, char * destination);
// Convert public key bytes 'source' to a 65 byte non-null-terminated account string 'destination'
void blt_uint256_to_address (blt_uint256 source, char * destination);
// Convert public/private key bytes 'source' to a 128 byte not-null-terminated hex string 'destination'
void blt_uint512_to_string (const blt_uint512 source, char * destination);

// Convert 64 byte hex string 'source' to a byte array 'destination'
// Return 0 on success, nonzero on error
int blt_uint256_from_string (const char * source, blt_uint256 destination);
// Convert 128 byte hex string 'source' to a byte array 'destination'
// Return 0 on success, nonzero on error
int blt_uint512_from_string (const char * source, blt_uint512 destination);

// Check if the null-terminated string 'account' is a valid bolt account number
// Return 0 on correct, nonzero on invalid
int blt_valid_address (const char * account);

// Create a new random number in to 'destination'
void blt_generate_random (blt_uint256 destination);
// Retrieve the deterministic private key for 'seed' at 'index'
void blt_seed_key (const blt_uint256 seed, int index, blt_uint256);
// Derive the public key 'pub' from 'key'
void blt_key_account (blt_uint256 key, blt_uint256 pub);

// Sign 'transaction' using 'private_key' and write to 'signature'
char * blt_sign_transaction (const char * transaction, const blt_uint256 private_key);
// Generate work for 'transaction'
char * blt_work_transaction (const char * transaction);

#if __cplusplus
} // extern "C"
#endif

#endif // BAN_INTERFACE_H
