1 // ----------------------------------------------------------------------------
2 // 'CTB' 'CrypTollBooth Token' token contract
3 //
4 // Symbol      : CTB
5 // Name        : CrypTollBooth
6 // Total supply: 50,000,000.000000000
7 // Decimals    : 9
8 //
9 // Enjoy.
10 //
11 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 /**
19  * Math operations with safety checks
20  */
21 contract SafeMath {
22   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
29     assert(b > 0);
30     uint256 c = a / b;
31     assert(a == b * c + a % b);
32     return c;
33   }
34 
35   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
41     uint256 c = a + b;
42     assert(c>=a && c>=b);
43     return c;
44   }
45 
46   function assert(bool assertion) internal {
47     if (!assertion) {
48       throw;
49     }
50   }
51 }
52 
53 
54 interface token {
55     function transfer(address receiver, uint amount);
56 }
57 
58 contract Crowdsale {
59     address public beneficiary;
60     uint public fundingGoal;
61     uint public amountRaised;
62     uint public deadline;
63     uint public price;
64     token public tokenReward;
65     mapping(address => uint256) public balanceOf;
66     bool fundingGoalReached = false;
67     bool crowdsaleClosed = false;
68 
69     event GoalReached(address recipient, uint totalAmountRaised);
70     event FundTransfer(address backer, uint amount, bool isContribution);
71 
72     /**
73      * Constructor function
74      *
75      * Setup the owner
76      */
77     function Crowdsale(
78         address ifSuccessfulSendTo,
79         uint fundingGoalInEthers,
80         uint durationInMinutes,
81         uint etherCostOfEachToken,
82         address addressOfTokenUsedAsReward
83     ) {
84         beneficiary = ifSuccessfulSendTo;
85         fundingGoal = fundingGoalInEthers * 1 ether;
86         deadline = 1523577600 + durationInMinutes * 1 minutes;
87         price = etherCostOfEachToken * 1 ether;
88         tokenReward = token(addressOfTokenUsedAsReward);
89     }
90 
91     /**
92      * Fallback function
93      *
94      * The function without name is the default function that is called whenever anyone sends funds to a contract
95      */
96     function () payable {
97         require(!crowdsaleClosed);
98         uint amount = msg.value;
99         balanceOf[msg.sender] += amount;
100         amountRaised += amount;
101         tokenReward.transfer(msg.sender, amount / price);
102         FundTransfer(msg.sender, amount, true);
103     }
104 
105     modifier afterDeadline() { if (now >= deadline) _; }
106 
107     /**
108      * Check if goal was reached
109      *
110      * Checks if the goal or time limit has been reached and ends the campaign
111      */
112     function checkGoalReached() afterDeadline {
113         if (amountRaised >= fundingGoal){
114             fundingGoalReached = true;
115             GoalReached(beneficiary, amountRaised);
116         }
117         crowdsaleClosed = true;
118     }
119 }
120 
121 contract CrypTollBoothToken is SafeMath{
122     string public name;
123     string public symbol;
124     uint8 public decimals;
125     uint256 public totalSupply;
126 	address public owner;
127 
128     /* This creates an array with all balances */
129     mapping (address => uint256) public balanceOf;
130 	mapping (address => uint256) public freezeOf;
131     mapping (address => mapping (address => uint256)) public allowance;
132 
133     /* This generates a public event on the blockchain that will notify clients */
134     event Transfer(address indexed from, address indexed to, uint256 value);
135 
136     /* This notifies clients about the amount burnt */
137     event Burn(address indexed from, uint256 value);
138 	
139 	/* This notifies clients about the amount frozen */
140     event Freeze(address indexed from, uint256 value);
141 	
142 	/* This notifies clients about the amount unfrozen */
143     event Unfreeze(address indexed from, uint256 value);
144 
145     /* Initializes contract with initial supply tokens to the creator of the contract */
146     function CrypTollBoothToken(
147         uint256 initialSupply,
148         string tokenName,
149         uint8 decimalUnits,
150         string tokenSymbol
151         ) {
152         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
153         totalSupply = initialSupply;                        // Update total supply
154         name = tokenName;                                   // Set the name for display purposes
155         symbol = tokenSymbol;                               // Set the symbol for display purposes
156         decimals = decimalUnits;                            // Amount of decimals for display purposes
157 		owner = msg.sender;
158     }
159 
160     /* Send coins */
161     function transfer(address _to, uint256 _value) {
162         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
163 		if (_value <= 0) throw; 
164         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
165         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
166         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
167         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
168         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
169     }
170 
171     /* Allow another contract to spend some tokens in your behalf */
172     function approve(address _spender, uint256 _value)
173         returns (bool success) {
174 		if (_value <= 0) throw; 
175         allowance[msg.sender][_spender] = _value;
176         return true;
177     }
178        
179 
180     /* A contract attempts to get the coins */
181     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
182         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
183 		if (_value <= 0) throw; 
184         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
185         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
186         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
187         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
188         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
189         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
190         Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     function burn(uint256 _value) returns (bool success) {
195         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
196 		if (_value <= 0) throw; 
197         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
198         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
199         Burn(msg.sender, _value);
200         return true;
201     }
202 	
203 	function freeze(uint256 _value) returns (bool success) {
204         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
205 		if (_value <= 0) throw; 
206         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
207         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
208         Freeze(msg.sender, _value);
209         return true;
210     }
211 	
212 	function unfreeze(uint256 _value) returns (bool success) {
213         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
214 		if (_value <= 0) throw; 
215         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
216 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
217         Unfreeze(msg.sender, _value);
218         return true;
219     }
220 	
221 	// transfer balance to owner
222 	function withdrawEther(uint256 amount) {
223 		if(msg.sender != owner)throw;
224 		owner.transfer(amount);
225 	}
226 	
227 	// can accept ether
228 	function() payable {
229     }
230 }