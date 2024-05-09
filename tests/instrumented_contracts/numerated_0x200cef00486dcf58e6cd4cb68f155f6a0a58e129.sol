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
37 contract CCTHCoin is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42 	address public owner;
43 
44     /* This creates an array with all balances */
45     mapping (address => uint256) public balanceOf;
46 	mapping (address => uint256) public freezeOf;
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
60         string tokenName;
61         uint8 decimalUnits;
62         string tokenSymbol;
63         uint256 public mined_coin_supply = 0;
64         uint256 public pre_mined_supply = 0;
65         uint256 public circulating_supply = 0;
66         uint256 public reward = 5000000000;
67         uint256 public timeOfLastHalving = now;
68         uint public timeOfLastIncrease = now;
69     
70     /* Initializes contract with initial supply tokens to the creator of the contract */
71     function CCTHCoin() {
72         //balanceOf[msg.sender] = 2100000000000000;              // Give the creator all initial tokens
73         totalSupply = 2100000000000000;                        // Update total supply
74         name = "CryptoChips Coin";                            // Set the name for display purposes
75         symbol = "CCTH";                               // Set the symbol for display purposes
76         decimals = 8;                            // Amount of decimals for display purposes
77 		owner = msg.sender;
78         timeOfLastHalving = now;
79     }
80 
81     function updateSupply() internal returns (uint256) {
82 
83       if (now - timeOfLastHalving >= 2100000 minutes) {
84         reward /= 2;
85         timeOfLastHalving = now;
86       }
87 
88       if (now - timeOfLastIncrease >= 150 seconds) {
89         uint256 increaseAmount = ((now - timeOfLastIncrease) / 60 seconds) * reward;
90       if (totalSupply>(pre_mined_supply+increaseAmount))
91         {
92           pre_mined_supply += increaseAmount;
93           mined_coin_supply += increaseAmount;
94           timeOfLastIncrease = now;
95         }
96       }
97 
98       circulating_supply = pre_mined_supply - mined_coin_supply;
99 
100       return circulating_supply;
101     }
102     
103     /* Send coins */
104     function transfer(address _to, uint256 _value) public {
105         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
106         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
107         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);               // Subtract from the sender
108         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
109 
110         /* Notify anyone listening that the transfer took place */
111         Transfer(msg.sender, _to, _value);
112 
113     }
114     function burn(uint256 _value) returns (bool success) {
115         if (balanceOf[msg.sender] < _value) throw;                                           // Check if the sender has enough
116 		if (_value <= 0) throw; 
117         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender
118         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
119         Burn(msg.sender, _value);
120         return true;
121     }
122 	
123 	function freeze(uint256 _value) returns (bool success) {
124         if (balanceOf[msg.sender] < _value) throw;                                       // Check if the sender has enough
125 		if (_value <= 0) throw; 
126         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);        // Subtract from the sender
127         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
128         Freeze(msg.sender, _value);
129         return true;
130     }
131 	
132 	function unfreeze(uint256 _value) returns (bool success) {
133         if (freezeOf[msg.sender] < _value) throw;                                       // Check if the sender has enough
134 		if (_value <= 0) throw; 
135         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);          // Subtract from the sender
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
147 
148     
149     function mint(uint256 _value) {
150         if(msg.sender != owner)throw;
151         else{
152             mined_coin_supply -= _value; // Remove from unspent supply
153             balanceOf[msg.sender] =SafeMath.safeAdd(balanceOf[msg.sender], _value);  // Add the same to the recipient
154             updateSupply();
155         }
156 
157     }
158 	
159 	// can accept ether
160 	function() payable {
161     }
162 }