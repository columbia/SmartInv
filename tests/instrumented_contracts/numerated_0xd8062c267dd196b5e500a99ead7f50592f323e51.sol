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
37 contract BidaCoin is SafeMath{
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
62     function BidaCoin(
63         uint256 initialSupply
64         ) {
65         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
66         totalSupply = initialSupply;                        // Update total supply
67         name = "BidaCoin";                                  // Set the name for display purposes
68         symbol = "BDB";                                     // Set the symbol for display purposes
69         decimals = 18;                                      // Amount of decimals for display purposes
70 		owner = msg.sender;
71     }
72 
73     /* Send coins */
74     function transfer(address _to, uint256 _value) {
75         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
76 		if (_value <= 0) throw; 
77         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
78         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
79         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
80         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
81         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
82     }
83 
84     /* Allow another contract to spend some tokens in your behalf */
85     function approve(address _spender, uint256 _value)
86         returns (bool success) {
87 		if (_value <= 0) throw; 
88         allowance[msg.sender][_spender] = _value;
89         return true;
90     }
91        
92 
93     /* A contract attempts to get the coins */
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
95         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
96 		if (_value <= 0) throw; 
97         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
98         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
99         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
100         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
101         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
102         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
103         Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function burn(uint256 _value) returns (bool success) {
108         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
109 		if (_value <= 0) throw; 
110         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
111         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
112         Burn(msg.sender, _value);
113         return true;
114     }
115 	
116 	function freeze(uint256 _value) returns (bool success) {
117         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
118 		if (_value <= 0) throw; 
119         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
120         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
121         Freeze(msg.sender, _value);
122         return true;
123     }
124 	
125 	function unfreeze(uint256 _value) returns (bool success) {
126         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
127 		if (_value <= 0) throw; 
128         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
129 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
130         Unfreeze(msg.sender, _value);
131         return true;
132     }
133 	
134 	// transfer balance to owner
135 	function withdrawEther(uint256 amount) {
136 		if(msg.sender != owner)throw;
137 		owner.transfer(amount);
138 	}
139 	
140 	// can accept ether
141 	function() payable {
142     }
143 }