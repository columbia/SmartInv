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
37 contract AllTest7 is SafeMath{
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
62     function AllTest7(
63         ) {
64 
65         uint256 initialSupply;
66         string tokenName;
67         uint8 decimalUnits;
68         string tokenSymbol;
69         balanceOf[msg.sender] = 50000000000000000000000000000;              // Give the creator all initial tokens
70         totalSupply = 50000000000000000000000000000;                        // Update total supply
71         name = "AllTest7";                                   // Set the name for display purposes
72         symbol = "AllTest7";                               // Set the symbol for display purposes
73         decimals = 18;                            // Amount of decimals for display purposes
74 		owner = msg.sender;
75     }
76 
77     /* Send coins */
78     function transfer(address _to, uint256 _value) {
79         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
80 		if (_value <= 0) throw; 
81         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
82         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
83         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
84         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
85         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
86     }
87 
88     /* Allow another contract to spend some tokens in your behalf */
89     function approve(address _spender, uint256 _value)
90         returns (bool success) {
91 		if (_value <= 0) throw; 
92         allowance[msg.sender][_spender] = _value;
93         return true;
94     }
95        
96 
97     /* A contract attempts to get the coins */
98     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
99         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
100 		if (_value <= 0) throw; 
101         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
102         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
103         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
104         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
105         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
106         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
107         Transfer(_from, _to, _value);
108         return true;
109     }
110 
111     function burn(uint256 _value) returns (bool success) {
112         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
113 		if (_value <= 0) throw; 
114         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
115         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
116         Burn(msg.sender, _value);
117         return true;
118     }
119 	
120 	function freeze(uint256 _value) returns (bool success) {
121         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
122 		if (_value <= 0) throw; 
123         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
124         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
125         Freeze(msg.sender, _value);
126         return true;
127     }
128 	
129 	function unfreeze(uint256 _value) returns (bool success) {
130         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
131 		if (_value <= 0) throw; 
132         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
133 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
134         Unfreeze(msg.sender, _value);
135         return true;
136     }
137 	
138 	// transfer balance to owner
139 	function withdrawEther(uint256 amount) {
140 		if(msg.sender != owner)throw;
141 		owner.transfer(amount);
142 	}
143 	
144 	// can accept ether
145 	function() payable {
146     }
147 }