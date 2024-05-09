1 /**
2  * Flit Token is created 21th November 2019 Developer @BitBD >NEXBIT.IO
3 */
4 
5 
6 
7 
8 pragma solidity ^0.4.11;
9 
10 /**
11  * Math operations with safety checks
12  */
13 contract SafeMath {
14   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b > 0);
22     uint256 c = a / b;
23     assert(a == b * c + a % b);
24     return c;
25   }
26 
27   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
33     uint256 c = a + b;
34     assert(c>=a && c>=b);
35     return c;
36   }
37 
38   function assert(bool assertion) internal {
39     if (!assertion) {
40       revert();
41     }
42   }
43 }
44 contract FlitToken is SafeMath{
45     string public name;
46     string public symbol;
47     uint8 public decimals;
48     uint256 public totalSupply;
49 	address public owner;
50 
51     /* This creates an array with all balances */
52     mapping (address => uint256) public balanceOf;
53 	mapping (address => uint256) public freezeOf;
54     mapping (address => mapping (address => uint256)) public allowance;
55 
56     /* This generates a public event on the blockchain that will notify clients */
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 
59     /* This notifies clients about the amount burnt */
60     event Burn(address indexed from, uint256 value);
61 
62 	/* This notifies clients about the amount frozen */
63     event Freeze(address indexed from, uint256 value);
64 
65 	/* This notifies clients about the amount unfrozen */
66     event Unfreeze(address indexed from, uint256 value);
67 
68     /* Initializes contract with initial supply tokens to the creator of the contract */
69     function FlitToken(
70         uint256 initialSupply,
71         string tokenName,
72         uint8 decimalUnits,
73         string tokenSymbol
74         ) {
75         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
76         totalSupply = initialSupply;                        // Update total supply
77         name = tokenName;                                   // Set the name for display purposes
78         symbol = tokenSymbol;                               // Set the symbol for display purposes
79         decimals = decimalUnits;                            // Amount of decimals for display purposes
80 		owner = msg.sender;
81     }
82 
83     /* Send coins */
84     function transfer(address _to, uint256 _value) {
85         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
86 		if (_value <= 0) revert();
87         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
88         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
89         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
90         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
91         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
92     }
93 
94     /* Allow another contract to spend some tokens in your behalf */
95     function approve(address _spender, uint256 _value)
96         returns (bool success) {
97 		if (_value <= 0) revert();
98         allowance[msg.sender][_spender] = _value;
99         return true;
100     }
101 
102 
103     /* A contract attempts to get the coins */
104     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
105         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
106 		if (_value <= 0) revert();
107         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
108         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
109         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
110         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
111         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
112         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
113         Transfer(_from, _to, _value);
114         return true;
115     }
116 
117     function burn(uint256 _value) returns (bool success) {
118         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
119 		if (_value <= 0) revert();
120         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
121         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
122         Burn(msg.sender, _value);
123         return true;
124     }
125 
126 	function freeze(uint256 _value) returns (bool success) {
127         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
128 		if (_value <= 0) revert();
129         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
130         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
131         Freeze(msg.sender, _value);
132         return true;
133     }
134 
135 	function unfreeze(uint256 _value) returns (bool success) {
136         if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
137 		if (_value <= 0) revert();
138         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
139 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
140         Unfreeze(msg.sender, _value);
141         return true;
142     }
143 
144 	// transfer balance to owner
145 	function withdrawEther(uint256 amount) {
146 		if(msg.sender != owner) revert();
147 		owner.transfer(amount);
148 	}
149 
150 	// can not accept ether
151 	function() {
152 revert();    }
153 }