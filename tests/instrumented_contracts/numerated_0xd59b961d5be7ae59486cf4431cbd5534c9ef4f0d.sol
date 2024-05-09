1 pragma solidity ^0.4.12;
2 
3 
4 //Compiler Version:	v0.4.12+commit.194ff033
5 /**
6  * Math operations with safety checks
7  */
8 contract SafeMath {
9   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
16     assert(b > 0);
17     uint256 c = a / b;
18     assert(a == b * c + a % b);
19     return c;
20   }
21 
22   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c>=a && c>=b);
30     return c;
31   }
32 
33   function assert(bool assertion) internal {
34     if (!assertion) {
35       throw;
36     }
37   }
38 }
39 
40 contract owned {
41     address public owner;
42 
43     function owned() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address newOwner) onlyOwner public {
53         owner = newOwner;
54     }
55 }
56 contract TTCoin is SafeMath,owned{
57     string public name;
58     string public symbol;
59     uint8 public decimals=8;
60     uint256 public totalSupply;
61     uint256 public soldToken;
62 	//address public owner;
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
81   
82     /* Initializes contract with initial supply tokens to the creator of the contract */
83     function TTCoin(
84         
85         ) {
86                     // Give the creator all initial tokens
87         
88         totalSupply = 10000000000 *10**uint256(decimals);                        // Update total supply
89         balanceOf[msg.sender] = totalSupply; 
90         name = "TongTong Coin";                                   // Set the name for display purposes
91         symbol = "TTCoin";                               // Set the symbol for display purposes
92                                   // Amount of decimals for display purposes
93 		soldToken=0;
94     }
95 
96     /* Send coins */
97     function transfer(address _to, uint256 _value) {
98         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
99 		if (_value <= 0) throw; 
100         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
101         if (balanceOf[_to] + _value < balanceOf[_to]) revert();// Check for overflows
102        
103         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
104         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
105         soldToken+=_value;
106         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
107     }
108     /* Allow another contract to spend some tokens in your behalf */
109     function approve(address _spender, uint256 _value)
110         returns (bool success) {
111 		if (_value <= 0) throw; 
112         allowance[msg.sender][_spender] = _value;
113         return true;
114     }
115        
116 
117     /* A contract attempts to get the coins */
118     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
119         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
120 		if (_value <= 0) throw; 
121         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
122         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
123         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
124         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
125         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
126         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
127         soldToken +=_value;
128         Transfer(_from, _to, _value);
129         return true;
130     }
131 
132     function burn(uint256 _value) returns (bool success) {
133         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
134 		if (_value <= 0) throw; 
135         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
136         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
137         Burn(msg.sender, _value);
138         return true;
139     }
140 	
141 	function freeze(address _freeze,uint256 _value) onlyOwner returns (bool success) {
142         if (balanceOf[_freeze] < _value) throw;            // Check if the sender has enough
143 	    if (_value <= 0) throw; 
144         balanceOf[_freeze] = SafeMath.safeSub(balanceOf[_freeze], _value);                      // Subtract from the sender
145         freezeOf[_freeze] = SafeMath.safeAdd(freezeOf[_freeze], _value);                                // Updates totalSupply
146         Freeze(_freeze, _value);
147         return true;
148     }
149 	
150 	function unfreeze(address _unfreeze,uint256 _value) onlyOwner returns (bool success) {
151         if (freezeOf[_unfreeze] < _value) throw;            // Check if the sender has enough
152 		if (_value <= 0) throw; 
153         freezeOf[_unfreeze] = SafeMath.safeSub(freezeOf[_unfreeze], _value);                      // Subtract from the sender
154 		balanceOf[_unfreeze] = SafeMath.safeAdd(balanceOf[_unfreeze], _value);
155         Unfreeze(_unfreeze, _value);
156         return true;
157     }
158     
159     
160      function mintToken(address target, uint256 mintedAmount) onlyOwner public {
161         balanceOf[target] += mintedAmount;
162         totalSupply += mintedAmount;
163         Transfer(0, this, mintedAmount);
164         Transfer(this, target, mintedAmount);
165     }
166 	
167 	
168 
169 	
170 // can accept ether
171 	function() payable {
172     }
173 }