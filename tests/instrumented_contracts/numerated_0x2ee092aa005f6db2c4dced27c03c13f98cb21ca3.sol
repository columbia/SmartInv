1 pragma solidity ^0.8.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 // File: contracts/sale_v2.sol
91 
92 // SPDX-License-Identifier: Unlicensed
93 
94 pragma solidity ^0.8.4;
95 
96 //@R
97 
98 //+---------------------------------------------------------------------------------------+
99 // Imports
100 //+---------------------------------------------------------------------------------------+
101 
102 
103 
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `recipient`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transfer(address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through {transferFrom}. This is
127      * zero by default.
128      *
129      * This value changes when {approve} or {transferFrom} are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     /**
134      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * IMPORTANT: Beware that changing an allowance with this method brings the risk
139      * that someone may use both the old and the new allowance by unfortunate
140      * transaction ordering. One possible solution to mitigate this race
141      * condition is to first reduce the spender's allowance to 0 and set the
142      * desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address spender, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Moves `amount` tokens from `sender` to `recipient` using the
151      * allowance mechanism. `amount` is then deducted from the caller's
152      * allowance.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Emitted when `value` tokens are moved from one account (`from`) to
162      * another (`to`).
163      *
164      * Note that `value` may be zero.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to {approve}. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 library SafeMath {
176     /**
177      * @dev Returns the addition of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `+` operator.
181      *
182      * Requirements:
183      *
184      * - Addition cannot overflow.
185      */
186     function add(uint256 a, uint256 b) internal pure returns (uint256) {
187         uint256 c = a + b;
188         require(c >= a, "SafeMath: addition overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the subtraction of two unsigned integers, reverting on
195      * overflow (when the result is negative).
196      *
197      * Counterpart to Solidity's `-` operator.
198      *
199      * Requirements:
200      *
201      * - Subtraction cannot overflow.
202      */
203     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
204         return sub(a, b, "SafeMath: subtraction overflow");
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      *
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b <= a, errorMessage);
219         uint256 c = a - b;
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the multiplication of two unsigned integers, reverting on
226      * overflow.
227      *
228      * Counterpart to Solidity's `*` operator.
229      *
230      * Requirements:
231      *
232      * - Multiplication cannot overflow.
233      */
234     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
235         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
236         // benefit is lost if 'b' is also tested.
237         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
238         if (a == 0) {
239             return 0;
240         }
241 
242         uint256 c = a * b;
243         require(c / a == b, "SafeMath: multiplication overflow");
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the integer division of two unsigned integers. Reverts on
250      * division by zero. The result is rounded towards zero.
251      *
252      * Counterpart to Solidity's `/` operator. Note: this function uses a
253      * `revert` opcode (which leaves remaining gas untouched) while Solidity
254      * uses an invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function div(uint256 a, uint256 b) internal pure returns (uint256) {
261         return div(a, b, "SafeMath: division by zero");
262     }
263 
264     /**
265      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
266      * division by zero. The result is rounded towards zero.
267      *
268      * Counterpart to Solidity's `/` operator. Note: this function uses a
269      * `revert` opcode (which leaves remaining gas untouched) while Solidity
270      * uses an invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b > 0, errorMessage);
278         uint256 c = a / b;
279         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
280 
281         return c;
282     }
283 
284     /**
285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
286      * Reverts when dividing by zero.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
297         return mod(a, b, "SafeMath: modulo by zero");
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * Reverts with custom message when dividing by zero.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
313         require(b != 0, errorMessage);
314         return a % b;
315     }
316 }
317 
318 //+---------------------------------------------------------------------------------------+
319 // Contracts
320 //+---------------------------------------------------------------------------------------+
321 
322 /** This contract is designed for coordinating the sale of wLiti tokens to purchasers
323   *     and includes a referral system where referrers earn bonus tokens on each wLiti
324   *     sale.
325   **/
326 contract wLitiSale is Context, Ownable {
327 
328     using SafeMath for uint256;
329 
330     //+---------------------------------------------------------------------------------------+
331     // Structures
332     //+---------------------------------------------------------------------------------------+
333 
334     //Type for tracking referral memebers and their bonus percentages
335     struct Referrer {
336 
337         bool isReferrer;  //If true, referer is allowed to receive referral bonuses
338         uint256 bonusPercent; //Percentage bonus amount
339 
340     }
341 
342     //+---------------------------------------------------------------------------------------+
343     // Contract Data Members
344     //+---------------------------------------------------------------------------------------+
345 
346     //Referral info
347     address private _masterReferrerWallet; //Wallet of the master referrer (this person ALWAYS recieves a bonus)
348     uint256 private _maxBonusPercent; //Max bonus that can be given to referrers
349     mapping(address => Referrer) _referrers; //Track referrer info
350 
351     //Sale info
352     IERC20 private _token; //Token to be sold
353     address private _ETHWallet; //Wallet ETH is sent to
354     uint256 private _saleCount; //Counts the number of sales
355     uint256 private _tokenPrice; //ETH price per token
356     uint256 private _saleSupplyLeft; //Supply left in sale
357     uint256 private _saleSupplyTotal; //Total supply of sale
358     uint256 private _saleStartTime; //Sale start epoch timestamp
359     uint256 private _saleEndTime; //Sale end epoch timestamp
360     mapping(uint256 => uint256) _weiRaised; //Track wei raised from each sale
361 
362     //+---------------------------------------------------------------------------------------+
363     // Constructors
364     //+---------------------------------------------------------------------------------------+
365 
366     /** Constructor to build the contract
367       *
368       * @param token - the contract address of the token that is being sold
369       * @param ETHWallet - the wallet that ETH will be sent to after every purchase
370       * @param masterReferrerWallet - the wallet of the master referrer
371       *
372       **/
373     constructor(address token, address ETHWallet, address masterReferrerWallet) {
374 
375         _token = IERC20(token);
376         _ETHWallet = ETHWallet;
377         _masterReferrerWallet = masterReferrerWallet;
378 
379     }
380 
381     //+---------------------------------------------------------------------------------------+
382     // Getters
383     //+---------------------------------------------------------------------------------------+
384 
385     function getMasterReferrerWallet() public view returns (address) { return _masterReferrerWallet; }
386 
387     function getReferrerBonusPercent(address referrer) public view returns (uint256) { return _referrers[referrer].bonusPercent; }
388 
389     function getMaxBonusPercent() public view returns (uint256) { return _maxBonusPercent; }
390 
391     function getTokenPrice() public view returns (uint256) { return _tokenPrice; }
392 
393     function getSaleSupplyLeft() public view returns (uint256) { return _saleSupplyLeft; }
394 
395     function getSaleSupplyTotal() public view returns (uint256) { return _saleSupplyTotal; }
396 
397     function getSaleStartTime() public view returns (uint256) { return _saleStartTime; }
398 
399     function getSaleEndTime() public view returns (uint256) { return _saleEndTime; }
400 
401     function getSaleCount() public view returns (uint256) { return _saleCount; }
402 
403     function getWeiRaised(uint256 sale) public view returns (uint256) { return _weiRaised[sale]; }
404 
405     function getETHWallet() public view returns (address) { return _ETHWallet; }
406 
407     function isSaleActive() public view returns (bool) {
408 
409         return (block.timestamp > _saleStartTime &&
410                 block.timestamp < _saleEndTime);
411 
412     }
413 
414     function isReferrer(address referrer) public view returns (bool) { return _referrers[referrer].isReferrer; }
415 
416     //+---------------------------------------------------------------------------------------+
417     // Private Functions
418     //+---------------------------------------------------------------------------------------+
419 
420     function transferReferralTokens(address referrer, uint256 bonusPercent, uint purchaseAmountBig) private {
421 
422         uint256 referralAmountBig = purchaseAmountBig.mul(bonusPercent).div(10**2);
423         _token.transfer(referrer, (referralAmountBig));
424 
425     }
426 
427     //+---------------------------------------------------------------------------------------+
428     // Public/User Functions
429     //+---------------------------------------------------------------------------------------+
430 
431     /** Purchase tokens from contract and distribute token bonuses to referrers. Master referrer will ALWAYS recieve at least
432       *     a 1% token bonus. A second referrer address is required to be provided when purchasing and they will recieve at least 1%.
433       *     A third referrer is optional, but not required. If the optional referrer is an autherized Referrer by the contract owner, then
434       *     the optional referrer will receive a minimum of a 1% token bonus.
435       *
436       *  @param purchaseAmount - the amount of tokens that the purchaser wants to buy
437       *  @param referrer - second referrer that is required
438       *  @param optionalReferrer - third referrer that is optional
439       **/
440     function purchaseTokens(uint256 purchaseAmount, address referrer, address optionalReferrer) public payable {
441 
442         require(_msgSender() != address(0), "AddressZero cannot purchase tokens");
443         require(isSaleActive(), "Sale is not active");
444         require(getTokenPrice() != 0, "Token price is not set");
445         require(getMaxBonusPercent() != 0, "Referral bonus percent is not set");
446         require(isReferrer(referrer), "Referrer is not authorized");
447 
448         //Calculate big number amounts
449         uint256 purchaseAmountBig = purchaseAmount * 1 ether; //Amount of tokens user is purchasing
450         uint256 totalRAmountBig = purchaseAmountBig.mul(_maxBonusPercent).div(10**2); //Amount of tokens referrers will earn
451         uint256 totalAmountBig = purchaseAmountBig.add(totalRAmountBig); //Total amount of tokens being distributed
452         uint256 masterBonusPercent = _maxBonusPercent; //Bonus percent for the master referrer
453 
454         require(totalAmountBig <= _saleSupplyLeft, "Purchase amount is bigger than the remaining sale supply");
455 
456         uint256 totalPrice = purchaseAmount * _tokenPrice; //Total ETH price for tokens
457         require(msg.value >= totalPrice, "Payment amount too low");
458 
459         //If the optionalReferrer is an authorized referrer, then distribute referral bonus tokens
460         if(isReferrer(optionalReferrer)) {
461 
462             require(_referrers[referrer].bonusPercent + _referrers[optionalReferrer].bonusPercent < _maxBonusPercent,
463                 "Referrers bonus percent must be less than max bonus");
464 
465             //Subtract the master's bonus by the referrers' bonus AND transfer tokens to the optional referrer
466             masterBonusPercent = masterBonusPercent.sub(_referrers[referrer].bonusPercent).sub(_referrers[optionalReferrer].bonusPercent);
467             transferReferralTokens(optionalReferrer, _referrers[optionalReferrer].bonusPercent, purchaseAmountBig);
468 
469         }
470         //There is only one referrer, ignore the optional referrer
471         else {
472 
473             require(_referrers[referrer].bonusPercent < _maxBonusPercent, "Referrer bonus percent must be less than max bonus");
474 
475             //Subtract the master's bonus by the referrer's bonus
476             masterBonusPercent = masterBonusPercent.sub(_referrers[referrer].bonusPercent);
477 
478         }
479 
480         //Transfer tokens to referrer, master referrer, and purchaser
481         transferReferralTokens(referrer, _referrers[referrer].bonusPercent, purchaseAmountBig);
482         transferReferralTokens(_masterReferrerWallet, masterBonusPercent, purchaseAmountBig);
483         _token.transfer(msg.sender, (purchaseAmountBig));
484 
485         //Modify sale information
486         _weiRaised[_saleCount] = _weiRaised[_saleCount] + totalPrice;
487         _saleSupplyLeft = _saleSupplyLeft - (totalAmountBig);
488 
489         //Transfer ETH back to presale wallet
490         address payable walletPayable = payable(_ETHWallet);
491         walletPayable.transfer(totalPrice);
492 
493         //Transfer extra ETH back to buyer
494         address payable client = payable(msg.sender);
495         client.transfer(msg.value - totalPrice);
496 
497     }
498 
499     //+---------------------------------------------------------------------------------------+
500     // Setters (Owner Only)
501     //+---------------------------------------------------------------------------------------+
502 
503     //Set the max bonue that referrers can earn
504     function setMaxBonusPercent(uint256 percent) public onlyOwner { _maxBonusPercent = percent; }
505 
506     //Set the ETH price of the tokens
507     function setTokenPrice(uint256 price) public onlyOwner { _tokenPrice = price; }
508 
509     //Set the wallet to receive ETH
510     function setETHWallet(address ETHWallet) public onlyOwner { _ETHWallet = ETHWallet; }
511 
512     //Set the master referrer wallet
513     function setMasterReferrerWallet(address masterReferrerWallet) public onlyOwner { _masterReferrerWallet = masterReferrerWallet; }
514 
515     //Set referrer bonus percent
516     function setReferrerBonusPercent(address referrer, uint256 bonusPercent) public onlyOwner {
517 
518         _referrers[referrer].bonusPercent = bonusPercent;
519 
520     }
521 
522     //+---------------------------------------------------------------------------------------+
523     // Controls (Owner Only)
524     //+---------------------------------------------------------------------------------------+
525 
526     //Add a referrer
527     function addReferrer(address referrer, uint256 bonusPercent) public onlyOwner {
528 
529         require(!isReferrer(referrer), "Address is already a referrer");
530         require(bonusPercent < _maxBonusPercent, "Referrer bonus cannot be equal to or greater than max bonus");
531         require(bonusPercent > 0, "Bonus percent must be greater than 0");
532 
533         _referrers[referrer].isReferrer = true;
534         _referrers[referrer].bonusPercent = bonusPercent;
535 
536     }
537 
538     //Remove a referrer
539     function removeReferrer(address referrer) public onlyOwner {
540 
541         require(isReferrer(referrer), "Address already is not a referrer");
542 
543         delete _referrers[referrer];
544 
545     }
546 
547     //Withdraw a number of tokens from contract to the contract owner
548     function withdrawToken(uint256 amount) public onlyOwner {
549         _token.transfer(owner(), amount);
550     }
551 
552     //Withdraw ALL tokens from contract to the contract owner
553     function withdrawAllTokens() public onlyOwner {
554         _token.transfer(owner(), _token.balanceOf(address(this)));
555     }
556 
557     //Create a sale
558     function createSale(uint256 supply, uint256 timeStart, uint256 timeEnd) public onlyOwner {
559 
560         require(supply <= _token.balanceOf(address(this)), "Supply too high, not enough tokens in contract");
561         require(timeStart >= block.timestamp, "Sale start time cannot be in the past");
562         require(timeEnd > timeStart, "Sale start time cannot be before the end time");
563 
564         //Store sale info
565         _saleSupplyTotal = supply;
566         _saleSupplyLeft = supply;
567         _saleStartTime = timeStart;
568         _saleEndTime = timeEnd;
569         _saleCount += 1;
570 
571     }
572 
573 }