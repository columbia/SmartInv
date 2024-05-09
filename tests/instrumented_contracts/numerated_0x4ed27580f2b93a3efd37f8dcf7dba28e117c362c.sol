1 // Built by @ragonzal - 2020
2 // SPDX-License-Identifier: MIT
3 pragma solidity ^0.6.12;
4 
5 interface Poap {
6     function mintToken(uint256 eventId, address to) external returns (bool);
7 }
8 
9 contract PoapAirdrop {
10 
11     string public name;
12 
13     // POAP Contract - Only Mint Token function
14     Poap POAPToken;
15 
16     // Processed claims
17     mapping(address => bool) public claimed;
18 
19     // Merkle tree root hash
20     bytes32 public rootHash;
21 
22     /**
23      * @dev Contract constructor
24      * @param contractName Contract name
25      * @param contractAddress Address of the POAP contract
26      * @param merkleTreeRootHash Processed merkle tree root hash
27      */
28     constructor (string memory contractName, address contractAddress, bytes32 merkleTreeRootHash) public {
29         name = contractName;
30         POAPToken = Poap(contractAddress);
31         rootHash = merkleTreeRootHash;
32     }
33 
34     /**
35      * @dev Function to verify merkle tree proofs and mint POAPs to the recipient
36      * @param index Leaf position in the merkle tree
37      * @param recipient Recipient address of the POAPs to be minted
38      * @param events Array of event ids to be minted
39      * @param proofs Array of proofs to verify the claim
40      */
41     function claim(uint256 index, address recipient, uint256[] calldata events, bytes32[] calldata proofs) external {
42         require(claimed[recipient] == false, "Recipient already processed!");
43         require(verify(index, recipient, events, proofs), "Recipient not in merkle tree!");
44 
45         claimed[recipient] = true;
46 
47         require(mintTokens(recipient, events), "Could not mint POAPs");
48     }
49 
50     /**
51      * @dev Function to verify merkle tree proofs
52      * @param index Leaf position in the merkle tree
53      * @param recipient Recipient address of the POAPs to be minted
54      * @param events Array of event ids to be minted
55      * @param proofs Array of proofs to verify the claim
56      */
57     function verify(uint256 index, address recipient, uint256[] memory events, bytes32[] memory proofs) public view returns (bool) {
58 
59         // Compute the merkle root
60         bytes32 node = keccak256(abi.encodePacked(index, recipient, events));
61         for (uint16 i = 0; i < proofs.length; i++) {
62             bytes32 proofElement = proofs[i];
63             if (proofElement < node) {
64                 node = keccak256(abi.encodePacked(proofElement, node));
65             } else {
66                 node = keccak256(abi.encodePacked(node, proofElement));
67             }
68         }
69 
70         // Check the merkle proof
71         return node == rootHash;
72     }
73 
74     /**
75      * @dev Function to mint POAPs
76      * @param recipient Recipient address of the POAPs to be minted
77      * @param events Array of event ids to be minted
78      */
79     function mintTokens(address recipient, uint256[] memory events) internal returns (bool) {
80         for (uint256 i = 0; i < events.length; i++) {
81             POAPToken.mintToken(events[i], recipient);
82         }
83         return true;
84     }
85 
86 }