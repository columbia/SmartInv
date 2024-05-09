1 contract SafeMath {
2   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
9     assert(b > 0);
10     uint256 c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14 
15   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
21     uint256 c = a + b;
22     assert(c>=a && c>=b);
23     return c;
24   }
25 
26   function assert(bool assertion) internal {
27     if (!assertion) {
28       throw;
29     }
30   }
31 }
32 contract ICSS is SafeMath{
33     string public name;
34     string public symbol;
35     uint8 public decimals;
36     uint256 public totalSupply;
37 	address public owner;
38 
39     /* This creates an array with all balances */
40     mapping (address => uint256) public balanceOf;
41 	mapping (address => uint256) public freezeOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44     /* This generates a public event on the blockchain that will notify clients */
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     /* This notifies clients about the amount burnt */
48     event Burn(address indexed from, uint256 value);
49 	
50 	/* This notifies clients about the amount frozen */
51     event Freeze(address indexed from, uint256 value);
52 	
53 	/* This notifies clients about the amount unfrozen */
54     event Unfreeze(address indexed from, uint256 value);
55 
56     /* Initializes contract with initial supply tokens to the creator of the contract */
57     function ICSS(
58         uint256 initialSupply,
59         string tokenName,
60         uint8 decimalUnits,
61         string tokenSymbol
62         ) {
63         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
64         totalSupply = initialSupply;                        // Update total supply
65         name = tokenName;                                   // Set the name for display purposes
66         symbol = tokenSymbol;                               // Set the symbol for display purposes
67         decimals = decimalUnits;                            // Amount of decimals for display purposes
68 		owner = msg.sender;
69     }
70 
71     /* Send coins */
72     function transfer(address _to, uint256 _value) {
73         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
74 		if (_value <= 0) throw; 
75         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
76         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
77         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
78         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
79         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
80     }
81 
82     /* Allow another contract to spend some tokens in your behalf */
83     function approve(address _spender, uint256 _value)
84         returns (bool success) {
85 		if (_value <= 0) throw; 
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89        
90 
91     /* A contract attempts to get the coins */
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
93         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
94 		if (_value <= 0) throw; 
95         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
96         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
97         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
98         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
99         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
100         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
101         Transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function burn(uint256 _value) returns (bool success) {
106         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
107 		if (_value <= 0) throw; 
108         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
109         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
110         Burn(msg.sender, _value);
111         return true;
112     }
113 	
114 	function freeze(uint256 _value) returns (bool success) {
115         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
116 		if (_value <= 0) throw; 
117         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
118         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
119         Freeze(msg.sender, _value);
120         return true;
121     }
122 	
123 	function unfreeze(uint256 _value) returns (bool success) {
124         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
125 		if (_value <= 0) throw; 
126         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
127 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
128         Unfreeze(msg.sender, _value);
129         return true;
130     }
131 	
132 	// transfer balance to owner
133 	function withdrawEther(uint256 amount) {
134 		if(msg.sender != owner)throw;
135 		owner.transfer(amount);
136 	}
137 	
138 	// can accept ether
139 	function() payable {
140     }
141 }