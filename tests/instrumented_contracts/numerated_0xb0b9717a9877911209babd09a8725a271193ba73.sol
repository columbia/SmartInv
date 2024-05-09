1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address private _owner;
5 
6   event OwnershipTransferred(
7     address indexed previousOwner,
8     address indexed newOwner
9   );
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   constructor() internal {
16     _owner = msg.sender;
17     emit OwnershipTransferred(address(0), _owner);
18   }
19 
20   /**
21    * @return the address of the owner.
22    */
23   function owner() public view returns(address) {
24     return _owner;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(isOwner());
32     _;
33   }
34 
35   /**
36    * @return true if `msg.sender` is the owner of the contract.
37    */
38   function isOwner() public view returns(bool) {
39     return msg.sender == _owner;
40   }
41 
42   /**
43    * @dev Allows the current owner to relinquish control of the contract.
44    * @notice Renouncing to ownership will leave the contract without an owner.
45    * It will not be possible to call the functions with the `onlyOwner`
46    * modifier anymore.
47    */
48   function renounceOwnership() public onlyOwner {
49     emit OwnershipTransferred(_owner, address(0));
50     _owner = address(0);
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     _transferOwnership(newOwner);
59   }
60 
61   /**
62    * @dev Transfers control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function _transferOwnership(address newOwner) internal {
66     require(newOwner != address(0));
67     emit OwnershipTransferred(_owner, newOwner);
68     _owner = newOwner;
69   }
70 }
71 
72 library SafeMath {
73 
74   /**
75   * @dev Multiplies two numbers, reverts on overflow.
76   */
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79     // benefit is lost if 'b' is also tested.
80     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81     if (a == 0) {
82       return 0;
83     }
84 
85     uint256 c = a * b;
86     require(c / a == b);
87 
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
93   */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b > 0); // Solidity only automatically asserts when dividing by 0
96     uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98 
99     return c;
100   }
101 
102   /**
103   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
104   */
105   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106     require(b <= a);
107     uint256 c = a - b;
108 
109     return c;
110   }
111 
112   /**
113   * @dev Adds two numbers, reverts on overflow.
114   */
115   function add(uint256 a, uint256 b) internal pure returns (uint256) {
116     uint256 c = a + b;
117     require(c >= a);
118 
119     return c;
120   }
121 
122   /**
123   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
124   * reverts when dividing by zero.
125   */
126   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127     require(b != 0);
128     return a % b;
129   }
130 }
131 
132 contract ReentrancyGuard {
133 
134   /// @dev counter to allow mutex lock with only one SSTORE operation
135   uint256 private _guardCounter;
136 
137   constructor() internal {
138     // The counter starts at one to prevent changing it from zero to a non-zero
139     // value, which is a more expensive operation.
140     _guardCounter = 1;
141   }
142 
143   /**
144    * @dev Prevents a contract from calling itself, directly or indirectly.
145    * Calling a `nonReentrant` function from another `nonReentrant`
146    * function is not supported. It is possible to prevent this from happening
147    * by making the `nonReentrant` function external, and make it call a
148    * `private` function that does the actual work.
149    */
150   modifier nonReentrant() {
151     _guardCounter += 1;
152     uint256 localCounter = _guardCounter;
153     _;
154     require(localCounter == _guardCounter);
155   }
156 
157 }
158 
159 contract Presale is Ownable, ReentrancyGuard {
160   using SafeMath for uint256;
161 
162   struct ReferralData {
163     uint256 referrals; // number of referrals
164     uint256 bonusSum;  // sum of all bonuses - this is just for showing the total amount - for payouts the referralBonuses mapping will be used
165     address[] children; // child referrals
166   }
167 
168   uint256 public currentPrice = 0;
169 
170   bool public isActive = false;
171 
172   uint256 public currentDiscountSum = 0;                       // current sum of all discounts (have to stay in the contract for payout)
173   uint256 public overallDiscountSum = 0;                       // sum of all discounts given since beginning
174 
175   bool public referralsEnabled = true;                      // are referrals enabled in general
176 
177   mapping(address => uint) private referralBonuses;
178 
179   uint256 public referralBonusMaxDepth = 3;                                  // used to ensure the max depth
180   mapping(uint256 => uint) public currentReferralCommissionPercentages;      // commission levels
181   uint256 public currentReferralBuyerDiscountPercentage = 5;                 // discount percentage if a buyer uses a valid affiliate link
182 
183   mapping(address => address) private parentReferrals;    // parent relationship
184   mapping(address => ReferralData) private referralData;  // referral data for this address
185   mapping(address => uint) private nodesBought;           // number of bought nodes
186 
187   event MasternodeSold(address buyer, uint256 price, string coinsTargetAddress, bool referral);
188   event MasternodePriceChanged(uint256 price);
189   event ReferralAdded(address buyer, address parent);
190 
191   constructor() public {
192     currentReferralCommissionPercentages[0] = 10;
193     currentReferralCommissionPercentages[1] = 5;
194     currentReferralCommissionPercentages[2] = 3;
195   }
196 
197   function () external payable {
198       // nothing to do
199   }
200 
201   function buyMasternode(string memory coinsTargetAddress) public nonReentrant payable {
202     _buyMasternode(coinsTargetAddress, false, owner());
203   }
204 
205   function buyMasternodeReferral(string memory coinsTargetAddress, address referral) public nonReentrant payable {
206     _buyMasternode(coinsTargetAddress, referralsEnabled, referral);
207   }
208 
209   function _buyMasternode(string memory coinsTargetAddress, bool useReferral, address referral) internal {
210     require(isActive, "Buying is currently deactivated.");
211     require(currentPrice > 0, "There was no MN price set so far.");
212 
213     uint256 nodePrice = currentPrice;
214 
215     // nodes can be bought cheaper if the user uses a valid referral address
216     if (useReferral && isValidReferralAddress(referral)) {
217       nodePrice = getDiscountedNodePrice();
218     }
219 
220     require(msg.value >= nodePrice, "Sent amount of ETH was too low.");
221 
222     // check target address
223     uint256 length = bytes(coinsTargetAddress).length;
224     require(length >= 30 && length <= 42 , "Coins target address invalid");
225 
226     if (useReferral && isValidReferralAddress(referral)) {
227 
228       require(msg.sender != referral, "You can't be your own referral.");
229 
230       // set parent/child relations (only if there is no connection/parent yet available)
231       // --> this also means that a referral structure can't be changed
232       address parent = parentReferrals[msg.sender];
233       if (referralData[parent].referrals == 0) {
234         referralData[referral].referrals = referralData[referral].referrals.add(1);
235         referralData[referral].children.push(msg.sender);
236         parentReferrals[msg.sender] = referral;
237       }
238 
239       // iterate over commissionLevels and calculate commissions
240       uint256 discountSumForThisPayment = 0;
241       address currentReferral = referral;
242 
243       for (uint256 level=0; level < referralBonusMaxDepth; level++) {
244         // only apply discount if referral address is valid (or as long we can step up the hierarchy)
245         if(isValidReferralAddress(currentReferral)) {
246 
247           require(msg.sender != currentReferral, "Invalid referral structure (you can't be in your own tree)");
248 
249           // do not take node price here since it could be already dicounted
250           uint256 referralBonus = currentPrice.div(100).mul(currentReferralCommissionPercentages[level]);
251 
252           // set payout bonus
253           referralBonuses[currentReferral] = referralBonuses[currentReferral].add(referralBonus);
254 
255           // set stats/counters
256           referralData[currentReferral].bonusSum = referralData[currentReferral].bonusSum.add(referralBonus);
257           discountSumForThisPayment = discountSumForThisPayment.add(referralBonus);
258 
259           // step up one hierarchy level
260           currentReferral = parentReferrals[currentReferral];
261         } else {
262           // we can't find any parent - stop hierarchy calculation
263           break;
264         }
265       }
266 
267       require(discountSumForThisPayment < nodePrice, "Wrong calculation of bonuses/discounts - would be higher than the price itself");
268 
269       currentDiscountSum = currentDiscountSum.add(discountSumForThisPayment);
270       overallDiscountSum = overallDiscountSum.add(discountSumForThisPayment);
271     }
272 
273     // set the node bought counter
274     nodesBought[msg.sender] = nodesBought[msg.sender].add(1);
275 
276     emit MasternodeSold(msg.sender, currentPrice, coinsTargetAddress, useReferral);
277   }
278 
279   function setActiveState(bool active) public onlyOwner {
280     isActive = active;
281   }
282 
283   function setPrice(uint256 price) public onlyOwner {
284     require(price > 0, "Price has to be greater than zero.");
285 
286     currentPrice = price;
287 
288     emit MasternodePriceChanged(price);
289   }
290 
291   function setReferralsEnabledState(bool _referralsEnabled) public onlyOwner {
292     referralsEnabled = _referralsEnabled;
293   }
294 
295   function setReferralCommissionPercentageLevel(uint256 level, uint256 percentage) public onlyOwner {
296     require(percentage >= 0 && percentage <= 20, "Percentage has to be between 0 and 20.");
297     require(level >= 0 && level < referralBonusMaxDepth, "Invalid depth level");
298 
299     currentReferralCommissionPercentages[level] = percentage;
300   }
301 
302   function setReferralBonusMaxDepth(uint256 depth) public onlyOwner {
303     require(depth >= 0 && depth <= 10, "Referral bonus depth too high.");
304 
305     referralBonusMaxDepth = depth;
306   }
307 
308   function setReferralBuyerDiscountPercentage(uint256 percentage) public onlyOwner {
309     require(percentage >= 0 && percentage <= 20, "Percentage has to be between 0 and 20.");
310 
311     currentReferralBuyerDiscountPercentage = percentage;
312   }
313 
314   function withdraw(uint256 amount) public onlyOwner {
315     owner().transfer(amount);
316   }
317 
318   function withdrawReferralBonus() public nonReentrant returns (bool) {
319     uint256 amount = referralBonuses[msg.sender];
320 
321     if (amount > 0) {
322         referralBonuses[msg.sender] = 0;
323         currentDiscountSum = currentDiscountSum.sub(amount);
324 
325         if (!msg.sender.send(amount)) {
326             referralBonuses[msg.sender] = amount;
327             currentDiscountSum = currentDiscountSum.add(amount);
328 
329             return false;
330         }
331     }
332 
333     return true;
334   }
335 
336   function checkReferralBonusHeight(address addr) public view returns (uint) {
337       return referralBonuses[addr];
338   }
339 
340   function getNrOfReferrals(address addr) public view returns (uint) {
341       return referralData[addr].referrals;
342   }
343 
344   function getReferralBonusSum(address addr) public view returns (uint) {
345       return referralData[addr].bonusSum;
346   }
347 
348   function getReferralChildren(address addr) public view returns (address[] memory) {
349       return referralData[addr].children;
350   }
351 
352   function getReferralChild(address addr, uint256 idx) public view returns (address) {
353       return referralData[addr].children[idx];
354   }
355 
356   function isValidReferralAddress(address addr) public view returns (bool) {
357       return nodesBought[addr] > 0;
358   }
359 
360   function getNodesBoughtCountForAddress(address addr) public view returns (uint256) {
361       return nodesBought[addr];
362   }
363 
364   function getDiscountedNodePrice() public view returns (uint256) {
365       return currentPrice.sub(currentPrice.div(100).mul(currentReferralBuyerDiscountPercentage));
366   }
367 }