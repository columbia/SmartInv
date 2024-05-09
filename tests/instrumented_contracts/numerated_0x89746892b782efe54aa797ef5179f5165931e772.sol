1 pragma solidity ^0.4.8;
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
37 contract CCICoin is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42 	address public owner;
43 
44     /* This creates an array with all balances */
45     mapping (address => uint256) public balanceOf;
46 	mapping (address => uint256) public freezeOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     /* This generates a public event on the blockchain that will notify clients */
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     /* This notifies clients about the amount burnt */
53     event Burn(address indexed from, uint256 value);
54 	
55 	/* This notifies clients about the amount frozen */
56     event Freeze(address indexed from, uint256 value);
57 	
58 	/* This notifies clients about the amount unfrozen */
59     event Unfreeze(address indexed from, uint256 value);
60         string tokenName;
61         uint8 decimalUnits;
62         string tokenSymbol;
63         uint256 public mined_coin_supply = 0;
64         uint256 public pre_mined_supply = 0;
65         uint256 public circulating_supply = 0;
66         uint256 public reward = 5000000000;
67         uint256 public timeOfLastHalving = now;
68         uint public timeOfLastIncrease = now;
69     /* Initializes contract with initial supply tokens to the creator of the contract */
70     function CCICoin() {
71         //balanceOf[msg.sender] = 2100000000000000;              // Give the creator all initial tokens
72         totalSupply = 2100000000000000;                        // Update total supply
73         name = "CryptoChips Coin";                            // Set the name for display purposes
74         symbol = "CCI";                               // Set the symbol for display purposes
75         decimals = 8;                            // Amount of decimals for display purposes
76 		owner = msg.sender;
77         timeOfLastHalving = now;
78     }
79 
80     function updateSupply() internal returns (uint256) {
81 
82       if (now - timeOfLastHalving >= 2100000 minutes) {
83         reward /= 2;
84         timeOfLastHalving = now;
85       }
86 
87       if (now - timeOfLastIncrease >= 150 seconds) {
88         uint256 increaseAmount = ((now - timeOfLastIncrease) / 1 seconds) * reward;
89       if (totalSupply>(pre_mined_supply+increaseAmount))
90         {
91           pre_mined_supply += increaseAmount;
92           mined_coin_supply += increaseAmount;
93           timeOfLastIncrease = now;
94         }
95       }
96 
97       circulating_supply = pre_mined_supply - mined_coin_supply;
98 
99       return circulating_supply;
100     }
101 
102     /* Send coins */
103     function transfer(address _to, uint256 _value) {
104         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
105 		if (_value <= 0) throw; 
106         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
107         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
108         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
109         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
110         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
111         
112     }
113 
114     /* Allow another contract to spend some tokens in your behalf */
115     function approve(address _spender, uint256 _value)
116         returns (bool success) {
117 		if (_value <= 0) throw; 
118         allowance[msg.sender][_spender] = _value;
119         return true;
120     }
121        
122 
123     /* A contract attempts to get the coins */
124     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
125         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
126 		if (_value <= 0) throw; 
127         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
128         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
129         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
130         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
131         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
132         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
133         Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     function burn(uint256 _value) returns (bool success) {
138         if (balanceOf[msg.sender] < _value) throw;                                           // Check if the sender has enough
139 		if (_value <= 0) throw; 
140         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender
141         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
142         Burn(msg.sender, _value);
143         return true;
144     }
145 	
146 	function freeze(uint256 _value) returns (bool success) {
147         if (balanceOf[msg.sender] < _value) throw;                                       // Check if the sender has enough
148 		if (_value <= 0) throw; 
149         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);        // Subtract from the sender
150         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
151         Freeze(msg.sender, _value);
152         return true;
153     }
154 	
155 	function unfreeze(uint256 _value) returns (bool success) {
156         if (freezeOf[msg.sender] < _value) throw;                                       // Check if the sender has enough
157 		if (_value <= 0) throw; 
158         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);          // Subtract from the sender
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
170 
171     
172     function mint(uint256 _value) {
173         if(msg.sender != owner)throw;
174         else{
175             mined_coin_supply -= _value; // Remove from unspent supply
176             balanceOf[msg.sender] =SafeMath.safeAdd(balanceOf[msg.sender], _value);  // Add the same to the recipient
177             updateSupply();
178         }
179 
180     }
181 	
182 	// can accept ether
183 	function() payable {
184     }
185 }