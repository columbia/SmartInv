1 pragma solidity ^0.4.18;
2 
3 // https://www.storm4.cloud
4 
5 contract PubKeyTrust {
6 	address owner;
7 
8 	uint8[] public allHashTypes;
9 	mapping(uint8 => string) public hashTypes;
10 
11 	struct HashInfo {
12 		bytes pubKeyHash;
13 		bytes keyID;
14 		uint blockNumber;
15 	}
16 	struct UserHashes {
17 		mapping(uint8 => HashInfo) hashes;
18 		bool initialized;
19 	}
20 	mapping(bytes20 => UserHashes) hashes;
21 
22 	event UserAdded(bytes20 indexed userID);
23 	event PubKeyHashAdded(bytes20 indexed userID, uint8 indexed hashType);
24 	event PubKeyHashTypeAdded(uint8 indexed hashType);
25 
26 	function PubKeyTrust() public {
27 		owner = msg.sender;
28 	}
29 
30 	modifier onlyByOwner()
31 	{
32 		if (msg.sender != owner)
33 			require(false);
34 		else
35 			_;
36 	}
37 
38 	function numHashTypes() public view returns (uint) {
39 
40 		return allHashTypes.length;
41 	}
42 
43 	function addHashType(uint8 hashType, string description) public onlyByOwner {
44 
45 		// Strings must be non-empty
46 		if (hashType == 0) require(false);
47 		if (bytes(description).length == 0) require(false);
48 		if (bytes(description).length > 64) require(false);
49 
50 		string storage prvDescription = hashTypes[hashType];
51 		if (bytes(prvDescription).length == 0)
52 		{
53 			allHashTypes.push(hashType);
54 			hashTypes[hashType] = description;
55 			PubKeyHashTypeAdded(hashType);
56 		}
57 	}
58 
59 	function isValidHashType(uint8 hashType) public view returns (bool) {
60 
61 		string storage description = hashTypes[hashType];
62 		return (bytes(description).length > 0);
63 	}
64 
65 	function addPubKeyHash(bytes20 userID, uint8 hashType, bytes pubKeyHash, bytes keyID) public onlyByOwner {
66 
67 		if (!isValidHashType(hashType)) require(false);
68 		if (pubKeyHash.length == 0) require(false);
69 		if (keyID.length == 0) require(false);
70 
71 		UserHashes storage userHashes = hashes[userID];
72 		if (!userHashes.initialized) {
73 			userHashes.initialized = true;
74 			UserAdded(userID);
75 		}
76 
77 		HashInfo storage hashInfo = userHashes.hashes[hashType];
78 		if (hashInfo.blockNumber == 0)
79 		{
80 			hashInfo.pubKeyHash = pubKeyHash;
81 			hashInfo.keyID = keyID;
82 			hashInfo.blockNumber = block.number;
83 			PubKeyHashAdded(userID, hashType);
84 		}
85 	}
86 
87 	function getPubKeyHash(bytes20 userID, uint8 hashType) public view returns (bytes) {
88 
89 		UserHashes storage userHashes = hashes[userID];
90 		HashInfo storage hashInfo = userHashes.hashes[hashType];
91 
92 		return hashInfo.pubKeyHash;
93 	}
94 
95 	function getKeyID(bytes20 userID, uint8 hashType) public view returns (bytes) {
96 
97 		UserHashes storage userHashes = hashes[userID];
98 		HashInfo storage hashInfo = userHashes.hashes[hashType];
99 
100 		return hashInfo.keyID;
101 	}
102 
103 	function getBlockNumber(bytes20 userID, uint8 hashType) public view returns (uint) {
104 
105 		UserHashes storage userHashes = hashes[userID];
106 		HashInfo storage hashInfo = userHashes.hashes[hashType];
107 
108 		return hashInfo.blockNumber;
109 	}
110 }