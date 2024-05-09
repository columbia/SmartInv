1 pragma solidity ^0.4.23;
2 
3 /// @title SecretRegistry
4 /// @notice SecretRegistry contract for registering secrets from Raiden Network
5 /// clients.
6 contract SecretRegistry {
7 
8     string constant public contract_version = "0.4.0";
9 
10     // keccak256(secret) => block number at which the secret was revealed
11     mapping(bytes32 => uint256) private secrethash_to_block;
12 
13     event SecretRevealed(bytes32 indexed secrethash, bytes32 secret);
14 
15     /// @notice Registers a hash time lock secret and saves the block number.
16     /// This allows the lock to be unlocked after the expiration block.
17     /// @param secret The secret used to lock the hash time lock.
18     /// @return true if secret was registered, false if the secret was already
19     /// registered.
20     function registerSecret(bytes32 secret) public returns (bool) {
21         bytes32 secrethash = keccak256(abi.encodePacked(secret));
22         if (secret == bytes32(0x0) || secrethash_to_block[secrethash] > 0) {
23             return false;
24         }
25         secrethash_to_block[secrethash] = block.number;
26         emit SecretRevealed(secrethash, secret);
27         return true;
28     }
29 
30     /// @notice Registers multiple hash time lock secrets and saves the block
31     /// number.
32     /// @param secrets The array of secrets to be registered.
33     /// @return true if all secrets could be registered, false otherwise.
34     function registerSecretBatch(bytes32[] secrets) public returns (bool) {
35         bool completeSuccess = true;
36         for(uint i = 0; i < secrets.length; i++) {
37             if(!registerSecret(secrets[i])) {
38                 completeSuccess = false;
39             }
40         }
41         return completeSuccess;
42     }
43 
44     /// @notice Get the stored block number at which the secret was revealed.
45     /// @param secrethash The hash of the registered secret `keccak256(secret)`.
46     /// @return The block number at which the secret was revealed.
47     function getSecretRevealBlockHeight(bytes32 secrethash) public view returns (uint256) {
48         return secrethash_to_block[secrethash];
49     }
50 }
