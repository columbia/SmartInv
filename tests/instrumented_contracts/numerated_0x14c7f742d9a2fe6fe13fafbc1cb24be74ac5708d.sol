1 pragma solidity ^0.4.23;
2 
3 /*
4 
5 P3D Charity Mining Pool
6 
7 - Splits deposit according to feeDivisor (default is 4 = 25% donation)
8     - Sends user donation plus current dividends to charity address (Giveth)
9     - Uses the rest to buy P3D tokens under the sender's masternode
10     - feeDivisor can be from 2 to 10 (50% to 10% donation range)
11 - Dividends accumulated by miner can be sent as donation at anytime
12 - Donors can sell their share of tokens at anytime and withdraw the ETH value!
13 
14 https://discord.gg/N4UShc3
15 
16 */
17 
18 contract ERC20Interface {
19     function transfer(address to, uint256 tokens) public returns (bool success);
20 }
21 
22 contract POWH {
23     function buy(address) public payable returns(uint256);
24     function sell(uint256) public;
25     function withdraw() public;
26     function myTokens() public view returns(uint256);
27     function myDividends(bool) public view returns(uint256);
28 }
29 
30 contract CharityMiner {
31     using SafeMath for uint256;
32     
33     // Modifiers
34     modifier notP3d(address aContract) {
35         require(aContract != address(p3d));
36         _;
37     }
38     
39     // Events
40     event Deposit(uint256 amount, address depositer, uint256 donation);
41     event Withdraw(uint256 tokens, address depositer, uint256 tokenValue, uint256 donation);
42     event Dividends(uint256 amount, address sender);
43     event Paused(bool paused);
44     
45     // Public Variables
46     bool public paused = false;
47     address public charityAddress = 0x8f951903C9360345B4e1b536c7F5ae8f88A64e79; // Giveth
48     address public owner;
49     address public P3DAddress;
50     address public largestDonor;
51     address public lastDonor;
52     uint public totalDonors;
53     uint public totalDonated;
54     uint public totalDonations;
55     uint public largestDonation;
56     uint public currentHolders;
57     uint public totalDividends;
58     
59     // Public Mappings
60     mapping( address => bool ) public donor;
61     mapping( address => uint256 ) public userTokens;
62     mapping( address => uint256 ) public userDonations;
63     
64     // PoWH Contract
65     POWH p3d;
66 	
67 	// Constructor
68 	constructor(address powh) public {
69 	    p3d = POWH(powh);
70 	    P3DAddress = powh;
71 	    owner = msg.sender;
72 	}
73 	
74 	// Pause
75 	// - In case charity address is no longer active or deposits have to be paused for unexpected reason
76 	// - Cannot be paused while anyone owns tokens
77 	function pause() public {
78 	    require(msg.sender == owner && myTokens() == 0);
79 	    paused = !paused;
80 	    
81 	    emit Paused(paused);
82 	}
83 	
84 	// Fallback
85 	// - Easy deposit, sets default feeDivisor
86 	function() payable public {
87 	    if(msg.sender != address(p3d)) { // Need to receive divs from P3D contract
88     	    uint8 feeDivisor = 4; // Default 25% donation
89     	    deposit(feeDivisor);
90 	    }
91 	}
92 
93 	// Deposit
94     // - Divide deposit by feeDivisor then add divs and send as donation
95 	// - Use the rest to buy P3D tokens under sender's masternode
96 	function deposit(uint8 feeDivisor) payable public {
97 	    require(msg.value > 100000 && !paused);
98 	    require(feeDivisor >= 2 && feeDivisor <= 10); // 50% to 10% donation range
99 	    
100 	    // If we have divs, withdraw them
101 	    uint divs = myDividends();
102 	    if(divs > 0){
103 	        p3d.withdraw();
104 	    }
105 	    
106 	    // Split deposit
107 	    uint fee = msg.value.div(feeDivisor);
108 	    uint purchase = msg.value.sub(fee);
109 	    uint donation = divs.add(fee);
110 	    
111 	    // Send donation
112 	    charityAddress.transfer(donation);
113 	    
114 	    // Buy tokens
115 	    uint tokens = myTokens();
116 	    p3d.buy.value(purchase)(msg.sender);
117 	    uint newTokens = myTokens().sub(tokens);
118 	    
119 	    // If new donor, add them to stats
120 	    if(!donor[msg.sender]){
121 	        donor[msg.sender] = true;
122 	        totalDonors += 1;
123 	        currentHolders += 1;
124 	    }
125 	    
126 	    // If largest donor, update stats
127 	    // Don't include dividends or token value in user donations
128 	    if(fee > largestDonation){ 
129 	        largestDonation = fee;
130 	        largestDonor = msg.sender;
131 	    }
132 	    
133 	    // Update stats and storage
134 	    totalDonations += 1;
135 	    totalDonated += donation;
136 	    totalDividends += divs;
137 	    lastDonor = msg.sender;
138 	    userDonations[msg.sender] = userDonations[msg.sender].add(fee); 
139 	    userTokens[msg.sender] = userTokens[msg.sender].add(newTokens);
140 	    
141 	    // Deposit event
142 	    emit Deposit(purchase, msg.sender, donation);
143 	}
144 	
145 	// Withdraw
146 	// - Sell user's tokens and withdraw the eth value, sends divs as donation
147 	// - User doesn't get any of the excess divs
148 	function withdraw() public {
149 	    uint tokens = userTokens[msg.sender];
150 	    require(tokens > 0);
151 	    
152 	    // Save divs and balance
153 	    uint divs = myDividends();
154 	    uint balance = address(this).balance;
155 	    
156 	    // Update before we sell
157 	    userTokens[msg.sender] = 0;
158 	    
159 	    // Sell tokens and withdraw
160 	    p3d.sell(tokens);
161 	    p3d.withdraw();
162 	    
163 	    // Get value of sold tokens
164 	    uint tokenValue = address(this).balance.sub(divs).sub(balance);
165 	    
166 	    // Send donation and payout
167 	    charityAddress.transfer(divs);
168 	    msg.sender.transfer(tokenValue);
169 	    
170 	    // Update stats
171 	    totalDonated += divs;
172 	    totalDividends += divs;
173 	    totalDonations += 1;
174 	    currentHolders -= 1;
175 	    
176 	    // Withdraw event
177 	    emit Withdraw(tokens, msg.sender, tokenValue, divs);
178 	}
179 	
180 	// SendDividends
181 	// - Withdraw dividends and send as donation (can be called by anyone)
182 	function sendDividends() public {
183 	    uint divs = myDividends();
184 	    // Don't want to spam them with tiny donations
185 	    require(divs > 100000);
186 	    p3d.withdraw();
187 	    
188 	    // Send donation
189 	    charityAddress.transfer(divs);
190 	    
191 	    // Update stats
192 	    totalDonated += divs;
193 	    totalDividends += divs;
194 	    totalDonations += 1;
195 	    
196 	    // Dividends event
197 	    emit Dividends(divs, msg.sender);
198 	}
199 	
200     // MyTokens
201     // - Retun tokens owned by this contract
202     function myTokens() public view returns(uint256) {
203         return p3d.myTokens();
204     }
205     
206 	// MyDividends
207 	// - Return contract's current dividends including referral bonus
208 	function myDividends() public view returns(uint256) {
209         return p3d.myDividends(true);
210     }
211 	
212 	// Rescue function to transfer tokens. Cannot be used on P3D.
213 	function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) public notP3d(tokenAddress) returns (bool success) {
214 		require(msg.sender == owner);
215 		return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
216 	}
217     
218 }
219 
220 
221 /**
222  * @title SafeMath
223  * @dev Math operations with safety checks that throw on error
224  */
225 library SafeMath {
226 
227   /**
228   * @dev Multiplies two numbers, throws on overflow.
229   */
230   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
231     if (a == 0) {
232       return 0;
233     }
234     c = a * b;
235     assert(c / a == b);
236     return c;
237   }
238 
239   /**
240   * @dev Integer division of two numbers, truncating the quotient.
241   */
242   function div(uint256 a, uint256 b) internal pure returns (uint256) {
243     // assert(b > 0); // Solidity automatically throws when dividing by 0
244     // uint256 c = a / b;
245     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
246     return a / b;
247   }
248 
249   /**
250   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
251   */
252   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
253     assert(b <= a);
254     return a - b;
255   }
256 
257   /**
258   * @dev Adds two numbers, throws on overflow.
259   */
260   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
261     c = a + b;
262     assert(c >= a);
263     return c;
264   }
265 }