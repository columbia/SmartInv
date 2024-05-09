1 // File: ReentrancyGuard.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  *
21  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
22  * metering changes introduced in the Istanbul hardfork.
23  */
24 contract ReentrancyGuard {
25     bool private _notEntered;
26 
27     constructor () internal {
28         // Storing an initial non-zero value makes deployment a bit more
29         // expensive, but in exchange the refund on every call to nonReentrant
30         // will be lower in amount. Since refunds are capped to a percetange of
31         // the total transaction's gas, it is best to keep them low in cases
32         // like this one, to increase the likelihood of the full refund coming
33         // into effect.
34         _notEntered = true;
35     }
36 
37     /**
38      * @dev Prevents a contract from calling itself, directly or indirectly.
39      * Calling a `nonReentrant` function from another `nonReentrant`
40      * function is not supported. It is possible to prevent this from happening
41      * by making the `nonReentrant` function external, and make it call a
42      * `private` function that does the actual work.
43      */
44     modifier nonReentrant() {
45         // On the first call to nonReentrant, _notEntered will be true
46         require(_notEntered, "ReentrancyGuard: reentrant call");
47 
48         // Any calls to nonReentrant after this point will fail
49         _notEntered = false;
50 
51         _;
52 
53         // By storing the original value once again, a refund is triggered (see
54         // https://eips.ethereum.org/EIPS/eip-2200)
55         _notEntered = true;
56     }
57 }
58 
59 
60 // File: Address.sol
61 
62 pragma solidity ^0.5.5;
63 
64 /**
65  * @dev Collection of functions related to the address type
66  */
67 library Address {
68     /**
69      * @dev Returns true if `account` is a contract.
70      *
71      * [IMPORTANT]
72      * ====
73      * It is unsafe to assume that an address for which this function returns
74      * false is an externally-owned account (EOA) and not a contract.
75      *
76      * Among others, `isContract` will return false for the following 
77      * types of addresses:
78      *
79      *  - an externally-owned account
80      *  - a contract in construction
81      *  - an address where a contract will be created
82      *  - an address where a contract lived, but was destroyed
83      * ====
84      */
85     function isContract(address account) internal view returns (bool) {
86         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
87         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
88         // for accounts without code, i.e. `keccak256('')`
89         bytes32 codehash;
90         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
91         // solhint-disable-next-line no-inline-assembly
92         assembly { codehash := extcodehash(account) }
93         return (codehash != accountHash && codehash != 0x0);
94     }
95 
96     /**
97      * @dev Converts an `address` into `address payable`. Note that this is
98      * simply a type cast: the actual underlying value is not changed.
99      *
100      * _Available since v2.4.0._
101      */
102     function toPayable(address account) internal pure returns (address payable) {
103         return address(uint160(account));
104     }
105 
106     /**
107      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
108      * `recipient`, forwarding all available gas and reverting on errors.
109      *
110      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
111      * of certain opcodes, possibly making contracts go over the 2300 gas limit
112      * imposed by `transfer`, making them unable to receive funds via
113      * `transfer`. {sendValue} removes this limitation.
114      *
115      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
116      *
117      * IMPORTANT: because control is transferred to `recipient`, care must be
118      * taken to not create reentrancy vulnerabilities. Consider using
119      * {ReentrancyGuard} or the
120      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
121      *
122      * _Available since v2.4.0._
123      */
124     function sendValue(address payable recipient, uint256 amount) internal {
125         require(address(this).balance >= amount, "Address: insufficient balance");
126 
127         // solhint-disable-next-line avoid-call-value
128         (bool success, ) = recipient.call.value(amount)("");
129         require(success, "Address: unable to send value, recipient may have reverted");
130     }
131 }
132 
133 // File: SafeERC20.sol
134 
135 pragma solidity ^0.5.0;
136 
137 /**
138  * @title SafeERC20
139  * @dev Wrappers around ERC20 operations that throw on failure (when the token
140  * contract returns false). Tokens that return no value (and instead revert or
141  * throw on failure) are also supported, non-reverting calls are assumed to be
142  * successful.
143  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
144  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
145  */
146 library SafeERC20 {
147     using SafeMath for uint256;
148     using Address for address;
149 
150     function safeTransfer(IERC20 token, address to, uint256 value) internal {
151         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
152     }
153 
154     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
155         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
156     }
157 
158     function safeApprove(IERC20 token, address spender, uint256 value) internal {
159         // safeApprove should only be called when setting an initial allowance,
160         // or when resetting it to zero. To increase and decrease it, use
161         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
162         // solhint-disable-next-line max-line-length
163         require((value == 0) || (token.allowance(address(this), spender) == 0),
164             "SafeERC20: approve from non-zero to non-zero allowance"
165         );
166         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
167     }
168 
169     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
170         uint256 newAllowance = token.allowance(address(this), spender).add(value);
171         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
172     }
173 
174     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
175         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
176         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
177     }
178 
179     /**
180      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
181      * on the return value: the return value is optional (but if data is returned, it must not be false).
182      * @param token The token targeted by the call.
183      * @param data The call data (encoded using abi.encode or one of its variants).
184      */
185     function callOptionalReturn(IERC20 token, bytes memory data) private {
186         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
187         // we're implementing it ourselves.
188 
189         // A Solidity high level call has three parts:
190         //  1. The target address is checked to verify it contains contract code
191         //  2. The call itself is made, and success asserted
192         //  3. The return value is decoded, which in turn checks the size of the returned data.
193         // solhint-disable-next-line max-line-length
194         require(address(token).isContract(), "SafeERC20: call to non-contract");
195 
196         // solhint-disable-next-line avoid-low-level-calls
197         (bool success, bytes memory returndata) = address(token).call(data);
198         require(success, "SafeERC20: low-level call failed");
199 
200         if (returndata.length > 0) { // Return data is optional
201             // solhint-disable-next-line max-line-length
202             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
203         }
204     }
205 }
206 
207 // File: SafeMath.sol
208 
209 pragma solidity ^0.5.0;
210 
211 /**
212  * @dev Wrappers over Solidity's arithmetic operations with added overflow
213  * checks.
214  *
215  * Arithmetic operations in Solidity wrap on overflow. This can easily result
216  * in bugs, because programmers usually assume that an overflow raises an
217  * error, which is the standard behavior in high level programming languages.
218  * `SafeMath` restores this intuition by reverting the transaction when an
219  * operation overflows.
220  *
221  * Using this library instead of the unchecked operations eliminates an entire
222  * class of bugs, so it's recommended to use it always.
223  */
224 library SafeMath {
225     /**
226      * @dev Returns the addition of two unsigned integers, reverting on
227      * overflow.
228      *
229      * Counterpart to Solidity's `+` operator.
230      *
231      * Requirements:
232      * - Addition cannot overflow.
233      */
234     function add(uint256 a, uint256 b) internal pure returns (uint256) {
235         uint256 c = a + b;
236         require(c >= a, "SafeMath: addition overflow");
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the subtraction of two unsigned integers, reverting on
243      * overflow (when the result is negative).
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      * - Subtraction cannot overflow.
249      */
250     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
251         return sub(a, b, "SafeMath: subtraction overflow");
252     }
253 
254     /**
255      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
256      * overflow (when the result is negative).
257      *
258      * Counterpart to Solidity's `-` operator.
259      *
260      * Requirements:
261      * - Subtraction cannot overflow.
262      *
263      * _Available since v2.4.0._
264      */
265     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b <= a, errorMessage);
267         uint256 c = a - b;
268 
269         return c;
270     }
271 
272     /**
273      * @dev Returns the multiplication of two unsigned integers, reverting on
274      * overflow.
275      *
276      * Counterpart to Solidity's `*` operator.
277      *
278      * Requirements:
279      * - Multiplication cannot overflow.
280      */
281     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
282         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
283         // benefit is lost if 'b' is also tested.
284         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
285         if (a == 0) {
286             return 0;
287         }
288 
289         uint256 c = a * b;
290         require(c / a == b, "SafeMath: multiplication overflow");
291 
292         return c;
293     }
294 
295     /**
296      * @dev Returns the integer division of two unsigned integers. Reverts on
297      * division by zero. The result is rounded towards zero.
298      *
299      * Counterpart to Solidity's `/` operator. Note: this function uses a
300      * `revert` opcode (which leaves remaining gas untouched) while Solidity
301      * uses an invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      * - The divisor cannot be zero.
305      */
306     function div(uint256 a, uint256 b) internal pure returns (uint256) {
307         return div(a, b, "SafeMath: division by zero");
308     }
309 
310     /**
311      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
312      * division by zero. The result is rounded towards zero.
313      *
314      * Counterpart to Solidity's `/` operator. Note: this function uses a
315      * `revert` opcode (which leaves remaining gas untouched) while Solidity
316      * uses an invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      * - The divisor cannot be zero.
320      *
321      * _Available since v2.4.0._
322      */
323     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         // Solidity only automatically asserts when dividing by 0
325         require(b > 0, errorMessage);
326         uint256 c = a / b;
327         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
334      * Reverts when dividing by zero.
335      *
336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
337      * opcode (which leaves remaining gas untouched) while Solidity uses an
338      * invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      * - The divisor cannot be zero.
342      */
343     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
344         return mod(a, b, "SafeMath: modulo by zero");
345     }
346 
347     /**
348      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
349      * Reverts with custom message when dividing by zero.
350      *
351      * Counterpart to Solidity's `%` operator. This function uses a `revert`
352      * opcode (which leaves remaining gas untouched) while Solidity uses an
353      * invalid opcode to revert (consuming all remaining gas).
354      *
355      * Requirements:
356      * - The divisor cannot be zero.
357      *
358      * _Available since v2.4.0._
359      */
360     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         require(b != 0, errorMessage);
362         return a % b;
363     }
364 }
365 
366 // File: IERC20.sol
367 
368 pragma solidity ^0.5.0;
369 
370 /**
371  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
372  * the optional functions; to access them see {ERC20Detailed}.
373  */
374 interface IERC20 {
375     /**
376      * @dev Returns the amount of tokens in existence.
377      */
378     function totalSupply() external view returns (uint256);
379 
380     /**
381      * @dev Returns the amount of tokens owned by `account`.
382      */
383     function balanceOf(address account) external view returns (uint256);
384 
385     /**
386      * @dev Moves `amount` tokens from the caller's account to `recipient`.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transfer(address recipient, uint256 amount) external returns (bool);
393 
394     /**
395      * @dev Returns the remaining number of tokens that `spender` will be
396      * allowed to spend on behalf of `owner` through {transferFrom}. This is
397      * zero by default.
398      *
399      * This value changes when {approve} or {transferFrom} are called.
400      */
401     function allowance(address owner, address spender) external view returns (uint256);
402 
403     /**
404      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
405      *
406      * Returns a boolean value indicating whether the operation succeeded.
407      *
408      * IMPORTANT: Beware that changing an allowance with this method brings the risk
409      * that someone may use both the old and the new allowance by unfortunate
410      * transaction ordering. One possible solution to mitigate this race
411      * condition is to first reduce the spender's allowance to 0 and set the
412      * desired value afterwards:
413      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
414      *
415      * Emits an {Approval} event.
416      */
417     function approve(address spender, uint256 amount) external returns (bool);
418 
419     /**
420      * @dev Moves `amount` tokens from `sender` to `recipient` using the
421      * allowance mechanism. `amount` is then deducted from the caller's
422      * allowance.
423      *
424      * Returns a boolean value indicating whether the operation succeeded.
425      *
426      * Emits a {Transfer} event.
427      */
428     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
429 
430     /**
431      * @dev Emitted when `value` tokens are moved from one account (`from`) to
432      * another (`to`).
433      *
434      * Note that `value` may be zero.
435      */
436     event Transfer(address indexed from, address indexed to, uint256 value);
437 
438     /**
439      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
440      * a call to {approve}. `value` is the new allowance.
441      */
442     event Approval(address indexed owner, address indexed spender, uint256 value);
443 }
444 
445 // File: Context.sol
446 
447 pragma solidity ^0.5.0;
448 
449 /*
450  * @dev Provides information about the current execution context, including the
451  * sender of the transaction and its data. While these are generally available
452  * via msg.sender and msg.data, they should not be accessed in such a direct
453  * manner, since when dealing with GSN meta-transactions the account sending and
454  * paying for execution may not be the actual sender (as far as an application
455  * is concerned).
456  *
457  * This contract is only required for intermediate, library-like contracts.
458  */
459 contract Context {
460     // Empty internal constructor, to prevent people from mistakenly deploying
461     // an instance of this contract, which should be used via inheritance.
462     constructor () internal { }
463     // solhint-disable-previous-line no-empty-blocks
464 
465     function _msgSender() internal view returns (address payable) {
466         return msg.sender;
467     }
468 
469     function _msgData() internal view returns (bytes memory) {
470         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
471         return msg.data;
472     }
473 }
474 
475 // File: Crowdsale.sol
476 
477 pragma solidity ^0.5.0;
478 
479 /**
480  * @title Crowdsale
481  * @dev Crowdsale is a base contract for managing a token crowdsale,
482  * allowing investors to purchase tokens with ether. This contract implements
483  * such functionality in its most fundamental form and can be extended to provide additional
484  * functionality and/or custom behavior.
485  * The external interface represents the basic interface for purchasing tokens, and conforms
486  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
487  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
488  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
489  * behavior.
490  */
491 contract Crowdsale is Context, ReentrancyGuard {
492     using SafeMath for uint256;
493     using SafeERC20 for IERC20;
494 
495     // The token being sold
496     IERC20 private _token;
497 
498     // Address where funds are collected
499     address payable private _wallet;
500 
501     // How many token units a buyer gets per wei.
502     // The rate is the conversion between wei and the smallest and indivisible token unit.
503     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
504     // 1 wei will give you 1 unit, or 0.001 TOK.
505     uint256 private _rate;
506 
507     // Amount of wei raised
508     uint256 private _weiRaised;
509 
510     /**
511      * Event for token purchase logging
512      * @param purchaser who paid for the tokens
513      * @param beneficiary who got the tokens
514      * @param value weis paid for purchase
515      * @param amount amount of tokens purchased
516      */
517     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
518 
519     /**
520      * @param rate Number of token units a buyer gets per wei
521      * @dev The rate is the conversion between wei and the smallest and indivisible
522      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
523      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
524      * @param wallet Address where collected funds will be forwarded to
525      * @param token Address of the token being sold
526      */
527     constructor (uint256 rate, address payable wallet, IERC20 token) public {
528         require(rate > 0, "Crowdsale: rate is 0");
529         require(wallet != address(0), "Crowdsale: wallet is the zero address");
530         require(address(token) != address(0), "Crowdsale: token is the zero address");
531 
532         _rate = rate;
533         _wallet = wallet;
534         _token = token;
535     }
536 
537     /**
538      * @dev fallback function ***DO NOT OVERRIDE***
539      * Note that other contracts will transfer funds with a base gas stipend
540      * of 2300, which is not enough to call buyTokens. Consider calling
541      * buyTokens directly when purchasing tokens from a contract.
542      */
543     function () external payable {
544         buyTokens(_msgSender());
545     }
546 
547     /**
548      * @return the token being sold.
549      */
550     function token() public view returns (IERC20) {
551         return _token;
552     }
553 
554     /**
555      * @return the address where funds are collected.
556      */
557     function wallet() public view returns (address payable) {
558         return _wallet;
559     }
560 
561     /**
562      * @return the number of token units a buyer gets per wei.
563      */
564     function rate() public view returns (uint256) {
565         return _rate;
566     }
567 
568     /**
569      * @return the amount of wei raised.
570      */
571     function weiRaised() public view returns (uint256) {
572         return _weiRaised;
573     }
574 
575     /**
576      * @dev low level token purchase ***DO NOT OVERRIDE***
577      * This function has a non-reentrancy guard, so it shouldn't be called by
578      * another `nonReentrant` function.
579      * @param beneficiary Recipient of the token purchase
580      */
581     function buyTokens(address beneficiary) public nonReentrant payable {
582         uint256 weiAmount = msg.value;
583         _preValidatePurchase(beneficiary, weiAmount);
584 
585         // calculate token amount to be created
586         uint256 tokens = _getTokenAmount(weiAmount);
587 
588         // update state
589         _weiRaised = _weiRaised.add(weiAmount);
590 
591         _processPurchase(beneficiary, tokens);
592         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
593 
594         _updatePurchasingState(beneficiary, weiAmount);
595 
596         _forwardFunds();
597         _postValidatePurchase(beneficiary, weiAmount);
598     }
599 
600     /**
601      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
602      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
603      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
604      *     super._preValidatePurchase(beneficiary, weiAmount);
605      *     require(weiRaised().add(weiAmount) <= cap);
606      * @param beneficiary Address performing the token purchase
607      * @param weiAmount Value in wei involved in the purchase
608      */
609     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
610         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
611         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
612         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
613     }
614 
615     /**
616      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
617      * conditions are not met.
618      * @param beneficiary Address performing the token purchase
619      * @param weiAmount Value in wei involved in the purchase
620      */
621     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
622         // solhint-disable-previous-line no-empty-blocks
623     }
624 
625     /**
626      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
627      * its tokens.
628      * @param beneficiary Address performing the token purchase
629      * @param tokenAmount Number of tokens to be emitted
630      */
631     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
632         _token.safeTransfer(beneficiary, tokenAmount);
633     }
634 
635     /**
636      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
637      * tokens.
638      * @param beneficiary Address receiving the tokens
639      * @param tokenAmount Number of tokens to be purchased
640      */
641     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
642         _deliverTokens(beneficiary, tokenAmount);
643     }
644 
645     /**
646      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
647      * etc.)
648      * @param beneficiary Address receiving the tokens
649      * @param weiAmount Value in wei involved in the purchase
650      */
651     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
652         // solhint-disable-previous-line no-empty-blocks
653     }
654 
655     /**
656      * @dev Override to extend the way in which ether is converted to tokens.
657      * @param weiAmount Value in wei to be converted into tokens
658      * @return Number of tokens that can be purchased with the specified _weiAmount
659      */
660     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
661         return weiAmount.mul(_rate);
662     }
663 
664     /**
665      * @dev Determines how ETH is stored/forwarded on purchases.
666      */
667     function _forwardFunds() internal {
668         _wallet.transfer(msg.value);
669     }
670 }
671 
672 // File: TimedCrowdsale.sol
673 
674 pragma solidity ^0.5.0;
675 
676 /**
677  * @title TimedCrowdsale
678  * @dev Crowdsale accepting contributions only within a time frame.
679  */
680 contract TimedCrowdsale is Crowdsale {
681     using SafeMath for uint256;
682 
683     uint256 private _openingTime;
684     uint256 private _closingTime;
685 
686     /**
687      * Event for crowdsale extending
688      * @param newClosingTime new closing time
689      * @param prevClosingTime old closing time
690      */
691     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
692 
693     /**
694      * @dev Reverts if not in crowdsale time range.
695      */
696     modifier onlyWhileOpen {
697         require(isOpen(), "TimedCrowdsale: not open");
698         _;
699     }
700 
701     /**
702      * @dev Constructor, takes crowdsale opening and closing times.
703      * @param openingTime Crowdsale opening time
704      * @param closingTime Crowdsale closing time
705      */
706     constructor (uint256 openingTime, uint256 closingTime) public {
707         // solhint-disable-next-line not-rely-on-time
708         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
709         // solhint-disable-next-line max-line-length
710         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
711 
712         _openingTime = openingTime;
713         _closingTime = closingTime;
714     }
715 
716     /**
717      * @return the crowdsale opening time.
718      */
719     function openingTime() public view returns (uint256) {
720         return _openingTime;
721     }
722 
723     /**
724      * @return the crowdsale closing time.
725      */
726     function closingTime() public view returns (uint256) {
727         return _closingTime;
728     }
729 
730     /**
731      * @return true if the crowdsale is open, false otherwise.
732      */
733     function isOpen() public view returns (bool) {
734         // solhint-disable-next-line not-rely-on-time
735         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
736     }
737 
738     /**
739      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
740      * @return Whether crowdsale period has elapsed
741      */
742     function hasClosed() public view returns (bool) {
743         // solhint-disable-next-line not-rely-on-time
744         return block.timestamp > _closingTime;
745     }
746 
747     /**
748      * @dev Extend parent behavior requiring to be within contributing period.
749      * @param beneficiary Token purchaser
750      * @param weiAmount Amount of wei contributed
751      */
752     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
753         super._preValidatePurchase(beneficiary, weiAmount);
754     }
755 
756     /**
757      * @dev Extend crowdsale.
758      * @param newClosingTime Crowdsale closing time
759      */
760     function _extendTime(uint256 newClosingTime) internal {
761         require(!hasClosed(), "TimedCrowdsale: already closed");
762         // solhint-disable-next-line max-line-length
763         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
764 
765         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
766         _closingTime = newClosingTime;
767     }
768 }
769 
770 // File: FinalizableCrowdsale.sol
771 
772 pragma solidity ^0.5.0;
773 
774 /**
775  * @title FinalizableCrowdsale
776  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
777  * can do extra work after finishing.
778  */
779 contract FinalizableCrowdsale is TimedCrowdsale {
780     using SafeMath for uint256;
781 
782     bool private _finalized;
783 
784     event CrowdsaleFinalized();
785 
786     constructor () internal {
787         _finalized = false;
788     }
789 
790     /**
791      * @return true if the crowdsale is finalized, false otherwise.
792      */
793     function finalized() public view returns (bool) {
794         return _finalized;
795     }
796 
797     /**
798      * @dev Must be called after crowdsale ends, to do some extra finalization
799      * work. Calls the contract's finalization function.
800      */
801     function finalize() public {
802         require(!_finalized, "FinalizableCrowdsale: already finalized");
803         require(hasClosed(), "FinalizableCrowdsale: not closed");
804 
805         _finalized = true;
806 
807         _finalization();
808         emit CrowdsaleFinalized();
809     }
810 
811     /**
812      * @dev Can be overridden to add finalization logic. The overriding function
813      * should call super._finalization() to ensure the chain of finalization is
814      * executed entirely.
815      */
816     function _finalization() internal {
817         // solhint-disable-previous-line no-empty-blocks
818     }
819 }
820 
821 // File: WhitelistAdminRole.sol
822 
823 pragma solidity ^0.5.0;
824 
825 /**
826  * @title WhitelistAdminRole
827  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
828  */
829 contract WhitelistAdminRole is Context {
830     using Roles for Roles.Role;
831 
832     event WhitelistAdminAdded(address indexed account);
833     event WhitelistAdminRemoved(address indexed account);
834 
835     Roles.Role private _whitelistAdmins;
836 
837     constructor () internal {
838         _addWhitelistAdmin(_msgSender());
839     }
840 
841     modifier onlyWhitelistAdmin() {
842         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
843         _;
844     }
845 
846     function isWhitelistAdmin(address account) public view returns (bool) {
847         return _whitelistAdmins.has(account);
848     }
849 
850     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
851         _addWhitelistAdmin(account);
852     }
853 
854     function renounceWhitelistAdmin() public {
855         _removeWhitelistAdmin(_msgSender());
856     }
857 
858     function _addWhitelistAdmin(address account) internal {
859         _whitelistAdmins.add(account);
860         emit WhitelistAdminAdded(account);
861     }
862 
863     function _removeWhitelistAdmin(address account) internal {
864         _whitelistAdmins.remove(account);
865         emit WhitelistAdminRemoved(account);
866     }
867 }
868 
869 // File: WhitelistedRole.sol
870 
871 pragma solidity ^0.5.0;
872 
873 /**
874  * @title WhitelistedRole
875  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
876  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
877  * it), and not Whitelisteds themselves.
878  */
879 contract WhitelistedRole is Context, WhitelistAdminRole {
880     using Roles for Roles.Role;
881 
882     event WhitelistedAdded(address indexed account);
883     event WhitelistedRemoved(address indexed account);
884 
885     Roles.Role private _whitelisteds;
886 
887     modifier onlyWhitelisted() {
888         require(isWhitelisted(_msgSender()), "WhitelistedRole: caller does not have the Whitelisted role");
889         _;
890     }
891 
892     function isWhitelisted(address account) public view returns (bool) {
893         return _whitelisteds.has(account);
894     }
895 
896     function addWhitelisted(address account) public onlyWhitelistAdmin {
897         _addWhitelisted(account);
898     }
899 
900     function removeWhitelisted(address account) public onlyWhitelistAdmin {
901         _removeWhitelisted(account);
902     }
903 
904     function renounceWhitelisted() public {
905         _removeWhitelisted(_msgSender());
906     }
907 
908     function _addWhitelisted(address account) internal {
909         _whitelisteds.add(account);
910         emit WhitelistedAdded(account);
911     }
912 
913     function _removeWhitelisted(address account) internal {
914         _whitelisteds.remove(account);
915         emit WhitelistedRemoved(account);
916     }
917 }
918 
919 // File: WhitelistCrowdsale.sol
920 
921 pragma solidity ^0.5.0;
922 
923 /**
924  * @title WhitelistCrowdsale
925  * @dev Crowdsale in which only whitelisted users can contribute.
926  */
927 contract WhitelistCrowdsale is WhitelistedRole, Crowdsale {
928     /**
929      * @dev Extend parent behavior requiring beneficiary to be whitelisted. Note that no
930      * restriction is imposed on the account sending the transaction.
931      * @param _beneficiary Token beneficiary
932      * @param _weiAmount Amount of wei contributed
933      */
934     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
935         require(isWhitelisted(_beneficiary), "WhitelistCrowdsale: beneficiary doesn't have the Whitelisted role");
936         super._preValidatePurchase(_beneficiary, _weiAmount);
937     }
938 }
939 
940 // File: PauserRole.sol
941 
942 pragma solidity ^0.5.0;
943 
944 contract PauserRole is Context {
945     using Roles for Roles.Role;
946 
947     event PauserAdded(address indexed account);
948     event PauserRemoved(address indexed account);
949 
950     Roles.Role private _pausers;
951 
952     constructor () internal {
953         _addPauser(_msgSender());
954     }
955 
956     modifier onlyPauser() {
957         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
958         _;
959     }
960 
961     function isPauser(address account) public view returns (bool) {
962         return _pausers.has(account);
963     }
964 
965     function addPauser(address account) public onlyPauser {
966         _addPauser(account);
967     }
968 
969     function renouncePauser() public {
970         _removePauser(_msgSender());
971     }
972 
973     function _addPauser(address account) internal {
974         _pausers.add(account);
975         emit PauserAdded(account);
976     }
977 
978     function _removePauser(address account) internal {
979         _pausers.remove(account);
980         emit PauserRemoved(account);
981     }
982 }
983 
984 // File: Pausable.sol
985 
986 pragma solidity ^0.5.0;
987 
988 /**
989  * @dev Contract module which allows children to implement an emergency stop
990  * mechanism that can be triggered by an authorized account.
991  *
992  * This module is used through inheritance. It will make available the
993  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
994  * the functions of your contract. Note that they will not be pausable by
995  * simply including this module, only once the modifiers are put in place.
996  */
997 contract Pausable is Context, PauserRole {
998     /**
999      * @dev Emitted when the pause is triggered by a pauser (`account`).
1000      */
1001     event Paused(address account);
1002 
1003     /**
1004      * @dev Emitted when the pause is lifted by a pauser (`account`).
1005      */
1006     event Unpaused(address account);
1007 
1008     bool private _paused;
1009 
1010     /**
1011      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
1012      * to the deployer.
1013      */
1014     constructor () internal {
1015         _paused = false;
1016     }
1017 
1018     /**
1019      * @dev Returns true if the contract is paused, and false otherwise.
1020      */
1021     function paused() public view returns (bool) {
1022         return _paused;
1023     }
1024 
1025     /**
1026      * @dev Modifier to make a function callable only when the contract is not paused.
1027      */
1028     modifier whenNotPaused() {
1029         require(!_paused, "Pausable: paused");
1030         _;
1031     }
1032 
1033     /**
1034      * @dev Modifier to make a function callable only when the contract is paused.
1035      */
1036     modifier whenPaused() {
1037         require(_paused, "Pausable: not paused");
1038         _;
1039     }
1040 
1041     /**
1042      * @dev Called by a pauser to pause, triggers stopped state.
1043      */
1044     function pause() public onlyPauser whenNotPaused {
1045         _paused = true;
1046         emit Paused(_msgSender());
1047     }
1048 
1049     /**
1050      * @dev Called by a pauser to unpause, returns to normal state.
1051      */
1052     function unpause() public onlyPauser whenPaused {
1053         _paused = false;
1054         emit Unpaused(_msgSender());
1055     }
1056 }
1057 
1058 // File: PausableCrowdsale.sol
1059 
1060 pragma solidity ^0.5.0;
1061 
1062 /**
1063  * @title PausableCrowdsale
1064  * @dev Extension of Crowdsale contract where purchases can be paused and unpaused by the pauser role.
1065  */
1066 contract PausableCrowdsale is Crowdsale, Pausable {
1067     /**
1068      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
1069      * Use super to concatenate validations.
1070      * Adds the validation that the crowdsale must not be paused.
1071      * @param _beneficiary Address performing the token purchase
1072      * @param _weiAmount Value in wei involved in the purchase
1073      */
1074     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view whenNotPaused {
1075         return super._preValidatePurchase(_beneficiary, _weiAmount);
1076     }
1077 }
1078 
1079 // File: Roles.sol
1080 
1081 pragma solidity ^0.5.0;
1082 
1083 /**
1084  * @title Roles
1085  * @dev Library for managing addresses assigned to a Role.
1086  */
1087 library Roles {
1088     struct Role {
1089         mapping (address => bool) bearer;
1090     }
1091 
1092     /**
1093      * @dev Give an account access to this role.
1094      */
1095     function add(Role storage role, address account) internal {
1096         require(!has(role, account), "Roles: account already has role");
1097         role.bearer[account] = true;
1098     }
1099 
1100     /**
1101      * @dev Remove an account's access to this role.
1102      */
1103     function remove(Role storage role, address account) internal {
1104         require(has(role, account), "Roles: account does not have role");
1105         role.bearer[account] = false;
1106     }
1107 
1108     /**
1109      * @dev Check if an account has this role.
1110      * @return bool
1111      */
1112     function has(Role storage role, address account) internal view returns (bool) {
1113         require(account != address(0), "Roles: account is the zero address");
1114         return role.bearer[account];
1115     }
1116 }
1117 
1118 // File: CapperRole.sol
1119 
1120 pragma solidity ^0.5.0;
1121 
1122 contract CapperRole is Context {
1123     using Roles for Roles.Role;
1124 
1125     event CapperAdded(address indexed account);
1126     event CapperRemoved(address indexed account);
1127 
1128     Roles.Role private _cappers;
1129 
1130     constructor () internal {
1131         _addCapper(_msgSender());
1132     }
1133 
1134     modifier onlyCapper() {
1135         require(isCapper(_msgSender()), "CapperRole: caller does not have the Capper role");
1136         _;
1137     }
1138 
1139     function isCapper(address account) public view returns (bool) {
1140         return _cappers.has(account);
1141     }
1142 
1143     function addCapper(address account) public onlyCapper {
1144         _addCapper(account);
1145     }
1146 
1147     function renounceCapper() public {
1148         _removeCapper(_msgSender());
1149     }
1150 
1151     function _addCapper(address account) internal {
1152         _cappers.add(account);
1153         emit CapperAdded(account);
1154     }
1155 
1156     function _removeCapper(address account) internal {
1157         _cappers.remove(account);
1158         emit CapperRemoved(account);
1159     }
1160 }
1161 
1162 // File: IndividuallyCappedCrowdsale.sol
1163 
1164 pragma solidity ^0.5.0;
1165 
1166 /**
1167  * @title IndividuallyCappedCrowdsale
1168  * @dev Crowdsale with per-beneficiary caps.
1169  */
1170 contract IndividuallyCappedCrowdsale is Crowdsale, CapperRole {
1171     using SafeMath for uint256;
1172 
1173     mapping(address => uint256) private _contributions;
1174     uint256 private _perWalletCap;
1175 
1176     /**
1177      * @dev Sets a specific beneficiary's maximum contribution.
1178      * @param perWalletCap Wei limit for individual contribution
1179      */
1180     function setPerWalletCap(uint256 perWalletCap) public onlyCapper {
1181         _perWalletCap = perWalletCap;
1182     }
1183 
1184     /**
1185      * @dev Returns the cap of a specific beneficiary.
1186      * @return Current cap for individual beneficiary
1187      */
1188     function getPerWalletCap() public view returns (uint256) {
1189         return _perWalletCap;
1190     }
1191 
1192     /**
1193      * @dev Returns the amount contributed so far by a specific beneficiary.
1194      * @param beneficiary Address of contributor
1195      * @return Beneficiary contribution so far
1196      */
1197     function getContribution(address beneficiary) public view returns (uint256) {
1198         return _contributions[beneficiary];
1199     }
1200 
1201     /**
1202      * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
1203      * @param beneficiary Token purchaser
1204      * @param weiAmount Amount of wei contributed
1205      */
1206     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1207         super._preValidatePurchase(beneficiary, weiAmount);
1208         // solhint-disable-next-line max-line-length
1209         require(_contributions[beneficiary].add(weiAmount) <= _perWalletCap, "IndividuallyCappedCrowdsale: beneficiary's cap exceeded");
1210     }
1211 
1212     /**
1213      * @dev Extend parent behavior to update beneficiary contributions.
1214      * @param beneficiary Token purchaser
1215      * @param weiAmount Amount of wei contributed
1216      */
1217     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
1218         super._updatePurchasingState(beneficiary, weiAmount);
1219         _contributions[beneficiary] = _contributions[beneficiary].add(weiAmount);
1220     }
1221 }
1222 
1223 // File: CappedCrowdsale.sol
1224 
1225 pragma solidity ^0.5.0;
1226 
1227 /**
1228  * @title CappedCrowdsale
1229  * @dev Crowdsale with a limit for total contributions.
1230  */
1231 contract CappedCrowdsale is Crowdsale {
1232     using SafeMath for uint256;
1233 
1234     uint256 private _cap;
1235 
1236     /**
1237      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
1238      * @param cap Max amount of wei to be contributed
1239      */
1240     constructor (uint256 cap) public {
1241         require(cap > 0, "CappedCrowdsale: cap is 0");
1242         _cap = cap;
1243     }
1244 
1245     /**
1246      * @return the cap of the crowdsale.
1247      */
1248     function cap() public view returns (uint256) {
1249         return _cap;
1250     }
1251 
1252     /**
1253      * @dev Checks whether the cap has been reached.
1254      * @return Whether the cap was reached
1255      */
1256     function capReached() public view returns (bool) {
1257         return weiRaised() >= _cap;
1258     }
1259 
1260     /**
1261      * @dev Extend parent behavior requiring purchase to respect the funding cap.
1262      * @param beneficiary Token purchaser
1263      * @param weiAmount Amount of wei contributed
1264      */
1265     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1266         super._preValidatePurchase(beneficiary, weiAmount);
1267         require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
1268     }
1269 }
1270 
1271 
1272 // File: HLDCrowdsale.sol
1273 
1274 pragma solidity ^0.5.0;
1275 
1276 contract HLDCrowdsale is CappedCrowdsale, IndividuallyCappedCrowdsale ,PausableCrowdsale, TimedCrowdsale, WhitelistCrowdsale, FinalizableCrowdsale {
1277    
1278     constructor(uint256 rate, address payable wallet, IERC20 token, uint256 cap, uint256 perWalletCap, uint256 startTime, uint256 endTime) public CappedCrowdsale(cap) TimedCrowdsale(startTime, endTime) Crowdsale(rate, wallet, IERC20(token)) {
1279         setPerWalletCap(perWalletCap);
1280     }
1281 
1282     function _finalization() internal {
1283         IERC20 token = token();
1284         address wallet = wallet();
1285         
1286         uint256 remaining = token.balanceOf(address(this));
1287         token.transfer(wallet, remaining);
1288         super._finalization();
1289     }
1290     
1291     function addManyToWhitelist(address[] calldata list) external onlyWhitelistAdmin{
1292         for (uint256 i = 0 ; i < list.length ; i++) {
1293             _addWhitelisted(list[i]);
1294         }
1295     }
1296 }