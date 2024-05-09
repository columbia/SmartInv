1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      * - Subtraction cannot overflow.
135      *
136      * _Available since v2.4.0._
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      * - The divisor cannot be zero.
193      *
194      * _Available since v2.4.0._
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         // Solidity only automatically asserts when dividing by 0
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      * - The divisor cannot be zero.
230      *
231      * _Available since v2.4.0._
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/GSN/Context.sol
240 
241 pragma solidity ^0.5.0;
242 
243 /*
244  * @dev Provides information about the current execution context, including the
245  * sender of the transaction and its data. While these are generally available
246  * via msg.sender and msg.data, they should not be accessed in such a direct
247  * manner, since when dealing with GSN meta-transactions the account sending and
248  * paying for execution may not be the actual sender (as far as an application
249  * is concerned).
250  *
251  * This contract is only required for intermediate, library-like contracts.
252  */
253 contract Context {
254     // Empty internal constructor, to prevent people from mistakenly deploying
255     // an instance of this contract, which should be used via inheritance.
256     constructor () internal { }
257     // solhint-disable-previous-line no-empty-blocks
258 
259     function _msgSender() internal view returns (address payable) {
260         return msg.sender;
261     }
262 
263     function _msgData() internal view returns (bytes memory) {
264         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
265         return msg.data;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 pragma solidity ^0.5.5;
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
296         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
297         // for accounts without code, i.e. `keccak256('')`
298         bytes32 codehash;
299         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { codehash := extcodehash(account) }
302         return (codehash != accountHash && codehash != 0x0);
303     }
304 
305     /**
306      * @dev Converts an `address` into `address payable`. Note that this is
307      * simply a type cast: the actual underlying value is not changed.
308      *
309      * _Available since v2.4.0._
310      */
311     function toPayable(address account) internal pure returns (address payable) {
312         return address(uint160(account));
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      *
331      * _Available since v2.4.0._
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(address(this).balance >= amount, "Address: insufficient balance");
335 
336         // solhint-disable-next-line avoid-call-value
337         (bool success, ) = recipient.call.value(amount)("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 }
341 
342 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
343 
344 pragma solidity ^0.5.0;
345 
346 
347 
348 
349 /**
350  * @title SafeERC20
351  * @dev Wrappers around ERC20 operations that throw on failure (when the token
352  * contract returns false). Tokens that return no value (and instead revert or
353  * throw on failure) are also supported, non-reverting calls are assumed to be
354  * successful.
355  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
356  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
357  */
358 library SafeERC20 {
359     using SafeMath for uint256;
360     using Address for address;
361 
362     function safeTransfer(IERC20 token, address to, uint256 value) internal {
363         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
364     }
365 
366     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
367         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
368     }
369 
370     function safeApprove(IERC20 token, address spender, uint256 value) internal {
371         // safeApprove should only be called when setting an initial allowance,
372         // or when resetting it to zero. To increase and decrease it, use
373         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
374         // solhint-disable-next-line max-line-length
375         require((value == 0) || (token.allowance(address(this), spender) == 0),
376             "SafeERC20: approve from non-zero to non-zero allowance"
377         );
378         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
379     }
380 
381     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
382         uint256 newAllowance = token.allowance(address(this), spender).add(value);
383         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
384     }
385 
386     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
387         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
388         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
389     }
390 
391     /**
392      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
393      * on the return value: the return value is optional (but if data is returned, it must not be false).
394      * @param token The token targeted by the call.
395      * @param data The call data (encoded using abi.encode or one of its variants).
396      */
397     function callOptionalReturn(IERC20 token, bytes memory data) private {
398         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
399         // we're implementing it ourselves.
400 
401         // A Solidity high level call has three parts:
402         //  1. The target address is checked to verify it contains contract code
403         //  2. The call itself is made, and success asserted
404         //  3. The return value is decoded, which in turn checks the size of the returned data.
405         // solhint-disable-next-line max-line-length
406         require(address(token).isContract(), "SafeERC20: call to non-contract");
407 
408         // solhint-disable-next-line avoid-low-level-calls
409         (bool success, bytes memory returndata) = address(token).call(data);
410         require(success, "SafeERC20: low-level call failed");
411 
412         if (returndata.length > 0) { // Return data is optional
413             // solhint-disable-next-line max-line-length
414             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
415         }
416     }
417 }
418 
419 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
420 
421 pragma solidity ^0.5.0;
422 
423 /**
424  * @dev Contract module that helps prevent reentrant calls to a function.
425  *
426  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
427  * available, which can be applied to functions to make sure there are no nested
428  * (reentrant) calls to them.
429  *
430  * Note that because there is a single `nonReentrant` guard, functions marked as
431  * `nonReentrant` may not call one another. This can be worked around by making
432  * those functions `private`, and then adding `external` `nonReentrant` entry
433  * points to them.
434  *
435  * TIP: If you would like to learn more about reentrancy and alternative ways
436  * to protect against it, check out our blog post
437  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
438  *
439  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
440  * metering changes introduced in the Istanbul hardfork.
441  */
442 contract ReentrancyGuard {
443     bool private _notEntered;
444 
445     constructor () internal {
446         // Storing an initial non-zero value makes deployment a bit more
447         // expensive, but in exchange the refund on every call to nonReentrant
448         // will be lower in amount. Since refunds are capped to a percetange of
449         // the total transaction's gas, it is best to keep them low in cases
450         // like this one, to increase the likelihood of the full refund coming
451         // into effect.
452         _notEntered = true;
453     }
454 
455     /**
456      * @dev Prevents a contract from calling itself, directly or indirectly.
457      * Calling a `nonReentrant` function from another `nonReentrant`
458      * function is not supported. It is possible to prevent this from happening
459      * by making the `nonReentrant` function external, and make it call a
460      * `private` function that does the actual work.
461      */
462     modifier nonReentrant() {
463         // On the first call to nonReentrant, _notEntered will be true
464         require(_notEntered, "ReentrancyGuard: reentrant call");
465 
466         // Any calls to nonReentrant after this point will fail
467         _notEntered = false;
468 
469         _;
470 
471         // By storing the original value once again, a refund is triggered (see
472         // https://eips.ethereum.org/EIPS/eip-2200)
473         _notEntered = true;
474     }
475 }
476 
477 // SPDX-License-Identifier: MIT
478 
479 pragma solidity ^0.5.0;
480 
481 /**
482  * @dev Contract module which provides a basic access control mechanism, where
483  * there is an account (an owner) that can be granted exclusive access to
484  * specific functions.
485  *
486  * By default, the owner account will be the one that deploys the contract. This
487  * can later be changed with {transferOwnership}.
488  *
489  * This module is used through inheritance. It will make available the modifier
490  * `onlyOwner`, which can be applied to your functions to restrict their use to
491  * the owner.
492  */
493 contract Ownable is Context {
494     address private _owner;
495 
496     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
497 
498     /**
499      * @dev Initializes the contract setting the deployer as the initial owner.
500      */
501     constructor () internal {
502         address msgSender = _msgSender();
503         _owner = msgSender;
504         emit OwnershipTransferred(address(0), msgSender);
505     }
506 
507     /**
508      * @dev Returns the address of the current owner.
509      */
510     function owner() public view returns (address) {
511         return _owner;
512     }
513 
514     /**
515      * @dev Throws if called by any account other than the owner.
516      */
517     modifier onlyOwner() {
518         require(_owner == _msgSender(), "Ownable: caller is not the owner");
519         _;
520     }
521 
522     /**
523      * @dev Leaves the contract without owner. It will not be possible to call
524      * `onlyOwner` functions anymore. Can only be called by the current owner.
525      *
526      * NOTE: Renouncing ownership will leave the contract without an owner,
527      * thereby removing any functionality that is only available to the owner.
528      */
529     function renounceOwnership() public onlyOwner {
530         emit OwnershipTransferred(_owner, address(0));
531         _owner = address(0);
532     }
533 
534     /**
535      * @dev Transfers ownership of the contract to a new account (`newOwner`).
536      * Can only be called by the current owner.
537      */
538     function transferOwnership(address newOwner) public onlyOwner {
539         require(newOwner != address(0), "Ownable: new owner is the zero address");
540         emit OwnershipTransferred(_owner, newOwner);
541         _owner = newOwner;
542     }
543 }
544 
545 // File: @openzeppelin/contracts/crowdsale/Crowdsale.sol
546 
547 pragma solidity ^0.5.0;
548 
549 /**
550  * @title Crowdsale
551  * @dev Crowdsale is a base contract for managing a token crowdsale,
552  * allowing investors to purchase tokens with ether. This contract implements
553  * such functionality in its most fundamental form and can be extended to provide additional
554  * functionality and/or custom behavior.
555  * The external interface represents the basic interface for purchasing tokens, and conforms
556  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
557  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
558  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
559  * behavior.
560  */
561 contract Crowdsale is Context, ReentrancyGuard {
562     using SafeMath for uint256;
563     using SafeERC20 for IERC20;
564 
565     // The token being sold
566     IERC20 private _token;
567 
568     // Address where funds are collected
569     address payable private _wallet;
570 
571     // How many token units a buyer gets per wei.
572     // The rate is the conversion between wei and the smallest and indivisible token unit.
573     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
574     // 1 wei will give you 1 unit, or 0.001 TOK.
575     uint256 private _rate;
576 
577     // Amount of wei raised
578     uint256 private _weiRaised;
579 
580     /**
581      * Event for token purchase logging
582      * @param purchaser who paid for the tokens
583      * @param beneficiary who got the tokens
584      * @param value weis paid for purchase
585      * @param amount amount of tokens purchased
586      */
587     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
588 
589     /**
590      * @param rate Number of token units a buyer gets per wei
591      * @dev The rate is the conversion between wei and the smallest and indivisible
592      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
593      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
594      * @param wallet Address where collected funds will be forwarded to
595      * @param token Address of the token being sold
596      */
597     constructor (uint256 rate, address payable wallet, IERC20 token) public {
598         require(rate > 0, "Crowdsale: rate is 0");
599         require(wallet != address(0), "Crowdsale: wallet is the zero address");
600         require(address(token) != address(0), "Crowdsale: token is the zero address");
601 
602         _rate = rate;
603         _wallet = wallet;
604         _token = token;
605     }
606 
607     /**
608      * @dev fallback function ***DO NOT OVERRIDE***
609      * Note that other contracts will transfer funds with a base gas stipend
610      * of 2300, which is not enough to call buyTokens. Consider calling
611      * buyTokens directly when purchasing tokens from a contract.
612      */
613     function () external payable {
614         buyTokens(_msgSender());
615     }
616 
617     /**
618      * @return the token being sold.
619      */
620     function token() public view returns (IERC20) {
621         return _token;
622     }
623 
624     /**
625      * @return the address where funds are collected.
626      */
627     function wallet() public view returns (address payable) {
628         return _wallet;
629     }
630 
631     /**
632      * @return the number of token units a buyer gets per wei.
633      */
634     function rate() public view returns (uint256) {
635         return _rate;
636     }
637 
638     /**
639      * @return the amount of wei raised.
640      */
641     function weiRaised() public view returns (uint256) {
642         return _weiRaised;
643     }
644 
645     /**
646      * @dev low level token purchase ***DO NOT OVERRIDE***
647      * This function has a non-reentrancy guard, so it shouldn't be called by
648      * another `nonReentrant` function.
649      * @param beneficiary Recipient of the token purchase
650      */
651     function buyTokens(address beneficiary) public nonReentrant payable {
652         uint256 weiAmount = msg.value;
653         _preValidatePurchase(beneficiary, weiAmount);
654 
655         // calculate token amount to be created
656         uint256 tokens = _getTokenAmount(weiAmount);
657 
658         // update state
659         _weiRaised = _weiRaised.add(weiAmount);
660 
661         _processPurchase(beneficiary, tokens);
662         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
663 
664         _updatePurchasingState(beneficiary, weiAmount);
665 
666         _forwardFunds();
667         _postValidatePurchase(beneficiary, weiAmount);
668     }
669 
670     /**
671      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
672      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
673      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
674      *     super._preValidatePurchase(beneficiary, weiAmount);
675      *     require(weiRaised().add(weiAmount) <= cap);
676      * @param beneficiary Address performing the token purchase
677      * @param weiAmount Value in wei involved in the purchase
678      */
679     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
680         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
681         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
682         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
683     }
684 
685     /**
686      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
687      * conditions are not met.
688      * @param beneficiary Address performing the token purchase
689      * @param weiAmount Value in wei involved in the purchase
690      */
691     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
692         // solhint-disable-previous-line no-empty-blocks
693     }
694 
695     /**
696      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
697      * its tokens.
698      * @param beneficiary Address performing the token purchase
699      * @param tokenAmount Number of tokens to be emitted
700      */
701     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
702         _token.safeTransfer(beneficiary, tokenAmount);
703     }
704 
705     /**
706      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
707      * tokens.
708      * @param beneficiary Address receiving the tokens
709      * @param tokenAmount Number of tokens to be purchased
710      */
711     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
712         _deliverTokens(beneficiary, tokenAmount);
713     }
714 
715     /**
716      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
717      * etc.)
718      * @param beneficiary Address receiving the tokens
719      * @param weiAmount Value in wei involved in the purchase
720      */
721     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
722         // solhint-disable-previous-line no-empty-blocks
723     }
724 
725     /**
726      * @dev Override to extend the way in which ether is converted to tokens.
727      * @param weiAmount Value in wei to be converted into tokens
728      * @return Number of tokens that can be purchased with the specified _weiAmount
729      */
730     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
731         return weiAmount.mul(_rate);
732     }
733 
734     /**
735      * @dev Determines how ETH is stored/forwarded on purchases.
736      */
737     function _forwardFunds() internal {
738         _wallet.transfer(msg.value);
739     }
740 }
741 
742 // File: @openzeppelin/contracts/crowdsale/validation/CappedCrowdsale.sol
743 
744 pragma solidity ^0.5.0;
745 
746 
747 
748 /**
749  * @title CappedCrowdsale
750  * @dev Crowdsale with a limit for total contributions.
751  */
752 contract CappedCrowdsale is Crowdsale {
753     using SafeMath for uint256;
754 
755     uint256 private _cap;
756 
757     /**
758      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
759      * @param cap Max amount of wei to be contributed
760      */
761     constructor (uint256 cap) public {
762         require(cap > 0, "CappedCrowdsale: cap is 0");
763         _cap = cap;
764     }
765 
766     /**
767      * @return the cap of the crowdsale.
768      */
769     function cap() public view returns (uint256) {
770         return _cap;
771     }
772 
773     /**
774      * @dev Checks whether the cap has been reached.
775      * @return Whether the cap was reached
776      */
777     function capReached() public view returns (bool) {
778         uint256 _adjustedValue = 0.5 ether;
779         uint256 _adjustedCap = _cap.sub(_adjustedValue);
780         return weiRaised() >= _adjustedCap;
781     }
782 
783     /**
784      * @dev Extend parent behavior requiring purchase to respect the funding cap.
785      * @param beneficiary Token purchaser
786      * @param weiAmount Amount of wei contributed
787      */
788     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
789         super._preValidatePurchase(beneficiary, weiAmount);
790         require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
791     }
792 }
793 
794 // File: @openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol
795 
796 pragma solidity ^0.5.0;
797 
798 /**
799  * @title TimedCrowdsale
800  * @dev Crowdsale accepting contributions only within a time frame.
801  */
802 contract TimedCrowdsale is Ownable, CappedCrowdsale {
803     using SafeMath for uint256;
804 
805     uint256 private _openingTime;
806     uint256 private _closingTime;
807     bool private _finalized;
808 
809     event CrowdsaleFinalized();
810 
811     /**
812      * Event for crowdsale extending
813      * @param newClosingTime new closing time
814      * @param prevClosingTime old closing time
815      */
816     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
817 
818     /**
819      * @dev Reverts if not in crowdsale time range.
820      */
821     modifier onlyWhileOpen {
822         require(isOpen(), "TimedCrowdsale: not open");
823         _;
824     }
825 
826     /**
827      * @dev Constructor, takes crowdsale opening and closing times.
828      * @param openingTime Crowdsale opening time
829      * @param closingTime Crowdsale closing time
830      */
831     constructor (uint256 openingTime, uint256 closingTime) public {
832         // solhint-disable-next-line not-rely-on-time
833         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
834         // solhint-disable-next-line max-line-length
835         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
836 
837         _openingTime = openingTime;
838         _closingTime = closingTime;
839         _finalized = false;
840     }
841 
842     /**
843      * @return the crowdsale opening time.
844      */
845     function openingTime() public view returns (uint256) {
846         return _openingTime;
847     }
848 
849     /**
850      * @return the crowdsale closing time.
851      */
852     function closingTime() public view returns (uint256) {
853         return _closingTime;
854     }
855 
856     /**
857      * @return true if the crowdsale is open, false otherwise.
858      */
859     function isOpen() public view returns (bool) {
860         // solhint-disable-next-line not-rely-on-time
861         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
862     }
863 
864     /**
865      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
866      * @return Whether crowdsale period has elapsed
867      */
868     function hasClosed() public view returns (bool) {
869         // solhint-disable-next-line not-rely-on-time
870         return ((block.timestamp > _closingTime) || (capReached()));
871     }
872 
873     /**
874      * @return true if the crowdsale is finalized, false otherwise.
875      */
876     function finalized() public view returns (bool) {
877         return _finalized;
878     }
879 
880     /**
881      * @dev Must be called after crowdsale ends, to do some extra finalization
882      * work. Calls the contract's finalization function.
883      */
884     function finalize() public onlyOwner {
885 
886         require(!_finalized, "FinalizableCrowdsale: already finalized");
887         require(hasClosed(), "FinalizableCrowdsale: not closed");
888 
889         _finalized = true;
890 
891         _finalization();
892         emit CrowdsaleFinalized();
893     }
894 
895     /**
896      * @dev Can be overridden to add finalization logic. The overriding function
897      * should call super._finalization() to ensure the chain of finalization is
898      * executed entirely.
899      */
900     function _finalization() internal {
901         // solhint-disable-previous-line no-empty-blocks
902     }
903     /**
904      * @dev Extend parent behavior requiring to be within contributing period.
905      * @param beneficiary Token purchaser
906      * @param weiAmount Amount of wei contributed
907      */
908     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
909         super._preValidatePurchase(beneficiary, weiAmount);
910     }
911 
912     /**
913      * @dev Extend crowdsale.
914      * @param newClosingTime Crowdsale closing time
915      */
916     function _extendTime(uint256 newClosingTime) internal {
917         require(!hasClosed(), "TimedCrowdsale: already closed");
918         // solhint-disable-next-line max-line-length
919         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
920 
921         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
922         _closingTime = newClosingTime;
923     }
924 }
925 
926 // File: @openzeppelin/contracts/ownership/Secondary.sol
927 
928 pragma solidity ^0.5.0;
929 
930 /**
931  * @dev A Secondary contract can only be used by its primary account (the one that created it).
932  */
933 contract Secondary is Context {
934     address private _primary;
935 
936     /**
937      * @dev Emitted when the primary contract changes.
938      */
939     event PrimaryTransferred(
940         address recipient
941     );
942 
943     /**
944      * @dev Sets the primary account to the one that is creating the Secondary contract.
945      */
946     constructor () internal {
947         address msgSender = _msgSender();
948         _primary = msgSender;
949         emit PrimaryTransferred(msgSender);
950     }
951 
952     /**
953      * @dev Reverts if called from any account other than the primary.
954      */
955     modifier onlyPrimary() {
956         require(_msgSender() == _primary, "Secondary: caller is not the primary account");
957         _;
958     }
959 
960     /**
961      * @return the address of the primary.
962      */
963     function primary() public view returns (address) {
964         return _primary;
965     }
966 
967     /**
968      * @dev Transfers contract to a new primary.
969      * @param recipient The address of new primary.
970      */
971     function transferPrimary(address recipient) public onlyPrimary {
972         require(recipient != address(0), "Secondary: new primary is the zero address");
973         _primary = recipient;
974         emit PrimaryTransferred(recipient);
975     }
976 }
977 
978 // File: @openzeppelin/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
979 
980 pragma solidity ^0.5.0;
981 
982 
983 
984 
985 
986 /**
987  * @title PostDeliveryCrowdsale
988  * @dev Crowdsale that locks tokens from withdrawal until it ends.
989  */
990 contract PostDeliveryCrowdsale is TimedCrowdsale {
991     using SafeMath for uint256;
992 
993     mapping(address => uint256) private _balances;
994     __unstable__TokenVault private _vault;
995 
996     constructor() public {
997         _vault = new __unstable__TokenVault();
998     }
999 
1000     /**
1001      * @dev Withdraw tokens only after crowdsale ends.
1002      * @param beneficiary Whose tokens will be withdrawn.
1003      */
1004     function withdrawTokens(address beneficiary) public {
1005         require(hasClosed(), "PostDeliveryCrowdsale: not closed");
1006         require(finalized(), "PostDeliveryCrowdsale: not finalized");
1007 
1008         uint256 amount = _balances[beneficiary];
1009         require(amount > 0, "PostDeliveryCrowdsale: beneficiary is not due any tokens");
1010 
1011         _balances[beneficiary] = 0;
1012         _vault.transfer(token(), beneficiary, amount);
1013     }
1014 
1015     /**
1016      * @return the balance of an account.
1017      */
1018     function balanceOf(address account) public view returns (uint256) {
1019         return _balances[account];
1020     }
1021 
1022     /**
1023      * @dev Overrides parent by storing due balances, and delivering tokens to the vault instead of the end user. This
1024      * ensures that the tokens will be available by the time they are withdrawn (which may not be the case if
1025      * `_deliverTokens` was called later).
1026      * @param beneficiary Token purchaser
1027      * @param tokenAmount Amount of tokens purchased
1028      */
1029     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
1030         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
1031         _deliverTokens(address(_vault), tokenAmount);
1032     }
1033 }
1034 
1035 /**
1036  * @title __unstable__TokenVault
1037  * @dev Similar to an Escrow for tokens, this contract allows its primary account to spend its tokens as it sees fit.
1038  * This contract is an internal helper for PostDeliveryCrowdsale, and should not be used outside of this context.
1039  */
1040 // solhint-disable-next-line contract-name-camelcase
1041 contract __unstable__TokenVault is Secondary {
1042     function transfer(IERC20 token, address to, uint256 amount) public onlyPrimary {
1043         token.transfer(to, amount);
1044     }
1045 }
1046 
1047 // File: contracts/StealthSwapCrowdsale.sol
1048 
1049 pragma solidity ^0.5.0;
1050 
1051 
1052 
1053 
1054 
1055 contract StealthSwapCrowdsale is CappedCrowdsale, PostDeliveryCrowdsale {
1056 
1057     uint256 public investorMinCap = 0.5 ether;
1058     uint256 public investorHardCap = 75 ether;
1059 
1060     uint256 public _hardCap = 2690 ether;
1061     uint256 public _exchangeRate = 974;
1062 
1063 	mapping(address => uint256) private _contributions;
1064     constructor (uint256 openingTime, uint256 closingTime, uint256 rate, address payable wallet, IERC20 token)
1065         public
1066         TimedCrowdsale(openingTime, closingTime)
1067         Crowdsale(rate, wallet, token)
1068         CappedCrowdsale(_hardCap)
1069     {
1070         // solhint-disable-previous-line no-empty-blocks
1071     }
1072     function _updatePurchasingState(address _beneficiary, uint256 weiAmount) internal {
1073         // solhint-disable-previous-line no-empty-blocks
1074         super._updatePurchasingState(_beneficiary, weiAmount);
1075         _contributions[_beneficiary] = weiAmount;
1076     }
1077     function _preValidatePurchase(
1078         address _beneficiary,
1079         uint256 _weiAmount
1080     )
1081     internal view
1082     {
1083         super._preValidatePurchase(_beneficiary, _weiAmount);
1084         uint256 _existingContribution = _contributions[_beneficiary];
1085         uint256 _newContribution = _existingContribution.add(_weiAmount);
1086         require(_newContribution >= investorMinCap && _newContribution <= investorHardCap, "CappedCrowdsale: individual cap exceeded");
1087     }
1088 }