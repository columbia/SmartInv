1 pragma solidity ^0.4.17;
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
37 
38 
39 contract owned {
40         address public owner;
41 
42         function owned() {
43             owner = msg.sender;
44         }
45 
46         modifier onlyOwner {
47             require(msg.sender == owner);
48             _;
49         }
50 
51         function transferOwnership(address newOwner) onlyOwner {
52             owner = newOwner;
53         }
54 }
55 
56 
57 contract MintableToken is SafeMath ,owned{
58     string public name;
59     string public symbol;
60     uint8 public decimals;
61     uint256 public totalSupply;
62 	address public owner;
63 
64     /* This creates an array with all balances */
65     mapping (address => uint256) public balanceOf;
66 	mapping (address => uint256) public freezeOf;
67     mapping (address => mapping (address => uint256)) public allowance;
68 
69     /* This generates a public event on the blockchain that will notify clients */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /* This notifies clients about the amount burnt */
73     event Burn(address indexed from, uint256 value);
74 	
75 	/* This notifies clients about the amount frozen */
76     event Freeze(address indexed from, uint256 value);
77 	
78 	/* This notifies clients about the amount unfrozen */
79     event Unfreeze(address indexed from, uint256 value);
80 
81     /* Initializes contract with initial supply tokens to the creator of the contract */
82     function MintableToken(
83         uint256 initialSupply,
84         string tokenName,
85         uint8 decimalUnits,
86         string tokenSymbol
87         ) {
88         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
89         totalSupply = initialSupply;                        // Update total supply
90         name = tokenName;                                   // Set the name for display purposes
91         symbol = tokenSymbol;                               // Set the symbol for display purposes
92         decimals = decimalUnits;                            // Amount of decimals for display purposes
93 		owner = msg.sender;
94     }
95 
96     /* Send coins */
97     function transfer(address _to, uint256 _value) {
98         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
99 		if (_value <= 0) throw; 
100         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
101         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
102         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
103         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
104         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
105     }
106 
107     /* Allow another contract to spend some tokens in your behalf */
108     function approve(address _spender, uint256 _value)
109         returns (bool success) {
110 		if (_value <= 0) throw; 
111         allowance[msg.sender][_spender] = _value;
112         return true;
113     }
114        
115 
116     /* A contract attempts to get the coins */
117     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
118         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
119 		if (_value <= 0) throw; 
120         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
121         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
122         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
123         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
124         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
125         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
126         Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     function burn(uint256 _value) returns (bool success) {
131         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
132 		if (_value <= 0) throw; 
133         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
134         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
135         Burn(msg.sender, _value);
136         return true;
137     }
138 
139     function mintToken(address target, uint256 mintedAmount) onlyOwner {
140         balanceOf[target] += mintedAmount;
141         totalSupply += mintedAmount;
142         Transfer(0, owner, mintedAmount);
143         Transfer(owner, target, mintedAmount);
144     }
145 	
146 	function freeze(uint256 _value) returns (bool success) {
147         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
148 		if (_value <= 0) throw; 
149         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
150         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
151         Freeze(msg.sender, _value);
152         return true;
153     }
154 	
155 	function unfreeze(uint256 _value) returns (bool success) {
156         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
157 		if (_value <= 0) throw; 
158         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
159 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
160         Unfreeze(msg.sender, _value);
161         return true;
162     }
163 	
164 	// transfer balance to owner
165 	function withdrawEther(uint256 amount) {
166 		if(msg.sender != owner)throw;
167 		owner.transfer(amount);
168 	}
169 	
170 	// can accept ether
171 	function() payable {
172     }
173 }