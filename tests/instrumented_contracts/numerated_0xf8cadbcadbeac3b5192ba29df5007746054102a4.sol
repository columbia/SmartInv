1 pragma solidity 0.4.18;
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
12  * - The merkle tree root for any given user can only be assigned once (per hash algorithm).
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
26 
27 	/**
28 	 * Rather than hard-coding a specific hash algorithm, we allow for upgradeability,
29 	 * should it become important to do so in the future for security reasons.
30 	 * 
31 	 * In order to support this, we keep a "register" of supported hash algorithms.
32 	 * Every hash algorithm in the system is assigned a unique ID (a uint8),
33 	 * along with a corresponding short identifier.
34 	 * 
35 	 * For example: 0 => "sha256"
36 	 * 
37 	 * Note: Since we are expecting there to be very few hash algorithms used
38 	 * in practice (probably just 1 or 2), we artificially limit the size of
39 	 * the hashTypes array to 256 entries. This allows us to use uint8 throughout
40 	 * the rest of the contract.
41 	**/
42 	string[] public hashTypes;
43 
44 	/**
45 	 * We batch the public keys of multiple users into a single merkle tree,
46 	 * and then publish the merkle tree root to the blockchain.
47 	 * 
48 	 * Note: merkleTreeRoots[0] is initialized in the constructor to store
49 	 * the block number of when the contract was published.
50 	**/
51 	struct MerkleInfo {
52 		bytes merkleTreeRoot;
53 		uint blockNumber;
54 	}
55 	MerkleInfo[] public merkleTreeRoots;
56 
57 	/**
58 	 * users[userID][hashTypeID] => merkleTreeRootsIndex
59 	 * 
60 	 * A value of zero indicates that a merkleTreeRoot has not been
61 	 * published for the <userID, hashTypeID> tuple.
62 	 * A nonzero value can be used as the index for the merkleTreeRoots array.
63 	 * 
64 	 * Note: merkleTreeRoots[0] is initialized in the constructor to store
65 	 * the block number of when the contract was published.
66 	 * Thus: merkleTreeRoots[0].merkleTreeRoot.length == 0
67 	**/
68 	mapping(bytes20 => mapping(uint8 => uint)) public users;
69 
70 	event HashTypeAdded(uint8 hashTypeID);
71 	event MerkleTreeRootAdded(uint8 hashTypeID, bytes merkleTreeRoot);
72 
73 	function PubKeyTrust() public {
74 		owner = msg.sender;
75 		merkleTreeRoots.push(MerkleInfo(new bytes(0), block.number));
76 	}
77 
78 	modifier onlyByOwner()
79 	{
80 		if (msg.sender != owner)
81 			require(false);
82 		else
83 			_;
84 	}
85 
86 	function numHashTypes() public view returns (uint) {
87 
88 		return hashTypes.length;
89 	}
90 
91 	function addHashType(string description) public onlyByOwner returns(bool, uint8) {
92 
93 		uint hashTypeID = hashTypes.length;
94 
95 		// Restrictions:
96 		// - there cannot be more than 256 different hash types
97 		// - the description cannot be the empty string
98 		// - the description cannot be over 64 bytes long
99 		if (hashTypeID >= 256) require(false);
100 		if (bytes(description).length == 0) require(false);
101 		if (bytes(description).length > 64) require(false);
102 
103 		// Ensure the given description doesn't already exist
104 		for (uint i = 0; i < hashTypeID; i++)
105 		{
106 			if (stringsEqual(hashTypes[i], description)) {
107 				return (false, uint8(0));
108 			}
109 		}
110 
111 		// Go ahead and add the new hash type
112 		hashTypes.push(description);
113 		HashTypeAdded(uint8(hashTypeID));
114 
115 		return (true, uint8(hashTypeID));
116 	}
117 
118 	/**
119 	 * We originally passed the userIDs as: bytes20[] userIDs
120 	 * But it was discovered that this was inefficiently packed,
121 	 * and ended up sending 12 bytes of zero's per userID.
122 	 * Since gtxdatazero is set to 4 gas/bytes, this translated into
123 	 * 48 gas wasted per user due to inefficient packing.
124 	**/
125 	function addMerkleTreeRoot(uint8 hashTypeID, bytes merkleTreeRoot, bytes userIDsPacked) public onlyByOwner {
126 
127 		if (hashTypeID >= hashTypes.length) require(false);
128 		if (merkleTreeRoot.length == 0) require(false);
129 
130 		uint index = merkleTreeRoots.length;
131 		bool addedIndexForUser = false;
132 
133 		uint numUserIDs = userIDsPacked.length / 20;
134 		for (uint i = 0; i < numUserIDs; i++)
135 		{
136 			bytes20 userID;
137 			assembly {
138 				userID := mload(add(userIDsPacked, add(32, mul(20, i))))
139 			}
140 
141 			uint existingIndex = users[userID][hashTypeID];
142 			if (existingIndex == 0)
143 			{
144 				users[userID][hashTypeID] = index;
145 				addedIndexForUser = true;
146 			}
147 		}
148 
149 		if (addedIndexForUser)
150 		{
151 			merkleTreeRoots.push(MerkleInfo(merkleTreeRoot, block.number));
152 			MerkleTreeRootAdded(hashTypeID, merkleTreeRoot);
153 		}
154 	}
155 
156 	function getMerkleTreeRoot(bytes20 userID, uint8 hashTypeID) public view returns (bytes) {
157 
158 		uint merkleTreeRootsIndex = users[userID][hashTypeID];
159 		if (merkleTreeRootsIndex == 0) {
160 			return new bytes(0);
161 		}
162 		else {
163 			MerkleInfo storage merkleInfo = merkleTreeRoots[merkleTreeRootsIndex];
164 			return merkleInfo.merkleTreeRoot;
165 		}
166 	}
167 
168 	function getBlockNumber(bytes20 userID, uint8 hashTypeID) public view returns (uint) {
169 
170 		uint merkleTreeRootsIndex = users[userID][hashTypeID];
171 		if (merkleTreeRootsIndex == 0) {
172 			return 0;
173 		}
174 		else {
175 			MerkleInfo storage merkleInfo = merkleTreeRoots[merkleTreeRootsIndex];
176 			return merkleInfo.blockNumber;
177 		}
178 	}
179 
180 	// Utility function (because string comparison doesn't exist natively in Solidity yet)
181 	function stringsEqual(string storage _a, string memory _b) internal view returns (bool) {
182 
183 		bytes storage a = bytes(_a);
184 		bytes memory b = bytes(_b);
185 		if (a.length != b.length) {
186 			return false;
187 		}
188 		for (uint i = 0; i < a.length; i++) {
189 			if (a[i] != b[i]) {
190 				return false;
191 			}
192 		}
193 		return true;
194 	}
195 }