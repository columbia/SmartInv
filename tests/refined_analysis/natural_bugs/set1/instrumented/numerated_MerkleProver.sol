1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.3;
4 
5 import "@openzeppelin/contracts/cryptography/MerkleProof.sol";
6 
7 contract MerkleProver {
8     bytes32 public immutable merkleRoot = bytes32(0xf4dbd0fb1957570029a847490cb3d731a45962072953ba7da80ff132ccd97d51);
9 
10     function isWhitelisted(
11         uint256 index,
12         address account,
13         uint256 amount,
14         bytes32[] calldata merkleProof
15     ) public view returns (bool) {
16         // Verify the merkle proof.
17         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
18         return MerkleProof.verify(merkleProof, merkleRoot, node);
19     }
20 }
