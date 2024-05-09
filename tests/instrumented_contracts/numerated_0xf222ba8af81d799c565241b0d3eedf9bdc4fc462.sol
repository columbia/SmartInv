1 /**
2  *Cultural Theme Park (CTP)https://www.ctp.io  on 2019-09-1
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
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
41 contract CulturalThemePark is SafeMath{
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     uint256 public totalSupply;
46     uint256 ethExchuangeRate=13000;//eth  exchange rate
47 	address public owner;
48 
49     /* This creates an array with all balances */
50     mapping (address => uint256) public balanceOf;
51 	mapping (address => uint256) public freezeOf;
52     mapping (address => mapping (address => uint256)) public allowance;
53 
54     /* This generates a public event on the blockchain that will notify clients */
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     /* This notifies clients about the amount burnt */
58     event Burn(address indexed from, uint256 value);
59 	
60 	/* This notifies clients about the amount frozen */
61     event Freeze(address indexed from, uint256 value);
62 	
63 	/* This notifies clients about the amount unfrozen */
64     event Unfreeze(address indexed from, uint256 value);
65 
66     /* Initializes contract with initial supply tokens to the creator of the contract */
67     function CulturalThemePark(
68         uint256 initialSupply,
69         string tokenName,
70         uint8 decimalUnits,
71         string tokenSymbol
72         ) {
73         name = tokenName; // Set the name for display purposes
74         symbol = tokenSymbol; // Set the symbol for display purposes
75         decimals = decimalUnits;  
76         totalSupply = initialSupply * 10 ** uint256(decimals);
77         balanceOf[msg.sender] = totalSupply;  // Amount of decimals for display purposes
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
99        
100 
101     /* A contract attempts to get the coins */
102     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
103         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
104 		if (_value <= 0) throw; 
105         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
106         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
107         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
108         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
109         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
110         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
111         Transfer(_from, _to, _value);
112         return true;
113     }
114 
115     function burn(uint256 _value) returns (bool success) {
116         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
117 		if (_value <= 0) throw; 
118         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
119         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
120         Burn(msg.sender, _value);
121         return true;
122     }
123 	
124 	function freeze(uint256 _value) returns (bool success) {
125         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
126 		if (_value <= 0) throw; 
127         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
128         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
129         Freeze(msg.sender, _value);
130         return true;
131     }
132 	
133 	function unfreeze(uint256 _value) returns (bool success) {
134         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
135 		if (_value <= 0) throw; 
136         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
137 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
138         Unfreeze(msg.sender, _value);
139         return true;
140     }
141 	
142 	// transfer balance to owner
143 	function withdrawEther(uint256 amount) {
144 		if(msg.sender != owner)throw;
145 		owner.transfer(amount);
146 	}
147 	function Crowdfunding()payable public{
148 	    uint256 amount_eth=msg.value;
149 	    uint256 ethExchuange=amount_eth*ethExchuangeRate;
150 	    if(balanceOf[this] < ethExchuange)throw;
151 	    balanceOf[this]-=ethExchuange;
152 	    balanceOf[msg.sender]+=ethExchuange;
153 	}
154 	function exchangeRate(uint256 _value){
155 	    if(msg.sender != owner)throw;
156 	    ethExchuangeRate=_value;
157 	}
158 	// can accept ether
159 	function() payable {
160     }
161 }