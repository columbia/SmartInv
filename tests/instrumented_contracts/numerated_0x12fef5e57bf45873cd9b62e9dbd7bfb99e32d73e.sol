1 pragma solidity ^0.4.11;
2 
3 contract owned {
4 
5 	address public owner;
6 
7 	function owned() {
8 		owner = msg.sender;
9 	}
10 
11 	modifier onlyOwner {
12 		if (msg.sender != owner) throw;
13 		_;
14 	}
15 
16 	function transferOwnership(address newOwner) onlyOwner {
17 		owner = newOwner;
18 	}
19 }
20 
21 contract tokenRecipient { 
22 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
23 } 
24 
25 contract IERC20Token {     
26 
27 	/// @return total amount of tokens     
28 	function totalSupply() constant returns (uint256 totalSupply);     
29 
30 	/// @param _owner The address from which the balance will be retrieved     
31 	/// @return The balance     
32 	function balanceOf(address _owner) constant returns (uint256 balance) {}     
33 
34 	/// @notice send `_value` token to `_to` from `msg.sender`     
35 	/// @param _to The address of the recipient     
36 	/// @param _value The amount of token to be transferred     
37 	/// @return Whether the transfer was successful or not     
38 	function transfer(address _to, uint256 _value) returns (bool success) {}     
39 
40 	/// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`     
41 	/// @param _from The address of the sender     
42 	/// @param _to The address of the recipient     
43 	/// @param _value The amount of token to be transferred     
44 	/// @return Whether the transfer was successful or not     
45 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}     
46 
47 	/// @notice `msg.sender` approves `_addr` to spend `_value` tokens     
48 	/// @param _spender The address of the account able to transfer the tokens     
49 	/// @param _value The amount of wei to be approved for transfer     
50 	/// @return Whether the approval was successful or not     
51 	function approve(address _spender, uint256 _value) returns (bool success) {}     
52 
53 	/// @param _owner The address of the account owning tokens     
54 	/// @param _spender The address of the account able to transfer the tokens     
55 	/// @return Amount of remaining tokens allowed to spent     
56 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}       
57 
58 	event Transfer(address indexed _from, address indexed _to, uint256 _value);     
59 	event Approval(address indexed _owner, address indexed _spender, uint256 _value); 
60 } 
61 
62 contract CofounditToken is IERC20Token, owned{         
63 
64 	/* Public variables of the token */     
65 	string public standard = "Cofoundit token v1.0";     
66 	string public name = "Cofoundit";     
67 	string public symbol = "CFI";     
68 	uint8 public decimals = 18;     
69 	address public icoContractAddress;     
70 	uint256 public tokenFrozenUntilBlock;     
71 
72 	/* Private variables of the token */     
73 	uint256 supply = 0;     
74 	mapping (address => uint256) balances;     
75 	mapping (address => mapping (address => uint256)) allowances;     
76 	mapping (address => bool) restrictedAddresses;     
77 
78 	/* Events */       
79 	event Mint(address indexed _to, uint256 _value);     
80 	event TokenFrozen(uint256 _frozenUntilBlock, string _reason);     
81 
82 	/* Initializes contract and  sets restricted addresses */     
83 	function CofounditToken(address _icoAddress) {         
84 		restrictedAddresses[0x0] = true;			// Users cannot send tokens to 0x0 address         
85 		restrictedAddresses[_icoAddress] = true;	// Users cannot send tokens to ico contract         
86 		restrictedAddresses[address(this)] = true;	// Users cannot sent tokens to this contracts address                 
87 		icoContractAddress = _icoAddress;			// Sets ico contract address from where mints will happen     
88 	}         
89 
90 	/* Get total supply of issued coins */     
91 	function totalSupply() constant returns (uint256 totalSupply) {         
92 		return supply;     
93 	}         
94 
95 	/* Get balance of specific address */     
96 	function balanceOf(address _owner) constant returns (uint256 balance) {         
97 		return balances[_owner];     
98 	}     
99 
100 	/* Send coins */     
101 	function transfer(address _to, uint256 _value) returns (bool success) {     	
102 		if (block.number < tokenFrozenUntilBlock) throw;	// Throw is token is frozen in case of emergency         
103 		if (restrictedAddresses[_to]) throw;                // Prevent transfer to restricted addresses         
104 		if (balances[msg.sender] < _value) throw;           // Check if the sender has enough         
105 		if (balances[_to] + _value < balances[_to]) throw;  // Check for overflows         
106 		balances[msg.sender] -= _value;                     // Subtract from the sender         
107 		balances[_to] += _value;                            // Add the same to the recipient         
108 		Transfer(msg.sender, _to, _value);                  // Notify anyone listening that this transfer took place         
109 		return true;     
110 	}     
111 
112 	/* Allow another contract to spend some tokens in your behalf */     
113 	function approve(address _spender, uint256 _value) returns (bool success) {     	
114 		if (block.number < tokenFrozenUntilBlock) throw;	// Throw is token is frozen in case of emergency         
115 		allowances[msg.sender][_spender] = _value;          // Set allowance         
116 		Approval(msg.sender, _spender, _value);             // Raise Approval event         
117 		return true;     
118 	}     
119 
120 	/* Approve and then comunicate the approved contract in a single tx */     
121 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {            
122 		tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract         
123 		approve(_spender, _value);                                      // Set approval to contract for _value         
124 		spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract         
125 		return true;     
126 	}     
127 
128 	/* A contract attempts to get the coins */     
129 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {     	
130 		if (block.number < tokenFrozenUntilBlock) throw;	// Throw is token is frozen in case of emergency         
131 		if (restrictedAddresses[_to]) throw;                // Prevent transfer to restricted addresses         
132 		if (balances[_from] < _value) throw;                // Check if the sender has enough         
133 		if (balances[_to] + _value < balances[_to]) throw;  // Check for overflows         
134 		if (_value > allowances[_from][msg.sender]) throw;  // Check allowance         
135 		balances[_from] -= _value;                          // Subtract from the sender         
136 		balances[_to] += _value;                            // Add the same to the recipient         
137 		allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address         
138 		Transfer(_from, _to, _value);                       // Notify anyone listening that this transfer took place         
139 		return true;     
140 	}         
141 
142 	/* Get the ammount of remaining tokens to spend */     
143 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {         
144 		return allowances[_owner][_spender];     
145 	}         
146 
147 	/* Create new tokens*/     
148 	function mintTokens(address _to, uint256 _amount, string _reason) {         
149 		if (msg.sender != icoContractAddress) throw;			// Check if minter is ico Contract address         
150 		if (restrictedAddresses[_to]) throw;                    // Prevent transfer to restricted addresses         
151 		if (_amount == 0 || sha3(_reason) == sha3("")) throw;   // Check if values are not null;         
152 		if (balances[_to] + _amount < balances[_to]) throw;     // Check for overflows         
153 		supply += _amount;                                      // Update total supply         
154 		balances[_to] += _amount;                    		    // Set minted coins to target         
155 		Mint(_to, _amount);                          		    // Create Mint event         
156 		Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x     
157 	}     
158 
159 	/* Stops all token transfers in case of emergency */     
160 	function freezeTransfersUntil(uint256 _frozenUntilBlock, string _reason) onlyOwner {     	
161 		tokenFrozenUntilBlock = _frozenUntilBlock;     	
162 		TokenFrozen(_frozenUntilBlock, _reason);     
163 	}     
164 	
165 	/* Owner can add new restricted address or removes one */
166 	function editRestrictedAddress(address _newRestrictedAddress) onlyOwner {
167 		restrictedAddresses[_newRestrictedAddress] = !restrictedAddresses[_newRestrictedAddress];
168 	}
169 
170 	function isRestrictedAddress(address _querryAddress) constant returns (bool answer){
171 		return restrictedAddresses[_querryAddress];
172 	}
173 
174 	/* This unnamed function is called whenever someone tries to send ether to it */     
175 
176 	function () {         
177 		throw;     // Prevents accidental sending of ether     
178 	} 
179 
180 	//
181 	/* This part is here only for testing and will not be included into final version */
182 	//
183 
184 	//function changeICOAddress(address _newAddress) onlyOwner{
185 	//	icoContractAddress = _newAddress;
186 	//}
187 
188 	//function killContract() onlyOwner{
189 	//	selfdestruct(msg.sender);
190 	//}
191 }