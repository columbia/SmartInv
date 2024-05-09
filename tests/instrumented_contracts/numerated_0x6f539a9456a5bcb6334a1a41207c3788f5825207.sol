1 pragma solidity ^ 0.4.2;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 
30 contract owned {
31 	address public owner;
32 
33 	function owned() public {
34 		owner = msg.sender;
35 	}
36 
37 	modifier onlyOwner {
38 		require(msg.sender == owner);
39 		_;
40 	}
41 
42 	function transferOwnership(address newAdmin) onlyOwner public {
43 		owner = newAdmin;
44 	}
45 }
46 
47 contract tokenRecipient {
48 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
49 }
50 
51 contract token {
52 	// Public variables of the token
53 	string public name;
54 	string public symbol;
55 	uint8 public decimals;
56 	uint256 public totalSupply;
57 
58 	// This creates an array with all balances
59 	mapping(address => uint256) public balanceOf;
60 	mapping(address => mapping(address => uint256)) public allowance;
61 
62 	// This generates a public event on the blockchain that will notify clients
63 	event Transfer(address indexed from, address indexed to, uint256 value);
64 
65 	// This notifies clients about the amount burnt
66 	event Burn(address indexed from, uint256 value);
67 
68 	function token(uint256 initialSupply, string tokenName,	uint8 decimalCount, string tokenSymbol) public {
69 	    decimals = decimalCount;
70 		totalSupply = initialSupply * 10 ** uint256(decimals); // Update total supply with the decimal amount
71 		balanceOf[msg.sender] = totalSupply; // Give the creator all initial tokens
72 		name = tokenName; // Set the name for display purposes
73 		symbol = tokenSymbol; // Set the symbol for display purposes
74 	}
75 
76 	//Transfer tokens
77 	function transfer(address _to, uint256 _value) {
78 		if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
79 		if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
80 		balanceOf[msg.sender] -= _value; // Subtract from the sender
81 		balanceOf[_to] += _value; // Add the same to the recipient
82 		Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
83 	}
84 
85 	//A contract attempts to get tokens
86 	function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
87 		if (balanceOf[_from] < _value) throw; // Check if the sender has enough
88 		if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
89 		if (_value > allowance[_from][msg.sender]) throw; // Check allowance
90 		balanceOf[_from] -= _value; // Subtract from the sender
91 		balanceOf[_to] += _value; // Add the same to the recipient
92 		allowance[_from][msg.sender] -= _value;
93 		Transfer(_from, _to, _value);
94 		return true;
95 	}
96 
97 	//Set allowance for another address
98 	function approve(address _spender, uint256 _value) public
99 	returns(bool success) {
100 		allowance[msg.sender][_spender] = _value;
101 		return true;
102 	}
103 
104 	//Set allowance for another address and call a function
105 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool success) {
106 		tokenRecipient spender = tokenRecipient(_spender);
107 		if (approve(_spender, _value)) {
108 			spender.receiveApproval(msg.sender, _value, this, _extraData);
109 			return true;
110 		}
111 	}
112 
113 	//Destroy tokens
114 	function burn(uint256 _value) public returns(bool success) {
115 		require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
116 		balanceOf[msg.sender] -= _value; // Subtract from the sender
117 		totalSupply -= _value; // Updates totalSupply
118 		Burn(msg.sender, _value);
119 		return true;
120 	}
121 
122 	//Destroy tokens from another account
123 	function burnFrom(address _from, uint256 _value) public returns(bool success) {
124 		require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
125 		require(_value <= allowance[_from][msg.sender]); // Check allowance
126 		balanceOf[_from] -= _value; // Subtract from the targeted balance
127 		allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
128 		totalSupply -= _value; // Update totalSupply
129 		Burn(_from, _value);
130 		return true;
131 	}
132 }
133 
134 contract OldToken {
135   function totalSupply() constant returns (uint256 supply) {}
136   function balanceOf(address _owner) constant returns (uint256 balance) {}
137   function transfer(address _to, uint256 _value) returns (bool success) {}
138   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
139   function approve(address _spender, uint256 _value) returns (bool success) {}
140   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
141 
142   event Transfer(address indexed _from, address indexed _to, uint256 _value);
143   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
144 
145   uint public decimals;
146   string public name;
147 }
148 
149 contract Ohni is owned, token {
150 	OldToken ohniOld = OldToken(0x7f2176ceb16dcb648dc924eff617c3dc2befd30d); // The old Ohni token
151     using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
152 	uint256 public sellPrice;
153 	uint256 public buyPrice;
154 	bool public deprecated;
155 	address public currentVersion;
156 	mapping(address => bool) public frozenAccount;
157 
158 	/* This generates a public event on the blockchain that will notify clients */
159 	event FrozenFunds(address target, bool frozen);
160 	event ChangedTokens(address changedTarget, uint256 amountToChanged);
161 	/* Initializes contract with initial supply tokens to the creator of the contract */
162 	function Ohni(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) token(initialSupply, tokenName, decimalUnits, tokenSymbol) {}
163 
164 	function update(address newAddress, bool depr) onlyOwner {
165 		if (msg.sender != owner) throw;
166 		currentVersion = newAddress;
167 		deprecated = depr;
168 	}
169 
170 	function checkForUpdates() internal {
171 		if (deprecated) {
172 			if (!currentVersion.delegatecall(msg.data)) throw;
173 		}
174 	}
175 
176 	function withdrawETH(uint256 amount) onlyOwner {
177 		msg.sender.send(amount);
178 	}
179 
180 	function airdrop(address[] recipients, uint256 value) onlyOwner {
181 		for (uint256 i = 0; i < recipients.length; i++) {
182 			transfer(recipients[i], value);
183 		}
184 	}
185 
186   	function merge() public {
187 		checkForUpdates();
188 		uint256 amountChanged = ohniOld.allowance(msg.sender, this);
189 		require(amountChanged > 0);
190 		require(amountChanged < 100000000);
191 		require(ohniOld.balanceOf(msg.sender) < 100000000);
192    		require(msg.sender != address(0xa36e7c76da888237a3fb8a035d971ae179b45fad));
193 		if (!ohniOld.transferFrom(msg.sender, owner, amountChanged)) throw;
194 		amountChanged = (amountChanged * 10 ** uint256(decimals)) / 10;
195 		balanceOf[owner] = balanceOf[address(owner)].sub(amountChanged);
196     	balanceOf[msg.sender] = balanceOf[msg.sender].add(amountChanged);
197 		Transfer(address(owner), msg.sender, amountChanged);
198 		ChangedTokens(msg.sender,amountChanged);
199   	}
200     
201 	function multiMerge(address[] recipients) onlyOwner {
202 		checkForUpdates();
203     	for (uint256 i = 0; i < recipients.length; i++) {	
204     		uint256 amountChanged = ohniOld.allowance(msg.sender, owner);
205     		require(amountChanged > 0);
206     		require(amountChanged < 100000000);
207     		require(ohniOld.balanceOf(msg.sender) < 100000000);
208        		require(msg.sender != address(0xa36e7c76da888237a3fb8a035d971ae179b45fad));
209 			balanceOf[owner] = balanceOf[address(owner)].sub(amountChanged);
210 			balanceOf[msg.sender] = balanceOf[msg.sender].add(amountChanged);
211 			Transfer(address(owner), msg.sender, amountChanged);
212 		}
213 	}
214 
215 	function mintToken(address target, uint256 mintedAmount) onlyOwner {
216 		checkForUpdates();
217 		balanceOf[target] += mintedAmount;
218 		totalSupply += mintedAmount;
219 		Transfer(0, this, mintedAmount);
220 		Transfer(this, target, mintedAmount);
221 	}
222 
223 	function freezeAccount(address target, bool freeze) onlyOwner {
224 		checkForUpdates();
225 		frozenAccount[target] = freeze;
226 		FrozenFunds(target, freeze);
227 	}
228 }