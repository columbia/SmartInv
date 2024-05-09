1 pragma solidity ^0.5.8;
2 contract ProofOfExistence {
3     event Attestation(bytes32 indexed hash);
4     function attest(bytes32 hash) public {
5         emit Attestation(hash);
6     }
7 }