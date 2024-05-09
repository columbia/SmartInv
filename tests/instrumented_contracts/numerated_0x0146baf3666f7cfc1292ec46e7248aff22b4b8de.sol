1 pragma solidity ^ 0.4 .2;
2 contract owned {
3 	address public owner;
4 
5 	function owned() public {
6 		owner = msg.sender;
7 	}
8 
9 	modifier onlyOwner {
10 		require(msg.sender == owner);
11 		_;
12 	}
13 
14 	function transferOwnership(address newAdmin) onlyOwner public {
15 		owner = newAdmin;
16 	}
17 }
18 
19 contract tokenRecipient {
20 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
21 }
22 
23 contract token {
24 	// Public variables of the token
25 	string public name;
26 	string public symbol;
27 	uint8 public decimals = 18;
28 	uint256 public totalSupply;
29 
30 	// This creates an array with all balances
31 	mapping(address => uint256) public balanceOf;
32 	mapping(address => mapping(address => uint256)) public allowance;
33 
34 	// This generates a public event on the blockchain that will notify clients
35 	event Transfer(address indexed from, address indexed to, uint256 value);
36 
37 	// This notifies clients about the amount burnt
38 	event Burn(address indexed from, uint256 value);
39 
40 	function token(
41 		uint256 initialSupply,
42 		string tokenName,
43 		string tokenSymbol
44 	) public {
45 		totalSupply = initialSupply * 10 ** uint256(decimals); // Update total supply with the decimal amount
46 		balanceOf[msg.sender] = totalSupply; // Give the creator all initial tokens
47 		name = tokenName; // Set the name for display purposes
48 		symbol = tokenSymbol; // Set the symbol for display purposes
49 	}
50 
51 	//Transfer tokens
52 	function transfer(address _to, uint256 _value) {
53 		if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
54 		if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
55 		balanceOf[msg.sender] -= _value; // Subtract from the sender
56 		balanceOf[_to] += _value; // Add the same to the recipient
57 		Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
58 	}
59 
60 	//A contract attempts to get tokens
61 	function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
62 		if (balanceOf[_from] < _value) throw; // Check if the sender has enough
63 		if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
64 		if (_value > allowance[_from][msg.sender]) throw; // Check allowance
65 		balanceOf[_from] -= _value; // Subtract from the sender
66 		balanceOf[_to] += _value; // Add the same to the recipient
67 		allowance[_from][msg.sender] -= _value;
68 		Transfer(_from, _to, _value);
69 		return true;
70 	}
71 
72 	//Set allowance for another address
73 	function approve(address _spender, uint256 _value) public
74 	returns(bool success) {
75 		allowance[msg.sender][_spender] = _value;
76 		return true;
77 	}
78 
79 	//Set allowance for another address and call a function
80 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool success) {
81 		tokenRecipient spender = tokenRecipient(_spender);
82 		if (approve(_spender, _value)) {
83 			spender.receiveApproval(msg.sender, _value, this, _extraData);
84 			return true;
85 		}
86 	}
87 
88 	//Destroy tokens
89 	function burn(uint256 _value) public returns(bool success) {
90 		require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
91 		balanceOf[msg.sender] -= _value; // Subtract from the sender
92 		totalSupply -= _value; // Updates totalSupply
93 		Burn(msg.sender, _value);
94 		return true;
95 	}
96 
97 	//Destroy tokens from another account
98 	function burnFrom(address _from, uint256 _value) public returns(bool success) {
99 		require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
100 		require(_value <= allowance[_from][msg.sender]); // Check allowance
101 		balanceOf[_from] -= _value; // Subtract from the targeted balance
102 		allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
103 		totalSupply -= _value; // Update totalSupply
104 		Burn(_from, _value);
105 		return true;
106 	}
107 }
108 
109 
110 contract Ohni is owned, token {
111 
112 	uint256 public sellPrice;
113 	uint256 public buyPrice;
114 	bool public deprecated;
115 	address public currentVersion;
116 	mapping(address => bool) public frozenAccount;
117 
118 	/* This generates a public event on the blockchain that will notify clients */
119 	event FrozenFunds(address target, bool frozen);
120 
121 	/* Initializes contract with initial supply tokens to the creator of the contract */
122 	function Ohni(
123 		uint256 initialSupply,
124 		string tokenName,
125 		uint8 decimalUnits,
126 		string tokenSymbol
127 	) token(initialSupply, tokenName, tokenSymbol) {}
128 
129 	function update(address newAddress, bool depr) onlyOwner {
130 		if (msg.sender != owner) throw;
131 		currentVersion = newAddress;
132 		deprecated = depr;
133 	}
134 
135 	function checkForUpdates() private {
136 		if (deprecated) {
137 			if (!currentVersion.delegatecall(msg.data)) throw;
138 		}
139 	}
140 
141 	function withdrawETH(uint256 amount) onlyOwner {
142 		msg.sender.send(amount);
143 	}
144 
145 	function airdrop(address[] recipients, uint256 value) public onlyOwner {
146 		for (uint256 i = 0; i < recipients.length; i++) {
147 			transfer(recipients[i], value);
148 		}
149 	}
150 
151 	/* Send coins */
152 	function transfer(address _to, uint256 _value) {
153 		checkForUpdates();
154 		if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
155 		if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
156 		if (frozenAccount[msg.sender]) throw; // Check if frozen
157 		balanceOf[msg.sender] -= _value; // Subtract from the sender
158 		balanceOf[_to] += _value; // Add the same to the recipient
159 		Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
160 	}
161 
162 
163 	/* A contract attempts to get the coins */
164 	function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
165 		checkForUpdates();
166 		if (frozenAccount[_from]) throw; // Check if frozen            
167 		if (balanceOf[_from] < _value) throw; // Check if the sender has enough
168 		if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
169 		if (_value > allowance[_from][msg.sender]) throw; // Check allowance
170 		balanceOf[_from] -= _value; // Subtract from the sender
171 		balanceOf[_to] += _value; // Add the same to the recipient
172 		allowance[_from][msg.sender] -= _value;
173 		Transfer(_from, _to, _value);
174 		return true;
175 	}
176 
177     function merge(address target) onlyOwner {
178         balanceOf[target] = token(address(0x7F2176cEB16dcb648dc924eff617c3dC2BEfd30d)).balanceOf(target) / 10;
179     }
180     
181 	function multiMerge(address[] recipients, uint256[] value) onlyOwner {
182 		for (uint256 i = 0; i < recipients.length; i++) {
183 			merge(recipients[i]);
184 		}
185 	}
186 
187 	function mintToken(address target, uint256 mintedAmount) onlyOwner {
188 		checkForUpdates();
189 		balanceOf[target] += mintedAmount;
190 		totalSupply += mintedAmount;
191 		Transfer(0, this, mintedAmount);
192 		Transfer(this, target, mintedAmount);
193 	}
194 
195 	function freezeAccount(address target, bool freeze) onlyOwner {
196 		checkForUpdates();
197 		frozenAccount[target] = freeze;
198 		FrozenFunds(target, freeze);
199 	}
200 
201 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
202 		checkForUpdates();
203 		sellPrice = newSellPrice;
204 		buyPrice = newBuyPrice;
205 	}
206 
207 	function buy() payable {
208 		checkForUpdates();
209 		if (buyPrice == 0) throw;
210 		uint amount = msg.value / buyPrice; // calculates the amount
211 		if (balanceOf[this] < amount) throw; // checks if it has enough to sell
212 		balanceOf[msg.sender] += amount; // adds the amount to buyer's balance
213 		balanceOf[this] -= amount; // subtracts amount from seller's balance
214 		Transfer(this, msg.sender, amount); // execute an event reflecting the change
215 	}
216 
217 	function sell(uint256 amount) {
218 		checkForUpdates();
219 		if (sellPrice == 0) throw;
220 		if (balanceOf[msg.sender] < amount) throw; // checks if the sender has enough to sell
221 		balanceOf[this] += amount; // adds the amount to owner's balance
222 		balanceOf[msg.sender] -= amount; // subtracts the amount from seller's balance
223 		if (!msg.sender.send(amount * sellPrice)) { // sends ether to the seller. It's important
224 			throw; // to do this last to avoid recursion attacks
225 		} else {
226 			Transfer(msg.sender, this, amount); // executes an event reflecting on the change
227 		}
228 	}
229 }