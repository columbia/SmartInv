1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'CTB' 'CrypTollBooth Token' token contract
5 //
6 // Symbol      : CTB
7 // Name        : CrypTollBooth
8 // Total supply: 50,000,000.000000000
9 // Decimals    : 9
10 //
11 // Enjoy.
12 //
13 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 /**
21  * Math operations with safety checks
22  */
23 contract SafeMath {
24   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
31     assert(b > 0);
32     uint256 c = a / b;
33     assert(a == b * c + a % b);
34     return c;
35   }
36 
37   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
43     uint256 c = a + b;
44     assert(c>=a && c>=b);
45     return c;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 interface token {
57     function transfer(address receiver, uint amount);
58 }
59 
60 contract Crowdsale {
61     address public beneficiary;
62     uint public fundingGoal;
63     uint public amountRaised;
64     uint public deadline;
65     uint public price;
66     token public tokenReward;
67     mapping(address => uint256) public balanceOf;
68     bool fundingGoalReached = false;
69     bool crowdsaleClosed = false;
70 
71     event GoalReached(address recipient, uint totalAmountRaised);
72     event FundTransfer(address backer, uint amount, bool isContribution);
73 
74     /**
75      * Constructor function
76      *
77      * Setup the owner
78      */
79     function Crowdsale(
80         address ifSuccessfulSendTo,
81         uint fundingGoalInEthers,
82         uint durationInMinutes,
83         uint etherCostOfEachToken,
84         address addressOfTokenUsedAsReward
85     ) {
86         beneficiary = ifSuccessfulSendTo;
87         fundingGoal = fundingGoalInEthers * 1 ether;
88         deadline = 1523577600 + durationInMinutes * 1 minutes;
89         price = etherCostOfEachToken * 1 ether;
90         tokenReward = token(addressOfTokenUsedAsReward);
91     }
92 
93     /**
94      * Fallback function
95      *
96      * The function without name is the default function that is called whenever anyone sends funds to a contract
97      */
98     function () payable {
99         require(!crowdsaleClosed);
100         uint amount = msg.value;
101         balanceOf[msg.sender] += amount;
102         amountRaised += amount;
103         tokenReward.transfer(msg.sender, amount / price);
104         FundTransfer(msg.sender, amount, true);
105     }
106 
107     modifier afterDeadline() { if (now >= deadline) _; }
108 
109     /**
110      * Check if goal was reached
111      *
112      * Checks if the goal or time limit has been reached and ends the campaign
113      */
114     function checkGoalReached() afterDeadline {
115         if (amountRaised >= fundingGoal){
116             fundingGoalReached = true;
117             GoalReached(beneficiary, amountRaised);
118         }
119         crowdsaleClosed = true;
120     }
121 }
122 
123 contract CrypTollBoothToken is SafeMath{
124     string public name;
125     string public symbol;
126     uint8 public decimals;
127     uint256 public totalSupply;
128 	address public owner;
129 
130     /* This creates an array with all balances */
131     mapping (address => uint256) public balanceOf;
132 	mapping (address => uint256) public freezeOf;
133     mapping (address => mapping (address => uint256)) public allowance;
134 
135     /* This generates a public event on the blockchain that will notify clients */
136     event Transfer(address indexed from, address indexed to, uint256 value);
137 
138     /* This notifies clients about the amount burnt */
139     event Burn(address indexed from, uint256 value);
140 	
141 	/* This notifies clients about the amount frozen */
142     event Freeze(address indexed from, uint256 value);
143 	
144 	/* This notifies clients about the amount unfrozen */
145     event Unfreeze(address indexed from, uint256 value);
146 
147     /* Initializes contract with initial supply tokens to the creator of the contract */
148     function CrypTollBoothToken(
149         uint256 initialSupply,
150         string tokenName,
151         uint8 decimalUnits,
152         string tokenSymbol
153         ) {
154         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
155         totalSupply = initialSupply;                        // Update total supply
156         name = tokenName;                                   // Set the name for display purposes
157         symbol = tokenSymbol;                               // Set the symbol for display purposes
158         decimals = decimalUnits;                            // Amount of decimals for display purposes
159 		owner = msg.sender;
160     }
161 
162     /* Send coins */
163     function transfer(address _to, uint256 _value) {
164         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
165 		if (_value <= 0) throw; 
166         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
167         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
168         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
169         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
170         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
171     }
172 
173     /* Allow another contract to spend some tokens in your behalf */
174     function approve(address _spender, uint256 _value)
175         returns (bool success) {
176 		if (_value <= 0) throw; 
177         allowance[msg.sender][_spender] = _value;
178         return true;
179     }
180        
181 
182     /* A contract attempts to get the coins */
183     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
184         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
185 		if (_value <= 0) throw; 
186         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
187         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
188         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
189         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
190         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
191         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
192         Transfer(_from, _to, _value);
193         return true;
194     }
195 
196     function burn(uint256 _value) returns (bool success) {
197         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
198 		if (_value <= 0) throw; 
199         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
200         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
201         Burn(msg.sender, _value);
202         return true;
203     }
204 	
205 	function freeze(uint256 _value) returns (bool success) {
206         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
207 		if (_value <= 0) throw; 
208         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
209         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
210         Freeze(msg.sender, _value);
211         return true;
212     }
213 	
214 	function unfreeze(uint256 _value) returns (bool success) {
215         if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough
216 		if (_value <= 0) throw; 
217         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
218 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
219         Unfreeze(msg.sender, _value);
220         return true;
221     }
222 	
223 	// transfer balance to owner
224 	function withdrawEther(uint256 amount) {
225 		if(msg.sender != owner)throw;
226 		owner.transfer(amount);
227 	}
228 	
229 	// can accept ether
230 	function() payable {
231     }
232 }