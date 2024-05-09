1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  D:\Repositories\GitHub\Cronos\src\CRS.Presale.Contract\contracts\Presale.sol
6 // flattened :  Friday, 28-Dec-18 10:47:36 UTC
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 contract ReentrancyGuard {
68 
69   /// @dev counter to allow mutex lock with only one SSTORE operation
70   uint256 private _guardCounter;
71 
72   constructor() internal {
73     // The counter starts at one to prevent changing it from zero to a non-zero
74     // value, which is a more expensive operation.
75     _guardCounter = 1;
76   }
77 
78   /**
79    * @dev Prevents a contract from calling itself, directly or indirectly.
80    * Calling a `nonReentrant` function from another `nonReentrant`
81    * function is not supported. It is possible to prevent this from happening
82    * by making the `nonReentrant` function external, and make it call a
83    * `private` function that does the actual work.
84    */
85   modifier nonReentrant() {
86     _guardCounter += 1;
87     uint256 localCounter = _guardCounter;
88     _;
89     require(localCounter == _guardCounter);
90   }
91 
92 }
93 
94 contract Ownable {
95   address private _owner;
96 
97   event OwnershipTransferred(
98     address indexed previousOwner,
99     address indexed newOwner
100   );
101 
102   /**
103    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
104    * account.
105    */
106   constructor() internal {
107     _owner = msg.sender;
108     emit OwnershipTransferred(address(0), _owner);
109   }
110 
111   /**
112    * @return the address of the owner.
113    */
114   function owner() public view returns(address) {
115     return _owner;
116   }
117 
118   /**
119    * @dev Throws if called by any account other than the owner.
120    */
121   modifier onlyOwner() {
122     require(isOwner());
123     _;
124   }
125 
126   /**
127    * @return true if `msg.sender` is the owner of the contract.
128    */
129   function isOwner() public view returns(bool) {
130     return msg.sender == _owner;
131   }
132 
133   /**
134    * @dev Allows the current owner to relinquish control of the contract.
135    * @notice Renouncing to ownership will leave the contract without an owner.
136    * It will not be possible to call the functions with the `onlyOwner`
137    * modifier anymore.
138    */
139   function renounceOwnership() public onlyOwner {
140     emit OwnershipTransferred(_owner, address(0));
141     _owner = address(0);
142   }
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address newOwner) public onlyOwner {
149     _transferOwnership(newOwner);
150   }
151 
152   /**
153    * @dev Transfers control of the contract to a newOwner.
154    * @param newOwner The address to transfer ownership to.
155    */
156   function _transferOwnership(address newOwner) internal {
157     require(newOwner != address(0));
158     emit OwnershipTransferred(_owner, newOwner);
159     _owner = newOwner;
160   }
161 }
162 
163 contract Presale is Ownable, ReentrancyGuard {
164   using SafeMath for uint256;
165 
166   struct ReferralData {
167     uint256 referrals; // number of referrals
168     uint256 bonusSum;  // sum of all bonuses - this is just for showing the total amount - for payouts the referralBonuses mapping will be used
169     address[] children; // child referrals
170   }
171 
172   uint256 public currentPrice = 0;
173 
174   bool public isActive = false;
175 
176   uint256 public currentDiscountSum = 0;                       // current sum of all discounts (have to stay in the contract for payout)
177   uint256 public overallDiscountSum = 0;                       // sum of all discounts given since beginning
178 
179   bool public referralsEnabled = true;                      // are referrals enabled in general
180 
181   mapping(address => uint) private referralBonuses;
182 
183   uint256 public referralBonusMaxDepth = 3;                                  // used to ensure the max depth
184   mapping(uint256 => uint) public currentReferralCommissionPercentages;      // commission levels
185   uint256 public currentReferralBuyerDiscountPercentage = 5;                 // discount percentage if a buyer uses a valid affiliate link
186 
187   mapping(address => address) private parentReferrals;    // parent relationship
188   mapping(address => ReferralData) private referralData;  // referral data for this address
189   mapping(address => uint) private nodesBought;           // number of bought nodes
190 
191   mapping(address => bool) private manuallyAddedReferrals; // we need a chance to add referrals manually since this is needed for promotion
192 
193   event MasternodeSold(address buyer, uint256 price, string coinsTargetAddress, bool referral);
194   event MasternodePriceChanged(uint256 price);
195   event ReferralAdded(address buyer, address parent);
196 
197   constructor() public {
198     currentReferralCommissionPercentages[0] = 10;
199     currentReferralCommissionPercentages[1] = 5;
200     currentReferralCommissionPercentages[2] = 3;
201   }
202 
203   function () external payable {
204       // nothing to do
205   }
206 
207   function buyMasternode(string memory coinsTargetAddress) public nonReentrant payable {
208     _buyMasternode(coinsTargetAddress, false, owner());
209   }
210 
211   function buyMasternodeReferral(string memory coinsTargetAddress, address referral) public nonReentrant payable {
212     _buyMasternode(coinsTargetAddress, referralsEnabled, referral);
213   }
214 
215   function _buyMasternode(string memory coinsTargetAddress, bool useReferral, address referral) internal {
216     require(isActive, "Buying is currently deactivated.");
217     require(currentPrice > 0, "There was no MN price set so far.");
218 
219     uint256 nodePrice = currentPrice;
220 
221     // nodes can be bought cheaper if the user uses a valid referral address
222     if (useReferral && isValidReferralAddress(referral)) {
223       nodePrice = getDiscountedNodePrice();
224     }
225 
226     require(msg.value >= nodePrice, "Sent amount of ETH was too low.");
227 
228     // check target address
229     uint256 length = bytes(coinsTargetAddress).length;
230     require(length >= 30 && length <= 42 , "Coins target address invalid");
231 
232     if (useReferral && isValidReferralAddress(referral)) {
233 
234       require(msg.sender != referral, "You can't be your own referral.");
235 
236       // set parent/child relations (only if there is no connection/parent yet available)
237       // --> this also means that a referral structure can't be changed
238       address parent = parentReferrals[msg.sender];
239       if (referralData[parent].referrals == 0) {
240         referralData[referral].referrals = referralData[referral].referrals.add(1);
241         referralData[referral].children.push(msg.sender);
242         parentReferrals[msg.sender] = referral;
243       }
244 
245       // iterate over commissionLevels and calculate commissions
246       uint256 discountSumForThisPayment = 0;
247       address currentReferral = referral;
248 
249       for (uint256 level=0; level < referralBonusMaxDepth; level++) {
250         // only apply discount if referral address is valid (or as long we can step up the hierarchy)
251         if(isValidReferralAddress(currentReferral)) {
252 
253           require(msg.sender != currentReferral, "Invalid referral structure (you can't be in your own tree)");
254 
255           // do not take node price here since it could be already dicounted
256           uint256 referralBonus = currentPrice.div(100).mul(currentReferralCommissionPercentages[level]);
257 
258           // set payout bonus
259           referralBonuses[currentReferral] = referralBonuses[currentReferral].add(referralBonus);
260 
261           // set stats/counters
262           referralData[currentReferral].bonusSum = referralData[currentReferral].bonusSum.add(referralBonus);
263           discountSumForThisPayment = discountSumForThisPayment.add(referralBonus);
264 
265           // step up one hierarchy level
266           currentReferral = parentReferrals[currentReferral];
267         } else {
268           // we can't find any parent - stop hierarchy calculation
269           break;
270         }
271       }
272 
273       require(discountSumForThisPayment < nodePrice, "Wrong calculation of bonuses/discounts - would be higher than the price itself");
274 
275       currentDiscountSum = currentDiscountSum.add(discountSumForThisPayment);
276       overallDiscountSum = overallDiscountSum.add(discountSumForThisPayment);
277     }
278 
279     // set the node bought counter
280     nodesBought[msg.sender] = nodesBought[msg.sender].add(1);
281 
282     emit MasternodeSold(msg.sender, currentPrice, coinsTargetAddress, useReferral);
283   }
284 
285   function setActiveState(bool active) public onlyOwner {
286     isActive = active;
287   }
288 
289   function setPrice(uint256 price) public onlyOwner {
290     require(price > 0, "Price has to be greater than zero.");
291 
292     currentPrice = price;
293 
294     emit MasternodePriceChanged(price);
295   }
296 
297   function setReferralsEnabledState(bool _referralsEnabled) public onlyOwner {
298     referralsEnabled = _referralsEnabled;
299   }
300 
301   function setReferralCommissionPercentageLevel(uint256 level, uint256 percentage) public onlyOwner {
302     require(percentage >= 0 && percentage <= 20, "Percentage has to be between 0 and 20.");
303     require(level >= 0 && level < referralBonusMaxDepth, "Invalid depth level");
304 
305     currentReferralCommissionPercentages[level] = percentage;
306   }
307 
308   function setReferralBonusMaxDepth(uint256 depth) public onlyOwner {
309     require(depth >= 0 && depth <= 10, "Referral bonus depth too high.");
310 
311     referralBonusMaxDepth = depth;
312   }
313 
314   function setReferralBuyerDiscountPercentage(uint256 percentage) public onlyOwner {
315     require(percentage >= 0 && percentage <= 20, "Percentage has to be between 0 and 20.");
316 
317     currentReferralBuyerDiscountPercentage = percentage;
318   }
319 
320   function addReferralAddress(address addr) public onlyOwner {
321     manuallyAddedReferrals[addr] = true;
322   }
323 
324   function removeReferralAddress(address addr) public onlyOwner {
325     manuallyAddedReferrals[addr] = false;
326   }
327 
328   function withdraw(uint256 amount) public onlyOwner {
329     owner().transfer(amount);
330   }
331 
332   function withdrawReferralBonus() public nonReentrant returns (bool) {
333     uint256 amount = referralBonuses[msg.sender];
334 
335     if (amount > 0) {
336         referralBonuses[msg.sender] = 0;
337         currentDiscountSum = currentDiscountSum.sub(amount);
338 
339         if (!msg.sender.send(amount)) {
340             referralBonuses[msg.sender] = amount;
341             currentDiscountSum = currentDiscountSum.add(amount);
342 
343             return false;
344         }
345     }
346 
347     return true;
348   }
349 
350   function checkReferralBonusHeight(address addr) public view returns (uint) {
351       return referralBonuses[addr];
352   }
353 
354   function getNrOfReferrals(address addr) public view returns (uint) {
355       return referralData[addr].referrals;
356   }
357 
358   function getReferralBonusSum(address addr) public view returns (uint) {
359       return referralData[addr].bonusSum;
360   }
361 
362   function getReferralChildren(address addr) public view returns (address[] memory) {
363       return referralData[addr].children;
364   }
365 
366   function getReferralChild(address addr, uint256 idx) public view returns (address) {
367       return referralData[addr].children[idx];
368   }
369 
370   function isValidReferralAddress(address addr) public view returns (bool) {
371       return nodesBought[addr] > 0 || manuallyAddedReferrals[addr] == true;
372   }
373 
374   function getNodesBoughtCountForAddress(address addr) public view returns (uint256) {
375       return nodesBought[addr];
376   }
377 
378   function getDiscountedNodePrice() public view returns (uint256) {
379       return currentPrice.sub(currentPrice.div(100).mul(currentReferralBuyerDiscountPercentage));
380   }
381 }