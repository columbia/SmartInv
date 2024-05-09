1 pragma solidity ^0.4.23;
2 
3 /*********************************************************************************
4  *********************************************************************************
5  *
6  * Name of the project: Senddox registration service
7  * Version: 0.6
8  * Author: Ethernity.live 
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
49 	uint public adminPerc;
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
76 		// storageAddress = 0xabc66b985ce66ba651f199555dd4236dbcd14daa; // Kovan
77 		// storageAddress = 0xb94cde73d07e0fcd7768cd0c7a8fb2afb403327a; // Rinkeby
78 		storageAddress = 0x8f49722c61a9398a1c5f5ce6e5feeef852831a64; // Mainnet
79 		adminPerc = 2;
80 		Storage = GlobalStorageMultiId(storageAddress);
81 	}
82 
83 
84 	// GlobalStorage functions
85 	// ----------------------------------------
86 
87 	function getStoragePrice() onlyAdmin constant returns(uint) {
88 		return Storage.regPrice();
89 	}
90 
91 	function registerDocs(bytes32 _storKey) onlyAdmin payable {
92 		// Register key with IntelligentStorage
93 		require(!registered); // It only does it one time
94 		uint _value = Storage.regPrice();
95 		storKey = _storKey;
96 		Storage.registerUser.value(_value)(_storKey);
97 		registered = true;
98 	}
99 
100 	function upgradeDocs(address _newAddress) onlyAdmin {
101 		// This is to update this contract to a new address and transfer ownership of Storage to the new address
102 		UpgDocs newDocs = UpgDocs(_newAddress);
103 		require(newDocs.confirm(storKey));
104 		Storage.changeAddress(storKey,_newAddress);
105 		_newAddress.send(this.balance);
106 	}
107 
108 	function confirm(bytes32 _storKey) returns(bool) {
109 		// This is called from older version, to register key for IntelligentStorage
110 		require(!registered);
111 		storKey = _storKey;
112 		registered = true;
113 		emit DocsUpgraded(msg.sender,this);
114 		return true;
115 	}
116 
117 	// Admin functions
118 	// -------------------------------------
119 
120 	function changeOwner(address _newOwnerAddress) onlyOwner returns(bool){
121 		owner = _newOwnerAddress;
122 		return true;
123 	}
124 
125 	function changeAdmin(address _newAdmin) onlyOwner returns(bool) {
126 		admin = _newAdmin;
127 		return true;
128 	}
129 
130 	function sendToken(address _token,address _to , uint _value) onlyOwner returns(bool) {
131 		// To send ERC20 tokens sent accidentally
132 		ERC20Basic Token = ERC20Basic(_token);
133 		require(Token.transfer(_to, _value));
134 		return true;
135 	}
136 
137 	function changePerc(uint _newperc) onlyAdmin public {
138 		adminPerc = _newperc;
139 	}
140 
141 	function changePrice(uint _newPrice) onlyAdmin public {
142 		price = _newPrice;
143 	}
144 
145 	// Main functions
146 	// -----------------------------------------------------
147 
148 	function() payable public {
149 		// Invoked by users to pay for the service
150 		uint a = getUint(msg.sender);
151 		setUint(msg.sender, a + msg.value);
152 		admin.send(msg.value * adminPerc / 100);
153 		owner.send(this.balance);
154 		emit ReceivedPayment(msg.sender, msg.value);
155 	}
156 
157 	function sendCredits(address[] _addresses, uint _amountEach) onlyAdmin public returns (bool success) {
158 		// Invoked by admin to give balance to users
159 		for (uint8 i=0; i<_addresses.length; i++){
160 			uint a = getUint(_addresses[i]);
161 			setUint(_addresses[i], a + _amountEach);
162 			emit ReceivedPayment(_addresses[i],_amountEach);
163 		}
164 	}
165 
166 	function getBalance(address _address) constant returns(uint) {
167 		return getUint(_address);
168 	}
169 
170 	function regDoc(address _address, string _hash) onlyAdmin returns (bool success) {
171 		uint a = getUint(_address);
172 		require(a >= price);
173 		setUint(_address, a - price);
174 		emit RegDocument(_address);
175 		return true;
176 		}
177 
178 	function getPrice() constant returns(uint) {
179 		return price;
180 	}
181 
182 	// Internal functions
183 
184 	function setUint(address _address, uint _value) internal {
185 		Storage.setUint(storKey, bytes32(_address), _value, true);
186 	}
187 
188 	function getUint(address _address) internal constant returns(uint) {
189 		return Storage.getUint(storKey, bytes32(_address));
190 
191 	}
192 
193 }