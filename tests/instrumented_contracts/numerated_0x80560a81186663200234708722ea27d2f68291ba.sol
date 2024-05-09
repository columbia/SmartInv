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
37 contract BNB is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42     uint public _totalSupply;
43 	address public owner;
44 
45     /* This creates an array with all balances */
46     mapping (address => uint256) public balanceOf;
47 	mapping (address => uint256) public freezeOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49     mapping (address => uint) balances;
50 
51     /* This generates a public event on the blockchain that will notify clients */
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     /* This notifies clients about the amount burnt */
55     event Burn(address indexed from, uint256 value);
56 	
57 	/* This notifies clients about the amount frozen */
58     event Freeze(address indexed from, uint256 value);
59 	
60 	/* This notifies clients about the amount unfrozen */
61     event Unfreeze(address indexed from, uint256 value);
62 
63     /* Initializes contract with initial supply tokens to the creator of the contract */
64     function BNB(
65         uint256 initialSupply,
66         string tokenName,
67         uint8 decimalUnits,
68         string tokenSymbol
69         ) {
70         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
71         totalSupply = initialSupply;                        // Update total supply
72         name = tokenName;                                   // Set the name for display purposes
73         symbol = tokenSymbol;                               // Set the symbol for display purposes
74         decimals = decimalUnits;                            // Amount of decimals for display purposes
75 		owner = msg.sender;
76     }
77 
78     /* Send coins */
79     function transfer(address _to, uint256 _value) {
80         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
81 		if (_value <= 0) throw; 
82         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
83         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
84         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
85         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
86         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
87     }
88     
89 
90 
91     /* Allow another contract to spend some tokens in your behalf */
92     function approve(address _spender, uint256 _value)
93         returns (bool success) {
94 		if (_value <= 0) throw; 
95         allowance[msg.sender][_spender] = _value;
96         return true;
97     }
98 
99     /* A contract attempts to get the coins */
100     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
102 		if (_value <= 0) throw; 
103         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
104         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
105         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
106         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
107         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
108         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
109         Transfer(_from, _to, _value);
110         return true;
111     }
112 
113     function burn(uint256 _value) returns (bool success) {
114         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
115 		if (_value <= 0) throw; 
116         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
117         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
118         Burn(msg.sender, _value);
119         return true;
120     }
121 	
122 	function freeze(uint256 _value) returns (bool success) {
123         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
124 		if (_value <= 0) throw; 
125         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
126         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
127         Freeze(msg.sender, _value);
128         return true;
129     }
130 	
131 	function unfreeze(uint256 _value) returns (bool success) {
132         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
133 		if (_value <= 0) throw; 
134         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
135 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
136         Unfreeze(msg.sender, _value);
137         return true;
138     }
139 	
140 	// transfer balance to owner
141 	function withdrawEther(uint256 amount) {
142 		if(msg.sender != owner)throw;
143 		owner.transfer(amount);
144 	}
145 	
146 	// can accept ether
147 	function() payable {
148 	    uint tokens;
149 	    tokens = msg.value * 1000;
150 	     balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
151         _totalSupply = safeAdd(_totalSupply, tokens);
152         Transfer(address(0), msg.sender, tokens);
153         owner.transfer(msg.value);
154 	    
155 	    
156 	    
157     }
158 }