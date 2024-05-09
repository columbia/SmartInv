1 pragma solidity ^0.4.20;
2 /**
3  * Math operations with checks
4  */
5 contract KVCMath {
6   function kvcMul(uint256 a, uint256 b) internal returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function kvcDiv(uint256 a, uint256 b) internal returns (uint256) {
13     assert(b > 0);
14     uint256 c = a / b;
15     assert(a == b * c + a % b);
16     return c;
17   }
18 
19   function kvcSub(uint256 a, uint256 b) internal returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function kvcAdd(uint256 a, uint256 b) internal returns (uint256) {
25     uint256 c = a + b;
26     assert(c>=a && c>=b);
27     return c;
28   }
29 
30   function assert(bool assertion) internal {
31     if (!assertion) {
32       throw;
33     }
34   }
35 }
36 contract KVC is KVCMath{
37     string public name;
38     string public symbol;
39     uint8 public decimals;
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
61     function KVC(
62         uint256 initialSupply,
63         string tokenName,
64         uint8 decimalUnits,
65         string tokenSymbol
66         ) {
67         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
68         totalSupply = initialSupply;                        // Update total supply
69         name = tokenName;                                   // Set the name for display purposes
70         symbol = tokenSymbol;                               // Set the symbol for display purposes
71         decimals = decimalUnits;                            // Amount of decimals for display purposes
72 		owner = msg.sender;
73     }
74 
75     /* Send coins */
76     function transfer(address _to, uint256 _value) {
77         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
78 		if (_value <= 0) throw; 
79         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
80         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
81         balanceOf[msg.sender] = KVCMath.kvcSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
82         balanceOf[_to] = KVCMath.kvcAdd(balanceOf[_to], _value);                            // Add the same to the recipient
83         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
84     }
85 
86     /* Allow another contract to spend some tokens in your behalf */
87     function approve(address _spender, uint256 _value)
88         returns (bool success) {
89 		if (_value <= 0) throw; 
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93        
94 
95     /* A contract attempts to get the coins */
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
97         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
98 		if (_value <= 0) throw; 
99         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
100         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
101         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
102         balanceOf[_from] = KVCMath.kvcSub(balanceOf[_from], _value);                           // Subtract from the sender
103         balanceOf[_to] = KVCMath.kvcAdd(balanceOf[_to], _value);                             // Add the same to the recipient
104         allowance[_from][msg.sender] = KVCMath.kvcSub(allowance[_from][msg.sender], _value);
105         Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function burn(uint256 _value) returns (bool success) {
110         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
111 		if (_value <= 0) throw; 
112         balanceOf[msg.sender] = KVCMath.kvcSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
113         totalSupply = KVCMath.kvcSub(totalSupply,_value);                                // Updates totalSupply
114         Burn(msg.sender, _value);
115         return true;
116     }
117 	
118 	function freeze(uint256 _value) returns (bool success) {
119         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
120 		if (_value <= 0) throw; 
121         balanceOf[msg.sender] = KVCMath.kvcSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
122         freezeOf[msg.sender] = KVCMath.kvcAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
123         Freeze(msg.sender, _value);
124         return true;
125     }
126 	
127 	function unfreeze(uint256 _value) returns (bool success) {
128         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
129 		if (_value <= 0) throw; 
130         freezeOf[msg.sender] = KVCMath.kvcSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
131 		balanceOf[msg.sender] = KVCMath.kvcAdd(balanceOf[msg.sender], _value);
132         Unfreeze(msg.sender, _value);
133         return true;
134     }
135 	
136 	// transfer balance to owner
137 	function withdrawEther(uint256 amount) {
138 		if(msg.sender != owner)throw;
139 		owner.transfer(amount);
140 	}
141 	
142 	// can accept ether
143 	function() payable {
144     }
145 }