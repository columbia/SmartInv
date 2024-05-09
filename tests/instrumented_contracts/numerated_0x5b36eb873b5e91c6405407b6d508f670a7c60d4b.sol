1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Datatrust Anchoring system
5  * @author Blockchain Partner
6  * @author https://blockchainpartner.fr
7  */
8 contract Datatrust {
9 
10     // Event emitted when saving a new anchor
11     event NewAnchor(bytes32 merkleRoot);
12 
13     /**
14      * @dev Save a new anchor for a given Merkle tree root hash
15      * @dev Use events as a form of storage
16      * @param _merkleRoot bytes32 hash to anchor
17      */
18     function saveNewAnchor(bytes32 _merkleRoot) public {
19         emit NewAnchor(_merkleRoot);
20     }
21 }