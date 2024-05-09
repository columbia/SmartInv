1 pragma solidity ^0.4.8;
2 
3 /* Math operations with safety checks */
4 contract SafeMath {
5 	function safeMul(uint256 a, uint256 b) internal returns (uint256) {
6 		uint256 c = a * b;
7 		assert(a == 0 || c / a == b);
8 		return c;
9 	}
10 	function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
11 		assert(b > 0);
12 		uint256 c = a / b;
13 		assert(a == b * c + a % b);
14 		return c; 
15 	}
16 	function safeSub(uint256 a, uint256 b) internal returns (uint256) {
17 		assert(b <= a);
18 		return a - b; 
19 	}
20 	function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
21 		uint256 c = a + b;
22 		assert(c>=a && c>=b);
23 		return c;
24 	}
25 	function assert(bool assertion) internal {
26 		if (!assertion) {
27 			throw; 
28 		}
29 	}
30 }
31 
32 /* SGCC ERC20 Token */
33 contract SGCC is SafeMath { 
34 	string public name;
35 	string public symbol;
36 	uint8 public decimals;
37 	uint256 public totalSupply;
38 	address public owner;
39 	
40 	/* This creates an array with all balances */
41 	mapping (address => uint256) public balanceOf;
42 	mapping (address => uint256) public freezeOf;
43 	mapping (address => mapping (address => uint256)) public allowance;
44 	
45 	/* This generates a public event for notifying clients of transfers */ 
46 	event Transfer(address indexed from, address indexed to, uint256 value);
47 	/* This notifies clients about the amount burnt */ 
48 	event Burn(address indexed from, uint256 value);
49 	/* This notifies clients about the amount frozen */ 
50 	event Freeze(address indexed from, uint256 value);
51 	/* This notifies clients about the amount unfrozen */ 
52 	event Unfreeze(address indexed from, uint256 value);
53 
54 	/* Initializes contract with initial supply of tokens to the creator of the contract */ 
55 	function SGCC() public {
56 		decimals = 18;
57 		balanceOf[msg.sender] = 20000000000 * (10 ** uint256(decimals)); // Give the creator all initial tokens
58 		totalSupply = 20000000000 * (10 ** uint256(decimals)); // Update total supply
59 		name = 'SGCC'; // Set the name for display purposes
60 		symbol = 'SGCC'; // Set the symbol for display purposes
61 		owner = msg.sender;
62 	}
63 
64 	/* Send coins from the caller's account */
65 	function transfer(address _to, uint256 _value) public {
66 		if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead 
67 		if (_value <= 0) throw;
68 		if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
69 		if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows 
70 		balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
71 		balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); // Add the same to the recipient
72 		Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
73 	}
74 	
75 	/* Allow another account to withdraw up to some number of coins from the caller */
76 	function approve(address _spender, uint256 _value) public returns (bool success) {
77 		if (_value <= 0) throw;
78 		allowance[msg.sender][_spender] = _value;
79 		return true;
80 	}
81 	
82 	/* Send coins from an account that previously approved this caller to do so */
83 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84 		if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
85 		if (_value <= 0) throw;
86 		if (balanceOf[_from] < _value) throw; // Check if the sender has enough 
87 		if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
88 		if (_value > allowance[_from][msg.sender]) throw; // Check allowance 
89 		balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value); // Subtract from the sender
90 		balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); // Add the same to the recipient
91 		allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value); 
92 		Transfer(_from, _to, _value); // emit event
93 		return true;
94 	}
95 	
96 	/* Permanently delete some number of coins that are in the caller's account */
97 	function burn(uint256 _value) public returns (bool success) {
98 		if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
99 		if (_value <= 0) throw;
100 		balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
101 		totalSupply = SafeMath.safeSub(totalSupply,_value); // Reduce the total supply too
102 		Burn(msg.sender, _value); // emit event
103 		return true;
104 	}
105 
106 	/* Make some of the caller's coins temporarily unavailable */
107 	function freeze(uint256 _value) public returns (bool success) {
108 		if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
109 		if (_value <= 0) throw;
110 		balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
111 		freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value); // Add to sender's frozen balance
112 		Freeze(msg.sender, _value); // emit event
113 		return true;
114 	}
115 
116 	/* Frozen coins can be made available again by unfreezing them */
117 	function unfreeze(uint256 _value) public returns (bool success) {
118 		if (freezeOf[msg.sender] < _value) throw; // Check if the sender has enough
119 		if (_value <= 0) throw;
120 		freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value); // Subtract from sender's frozen balance
121 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value); // Add to the sender
122 		Unfreeze(msg.sender, _value); // emit event
123 		return true; 
124 	}
125 
126 	function withdrawEther(uint256 amount) public {
127 		// disabled
128 	}
129 	function() public payable {}
130 }