1 pragma solidity 0.4.24;
2 
3 /**
4  * This contract is used to protect the users of Storm4:
5  * https://www.storm4.cloud
6  * 
7  * That is, to ensure the public keys of users are verifiable, auditable & tamper-proof.
8  * 
9  * Here's the general idea:
10  * - We batch the public keys of multiple users into a merkle tree.
11  * - We publish the merkle tree root to this contract.
12  * - The merkle tree root for any user can only be assigned once.
13  * 
14  * In order to verify a user:
15  * - Use this contract to fetch the merkle tree root value for the userID.
16  * - Then use HTTPS to fetch the corresponding merkle file from our server.
17  *   For example, if the merkle tree root value is
18  *   "0xcd59b7bda6dc1dd82cb173d0cdfa408db30e9a747d4366eb5b60597899eb69c1",
19  *   then you could fetch the corresponding JSON file at
20  *   https://blockchain.storm4.cloud/cd59b7bda6dc1dd82cb173d0cdfa408db30e9a747d4366eb5b60597899eb69c1.json
21  * - The JSON file allows you to independently verify the public key information
22  *   by calculating the merkle tree root for yourself.
23 **/
24 contract PubKeyTrust {
25 	address public owner;
26 	string public constant HASH_TYPE = "sha256";
27 
28 	/**
29 	 * users[userID] => merkleTreeRoot
30 	 * 
31 	 * A value of zero indicates that a merkleTreeRoot has not been
32 	 * published for the userID.
33 	**/
34 	mapping(bytes20 => bytes32) private users;
35 	
36 	/**
37 	 * merkleTreeRoots[merkleTreeRootValue] => blockNumber
38 	 * 
39 	 * Note: merkleTreeRoots[0x0] is initialized in the constructor to store
40 	 * the block number of when the contract was published.
41 	**/
42 	mapping(bytes32 => uint) private merkleTreeRoots;
43 
44 	constructor() public {
45 		owner = msg.sender;
46 		merkleTreeRoots[bytes32(0)] = block.number;
47 	}
48 
49 	modifier onlyByOwner()
50 	{
51 		if (msg.sender != owner)
52 			require(false);
53 		else
54 			_;
55 	}
56 
57 	/**
58 	 * We originally passed the userIDs as: bytes20[] userIDs
59 	 * But it was discovered that this was inefficiently packed,
60 	 * and ended up sending 12 bytes of zero's per userID.
61 	 * Since gtxdatazero is set to 4 gas/bytes, this translated into
62 	 * 48 gas wasted per user due to inefficient packing.
63 	**/
64 	function addMerkleTreeRoot(bytes32 merkleTreeRoot, bytes userIDsPacked) public onlyByOwner {
65 
66 		if (merkleTreeRoot == bytes32(0)) require(false);
67 
68 		bool addedUser = false;
69 
70 		uint numUserIDs = userIDsPacked.length / 20;
71 		for (uint i = 0; i < numUserIDs; i++)
72 		{
73 			bytes20 userID;
74 			assembly {
75 				userID := mload(add(userIDsPacked, add(32, mul(20, i))))
76 			}
77 
78 			bytes32 existingMerkleTreeRoot = users[userID];
79 			if (existingMerkleTreeRoot == bytes32(0))
80 			{
81 				users[userID] = merkleTreeRoot;
82 				addedUser = true;
83 			}
84 		}
85 
86 		if (addedUser && (merkleTreeRoots[merkleTreeRoot] == 0))
87 		{
88 			merkleTreeRoots[merkleTreeRoot] = block.number;
89 		}
90 	}
91 
92 	function getMerkleTreeRoot(bytes20 userID) public view returns (bytes32) {
93 
94 		return users[userID];
95 	}
96 
97 	function getBlockNumber(bytes32 merkleTreeRoot) public view returns (uint) {
98 
99 		return merkleTreeRoots[merkleTreeRoot];
100 	}
101 
102     function getUserInfo(bytes20 userID) public view returns (bytes32, uint) {
103         
104         bytes32 merkleTreeRoot = users[userID];
105         uint blockNumber = merkleTreeRoots[merkleTreeRoot];
106         
107         return (merkleTreeRoot, blockNumber);
108     }	
109 }