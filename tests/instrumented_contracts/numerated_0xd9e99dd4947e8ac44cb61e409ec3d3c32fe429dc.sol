1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-17
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-11-16
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-09-14
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2017-07-06
15 */
16 
17 pragma solidity ^0.4.8;
18 
19 /**
20  * Math operations with safety checks
21  */
22 contract SafeMath {
23   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
30     assert(b > 0);
31     uint256 c = a / b;
32     assert(a == b * c + a % b);
33     return c;
34   }
35 
36   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
42     uint256 c = a + b;
43     assert(c>=a && c>=b);
44     return c;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 contract DSTAR is SafeMath{
54     string public name;
55     string public symbol;
56     uint8 public decimals;
57     uint256 public totalSupply;
58 	address public owner;
59 
60     /* This creates an array with all balances */
61     mapping (address => uint256) public balanceOf;
62 	mapping (address => uint256) public freezeOf;
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65     /* This generates a public event on the blockchain that will notify clients */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /* This notifies clients about the amount burnt */
69     event Burn(address indexed from, uint256 value);
70 	
71 	/* This notifies clients about the amount frozen */
72     event Freeze(address indexed from, uint256 value);
73 	
74 	/* This notifies clients about the amount unfrozen */
75     event Unfreeze(address indexed from, uint256 value);
76 
77     /* Initializes contract with initial supply tokens to the creator of the contract */
78     function DSTAR(
79         uint256 initialSupply,
80         string tokenName,
81         uint8 decimalUnits,
82         string tokenSymbol
83         ) {
84         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
85         totalSupply = initialSupply;                        // Update total supply
86         name = tokenName;                                   // Set the name for display purposes
87         symbol = tokenSymbol;                               // Set the symbol for display purposes
88         decimals = decimalUnits;                            // Amount of decimals for display purposes
89 		owner = msg.sender;
90     }
91 
92     /* Send coins */
93     function transfer(address _to, uint256 _value) {
94         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
95 		if (_value <= 0) throw; 
96         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
97         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
98         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
99         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
100         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
101     }
102 
103     /* Allow another contract to spend some tokens in your behalf */
104     function approve(address _spender, uint256 _value)
105         returns (bool success) {
106 		if (_value <= 0) throw; 
107         allowance[msg.sender][_spender] = _value;
108         return true;
109     }
110        
111 
112     /* A contract attempts to get the coins */
113     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
114         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
115 		if (_value <= 0) throw; 
116         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
117         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
118         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
119         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
120         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
121         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
122         Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     function burn(uint256 _value) returns (bool success) {
127         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
128 		if (_value <= 0) throw; 
129         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
130         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
131         Burn(msg.sender, _value);
132         return true;
133     }
134 	
135 	function freeze(uint256 _value) returns (bool success) {
136         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
137 		if (_value <= 0) throw; 
138         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
139         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
140         Freeze(msg.sender, _value);
141         return true;
142     }
143 	
144 	function unfreeze(uint256 _value) returns (bool success) {
145         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
146 		if (_value <= 0) throw; 
147         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
148 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
149         Unfreeze(msg.sender, _value);
150         return true;
151     }
152 	
153 	// transfer balance to owner
154 	function withdrawEther(uint256 amount) {
155 		if(msg.sender != owner)throw;
156 		owner.transfer(amount);
157 	}
158 	
159 	// can accept ether
160 	function() payable {
161     }
162 }