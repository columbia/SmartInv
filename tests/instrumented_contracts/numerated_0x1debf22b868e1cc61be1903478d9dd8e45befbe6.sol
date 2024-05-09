1 /*
2 
3    ___  _________________  ____  ____
4   / _ )/  _/ __/_  __/ _ \/ __ \/ __ \
5  / _  |/ /_\ \  / / / , _/ /_/ / /_/ /
6 /____/___/___/ /_/ /_/|_|\____/\____/
7 
8 Bistroo Crowdsale Contract
9 Powered by TERRY.COM
10 
11 */
12 
13 // File: @openzeppelin/contracts/GSN/Context.sol
14 
15 pragma solidity ^0.5.0;
16 
17 /*
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with GSN meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 contract Context {
28     // Empty internal constructor, to prevent people from mistakenly deploying
29     // an instance of this contract, which should be used via inheritance.
30     constructor () internal { }
31     // solhint-disable-previous-line no-empty-blocks
32 
33     function _msgSender() internal view returns (address payable) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view returns (bytes memory) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
44 
45 pragma solidity ^0.5.0;
46 
47 /**
48  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
49  * the optional functions; to access them see {ERC20Detailed}.
50  */
51 interface IERC20 {
52     /**
53      * @dev Returns the amount of tokens in existence.
54      */
55     function totalSupply() external view returns (uint256);
56 
57     /**
58      * @dev Returns the amount of tokens owned by `account`.
59      */
60     function balanceOf(address account) external view returns (uint256);
61 
62     /**
63      * @dev Moves `amount` tokens from the caller's account to `recipient`.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transfer(address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Returns the remaining number of tokens that `spender` will be
73      * allowed to spend on behalf of `owner` through {transferFrom}. This is
74      * zero by default.
75      *
76      * This value changes when {approve} or {transferFrom} are called.
77      */
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     /**
81      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * IMPORTANT: Beware that changing an allowance with this method brings the risk
86      * that someone may use both the old and the new allowance by unfortunate
87      * transaction ordering. One possible solution to mitigate this race
88      * condition is to first reduce the spender's allowance to 0 and set the
89      * desired value afterwards:
90      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
91      *
92      * Emits an {Approval} event.
93      */
94     function approve(address spender, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Moves `amount` tokens from `sender` to `recipient` using the
98      * allowance mechanism. `amount` is then deducted from the caller's
99      * allowance.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Emitted when `value` tokens are moved from one account (`from`) to
109      * another (`to`).
110      *
111      * Note that `value` may be zero.
112      */
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     /**
116      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
117      * a call to {approve}. `value` is the new allowance.
118      */
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 // File: @openzeppelin/contracts/math/SafeMath.sol
123 
124 pragma solidity ^0.5.0;
125 
126 /**
127  * @dev Wrappers over Solidity's arithmetic operations with added overflow
128  * checks.
129  *
130  * Arithmetic operations in Solidity wrap on overflow. This can easily result
131  * in bugs, because programmers usually assume that an overflow raises an
132  * error, which is the standard behavior in high level programming languages.
133  * `SafeMath` restores this intuition by reverting the transaction when an
134  * operation overflows.
135  *
136  * Using this library instead of the unchecked operations eliminates an entire
137  * class of bugs, so it's recommended to use it always.
138  */
139 library SafeMath {
140     /**
141      * @dev Returns the addition of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `+` operator.
145      *
146      * Requirements:
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      * - Subtraction cannot overflow.
177      *
178      * _Available since v2.4.0._
179      */
180     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b <= a, errorMessage);
182         uint256 c = a - b;
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198         // benefit is lost if 'b' is also tested.
199         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200         if (a == 0) {
201             return 0;
202         }
203 
204         uint256 c = a * b;
205         require(c / a == b, "SafeMath: multiplication overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         return div(a, b, "SafeMath: division by zero");
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      *
236      * _Available since v2.4.0._
237      */
238     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         // Solidity only automatically asserts when dividing by 0
240         require(b > 0, errorMessage);
241         uint256 c = a / b;
242         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return mod(a, b, "SafeMath: modulo by zero");
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts with custom message when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      * - The divisor cannot be zero.
272      *
273      * _Available since v2.4.0._
274      */
275     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b != 0, errorMessage);
277         return a % b;
278     }
279 }
280 
281 // File: @openzeppelin/contracts/utils/Address.sol
282 
283 pragma solidity ^0.5.5;
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
308         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
309         // for accounts without code, i.e. `keccak256('')`
310         bytes32 codehash;
311         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
312         // solhint-disable-next-line no-inline-assembly
313         assembly { codehash := extcodehash(account) }
314         return (codehash != accountHash && codehash != 0x0);
315     }
316 
317     /**
318      * @dev Converts an `address` into `address payable`. Note that this is
319      * simply a type cast: the actual underlying value is not changed.
320      *
321      * _Available since v2.4.0._
322      */
323     function toPayable(address account) internal pure returns (address payable) {
324         return address(uint160(account));
325     }
326 
327     /**
328      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
329      * `recipient`, forwarding all available gas and reverting on errors.
330      *
331      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
332      * of certain opcodes, possibly making contracts go over the 2300 gas limit
333      * imposed by `transfer`, making them unable to receive funds via
334      * `transfer`. {sendValue} removes this limitation.
335      *
336      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
337      *
338      * IMPORTANT: because control is transferred to `recipient`, care must be
339      * taken to not create reentrancy vulnerabilities. Consider using
340      * {ReentrancyGuard} or the
341      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
342      *
343      * _Available since v2.4.0._
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         // solhint-disable-next-line avoid-call-value
349         (bool success, ) = recipient.call.value(amount)("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 }
353 
354 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
355 
356 pragma solidity ^0.5.0;
357 
358 
359 
360 
361 /**
362  * @title SafeERC20
363  * @dev Wrappers around ERC20 operations that throw on failure (when the token
364  * contract returns false). Tokens that return no value (and instead revert or
365  * throw on failure) are also supported, non-reverting calls are assumed to be
366  * successful.
367  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
368  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
369  */
370 library SafeERC20 {
371     using SafeMath for uint256;
372     using Address for address;
373 
374     function safeTransfer(IERC20 token, address to, uint256 value) internal {
375         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
376     }
377 
378     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
379         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
380     }
381 
382     function safeApprove(IERC20 token, address spender, uint256 value) internal {
383         // safeApprove should only be called when setting an initial allowance,
384         // or when resetting it to zero. To increase and decrease it, use
385         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
386         // solhint-disable-next-line max-line-length
387         require((value == 0) || (token.allowance(address(this), spender) == 0),
388             "SafeERC20: approve from non-zero to non-zero allowance"
389         );
390         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
391     }
392 
393     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
394         uint256 newAllowance = token.allowance(address(this), spender).add(value);
395         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
396     }
397 
398     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
399         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
400         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
401     }
402 
403     /**
404      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
405      * on the return value: the return value is optional (but if data is returned, it must not be false).
406      * @param token The token targeted by the call.
407      * @param data The call data (encoded using abi.encode or one of its variants).
408      */
409     function callOptionalReturn(IERC20 token, bytes memory data) private {
410         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
411         // we're implementing it ourselves.
412 
413         // A Solidity high level call has three parts:
414         //  1. The target address is checked to verify it contains contract code
415         //  2. The call itself is made, and success asserted
416         //  3. The return value is decoded, which in turn checks the size of the returned data.
417         // solhint-disable-next-line max-line-length
418         require(address(token).isContract(), "SafeERC20: call to non-contract");
419 
420         // solhint-disable-next-line avoid-low-level-calls
421         (bool success, bytes memory returndata) = address(token).call(data);
422         require(success, "SafeERC20: low-level call failed");
423 
424         if (returndata.length > 0) { // Return data is optional
425             // solhint-disable-next-line max-line-length
426             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
427         }
428     }
429 }
430 
431 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
432 
433 pragma solidity ^0.5.0;
434 
435 /**
436  * @dev Contract module that helps prevent reentrant calls to a function.
437  *
438  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
439  * available, which can be applied to functions to make sure there are no nested
440  * (reentrant) calls to them.
441  *
442  * Note that because there is a single `nonReentrant` guard, functions marked as
443  * `nonReentrant` may not call one another. This can be worked around by making
444  * those functions `private`, and then adding `external` `nonReentrant` entry
445  * points to them.
446  *
447  * TIP: If you would like to learn more about reentrancy and alternative ways
448  * to protect against it, check out our blog post
449  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
450  *
451  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
452  * metering changes introduced in the Istanbul hardfork.
453  */
454 contract ReentrancyGuard {
455     bool private _notEntered;
456 
457     constructor () internal {
458         // Storing an initial non-zero value makes deployment a bit more
459         // expensive, but in exchange the refund on every call to nonReentrant
460         // will be lower in amount. Since refunds are capped to a percetange of
461         // the total transaction's gas, it is best to keep them low in cases
462         // like this one, to increase the likelihood of the full refund coming
463         // into effect.
464         _notEntered = true;
465     }
466 
467     /**
468      * @dev Prevents a contract from calling itself, directly or indirectly.
469      * Calling a `nonReentrant` function from another `nonReentrant`
470      * function is not supported. It is possible to prevent this from happening
471      * by making the `nonReentrant` function external, and make it call a
472      * `private` function that does the actual work.
473      */
474     modifier nonReentrant() {
475         // On the first call to nonReentrant, _notEntered will be true
476         require(_notEntered, "ReentrancyGuard: reentrant call");
477 
478         // Any calls to nonReentrant after this point will fail
479         _notEntered = false;
480 
481         _;
482 
483         // By storing the original value once again, a refund is triggered (see
484         // https://eips.ethereum.org/EIPS/eip-2200)
485         _notEntered = true;
486     }
487 }
488 
489 // File: @openzeppelin/contracts/crowdsale/Crowdsale.sol
490 
491 pragma solidity ^0.5.0;
492 
493 
494 
495 
496 
497 
498 /**
499  * @title Crowdsale
500  * @dev Crowdsale is a base contract for managing a token crowdsale,
501  * allowing investors to purchase tokens with ether. This contract implements
502  * such functionality in its most fundamental form and can be extended to provide additional
503  * functionality and/or custom behavior.
504  * The external interface represents the basic interface for purchasing tokens, and conforms
505  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
506  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
507  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
508  * behavior.
509  */
510 contract Crowdsale is Context, ReentrancyGuard {
511     using SafeMath for uint256;
512     using SafeERC20 for IERC20;
513 
514     // The token being sold
515     IERC20 private _token;
516 
517     // Address where funds are collected
518     address payable private _wallet;
519 
520     // How many token units a buyer gets per wei.
521     // The rate is the conversion between wei and the smallest and indivisible token unit.
522     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
523     // 1 wei will give you 1 unit, or 0.001 TOK.
524     uint256 private _rate;
525 
526     // Amount of wei raised
527     uint256 private _weiRaised;
528 
529     /**
530      * Event for token purchase logging
531      * @param purchaser who paid for the tokens
532      * @param beneficiary who got the tokens
533      * @param value weis paid for purchase
534      * @param amount amount of tokens purchased
535      */
536     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
537 
538     /**
539      * @param rate Number of token units a buyer gets per wei
540      * @dev The rate is the conversion between wei and the smallest and indivisible
541      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
542      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
543      * @param wallet Address where collected funds will be forwarded to
544      * @param token Address of the token being sold
545      */
546     constructor (uint256 rate, address payable wallet, IERC20 token) public {
547         require(rate > 0, "Crowdsale: rate is 0");
548         require(wallet != address(0), "Crowdsale: wallet is the zero address");
549         require(address(token) != address(0), "Crowdsale: token is the zero address");
550 
551         _rate = rate;
552         _wallet = wallet;
553         _token = token;
554     }
555 
556     /**
557      * @dev fallback function ***DO NOT OVERRIDE***
558      * Note that other contracts will transfer funds with a base gas stipend
559      * of 2300, which is not enough to call buyTokens. Consider calling
560      * buyTokens directly when purchasing tokens from a contract.
561      */
562     function () external payable {
563         buyTokens(_msgSender());
564     }
565 
566     /**
567      * @return the token being sold.
568      */
569     function token() public view returns (IERC20) {
570         return _token;
571     }
572 
573     /**
574      * @return the address where funds are collected.
575      */
576     function wallet() public view returns (address payable) {
577         return _wallet;
578     }
579 
580     /**
581      * @return the number of token units a buyer gets per wei.
582      */
583     function rate() public view returns (uint256) {
584         return _rate;
585     }
586 
587     /**
588      * @return the amount of wei raised.
589      */
590     function weiRaised() public view returns (uint256) {
591         return _weiRaised;
592     }
593 
594     /**
595      * @dev low level token purchase ***DO NOT OVERRIDE***
596      * This function has a non-reentrancy guard, so it shouldn't be called by
597      * another `nonReentrant` function.
598      * @param beneficiary Recipient of the token purchase
599      */
600     function buyTokens(address beneficiary) public nonReentrant payable {
601         uint256 weiAmount = msg.value;
602         _preValidatePurchase(beneficiary, weiAmount);
603 
604         // calculate token amount to be created
605         uint256 tokens = _getTokenAmount(weiAmount);
606 
607         // update state
608         _weiRaised = _weiRaised.add(weiAmount);
609 
610         _processPurchase(beneficiary, tokens);
611         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
612 
613         _updatePurchasingState(beneficiary, weiAmount);
614 
615         _forwardFunds();
616         _postValidatePurchase(beneficiary, weiAmount);
617     }
618 
619     /**
620      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
621      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
622      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
623      *     super._preValidatePurchase(beneficiary, weiAmount);
624      *     require(weiRaised().add(weiAmount) <= cap);
625      * @param beneficiary Address performing the token purchase
626      * @param weiAmount Value in wei involved in the purchase
627      */
628     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
629         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
630         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
631         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
632     }
633 
634     /**
635      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
636      * conditions are not met.
637      * @param beneficiary Address performing the token purchase
638      * @param weiAmount Value in wei involved in the purchase
639      */
640     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
641         // solhint-disable-previous-line no-empty-blocks
642     }
643 
644     /**
645      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
646      * its tokens.
647      * @param beneficiary Address performing the token purchase
648      * @param tokenAmount Number of tokens to be emitted
649      */
650     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
651         _token.safeTransfer(beneficiary, tokenAmount);
652     }
653 
654     /**
655      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
656      * tokens.
657      * @param beneficiary Address receiving the tokens
658      * @param tokenAmount Number of tokens to be purchased
659      */
660     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
661         _deliverTokens(beneficiary, tokenAmount);
662     }
663 
664     /**
665      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
666      * etc.)
667      * @param beneficiary Address receiving the tokens
668      * @param weiAmount Value in wei involved in the purchase
669      */
670     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
671         // solhint-disable-previous-line no-empty-blocks
672     }
673 
674     /**
675      * @dev Override to extend the way in which ether is converted to tokens.
676      * @param weiAmount Value in wei to be converted into tokens
677      * @return Number of tokens that can be purchased with the specified _weiAmount
678      */
679     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
680         return weiAmount.mul(_rate);
681     }
682 
683     /**
684      * @dev Determines how ETH is stored/forwarded on purchases.
685      */
686     function _forwardFunds() internal {
687         _wallet.transfer(msg.value);
688     }
689 }
690 
691 // File: @openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol
692 
693 pragma solidity ^0.5.0;
694 
695 
696 
697 /**
698  * @title TimedCrowdsale
699  * @dev Crowdsale accepting contributions only within a time frame.
700  */
701 contract TimedCrowdsale is Crowdsale {
702     using SafeMath for uint256;
703 
704     uint256 private _openingTime;
705     uint256 private _closingTime;
706 
707     /**
708      * Event for crowdsale extending
709      * @param newClosingTime new closing time
710      * @param prevClosingTime old closing time
711      */
712     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
713 
714     /**
715      * @dev Reverts if not in crowdsale time range.
716      */
717     modifier onlyWhileOpen {
718         require(isOpen(), "TimedCrowdsale: not open");
719         _;
720     }
721 
722     /**
723      * @dev Constructor, takes crowdsale opening and closing times.
724      * @param openingTime Crowdsale opening time
725      * @param closingTime Crowdsale closing time
726      */
727     constructor (uint256 openingTime, uint256 closingTime) public {
728         // solhint-disable-next-line not-rely-on-time
729         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
730         // solhint-disable-next-line max-line-length
731         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
732 
733         _openingTime = openingTime;
734         _closingTime = closingTime;
735     }
736 
737     /**
738      * @return the crowdsale opening time.
739      */
740     function openingTime() public view returns (uint256) {
741         return _openingTime;
742     }
743 
744     /**
745      * @return the crowdsale closing time.
746      */
747     function closingTime() public view returns (uint256) {
748         return _closingTime;
749     }
750 
751     /**
752      * @return true if the crowdsale is open, false otherwise.
753      */
754     function isOpen() public view returns (bool) {
755         // solhint-disable-next-line not-rely-on-time
756         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
757     }
758 
759     /**
760      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
761      * @return Whether crowdsale period has elapsed
762      */
763     function hasClosed() public view returns (bool) {
764         // solhint-disable-next-line not-rely-on-time
765         return block.timestamp > _closingTime;
766     }
767 
768     /**
769      * @dev Extend parent behavior requiring to be within contributing period.
770      * @param beneficiary Token purchaser
771      * @param weiAmount Amount of wei contributed
772      */
773     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
774         super._preValidatePurchase(beneficiary, weiAmount);
775     }
776 
777     /**
778      * @dev Extend crowdsale.
779      * @param newClosingTime Crowdsale closing time
780      */
781     function _extendTime(uint256 newClosingTime) internal {
782         require(!hasClosed(), "TimedCrowdsale: already closed");
783         // solhint-disable-next-line max-line-length
784         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
785 
786         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
787         _closingTime = newClosingTime;
788     }
789 }
790 
791 // File: @openzeppelin/contracts/ownership/Secondary.sol
792 
793 pragma solidity ^0.5.0;
794 
795 /**
796  * @dev A Secondary contract can only be used by its primary account (the one that created it).
797  */
798 contract Secondary is Context {
799     address private _primary;
800 
801     /**
802      * @dev Emitted when the primary contract changes.
803      */
804     event PrimaryTransferred(
805         address recipient
806     );
807 
808     /**
809      * @dev Sets the primary account to the one that is creating the Secondary contract.
810      */
811     constructor () internal {
812         address msgSender = _msgSender();
813         _primary = msgSender;
814         emit PrimaryTransferred(msgSender);
815     }
816 
817     /**
818      * @dev Reverts if called from any account other than the primary.
819      */
820     modifier onlyPrimary() {
821         require(_msgSender() == _primary, "Secondary: caller is not the primary account");
822         _;
823     }
824 
825     /**
826      * @return the address of the primary.
827      */
828     function primary() public view returns (address) {
829         return _primary;
830     }
831 
832     /**
833      * @dev Transfers contract to a new primary.
834      * @param recipient The address of new primary.
835      */
836     function transferPrimary(address recipient) public onlyPrimary {
837         require(recipient != address(0), "Secondary: new primary is the zero address");
838         _primary = recipient;
839         emit PrimaryTransferred(recipient);
840     }
841 }
842 
843 // File: @openzeppelin/contracts/crowdsale/distribution/PostDeliveryCappedCrowdsale.sol
844 
845 pragma solidity ^0.5.0;
846 
847 
848 
849 
850 
851 /**
852  * @title PostDeliveryCrowdsale
853  * @dev Crowdsale that locks tokens from withdrawal until it ends.
854  */
855 contract PostDeliveryCrowdsale is TimedCrowdsale {
856     using SafeMath for uint256;
857 
858     mapping(address => uint256) private _balances;
859     __unstable__TokenVault private _vault;
860 
861     constructor() public {
862         _vault = new __unstable__TokenVault();
863     }
864 
865     /**
866      * @dev Withdraw tokens only after crowdsale ends.
867      * @param beneficiary Whose tokens will be withdrawn.
868      */
869     function withdrawTokens(address beneficiary) public {
870         require(hasClosed(), "PostDeliveryCrowdsale: not closed");
871         uint256 amount = _balances[beneficiary];
872         require(amount > 0, "PostDeliveryCrowdsale: beneficiary is not due any tokens");
873 
874         _balances[beneficiary] = 0;
875         _vault.transfer(token(), beneficiary, amount);
876     }
877 
878     /**
879      * @return the balance of an account.
880      */
881     function balanceOf(address account) public view returns (uint256) {
882         return _balances[account];
883     }
884 
885     /**
886      * @dev Overrides parent by storing due balances, and delivering tokens to the vault instead of the end user. This
887      * ensures that the tokens will be available by the time they are withdrawn (which may not be the case if
888      * `_deliverTokens` was called later).
889      * @param beneficiary Token purchaser
890      * @param tokenAmount Amount of tokens purchased
891      */
892     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
893         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
894         _deliverTokens(address(_vault), tokenAmount);
895     }
896 }
897 
898 /**
899  * @title __unstable__TokenVault
900  * @dev Similar to an Escrow for tokens, this contract allows its primary account to spend its tokens as it sees fit.
901  * This contract is an internal helper for PostDeliveryCrowdsale, and should not be used outside of this context.
902  */
903 // solhint-disable-next-line contract-name-camelcase
904 contract __unstable__TokenVault is Secondary {
905     function transfer(IERC20 token, address to, uint256 amount) public onlyPrimary {
906         token.transfer(to, amount);
907     }
908 }
909 
910 // File: @openzeppelin/contracts/math/Math.sol
911 
912 pragma solidity ^0.5.0;
913 
914 /**
915  * @dev Standard math utilities missing in the Solidity language.
916  */
917 library Math {
918     /**
919      * @dev Returns the largest of two numbers.
920      */
921     function max(uint256 a, uint256 b) internal pure returns (uint256) {
922         return a >= b ? a : b;
923     }
924 
925     /**
926      * @dev Returns the smallest of two numbers.
927      */
928     function min(uint256 a, uint256 b) internal pure returns (uint256) {
929         return a < b ? a : b;
930     }
931 
932     /**
933      * @dev Returns the average of two numbers. The result is rounded towards
934      * zero.
935      */
936     function average(uint256 a, uint256 b) internal pure returns (uint256) {
937         // (a + b) / 2 can overflow, so we distribute
938         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
939     }
940 }
941 
942 // File: @openzeppelin/contracts/crowdsale/emission/AllowanceCrowdsale.sol
943 
944 pragma solidity ^0.5.0;
945 
946 
947 
948 
949 
950 
951 /**
952  * @title AllowanceCrowdsale
953  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
954  */
955 contract AllowanceCrowdsale is Crowdsale {
956     using SafeMath for uint256;
957     using SafeERC20 for IERC20;
958 
959     address private _tokenWallet;
960 
961     /**
962      * @dev Constructor, takes token wallet address.
963      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale.
964      */
965     constructor (address tokenWallet) public {
966         require(tokenWallet != address(0), "AllowanceCrowdsale: token wallet is the zero address");
967         _tokenWallet = tokenWallet;
968     }
969 
970     /**
971      * @return the address of the wallet that will hold the tokens.
972      */
973     function tokenWallet() public view returns (address) {
974         return _tokenWallet;
975     }
976 
977     /**
978      * @dev Checks the amount of tokens left in the allowance.
979      * @return Amount of tokens left in the allowance
980      */
981     function remainingTokens() public view returns (uint256) {
982         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
983     }
984 
985     /**
986      * @dev Overrides parent behavior by transferring tokens from wallet.
987      * @param beneficiary Token purchaser
988      * @param tokenAmount Amount of tokens purchased
989      */
990     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
991         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
992     }
993 }
994 
995 // File: @openzeppelin/contracts/crowdsale/validation/CappedCrowdsale.sol
996 
997 pragma solidity ^0.5.0;
998 
999 
1000 
1001 /**
1002  * @title CappedCrowdsale
1003  * @dev Crowdsale with a limit for total contributions.
1004  */
1005 contract CappedCrowdsale is Crowdsale {
1006     using SafeMath for uint256;
1007 
1008     uint256 private _cap;
1009 
1010     /**
1011      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
1012      * @param cap Max amount of wei to be contributed
1013      */
1014     constructor (uint256 cap) public {
1015         require(cap > 0, "CappedCrowdsale: cap is 0");
1016         _cap = cap;
1017     }
1018 
1019     /**
1020      * @return the cap of the crowdsale.
1021      */
1022     function cap() public view returns (uint256) {
1023         return _cap;
1024     }
1025 
1026     /**
1027      * @dev Checks whether the cap has been reached.
1028      * @return Whether the cap was reached
1029      */
1030     function capReached() public view returns (bool) {
1031         return weiRaised() >= _cap;
1032     }
1033 
1034     /**
1035      * @dev Extend parent behavior requiring purchase to respect the funding cap.
1036      * @param beneficiary Token purchaser
1037      * @param weiAmount Amount of wei contributed
1038      */
1039     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1040         super._preValidatePurchase(beneficiary, weiAmount);
1041         require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
1042     }
1043 }
1044 
1045 // File: contracts/crowdsale/WhitelistCrowdsale.sol
1046 
1047 pragma solidity ^0.5.0;
1048 
1049 
1050 // custom validation using the whitelister contract
1051 
1052 contract WhitelistCrowdsale is Crowdsale {
1053     address public whitelister;
1054 
1055     constructor(address _whitelister) public {
1056         whitelister = _whitelister;
1057     }
1058 
1059     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
1060         require(IWhitelister(whitelister).whitelisted(_beneficiary) == true, "WhitelistCrowdsale: beneficiary not whitelisted");
1061         super._preValidatePurchase(_beneficiary, _weiAmount);
1062     }
1063 
1064     function isWhitelisted(address _address) external view returns (bool) {
1065         return IWhitelister(whitelister).whitelisted(_address);
1066     }
1067 }
1068 
1069 interface IWhitelister {
1070     function whitelisted(address _address) external view returns (bool);
1071 }
1072 
1073 // File: @openzeppelin/contracts/access/Roles.sol
1074 
1075 pragma solidity ^0.5.0;
1076 
1077 /**
1078  * @title Roles
1079  * @dev Library for managing addresses assigned to a Role.
1080  */
1081 library Roles {
1082     struct Role {
1083         mapping (address => bool) bearer;
1084     }
1085 
1086     /**
1087      * @dev Give an account access to this role.
1088      */
1089     function add(Role storage role, address account) internal {
1090         require(!has(role, account), "Roles: account already has role");
1091         role.bearer[account] = true;
1092     }
1093 
1094     /**
1095      * @dev Remove an account's access to this role.
1096      */
1097     function remove(Role storage role, address account) internal {
1098         require(has(role, account), "Roles: account does not have role");
1099         role.bearer[account] = false;
1100     }
1101 
1102     /**
1103      * @dev Check if an account has this role.
1104      * @return bool
1105      */
1106     function has(Role storage role, address account) internal view returns (bool) {
1107         require(account != address(0), "Roles: account is the zero address");
1108         return role.bearer[account];
1109     }
1110 }
1111 
1112 // File: @openzeppelin/contracts/access/roles/CapperRole.sol
1113 
1114 pragma solidity ^0.5.0;
1115 
1116 
1117 
1118 contract CapperRole is Context {
1119     using Roles for Roles.Role;
1120 
1121     event CapperAdded(address indexed account);
1122     event CapperRemoved(address indexed account);
1123 
1124     Roles.Role private _cappers;
1125 
1126     constructor () internal {
1127         _addCapper(_msgSender());
1128     }
1129 
1130     modifier onlyCapper() {
1131         require(isCapper(_msgSender()), "CapperRole: caller does not have the Capper role");
1132         _;
1133     }
1134 
1135     function isCapper(address account) public view returns (bool) {
1136         return _cappers.has(account);
1137     }
1138 
1139     function addCapper(address account) public onlyCapper {
1140         _addCapper(account);
1141     }
1142 
1143     function renounceCapper() public {
1144         _removeCapper(_msgSender());
1145     }
1146 
1147     function _addCapper(address account) internal {
1148         _cappers.add(account);
1149         emit CapperAdded(account);
1150     }
1151 
1152     function _removeCapper(address account) internal {
1153         _cappers.remove(account);
1154         emit CapperRemoved(account);
1155     }
1156 }
1157 
1158 // File: contracts/crowdsale/IndividuallyCappedCrowdsale.sol
1159 
1160 pragma solidity ^0.5.0;
1161 
1162 
1163 
1164 
1165 // a single cap applied to all users
1166 
1167 /**
1168  * @title IndividuallyCappedCrowdsale
1169  * @dev Crowdsale with per-beneficiary caps.
1170  */
1171 contract IndividuallyCappedCrowdsale is Crowdsale {
1172     using SafeMath for uint256;
1173 
1174     mapping(address => uint256) private _contributions;
1175     // mapping(address => uint256) private _caps;
1176     uint256 public individualCap;
1177 
1178     constructor(uint256 _individualCap) public {
1179         individualCap = _individualCap;
1180     }
1181 
1182     /**
1183      * @dev Sets a specific beneficiary's maximum contribution.
1184      * @param beneficiary Address to be capped
1185      * @param cap Wei limit for individual contribution
1186      */
1187     // function setCap(address beneficiary, uint256 cap) external onlyCapper {
1188     //     _caps[beneficiary] = cap;
1189     // }
1190 
1191     /**
1192      * @dev Returns the cap of a specific beneficiary.
1193      * @param beneficiary Address whose cap is to be checked
1194      * @return Current cap for individual beneficiary
1195      */
1196     // function getCap(address beneficiary) public view returns (uint256) {
1197     // return _caps[beneficiary];
1198     // }
1199 
1200     /**
1201      * @dev Returns the amount contributed so far by a specific beneficiary.
1202      * @param beneficiary Address of contributor
1203      * @return Beneficiary contribution so far
1204      */
1205     function getContribution(address beneficiary) public view returns (uint256) {
1206         return _contributions[beneficiary];
1207     }
1208 
1209     /**
1210      * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
1211      * @param beneficiary Token purchaser
1212      * @param weiAmount Amount of wei contributed
1213      */
1214     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1215         super._preValidatePurchase(beneficiary, weiAmount);
1216         // solhint-disable-next-line max-line-length
1217         // require(_contributions[beneficiary].add(weiAmount) <= _caps[beneficiary], "IndividuallyCappedCrowdsale: beneficiary's cap exceeded");
1218         require(_contributions[beneficiary].add(weiAmount) <= individualCap, "IndividuallyCappedCrowdsale: beneficiary's cap exceeded");
1219     }
1220 
1221     /**
1222      * @dev Extend parent behavior to update beneficiary contributions.
1223      * @param beneficiary Token purchaser
1224      * @param weiAmount Amount of wei contributed
1225      */
1226     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
1227         super._updatePurchasingState(beneficiary, weiAmount);
1228         _contributions[beneficiary] = _contributions[beneficiary].add(weiAmount);
1229     }
1230 }
1231 
1232 // File: contracts/BistrooCrowdsale.sol
1233 
1234 pragma solidity ^0.5.17;
1235 
1236 
1237 
1238 
1239 
1240 
1241 
1242 
1243 contract BistrooCrowdsale is
1244 Crowdsale,
1245 AllowanceCrowdsale,
1246 WhitelistCrowdsale,
1247 CappedCrowdsale,
1248 TimedCrowdsale,
1249 PostDeliveryCrowdsale,
1250 IndividuallyCappedCrowdsale
1251 {
1252     uint256 private _rate = 7200;
1253     uint256 private _individualCap = 100e18;
1254     uint256 private _totalCap = 4166e18;
1255 
1256     constructor(
1257         address payable crowdsaleWallet,
1258         IERC20 token,
1259         address tokenWallet,
1260         uint256 openingTime,
1261         uint256 closingTime,
1262         address whitelister
1263     )
1264 
1265     WhitelistCrowdsale(whitelister)
1266     TimedCrowdsale(openingTime, closingTime)
1267     CappedCrowdsale(_totalCap)
1268     IndividuallyCappedCrowdsale(_individualCap)
1269     AllowanceCrowdsale(tokenWallet)
1270     Crowdsale(_rate, crowdsaleWallet, token)
1271 
1272     public
1273     {}
1274 }