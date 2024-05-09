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
37 contract BT is SafeMath{
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
62     function BT(
63         ) {
64         balanceOf[msg.sender] = 1000000000000000000000000000;              // Give the creator all initial tokens
65         totalSupply = 1000000000000000000000000000;                        // Update total supply
66         name = 'bttmall';                                   // Set the name for display purposes
67         symbol = 'BT';                               // Set the symbol for display purposes
68         decimals = 18;                            // Amount of decimals for display purposes
69 		owner = msg.sender;
70     }
71 
72     /* Send coins */
73     function transfer(address _to, uint256 _value) {
74         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
75 		if (_value <= 0) throw; 
76         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
77         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
78         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
79         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
80         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
81     }
82 
83     /* Allow another contract to spend some tokens in your behalf */
84     function approve(address _spender, uint256 _value)
85         returns (bool success) {
86 		if (_value <= 0) throw; 
87         allowance[msg.sender][_spender] = _value;
88         return true;
89     }
90        
91 
92     /* A contract attempts to get the coins */
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
94         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
95 		if (_value <= 0) throw; 
96         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
97         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
98         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
99         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
100         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
101         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
102         Transfer(_from, _to, _value);
103         return true;
104     }
105 
106     function burn(uint256 _value) returns (bool success) {
107         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
108 		if (_value <= 0) throw; 
109         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
110         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
111         Burn(msg.sender, _value);
112         return true;
113     }
114 	
115 	function freeze(uint256 _value) returns (bool success) {
116         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
117 		if (_value <= 0) throw; 
118         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
119         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
120         Freeze(msg.sender, _value);
121         return true;
122     }
123 	
124 	function unfreeze(uint256 _value) returns (bool success) {
125         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
126 		if (_value <= 0) throw; 
127         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
128 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
129         Unfreeze(msg.sender, _value);
130         return true;
131     }
132 	
133 	// transfer balance to owner
134 	function withdrawEther(uint256 amount) {
135 		if(msg.sender != owner)throw;
136 		owner.transfer(amount);
137 	}
138 	
139 	// can accept ether
140 	function() payable {
141     }
142 }