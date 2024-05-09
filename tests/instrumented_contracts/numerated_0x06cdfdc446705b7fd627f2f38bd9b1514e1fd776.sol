1 pragma solidity ^0.4.24;
2 
3 contract VerificationStorage {
4     event Verification(bytes ipfsHash);
5 
6     function verify(bytes _ipfsHash) public {
7         emit Verification(_ipfsHash);
8     }
9 }