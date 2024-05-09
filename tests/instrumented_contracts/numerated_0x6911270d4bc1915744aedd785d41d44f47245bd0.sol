1 /**Quanta Pay-Qpay (QPY) previous contract was 
2 0x2fe0bc5ffb80a84739da913f0a393a4b0cce661b
3 deprecated. QPay new contract initiated. Visit project : https://quantaex.com
4 and https://qpay.group for detaails. */
5 
6 
7 pragma solidity ^0.4.21;
8 
9 /**
10  * Math operations with safety checks
11  */
12 contract SafeMath {
13   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
20     assert(b > 0);
21     uint256 c = a / b;
22     assert(a == b * c + a % b);
23     return c;
24   }
25 
26   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
32     uint256 c = a + b;
33     assert(c>=a && c>=b);
34     return c;
35   }
36 
37   function assert(bool assertion) internal {
38     if (!assertion) {
39       throw;
40     }
41   }
42 }
43 contract QPay is SafeMath{
44     string public name;
45     string public symbol;
46     uint8 public decimals;
47     uint256 public totalSupply;
48 	address public owner;
49 
50     /* This creates an array with all balances */
51     mapping (address => uint256) public balanceOf;
52 	mapping (address => uint256) public freezeOf;
53     mapping (address => mapping (address => uint256)) public allowance;
54 
55     /* This generates a public event on the blockchain that will notify clients */
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58     /* This notifies clients about the amount burnt */
59     event Burn(address indexed from, uint256 value);
60 	
61 	/* This notifies clients about the amount frozen */
62     event Freeze(address indexed from, uint256 value);
63 	
64 	/* This notifies clients about the amount unfrozen */
65     event Unfreeze(address indexed from, uint256 value);
66 
67     /* Initializes contract with initial supply tokens to the creator of the contract */
68     function QPay(
69         uint256 initialSupply,
70         string tokenName,
71         uint8 decimalUnits,
72         string tokenSymbol
73         ) {
74         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
75         totalSupply = initialSupply;                        // Update total supply
76         name = tokenName;                                   // Set the name for display purposes
77         symbol = tokenSymbol;                               // Set the symbol for display purposes
78         decimals = decimalUnits;                            // Amount of decimals for display purposes
79 		owner = msg.sender;
80     }
81 
82     /* Send coins */
83     function transfer(address _to, uint256 _value) {
84         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
85 		if (_value <= 0) throw; 
86         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
87         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
88         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
89         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
90         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
91     }
92 
93     /* Allow another contract to spend some tokens in your behalf */
94     function approve(address _spender, uint256 _value)
95         returns (bool success) {
96 		if (_value <= 0) throw; 
97         allowance[msg.sender][_spender] = _value;
98         return true;
99     }
100        
101 
102     /* A contract attempts to get the coins */
103     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
104         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
105 		if (_value <= 0) throw; 
106         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
107         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
108         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
109         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
110         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
111         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
112         Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     function burn(uint256 _value) returns (bool success) {
117         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
118 		if (_value <= 0) throw; 
119         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
120         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
121         Burn(msg.sender, _value);
122         return true;
123     }
124 	
125 	function freeze(uint256 _value) returns (bool success) {
126         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
127 		if (_value <= 0) throw; 
128         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
129         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
130         Freeze(msg.sender, _value);
131         return true;
132     }
133 	
134 	function unfreeze(uint256 _value) returns (bool success) {
135         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
136 		if (_value <= 0) throw; 
137         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
138 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
139         Unfreeze(msg.sender, _value);
140         return true;
141     }
142 	
143 	// transfer balance to owner
144 	function withdrawEther(uint256 amount) {
145 		if(msg.sender != owner)throw;
146 		owner.transfer(amount);
147 	}
148 	
149 	// can not accept ether
150 	function() {
151 revert();    }
152 }