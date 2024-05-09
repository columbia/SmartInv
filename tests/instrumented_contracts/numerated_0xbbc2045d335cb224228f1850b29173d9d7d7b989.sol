1 pragma solidity ^0.4.19;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
8       uint256 z = x + y;
9       assert((z >= x) && (z >= y));
10       return z;
11     }
12 
13     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
14       assert(x >= y);
15       uint256 z = x - y;
16       return z;
17     }
18 
19     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
20       uint256 z = x * y;
21       assert((x == 0)||(z/x == y));
22       return z;
23     }
24 
25   function assert(bool assertion) internal {
26     if (!assertion) {
27       throw;
28     }
29   }
30 }
31 contract HELP is SafeMath{
32     string public name;
33     string public symbol;
34     uint8 public decimals;
35     uint256 public totalSupply;
36 	address public owner;
37 
38     /* This creates an array with all balances */
39     mapping (address => uint256) public balanceOf;
40 	mapping (address => uint256) public freezeOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42 
43     /* This generates a public event on the blockchain that will notify clients */
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     /* This notifies clients about the amount burnt */
47     event Burn(address indexed from, uint256 value);
48 
49 	/* This notifies clients about the amount frozen */
50     event Freeze(address indexed from, uint256 value);
51 
52 	/* This notifies clients about the amount unfrozen */
53     event Unfreeze(address indexed from, uint256 value);
54 
55     /* Initializes contract with initial supply tokens to the creator of the contract */
56     function HELP(
57         uint256 initialSupply,
58         string tokenName,
59         uint8 decimalUnits,
60         string tokenSymbol
61         ) {
62         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
63         totalSupply = initialSupply;                        // Update total supply
64         name = tokenName;                                   // Set the name for display purposes
65         symbol = tokenSymbol;                               // Set the symbol for display purposes
66         decimals = decimalUnits;                            // Amount of decimals for display purposes
67 		owner = msg.sender;
68     }
69 
70     /* Send tokens */
71     function transfer(address _to, uint256 _value) {
72         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
73 		if (_value <= 0) throw;
74         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
75         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
76         balanceOf[msg.sender] = SafeMath.safeSubtract(balanceOf[msg.sender], _value);                     // Subtract from the sender
77         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
78         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
79     }
80 
81     /* Allow another contract to spend some tokens in your behalf */
82     function approve(address _spender, uint256 _value)
83         returns (bool success) {
84 		if (_value <= 0) throw;
85         allowance[msg.sender][_spender] = _value;
86         return true;
87     }
88 
89 
90     /* A contract attempts to get the coins */
91     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
92         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
93 		if (_value <= 0) throw;
94         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
95         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
96         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
97         balanceOf[_from] = SafeMath.safeSubtract(balanceOf[_from], _value);                           // Subtract from the sender
98         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
99         allowance[_from][msg.sender] = SafeMath.safeSubtract(allowance[_from][msg.sender], _value);
100         Transfer(_from, _to, _value);
101         return true;
102     }
103 
104     function burn(uint256 _value) returns (bool success) {
105         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
106 		if (_value <= 0) throw;
107         balanceOf[msg.sender] = SafeMath.safeSubtract(balanceOf[msg.sender], _value);                      // Subtract from the sender
108         totalSupply = SafeMath.safeSubtract(totalSupply,_value);                                // Updates totalSupply
109         Burn(msg.sender, _value);
110         return true;
111     }
112 
113 	function freeze(uint256 _value) returns (bool success) {
114         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
115 		if (_value <= 0) throw;
116         balanceOf[msg.sender] = SafeMath.safeSubtract(balanceOf[msg.sender], _value);                      // Subtract from the sender
117         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
118         Freeze(msg.sender, _value);
119         return true;
120     }
121 
122 	function unfreeze(uint256 _value) returns (bool success) {
123         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
124 		if (_value <= 0) throw;
125         freezeOf[msg.sender] = SafeMath.safeSubtract(freezeOf[msg.sender], _value);                      // Subtract from the sender
126 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
127         Unfreeze(msg.sender, _value);
128         return true;
129     }
130 	
131 	// transfer balance to owner
132 	function withdrawEther(uint256 amount) {
133 		if(msg.sender != owner)throw;
134 		owner.transfer(amount);
135 	}
136 	
137 	// can accept ether
138 	function() payable {
139     }
140 }