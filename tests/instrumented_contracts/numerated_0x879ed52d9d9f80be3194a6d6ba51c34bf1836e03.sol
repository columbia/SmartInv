1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-08
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
41 contract COW is SafeMath{
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
66     function COW(
67         ) {
68         balanceOf[msg.sender] = 100000000000000;              // Give the creator all initial tokens
69         totalSupply = 100000000000000;                        // Update total supply
70         name = 'Cloud Of Wisdom Al';                                   // Set the name for display purposes
71         symbol = 'COW';                               // Set the symbol for display purposes
72         decimals = 5;                            // Amount of decimals for display purposes
73 		owner = msg.sender;
74     }
75 
76     /* Send coins */
77     function transfer(address _to, uint256 _value) {
78         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
79 		if (_value <= 0) throw; 
80         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
82         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
83         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
84         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
85     }
86 
87     /* Allow another contract to spend some tokens in your behalf */
88     function approve(address _spender, uint256 _value)
89         returns (bool success) {
90 		if (_value <= 0) throw; 
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94        
95 
96     /* A contract attempts to get the coins */
97     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
98         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
99 		if (_value <= 0) throw; 
100         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
101         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
102         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
103         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
104         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
105         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
106         Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     function burn(uint256 _value) returns (bool success) {
111         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
112 		if (_value <= 0) throw; 
113         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
114         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
115         Burn(msg.sender, _value);
116         return true;
117     }
118 	
119 	function freeze(uint256 _value) returns (bool success) {
120         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
121 		if (_value <= 0) throw; 
122         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
123         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
124         Freeze(msg.sender, _value);
125         return true;
126     }
127 	
128 	function unfreeze(uint256 _value) returns (bool success) {
129         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
130 		if (_value <= 0) throw; 
131         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
132 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
133         Unfreeze(msg.sender, _value);
134         return true;
135     }
136 	
137 	// transfer balance to owner
138 	function withdrawEther(uint256 amount) {
139 		if(msg.sender != owner)throw;
140 		owner.transfer(amount);
141 	}
142 	
143 	// can accept ether
144 	function() payable {
145     }
146 }