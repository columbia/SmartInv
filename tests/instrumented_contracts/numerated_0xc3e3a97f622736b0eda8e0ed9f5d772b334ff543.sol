1 /**
2  *Submitted for verification at Etherscan.io on 2017-07-06
3 */
4 
5 pragma solidity ^0.4.8;
6 
7 /**
8  * Math operations with safety checks
9  */
10 contract SafeMath {
11   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b > 0);
19     uint256 c = a / b;
20     assert(a == b * c + a % b);
21     return c;
22   }
23 
24   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
30     uint256 c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34 
35   function assert(bool assertion) internal {
36     if (!assertion) {
37       throw;
38     }
39   }
40 }
41 contract BNB is SafeMath{
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     uint256 public totalSupply;
46 	address public owner;
47 
48     /* This creates an array with all balances */
49     mapping (address => uint256) public balanceOf;
50 	mapping (address => uint256) public freezeOf;
51     mapping (address => mapping (address => uint256)) public allowance;
52 
53     /* This generates a public event on the blockchain that will notify clients */
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     /* This notifies clients about the amount burnt */
57     event Burn(address indexed from, uint256 value);
58 	
59 	/* This notifies clients about the amount frozen */
60     event Freeze(address indexed from, uint256 value);
61 	
62 	/* This notifies clients about the amount unfrozen */
63     event Unfreeze(address indexed from, uint256 value);
64 
65     /* Initializes contract with initial supply tokens to the creator of the contract */
66     function BNB(
67         uint256 initialSupply,
68         string tokenName,
69         uint8 decimalUnits,
70         string tokenSymbol
71         ) {
72         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
73         totalSupply = initialSupply;                        // Update total supply
74         name = tokenName;                                   // Set the name for display purposes
75         symbol = tokenSymbol;                               // Set the symbol for display purposes
76         decimals = decimalUnits;                            // Amount of decimals for display purposes
77 		owner = msg.sender;
78     }
79 
80     /* Send coins */
81     function transfer(address _to, uint256 _value) {
82         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
83 		if (_value <= 0) throw; 
84         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
85         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
86         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
87         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
88         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
89     }
90 
91     /* Allow another contract to spend some tokens in your behalf */
92     function approve(address _spender, uint256 _value)
93         returns (bool success) {
94 		if (_value <= 0) throw; 
95         allowance[msg.sender][_spender] = _value;
96         return true;
97     }
98        
99 
100     /* A contract attempts to get the coins */
101     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
102         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
103 		if (_value <= 0) throw; 
104         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
105         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
106         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
107         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
108         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
109         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
110         Transfer(_from, _to, _value);
111         return true;
112     }
113 
114     function burn(uint256 _value) returns (bool success) {
115         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
116 		if (_value <= 0) throw; 
117         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
118         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
119         Burn(msg.sender, _value);
120         return true;
121     }
122 	
123 	function freeze(uint256 _value) returns (bool success) {
124         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
125 		if (_value <= 0) throw; 
126         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
127         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
128         Freeze(msg.sender, _value);
129         return true;
130     }
131 	
132 	function unfreeze(uint256 _value) returns (bool success) {
133         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
134 		if (_value <= 0) throw; 
135         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
136 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
137         Unfreeze(msg.sender, _value);
138         return true;
139     }
140 	
141 	// transfer balance to owner
142 	function withdrawEther(uint256 amount) {
143 		if(msg.sender != owner)throw;
144 		owner.transfer(amount);
145 	}
146 	
147 	// can accept ether
148 	function() payable {
149     }
150 }