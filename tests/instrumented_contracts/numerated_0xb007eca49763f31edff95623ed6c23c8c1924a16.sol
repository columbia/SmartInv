1 pragma solidity ^0.4.24;
2 
3 // File: contracts/lib/ownership/Ownable.sol
4 
5 contract Ownable {
6     address public owner;
7     event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
8 
9     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
10     constructor() public { owner = msg.sender; }
11 
12     /// @dev Throws if called by any contract other than latest designated caller
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
19     /// @param newOwner The address to transfer ownership to.
20     function transferOwnership(address newOwner) public onlyOwner {
21        require(newOwner != address(0));
22        emit OwnershipTransferred(owner, newOwner);
23        owner = newOwner;
24     }
25 }
26 
27 // File: contracts/lib/ownership/ZapCoordinatorInterface.sol
28 
29 contract ZapCoordinatorInterface is Ownable {
30 	function addImmutableContract(string contractName, address newAddress) external;
31 	function updateContract(string contractName, address newAddress) external;
32 	function getContractName(uint index) public view returns (string);
33 	function getContract(string contractName) public view returns (address);
34 	function updateAllDependencies() external;
35 }
36 
37 // File: contracts/lib/ownership/Upgradable.sol
38 
39 pragma solidity ^0.4.24;
40 
41 contract Upgradable {
42 
43 	address coordinatorAddr;
44 	ZapCoordinatorInterface coordinator;
45 
46 	constructor(address c) public{
47 		coordinatorAddr = c;
48 		coordinator = ZapCoordinatorInterface(c);
49 	}
50 
51     function updateDependencies() external coordinatorOnly {
52        _updateDependencies();
53     }
54 
55     function _updateDependencies() internal;
56 
57     modifier coordinatorOnly() {
58     	require(msg.sender == coordinatorAddr, "Error: Coordinator Only Function");
59     	_;
60     }
61 }
62 
63 // File: contracts/platform/database/DatabaseInterface.sol
64 
65 contract DatabaseInterface is Ownable {
66 	function setStorageContract(address _storageContract, bool _allowed) public;
67 	/*** Bytes32 ***/
68 	function getBytes32(bytes32 key) external view returns(bytes32);
69 	function setBytes32(bytes32 key, bytes32 value) external;
70 	/*** Number **/
71 	function getNumber(bytes32 key) external view returns(uint256);
72 	function setNumber(bytes32 key, uint256 value) external;
73 	/*** Bytes ***/
74 	function getBytes(bytes32 key) external view returns(bytes);
75 	function setBytes(bytes32 key, bytes value) external;
76 	/*** String ***/
77 	function getString(bytes32 key) external view returns(string);
78 	function setString(bytes32 key, string value) external;
79 	/*** Bytes Array ***/
80 	function getBytesArray(bytes32 key) external view returns (bytes32[]);
81 	function getBytesArrayIndex(bytes32 key, uint256 index) external view returns (bytes32);
82 	function getBytesArrayLength(bytes32 key) external view returns (uint256);
83 	function pushBytesArray(bytes32 key, bytes32 value) external;
84 	function setBytesArrayIndex(bytes32 key, uint256 index, bytes32 value) external;
85 	function setBytesArray(bytes32 key, bytes32[] value) external;
86 	/*** Int Array ***/
87 	function getIntArray(bytes32 key) external view returns (int[]);
88 	function getIntArrayIndex(bytes32 key, uint256 index) external view returns (int);
89 	function getIntArrayLength(bytes32 key) external view returns (uint256);
90 	function pushIntArray(bytes32 key, int value) external;
91 	function setIntArrayIndex(bytes32 key, uint256 index, int value) external;
92 	function setIntArray(bytes32 key, int[] value) external;
93 	/*** Address Array ***/
94 	function getAddressArray(bytes32 key) external view returns (address[]);
95 	function getAddressArrayIndex(bytes32 key, uint256 index) external view returns (address);
96 	function getAddressArrayLength(bytes32 key) external view returns (uint256);
97 	function pushAddressArray(bytes32 key, address value) external;
98 	function setAddressArrayIndex(bytes32 key, uint256 index, address value) external;
99 	function setAddressArray(bytes32 key, address[] value) external;
100 }
101 
102 // File: contracts/lib/ownership/ZapCoordinator.sol
103 
104 contract ZapCoordinator is Ownable, ZapCoordinatorInterface {
105 
106 	event UpdatedContract(string name, address previousAddr, address newAddr);
107 	event UpdatedDependencies(uint timestamp, string contractName, address contractAddr);
108 
109 	mapping(string => address) contracts; 
110 
111 	// names of upgradable contracts
112 	string[] public loadedContracts;
113 
114 	DatabaseInterface public db;
115 
116 	// used for adding contracts like Database and ZapToken
117 	function addImmutableContract(string contractName, address newAddress) external onlyOwner {
118 		assert(contracts[contractName] == address(0));
119 		contracts[contractName] = newAddress;
120 
121 		// Create DB object when Database is added to Coordinator
122 		bytes32 hash = keccak256(abi.encodePacked(contractName));
123 		if(hash == keccak256(abi.encodePacked("DATABASE"))) db = DatabaseInterface(newAddress);
124 	}
125 
126 	// used for modifying an existing contract or adding a new contract to the system
127 	function updateContract(string contractName, address newAddress) external onlyOwner {
128 		address prev = contracts[contractName];
129 		if (prev == address(0) ) {
130 			// First time adding this contract
131 			loadedContracts.push(contractName);
132 		} else {
133 			// Deauth the old contract
134 			db.setStorageContract(prev, false);
135 		}
136 		// give new contract database access permission
137 		db.setStorageContract(newAddress, true);
138 
139 		emit UpdatedContract(contractName, prev, newAddress);
140 		contracts[contractName] = newAddress;
141 	}
142 
143 	function getContractName(uint index) public view returns (string) {
144 		return loadedContracts[index];
145 	}
146 
147 	function getContract(string contractName) public view returns (address) {
148 		return contracts[contractName];
149 	}
150 
151 	function updateAllDependencies() external onlyOwner {
152 		for ( uint i = 0; i < loadedContracts.length; i++ ) {
153 			address c = contracts[loadedContracts[i]];
154 			Upgradable(c).updateDependencies();
155 			emit UpdatedDependencies(block.timestamp, loadedContracts[i], c);
156 		}
157 	}
158 
159 }