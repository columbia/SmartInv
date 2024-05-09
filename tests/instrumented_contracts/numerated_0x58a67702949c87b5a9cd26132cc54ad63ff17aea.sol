1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title MerkleProof
5  * @dev Merkle proof verification based on
6  * https://github.com/ameensol/merkle-tree-solidity/blob/master/src/MerkleProof.sol
7  */
8 library MerkleProof {
9   /**
10    * @dev Verifies a Merkle proof proving the existence of a leaf in a Merkle tree. Assumes that each pair of leaves
11    * and each pair of pre-images are sorted.
12    * @param proof Merkle proof containing sibling hashes on the branch from the leaf to the root of the Merkle tree
13    * @param root Merkle root
14    * @param leaf Leaf of Merkle tree
15    */
16   function verify(
17     bytes32[] memory proof,
18     bytes32 root,
19     bytes32 leaf
20   )
21     internal
22     pure
23     returns (bool)
24   {
25     bytes32 computedHash = leaf;
26 
27     for (uint256 i = 0; i < proof.length; i++) {
28       bytes32 proofElement = proof[i];
29 
30       if (computedHash < proofElement) {
31         // Hash(current computed hash + current element of the proof)
32         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
33       } else {
34         // Hash(current element of the proof + current computed hash)
35         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
36       }
37     }
38 
39     // Check if the computed hash (root) is equal to the provided root
40     return computedHash == root;
41   }
42 }
43 
44 
45 interface IERC20 {
46   function transfer(address to, uint256 value) external returns (bool);
47 
48   function balanceOf(address who) external view returns (uint256);
49 
50   function allowance(address owner, address spender)
51     external view returns (uint256);
52 
53   function transferFrom(address from, address to, uint256 value)
54     external returns (bool);
55 }
56 
57 /**
58  * @title MerkleProof
59  * @dev Merkle proof verification based on
60  * https://github.com/ameensol/merkle-tree-solidity/blob/master/src/MerkleProof.sol
61  */
62 contract MerkleProofAirdrop {
63   event Drop(string ipfs, address indexed rec, uint amount);
64 
65   struct Airdrop {
66     address owner;
67     bytes32 root;
68     address tokenAddress;
69     uint total;
70     uint claimed;
71     mapping(address => bool) claimedRecipients;
72   }
73 
74   mapping(bytes32 => Airdrop) public airdrops;
75   address payable public owner;
76 
77   constructor(address payable _owner) public {
78     owner = _owner;
79   }
80 
81   function createNewAirdrop(
82       bytes32 _root,
83       address _tokenAddress,
84       uint _total,
85       string memory _ipfs
86     ) public payable {
87     require(msg.value >= 0.2 ether);
88     bytes32 ipfsHash = keccak256(abi.encodePacked(_ipfs));
89     IERC20 token = IERC20(_tokenAddress);
90     require(token.allowance(msg.sender, address(this)) >= _total, "this contract must be allowed to spend tokens");
91 
92     airdrops[ipfsHash] = Airdrop({
93       owner: msg.sender,
94       root: _root,
95       tokenAddress: _tokenAddress,
96       total: _total,
97       claimed: 0
98     });
99     owner.transfer(address(this).balance);
100   }
101 
102   function cancelAirdrop(string memory _ipfs) public {
103     bytes32 ipfsHash = keccak256(abi.encodePacked(_ipfs));
104     Airdrop storage airdrop = airdrops[ipfsHash];
105     require(msg.sender == airdrop.owner);
106     uint left = airdrop.total - airdrop.claimed;
107     require(left > 0);
108 
109     IERC20 token = IERC20(airdrop.tokenAddress);
110     require(token.balanceOf(address(this)) >= left, "not enough tokens");
111     token.transfer(msg.sender, left);
112 
113   }
114 
115   function drop(bytes32[] memory proof, address _recipient, uint256 _amount, string memory _ipfs) public {
116     bytes32 hash = keccak256(abi.encode(_recipient, _amount));
117     bytes32 leaf = keccak256(abi.encode(hash));
118     bytes32 ipfsHash = keccak256(abi.encodePacked(_ipfs));
119     Airdrop storage airdrop = airdrops[ipfsHash];
120 
121     require(verify(proof, airdrop.root, leaf));
122     require(airdrop.claimedRecipients[_recipient] == false, "double spend");
123     airdrop.claimedRecipients[_recipient] = true;
124     airdrop.claimed += _amount;
125 
126     IERC20 token = IERC20(airdrop.tokenAddress);
127     require(token.allowance(airdrop.owner, address(this)) >= _amount, "this contract must be allowed to spend tokens");
128     token.transferFrom(airdrop.owner, _recipient, _amount);
129 
130     // transfer tokens
131     emit Drop(_ipfs, _recipient, _amount);
132   }
133 
134   function verify(
135     bytes32[] memory proof,
136     bytes32 root,
137     bytes32 leaf
138   )
139     public
140     pure
141     returns (bool)
142   {
143     return MerkleProof.verify(proof, root, leaf);
144   }
145 
146 }