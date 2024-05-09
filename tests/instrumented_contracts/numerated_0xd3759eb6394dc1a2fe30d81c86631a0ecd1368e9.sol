1 pragma solidity ^0.4.13;
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
86   // The token being sold
87   ELTCoinToken public token;
88 
89   // end timestamp where investments are allowed (both inclusive)
90   uint256 public endTime;
91 
92   // address where funds are collected
93   address public wallet;
94 
95   // how many wei for a token unit
96   uint256 public rate;
97 
98   // the minimum transaction threshold in wei
99   uint256 public minThreshold;
100 
101   // amount of raised money in wei
102   uint256 public weiRaised;
103 
104   /**
105    * event for token purchase logging
106    * @param purchaser who paid for the tokens
107    * @param beneficiary who got the tokens
108    * @param value weis paid for purchase
109    * @param amount amount of tokens purchased
110    */
111   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
112 
113   function Crowdsale(
114     address _contractAddress, uint256 _endTime, uint256 _rate, uint256 _minThreshold, address _wallet) {
115     require(_endTime >= now);
116     require(_wallet != 0x0);
117 
118     token = ELTCoinToken(_contractAddress);
119     endTime = _endTime;
120     rate = _rate;
121     wallet = _wallet;
122     minThreshold = _minThreshold;
123   }
124 
125   // fallback function can be used to buy tokens
126   function () payable {
127     buyTokens(msg.sender);
128   }
129 
130   // low level token purchase function
131   function buyTokens(address beneficiary) public payable {
132     require(beneficiary != 0x0);
133     require(validPurchase());
134 
135     uint256 weiAmount = msg.value;
136 
137     require(weiAmount >= minThreshold);
138 
139     uint256 weiAmountBack = weiAmount % rate;
140 
141     weiAmount -= weiAmountBack;
142 
143     // calculate token amount to be created
144     uint256 tokens = weiAmount.div(rate);
145 
146     // update state
147     weiRaised = weiRaised.add(weiAmount);
148 
149     require(token.transfer(beneficiary, tokens));
150 
151     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
152 
153     forwardFunds(weiAmount);
154   }
155 
156   // send ether to the fund collection wallet
157   // override to create custom fund forwarding mechanisms
158   function forwardFunds(uint256 amount) internal {
159     wallet.transfer(amount);
160   }
161 
162   // @return true if the transaction can buy tokens
163   function validPurchase() internal returns (bool) {
164     bool withinPeriod = now <= endTime;
165     bool nonZeroPurchase = msg.value != 0;
166     return withinPeriod && nonZeroPurchase;
167   }
168 
169   // @return true if crowdsale event has ended
170   function hasEnded() public constant returns (bool) {
171     return now > endTime;
172   }
173 }
174 
175 /**
176  * @title IndividualCappedCrowdsale
177  * @dev Extension of Crowdsale with an individual cap
178  */
179 contract IndividualCappedCrowdsale is Crowdsale {
180   using SafeMath for uint256;
181 
182   uint public constant GAS_LIMIT_IN_WEI = 50000000000 wei;
183 
184   // The maximum wei amount a user can spend during this sale
185   uint256 public capPerAddress;
186 
187   mapping(address=>uint) public participated;
188 
189   function IndividualCappedCrowdsale(uint256 _capPerAddress) {
190     // require(capPerAddress > 0);
191     capPerAddress = _capPerAddress;
192   }
193 
194   /**
195     * @dev overriding CappedCrowdsale#validPurchase to add an individual cap
196     * @return true if investors can buy at the moment
197     */
198   function validPurchase() internal returns (bool) {
199     require(tx.gasprice <= GAS_LIMIT_IN_WEI);
200     participated[msg.sender] = participated[msg.sender].add(msg.value);
201     return super.validPurchase() && participated[msg.sender] <= capPerAddress;
202   }
203 }
204 
205 /**
206  * @title CappedCrowdsale
207  * @dev Extension of Crowdsale with a max amount of funds raised
208  */
209 contract CappedCrowdsale is Crowdsale {
210   using SafeMath for uint256;
211 
212   uint256 public cap;
213 
214   function CappedCrowdsale(uint256 _cap) {
215     require(_cap > 0);
216     cap = _cap;
217   }
218 
219   // overriding Crowdsale#validPurchase to add extra cap logic
220   // @return true if investors can buy at the moment
221   function validPurchase() internal returns (bool) {
222     bool withinCap = weiRaised.add(msg.value) <= cap;
223     return super.validPurchase() && withinCap;
224   }
225 }
226 
227 /**
228  * @title WhitelistedCrowdsale
229  * @dev This is an extension to add whitelist to a crowdsale
230  */
231 contract WhitelistedCrowdsale is Crowdsale, Ownable {
232 
233     mapping(address=>bool) public registered;
234 
235     event RegistrationStatusChanged(address indexed target, bool isRegistered);
236 
237     /**
238      * @dev Changes registration status of an address for participation.
239      * @param target Address that will be registered/deregistered.
240      * @param isRegistered New registration status of address.
241      */
242     function changeRegistrationStatus(address target, bool isRegistered)
243         public
244         onlyOwner
245     {
246         registered[target] = isRegistered;
247         RegistrationStatusChanged(target, isRegistered);
248     }
249 
250     /**
251      * @dev Changes registration statuses of addresses for participation.
252      * @param targets Addresses that will be registered/deregistered.
253      * @param isRegistered New registration status of addresses.
254      */
255     function changeRegistrationStatuses(address[] targets, bool isRegistered)
256         public
257         onlyOwner
258     {
259         for (uint i = 0; i < targets.length; i++) {
260             changeRegistrationStatus(targets[i], isRegistered);
261         }
262     }
263 
264     /**
265      * @dev overriding Crowdsale#validPurchase to add whilelist
266      * @return true if investors can buy at the moment, false otherwise
267      */
268     function validPurchase() internal returns (bool) {
269         return super.validPurchase() && registered[msg.sender];
270     }
271 }
272 
273 contract ELTCoinCrowdsale is Ownable, CappedCrowdsale, WhitelistedCrowdsale, IndividualCappedCrowdsale {
274   function ELTCoinCrowdsale(address _coinAddress, uint256 _endTime, uint256 _rate, uint256 _cap, uint256 _minThreshold, uint256 _capPerAddress, address _wallet)
275     IndividualCappedCrowdsale(_capPerAddress)
276     WhitelistedCrowdsale()
277     CappedCrowdsale(_cap)
278     Crowdsale(_coinAddress, _endTime, _rate, _minThreshold, _wallet)
279   {
280 
281   }
282 
283   /**
284   * @dev Transfer the unsold tokens to the owner main wallet
285   * @dev Only for owner
286   */
287   function drainRemainingToken ()
288     public
289     onlyOwner
290   {
291       require(hasEnded());
292       token.transfer(owner, token.balanceOf(this));
293   }
294 }