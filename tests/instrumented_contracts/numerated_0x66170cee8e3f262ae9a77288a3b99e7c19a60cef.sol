1 pragma solidity ^0.4.23;
2 
3 /*********************************************************************************
4  *********************************************************************************
5  *
6  * Name of the project: Senddox registration service
7  * Version: 0.8
8  * Author: Juan Livingston 
9  *
10  *********************************************************************************
11  ********************************************************************************/
12 
13  /* New ERC20 contract interface */
14 
15 contract ERC20Basic {
16 	uint256 public totalSupply;
17 	function balanceOf(address who) constant returns (uint256);
18 	function transfer(address to, uint256 value) returns (bool);
19 	event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 
23 // Interface for Storage
24 contract GlobalStorageMultiId { 
25 	uint256 public regPrice;
26 	function registerUser(bytes32 _id) payable returns(bool);
27 	function changeAddress(bytes32 _id , address _newAddress) returns(bool);
28 	function setUint(bytes32 _id , bytes32 _key , uint _data , bool _overwrite) returns(bool);
29 	function getUint(bytes32 _id , bytes32 _key) constant returns(uint);
30 	event Error(string _string);
31 	event RegisteredUser(address _address , bytes32 _id);
32 	event ChangedAdd(bytes32 _id , address _old , address _new);
33 }
34 
35 contract UpgDocs {
36 	function confirm(bytes32 _storKey) returns(bool);
37 	event DocsUpgraded(address _oldAddress,address _newAddress);
38 }
39 
40 // The Token
41 contract RegDocuments {
42 	string public version;
43 	address public admin;
44 	address public owner;
45 	uint public price;
46 	bool registered;
47 	address storageAddress;
48 	bytes32 public storKey;
49 	uint public ownerPerc;
50 
51 	GlobalStorageMultiId public Storage;
52 
53 	event RegDocument(address indexed from);
54 	event DocsUpgraded(address _oldAddress,address _newAddress);
55 	event ReceivedPayment(address indexed _address,uint256 _value);
56 
57 	// Modifiers
58 
59 	modifier onlyAdmin() {
60 		if ( msg.sender != admin && msg.sender != owner ) revert();
61 		_;
62 	}
63 
64 	modifier onlyOwner() {
65 		if ( msg.sender != owner ) revert();
66 		_;
67 	}
68 
69 
70 	// Constructor
71 	constructor() {     
72 		price = 0.01 ether;  
73 		admin = msg.sender;        
74 		owner = 0xc238ff50c09787e7b920f711850dd945a40d3232;
75 		version = "v0.6";
76 		storageAddress = 0x8f49722c61a9398a1c5f5ce6e5feeef852831a64; // Mainnet
77 		ownerPerc = 100;
78 		Storage = GlobalStorageMultiId(storageAddress);
79 	}
80 
81 
82 	// GlobalStorage functions
83 	// ----------------------------------------
84 
85 	function getStoragePrice() onlyAdmin constant returns(uint) {
86 		return Storage.regPrice();
87 	}
88 
89 	function registerDocs(bytes32 _storKey) onlyAdmin payable {
90 		// Register key with IntelligentStorage
91 		require(!registered); // It only does it one time
92 		uint _value = Storage.regPrice();
93 		storKey = _storKey;
94 		Storage.registerUser.value(_value)(_storKey);
95 		registered = true;
96 	}
97 
98 	function upgradeDocs(address _newAddress) onlyAdmin {
99 		// This is to update this contract to a new address and transfer ownership of Storage to the new address
100 		UpgDocs newDocs = UpgDocs(_newAddress);
101 		require(newDocs.confirm(storKey));
102 		Storage.changeAddress(storKey,_newAddress);
103 		_newAddress.send(this.balance);
104 	}
105 
106 	function confirm(bytes32 _storKey) returns(bool) {
107 		// This is called from older version, to register key for IntelligentStorage
108 		require(!registered);
109 		storKey = _storKey;
110 		registered = true;
111 		emit DocsUpgraded(msg.sender,this);
112 		return true;
113 	}
114 
115 	// Admin functions
116 	// -------------------------------------
117 
118 	function changeOwner(address _newOwnerAddress) onlyOwner returns(bool){
119 		owner = _newOwnerAddress;
120 		return true;
121 	}
122 
123 	function changeAdmin(address _newAdmin) onlyOwner returns(bool) {
124 		admin = _newAdmin;
125 		return true;
126 	}
127 
128 	function sendToken(address _token,address _to , uint _value) onlyOwner returns(bool) {
129 		// To send ERC20 tokens sent accidentally
130 		ERC20Basic Token = ERC20Basic(_token);
131 		require(Token.transfer(_to, _value));
132 		return true;
133 	}
134 
135 	function changePerc(uint _newperc) onlyAdmin public {
136 		ownerPerc = _newperc;
137 	}
138 
139 	function changePrice(uint _newPrice) onlyAdmin public {
140 		price = _newPrice;
141 	}
142 
143 	// Main functions
144 	// -----------------------------------------------------
145 
146 	function() payable public {
147 		// Invoked by users to pay for the service
148 		uint a = getUint(msg.sender);
149 		setUint(msg.sender, a + msg.value);
150 		owner.send(msg.value * ownerPerc / 100);
151 		if (this.balance > 0 ) admin.send(this.balance);
152 		emit ReceivedPayment(msg.sender, msg.value);
153 	}
154 
155 	function sendCredits(address[] _addresses, uint _amountEach) onlyAdmin public returns (bool success) {
156 		// Invoked by admin to give balance to users
157 		for (uint8 i=0; i<_addresses.length; i++){
158 			uint a = getUint(_addresses[i]);
159 			setUint(_addresses[i], a + _amountEach);
160 			emit ReceivedPayment(_addresses[i],_amountEach);
161 		}
162 	}
163 
164 	function getBalance(address _address) constant returns(uint) {
165 		return getUint(_address);
166 	}
167 
168 	function regDoc(address _address, string _hash) onlyAdmin returns (bool success) {
169 		uint a = getUint(_address);
170 		require(a >= price);
171 		setUint(_address, a - price);
172 		emit RegDocument(_address);
173 		return true;
174 		}
175 
176 	function getPrice() constant returns(uint) {
177 		return price;
178 	}
179 
180 	// Internal functions
181 
182 	function setUint(address _address, uint _value) internal {
183 		Storage.setUint(storKey, bytes32(_address), _value, true);
184 	}
185 
186 	function getUint(address _address) internal constant returns(uint) {
187 		return Storage.getUint(storKey, bytes32(_address));
188 
189 	}
190 
191 }