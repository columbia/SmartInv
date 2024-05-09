1 pragma solidity ^0.4.18;
2 /*
3 TwoXJackpot - A modification to TwoX that turns the 5% developer fee into a jackpot!
4 - Double your ether.
5 - 5% of purchase goes towards a jackpot.
6 - Any purchase of 1% of the JackPot total qualifies you.
7 - The last qualified address has a claim to the jackpot if no new qualified (1%) purchases in 6 hours.
8 - Claim must be made, any new purchase resets the timer and invalidate the previous claim.
9 - Admin can empty the jackpot if no new action and no claim in 30 days.
10 */
11 
12 contract TwoXJackpot {
13   using SafeMath for uint256;
14 
15   // Address of the contract creator
16   address public contractOwner;
17 
18   // FIFO queue
19   BuyIn[] public buyIns;
20 
21   // The current BuyIn queue index
22   uint256 public index;
23 
24   // Total invested for entire contract
25   uint256 public contractTotalInvested;
26 
27   // Dev Fee (1%)
28   uint256 public devFeeBalance;
29 
30   // Total of Jackpot
31   uint256 public jackpotBalance;
32 
33   // Track amount of seed money put into jackpot.
34   uint256 public seedAmount;
35 
36   // The last qualified address to get into the jackpot.
37   address public jackpotLastQualified;
38 
39   // Timestamp of the last action.
40   uint256 public lastAction;
41 
42   // Timestamp of Game Start
43   uint256 public gameStartTime;
44 
45   // Total invested for a given address
46   mapping (address => uint256) public totalInvested;
47 
48   // Total value for a given address
49   mapping (address => uint256) public totalValue;
50 
51   // Total paid out for a given address
52   mapping (address => uint256) public totalPaidOut;
53 
54   struct BuyIn {
55     uint256 value;
56     address owner;
57   }
58 
59   modifier onlyContractOwner() {
60     require(msg.sender == contractOwner);
61     _;
62   }
63 
64   modifier isStarted() {
65       require(now >= gameStartTime);
66       _;
67   }
68 
69   function TwoXJackpot() public {
70     contractOwner = msg.sender;
71     gameStartTime = now + 24 hours;
72   }
73 
74   //                 //
75   // ADMIN FUNCTIONS //
76   //                 //
77 
78   // return jackpot to contract creator if no purchases or claims in 30 days.
79   function killme() public payable onlyContractOwner {
80     require(now > lastAction + 30 days);
81     seedAmount = 0;
82     jackpotBalance = 0;
83     contractOwner.transfer(jackpotBalance);
84   }
85 
86   // Contract owner can seed the Jackpot, and get it back whenever Jackpot is paid. See claim() function
87   function seed() public payable onlyContractOwner {
88     seedAmount += msg.value;     // Amount owner gets back on payout.
89     jackpotBalance += msg.value; // Increase the value of the jackpot by this much.
90   }
91 
92   // Change the start time.
93   function changeStartTime(uint256 _time) public payable onlyContractOwner {
94     require(now < _time); // only allow changing it to something in the future.
95     require(now < gameStartTime); // Only change a game that has not started, prevent abuse.
96     gameStartTime = _time;
97   }
98 
99   //                //
100   // User Functions //
101   //                //
102 
103   function purchase() public payable isStarted {
104 
105     uint256 purchaseMin = SafeMath.mul(msg.value, 20); // 5% Jackpot Min Purchase
106     uint256 purchaseMax = SafeMath.mul(msg.value, 2); // 50% Jackpot Min Purchase
107 
108     require(purchaseMin >= jackpotBalance);
109     require(purchaseMax <= jackpotBalance);
110 
111     // Take a 5% fee
112     uint256 valueAfterTax = SafeMath.div(SafeMath.mul(msg.value, 95), 100);
113 
114     // Calculate the absolute number to put into pot. (5% total purchase)
115     uint256 potFee = SafeMath.sub(msg.value, valueAfterTax);
116 
117     // Add it to the jackpot
118     jackpotBalance += potFee;
119     jackpotLastQualified = msg.sender;
120     lastAction = now;
121 
122     // HNNNNNNGGGGGG
123     uint256 valueMultiplied = SafeMath.mul(msg.value, 2);
124 
125     contractTotalInvested += msg.value;
126     totalInvested[msg.sender] += msg.value;
127 
128     while (index < buyIns.length && valueAfterTax > 0) {
129       BuyIn storage buyIn = buyIns[index];
130 
131       if (valueAfterTax < buyIn.value) {
132         buyIn.owner.transfer(valueAfterTax);
133         totalPaidOut[buyIn.owner] += valueAfterTax;
134         totalValue[buyIn.owner] -= valueAfterTax;
135         buyIn.value -= valueAfterTax;
136         valueAfterTax = 0;
137       } else {
138         buyIn.owner.transfer(buyIn.value);
139         totalPaidOut[buyIn.owner] += buyIn.value;
140         totalValue[buyIn.owner] -= buyIn.value;
141         valueAfterTax -= buyIn.value;
142         buyIn.value = 0;
143         index++;
144       }
145     }
146 
147     // if buyins have been exhausted, return the remaining
148     // funds back to the investor
149     if (valueAfterTax > 0) {
150       msg.sender.transfer(valueAfterTax);
151       valueMultiplied -= valueAfterTax;
152       totalPaidOut[msg.sender] += valueAfterTax;
153     }
154 
155     totalValue[msg.sender] += valueMultiplied;
156 
157     buyIns.push(BuyIn({
158       value: valueMultiplied,
159       owner: msg.sender
160     }));
161   }
162 
163 
164   // Send the jackpot if no activity in 24 hours and claimant was the last person to generate activity.
165   function claim() public payable isStarted {
166     require(now > lastAction + 6 hours);
167 	require(jackpotLastQualified == msg.sender);
168 
169     uint256 seedPay = seedAmount;
170     uint256 jpotPay = jackpotBalance - seedAmount;
171 
172     seedAmount = 0;
173     contractOwner.transfer(seedPay); // Return the initial seed to owner.
174 
175     jackpotBalance = 0;
176 	msg.sender.transfer(jpotPay); // payout entire jackpot minus seed.
177   }
178 
179   // Fallback, sending any ether will call purchase() while sending 0 will call claim()
180   function () public payable {
181     if(msg.value > 0) {
182       purchase();
183     } else {
184       claim();
185     }
186   }
187 }
188 
189 
190 
191 /**
192  * @title SafeMath
193  * @dev Math operations with safety checks that throw on error
194  */
195 library SafeMath {
196 
197   /**
198   * @dev Multiplies two numbers, throws on overflow.
199   */
200   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201     if (a == 0) {
202       return 0;
203     }
204     uint256 c = a * b;
205     assert(c / a == b);
206     return c;
207   }
208 
209   /**
210   * @dev Integer division of two numbers, truncating the quotient.
211   */
212   function div(uint256 a, uint256 b) internal pure returns (uint256) {
213     // assert(b > 0); // Solidity automatically throws when dividing by 0
214     uint256 c = a / b;
215     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216     return c;
217   }
218 
219   /**
220   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
221   */
222   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223     assert(b <= a);
224     return a - b;
225   }
226 
227   /**
228   * @dev Adds two numbers, throws on overflow.
229   */
230   function add(uint256 a, uint256 b) internal pure returns (uint256) {
231     uint256 c = a + b;
232     assert(c >= a);
233     return c;
234   }
235 }