1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /// ============ Libraries ============
5 
6 /// @notice OpenZeppelin: MerkleProof
7 /// @dev The hashing algorithm should be keccak256 and pair sorting should be enabled.
8 library MerkleProof {
9   /// @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree defined by `root`.
10   function verify(
11     bytes32[] memory proof,
12     bytes32 root,
13     bytes32 leaf
14   ) internal pure returns (bool) {
15     return processProof(proof, leaf) == root;
16   }
17 
18   /// @dev Returns the rebuilt hash obtained by traversing a Merklee tree up from `leaf` using `proof`.
19   function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
20     bytes32 computedHash = leaf;
21     for (uint256 i = 0; i < proof.length; i++) {
22       bytes32 proofElement = proof[i];
23       if (computedHash <= proofElement) {
24         // Hash(current computed hash + current element of the proof)
25         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
26       } else {
27         // Hash(current element of the proof + current computed hash)
28         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
29       }
30     }
31     return computedHash;
32   }
33 }
34 
35 /// ============ Interfaces ============
36 
37 interface IERC721 {
38   /// @notice ERC721 transfer from (from) to (to)
39   function transferFrom(address from, address to, uint256 tokenId) external;
40 }
41 
42 contract SantaSwapExchange {
43 
44   /// ============ Structs ============
45 
46   /// @notice Individual ERC721 NFT details
47   struct SantaNFT {
48     /// @notice NFT contract
49     address nftContract;
50     /// @notice NFT tokenId
51     uint256 tokenId;
52   }
53 
54   /// ============ Immutable storage ============
55 
56   /// @notice Timestamp when reclaim is enabled
57   uint256 immutable public RECLAIM_OPEN;
58 
59   /// ============ Mutable storage ============
60 
61   /// @notice Contract owner
62   address public owner;
63   /// @notice Merkle root of santa => giftee
64   /// @dev keccak256(giftee, santa, santaNFTIndex)
65   bytes32 public merkle;
66   /// @notice Helper to iterate nfts for front-en
67   /// @dev Keeps santaNFTIndex count
68   mapping(address => uint256) public nftCount;
69   /// @notice Address to deposited NFTs
70   mapping(address => SantaNFT[]) public nfts;
71 
72   // ============ Errors ============
73 
74   /// @notice Thrown if caller is not owner
75   error NotOwner();
76   /// @notice Thrown if cannot claim NFT
77   error NotClaimable();
78 
79   /// ============ Constructor ============
80 
81   constructor() {
82     // Update contract owner
83     owner = msg.sender;
84     // Allow reclaiming 7 days after depositing
85     RECLAIM_OPEN = block.timestamp + 604_800;
86   }
87 
88   /// @notice Computes leaf of merkle tree by hashing params
89   /// @param giftee address receiving NFT gift
90   /// @param santa address giving NFT gift
91   /// @param santaIndex index of gift (for multiple tickets)
92   /// @return hash of leaf
93   function _leaf(
94     address giftee, 
95     address santa, 
96     uint256 santaIndex
97   ) internal pure returns (bytes32) {
98     return keccak256(abi.encodePacked(giftee, santa, santaIndex));
99   }
100 
101   /// @notice Verifies that leaf matches provided proof
102   /// @param leaf (computed in contract)
103   /// @param proof (provided externally)
104   /// @return whether santa => giftee matches up
105   function _verify(
106     bytes32 leaf,
107     bytes32[] calldata proof
108   ) internal view returns (bool) {
109     return MerkleProof.verify(proof, merkle, leaf);
110   }
111 
112   /// @notice Allows santas to deposit NFTs to contract
113   /// @param nftContract of NFT being deposited
114   /// @param tokenId being deposited
115   function santaDepositNFT(address nftContract, uint256 tokenId) external {
116     // Transfer NFT to contract
117     IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
118     // Mark as deposited by santa
119     nftCount[msg.sender]++;
120     nfts[msg.sender].push(SantaNFT(nftContract, tokenId));
121   }
122 
123   /// @notice Allows giftees to claim NFTs
124   /// @param santa who is gifting them
125   /// @param santaIndex index of gift in santa's array
126   /// @param proof merkle proof of claim
127   function gifteeClaimNFT(
128     address santa,
129     uint256 santaIndex,
130     bytes32[] calldata proof
131   ) external {
132     // Require merkle to be set
133     if (merkle == 0) revert NotClaimable();
134     // Require giftee to be claiming correct santa NFT
135     if (!_verify(_leaf(msg.sender, santa, santaIndex), proof)) revert NotClaimable();
136 
137     // Collect NFT
138     SantaNFT memory nft = nfts[santa][santaIndex];
139     // Transfer NFT
140     IERC721(nft.nftContract).transferFrom(address(this), msg.sender, nft.tokenId);
141   }
142 
143   /// @notice ALlows santas to reclaim their NFTs given reclaim period is active
144   /// @param index of gift in santa's array (fka: santaIndex)
145   function santaReclaimNFT(uint256 index) external {
146     // Require reclaim period to be active
147     if (block.timestamp < RECLAIM_OPEN) revert NotClaimable();
148     // Require provided index to be in range of owned NFTs
149     if (index + 1 > nfts[msg.sender].length) revert NotClaimable();
150 
151     // Collect NFT
152     SantaNFT memory nft = nfts[msg.sender][index];
153     // Transfer unclaimed NFT
154     IERC721(nft.nftContract).transferFrom(address(this), msg.sender, nft.tokenId);
155   }
156 
157   /// @notice Allows contract owner to withdraw any single NFT
158   /// @notice nftContract of NFT to withdraw
159   /// @notice tokenId to withdraw
160   /// @notice recipient of withdrawn NFT
161   function adminWithdrawNFT(
162     address nftContract,
163     uint256 tokenId,
164     address recipient
165   ) external {
166     // Require caller to be owner
167     if (msg.sender != owner) revert NotOwner();
168 
169     IERC721(nftContract).transferFrom(
170       // From this contract
171       address(this),
172       // To provided recipient
173       recipient,
174       // Transfer specified NFT tokenId
175       tokenId
176     );
177   }
178 
179   /// @notice Allows contract owner to withdraw bulk NFTs
180   /// @notice contracts of NFTs to withdraw
181   /// @notice tokenIds to withdraw
182   /// @notice recipients of withdrawn NFT
183   /// @dev Does not check for array length equality
184   function adminWithdrawNFTBulk(
185     address[] calldata contracts,
186     uint256[] calldata tokenIds,
187     address[] calldata recipients
188   ) external {
189     // Require caller to be owner
190     if (msg.sender != owner) revert NotOwner();
191 
192     // For each provided contract
193     for (uint256 i = 0; i < contracts.length; i++) {
194       IERC721(contracts[i]).transferFrom(
195         // From contract
196         address(this),
197         // To provided recipient
198         recipients[i],
199         // Transfer specified NFT tokenId
200         tokenIds[i]
201       );
202     }
203   }
204 
205   /// @notice Allows owner to update merkle
206   /// @param merkleRoot to update
207   function adminUpdateMerkle(bytes32 merkleRoot) external {
208     // Require caller to be owner
209     if (msg.sender != owner) revert NotOwner();
210     // Update merkle root
211     merkle = merkleRoot;
212   }
213 
214   /// @notice Allows owner to update new owner
215   /// @param newOwner to update
216   function adminUpdateOwner(address newOwner) external {
217     // Require caller to be owner
218     if (msg.sender != owner) revert NotOwner();
219     // Update to new owner
220     owner = newOwner;
221   }
222 }