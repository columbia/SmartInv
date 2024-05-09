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
27 // File: contracts/platform/database/DatabaseInterface.sol
28 
29 contract DatabaseInterface is Ownable {
30 	function setStorageContract(address _storageContract, bool _allowed) public;
31 	/*** Bytes32 ***/
32 	function getBytes32(bytes32 key) external view returns(bytes32);
33 	function setBytes32(bytes32 key, bytes32 value) external;
34 	/*** Number **/
35 	function getNumber(bytes32 key) external view returns(uint256);
36 	function setNumber(bytes32 key, uint256 value) external;
37 	/*** Bytes ***/
38 	function getBytes(bytes32 key) external view returns(bytes);
39 	function setBytes(bytes32 key, bytes value) external;
40 	/*** String ***/
41 	function getString(bytes32 key) external view returns(string);
42 	function setString(bytes32 key, string value) external;
43 	/*** Bytes Array ***/
44 	function getBytesArray(bytes32 key) external view returns (bytes32[]);
45 	function getBytesArrayIndex(bytes32 key, uint256 index) external view returns (bytes32);
46 	function getBytesArrayLength(bytes32 key) external view returns (uint256);
47 	function pushBytesArray(bytes32 key, bytes32 value) external;
48 	function setBytesArrayIndex(bytes32 key, uint256 index, bytes32 value) external;
49 	function setBytesArray(bytes32 key, bytes32[] value) external;
50 	/*** Int Array ***/
51 	function getIntArray(bytes32 key) external view returns (int[]);
52 	function getIntArrayIndex(bytes32 key, uint256 index) external view returns (int);
53 	function getIntArrayLength(bytes32 key) external view returns (uint256);
54 	function pushIntArray(bytes32 key, int value) external;
55 	function setIntArrayIndex(bytes32 key, uint256 index, int value) external;
56 	function setIntArray(bytes32 key, int[] value) external;
57 	/*** Address Array ***/
58 	function getAddressArray(bytes32 key) external view returns (address[]);
59 	function getAddressArrayIndex(bytes32 key, uint256 index) external view returns (address);
60 	function getAddressArrayLength(bytes32 key) external view returns (uint256);
61 	function pushAddressArray(bytes32 key, address value) external;
62 	function setAddressArrayIndex(bytes32 key, uint256 index, address value) external;
63 	function setAddressArray(bytes32 key, address[] value) external;
64 }
65 
66 // File: contracts/platform/database/Database.sol
67 
68 contract Database is Ownable, DatabaseInterface {
69 	event StorageModified(address indexed contractAddress, bool allowed);
70 
71 	mapping (bytes32 => bytes32) data_bytes32;
72 	mapping (bytes32 => bytes) data_bytes;
73 	mapping (bytes32 => bytes32[]) data_bytesArray;
74 	mapping (bytes32 => int[]) data_intArray;
75 	mapping (bytes32 => address[]) data_addressArray;
76 	mapping (address => bool) allowed;
77 
78 	constructor() public {
79 
80 	}
81 
82 	modifier storageOnly {
83 		require(allowed[msg.sender], "Error: Access not allowed to storage");
84 		_;
85 	}
86 
87 	function setStorageContract(address _storageContract, bool _allowed) public onlyOwner {
88 		require(_storageContract != address(0), "Error: Address zero is invalid storage contract");
89 		allowed[_storageContract] = _allowed;
90 		emit StorageModified(_storageContract, _allowed);
91 	}
92 
93 	/*** Bytes32 ***/
94 	function getBytes32(bytes32 key) external view returns(bytes32) {
95 		return data_bytes32[key];
96 	}
97 
98 	function setBytes32(bytes32 key, bytes32 value) external storageOnly  {
99 		data_bytes32[key] = value;
100 	}
101 
102 	/*** Number **/
103 	function getNumber(bytes32 key) external view returns(uint256) {
104 		return uint256(data_bytes32[key]);
105 	}
106 
107 	function setNumber(bytes32 key, uint256 value) external storageOnly {
108 		data_bytes32[key] = bytes32(value);
109 	}
110 
111 	/*** Bytes ***/
112 	function getBytes(bytes32 key) external view returns(bytes) {
113 		return data_bytes[key];
114 	}
115 
116 	function setBytes(bytes32 key, bytes value) external storageOnly {
117 		data_bytes[key] = value;
118 	}
119 
120 	/*** String ***/
121 	function getString(bytes32 key) external view returns(string) {
122 		return string(data_bytes[key]);
123 	}
124 
125 	function setString(bytes32 key, string value) external storageOnly {
126 		data_bytes[key] = bytes(value);
127 	}
128 
129 	/*** Bytes Array ***/
130 	function getBytesArray(bytes32 key) external view returns (bytes32[]) {
131 		return data_bytesArray[key];
132 	}
133 
134 	function getBytesArrayIndex(bytes32 key, uint256 index) external view returns (bytes32) {
135 		return data_bytesArray[key][index];
136 	}
137 
138 	function getBytesArrayLength(bytes32 key) external view returns (uint256) {
139 		return data_bytesArray[key].length;
140 	}
141 
142 	function pushBytesArray(bytes32 key, bytes32 value) external {
143 		data_bytesArray[key].push(value);
144 	}
145 
146 	function setBytesArrayIndex(bytes32 key, uint256 index, bytes32 value) external storageOnly {
147 		data_bytesArray[key][index] = value;
148 	}
149 
150 	function setBytesArray(bytes32 key, bytes32[] value) external storageOnly {
151 		data_bytesArray[key] = value;
152 	}
153 
154 	/*** Int Array ***/
155 	function getIntArray(bytes32 key) external view returns (int[]) {
156 		return data_intArray[key];
157 	}
158 
159 	function getIntArrayIndex(bytes32 key, uint256 index) external view returns (int) {
160 		return data_intArray[key][index];
161 	}
162 
163 	function getIntArrayLength(bytes32 key) external view returns (uint256) {
164 		return data_intArray[key].length;
165 	}
166 
167 	function pushIntArray(bytes32 key, int value) external {
168 		data_intArray[key].push(value);
169 	}
170 
171 	function setIntArrayIndex(bytes32 key, uint256 index, int value) external storageOnly {
172 		data_intArray[key][index] = value;
173 	}
174 
175 	function setIntArray(bytes32 key, int[] value) external storageOnly {
176 		data_intArray[key] = value;
177 	}
178 
179 	/*** Address Array ***/
180 	function getAddressArray(bytes32 key) external view returns (address[]) {
181 		return data_addressArray[key];
182 	}
183 
184 	function getAddressArrayIndex(bytes32 key, uint256 index) external view returns (address) {
185 		return data_addressArray[key][index];
186 	}
187 
188 	function getAddressArrayLength(bytes32 key) external view returns (uint256) {
189 		return data_addressArray[key].length;
190 	}
191 
192 	function pushAddressArray(bytes32 key, address value) external {
193 		data_addressArray[key].push(value);
194 	}
195 
196 	function setAddressArrayIndex(bytes32 key, uint256 index, address value) external storageOnly {
197 		data_addressArray[key][index] = value;
198 	}
199 
200 	function setAddressArray(bytes32 key, address[] value) external storageOnly {
201 		data_addressArray[key] = value;
202 	}
203 }