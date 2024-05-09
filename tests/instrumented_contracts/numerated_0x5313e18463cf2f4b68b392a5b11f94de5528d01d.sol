1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity >=0.4.21 <0.7.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: openzeppelin-solidity/contracts/GSN/Context.sol
161 
162 
163 /*
164  * @dev Provides information about the current execution context, including the
165  * sender of the transaction and its data. While these are generally available
166  * via msg.sender and msg.data, they should not be accessed in such a direct
167  * manner, since when dealing with GSN meta-transactions the account sending and
168  * paying for execution may not be the actual sender (as far as an application
169  * is concerned).
170  *
171  * This contract is only required for intermediate, library-like contracts.
172  */
173 contract Context {
174     // Empty internal constructor, to prevent people from mistakenly deploying
175     // an instance of this contract, which should be used via inheritance.
176     constructor () internal { }
177     // solhint-disable-previous-line no-empty-blocks
178 
179     function _msgSender() internal view returns (address payable) {
180         return msg.sender;
181     }
182 
183     function _msgData() internal view returns (bytes memory) {
184         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
185         return msg.data;
186     }
187 }
188 
189 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
190 
191 
192 
193 /**
194  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
195  * the optional functions; to access them see {ERC20Detailed}.
196  */
197 interface IERC20 {
198     /**
199      * @dev Returns the amount of tokens in existence.
200      */
201     function totalSupply() external view returns (uint256);
202 
203     /**
204      * @dev Returns the amount of tokens owned by `account`.
205      */
206     function balanceOf(address account) external view returns (uint256);
207 
208     /**
209      * @dev Moves `amount` tokens from the caller's account to `recipient`.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transfer(address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Returns the remaining number of tokens that `spender` will be
219      * allowed to spend on behalf of `owner` through {transferFrom}. This is
220      * zero by default.
221      *
222      * This value changes when {approve} or {transferFrom} are called.
223      */
224     function allowance(address owner, address spender) external view returns (uint256);
225 
226     /**
227      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * IMPORTANT: Beware that changing an allowance with this method brings the risk
232      * that someone may use both the old and the new allowance by unfortunate
233      * transaction ordering. One possible solution to mitigate this race
234      * condition is to first reduce the spender's allowance to 0 and set the
235      * desired value afterwards:
236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      *
238      * Emits an {Approval} event.
239      */
240     function approve(address spender, uint256 amount) external returns (bool);
241     /**
242      * @dev Moves `amount` tokens from `sender` to `recipient` using the
243      * allowance mechanism. `amount` is then deducted from the caller's
244      * allowance.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a {Transfer} event.
249      */
250     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
251 
252     /**
253      * @dev Emitted when `value` tokens are moved from one account (`from`) to
254      * another (`to`).
255      *
256      * Note that `value` may be zero.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     /**
261      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
262      * a call to {approve}. `value` is the new allowance.
263      */
264     event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 
267 // File: openzeppelin-solidity/contracts/utils/Address.sol
268 
269 
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * This test is non-exhaustive, and there may be false-negatives: during the
279      * execution of a contract's constructor, its address will be reported as
280      * not containing a contract.
281      *
282      * IMPORTANT: It is unsafe to assume that an address for which this
283      * function returns false is an externally-owned account (EOA) and not a
284      * contract.
285      */
286     function isContract(address account) internal view returns (bool) {
287         // This method relies in extcodesize, which returns 0 for contracts in
288         // construction, since the code is only stored at the end of the
289         // constructor execution.
290 
291         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293         // for accounts without code, i.e. `keccak256('')`
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { codehash := extcodehash(account) }
298         return (codehash != 0x0 && codehash != accountHash);
299     }
300 
301     /**
302      * @dev Converts an `address` into `address payable`. Note that this is
303      * simply a type cast: the actual underlying value is not changed.
304      *
305      * _Available since v2.4.0._
306      */
307     function toPayable(address account) internal pure returns (address payable) {
308         return address(uint160(account));
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      *
327      * _Available since v2.4.0._
328      */
329     function sendValue(address payable recipient, uint256 amount) internal {
330         require(address(this).balance >= amount, "Address: insufficient balance");
331 
332         // solhint-disable-next-line avoid-call-value
333         (bool success, ) = recipient.call.value(amount)("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 }
337 
338 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
339 
340 
341 
342 
343 
344 
345 /**
346  * @title SafeERC20
347  * @dev Wrappers around ERC20 operations that throw on failure (when the token
348  * contract returns false). Tokens that return no value (and instead revert or
349  * throw on failure) are also supported, non-reverting calls are assumed to be
350  * successful.
351  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
352  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
353  */
354 library SafeERC20 {
355     using SafeMath for uint256;
356     using Address for address;
357 
358     function safeTransfer(IERC20 token, address to, uint256 value) internal {
359         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
360     }
361 
362     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
363         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
364     }
365 
366     function safeApprove(IERC20 token, address spender, uint256 value) internal {
367         // safeApprove should only be called when setting an initial allowance,
368         // or when resetting it to zero. To increase and decrease it, use
369         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
370         // solhint-disable-next-line max-line-length
371         require((value == 0) || (token.allowance(address(this), spender) == 0),
372             "SafeERC20: approve from non-zero to non-zero allowance"
373         );
374         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
375     }
376 
377     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
378         uint256 newAllowance = token.allowance(address(this), spender).add(value);
379         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
380     }
381 
382     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
383         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
384         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
385     }
386 
387     /**
388      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
389      * on the return value: the return value is optional (but if data is returned, it must not be false).
390      * @param token The token targeted by the call.
391      * @param data The call data (encoded using abi.encode or one of its variants).
392      */
393     function callOptionalReturn(IERC20 token, bytes memory data) private {
394         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
395         // we're implementing it ourselves.
396 
397         // A Solidity high level call has three parts:
398         //  1. The target address is checked to verify it contains contract code
399         //  2. The call itself is made, and success asserted
400         //  3. The return value is decoded, which in turn checks the size of the returned data.
401         // solhint-disable-next-line max-line-length
402         require(address(token).isContract(), "SafeERC20: call to non-contract");
403 
404         // solhint-disable-next-line avoid-low-level-calls
405         (bool success, bytes memory returndata) = address(token).call(data);
406         require(success, "SafeERC20: low-level call failed");
407 
408         if (returndata.length > 0) { // Return data is optional
409             // solhint-disable-next-line max-line-length
410             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
411         }
412     }
413 }
414 
415 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
416 
417 
418 
419 /**
420  * @dev Contract module that helps prevent reentrant calls to a function.
421  *
422  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
423  * available, which can be applied to functions to make sure there are no nested
424  * (reentrant) calls to them.
425  *
426  * Note that because there is a single `nonReentrant` guard, functions marked as
427  * `nonReentrant` may not call one another. This can be worked around by making
428  * those functions `private`, and then adding `external` `nonReentrant` entry
429  * points to them.
430  */
431 contract ReentrancyGuard {
432     // counter to allow mutex lock with only one SSTORE operation
433     uint256 private _guardCounter;
434 
435     constructor () internal {
436         // The counter starts at one to prevent changing it from zero to a non-zero
437         // value, which is a more expensive operation.
438         _guardCounter = 1;
439     }
440 
441     /**
442      * @dev Prevents a contract from calling itself, directly or indirectly.
443      * Calling a `nonReentrant` function from another `nonReentrant`
444      * function is not supported. It is possible to prevent this from happening
445      * by making the `nonReentrant` function external, and make it call a
446      * `private` function that does the actual work.
447      */
448     modifier nonReentrant() {
449         _guardCounter += 1;
450         uint256 localCounter = _guardCounter;
451         _;
452         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
453     }
454 }
455 
456 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
457 
458 
459 
460 
461 
462 
463 
464 
465 /**
466  * @title Crowdsale
467  * @dev Crowdsale is a base contract for managing a token crowdsale,
468  * allowing investors to purchase tokens with ether. This contract implements
469  * such functionality in its most fundamental form and can be extended to provide additional
470  * functionality and/or custom behavior.
471  * The external interface represents the basic interface for purchasing tokens, and conforms
472  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
473  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
474  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
475  * behavior.
476  */
477 contract Crowdsale is Context, ReentrancyGuard {
478     using SafeMath for uint256;
479     using SafeERC20 for IERC20;
480 
481     // The token being sold
482     IERC20 private _token;
483 
484     // Address where funds are collected
485     address payable private _wallet;
486 
487     // How many token units a buyer gets per wei.
488     // The rate is the conversion between wei and the smallest and indivisible token unit.
489     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
490     // 1 wei will give you 1 unit, or 0.001 TOK.
491     uint256 private _rate;
492 
493     // Amount of wei raised
494     uint256 private _weiRaised;
495 
496     /**
497      * Event for token purchase logging
498      * @param purchaser who paid for the tokens
499      * @param beneficiary who got the tokens
500      * @param value weis paid for purchase
501      * @param amount amount of tokens purchased
502      */
503     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
504 
505     /**
506      * @param rate Number of token units a buyer gets per wei
507      * @dev The rate is the conversion between wei and the smallest and indivisible
508      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
509      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
510      * @param wallet Address where collected funds will be forwarded to
511      * @param token Address of the token being sold
512      */
513     constructor (uint256 rate, address payable wallet, IERC20 token) public {
514         require(rate > 0, "Crowdsale: rate is 0");
515         require(wallet != address(0), "Crowdsale: wallet is the zero address");
516         require(address(token) != address(0), "Crowdsale: token is the zero address");
517 
518         _rate = rate;
519         _wallet = wallet;
520         _token = token;
521     }
522 
523     /**
524      * @dev fallback function ***DO NOT OVERRIDE***
525      * Note that other contracts will transfer funds with a base gas stipend
526      * of 2300, which is not enough to call buyTokens. Consider calling
527      * buyTokens directly when purchasing tokens from a contract.
528      */
529     function () external payable {
530         buyTokens(_msgSender());
531     }
532 
533     /**
534      * @return the token being sold.
535      */
536     function token() public view returns (IERC20) {
537         return _token;
538     }
539 
540     /**
541      * @return the address where funds are collected.
542      */
543     function wallet() public view returns (address payable) {
544         return _wallet;
545     }
546 
547     /**
548      * @return the number of token units a buyer gets per wei.
549      */
550     function rate() public view returns (uint256) {
551         return _rate;
552     }
553 
554     /**
555      * @return the amount of wei raised.
556      */
557     function weiRaised() public view returns (uint256) {
558         return _weiRaised;
559     }
560 
561     /**
562      * @dev low level token purchase ***DO NOT OVERRIDE***
563      * This function has a non-reentrancy guard, so it shouldn't be called by
564      * another `nonReentrant` function.
565      * @param beneficiary Recipient of the token purchase
566      */
567     function buyTokens(address beneficiary) public nonReentrant payable {
568         uint256 weiAmount = msg.value;
569         _preValidatePurchase(beneficiary, weiAmount);
570 
571         // calculate token amount to be created
572         uint256 tokens = _getTokenAmount(weiAmount);
573 
574         // update state
575         _weiRaised = _weiRaised.add(weiAmount);
576 
577         _processPurchase(beneficiary, tokens);
578         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
579 
580         _updatePurchasingState(beneficiary, weiAmount);
581 
582         _forwardFunds();
583         _postValidatePurchase(beneficiary, weiAmount);
584     }
585 
586     /**
587      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
588      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
589      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
590      *     super._preValidatePurchase(beneficiary, weiAmount);
591      *     require(weiRaised().add(weiAmount) <= cap);
592      * @param beneficiary Address performing the token purchase
593      * @param weiAmount Value in wei involved in the purchase
594      */
595     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
596         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
597         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
598         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
599     }
600 
601     /**
602      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
603      * conditions are not met.
604      * @param beneficiary Address performing the token purchase
605      * @param weiAmount Value in wei involved in the purchase
606      */
607     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
608         // solhint-disable-previous-line no-empty-blocks
609     }
610 
611     /**
612      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
613      * its tokens.
614      * @param beneficiary Address performing the token purchase
615      * @param tokenAmount Number of tokens to be emitted
616      */
617     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
618         _token.safeTransfer(beneficiary, tokenAmount);
619     }
620 
621     /**
622      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
623      * tokens.
624      * @param beneficiary Address receiving the tokens
625      * @param tokenAmount Number of tokens to be purchased
626      */
627     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
628         _deliverTokens(beneficiary, tokenAmount);
629     }
630 
631     /**
632      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
633      * etc.)
634      * @param beneficiary Address receiving the tokens
635      * @param weiAmount Value in wei involved in the purchase
636      */
637     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
638         // solhint-disable-previous-line no-empty-blocks
639     }
640 
641     /**
642      * @dev Override to extend the way in which ether is converted to tokens.
643      * @param weiAmount Value in wei to be converted into tokens
644      * @return Number of tokens that can be purchased with the specified _weiAmount
645      */
646     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
647         return weiAmount.mul(_rate);
648     }
649 
650     /**
651      * @dev Determines how ETH is stored/forwarded on purchases.
652      */
653     function _forwardFunds() internal {
654         _wallet.transfer(msg.value);
655     }
656 }
657 
658 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
659 
660 
661 
662 
663 
664 /**
665  * @title CappedCrowdsale
666  * @dev Crowdsale with a limit for total contributions.
667  */
668 contract CappedCrowdsale is Crowdsale {
669     using SafeMath for uint256;
670 
671     uint256 private _cap;
672 
673     /**
674      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
675      * @param cap Max amount of wei to be contributed
676      */
677     constructor (uint256 cap) public {
678         require(cap > 0, "CappedCrowdsale: cap is 0");
679         _cap = cap;
680     }
681 
682     /**
683      * @return the cap of the crowdsale.
684      */
685     function cap() public view returns (uint256) {
686         return _cap;
687     }
688 
689     /**
690      * @dev Checks whether the cap has been reached.
691      * @return Whether the cap was reached
692      */
693     function capReached() public view returns (bool) {
694         return weiRaised() >= _cap;
695     }
696 
697     /**
698      * @dev Extend parent behavior requiring purchase to respect the funding cap.
699      * @param beneficiary Token purchaser
700      * @param weiAmount Amount of wei contributed
701      */
702     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
703         super._preValidatePurchase(beneficiary, weiAmount);
704         require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
705     }
706 }
707 
708 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
709 
710 
711 
712 
713 
714 /**
715  * @title TimedCrowdsale
716  * @dev Crowdsale accepting contributions only within a time frame.
717  */
718 contract TimedCrowdsale is Crowdsale {
719     using SafeMath for uint256;
720 
721     uint256 private _openingTime;
722     uint256 private _closingTime;
723 
724     /**
725      * Event for crowdsale extending
726      * @param newClosingTime new closing time
727      * @param prevClosingTime old closing time
728      */
729     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
730 
731     /**
732      * @dev Reverts if not in crowdsale time range.
733      */
734     modifier onlyWhileOpen {
735         require(isOpen(), "TimedCrowdsale: not open");
736         _;
737     }
738 
739     /**
740      * @dev Constructor, takes crowdsale opening and closing times.
741      * @param openingTime Crowdsale opening time
742      * @param closingTime Crowdsale closing time
743      */
744     constructor (uint256 openingTime, uint256 closingTime) public {
745         // solhint-disable-next-line not-rely-on-time
746         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
747         // solhint-disable-next-line max-line-length
748         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
749 
750         _openingTime = openingTime;
751         _closingTime = closingTime;
752     }
753 
754     /**
755      * @return the crowdsale opening time.
756      */
757     function openingTime() public view returns (uint256) {
758         return _openingTime;
759     }
760 
761     /**
762      * @return the crowdsale closing time.
763      */
764     function closingTime() public view returns (uint256) {
765         return _closingTime;
766     }
767 
768     /**
769      * @return true if the crowdsale is open, false otherwise.
770      */
771     function isOpen() public view returns (bool) {
772         // solhint-disable-next-line not-rely-on-time
773         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
774     }
775 
776     /**
777      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
778      * @return Whether crowdsale period has elapsed
779      */
780     function hasClosed() public view returns (bool) {
781         // solhint-disable-next-line not-rely-on-time
782         return block.timestamp > _closingTime;
783     }
784 
785     /**
786      * @dev Extend parent behavior requiring to be within contributing period.
787      * @param beneficiary Token purchaser
788      * @param weiAmount Amount of wei contributed
789      */
790     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
791         super._preValidatePurchase(beneficiary, weiAmount);
792     }
793 
794     /**
795      * @dev Extend crowdsale.
796      * @param newClosingTime Crowdsale closing time
797      */
798     function _extendTime(uint256 newClosingTime) internal {
799         require(!hasClosed(), "TimedCrowdsale: already closed");
800         // solhint-disable-next-line max-line-length
801         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
802 
803         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
804         _closingTime = newClosingTime;
805     }
806 }
807 
808 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
809 
810 
811 
812 
813 
814 /**
815  * @title FinalizableCrowdsale
816  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
817  * can do extra work after finishing.
818  */
819 contract FinalizableCrowdsale is TimedCrowdsale {
820     using SafeMath for uint256;
821 
822     bool private _finalized;
823 
824     event CrowdsaleFinalized();
825 
826     constructor () internal {
827         _finalized = false;
828     }
829 
830     /**
831      * @return true if the crowdsale is finalized, false otherwise.
832      */
833     function finalized() public view returns (bool) {
834         return _finalized;
835     }
836 
837     /**
838      * @dev Must be called after crowdsale ends, to do some extra finalization
839      * work. Calls the contract's finalization function.
840      */
841     function finalize() public {
842         require(!_finalized, "FinalizableCrowdsale: already finalized");
843         require(hasClosed(), "FinalizableCrowdsale: not closed");
844 
845         _finalized = true;
846 
847         _finalization();
848         emit CrowdsaleFinalized();
849     }
850 
851     /**
852      * @dev Can be overridden to add finalization logic. The overriding function
853      * should call super._finalization() to ensure the chain of finalization is
854      * executed entirely.
855      */
856     function _finalization() internal {
857         // solhint-disable-previous-line no-empty-blocks
858     }
859 }
860 
861 // File: openzeppelin-solidity/contracts/ownership/Secondary.sol
862 
863 
864 
865 /**
866  * @dev A Secondary contract can only be used by its primary account (the one that created it).
867  */
868 contract Secondary is Context {
869     address private _primary;
870 
871     /**
872      * @dev Emitted when the primary contract changes.
873      */
874     event PrimaryTransferred(
875         address recipient
876     );
877 
878     /**
879      * @dev Sets the primary account to the one that is creating the Secondary contract.
880      */
881     constructor () internal {
882         _primary = _msgSender();
883         emit PrimaryTransferred(_primary);
884     }
885 
886     /**
887      * @dev Reverts if called from any account other than the primary.
888      */
889     modifier onlyPrimary() {
890         require(_msgSender() == _primary, "Secondary: caller is not the primary account");
891         _;
892     }
893 
894     /**
895      * @return the address of the primary.
896      */
897     function primary() public view returns (address) {
898         return _primary;
899     }
900 
901     /**
902      * @dev Transfers contract to a new primary.
903      * @param recipient The address of new primary.
904      */
905     function transferPrimary(address recipient) public onlyPrimary {
906         require(recipient != address(0), "Secondary: new primary is the zero address");
907         _primary = recipient;
908         emit PrimaryTransferred(_primary);
909     }
910 }
911 
912 // File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
913 
914 
915 
916 
917 
918 
919  /**
920   * @title Escrow
921   * @dev Base escrow contract, holds funds designated for a payee until they
922   * withdraw them.
923   *
924   * Intended usage: This contract (and derived escrow contracts) should be a
925   * standalone contract, that only interacts with the contract that instantiated
926   * it. That way, it is guaranteed that all Ether will be handled according to
927   * the `Escrow` rules, and there is no need to check for payable functions or
928   * transfers in the inheritance tree. The contract that uses the escrow as its
929   * payment method should be its primary, and provide public methods redirecting
930   * to the escrow's deposit and withdraw.
931   */
932 contract Escrow is Secondary {
933     using SafeMath for uint256;
934     using Address for address payable;
935 
936     event Deposited(address indexed payee, uint256 weiAmount);
937     event Withdrawn(address indexed payee, uint256 weiAmount);
938 
939     mapping(address => uint256) private _deposits;
940 
941     function depositsOf(address payee) public view returns (uint256) {
942         return _deposits[payee];
943     }
944 
945     /**
946      * @dev Stores the sent amount as credit to be withdrawn.
947      * @param payee The destination address of the funds.
948      */
949     function deposit(address payee) public onlyPrimary payable {
950         uint256 amount = msg.value;
951         _deposits[payee] = _deposits[payee].add(amount);
952 
953         emit Deposited(payee, amount);
954     }
955 
956     /**
957      * @dev Withdraw accumulated balance for a payee, forwarding 2300 gas (a
958      * Solidity `transfer`).
959      *
960      * NOTE: This function has been deprecated, use {withdrawWithGas} instead.
961      * Calling contracts with fixed-gas limits is an anti-pattern and may break
962      * contract interactions in network upgrades (hardforks).
963      * https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more.]
964      *
965      * @param payee The address whose funds will be withdrawn and transferred to.
966      */
967     function withdraw(address payable payee) public onlyPrimary {
968         uint256 payment = _deposits[payee];
969 
970         _deposits[payee] = 0;
971 
972         payee.transfer(payment);
973 
974         emit Withdrawn(payee, payment);
975     }
976 
977     /**
978      * @dev Same as {withdraw}, but forwarding all gas to the recipient.
979      *
980      * WARNING: Forwarding all gas opens the door to reentrancy vulnerabilities.
981      * Make sure you trust the recipient, or are either following the
982      * checks-effects-interactions pattern or using {ReentrancyGuard}.
983      *
984      * _Available since v2.4.0._
985      */
986     function withdrawWithGas(address payable payee) public onlyPrimary {
987         uint256 payment = _deposits[payee];
988 
989         _deposits[payee] = 0;
990 
991         payee.sendValue(payment);
992 
993         emit Withdrawn(payee, payment);
994     }
995 }
996 
997 // File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
998 
999 
1000 
1001 
1002 /**
1003  * @title ConditionalEscrow
1004  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
1005  * @dev Intended usage: See {Escrow}. Same usage guidelines apply here.
1006  */
1007 contract ConditionalEscrow is Escrow {
1008     /**
1009      * @dev Returns whether an address is allowed to withdraw their funds. To be
1010      * implemented by derived contracts.
1011      * @param payee The destination address of the funds.
1012      */
1013     function withdrawalAllowed(address payee) public view returns (bool);
1014 
1015     function withdraw(address payable payee) public {
1016         require(withdrawalAllowed(payee), "ConditionalEscrow: payee is not allowed to withdraw");
1017         super.withdraw(payee);
1018     }
1019 }
1020 
1021 // File: openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol
1022 
1023 
1024 
1025 
1026 /**
1027  * @title RefundEscrow
1028  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
1029  * parties.
1030  * @dev Intended usage: See {Escrow}. Same usage guidelines apply here.
1031  * @dev The primary account (that is, the contract that instantiates this
1032  * contract) may deposit, close the deposit period, and allow for either
1033  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
1034  * with `RefundEscrow` will be made through the primary contract. See the
1035  * `RefundableCrowdsale` contract for an example of `RefundEscrow`’s use.
1036  */
1037 contract RefundEscrow is ConditionalEscrow {
1038     enum State { Active, Refunding, Closed }
1039 
1040     event RefundsClosed();
1041     event RefundsEnabled();
1042 
1043     State private _state;
1044     address payable private _beneficiary;
1045 
1046     /**
1047      * @dev Constructor.
1048      * @param beneficiary The beneficiary of the deposits.
1049      */
1050     constructor (address payable beneficiary) public {
1051         require(beneficiary != address(0), "RefundEscrow: beneficiary is the zero address");
1052         _beneficiary = beneficiary;
1053         _state = State.Active;
1054     }
1055 
1056     /**
1057      * @return The current state of the escrow.
1058      */
1059     function state() public view returns (State) {
1060         return _state;
1061     }
1062 
1063     /**
1064      * @return The beneficiary of the escrow.
1065      */
1066     function beneficiary() public view returns (address) {
1067         return _beneficiary;
1068     }
1069 
1070     /**
1071      * @dev Stores funds that may later be refunded.
1072      * @param refundee The address funds will be sent to if a refund occurs.
1073      */
1074     function deposit(address refundee) public payable {
1075         require(_state == State.Active, "RefundEscrow: can only deposit while active");
1076         super.deposit(refundee);
1077     }
1078 
1079     /**
1080      * @dev Allows for the beneficiary to withdraw their funds, rejecting
1081      * further deposits.
1082      */
1083     function close() public onlyPrimary {
1084         require(_state == State.Active, "RefundEscrow: can only close while active");
1085         _state = State.Closed;
1086         emit RefundsClosed();
1087     }
1088 
1089     /**
1090      * @dev Allows for refunds to take place, rejecting further deposits.
1091      */
1092     function enableRefunds() public onlyPrimary {
1093         require(_state == State.Active, "RefundEscrow: can only enable refunds while active");
1094         _state = State.Refunding;
1095         emit RefundsEnabled();
1096     }
1097 
1098     /**
1099      * @dev Withdraws the beneficiary's funds.
1100      */
1101     function beneficiaryWithdraw() public {
1102         require(_state == State.Closed, "RefundEscrow: beneficiary can only withdraw while closed");
1103         _beneficiary.transfer(address(this).balance);
1104     }
1105 
1106     /**
1107      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
1108      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
1109      */
1110     function withdrawalAllowed(address) public view returns (bool) {
1111         return _state == State.Refunding;
1112     }
1113 }
1114 
1115 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
1116 
1117 
1118 
1119 
1120 
1121 
1122 
1123 /**
1124  * @title RefundableCrowdsale
1125  * @dev Extension of `FinalizableCrowdsale` contract that adds a funding goal, and the possibility of users
1126  * getting a refund if goal is not met.
1127  *
1128  * Deprecated, use `RefundablePostDeliveryCrowdsale` instead. Note that if you allow tokens to be traded before the goal
1129  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
1130  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
1131  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
1132  */
1133 contract RefundableCrowdsale is Context, FinalizableCrowdsale {
1134     using SafeMath for uint256;
1135 
1136     // minimum amount of funds to be raised in weis
1137     uint256 private _goal;
1138 
1139     // refund escrow used to hold funds while crowdsale is running
1140     RefundEscrow private _escrow;
1141 
1142     /**
1143      * @dev Constructor, creates RefundEscrow.
1144      * @param goal Funding goal
1145      */
1146     constructor (uint256 goal) public {
1147         require(goal > 0, "RefundableCrowdsale: goal is 0");
1148         _escrow = new RefundEscrow(wallet());
1149         _goal = goal;
1150     }
1151 
1152     /**
1153      * @return minimum amount of funds to be raised in wei.
1154      */
1155     function goal() public view returns (uint256) {
1156         return _goal;
1157     }
1158 
1159     /**
1160      * @dev Investors can claim refunds here if crowdsale is unsuccessful.
1161      * @param refundee Whose refund will be claimed.
1162      */
1163     function claimRefund(address payable refundee) public {
1164         require(finalized(), "RefundableCrowdsale: not finalized");
1165         require(!goalReached(), "RefundableCrowdsale: goal reached");
1166 
1167         _escrow.withdraw(refundee);
1168     }
1169 
1170     /**
1171      * @dev Checks whether funding goal was reached.
1172      * @return Whether funding goal was reached
1173      */
1174     function goalReached() public view returns (bool) {
1175         return weiRaised() >= _goal;
1176     }
1177 
1178     /**
1179      * @dev Escrow finalization task, called when finalize() is called.
1180      */
1181     function _finalization() internal {
1182         if (goalReached()) {
1183             _escrow.close();
1184             _escrow.beneficiaryWithdraw();
1185         } else {
1186             _escrow.enableRefunds();
1187         }
1188 
1189         super._finalization();
1190     }
1191 
1192     /**
1193      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1194      */
1195     function _forwardFunds() internal {
1196         _escrow.deposit.value(msg.value)(_msgSender());
1197     }
1198 }
1199 
1200 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
1201 
1202 
1203 
1204 
1205 
1206 
1207 /**
1208  * @dev Implementation of the {IERC20} interface.
1209  *
1210  * This implementation is agnostic to the way tokens are created. This means
1211  * that a supply mechanism has to be added in a derived contract using {_mint}.
1212  * For a generic mechanism see {ERC20Mintable}.
1213  *
1214  * TIP: For a detailed writeup see our guide
1215  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1216  * to implement supply mechanisms].
1217  *
1218  * We have followed general OpenZeppelin guidelines: functions revert instead
1219  * of returning `false` on failure. This behavior is nonetheless conventional
1220  * and does not conflict with the expectations of ERC20 applications.
1221  *
1222  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1223  * This allows applications to reconstruct the allowance for all accounts just
1224  * by listening to said events. Other implementations of the EIP may not emit
1225  * these events, as it isn't required by the specification.
1226  *
1227  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1228  * functions have been added to mitigate the well-known issues around setting
1229  * allowances. See {IERC20-approve}.
1230  */
1231 contract ERC20 is Context, IERC20 {
1232     using SafeMath for uint256;
1233 
1234     mapping (address => uint256) private _balances;
1235 
1236     mapping (address => mapping (address => uint256)) private _allowances;
1237 
1238     uint256 private _totalSupply;
1239 
1240     /**
1241      * @dev See {IERC20-totalSupply}.
1242      */
1243     function totalSupply() public view returns (uint256) {
1244         return _totalSupply;
1245     }
1246 
1247     /**
1248      * @dev See {IERC20-balanceOf}.
1249      */
1250     function balanceOf(address account) public view returns (uint256) {
1251         return _balances[account];
1252     }
1253 
1254     /**
1255      * @dev See {IERC20-transfer}.
1256      *
1257      * Requirements:
1258      *
1259      * - `recipient` cannot be the zero address.
1260      * - the caller must have a balance of at least `amount`.
1261      */
1262     function transfer(address recipient, uint256 amount) public returns (bool) {
1263         _transfer(_msgSender(), recipient, amount);
1264         return true;
1265     }
1266 
1267     /**
1268      * @dev See {IERC20-allowance}.
1269      */
1270     function allowance(address owner, address spender) public view returns (uint256) {
1271         return _allowances[owner][spender];
1272     }
1273     
1274 
1275     /**
1276      * @dev See {IERC20-approve}.
1277      *
1278      * Requirements:
1279      *
1280      * - `spender` cannot be the zero address.
1281      */
1282     function approve(address spender, uint256 amount) public returns (bool) {
1283         _approve(_msgSender(), spender, amount);
1284         return true;
1285     }
1286 
1287     /**
1288      * @dev See {IERC20-transferFrom}.
1289      *
1290      * Emits an {Approval} event indicating the updated allowance. This is not
1291      * required by the EIP. See the note at the beginning of {ERC20};
1292      *
1293      * Requirements:
1294      * - `sender` and `recipient` cannot be the zero address.
1295      * - `sender` must have a balance of at least `amount`.
1296      * - the caller must have allowance for `sender`'s tokens of at least
1297      * `amount`.
1298      */
1299     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1300         _transfer(sender, recipient, amount);
1301         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1302         return true;
1303     }
1304 
1305     /**
1306      * @dev Atomically increases the allowance granted to `spender` by the caller.
1307      *
1308      * This is an alternative to {approve} that can be used as a mitigation for
1309      * problems described in {IERC20-approve}.
1310      *
1311      * Emits an {Approval} event indicating the updated allowance.
1312      *
1313      * Requirements:
1314      *
1315      * - `spender` cannot be the zero address.
1316      */
1317     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1318         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1319         return true;
1320     }
1321 
1322     /**
1323      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1324      *
1325      * This is an alternative to {approve} that can be used as a mitigation for
1326      * problems described in {IERC20-approve}.
1327      *
1328      * Emits an {Approval} event indicating the updated allowance.
1329      *
1330      * Requirements:
1331      *
1332      * - `spender` cannot be the zero address.
1333      * - `spender` must have allowance for the caller of at least
1334      * `subtractedValue`.
1335      */
1336     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1337         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1338         return true;
1339     }
1340 
1341     /**
1342      * @dev Moves tokens `amount` from `sender` to `recipient`.
1343      *
1344      * This is internal function is equivalent to {transfer}, and can be used to
1345      * e.g. implement automatic token fees, slashing mechanisms, etc.
1346      *
1347      * Emits a {Transfer} event.
1348      *
1349      * Requirements:
1350      *
1351      * - `sender` cannot be the zero address.
1352      * - `recipient` cannot be the zero address.
1353      * - `sender` must have a balance of at least `amount`.
1354      */
1355     function _transfer(address sender, address recipient, uint256 amount) internal {
1356         require(sender != address(0), "ERC20: transfer from the zero address");
1357         require(recipient != address(0), "ERC20: transfer to the zero address");
1358 
1359         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1360         _balances[recipient] = _balances[recipient].add(amount);
1361         emit Transfer(sender, recipient, amount);
1362     }
1363 
1364     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1365      * the total supply.
1366      *
1367      * Emits a {Transfer} event with `from` set to the zero address.
1368      *
1369      * Requirements
1370      *
1371      * - `to` cannot be the zero address.
1372      */
1373     function _mint(address account, uint256 amount) internal {
1374         require(account != address(0), "ERC20: mint to the zero address");
1375 
1376         _totalSupply = _totalSupply.add(amount);
1377         _balances[account] = _balances[account].add(amount);
1378         emit Transfer(address(0), account, amount);
1379     }
1380 
1381      /**
1382      * @dev Destroys `amount` tokens from `account`, reducing the
1383      * total supply.
1384      *
1385      * Emits a {Transfer} event with `to` set to the zero address.
1386      *
1387      * Requirements
1388      *
1389      * - `account` cannot be the zero address.
1390      * - `account` must have at least `amount` tokens.
1391      */
1392     function _burn(address account, uint256 amount) internal {
1393         require(account != address(0), "ERC20: burn from the zero address");
1394 
1395         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1396         _totalSupply = _totalSupply.sub(amount);
1397         emit Transfer(account, address(0), amount);
1398     }
1399 
1400     /**
1401      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1402      *
1403      * This is internal function is equivalent to `approve`, and can be used to
1404      * e.g. set automatic allowances for certain subsystems, etc.
1405      *
1406      * Emits an {Approval} event.
1407      *
1408      * Requirements:
1409      *
1410      * - `owner` cannot be the zero address.
1411      * - `spender` cannot be the zero address.
1412      */
1413     function _approve(address owner, address spender, uint256 amount) internal {
1414         require(owner != address(0), "ERC20: approve from the zero address");
1415         require(spender != address(0), "ERC20: approve to the zero address");
1416 
1417         _allowances[owner][spender] = amount;
1418         emit Approval(owner, spender, amount);
1419     }
1420 
1421     /**
1422      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
1423      * from the caller's allowance.
1424      *
1425      * See {_burn} and {_approve}.
1426      */
1427     function _burnFrom(address account, uint256 amount) internal {
1428         _burn(account, amount);
1429         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
1430     }
1431 }
1432 
1433 // File: openzeppelin-solidity/contracts/access/Roles.sol
1434 
1435 
1436 
1437 /**
1438  * @title Roles
1439  * @dev Library for managing addresses assigned to a Role.
1440  */
1441 library Roles {
1442     struct Role {
1443         mapping (address => bool) bearer;
1444     }
1445 
1446     /**
1447      * @dev Give an account access to this role.
1448      */
1449     function add(Role storage role, address account) internal {
1450         require(!has(role, account), "Roles: account already has role");
1451         role.bearer[account] = true;
1452     }
1453 
1454     /**
1455      * @dev Remove an account's access to this role.
1456      */
1457     function remove(Role storage role, address account) internal {
1458         require(has(role, account), "Roles: account does not have role");
1459         role.bearer[account] = false;
1460     }
1461 
1462     /**
1463      * @dev Check if an account has this role.
1464      * @return bool
1465      */
1466     function has(Role storage role, address account) internal view returns (bool) {
1467         require(account != address(0), "Roles: account is the zero address");
1468         return role.bearer[account];
1469     }
1470 }
1471 
1472 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1473 
1474 
1475 
1476 
1477 
1478 contract MinterRole is Context {
1479     using Roles for Roles.Role;
1480 
1481     event MinterAdded(address indexed account);
1482     event MinterRemoved(address indexed account);
1483 
1484     Roles.Role private _minters;
1485 
1486     constructor () internal {
1487         _addMinter(_msgSender());
1488     }
1489 
1490     modifier onlyMinter() {
1491         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1492         _;
1493     }
1494 
1495     function isMinter(address account) public view returns (bool) {
1496         return _minters.has(account);
1497     }
1498 
1499     function addMinter(address account) public onlyMinter {
1500         _addMinter(account);
1501     }
1502 
1503     function renounceMinter() public {
1504         _removeMinter(_msgSender());
1505     }
1506 
1507     function _addMinter(address account) internal {
1508         _minters.add(account);
1509         emit MinterAdded(account);
1510     }
1511 
1512     function _removeMinter(address account) internal {
1513         _minters.remove(account);
1514         emit MinterRemoved(account);
1515     }
1516 }
1517 
1518 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
1519 
1520 
1521 
1522 
1523 
1524 /**
1525  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1526  * which have permission to mint (create) new tokens as they see fit.
1527  *
1528  * At construction, the deployer of the contract is the only minter.
1529  */
1530 contract ERC20Mintable is ERC20, MinterRole {
1531     /**
1532      * @dev See {ERC20-_mint}.
1533      *
1534      * Requirements:
1535      *
1536      * - the caller must have the {MinterRole}.
1537      */
1538      
1539     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1540         _mint(account, amount);
1541         return true;
1542     }
1543 }
1544 
1545 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
1546 
1547 
1548 
1549 
1550 
1551 /**
1552  * @title MintedCrowdsale
1553  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1554  * Token ownership should be transferred to MintedCrowdsale for minting.
1555  */
1556 contract MintedCrowdsale is Crowdsale {
1557     /**
1558      * @dev Overrides delivery by minting tokens upon purchase.
1559      * @param beneficiary Token purchaser
1560      * @param tokenAmount Number of tokens to be minted
1561      */
1562     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
1563         // Potentially dangerous assumption about the type of the token.
1564         require(
1565             ERC20Mintable(address(token())).mint(beneficiary, tokenAmount),
1566                 "MintedCrowdsale: minting failed"
1567         );
1568     }
1569 }
1570 
1571 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1572 
1573 
1574 
1575 
1576 /**
1577  * @dev Optional functions from the ERC20 standard.
1578  */
1579 contract ERC20Detailed is IERC20 {
1580     string private _name;
1581     string private _symbol;
1582     uint8 private _decimals;
1583 
1584     /**
1585      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1586      * these values are immutable: they can only be set once during
1587      * construction.
1588      */
1589     constructor (string memory name, string memory symbol, uint8 decimals) public {
1590         _name = name;
1591         _symbol = symbol;
1592         _decimals = decimals;
1593     }
1594 
1595     /**
1596      * @dev Returns the name of the token.
1597      */
1598     function name() public view returns (string memory) {
1599         return _name;
1600     }
1601 
1602     /**
1603      * @dev Returns the symbol of the token, usually a shorter version of the
1604      * name.
1605      */
1606     function symbol() public view returns (string memory) {
1607         return _symbol;
1608     }
1609 
1610     /**
1611      * @dev Returns the number of decimals used to get its user representation.
1612      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1613      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1614      *
1615      * Tokens usually opt for a value of 18, imitating the relationship between
1616      * Ether and Wei.
1617      *
1618      * NOTE: This information is only used for _display_ purposes: it in
1619      * no way affects any of the arithmetic of the contract, including
1620      * {IERC20-balanceOf} and {IERC20-transfer}.
1621      */
1622     function decimals() public view returns (uint8) {
1623         return _decimals;
1624     }
1625 }
1626 
1627 // File: contracts/CovidToken.sol
1628 
1629 // solium-disable linebreak-style
1630 pragma solidity >=0.4.21 <0.7.0;
1631 
1632 
1633 
1634 
1635 
1636 
1637 /**
1638  * @title SampleCrowdsaleToken
1639  * @dev Very simple ERC20 Token that can be minted.
1640  * It is meant to be used in a crowdsale contract.
1641  */
1642 contract ulluToken is ERC20Mintable, ERC20Detailed {
1643     
1644     constructor( string memory _name, string memory _symbol, uint8 _decimals) 
1645         ERC20Detailed(_name, _symbol, _decimals)
1646         public
1647     {
1648 
1649     
1650 }
1651 
1652 
1653 }
1654 
1655 /**
1656  * @title SampleCrowdsale
1657  * @dev This is an example of a fully fledged crowdsale.
1658  * The way to add new features to a base crowdsale is by multiple inheritance.
1659  * In this example we are providing following extensions:
1660  * CappedCrowdsale - sets a max boundary for raised funds
1661  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
1662  * MintedCrowdsale - assumes the token can be minted by the crowdsale, which does so
1663  * when receiving purchases.
1664  *
1665  * After adding multiple features it's good practice to run integration tests
1666  * to ensure that subcontracts works together as intended.
1667  */