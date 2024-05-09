1 pragma solidity ^0.4.13;
2 
3 contract EthicHubStorage {
4 
5 	mapping(bytes32 => uint256) internal uintStorage;
6 	mapping(bytes32 => string) internal stringStorage;
7 	mapping(bytes32 => address) internal addressStorage;
8 	mapping(bytes32 => bytes) internal bytesStorage;
9 	mapping(bytes32 => bool) internal boolStorage;
10 	mapping(bytes32 => int256) internal intStorage;
11 
12 
13 
14     /*** Modifiers ************/
15 
16     /// @dev Only allow access from the latest version of a contract in the Rocket Pool network after deployment
17     modifier onlyEthicHubContracts() {
18         // Maje sure the access is permitted to only contracts in our Dapp
19         require(addressStorage[keccak256("contract.address", msg.sender)] != 0x0);
20         _;
21     }
22 
23     constructor() public {
24 		addressStorage[keccak256("contract.address", msg.sender)] = msg.sender;
25     }
26 
27 	/**** Get Methods ***********/
28 
29 	/// @param _key The key for the record
30 	function getAddress(bytes32 _key) external view returns (address) {
31 		return addressStorage[_key];
32 	}
33 
34 	/// @param _key The key for the record
35 	function getUint(bytes32 _key) external view returns (uint) {
36 		return uintStorage[_key];
37 	}
38 
39 	/// @param _key The key for the record
40 	function getString(bytes32 _key) external view returns (string) {
41 		return stringStorage[_key];
42 	}
43 
44 	/// @param _key The key for the record
45 	function getBytes(bytes32 _key) external view returns (bytes) {
46 		return bytesStorage[_key];
47 	}
48 
49 	/// @param _key The key for the record
50 	function getBool(bytes32 _key) external view returns (bool) {
51 		return boolStorage[_key];
52 	}
53 
54 	/// @param _key The key for the record
55 	function getInt(bytes32 _key) external view returns (int) {
56 		return intStorage[_key];
57 	}
58 
59 	/**** Set Methods ***********/
60 
61 	/// @param _key The key for the record
62 	function setAddress(bytes32 _key, address _value) onlyEthicHubContracts external {
63 		addressStorage[_key] = _value;
64 	}
65 
66 	/// @param _key The key for the record
67 	function setUint(bytes32 _key, uint _value) onlyEthicHubContracts external {
68 		uintStorage[_key] = _value;
69 	}
70 
71 	/// @param _key The key for the record
72 	function setString(bytes32 _key, string _value) onlyEthicHubContracts external {
73 		stringStorage[_key] = _value;
74 	}
75 
76 	/// @param _key The key for the record
77 	function setBytes(bytes32 _key, bytes _value) onlyEthicHubContracts external {
78 		bytesStorage[_key] = _value;
79 	}
80 
81 	/// @param _key The key for the record
82 	function setBool(bytes32 _key, bool _value) onlyEthicHubContracts external {
83 		boolStorage[_key] = _value;
84 	}
85 
86 	/// @param _key The key for the record
87 	function setInt(bytes32 _key, int _value) onlyEthicHubContracts external {
88 		intStorage[_key] = _value;
89 	}
90 
91 	/**** Delete Methods ***********/
92 
93 	/// @param _key The key for the record
94 	function deleteAddress(bytes32 _key) onlyEthicHubContracts external {
95 		delete addressStorage[_key];
96 	}
97 
98 	/// @param _key The key for the record
99 	function deleteUint(bytes32 _key) onlyEthicHubContracts external {
100 		delete uintStorage[_key];
101 	}
102 
103 	/// @param _key The key for the record
104 	function deleteString(bytes32 _key) onlyEthicHubContracts external {
105 		delete stringStorage[_key];
106 	}
107 
108 	/// @param _key The key for the record
109 	function deleteBytes(bytes32 _key) onlyEthicHubContracts external {
110 		delete bytesStorage[_key];
111 	}
112 
113 	/// @param _key The key for the record
114 	function deleteBool(bytes32 _key) onlyEthicHubContracts external {
115 		delete boolStorage[_key];
116 	}
117 
118 	/// @param _key The key for the record
119 	function deleteInt(bytes32 _key) onlyEthicHubContracts external {
120 		delete intStorage[_key];
121 	}
122 
123 }