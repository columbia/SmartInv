1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-26
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21     // solhint-disable-previous-line no-empty-blocks
22 
23     function _msgSender() internal view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 pragma solidity ^0.5.0;
111 
112 /**
113  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
114  * the optional functions; to access them see {ERC20Detailed}.
115  */
116 interface IERC20 {
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `recipient`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `sender` to `recipient` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Emitted when `value` tokens are moved from one account (`from`) to
174      * another (`to`).
175      *
176      * Note that `value` may be zero.
177      */
178     event Transfer(address indexed from, address indexed to, uint256 value);
179 
180     /**
181      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
182      * a call to {approve}. `value` is the new allowance.
183      */
184     event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 
187 pragma solidity ^0.5.0;
188 
189 /**
190  * @dev Wrappers over Solidity's arithmetic operations with added overflow
191  * checks.
192  *
193  * Arithmetic operations in Solidity wrap on overflow. This can easily result
194  * in bugs, because programmers usually assume that an overflow raises an
195  * error, which is the standard behavior in high level programming languages.
196  * `SafeMath` restores this intuition by reverting the transaction when an
197  * operation overflows.
198  *
199  * Using this library instead of the unchecked operations eliminates an entire
200  * class of bugs, so it's recommended to use it always.
201  */
202 library SafeMath {
203     /**
204      * @dev Returns the addition of two unsigned integers, reverting on
205      * overflow.
206      *
207      * Counterpart to Solidity's `+` operator.
208      *
209      * Requirements:
210      * - Addition cannot overflow.
211      */
212     function add(uint256 a, uint256 b) internal pure returns (uint256) {
213         uint256 c = a + b;
214         require(c >= a, "SafeMath: addition overflow");
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the subtraction of two unsigned integers, reverting on
221      * overflow (when the result is negative).
222      *
223      * Counterpart to Solidity's `-` operator.
224      *
225      * Requirements:
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         return sub(a, b, "SafeMath: subtraction overflow");
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      * - Subtraction cannot overflow.
240      *
241      * _Available since v2.4.0._
242      */
243     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b <= a, errorMessage);
245         uint256 c = a - b;
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the multiplication of two unsigned integers, reverting on
252      * overflow.
253      *
254      * Counterpart to Solidity's `*` operator.
255      *
256      * Requirements:
257      * - Multiplication cannot overflow.
258      */
259     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
261         // benefit is lost if 'b' is also tested.
262         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
263         if (a == 0) {
264             return 0;
265         }
266 
267         uint256 c = a * b;
268         require(c / a == b, "SafeMath: multiplication overflow");
269 
270         return c;
271     }
272 
273     /**
274      * @dev Returns the integer division of two unsigned integers. Reverts on
275      * division by zero. The result is rounded towards zero.
276      *
277      * Counterpart to Solidity's `/` operator. Note: this function uses a
278      * `revert` opcode (which leaves remaining gas untouched) while Solidity
279      * uses an invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      * - The divisor cannot be zero.
283      */
284     function div(uint256 a, uint256 b) internal pure returns (uint256) {
285         return div(a, b, "SafeMath: division by zero");
286     }
287 
288     /**
289      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
290      * division by zero. The result is rounded towards zero.
291      *
292      * Counterpart to Solidity's `/` operator. Note: this function uses a
293      * `revert` opcode (which leaves remaining gas untouched) while Solidity
294      * uses an invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      * - The divisor cannot be zero.
298      *
299      * _Available since v2.4.0._
300      */
301     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         // Solidity only automatically asserts when dividing by 0
303         require(b > 0, errorMessage);
304         uint256 c = a / b;
305         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
306 
307         return c;
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * Reverts when dividing by zero.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      * - The divisor cannot be zero.
320      */
321     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
322         return mod(a, b, "SafeMath: modulo by zero");
323     }
324 
325     /**
326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
327      * Reverts with custom message when dividing by zero.
328      *
329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
330      * opcode (which leaves remaining gas untouched) while Solidity uses an
331      * invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      * - The divisor cannot be zero.
335      *
336      * _Available since v2.4.0._
337      */
338     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
339         require(b != 0, errorMessage);
340         return a % b;
341     }
342 }
343 
344 pragma solidity ^0.5.5;
345 
346 /**
347  * @dev Collection of functions related to the address type
348  */
349 library Address {
350     /**
351      * @dev Returns true if `account` is a contract.
352      *
353      * [IMPORTANT]
354      * ====
355      * It is unsafe to assume that an address for which this function returns
356      * false is an externally-owned account (EOA) and not a contract.
357      *
358      * Among others, `isContract` will return false for the following
359      * types of addresses:
360      *
361      *  - an externally-owned account
362      *  - a contract in construction
363      *  - an address where a contract will be created
364      *  - an address where a contract lived, but was destroyed
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
369         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
370         // for accounts without code, i.e. `keccak256('')`
371         bytes32 codehash;
372         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
373         // solhint-disable-next-line no-inline-assembly
374         assembly { codehash := extcodehash(account) }
375         return (codehash != accountHash && codehash != 0x0);
376     }
377 
378     /**
379      * @dev Converts an `address` into `address payable`. Note that this is
380      * simply a type cast: the actual underlying value is not changed.
381      *
382      * _Available since v2.4.0._
383      */
384     function toPayable(address account) internal pure returns (address payable) {
385         return address(uint160(account));
386     }
387 
388     /**
389      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
390      * `recipient`, forwarding all available gas and reverting on errors.
391      *
392      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
393      * of certain opcodes, possibly making contracts go over the 2300 gas limit
394      * imposed by `transfer`, making them unable to receive funds via
395      * `transfer`. {sendValue} removes this limitation.
396      *
397      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
398      *
399      * IMPORTANT: because control is transferred to `recipient`, care must be
400      * taken to not create reentrancy vulnerabilities. Consider using
401      * {ReentrancyGuard} or the
402      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
403      *
404      * _Available since v2.4.0._
405      */
406     function sendValue(address payable recipient, uint256 amount) internal {
407         require(address(this).balance >= amount, "Address: insufficient balance");
408 
409         // solhint-disable-next-line avoid-call-value
410         (bool success, ) = recipient.call.value(amount)("");
411         require(success, "Address: unable to send value, recipient may have reverted");
412     }
413 }
414 
415 pragma solidity ^0.5.0;
416 
417 /**
418  * @title SafeERC20
419  * @dev Wrappers around ERC20 operations that throw on failure (when the token
420  * contract returns false). Tokens that return no value (and instead revert or
421  * throw on failure) are also supported, non-reverting calls are assumed to be
422  * successful.
423  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
424  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
425  */
426 library SafeERC20 {
427     using SafeMath for uint256;
428     using Address for address;
429 
430     function safeTransfer(IERC20 token, address to, uint256 value) internal {
431         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
432     }
433 
434     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
435         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
436     }
437 
438     function safeApprove(IERC20 token, address spender, uint256 value) internal {
439         // safeApprove should only be called when setting an initial allowance,
440         // or when resetting it to zero. To increase and decrease it, use
441         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
442         // solhint-disable-next-line max-line-length
443         require((value == 0) || (token.allowance(address(this), spender) == 0),
444             "SafeERC20: approve from non-zero to non-zero allowance"
445         );
446         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
447     }
448 
449     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
450         uint256 newAllowance = token.allowance(address(this), spender).add(value);
451         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
452     }
453 
454     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
455         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
456         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
457     }
458 
459     /**
460      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
461      * on the return value: the return value is optional (but if data is returned, it must not be false).
462      * @param token The token targeted by the call.
463      * @param data The call data (encoded using abi.encode or one of its variants).
464      */
465     function callOptionalReturn(IERC20 token, bytes memory data) private {
466         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
467         // we're implementing it ourselves.
468 
469         // A Solidity high level call has three parts:
470         //  1. The target address is checked to verify it contains contract code
471         //  2. The call itself is made, and success asserted
472         //  3. The return value is decoded, which in turn checks the size of the returned data.
473         // solhint-disable-next-line max-line-length
474         require(address(token).isContract(), "SafeERC20: call to non-contract");
475 
476         // solhint-disable-next-line avoid-low-level-calls
477         (bool success, bytes memory returndata) = address(token).call(data);
478         require(success, "SafeERC20: low-level call failed");
479 
480         if (returndata.length > 0) { // Return data is optional
481             // solhint-disable-next-line max-line-length
482             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
483         }
484     }
485 }
486 
487 pragma solidity ^0.5.0;
488 
489 /**
490  * @dev Contract module that helps prevent reentrant calls to a function.
491  *
492  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
493  * available, which can be applied to functions to make sure there are no nested
494  * (reentrant) calls to them.
495  *
496  * Note that because there is a single `nonReentrant` guard, functions marked as
497  * `nonReentrant` may not call one another. This can be worked around by making
498  * those functions `private`, and then adding `external` `nonReentrant` entry
499  * points to them.
500  *
501  * TIP: If you would like to learn more about reentrancy and alternative ways
502  * to protect against it, check out our blog post
503  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
504  *
505  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
506  * metering changes introduced in the Istanbul hardfork.
507  */
508 contract ReentrancyGuard {
509     bool private _notEntered;
510 
511     constructor () internal {
512         // Storing an initial non-zero value makes deployment a bit more
513         // expensive, but in exchange the refund on every call to nonReentrant
514         // will be lower in amount. Since refunds are capped to a percetange of
515         // the total transaction's gas, it is best to keep them low in cases
516         // like this one, to increase the likelihood of the full refund coming
517         // into effect.
518         _notEntered = true;
519     }
520 
521     /**
522      * @dev Prevents a contract from calling itself, directly or indirectly.
523      * Calling a `nonReentrant` function from another `nonReentrant`
524      * function is not supported. It is possible to prevent this from happening
525      * by making the `nonReentrant` function external, and make it call a
526      * `private` function that does the actual work.
527      */
528     modifier nonReentrant() {
529         // On the first call to nonReentrant, _notEntered will be true
530         require(_notEntered, "ReentrancyGuard: reentrant call");
531 
532         // Any calls to nonReentrant after this point will fail
533         _notEntered = false;
534 
535         _;
536 
537         // By storing the original value once again, a refund is triggered (see
538         // https://eips.ethereum.org/EIPS/eip-2200)
539         _notEntered = true;
540     }
541 }
542 
543 pragma solidity ^0.5.0;
544 
545 /**
546  * @title Crowdsale
547  * @dev Crowdsale is a base contract for managing a token crowdsale,
548  * allowing investors to purchase tokens with ether. This contract implements
549  * such functionality in its most fundamental form and can be extended to provide additional
550  * functionality and/or custom behavior.
551  * The external interface represents the basic interface for purchasing tokens, and conforms
552  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
553  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
554  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
555  * behavior.
556  */
557 contract Crowdsale is Context, ReentrancyGuard {
558     using SafeMath for uint256;
559     using SafeERC20 for IERC20;
560 
561     // The token being sold
562     IERC20 private _token;
563 
564     // Address where funds are collected
565     address payable private _wallet;
566 
567     // How many token units a buyer gets per wei.
568     // The rate is the conversion between wei and the smallest and indivisible token unit.
569 
570     uint256 private _rate;
571 
572     // Amount of wei raised
573     uint256 private _weiRaised;
574 
575     /**
576      * Event for token purchase logging
577      * @param purchaser who paid for the tokens
578      * @param beneficiary who got the tokens
579      * @param value weis paid for purchase
580      * @param amount amount of tokens purchased
581      */
582     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
583 
584     /**
585      * @param rate Number of token units a buyer gets per wei
586      * @dev The rate is the conversion between wei and the smallest and indivisible
587      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
588      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
589      * @param wallet Address where collected funds will be forwarded to
590      * @param token Address of the token being sold
591      */
592     constructor (uint256 rate, address payable wallet, IERC20 token) public {
593         require(rate > 0, "Crowdsale: rate is 0");
594         require(wallet != address(0), "Crowdsale: wallet is the zero address");
595         require(address(token) != address(0), "Crowdsale: token is the zero address");
596 
597         _rate = rate;
598         _wallet = wallet;
599         _token = token;
600     }
601 
602     /**
603      * @dev fallback function ***DO NOT OVERRIDE***
604      * Note that other contracts will transfer funds with a base gas stipend
605      * of 2300, which is not enough to call buyTokens. Consider calling
606      * buyTokens directly when purchasing tokens from a contract.
607      */
608     function () external payable {
609         buyTokens(_msgSender());
610     }
611 
612     /**
613      * @return the token being sold.
614      */
615     function token() public view returns (IERC20) {
616         return _token;
617     }
618 
619     /**
620      * @return the address where funds are collected.
621      */
622     function wallet() public view returns (address payable) {
623         return _wallet;
624     }
625 
626     /**
627      * @return the number of token units a buyer gets per wei.
628      */
629     function rate() public view returns (uint256) {
630         return _rate;
631     }
632 
633     /**
634      * @return the amount of wei raised.
635      */
636     function weiRaised() public view returns (uint256) {
637         return _weiRaised;
638     }
639 
640     /**
641      * @dev low level token purchase ***DO NOT OVERRIDE***
642      * This function has a non-reentrancy guard, so it shouldn't be called by
643      * another `nonReentrant` function.
644      * @param beneficiary Recipient of the token purchase
645      */
646     function buyTokens(address beneficiary) public nonReentrant payable {
647         uint256 weiAmount = msg.value;
648         _preValidatePurchase(beneficiary, weiAmount);
649 
650         // calculate token amount to be created
651         uint256 tokens = _getTokenAmount(weiAmount);
652 
653         // update state
654         _weiRaised = _weiRaised.add(weiAmount);
655 
656         _processPurchase(beneficiary, tokens);
657         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
658 
659         _updatePurchasingState(beneficiary, weiAmount);
660 
661         _forwardFunds();
662         _postValidatePurchase(beneficiary, weiAmount);
663     }
664 
665     /**
666      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
667      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
668      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
669      *     super._preValidatePurchase(beneficiary, weiAmount);
670      *     require(weiRaised().add(weiAmount) <= cap);
671      * @param beneficiary Address performing the token purchase
672      * @param weiAmount Value in wei involved in the purchase
673      */
674     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
675         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
676         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
677         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
678     }
679 
680     /**
681      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
682      * conditions are not met.
683      * @param beneficiary Address performing the token purchase
684      * @param weiAmount Value in wei involved in the purchase
685      */
686     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
687         // solhint-disable-previous-line no-empty-blocks
688     }
689 
690     /**
691      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
692      * its tokens.
693      * @param beneficiary Address performing the token purchase
694      * @param tokenAmount Number of tokens to be emitted
695      */
696     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
697         _token.safeTransfer(beneficiary, tokenAmount);
698     }
699 
700     /**
701      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
702      * tokens.
703      * @param beneficiary Address receiving the tokens
704      * @param tokenAmount Number of tokens to be purchased
705      */
706     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
707         _deliverTokens(beneficiary, tokenAmount);
708     }
709 
710     /**
711      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
712      * etc.)
713      * @param beneficiary Address receiving the tokens
714      * @param weiAmount Value in wei involved in the purchase
715      */
716     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
717         // solhint-disable-previous-line no-empty-blocks
718     }
719 
720     /**
721      * @dev Override to extend the way in which ether is converted to tokens.
722      * @param weiAmount Value in wei to be converted into tokens
723      * @return Number of tokens that can be purchased with the specified _weiAmount
724      */
725     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
726         return weiAmount.mul(_rate);
727     }
728 
729     /**
730      * @dev Determines how ETH is stored/forwarded on purchases.
731      */
732     function _forwardFunds() internal {
733         _wallet.transfer(msg.value);
734     }
735 }
736 
737 contract DotifySale is Crowdsale, Ownable {
738 
739     using SafeMath for uint256;
740     using SafeERC20 for IERC20;
741 
742     uint256 private rateM = 40000;    // rate in TKNbits
743     address payable private walletM = 0xCb1Cd7c15B30dC5b1E326D59e4D649f27EED4c22;
744     IERC20 private tokenM = IERC20(0x7CCC863EcE2E15bC45ac0565D410da7A3340aD98);
745     address private leftoverAddress = 0xE97C82e1e28566d9791881eF36C3213116Fb24DA;
746 
747     uint256 public newRateChange;    // rate in TKNbits
748 
749     constructor()
750         Crowdsale(rateM, walletM, tokenM)
751         public
752     {
753 
754     }
755 
756     function setRate(uint256 newRate) public onlyOwner {
757         rateM = newRate;
758         newRateChange = newRate;
759     }
760 
761     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
762         return weiAmount.mul(rateM);
763     }
764 
765     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
766        super._preValidatePurchase(beneficiary, weiAmount);
767     }
768 
769     function leftover(uint256 tokenAmount) public onlyOwner {
770         tokenM.safeTransfer(leftoverAddress, tokenAmount);
771     }
772 }