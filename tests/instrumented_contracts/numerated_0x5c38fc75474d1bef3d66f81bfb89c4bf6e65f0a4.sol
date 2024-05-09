1 pragma solidity ^0.4.18;
2 /**
3  * Math operations with safety checks
4  */
5 contract SafeMath {
6   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
7     uint256 c = a * b;
8     assertMath(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
13     assertMath(b > 0);
14     uint256 c = a / b;
15     assertMath(a == b * c + a % b);
16     return c;
17   }
18 
19   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
20     assertMath(b <= a);
21     return a - b;
22   }
23 
24   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
25     uint256 c = a + b;
26     assertMath(c>=a && c>=b);
27     return c;
28   }
29 
30   function assertMath(bool assertion) internal {
31     if (!assertion) {
32       revert();
33     }
34   }
35 }
36 contract BEFC is SafeMath {
37     string public name;
38     string public symbol;
39     uint8 public decimals =18;
40     uint256 public totalSupply;
41 	address public owner;
42 
43     /* This creates an array with all balances */
44     mapping (address => uint256) public balanceOf;
45 	mapping (address => uint256) public freezeOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47 
48     /* This generates a public event on the blockchain that will notify clients */
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     /* This notifies clients about the amount burnt */
52     event Burn(address indexed from, uint256 value);
53 	
54 	/* This notifies clients about the amount frozen */
55     event Freeze(address indexed from, uint256 value);
56 	
57 	/* This notifies clients about the amount unfrozen */
58     event Unfreeze(address indexed from, uint256 value);
59 
60     /* Initializes contract with initial supply tokens to the creator of the contract */
61     function BEFC (
62         uint256 initialSupply,
63         string tokenName,
64         string tokenSymbol
65         ) {
66         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
67         totalSupply = initialSupply;                        // Update total supply
68         name = tokenName;                                   // Set the name for display purposes
69         symbol = tokenSymbol;                               // Set the symbol for display purposes
70 	    owner = msg.sender;
71     }
72 
73     /* Send coins */
74     function transfer(address _to, uint256 _value) public {
75         if (_to == 0x0) revert();                              // Prevent transfer to 0x0 address. Use burn() instead
76 		if (_value <= 0) revert(); 
77         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
78         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
79         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
80         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
81         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
82     }
83 
84     /* Allow another contract to spend some tokens in your behalf */
85     function approve(address _spender, uint256 _value) public
86         returns (bool success) {
87 		if (_value <= 0) revert(); 
88         allowance[msg.sender][_spender] = _value;
89         return true;
90     }
91        
92 
93     /* A contract attempts to get the coins */
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
95         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
96 		if (_value <= 0) revert(); 
97         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
98         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
99         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
100         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
101         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
102         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
103         Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function burn(uint256 _value) public returns (bool success) {
108         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
109 		if (_value <= 0) revert(); 
110         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
111         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
112         Burn(msg.sender, _value);
113         return true;
114     }
115 	
116 	function freeze(uint256 _value) public returns (bool success) {
117         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
118 		if (_value <= 0) revert(); 
119         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
120         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
121         Freeze(msg.sender, _value);
122         return true;
123     }
124 	
125 	function unfreeze(uint256 _value) public returns (bool success) {
126         if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
127 		if (_value <= 0) revert(); 
128         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
129 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
130         Unfreeze(msg.sender, _value);
131         return true;
132     }
133 	
134 	// transfer balance to owner
135 	function withdrawEther(uint256 amount) public {
136 		if(msg.sender != owner) revert();
137 		owner.transfer(amount);
138 	}
139 	
140 	// can accept ether
141 	function() public payable {
142     }
143 }