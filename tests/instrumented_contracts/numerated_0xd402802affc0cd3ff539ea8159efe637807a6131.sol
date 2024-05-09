1 pragma solidity ^0.4.24;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function assert(bool assertion) internal {
32     if (!assertion) {
33       throw;
34     }
35   }
36 }
37 contract BNB is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42 	address public owner;
43 
44     /* This creates an array with all balances */
45     mapping (address => uint256) public balanceOf;
46 	mapping (address => uint256) public freezeOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     /* This generates a public event on the blockchain that will notify clients */
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     /* This notifies clients about the amount burnt */
53     event Burn(address indexed from, uint256 value);
54 	
55 	/* This notifies clients about the amount frozen */
56     event Freeze(address indexed from, uint256 value);
57 	
58 	/* This notifies clients about the amount unfrozen */
59     event Unfreeze(address indexed from, uint256 value);
60 
61     /* Initializes contract with initial supply tokens to the creator of the contract */
62     function BNB(
63         uint256 initialSupply,
64         string tokenName,
65         uint8 decimalUnits,
66         string tokenSymbol
67         ) {
68         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
69         totalSupply = initialSupply;                        // Update total supply
70         name = tokenName;                                   // Set the name for display purposes
71         symbol = tokenSymbol;                               // Set the symbol for display purposes
72         decimals = decimalUnits;                            // Amount of decimals for display purposes
73 		owner = msg.sender;
74     }
75 
76     /* Send coins */
77     function transfer(address _to, uint256 _value) {
78         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
79 		if (_value <= 0) throw; 
80         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
82         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
83         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
84         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
85     }
86 
87     /* Allow another contract to spend some tokens in your behalf */
88     function approve(address _spender, uint256 _value)
89         returns (bool success) {
90 		if (_value <= 0) throw; 
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94        
95 
96     /* A contract attempts to get the coins */
97     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
98         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
99 		if (_value <= 0) throw; 
100         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
101         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
102         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
103         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
104         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
105         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
106         Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     function burn(uint256 _value) returns (bool success) {
111         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
112 		if (_value <= 0) throw; 
113         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
114         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
115         Burn(msg.sender, _value);
116         return true;
117     }
118 	
119 	function freeze(uint256 _value) returns (bool success) {
120         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
121 		if (_value <= 0) throw; 
122         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
123         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
124         Freeze(msg.sender, _value);
125         return true;
126     }
127 	
128 	function unfreeze(uint256 _value) returns (bool success) {
129         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
130 		if (_value <= 0) throw; 
131         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
132 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
133         Unfreeze(msg.sender, _value);
134         return true;
135     }
136 	
137 	// transfer balance to owner
138 	function withdrawEther(uint256 amount) {
139 		if(msg.sender != owner)throw;
140 		owner.transfer(amount);
141 	}
142 	
143 	// can accept ether
144 	function() payable {
145     }
146 }