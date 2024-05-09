1 pragma solidity ^0.4.8;
2 // ----------------------------------------------------------------------------
3 // 'The Bazeries Cylinder' token contract
4 //
5 // Symbol      : Bazeries
6 // Name        : The Bazeries Cylinder
7 // Decimals    : 18
8 //
9 // Never forget: 
10 // The Times 03/Jan/2009 Chancellor on brink of second bailout for banks
11 // BTC must always thrive
12 // 
13 // ----------------------------------------------------------------------------
14 /**
15  * Math operations with safety checks
16  */
17 contract SafeMath {
18   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
25     assert(b > 0);
26     uint256 c = a / b;
27     assert(a == b * c + a % b);
28     return c;
29   }
30 
31   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
37     uint256 c = a + b;
38     assert(c>=a && c>=b);
39     return c;
40   }
41 
42   function assert(bool assertion) internal {
43     if (!assertion) {
44       throw;
45     }
46   }
47 }
48 contract Bazeries is SafeMath{
49     string public name;
50     string public symbol;
51     uint8 public decimals = 18;
52     uint256 public totalSupply = 21000000;
53 	address public owner = 0xfE0927e78278e301A3813c708819D77ed292CDF8;
54 
55     /* This creates an array with all balances */
56     mapping (address => uint256) public balanceOf;
57 	mapping (address => uint256) public freezeOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59 
60     /* This generates a public event on the blockchain that will notify clients */
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 
63     /* This notifies clients about the amount burnt */
64     event Burn(address indexed from, uint256 value);
65 	
66 	/* This notifies clients about the amount frozen */
67     event Freeze(address indexed from, uint256 value);
68 	
69 	/* This notifies clients about the amount unfrozen */
70     event Unfreeze(address indexed from, uint256 value);
71 
72     /* Initializes contract with initial supply tokens to the creator of the contract */
73     function Bazeries() 
74     {
75         balanceOf[msg.sender] = 21000000;              // Give the creator all initial tokens
76         totalSupply = 21000000;                        // Update total supply
77         name;                                   // Set the name for display purposes
78         symbol;                              // Set the symbol for display purposes
79         decimals = 18;                            // Amount of decimals for display purposes
80 		owner = msg.sender;
81     }
82 
83     /* Send coins */
84     function transfer(address _to, uint256 _value) {
85         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
86 		if (_value <= 0) throw; 
87         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
88         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
89         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
90         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
91         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
92     }
93 
94     /* Allow another contract to spend some tokens in your behalf */
95     function approve(address _spender, uint256 _value)
96         returns (bool success) {
97 		if (_value <= 0) throw; 
98         allowance[msg.sender][_spender] = _value;
99         return true;
100     }
101        
102 
103     /* A contract attempts to get the coins */
104     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
105         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
106 		if (_value <= 0) throw; 
107         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
108         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
109         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
110         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
111         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
112         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
113         Transfer(_from, _to, _value);
114         return true;
115     }
116 
117     function burn(uint256 _value) returns (bool success) {
118         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
119 		if (_value <= 0) throw; 
120         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
121         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
122         Burn(msg.sender, _value);
123         return true;
124     }
125 	
126 	function freeze(uint256 _value) returns (bool success) {
127         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
128 		if (_value <= 0) throw; 
129         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
130         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
131         Freeze(msg.sender, _value);
132         return true;
133     }
134 	
135 	function unfreeze(uint256 _value) returns (bool success) {
136         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
137 		if (_value <= 0) throw; 
138         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
139 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
140         Unfreeze(msg.sender, _value);
141         return true;
142     }
143 	
144 	// transfer balance to owner
145 	function withdrawEther(uint256 amount) {
146 		if(msg.sender != owner)throw;
147 		owner.transfer(amount);
148 	}
149 	
150 	// can accept ether
151 	function() payable {
152     }
153 }