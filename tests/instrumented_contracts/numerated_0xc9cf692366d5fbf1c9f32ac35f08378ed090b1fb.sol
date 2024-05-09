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
37 contract GDU is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42 	address public owner;
43 	
44 	uint256 createTime;
45 	
46 	address addr1;
47 	address addr2;
48 	address addr3;
49 	address addr4;
50 	
51 
52     /* This creates an array with all balances */
53     mapping (address => uint256) public balanceOf;
54 	mapping (address => uint256) public freezeOf;
55     mapping (address => mapping (address => uint256)) public allowance;
56 
57     /* This generates a public event on the blockchain that will notify clients */
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 
60     /* This notifies clients about the amount burnt */
61     event Burn(address indexed from, uint256 value);
62 	
63 	/* This notifies clients about the amount frozen */
64     event Freeze(address indexed from, uint256 value);
65 	
66 	/* This notifies clients about the amount unfrozen */
67     event Unfreeze(address indexed from, uint256 value);
68 
69     /* Initializes contract with initial supply tokens to the creator of the contract */
70     function GDU() {
71         balanceOf[msg.sender] = 15 * (10 ** 8) * (10 ** 18);              // Give the creator all initial tokens
72         totalSupply =  100 * (10 ** 8) * (10 ** 18);                        // Update total supply
73         name = "GD Union";                                   // Set the name for display purposes
74         symbol = "GDU";                               // Set the symbol for display purposes
75         decimals = 18;                            // Amount of decimals for display purposes
76 		owner = msg.sender;
77 		createTime = now;
78 		
79 		addr1 = 0xa201967b67fA4Da2F7f4Cc2a333d2594fC44d350;
80 		addr2 = 0xC49909D6Cc0B460ADB33E591eC314DC817E9d200;
81 		addr3 = 0x455A3Ac6f11e6c301E4e5996F26EfaA76c549474;
82 		addr4 = 0xA93EAe1Db16F8710293a505289B0c8C34af5332F;
83 	
84 		for(int i = 0;i < 10;i++) {
85 		    mouthUnlockList.push(0.5 * (10 ** 8) * (10 ** 18));
86 		}
87 		addrCanWithdraw[addr1] = mouthUnlockList;
88 		addrCanWithdraw[addr2] = mouthUnlockList;
89 		addrCanWithdraw[addr3] = mouthUnlockList;
90 		
91 		for(uint256 year = 0;year < 4;year++) {
92 		    yearUnlockList.push(10 * (10 ** 8) * (10 ** 18) + year * 5 * (10 ** 8) * (10 ** 18));
93 		}
94 		addrCanWithdraw[addr4] = yearUnlockList;
95 		
96     }
97     
98     uint256[] mouthUnlockList;
99     uint256[] yearUnlockList;
100     mapping (address => uint256[]) addrCanWithdraw;
101     
102     modifier onlyMounthWithdrawer {
103         require(msg.sender == addr1 || msg.sender == addr2 || msg.sender == addr3 );
104         _;
105     }
106     modifier onlyYearWithdrawer {
107         require(msg.sender == addr4 );
108         _;
109     }
110     
111     function withdrawUnlockMonth() onlyMounthWithdrawer {
112         uint256 currentTime = now;
113         uint256 times = (currentTime  - createTime) / 2190 hours;
114         for(uint256 i = 0;i < times; i++) {
115             balanceOf[msg.sender] += addrCanWithdraw[msg.sender][i];
116             addrCanWithdraw[msg.sender][i] = 0;
117         }
118     }
119     
120     function withdrawUnlockYear() onlyYearWithdrawer {
121         uint256 currentTime = now;
122         require((currentTime  - createTime) > 0);
123         uint256 times = (currentTime  - createTime) / 1 years;
124         require(times <= 3);
125         for(uint256 i = 0;i < times; i++) {
126             balanceOf[msg.sender] += addrCanWithdraw[msg.sender][i];
127             addrCanWithdraw[msg.sender][i] = 0;
128         }
129     }
130     
131     
132 
133     /* Send coins */
134     function transfer(address _to, uint256 _value) {
135         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
136 		if (_value <= 0) throw; 
137         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
138         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
139         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
140         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
141         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
142     }
143 
144     /* Allow another contract to spend some tokens in your behalf */
145     function approve(address _spender, uint256 _value)
146         returns (bool success) {
147 		if (_value <= 0) throw; 
148         allowance[msg.sender][_spender] = _value;
149         return true;
150     }
151        
152 
153     /* A contract attempts to get the coins */
154     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
155         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
156 		if (_value <= 0) throw; 
157         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
158         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
159         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
160         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
161         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
162         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
163         Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     function burn(uint256 _value) returns (bool success) {
168         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
169 		if (_value <= 0) throw; 
170         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
171         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
172         Burn(msg.sender, _value);
173         return true;
174     }
175 	
176 	function freeze(uint256 _value) returns (bool success) {
177         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
178 		if (_value <= 0) throw; 
179         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
180         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
181         Freeze(msg.sender, _value);
182         return true;
183     }
184 	
185 	function unfreeze(uint256 _value) returns (bool success) {
186         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
187 		if (_value <= 0) throw; 
188         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
189 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
190         Unfreeze(msg.sender, _value);
191         return true;
192     }
193 	
194 	// transfer balance to owner
195 	function withdrawEther(uint256 amount) payable {
196 		if(msg.sender != owner)throw;
197 		owner.transfer(amount);
198 	}
199 	
200 	// can accept ether
201 	function() payable {
202     }
203 }