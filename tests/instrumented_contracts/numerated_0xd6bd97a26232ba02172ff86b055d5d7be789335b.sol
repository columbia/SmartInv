1 contract TokenRecipient { 
2 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
3 } 
4 
5 contract IERC20Token {     
6 
7 	/// @return total amount of tokens     
8 	function totalSupply() constant returns (uint256 totalSupply);     
9 
10 	/// @param _owner The address from which the balance will be retrieved     
11 	/// @return The balance     
12 	function balanceOf(address _owner) constant returns (uint256 balance) {}     
13 
14 	/// @notice send `_value` token to `_to` from `msg.sender`     
15 	/// @param _to The address of the recipient     
16 	/// @param _value The amount of token to be transferred     
17 	/// @return Whether the transfer was successful or not     
18 	function transfer(address _to, uint256 _value) returns (bool success) {}     
19 
20 	/// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`     
21 	/// @param _from The address of the sender     
22 	/// @param _to The address of the recipient     
23 	/// @param _value The amount of token to be transferred     
24 	/// @return Whether the transfer was successful or not     
25 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}     
26 
27 	/// @notice `msg.sender` approves `_addr` to spend `_value` tokens     
28 	/// @param _spender The address of the account able to transfer the tokens     
29 	/// @param _value The amount of wei to be approved for transfer     
30 	/// @return Whether the approval was successful or not     
31 	function approve(address _spender, uint256 _value) returns (bool success) {}     
32 
33 	/// @param _owner The address of the account owning tokens     
34 	/// @param _spender The address of the account able to transfer the tokens     
35 	/// @return Amount of remaining tokens allowed to spent     
36 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}       
37 
38 	event Transfer(address indexed _from, address indexed _to, uint256 _value);     
39 	event Approval(address indexed _owner, address indexed _spender, uint256 _value); 
40 } 
41 
42 contract OrmeCash is IERC20Token {         
43   
44 	string public name = "OrmeCash";
45 	string public symbol = "OMC";
46 	uint8 public decimals = 18;
47 	uint256 public tokenFrozenUntilBlock;
48 	address public owner;
49 	uint public mintingCap = 2000000000 * 10**18;
50    
51 	uint256 supply = 0;
52 	mapping (address => uint256) balances;
53 	mapping (address => mapping (address => uint256)) allowances;
54 	mapping (address => bool) restrictedAddresses;
55    
56 	event Mint(address indexed _to, uint256 _value);
57 	event Burn(address indexed _from, uint256 _value);
58 	event TokenFrozen(uint256 _frozenUntilBlock);
59 
60 	modifier onlyOwner {
61 		require(msg.sender == owner);
62 		_;
63 	}
64 
65 	function OrmeCash() public {
66 		restrictedAddresses[0x0] = true;
67 		restrictedAddresses[address(this)] = true;
68 		owner = msg.sender;
69 	}         
70   
71 	function totalSupply() constant public returns (uint256 totalSupply) {         
72 		return supply;     
73 	}         
74 
75 	function balanceOf(address _owner) constant public returns (uint256 balance) {         
76 		return balances[_owner];     
77 	}     
78  
79 	function transfer(address _to, uint256 _value) public returns (bool success) {     	
80 		require (block.number >= tokenFrozenUntilBlock);
81 		require (!restrictedAddresses[_to]);
82 		require (balances[msg.sender] >= _value);
83 		require (balances[_to] + _value > balances[_to]);
84 		balances[msg.sender] -= _value;
85 		balances[_to] += _value;
86 		Transfer(msg.sender, _to, _value);       
87 		return true;
88 	}
89 
90 	function approve(address _spender, uint256 _value) public returns (bool success) {     	
91 		require (block.number >= tokenFrozenUntilBlock);
92 		allowances[msg.sender][_spender] = _value;
93 		Approval(msg.sender, _spender, _value);
94 		return true;     
95 	}     
96 
97 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {            
98 		TokenRecipient spender = TokenRecipient(_spender);      
99 		approve(_spender, _value);
100 		spender.receiveApproval(msg.sender, _value, this, _extraData);    
101 		return true;     
102 	}     
103 
104 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {     	
105 		require (block.number >= tokenFrozenUntilBlock);
106 		require (!restrictedAddresses[_to]);
107 		require (balances[_from] >= _value); 
108 		require (balances[_to] + _value >= balances[_to]);     
109 		require (_value <= allowances[_from][msg.sender]);     
110 		balances[_from] -= _value;
111 		balances[_to] += _value;    
112 		allowances[_from][msg.sender] -= _value; 
113 		Transfer(_from, _to, _value);  
114 		return true;
115 	}         
116 
117 	function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {         
118 		return allowances[_owner][_spender];     
119 	}         
120     
121 	function mintTokens(address _to, uint256 _amount) onlyOwner public {
122 		require (!restrictedAddresses[_to]);
123 		require (_amount != 0);
124 		require (balances[_to] + _amount > balances[_to]);
125 		require (mintingCap >= supply + _amount);
126 		supply += _amount;
127 		balances[_to] += _amount;
128 		Mint(_to, _amount);
129 		Transfer(0x0, _to, _amount);
130 	}
131 
132 	function burnTokens(uint _amount) public {
133 		require(_amount <= balanceOf(msg.sender));
134 		supply -= _amount;
135 		balances[msg.sender] -= _amount;
136 		Transfer(msg.sender, 0x0, _amount);
137 		Burn(msg.sender, _amount);
138 	}
139 
140 	function freezeTransfersUntil(uint256 _frozenUntilBlock) onlyOwner public {     	
141 		tokenFrozenUntilBlock = _frozenUntilBlock;     	
142 		TokenFrozen(_frozenUntilBlock);     
143 	}     
144 
145 	function editRestrictedAddress(address _newRestrictedAddress) onlyOwner public {
146 		restrictedAddresses[_newRestrictedAddress] = !restrictedAddresses[_newRestrictedAddress];
147 	}
148 
149 	function isRestrictedAddress(address _querryAddress) constant public returns (bool answer){
150 		return restrictedAddresses[_querryAddress];
151 	}
152 
153 	function transferOwnership(address newOwner) onlyOwner public {
154 		owner = newOwner;
155 	}
156 
157 	function killContract() onlyOwner public {
158 		selfdestruct(msg.sender);
159 	}
160 }