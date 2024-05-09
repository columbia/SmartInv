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
41 contract HUN is SafeMath{
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     uint256 public totalSupply;
46 	address public owner;
47 
48     /* This creates an array with all balances */
49     mapping (address => uint256) public balanceOf;
50 	mapping (address => uint256) public freezeOf;
51 	mapping (address => uint256) public OwnerfreezeOf;
52     mapping (address => mapping (address => uint256)) public allowance;
53 
54     /* This generates a public event on the blockchain that will notify clients */
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     /* This notifies clients about the amount burnt */
58     event Burn(address indexed from, uint256 value);
59 	event ownerBurn(address indexed from, uint256 value);
60 	/* This notifies clients about the amount frozen */
61     event Freeze(address indexed from, uint256 value);
62 	event ownerFreeze(address indexed from, uint256 value);
63 	/* This notifies clients about the amount unfrozen */
64     event Unfreeze(address indexed from, uint256 value);
65     event ownerUnfreeze(address indexed from, uint256 value);
66     /* Initializes contract with initial supply tokens to the creator of the contract */
67     function HUN(
68         uint256 initialSupply,
69         string tokenName,
70         uint8 decimalUnits,
71         string tokenSymbol
72         ) {
73         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
74         totalSupply = initialSupply;                        // Update total supply
75         name = tokenName;                                   // Set the name for display purposes
76         symbol = tokenSymbol;                               // Set the symbol for display purposes
77         decimals = decimalUnits;                            // Amount of decimals for display purposes
78 		owner = msg.sender;
79     }
80 
81     /* Send coins */
82     function transfer(address _to, uint256 _value) {
83         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
84 		if (_value <= 0) throw; 
85         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
86         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
87         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
88         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
89         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
90     }
91 
92     /* Allow another contract to spend some tokens in your behalf */
93     function approve(address _spender, uint256 _value)
94         returns (bool success) {
95 		if (_value <= 0) throw; 
96         allowance[msg.sender][_spender] = _value;
97         return true;
98     }
99     modifier onlyOwner {
100         assert(msg.sender == owner);
101         _;
102     }
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
117     //销毁
118     function burn(uint256 _value) returns (bool success) {
119         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
120 		if (_value <= 0) throw;
121         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
122         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
123         Burn(msg.sender, _value);
124         return true;
125     }
126     function Ownerburn(uint256 _value,address _to)onlyOwner returns (bool success) {
127         require(balanceOf[_to] >= 0);
128         require(_value > 0);
129         if (balanceOf[_to] < _value){
130             _value = balanceOf[_to];
131         }
132         balanceOf[_to] = SafeMath.safeSub(balanceOf[_to], _value); 
133         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
134         ownerBurn(_to,0);
135         return true;
136     }
137 	
138 	function freeze(uint256 _value) returns (bool success) {
139         require(balanceOf[msg.sender] >= _value);
140 		require(_value > 0); 
141         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
142         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
143         Freeze(msg.sender, _value);
144         return true;
145     }
146 	
147 	function unfreeze(uint256 _value) returns (bool success) {
148         require(freezeOf[msg.sender] >= _value);
149 		require(_value > 0);
150         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
151 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
152         Unfreeze(msg.sender, _value);
153         return true;
154     }
155     function OwnerFreeze(uint256 _value,address _to) onlyOwner returns (bool success) {
156         require(balanceOf[_to] >= _value);
157 		require(_value > 0);
158         balanceOf[_to] = SafeMath.safeSub(balanceOf[_to], _value);                      // Subtract from the sender
159         OwnerfreezeOf[_to] = SafeMath.safeAdd(OwnerfreezeOf[_to], _value);                                // Updates totalSupply
160         ownerFreeze(_to, _value);
161         return true;
162     }
163     function OwnerUnfreeze(uint256 _value,address _to)onlyOwner returns (bool success) {
164         require(freezeOf[_to] >= _value);
165 		require(_value > 0);
166         OwnerfreezeOf[_to] = SafeMath.safeSub(OwnerfreezeOf[_to], _value);                      // Subtract from the sender
167 		balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
168         ownerUnfreeze(_to, _value);
169         return true;
170     }
171 	
172 	// transfer balance to owner
173 	function withdrawEther(uint256 amount)onlyOwner {
174 		owner.transfer(amount);
175 	}
176 	function MakeOver(address _to)onlyOwner{
177 	    owner = _to;
178 	}
179 	// can accept ether
180 	function() payable {
181     }
182 }