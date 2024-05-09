1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
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
346 /**
347  * @title SafeERC20
348  * @dev Wrappers around ERC20 operations that throw on failure (when the token
349  * contract returns false). Tokens that return no value (and instead revert or
350  * throw on failure) are also supported, non-reverting calls are assumed to be
351  * successful.
352  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
353  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
354  */
355 library SafeERC20 {
356     using SafeMath for uint256;
357     using Address for address;
358 
359     function safeTransfer(IERC20 token, address to, uint256 value) internal {
360         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
361     }
362 
363     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
364         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
365     }
366 
367     function safeApprove(IERC20 token, address spender, uint256 value) internal {
368         // safeApprove should only be called when setting an initial allowance,
369         // or when resetting it to zero. To increase and decrease it, use
370         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
371         // solhint-disable-next-line max-line-length
372         require((value == 0) || (token.allowance(address(this), spender) == 0),
373             "SafeERC20: approve from non-zero to non-zero allowance"
374         );
375         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
376     }
377 
378     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
379         uint256 newAllowance = token.allowance(address(this), spender).add(value);
380         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
381     }
382 
383     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
384         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
385         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
386     }
387 
388     /**
389      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
390      * on the return value: the return value is optional (but if data is returned, it must not be false).
391      * @param token The token targeted by the call.
392      * @param data The call data (encoded using abi.encode or one of its variants).
393      */
394     function callOptionalReturn(IERC20 token, bytes memory data) private {
395         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
396         // we're implementing it ourselves.
397 
398         // A Solidity high level call has three parts:
399         //  1. The target address is checked to verify it contains contract code
400         //  2. The call itself is made, and success asserted
401         //  3. The return value is decoded, which in turn checks the size of the returned data.
402         // solhint-disable-next-line max-line-length
403         require(address(token).isContract(), "SafeERC20: call to non-contract");
404 
405         // solhint-disable-next-line avoid-low-level-calls
406         (bool success, bytes memory returndata) = address(token).call(data);
407         require(success, "SafeERC20: low-level call failed");
408 
409         if (returndata.length > 0) { // Return data is optional
410             // solhint-disable-next-line max-line-length
411             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
412         }
413     }
414 }
415 
416 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
417 
418 pragma solidity ^0.5.0;
419 
420 /**
421  * @dev Contract module that helps prevent reentrant calls to a function.
422  *
423  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
424  * available, which can be applied to functions to make sure there are no nested
425  * (reentrant) calls to them.
426  *
427  * Note that because there is a single `nonReentrant` guard, functions marked as
428  * `nonReentrant` may not call one another. This can be worked around by making
429  * those functions `private`, and then adding `external` `nonReentrant` entry
430  * points to them.
431  *
432  * TIP: If you would like to learn more about reentrancy and alternative ways
433  * to protect against it, check out our blog post
434  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
435  *
436  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
437  * metering changes introduced in the Istanbul hardfork.
438  */
439 contract ReentrancyGuard {
440     bool private _notEntered;
441 
442     constructor () internal {
443         // Storing an initial non-zero value makes deployment a bit more
444         // expensive, but in exchange the refund on every call to nonReentrant
445         // will be lower in amount. Since refunds are capped to a percetange of
446         // the total transaction's gas, it is best to keep them low in cases
447         // like this one, to increase the likelihood of the full refund coming
448         // into effect.
449         _notEntered = true;
450     }
451 
452     /**
453      * @dev Prevents a contract from calling itself, directly or indirectly.
454      * Calling a `nonReentrant` function from another `nonReentrant`
455      * function is not supported. It is possible to prevent this from happening
456      * by making the `nonReentrant` function external, and make it call a
457      * `private` function that does the actual work.
458      */
459     modifier nonReentrant() {
460         // On the first call to nonReentrant, _notEntered will be true
461         require(_notEntered, "ReentrancyGuard: reentrant call");
462 
463         // Any calls to nonReentrant after this point will fail
464         _notEntered = false;
465 
466         _;
467 
468         // By storing the original value once again, a refund is triggered (see
469         // https://eips.ethereum.org/EIPS/eip-2200)
470         _notEntered = true;
471     }
472 }
473 
474 // File: @openzeppelin/contracts/crowdsale/Crowdsale.sol
475 
476 pragma solidity ^0.5.0;
477 
478 /**
479  * @title Crowdsale
480  * @dev Crowdsale is a base contract for managing a token crowdsale,
481  * allowing investors to purchase tokens with ether. This contract implements
482  * such functionality in its most fundamental form and can be extended to provide additional
483  * functionality and/or custom behavior.
484  * The external interface represents the basic interface for purchasing tokens, and conforms
485  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
486  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
487  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
488  * behavior.
489  */
490 contract Crowdsale is Context, ReentrancyGuard {
491     using SafeMath for uint256;
492     using SafeERC20 for IERC20;
493 
494     // The token being sold
495     IERC20 private _token;
496 
497     // Address where funds are collected
498     address payable private _wallet;
499 
500     // How many token units a buyer gets per wei.
501     // The rate is the conversion between wei and the smallest and indivisible token unit.
502     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
503     // 1 wei will give you 1 unit, or 0.001 TOK.
504     uint256 private _rate;
505 
506     // Amount of wei raised
507     uint256 private _weiRaised;
508 
509     /**
510      * Event for token purchase logging
511      * @param purchaser who paid for the tokens
512      * @param beneficiary who got the tokens
513      * @param value weis paid for purchase
514      * @param amount amount of tokens purchased
515      */
516     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
517 
518     /**
519      * @param rate Number of token units a buyer gets per wei
520      * @dev The rate is the conversion between wei and the smallest and indivisible
521      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
522      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
523      * @param wallet Address where collected funds will be forwarded to
524      * @param token Address of the token being sold
525      */
526     constructor (uint256 rate, address payable wallet, IERC20 token) public {
527         require(rate > 0, "Crowdsale: rate is 0");
528         require(wallet != address(0), "Crowdsale: wallet is the zero address");
529         require(address(token) != address(0), "Crowdsale: token is the zero address");
530 
531         _rate = rate;
532         _wallet = wallet;
533         _token = token;
534     }
535 
536     /**
537      * @dev fallback function ***DO NOT OVERRIDE***
538      * Note that other contracts will transfer funds with a base gas stipend
539      * of 2300, which is not enough to call buyTokens. Consider calling
540      * buyTokens directly when purchasing tokens from a contract.
541      */
542     function () external payable {
543         buyTokens(_msgSender());
544     }
545 
546     /**
547      * @return the token being sold.
548      */
549     function token() public view returns (IERC20) {
550         return _token;
551     }
552 
553     /**
554      * @return the address where funds are collected.
555      */
556     function wallet() public view returns (address payable) {
557         return _wallet;
558     }
559 
560     /**
561      * @return the number of token units a buyer gets per wei.
562      */
563     function rate() public view returns (uint256) {
564         return _rate;
565     }
566 
567     /**
568      * @return the amount of wei raised.
569      */
570     function weiRaised() public view returns (uint256) {
571         return _weiRaised;
572     }
573 
574     /**
575      * @dev low level token purchase ***DO NOT OVERRIDE***
576      * This function has a non-reentrancy guard, so it shouldn't be called by
577      * another `nonReentrant` function.
578      * @param beneficiary Recipient of the token purchase
579      */
580     function buyTokens(address beneficiary) public nonReentrant payable {
581         uint256 weiAmount = msg.value;
582         _preValidatePurchase(beneficiary, weiAmount);
583 
584         // calculate token amount to be created
585         uint256 tokens = _getTokenAmount(weiAmount);
586 
587         // update state
588         _weiRaised = _weiRaised.add(weiAmount);
589 
590         _processPurchase(beneficiary, tokens);
591         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
592 
593         _updatePurchasingState(beneficiary, weiAmount);
594 
595         _forwardFunds();
596         _postValidatePurchase(beneficiary, weiAmount);
597     }
598 
599     /**
600      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
601      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
602      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
603      *     super._preValidatePurchase(beneficiary, weiAmount);
604      *     require(weiRaised().add(weiAmount) <= cap);
605      * @param beneficiary Address performing the token purchase
606      * @param weiAmount Value in wei involved in the purchase
607      */
608     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
609         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
610         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
611         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
612     }
613 
614     /**
615      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
616      * conditions are not met.
617      * @param beneficiary Address performing the token purchase
618      * @param weiAmount Value in wei involved in the purchase
619      */
620     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
621         // solhint-disable-previous-line no-empty-blocks
622     }
623 
624     /**
625      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
626      * its tokens.
627      * @param beneficiary Address performing the token purchase
628      * @param tokenAmount Number of tokens to be emitted
629      */
630     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
631         _token.safeTransfer(beneficiary, tokenAmount);
632     }
633 
634     /**
635      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
636      * tokens.
637      * @param beneficiary Address receiving the tokens
638      * @param tokenAmount Number of tokens to be purchased
639      */
640     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
641         _deliverTokens(beneficiary, tokenAmount);
642     }
643 
644     /**
645      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
646      * etc.)
647      * @param beneficiary Address receiving the tokens
648      * @param weiAmount Value in wei involved in the purchase
649      */
650     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
651         // solhint-disable-previous-line no-empty-blocks
652     }
653 
654     /**
655      * @dev Override to extend the way in which ether is converted to tokens.
656      * @param weiAmount Value in wei to be converted into tokens
657      * @return Number of tokens that can be purchased with the specified _weiAmount
658      */
659     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
660         return weiAmount.mul(_rate);
661     }
662 
663     /**
664      * @dev Determines how ETH is stored/forwarded on purchases.
665      */
666     function _forwardFunds() internal {
667         _wallet.transfer(msg.value);
668     }
669 }
670 
671 // File: @openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol
672 
673 pragma solidity ^0.5.0;
674 
675 /**
676  * @title TimedCrowdsale
677  * @dev Crowdsale accepting contributions only within a time frame.
678  */
679 contract TimedCrowdsale is Crowdsale {
680     using SafeMath for uint256;
681 
682     uint256 private _openingTime;
683     uint256 private _closingTime;
684 
685     /**
686      * Event for crowdsale extending
687      * @param newClosingTime new closing time
688      * @param prevClosingTime old closing time
689      */
690     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
691 
692     /**
693      * @dev Reverts if not in crowdsale time range.
694      */
695     modifier onlyWhileOpen {
696         require(isOpen(), "TimedCrowdsale: not open");
697         _;
698     }
699 
700     /**
701      * @dev Constructor, takes crowdsale opening and closing times.
702      * @param openingTime Crowdsale opening time
703      * @param closingTime Crowdsale closing time
704      */
705     constructor (uint256 openingTime, uint256 closingTime) public {
706         // solhint-disable-next-line not-rely-on-time
707         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
708         // solhint-disable-next-line max-line-length
709         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
710 
711         _openingTime = openingTime;
712         _closingTime = closingTime;
713     }
714 
715     /**
716      * @return the crowdsale opening time.
717      */
718     function openingTime() public view returns (uint256) {
719         return _openingTime;
720     }
721 
722     /**
723      * @return the crowdsale closing time.
724      */
725     function closingTime() public view returns (uint256) {
726         return _closingTime;
727     }
728 
729     /**
730      * @return true if the crowdsale is open, false otherwise.
731      */
732     function isOpen() public view returns (bool) {
733         // solhint-disable-next-line not-rely-on-time
734         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
735     }
736 
737     /**
738      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
739      * @return Whether crowdsale period has elapsed
740      */
741     function hasClosed() public view returns (bool) {
742         // solhint-disable-next-line not-rely-on-time
743         return block.timestamp > _closingTime;
744     }
745 
746     /**
747      * @dev Extend parent behavior requiring to be within contributing period.
748      * @param beneficiary Token purchaser
749      * @param weiAmount Amount of wei contributed
750      */
751     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
752         super._preValidatePurchase(beneficiary, weiAmount);
753     }
754 
755     /**
756      * @dev Extend crowdsale.
757      * @param newClosingTime Crowdsale closing time
758      */
759     function _extendTime(uint256 newClosingTime) internal {
760         require(!hasClosed(), "TimedCrowdsale: already closed");
761         // solhint-disable-next-line max-line-length
762         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
763 
764         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
765         _closingTime = newClosingTime;
766     }
767 }
768 
769 // File: @openzeppelin/contracts/ownership/Secondary.sol
770 
771 pragma solidity ^0.5.0;
772 
773 /**
774  * @dev A Secondary contract can only be used by its primary account (the one that created it).
775  */
776 contract Secondary is Context {
777     address private _primary;
778 
779     /**
780      * @dev Emitted when the primary contract changes.
781      */
782     event PrimaryTransferred(
783         address recipient
784     );
785 
786     /**
787      * @dev Sets the primary account to the one that is creating the Secondary contract.
788      */
789     constructor () internal {
790         address msgSender = _msgSender();
791         _primary = msgSender;
792         emit PrimaryTransferred(msgSender);
793     }
794 
795     /**
796      * @dev Reverts if called from any account other than the primary.
797      */
798     modifier onlyPrimary() {
799         require(_msgSender() == _primary, "Secondary: caller is not the primary account");
800         _;
801     }
802 
803     /**
804      * @return the address of the primary.
805      */
806     function primary() public view returns (address) {
807         return _primary;
808     }
809 
810     /**
811      * @dev Transfers contract to a new primary.
812      * @param recipient The address of new primary.
813      */
814     function transferPrimary(address recipient) public onlyPrimary {
815         require(recipient != address(0), "Secondary: new primary is the zero address");
816         _primary = recipient;
817         emit PrimaryTransferred(recipient);
818     }
819 }
820 
821 // File: @openzeppelin/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
822 
823 pragma solidity ^0.5.0;
824 
825 /**
826  * @title PostDeliveryCrowdsale
827  * @dev Crowdsale that locks tokens from withdrawal until it ends.
828  */
829 contract PostDeliveryCrowdsale is TimedCrowdsale {
830     using SafeMath for uint256;
831 
832     mapping(address => uint256) private _balances;
833     __unstable__TokenVault private _vault;
834 
835     constructor() public {
836         _vault = new __unstable__TokenVault();
837     }
838 
839     /**
840      * @dev Withdraw tokens only after crowdsale ends.
841      * @param beneficiary Whose tokens will be withdrawn.
842      */
843     function withdrawTokens(address beneficiary) public {
844         require(hasClosed(), "PostDeliveryCrowdsale: not closed");
845         uint256 amount = _balances[beneficiary];
846         require(amount > 0, "PostDeliveryCrowdsale: beneficiary is not due any tokens");
847 
848         _balances[beneficiary] = 0;
849         _vault.transfer(token(), beneficiary, amount);
850     }
851 
852     /**
853      * @return the balance of an account.
854      */
855     function balanceOf(address account) public view returns (uint256) {
856         return _balances[account];
857     }
858 
859     /**
860      * @dev Overrides parent by storing due balances, and delivering tokens to the vault instead of the end user. This
861      * ensures that the tokens will be available by the time they are withdrawn (which may not be the case if
862      * `_deliverTokens` was called later).
863      * @param beneficiary Token purchaser
864      * @param tokenAmount Amount of tokens purchased
865      */
866     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
867         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
868         _deliverTokens(address(_vault), tokenAmount);
869     }
870 }
871 
872 /**
873  * @title __unstable__TokenVault
874  * @dev Similar to an Escrow for tokens, this contract allows its primary account to spend its tokens as it sees fit.
875  * This contract is an internal helper for PostDeliveryCrowdsale, and should not be used outside of this context.
876  */
877 // solhint-disable-next-line contract-name-camelcase
878 contract __unstable__TokenVault is Secondary {
879     function transfer(IERC20 token, address to, uint256 amount) public onlyPrimary {
880         token.transfer(to, amount);
881     }
882 }
883 
884 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
885 
886 pragma solidity ^0.5.0;
887 
888 
889 
890 
891 /**
892  * @dev Implementation of the {IERC20} interface.
893  *
894  * This implementation is agnostic to the way tokens are created. This means
895  * that a supply mechanism has to be added in a derived contract using {_mint}.
896  * For a generic mechanism see {ERC20Mintable}.
897  *
898  * TIP: For a detailed writeup see our guide
899  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
900  * to implement supply mechanisms].
901  *
902  * We have followed general OpenZeppelin guidelines: functions revert instead
903  * of returning `false` on failure. This behavior is nonetheless conventional
904  * and does not conflict with the expectations of ERC20 applications.
905  *
906  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
907  * This allows applications to reconstruct the allowance for all accounts just
908  * by listening to said events. Other implementations of the EIP may not emit
909  * these events, as it isn't required by the specification.
910  *
911  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
912  * functions have been added to mitigate the well-known issues around setting
913  * allowances. See {IERC20-approve}.
914  */
915 contract ERC20 is Context, IERC20 {
916     using SafeMath for uint256;
917 
918     mapping (address => uint256) private _balances;
919 
920     mapping (address => mapping (address => uint256)) private _allowances;
921 
922     uint256 private _totalSupply;
923 
924     /**
925      * @dev See {IERC20-totalSupply}.
926      */
927     function totalSupply() public view returns (uint256) {
928         return _totalSupply;
929     }
930 
931     /**
932      * @dev See {IERC20-balanceOf}.
933      */
934     function balanceOf(address account) public view returns (uint256) {
935         return _balances[account];
936     }
937 
938     /**
939      * @dev See {IERC20-transfer}.
940      *
941      * Requirements:
942      *
943      * - `recipient` cannot be the zero address.
944      * - the caller must have a balance of at least `amount`.
945      */
946     function transfer(address recipient, uint256 amount) public returns (bool) {
947         _transfer(_msgSender(), recipient, amount);
948         return true;
949     }
950 
951     /**
952      * @dev See {IERC20-allowance}.
953      */
954     function allowance(address owner, address spender) public view returns (uint256) {
955         return _allowances[owner][spender];
956     }
957 
958     /**
959      * @dev See {IERC20-approve}.
960      *
961      * Requirements:
962      *
963      * - `spender` cannot be the zero address.
964      */
965     function approve(address spender, uint256 amount) public returns (bool) {
966         _approve(_msgSender(), spender, amount);
967         return true;
968     }
969 
970     /**
971      * @dev See {IERC20-transferFrom}.
972      *
973      * Emits an {Approval} event indicating the updated allowance. This is not
974      * required by the EIP. See the note at the beginning of {ERC20};
975      *
976      * Requirements:
977      * - `sender` and `recipient` cannot be the zero address.
978      * - `sender` must have a balance of at least `amount`.
979      * - the caller must have allowance for `sender`'s tokens of at least
980      * `amount`.
981      */
982     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
983         _transfer(sender, recipient, amount);
984         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
985         return true;
986     }
987 
988     /**
989      * @dev Atomically increases the allowance granted to `spender` by the caller.
990      *
991      * This is an alternative to {approve} that can be used as a mitigation for
992      * problems described in {IERC20-approve}.
993      *
994      * Emits an {Approval} event indicating the updated allowance.
995      *
996      * Requirements:
997      *
998      * - `spender` cannot be the zero address.
999      */
1000     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1001         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1002         return true;
1003     }
1004 
1005     /**
1006      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1007      *
1008      * This is an alternative to {approve} that can be used as a mitigation for
1009      * problems described in {IERC20-approve}.
1010      *
1011      * Emits an {Approval} event indicating the updated allowance.
1012      *
1013      * Requirements:
1014      *
1015      * - `spender` cannot be the zero address.
1016      * - `spender` must have allowance for the caller of at least
1017      * `subtractedValue`.
1018      */
1019     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1020         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1021         return true;
1022     }
1023 
1024     /**
1025      * @dev Moves tokens `amount` from `sender` to `recipient`.
1026      *
1027      * This is internal function is equivalent to {transfer}, and can be used to
1028      * e.g. implement automatic token fees, slashing mechanisms, etc.
1029      *
1030      * Emits a {Transfer} event.
1031      *
1032      * Requirements:
1033      *
1034      * - `sender` cannot be the zero address.
1035      * - `recipient` cannot be the zero address.
1036      * - `sender` must have a balance of at least `amount`.
1037      */
1038     function _transfer(address sender, address recipient, uint256 amount) internal {
1039         require(sender != address(0), "ERC20: transfer from the zero address");
1040         require(recipient != address(0), "ERC20: transfer to the zero address");
1041 
1042         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1043         _balances[recipient] = _balances[recipient].add(amount);
1044         emit Transfer(sender, recipient, amount);
1045     }
1046 
1047     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1048      * the total supply.
1049      *
1050      * Emits a {Transfer} event with `from` set to the zero address.
1051      *
1052      * Requirements
1053      *
1054      * - `to` cannot be the zero address.
1055      */
1056     function _mint(address account, uint256 amount) internal {
1057         require(account != address(0), "ERC20: mint to the zero address");
1058 
1059         _totalSupply = _totalSupply.add(amount);
1060         _balances[account] = _balances[account].add(amount);
1061         emit Transfer(address(0), account, amount);
1062     }
1063 
1064     /**
1065      * @dev Destroys `amount` tokens from `account`, reducing the
1066      * total supply.
1067      *
1068      * Emits a {Transfer} event with `to` set to the zero address.
1069      *
1070      * Requirements
1071      *
1072      * - `account` cannot be the zero address.
1073      * - `account` must have at least `amount` tokens.
1074      */
1075     function _burn(address account, uint256 amount) internal {
1076         require(account != address(0), "ERC20: burn from the zero address");
1077 
1078         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1079         _totalSupply = _totalSupply.sub(amount);
1080         emit Transfer(account, address(0), amount);
1081     }
1082 
1083     /**
1084      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1085      *
1086      * This is internal function is equivalent to `approve`, and can be used to
1087      * e.g. set automatic allowances for certain subsystems, etc.
1088      *
1089      * Emits an {Approval} event.
1090      *
1091      * Requirements:
1092      *
1093      * - `owner` cannot be the zero address.
1094      * - `spender` cannot be the zero address.
1095      */
1096     function _approve(address owner, address spender, uint256 amount) internal {
1097         require(owner != address(0), "ERC20: approve from the zero address");
1098         require(spender != address(0), "ERC20: approve to the zero address");
1099 
1100         _allowances[owner][spender] = amount;
1101         emit Approval(owner, spender, amount);
1102     }
1103 
1104     /**
1105      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
1106      * from the caller's allowance.
1107      *
1108      * See {_burn} and {_approve}.
1109      */
1110     function _burnFrom(address account, uint256 amount) internal {
1111         _burn(account, amount);
1112         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
1113     }
1114 }
1115 
1116 // File: @openzeppelin/contracts/access/Roles.sol
1117 
1118 pragma solidity ^0.5.0;
1119 
1120 /**
1121  * @title Roles
1122  * @dev Library for managing addresses assigned to a Role.
1123  */
1124 library Roles {
1125     struct Role {
1126         mapping (address => bool) bearer;
1127     }
1128 
1129     /**
1130      * @dev Give an account access to this role.
1131      */
1132     function add(Role storage role, address account) internal {
1133         require(!has(role, account), "Roles: account already has role");
1134         role.bearer[account] = true;
1135     }
1136 
1137     /**
1138      * @dev Remove an account's access to this role.
1139      */
1140     function remove(Role storage role, address account) internal {
1141         require(has(role, account), "Roles: account does not have role");
1142         role.bearer[account] = false;
1143     }
1144 
1145     /**
1146      * @dev Check if an account has this role.
1147      * @return bool
1148      */
1149     function has(Role storage role, address account) internal view returns (bool) {
1150         require(account != address(0), "Roles: account is the zero address");
1151         return role.bearer[account];
1152     }
1153 }
1154 
1155 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
1156 
1157 pragma solidity ^0.5.0;
1158 
1159 contract MinterRole is Context {
1160     using Roles for Roles.Role;
1161 
1162     event MinterAdded(address indexed account);
1163     event MinterRemoved(address indexed account);
1164 
1165     Roles.Role private _minters;
1166 
1167     constructor () internal {
1168         _addMinter(_msgSender());
1169     }
1170 
1171     modifier onlyMinter() {
1172         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1173         _;
1174     }
1175 
1176     function isMinter(address account) public view returns (bool) {
1177         return _minters.has(account);
1178     }
1179 
1180     function addMinter(address account) public onlyMinter {
1181         _addMinter(account);
1182     }
1183 
1184     function renounceMinter() public {
1185         _removeMinter(_msgSender());
1186     }
1187 
1188     function _addMinter(address account) internal {
1189         _minters.add(account);
1190         emit MinterAdded(account);
1191     }
1192 
1193     function _removeMinter(address account) internal {
1194         _minters.remove(account);
1195         emit MinterRemoved(account);
1196     }
1197 }
1198 
1199 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
1200 
1201 pragma solidity ^0.5.0;
1202 
1203 /**
1204  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1205  * which have permission to mint (create) new tokens as they see fit.
1206  *
1207  * At construction, the deployer of the contract is the only minter.
1208  */
1209 contract ERC20Mintable is ERC20, MinterRole {
1210     /**
1211      * @dev See {ERC20-_mint}.
1212      *
1213      * Requirements:
1214      *
1215      * - the caller must have the {MinterRole}.
1216      */
1217     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1218         _mint(account, amount);
1219         return true;
1220     }
1221 }
1222 
1223 // File: @openzeppelin/contracts/crowdsale/emission/MintedCrowdsale.sol
1224 
1225 pragma solidity ^0.5.0;
1226 
1227 /**
1228  * @title MintedCrowdsale
1229  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1230  * Token ownership should be transferred to MintedCrowdsale for minting.
1231  */
1232 contract MintedCrowdsale is Crowdsale {
1233     /**
1234      * @dev Overrides delivery by minting tokens upon purchase.
1235      * @param beneficiary Token purchaser
1236      * @param tokenAmount Number of tokens to be minted
1237      */
1238     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
1239         // Potentially dangerous assumption about the type of the token.
1240         require(
1241             ERC20Mintable(address(token())).mint(beneficiary, tokenAmount),
1242                 "MintedCrowdsale: minting failed"
1243         );
1244     }
1245 }
1246 
1247 // File: contracts/crowdsale/WhitelistCrowdsale.sol
1248 
1249 pragma solidity ^0.5.0;
1250 
1251 // custom validation using the whitelister contract
1252 
1253 contract WhitelistCrowdsale is Crowdsale {
1254     address public whitelister;
1255 
1256     constructor(address _whitelister) public {
1257         whitelister = _whitelister;
1258     }
1259 
1260     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
1261         require(IWhitelister(whitelister).whitelisted(_beneficiary) == true, "WhitelistCrowdsale: beneficiary not whitelisted");
1262         super._preValidatePurchase(_beneficiary, _weiAmount);
1263     }
1264 
1265     function isWhitelisted(address _address) external view returns (bool) {
1266     	return IWhitelister(whitelister).whitelisted(_address);
1267     }
1268 }
1269 
1270 interface IWhitelister {
1271     function whitelisted(address _address) external view returns (bool);
1272 }
1273 
1274 // File: @openzeppelin/contracts/access/roles/CapperRole.sol
1275 
1276 pragma solidity ^0.5.0;
1277 
1278 contract CapperRole is Context {
1279     using Roles for Roles.Role;
1280 
1281     event CapperAdded(address indexed account);
1282     event CapperRemoved(address indexed account);
1283 
1284     Roles.Role private _cappers;
1285 
1286     constructor () internal {
1287         _addCapper(_msgSender());
1288     }
1289 
1290     modifier onlyCapper() {
1291         require(isCapper(_msgSender()), "CapperRole: caller does not have the Capper role");
1292         _;
1293     }
1294 
1295     function isCapper(address account) public view returns (bool) {
1296         return _cappers.has(account);
1297     }
1298 
1299     function addCapper(address account) public onlyCapper {
1300         _addCapper(account);
1301     }
1302 
1303     function renounceCapper() public {
1304         _removeCapper(_msgSender());
1305     }
1306 
1307     function _addCapper(address account) internal {
1308         _cappers.add(account);
1309         emit CapperAdded(account);
1310     }
1311 
1312     function _removeCapper(address account) internal {
1313         _cappers.remove(account);
1314         emit CapperRemoved(account);
1315     }
1316 }
1317 
1318 // File: contracts/crowdsale/IndividuallyCappedCrowdsale.sol
1319 
1320 pragma solidity ^0.5.0;
1321 
1322 // a single cap applied to all users
1323 
1324 /**
1325  * @title IndividuallyCappedCrowdsale
1326  * @dev Crowdsale with per-beneficiary caps.
1327  */
1328 contract IndividuallyCappedCrowdsale is Crowdsale {
1329     using SafeMath for uint256;
1330 
1331     mapping(address => uint256) private _contributions;
1332     // mapping(address => uint256) private _caps;
1333     uint256 public individualCap;
1334 
1335     constructor(uint256 _individualCap) public {
1336         individualCap = _individualCap;
1337     }
1338 
1339     /**
1340      * @dev Sets a specific beneficiary's maximum contribution.
1341      * @param beneficiary Address to be capped
1342      * @param cap Wei limit for individual contribution
1343      */
1344     // function setCap(address beneficiary, uint256 cap) external onlyCapper {
1345     //     _caps[beneficiary] = cap;
1346     // }
1347 
1348     /**
1349      * @dev Returns the cap of a specific beneficiary.
1350      * @param beneficiary Address whose cap is to be checked
1351      * @return Current cap for individual beneficiary
1352      */
1353     // function getCap(address beneficiary) public view returns (uint256) {
1354         // return _caps[beneficiary];
1355     // }
1356 
1357     /**
1358      * @dev Returns the amount contributed so far by a specific beneficiary.
1359      * @param beneficiary Address of contributor
1360      * @return Beneficiary contribution so far
1361      */
1362     function getContribution(address beneficiary) public view returns (uint256) {
1363         return _contributions[beneficiary];
1364     }
1365 
1366     /**
1367      * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
1368      * @param beneficiary Token purchaser
1369      * @param weiAmount Amount of wei contributed
1370      */
1371     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1372         super._preValidatePurchase(beneficiary, weiAmount);
1373         // solhint-disable-next-line max-line-length
1374         // require(_contributions[beneficiary].add(weiAmount) <= _caps[beneficiary], "IndividuallyCappedCrowdsale: beneficiary's cap exceeded");
1375         require(_contributions[beneficiary].add(weiAmount) <= individualCap, "IndividuallyCappedCrowdsale: beneficiary's cap exceeded");
1376     }
1377 
1378     /**
1379      * @dev Extend parent behavior to update beneficiary contributions.
1380      * @param beneficiary Token purchaser
1381      * @param weiAmount Amount of wei contributed
1382      */
1383     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
1384         super._updatePurchasingState(beneficiary, weiAmount);
1385         _contributions[beneficiary] = _contributions[beneficiary].add(weiAmount);
1386     }
1387 }
1388 
1389 // File: contracts/crowdsale/IncreasingPriceCrowdsale.sol
1390 
1391 pragma solidity ^0.5.0;
1392 
1393 /**
1394  * @title IncreasingPriceCrowdsale
1395  * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
1396  * Note that what should be provided to the constructor is the initial and final _rates_, that is,
1397  * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
1398  */
1399 contract IncreasingPriceCrowdsale is TimedCrowdsale {
1400     using SafeMath for uint256;
1401 
1402     // uint256 private _initialRate;
1403     uint256 private _finalRate;
1404 
1405     address public referrers;
1406 
1407     /**
1408      * @dev Constructor, takes initial and final rates of tokens received per wei contributed.
1409      * @param finalRate Number of tokens a buyer gets per wei at the end of the crowdsale
1410      */
1411     constructor (uint256 finalRate, address _referrers) public {
1412         require(finalRate > 0, "IncreasingPriceCrowdsale: final rate is 0");
1413         // solhint-disable-next-line max-line-length
1414         _finalRate = finalRate;
1415         referrers = _referrers;
1416     }
1417 
1418     function isReferrer(address _address) public view returns (bool) {
1419         if (referrers == address(0)) {
1420             return false;
1421         }
1422         return IReferrers(referrers).isReferrer(_address);
1423     }
1424 
1425     /**
1426      * The base rate function is overridden to revert, since this crowdsale doesn't use it, and
1427      * all calls to it are a mistake.
1428      */
1429     function rate() public view returns (uint256) {
1430         revert("IncreasingPriceCrowdsale: rate() called");
1431     }
1432 
1433 
1434     // function initialRate() public view returns (uint256) {
1435     //     return _initialRate;
1436     // }
1437 
1438     /**
1439      * @return the final rate of the crowdsale.
1440      */
1441     function finalRate() public view returns (uint256) {
1442         return _finalRate;
1443     }
1444 
1445     /**
1446      * @dev Returns the rate of tokens per wei at the present time.
1447      * Note that, as price _increases_ with time, the rate _decreases_.
1448      * @return The number of tokens a buyer gets per wei at a given time
1449      */
1450     function getCurrentRate() public view returns (uint256) {
1451         if (!isOpen()) {
1452             return 0;
1453         }
1454 
1455         uint256 _weiRaised = weiRaised();
1456         uint256 _rate = _finalRate;
1457 
1458         if (isReferrer(msg.sender)) {
1459             _rate = _rate.mul(125).div(100);
1460         }
1461 
1462         if (_weiRaised < 15e18) {
1463             return _rate.mul(250).div(100);
1464         }
1465         if (_weiRaised < 30e18) {
1466             return _rate.mul(200).div(100);
1467         }
1468         if (_weiRaised < 45e18) {
1469             return _rate.mul(175).div(100);
1470         }
1471         if (_weiRaised < 75e18) {
1472             return _rate.mul(150).div(100);
1473         }
1474         if (_weiRaised < 105e18) {
1475             return _rate.mul(120).div(100);
1476         }
1477         if (_weiRaised < 135e18) {
1478             return _rate.mul(110).div(100);
1479         }
1480         if (_weiRaised < 165e18) {
1481             return _rate.mul(105).div(100);
1482         }
1483         return _rate;
1484     }
1485 
1486     /**
1487      * @dev Overrides parent method taking into account variable rate.
1488      * @param weiAmount The value in wei to be converted into tokens
1489      * @return The number of tokens _weiAmount wei will buy at present time
1490      */
1491     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
1492         uint256 currentRate = getCurrentRate();
1493         return currentRate.mul(weiAmount);
1494     }
1495 }
1496 
1497 interface IReferrers {
1498     function isReferrer(address _address) external view returns (bool);
1499 }
1500 
1501 // File: @openzeppelin/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
1502 
1503 pragma solidity ^0.5.0;
1504 
1505 /**
1506  * @title FinalizableCrowdsale
1507  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
1508  * can do extra work after finishing.
1509  */
1510 contract FinalizableCrowdsale is TimedCrowdsale {
1511     using SafeMath for uint256;
1512 
1513     bool private _finalized;
1514 
1515     event CrowdsaleFinalized();
1516 
1517     constructor () internal {
1518         _finalized = false;
1519     }
1520 
1521     /**
1522      * @return true if the crowdsale is finalized, false otherwise.
1523      */
1524     function finalized() public view returns (bool) {
1525         return _finalized;
1526     }
1527 
1528     /**
1529      * @dev Must be called after crowdsale ends, to do some extra finalization
1530      * work. Calls the contract's finalization function.
1531      */
1532     function finalize() public {
1533         require(!_finalized, "FinalizableCrowdsale: already finalized");
1534         require(hasClosed(), "FinalizableCrowdsale: not closed");
1535 
1536         _finalized = true;
1537 
1538         _finalization();
1539         emit CrowdsaleFinalized();
1540     }
1541 
1542     /**
1543      * @dev Can be overridden to add finalization logic. The overriding function
1544      * should call super._finalization() to ensure the chain of finalization is
1545      * executed entirely.
1546      */
1547     function _finalization() internal {
1548         // solhint-disable-previous-line no-empty-blocks
1549     }
1550 }
1551 
1552 // File: contracts/crowdsale/TokenTimelock.sol
1553 
1554 pragma solidity ^0.5.0;
1555 
1556 // a progressively unlocking timelock
1557 
1558 /**
1559  * @dev A token holder contract that will allow a beneficiary to extract the
1560  * tokens after a given release time.
1561  *
1562  * Useful for simple vesting schedules like "advisors get all of their tokens
1563  * after 1 year".
1564  *
1565  * For a more complete vesting schedule, see {TokenVesting}.
1566  */
1567 contract TokenTimelock {
1568     using SafeMath for uint256;
1569     using SafeERC20 for IERC20;
1570 
1571     // ERC20 basic token contract being held
1572     IERC20 private _token;
1573 
1574     // beneficiary of tokens after they are released
1575     address private _beneficiary;
1576 
1577     // timestamp when token release is enabled
1578     uint256 private _releaseTime;
1579 
1580     // timestamp when tokens were locked
1581     uint256 public startTime = block.timestamp;
1582 
1583     // how many tokens have been released so far
1584     uint256 public totalReleased;
1585 
1586     // how many tokens to lock initially
1587     uint256 public startLockedBalance;
1588 
1589     constructor (IERC20 token, address beneficiary, uint256 releaseTime, uint256 _startLockedBalance) public {
1590         // solhint-disable-next-line not-rely-on-time
1591         require(releaseTime > block.timestamp, "TokenTimelock: release time is before current time");
1592         _token = token;
1593         _beneficiary = beneficiary;
1594         _releaseTime = releaseTime;
1595         startLockedBalance = _startLockedBalance;
1596     }
1597 
1598     /**
1599      * @return the token being held.
1600      */
1601     function token() public view returns (IERC20) {
1602         return _token;
1603     }
1604 
1605     /**
1606      * @return the beneficiary of the tokens.
1607      */
1608     function beneficiary() public view returns (address) {
1609         return _beneficiary;
1610     }
1611 
1612     /**
1613      * @return the time when 100% of the tokens can be released.
1614      */
1615     function releaseTime() public view returns (uint256) {
1616         return _releaseTime;
1617     }
1618 
1619     // how much can be released right now
1620     function releasable() public view returns (uint256) {
1621         uint256 totalLockTime = _releaseTime.sub(startTime);
1622         uint256 timeElapsed = block.timestamp.sub(startTime);
1623         uint256 percentTimeElapsed = timeElapsed.mul(100).div(totalLockTime);
1624         uint256 startLockedBalanceReleasable = startLockedBalance.mul(percentTimeElapsed).div(100);
1625         uint256 balanceReleasable = startLockedBalanceReleasable.sub(totalReleased);
1626         uint256 balance = _token.balanceOf(address(this));
1627         // will occur after release time has passed
1628         if (balanceReleasable > balance) {
1629             return balance;
1630         }
1631         return balanceReleasable;
1632     }
1633 
1634     /**
1635      * @notice Transfers tokens held by timelock to beneficiary.
1636      */
1637     function release() public {
1638         uint256 balanceReleasable = releasable();
1639         require(balanceReleasable > 0, "TokenTimelock: no tokens to release");
1640         totalReleased = totalReleased + balanceReleasable;
1641         _token.safeTransfer(_beneficiary, balanceReleasable);
1642     }
1643 }
1644 
1645 // File: contracts/crowdsale/TreasuryCrowdsale.sol
1646 
1647 pragma solidity ^0.5.0;
1648 
1649 contract TreasuryCrowdsale is FinalizableCrowdsale {
1650     using SafeMath for uint256;
1651 
1652     TokenTimelock public treasuryTimelock;
1653 
1654     // mint treasury supply a single time after finalization (~3% unlocked, ~20% locked for 5 years)
1655     function _finalization() internal {
1656         uint256 treasuryAmountUnlocked = token().totalSupply().mul(4).div(100);
1657         uint256 treasuryAmountLocked = token().totalSupply().mul(25).div(100);
1658         treasuryTimelock = new TokenTimelock(
1659             token(),
1660             wallet(),
1661             block.timestamp.add(60 * 60 * 24 * 365 * 5), // 5 years
1662             treasuryAmountLocked
1663         );
1664         ERC20Mintable(address(token())).mint(wallet(), treasuryAmountUnlocked);
1665         ERC20Mintable(address(token())).mint(address(treasuryTimelock), treasuryAmountLocked);
1666         super._finalization();
1667     }
1668 }
1669 
1670 // File: contracts/Sav3Crowdsale.sol
1671 
1672 pragma solidity ^0.5.17;
1673 
1674 contract Sav3Crowdsale is 
1675     Crowdsale, 
1676     MintedCrowdsale, 
1677     WhitelistCrowdsale, 
1678     TimedCrowdsale, 
1679     PostDeliveryCrowdsale, 
1680     IndividuallyCappedCrowdsale, 
1681     IncreasingPriceCrowdsale,
1682     TreasuryCrowdsale
1683 {
1684     uint256 private _finalRate = 10000;
1685     uint256 private _individualCap = 3e18;
1686     constructor(
1687         address payable crowdsaleWallet, 
1688         IERC20 token,
1689         uint256 openingTime, 
1690         uint256 closingTime, 
1691         address whitelister,
1692         address referrers
1693     )
1694         TreasuryCrowdsale()
1695         WhitelistCrowdsale(whitelister)
1696         IncreasingPriceCrowdsale(_finalRate, referrers)
1697         PostDeliveryCrowdsale()
1698         TimedCrowdsale(openingTime, closingTime)
1699         IndividuallyCappedCrowdsale(_individualCap)
1700         MintedCrowdsale()
1701         Crowdsale(_finalRate, crowdsaleWallet, token)
1702         public
1703     {}
1704 }