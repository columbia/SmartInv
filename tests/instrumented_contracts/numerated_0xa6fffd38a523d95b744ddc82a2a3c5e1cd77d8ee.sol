1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-10
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-only
6 
7 pragma solidity 0.8.9;
8 
9 /**
10  * @dev Required interface of an ERC721 compliant contract.
11  */
12 interface IVoterID {
13     /**
14         Minting function
15     */
16     function createIdentityFor(address newId, uint tokenId, string memory uri) external;
17 
18     /**
19         Who's in charge around here
20     */
21     function owner() external view returns (address);
22 
23     /**
24         How many of these things exist?
25     */
26     function totalSupply() external view returns (uint);
27 }
28 
29 interface IPriceGate {
30 
31     function getCost(uint) external view returns (uint ethCost);
32 
33     function passThruGate(uint, address) external payable;
34 }
35 
36 
37 interface IEligibility {
38     
39     function isEligible(uint, address, bytes32[] memory) external view returns (bool eligible);
40 
41     function passThruGate(uint, address, bytes32[] memory) external;
42 }
43 
44 
45 library MerkleLib {
46 
47     function verifyProof(bytes32 root, bytes32 leaf, bytes32[] memory proof) public pure returns (bool) {
48         bytes32 currentHash = leaf;
49 
50         for (uint i = 0; i < proof.length; i += 1) {
51             currentHash = parentHash(currentHash, proof[i]);
52         }
53 
54         return currentHash == root;
55     }
56 
57     function parentHash(bytes32 a, bytes32 b) public pure returns (bytes32) {
58         if (a < b) {
59             return keccak256(abi.encode(a, b));
60         } else {
61             return keccak256(abi.encode(b, a));
62         }
63     }
64 
65 }
66 
67 
68 contract MerkleIdentity {
69     using MerkleLib for bytes32;
70 
71     struct MerkleTree {
72         bytes32 metadataMerkleRoot;
73         bytes32 ipfsHash;
74         address nftAddress;
75         address priceGateAddress;
76         address eligibilityAddress;
77         uint eligibilityIndex; // enables re-use of eligibility contracts
78         uint priceIndex; // enables re-use of price gate contracts
79     }
80 
81     mapping (uint => MerkleTree) public merkleTrees;
82     uint public numTrees;
83 
84     address public management;
85     address public treeAdder;
86 
87     event MerkleTreeAdded(uint indexed index, address indexed nftAddress);
88 
89     modifier managementOnly() {
90         require (msg.sender == management, 'Only management may call this');
91         _;
92     }
93 
94     constructor(address _mgmt) {
95         management = _mgmt;
96         treeAdder = _mgmt;
97     }
98 
99     // change the management key
100     function setManagement(address newMgmt) external managementOnly {
101         management = newMgmt;
102     }
103 
104     function setTreeAdder(address newAdder) external managementOnly {
105         treeAdder = newAdder;
106     }
107 
108     function setIpfsHash(uint merkleIndex, bytes32 hash) external managementOnly {
109         MerkleTree storage tree = merkleTrees[merkleIndex];
110         tree.ipfsHash = hash;
111     }
112 
113     function addMerkleTree(bytes32 metadataMerkleRoot, bytes32 ipfsHash, address nftAddress, address priceGateAddress, address eligibilityAddress, uint eligibilityIndex, uint priceIndex) external {
114         require(msg.sender == treeAdder, 'Only treeAdder can add trees');
115         MerkleTree storage tree = merkleTrees[++numTrees];
116         tree.metadataMerkleRoot = metadataMerkleRoot;
117         tree.ipfsHash = ipfsHash;
118         tree.nftAddress = nftAddress;
119         tree.priceGateAddress = priceGateAddress;
120         tree.eligibilityAddress = eligibilityAddress;
121         tree.eligibilityIndex = eligibilityIndex;
122         tree.priceIndex = priceIndex;
123         emit MerkleTreeAdded(numTrees, nftAddress);
124     }
125 
126     function withdraw(uint merkleIndex, uint tokenId, string memory uri, bytes32[] memory addressProof, bytes32[] memory metadataProof) external payable {
127         MerkleTree storage tree = merkleTrees[merkleIndex];
128         IVoterID id = IVoterID(tree.nftAddress);
129 
130         // mint an identity first, this keeps the token-collision gas cost down
131         id.createIdentityFor(msg.sender, tokenId, uri);
132 
133         // check that the merkle index is real
134         require(merkleIndex <= numTrees, 'merkleIndex out of range');
135 
136         // verify that the metadata is real
137         require(verifyMetadata(tree.metadataMerkleRoot, tokenId, uri, metadataProof), "The metadata proof could not be verified");
138 
139         // check eligibility of address
140         IEligibility(tree.eligibilityAddress).passThruGate(tree.eligibilityIndex, msg.sender, addressProof);
141 
142         // check that the price is right
143         IPriceGate(tree.priceGateAddress).passThruGate{value: msg.value}(tree.priceIndex, msg.sender);
144 
145     }
146 
147     function getPrice(uint merkleIndex) public view returns (uint) {
148         MerkleTree memory tree = merkleTrees[merkleIndex];
149         uint ethCost = IPriceGate(tree.priceGateAddress).getCost(tree.priceIndex);
150         return ethCost;
151     }
152 
153     function isEligible(uint merkleIndex, address recipient, bytes32[] memory proof) public view returns (bool) {
154         MerkleTree memory tree = merkleTrees[merkleIndex];
155         return IEligibility(tree.eligibilityAddress).isEligible(tree.eligibilityIndex, recipient, proof);
156     }
157 
158     function verifyMetadata(bytes32 root, uint tokenId, string memory uri, bytes32[] memory proof) public pure returns (bool) {
159         bytes32 leaf = keccak256(abi.encode(tokenId, uri));
160         return root.verifyProof(leaf, proof);
161     }
162 
163 }