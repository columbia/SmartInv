1 pragma solidity ^0.4.8;
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
37 contract BBY is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals =8;
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
62     function BBY(
63         uint256 initialSupply,
64         string tokenName,
65         string tokenSymbol
66         ) {
67         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
68         totalSupply = initialSupply;                        // Update total supply
69         name = tokenName;                                   // Set the name for display purposes
70         symbol = tokenSymbol;                               // Set the symbol for display purposes
71 	owner = msg.sender;
72     }
73 
74     /* Send coins */
75     function transfer(address _to, uint256 _value) {
76         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
77 		if (_value <= 0) throw; 
78         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
79         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
80         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
81         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
82         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
83     }
84 
85     /* Allow another contract to spend some tokens in your behalf */
86     function approve(address _spender, uint256 _value)
87         returns (bool success) {
88 		if (_value <= 0) throw; 
89         allowance[msg.sender][_spender] = _value;
90         return true;
91     }
92        
93 
94     /* A contract attempts to get the coins */
95     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
96         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
97 		if (_value <= 0) throw; 
98         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
99         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
100         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
101         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
102         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
103         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
104         Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function burn(uint256 _value) returns (bool success) {
109         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
110 		if (_value <= 0) throw; 
111         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
112         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
113         Burn(msg.sender, _value);
114         return true;
115     }
116 	
117 	function freeze(uint256 _value) returns (bool success) {
118         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
119 		if (_value <= 0) throw; 
120         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
121         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
122         Freeze(msg.sender, _value);
123         return true;
124     }
125 	
126 	function unfreeze(uint256 _value) returns (bool success) {
127         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
128 		if (_value <= 0) throw; 
129         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
130 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
131         Unfreeze(msg.sender, _value);
132         return true;
133     }
134 	
135 	// transfer balance to owner
136 	function withdrawEther(uint256 amount) {
137 		if(msg.sender != owner)throw;
138 		owner.transfer(amount);
139 	}
140 	
141 	// can accept ether
142 	function() payable {
143     }
144 }