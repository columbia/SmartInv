1 pragma solidity ^0.4.16;
2 
3 pragma solidity ^0.4.16;
4 
5 contract Permissions {
6 
7 	address ownerAddress;
8 	address storageAddress;
9 	address callerAddress;
10 
11 	function Permissions() public {
12 		ownerAddress = msg.sender;
13 	}
14 
15 	modifier onlyOwner() {
16 		require(msg.sender == ownerAddress);
17 		_;
18 	}
19 
20 	modifier onlyCaller() {
21 		require(msg.sender == callerAddress);
22 		_;
23 	}
24 
25 	function getOwner() view external returns (address) {
26 		return ownerAddress;
27 	}
28 
29 	function getStorageAddress() view external returns (address) {
30 		return storageAddress;
31 	}
32 
33 	function getCaller() view external returns (address) {
34 		return callerAddress;
35 	}
36 
37 	function transferOwnership(address newOwner) external onlyOwner {
38 		if (newOwner != address(0)) {
39 				ownerAddress = newOwner;
40 		}
41 	}
42 	function newStorage(address _new) external onlyOwner {
43 		if (_new != address(0)) {
44 				storageAddress = _new;
45 		}
46 	}
47 	function newCaller(address _new) external onlyOwner {
48 		if (_new != address(0)) {
49 				callerAddress = _new;
50 		}
51 	}
52 }
53 
54 contract Creatures is Permissions {
55 	struct Creature {
56 		uint16 species;
57 		uint8 subSpecies;
58 		uint8 eyeColor;
59 		uint64 timestamp;
60 	}
61 	Creature[] creatures;
62 
63 	mapping (uint256 =>	address) public creatureIndexToOwner;
64 	mapping (address => uint256) ownershipTokenCount;
65 
66 	event CreateCreature(uint256 id, address indexed owner);
67 	event Transfer(address _from, address _to, uint256 creatureID);
68 
69 	function add(address _owner, uint16 _species, uint8 _subSpecies, uint8 _eyeColor) external onlyCaller {
70 		// do checks in caller function
71 		Creature memory _creature = Creature({
72 			species: _species,
73 			subSpecies: _subSpecies,
74 			eyeColor: _eyeColor,
75 			timestamp: uint64(now)
76 		});
77 		uint256 newCreatureID = creatures.push(_creature) - 1;
78 		transfer(0, _owner, newCreatureID);
79 		CreateCreature(newCreatureID, _owner);
80 	}
81 	function getCreature(uint256 id) external view returns (address, uint16, uint8, uint8, uint64) {
82 		Creature storage c = creatures[id];
83 		address owner = creatureIndexToOwner[id];
84 		return (
85 			owner,
86 			c.species,
87 			c.subSpecies,
88 			c.eyeColor,
89 			c.timestamp
90 		);
91 	}
92 	function transfer(address _from, address _to, uint256 _tokenId) public onlyCaller {
93 		// do checks in caller function
94 		creatureIndexToOwner[_tokenId] = _to;
95 		if (_from != address(0)) {
96 			ownershipTokenCount[_from]--;
97 		}
98 		ownershipTokenCount[_to]++;
99 		Transfer(_from, _to, _tokenId);
100 	}
101 }
102 
103 
104 contract CreaturesInterface is Permissions {
105 
106 	mapping (uint8 => uint256) public creatureCosts;
107 
108 	function CreaturesInterface() public {
109 		creatureCosts[0] = .10 ether;
110 		creatureCosts[1] = .25 ether;
111 		creatureCosts[2] = .12 ether;
112 		creatureCosts[3] = .50 ether;
113 		creatureCosts[4] = .10 ether;
114 		creatureCosts[5] = 2.0 ether;
115 		creatureCosts[6] = 2.0 ether;
116 		creatureCosts[7] = 1.0 ether;
117 		creatureCosts[8] = .01 ether;
118 		creatureCosts[9] = .025 ether;
119 	}
120 
121 	function addCreature(uint16 _species, uint8 _subSpecies, uint8 _eyeColor) external payable {
122 		require(_species == 0); // only one species available for now
123 		require(creatureCosts[_subSpecies] > 0);
124 		require(msg.value >= creatureCosts[_subSpecies]);
125 		Creatures creatureStorage = Creatures(storageAddress);
126 		creatureStorage.add(msg.sender, _species, _subSpecies, _eyeColor);
127 	}
128     function withdrawBalance() external onlyOwner {
129         ownerAddress.transfer(this.balance);
130     }
131 }