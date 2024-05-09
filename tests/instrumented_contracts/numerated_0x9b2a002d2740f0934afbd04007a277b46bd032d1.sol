1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-14
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2017-07-06
7 */
8 
9 pragma solidity ^0.4.8;
10 
11 /**
12  * Math operations with safety checks
13  */
14 contract SafeMath {
15   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
22     assert(b > 0);
23     uint256 c = a / b;
24     assert(a == b * c + a % b);
25     return c;
26   }
27 
28   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
34     uint256 c = a + b;
35     assert(c>=a && c>=b);
36     return c;
37   }
38 
39   function assert(bool assertion) internal {
40     if (!assertion) {
41       throw;
42     }
43   }
44 }
45 contract DVD is SafeMath{
46     string public name;
47     string public symbol;
48     uint8 public decimals;
49     uint256 public totalSupply;
50 	address public owner;
51 
52     /* This creates an array with all balances */
53     mapping (address => uint256) public balanceOf;
54 	mapping (address => uint256) public freezeOf;
55     mapping (address => mapping (address => uint256)) public allowance;
56 
57     /* This generates a public event on the blockchain that will notify clients */
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 
60     /* This notifies clients about the amount burnt */
61     event Burn(address indexed from, uint256 value);
62 	
63 	/* This notifies clients about the amount frozen */
64     event Freeze(address indexed from, uint256 value);
65 	
66 	/* This notifies clients about the amount unfrozen */
67     event Unfreeze(address indexed from, uint256 value);
68 
69     /* Initializes contract with initial supply tokens to the creator of the contract */
70     function DVD(
71         uint256 initialSupply,
72         string tokenName,
73         uint8 decimalUnits,
74         string tokenSymbol
75         ) {
76         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
77         totalSupply = initialSupply;                        // Update total supply
78         name = tokenName;                                   // Set the name for display purposes
79         symbol = tokenSymbol;                               // Set the symbol for display purposes
80         decimals = decimalUnits;                            // Amount of decimals for display purposes
81 		owner = msg.sender;
82     }
83 
84     /* Send coins */
85     function transfer(address _to, uint256 _value) {
86         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
87 		if (_value <= 0) throw; 
88         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
89         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
90         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
91         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
92         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
93     }
94 
95     /* Allow another contract to spend some tokens in your behalf */
96     function approve(address _spender, uint256 _value)
97         returns (bool success) {
98 		if (_value <= 0) throw; 
99         allowance[msg.sender][_spender] = _value;
100         return true;
101     }
102        
103 
104     /* A contract attempts to get the coins */
105     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
106         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
107 		if (_value <= 0) throw; 
108         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
109         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
110         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
111         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
112         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
113         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
114         Transfer(_from, _to, _value);
115         return true;
116     }
117 
118     function burn(uint256 _value) returns (bool success) {
119         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
120 		if (_value <= 0) throw; 
121         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
122         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
123         Burn(msg.sender, _value);
124         return true;
125     }
126 	
127 	function freeze(uint256 _value) returns (bool success) {
128         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
129 		if (_value <= 0) throw; 
130         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
131         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
132         Freeze(msg.sender, _value);
133         return true;
134     }
135 	
136 	function unfreeze(uint256 _value) returns (bool success) {
137         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
138 		if (_value <= 0) throw; 
139         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
140 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
141         Unfreeze(msg.sender, _value);
142         return true;
143     }
144 	
145 	// transfer balance to owner
146 	function withdrawEther(uint256 amount) {
147 		if(msg.sender != owner)throw;
148 		owner.transfer(amount);
149 	}
150 	
151 	// can accept ether
152 	function() payable {
153     }
154 }