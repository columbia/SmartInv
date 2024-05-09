1 pragma solidity ^0.4.15;
2 
3 contract ELTCoinToken {
4   function transfer(address to, uint256 value) public returns (bool);
5   function balanceOf(address who) public constant returns (uint256);
6 }
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal constant returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 /**
76  * @title Crowdsale
77  * @dev Crowdsale is a base contract for managing a token crowdsale.
78  * Crowdsales have a end timestamp, where investors can make
79  * token purchases and the crowdsale will assign them tokens based
80  * on a token per ETH rate. Funds collected are forwarded to a wallet
81  * as they arrive.
82  */
83 contract Crowdsale {
84   using SafeMath for uint256;
85 
86   uint256 public constant RATE_CHANGE_THRESHOLD = 30000000000000;
87 
88   // The token being sold
89   ELTCoinToken public token;
90 
91   // end timestamp where investments are allowed (both inclusive)
92   uint256 public endTime;
93 
94   // address where funds are collected
95   address public wallet;
96 
97   // how many wei for a token unit
98   uint256 public startRate;
99 
100   // current rate
101   uint256 public currentRate;
102 
103   // maximum rate
104   uint256 public maxRate;
105 
106   // the minimum transaction threshold in wei
107   uint256 public minThreshold;
108 
109   // amount of raised money in wei
110   uint256 public weiRaised;
111 
112   // amount of tokens sold
113   uint256 public tokensSold;
114 
115   /**
116    * event for token purchase logging
117    * @param purchaser who paid for the tokens
118    * @param beneficiary who got the tokens
119    * @param value weis paid for purchase
120    * @param amount amount of tokens purchased
121    */
122   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
123 
124   event WeiTransfer(address indexed receiver, uint256 amount);
125 
126   function Crowdsale(
127     address _contractAddress, uint256 _endTime, uint256 _startRate, uint256 _minThreshold, address _wallet) {
128     // require(_endTime >= now);
129     require(_wallet != 0x0);
130 
131     token = ELTCoinToken(_contractAddress);
132     endTime = _endTime;
133     startRate = _startRate;
134     currentRate = _startRate;
135     maxRate = startRate.mul(10);
136     wallet = _wallet;
137     minThreshold = _minThreshold;
138   }
139 
140   // fallback function can be used to buy tokens
141   function () payable {
142     buyTokens(msg.sender);
143   }
144 
145   // low level token purchase function
146   function buyTokens(address beneficiary) public payable {
147     require(beneficiary != 0x0);
148     require(validPurchase());
149 
150     uint256 weiAmount = msg.value;
151 
152     require(weiAmount >= minThreshold);
153 
154     uint256 weiToAllocate = weiAmount;
155 
156     uint256 tokensTotal = 0;
157 
158     while (weiToAllocate > 0) {
159       currentRate = tokensSold.div(RATE_CHANGE_THRESHOLD).mul(startRate).add(startRate);
160 
161       if (currentRate > maxRate) {
162         currentRate = maxRate;
163       }
164 
165       // Round to an integer number of tokens
166       weiToAllocate = weiToAllocate.sub(weiToAllocate % currentRate);
167 
168       uint256 remainingTokens = RATE_CHANGE_THRESHOLD.sub(tokensSold % RATE_CHANGE_THRESHOLD);
169 
170       uint256 tokens = weiToAllocate.div(currentRate) > remainingTokens ? remainingTokens : weiToAllocate.div(currentRate);
171 
172       tokensTotal = tokensTotal.add(tokens);
173       tokensSold = tokensSold.add(tokens);
174 
175       weiToAllocate = weiToAllocate.sub(tokens.mul(currentRate));
176     }
177 
178     weiRaised = weiRaised.add(weiAmount);
179 
180     require(token.transfer(beneficiary, tokensTotal));
181 
182     TokenPurchase(msg.sender, beneficiary, weiAmount, tokensTotal);
183 
184     forwardFunds(weiAmount);
185   }
186 
187   function forwardFunds(uint256 amount) internal {
188     wallet.transfer(amount);
189     WeiTransfer(wallet, amount);
190   }
191 
192   // @return true if the transaction can buy tokens
193   function validPurchase() internal returns (bool) {
194     bool withinPeriod = now <= endTime;
195     bool nonZeroPurchase = msg.value != 0;
196     return withinPeriod && nonZeroPurchase;
197   }
198 
199   // @return true if crowdsale event has ended
200   function hasEnded() public constant returns (bool) {
201     return now > endTime;
202   }
203 }
204 
205 /**
206  * @title IndividualCappedCrowdsale
207  * @dev Extension of Crowdsale with an individual cap
208  */
209 contract IndividualCappedCrowdsale is Crowdsale {
210   using SafeMath for uint256;
211 
212   uint public constant GAS_LIMIT_IN_WEI = 50000000000 wei;
213 
214   // The maximum wei amount a user can spend during this sale
215   uint256 public capPerAddress;
216 
217   mapping(address=>uint) public participated;
218 
219   function IndividualCappedCrowdsale(uint256 _capPerAddress) {
220     // require(capPerAddress > 0);
221     capPerAddress = _capPerAddress;
222   }
223 
224   /**
225     * @dev overriding CappedCrowdsale#validPurchase to add an individual cap
226     * @return true if investors can buy at the moment
227     */
228   function validPurchase() internal returns (bool) {
229     require(tx.gasprice <= GAS_LIMIT_IN_WEI);
230     participated[msg.sender] = participated[msg.sender].add(msg.value);
231     return super.validPurchase() && participated[msg.sender] <= capPerAddress;
232   }
233 }
234 
235 /**
236  * @title CappedCrowdsale
237  * @dev Extension of Crowdsale with a max amount of funds raised
238  */
239 contract CappedCrowdsale is Crowdsale {
240   using SafeMath for uint256;
241 
242   uint256 public cap;
243 
244   function CappedCrowdsale(uint256 _cap) {
245     require(_cap > 0);
246     cap = _cap;
247   }
248 
249   // overriding Crowdsale#validPurchase to add extra cap logic
250   // @return true if investors can buy at the moment
251   function validPurchase() internal returns (bool) {
252     bool withinCap = weiRaised.add(msg.value) <= cap;
253     return super.validPurchase() && withinCap;
254   }
255 }
256 
257 contract ELTCoinCrowdsale is Ownable, CappedCrowdsale, IndividualCappedCrowdsale {
258   function ELTCoinCrowdsale(address _coinAddress, uint256 _endTime, uint256 _rate, uint256 _cap, uint256 _minThreshold, uint256 _capPerAddress, address _wallet)
259     IndividualCappedCrowdsale(_capPerAddress)
260     CappedCrowdsale(_cap)
261     Crowdsale(_coinAddress, _endTime, _rate, _minThreshold, _wallet)
262   {
263 
264   }
265 
266   /**
267   * @dev Transfer the unsold tokens to the owner main wallet
268   * @dev Only for owner
269   */
270   function drainRemainingToken ()
271     public
272     onlyOwner
273   {
274       require(hasEnded());
275       token.transfer(owner, token.balanceOf(this));
276   }
277 
278   function setMaxRate(uint256 _maxRate) public onlyOwner {
279     maxRate = _maxRate;
280   }
281 }