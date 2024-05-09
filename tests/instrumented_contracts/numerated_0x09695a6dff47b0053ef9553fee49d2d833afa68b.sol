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
477 // File: @openzeppelin/contracts/crowdsale/Crowdsale.sol
478 
479 pragma solidity ^0.5.0;
480 
481 
482 
483 
484 
485 
486 /**
487  * @title Crowdsale
488  * @dev Crowdsale is a base contract for managing a token crowdsale,
489  * allowing investors to purchase tokens with ether. This contract implements
490  * such functionality in its most fundamental form and can be extended to provide additional
491  * functionality and/or custom behavior.
492  * The external interface represents the basic interface for purchasing tokens, and conforms
493  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
494  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
495  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
496  * behavior.
497  */
498 contract Crowdsale is Context, ReentrancyGuard {
499     using SafeMath for uint256;
500     using SafeERC20 for IERC20;
501 
502     // The token being sold
503     IERC20 private _token;
504 
505     // Address where funds are collected
506     address payable private _wallet;
507 
508     // How many token units a buyer gets per wei.
509     // The rate is the conversion between wei and the smallest and indivisible token unit.
510     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
511     // 1 wei will give you 1 unit, or 0.001 TOK.
512     uint256 private _rate;
513 
514     // Amount of wei raised
515     uint256 private _weiRaised;
516 
517     /**
518      * Event for token purchase logging
519      * @param purchaser who paid for the tokens
520      * @param beneficiary who got the tokens
521      * @param value weis paid for purchase
522      * @param amount amount of tokens purchased
523      */
524     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
525 
526     /**
527      * @param rate Number of token units a buyer gets per wei
528      * @dev The rate is the conversion between wei and the smallest and indivisible
529      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
530      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
531      * @param wallet Address where collected funds will be forwarded to
532      * @param token Address of the token being sold
533      */
534     constructor (uint256 rate, address payable wallet, IERC20 token) public {
535         require(rate > 0, "Crowdsale: rate is 0");
536         require(wallet != address(0), "Crowdsale: wallet is the zero address");
537         require(address(token) != address(0), "Crowdsale: token is the zero address");
538 
539         _rate = rate;
540         _wallet = wallet;
541         _token = token;
542     }
543 
544     /**
545      * @dev fallback function ***DO NOT OVERRIDE***
546      * Note that other contracts will transfer funds with a base gas stipend
547      * of 2300, which is not enough to call buyTokens. Consider calling
548      * buyTokens directly when purchasing tokens from a contract.
549      */
550     function () external payable {
551         buyTokens(_msgSender());
552     }
553 
554     /**
555      * @return the token being sold.
556      */
557     function token() public view returns (IERC20) {
558         return _token;
559     }
560 
561     /**
562      * @return the address where funds are collected.
563      */
564     function wallet() public view returns (address payable) {
565         return _wallet;
566     }
567 
568     /**
569      * @return the number of token units a buyer gets per wei.
570      */
571     function rate() public view returns (uint256) {
572         return _rate;
573     }
574 
575     /**
576      * @return the amount of wei raised.
577      */
578     function weiRaised() public view returns (uint256) {
579         return _weiRaised;
580     }
581 
582     /**
583      * @dev low level token purchase ***DO NOT OVERRIDE***
584      * This function has a non-reentrancy guard, so it shouldn't be called by
585      * another `nonReentrant` function.
586      * @param beneficiary Recipient of the token purchase
587      */
588     function buyTokens(address beneficiary) public nonReentrant payable {
589         uint256 weiAmount = msg.value;
590         _preValidatePurchase(beneficiary, weiAmount);
591 
592         // calculate token amount to be created
593         uint256 tokens = _getTokenAmount(weiAmount);
594 
595         // update state
596         _weiRaised = _weiRaised.add(weiAmount);
597 
598         _processPurchase(beneficiary, tokens);
599         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
600 
601         _updatePurchasingState(beneficiary, weiAmount);
602 
603         _forwardFunds();
604         _postValidatePurchase(beneficiary, weiAmount);
605     }
606 
607     /**
608      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
609      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
610      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
611      *     super._preValidatePurchase(beneficiary, weiAmount);
612      *     require(weiRaised().add(weiAmount) <= cap);
613      * @param beneficiary Address performing the token purchase
614      * @param weiAmount Value in wei involved in the purchase
615      */
616     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
617         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
618         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
619         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
620     }
621 
622     /**
623      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
624      * conditions are not met.
625      * @param beneficiary Address performing the token purchase
626      * @param weiAmount Value in wei involved in the purchase
627      */
628     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
629         // solhint-disable-previous-line no-empty-blocks
630     }
631 
632     /**
633      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
634      * its tokens.
635      * @param beneficiary Address performing the token purchase
636      * @param tokenAmount Number of tokens to be emitted
637      */
638     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
639         _token.safeTransfer(beneficiary, tokenAmount);
640     }
641 
642     /**
643      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
644      * tokens.
645      * @param beneficiary Address receiving the tokens
646      * @param tokenAmount Number of tokens to be purchased
647      */
648     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
649         _deliverTokens(beneficiary, tokenAmount);
650     }
651 
652     /**
653      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
654      * etc.)
655      * @param beneficiary Address receiving the tokens
656      * @param weiAmount Value in wei involved in the purchase
657      */
658     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
659         // solhint-disable-previous-line no-empty-blocks
660     }
661 
662     /**
663      * @dev Override to extend the way in which ether is converted to tokens.
664      * @param weiAmount Value in wei to be converted into tokens
665      * @return Number of tokens that can be purchased with the specified _weiAmount
666      */
667     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
668         return weiAmount.mul(_rate);
669     }
670 
671     /**
672      * @dev Determines how ETH is stored/forwarded on purchases.
673      */
674     function _forwardFunds() internal {
675         _wallet.transfer(msg.value);
676     }
677 }
678 
679 // File: @openzeppelin/contracts/math/Math.sol
680 
681 pragma solidity ^0.5.0;
682 
683 /**
684  * @dev Standard math utilities missing in the Solidity language.
685  */
686 library Math {
687     /**
688      * @dev Returns the largest of two numbers.
689      */
690     function max(uint256 a, uint256 b) internal pure returns (uint256) {
691         return a >= b ? a : b;
692     }
693 
694     /**
695      * @dev Returns the smallest of two numbers.
696      */
697     function min(uint256 a, uint256 b) internal pure returns (uint256) {
698         return a < b ? a : b;
699     }
700 
701     /**
702      * @dev Returns the average of two numbers. The result is rounded towards
703      * zero.
704      */
705     function average(uint256 a, uint256 b) internal pure returns (uint256) {
706         // (a + b) / 2 can overflow, so we distribute
707         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
708     }
709 }
710 
711 // File: @openzeppelin/contracts/crowdsale/emission/AllowanceCrowdsale.sol
712 
713 pragma solidity ^0.5.0;
714 
715 
716 
717 
718 
719 
720 /**
721  * @title AllowanceCrowdsale
722  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
723  */
724 contract AllowanceCrowdsale is Crowdsale {
725     using SafeMath for uint256;
726     using SafeERC20 for IERC20;
727 
728     address private _tokenWallet;
729 
730     /**
731      * @dev Constructor, takes token wallet address.
732      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale.
733      */
734     constructor (address tokenWallet) public {
735         require(tokenWallet != address(0), "AllowanceCrowdsale: token wallet is the zero address");
736         _tokenWallet = tokenWallet;
737     }
738 
739     /**
740      * @return the address of the wallet that will hold the tokens.
741      */
742     function tokenWallet() public view returns (address) {
743         return _tokenWallet;
744     }
745 
746     /**
747      * @dev Checks the amount of tokens left in the allowance.
748      * @return Amount of tokens left in the allowance
749      */
750     function remainingTokens() public view returns (uint256) {
751         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
752     }
753 
754     /**
755      * @dev Overrides parent behavior by transferring tokens from wallet.
756      * @param beneficiary Token purchaser
757      * @param tokenAmount Amount of tokens purchased
758      */
759     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
760         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
761     }
762 }
763 
764 // File: @openzeppelin/contracts/crowdsale/validation/CappedCrowdsale.sol
765 
766 pragma solidity ^0.5.0;
767 
768 
769 
770 /**
771  * @title CappedCrowdsale
772  * @dev Crowdsale with a limit for total contributions.
773  */
774 contract CappedCrowdsale is Crowdsale {
775     using SafeMath for uint256;
776 
777     uint256 private _cap;
778 
779     /**
780      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
781      * @param cap Max amount of wei to be contributed
782      */
783     constructor (uint256 cap) public {
784         require(cap > 0, "CappedCrowdsale: cap is 0");
785         _cap = cap;
786     }
787 
788     /**
789      * @return the cap of the crowdsale.
790      */
791     function cap() public view returns (uint256) {
792         return _cap;
793     }
794 
795     /**
796      * @dev Checks whether the cap has been reached.
797      * @return Whether the cap was reached
798      */
799     function capReached() public view returns (bool) {
800         return weiRaised() >= _cap;
801     }
802 
803     /**
804      * @dev Extend parent behavior requiring purchase to respect the funding cap.
805      * @param beneficiary Token purchaser
806      * @param weiAmount Amount of wei contributed
807      */
808     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
809         super._preValidatePurchase(beneficiary, weiAmount);
810         require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
811     }
812 }
813 
814 // File: @openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol
815 
816 pragma solidity ^0.5.0;
817 
818 
819 
820 /**
821  * @title TimedCrowdsale
822  * @dev Crowdsale accepting contributions only within a time frame.
823  */
824 contract TimedCrowdsale is Crowdsale {
825     using SafeMath for uint256;
826 
827     uint256 private _openingTime;
828     uint256 private _closingTime;
829 
830     /**
831      * Event for crowdsale extending
832      * @param newClosingTime new closing time
833      * @param prevClosingTime old closing time
834      */
835     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
836 
837     /**
838      * @dev Reverts if not in crowdsale time range.
839      */
840     modifier onlyWhileOpen {
841         require(isOpen(), "TimedCrowdsale: not open");
842         _;
843     }
844 
845     /**
846      * @dev Constructor, takes crowdsale opening and closing times.
847      * @param openingTime Crowdsale opening time
848      * @param closingTime Crowdsale closing time
849      */
850     constructor (uint256 openingTime, uint256 closingTime) public {
851         // solhint-disable-next-line not-rely-on-time
852         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
853         // solhint-disable-next-line max-line-length
854         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
855 
856         _openingTime = openingTime;
857         _closingTime = closingTime;
858     }
859 
860     /**
861      * @return the crowdsale opening time.
862      */
863     function openingTime() public view returns (uint256) {
864         return _openingTime;
865     }
866 
867     /**
868      * @return the crowdsale closing time.
869      */
870     function closingTime() public view returns (uint256) {
871         return _closingTime;
872     }
873 
874     /**
875      * @return true if the crowdsale is open, false otherwise.
876      */
877     function isOpen() public view returns (bool) {
878         // solhint-disable-next-line not-rely-on-time
879         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
880     }
881 
882     /**
883      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
884      * @return Whether crowdsale period has elapsed
885      */
886     function hasClosed() public view returns (bool) {
887         // solhint-disable-next-line not-rely-on-time
888         return block.timestamp > _closingTime;
889     }
890 
891     /**
892      * @dev Extend parent behavior requiring to be within contributing period.
893      * @param beneficiary Token purchaser
894      * @param weiAmount Amount of wei contributed
895      */
896     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
897         super._preValidatePurchase(beneficiary, weiAmount);
898     }
899 
900     /**
901      * @dev Extend crowdsale.
902      * @param newClosingTime Crowdsale closing time
903      */
904     function _extendTime(uint256 newClosingTime) internal {
905         require(!hasClosed(), "TimedCrowdsale: already closed");
906         // solhint-disable-next-line max-line-length
907         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
908 
909         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
910         _closingTime = newClosingTime;
911     }
912 }
913 
914 // File: @openzeppelin/contracts/ownership/Ownable.sol
915 
916 pragma solidity ^0.5.0;
917 
918 /**
919  * @dev Contract module which provides a basic access control mechanism, where
920  * there is an account (an owner) that can be granted exclusive access to
921  * specific functions.
922  *
923  * This module is used through inheritance. It will make available the modifier
924  * `onlyOwner`, which can be applied to your functions to restrict their use to
925  * the owner.
926  */
927 contract Ownable is Context {
928     address private _owner;
929 
930     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
931 
932     /**
933      * @dev Initializes the contract setting the deployer as the initial owner.
934      */
935     constructor () internal {
936         address msgSender = _msgSender();
937         _owner = msgSender;
938         emit OwnershipTransferred(address(0), msgSender);
939     }
940 
941     /**
942      * @dev Returns the address of the current owner.
943      */
944     function owner() public view returns (address) {
945         return _owner;
946     }
947 
948     /**
949      * @dev Throws if called by any account other than the owner.
950      */
951     modifier onlyOwner() {
952         require(isOwner(), "Ownable: caller is not the owner");
953         _;
954     }
955 
956     /**
957      * @dev Returns true if the caller is the current owner.
958      */
959     function isOwner() public view returns (bool) {
960         return _msgSender() == _owner;
961     }
962 
963     /**
964      * @dev Leaves the contract without owner. It will not be possible to call
965      * `onlyOwner` functions anymore. Can only be called by the current owner.
966      *
967      * NOTE: Renouncing ownership will leave the contract without an owner,
968      * thereby removing any functionality that is only available to the owner.
969      */
970     function renounceOwnership() public onlyOwner {
971         emit OwnershipTransferred(_owner, address(0));
972         _owner = address(0);
973     }
974 
975     /**
976      * @dev Transfers ownership of the contract to a new account (`newOwner`).
977      * Can only be called by the current owner.
978      */
979     function transferOwnership(address newOwner) public onlyOwner {
980         _transferOwnership(newOwner);
981     }
982 
983     /**
984      * @dev Transfers ownership of the contract to a new account (`newOwner`).
985      */
986     function _transferOwnership(address newOwner) internal {
987         require(newOwner != address(0), "Ownable: new owner is the zero address");
988         emit OwnershipTransferred(_owner, newOwner);
989         _owner = newOwner;
990     }
991 }
992 
993 // File: @openzeppelin/contracts/ownership/Secondary.sol
994 
995 pragma solidity ^0.5.0;
996 
997 /**
998  * @dev A Secondary contract can only be used by its primary account (the one that created it).
999  */
1000 contract Secondary is Context {
1001     address private _primary;
1002 
1003     /**
1004      * @dev Emitted when the primary contract changes.
1005      */
1006     event PrimaryTransferred(
1007         address recipient
1008     );
1009 
1010     /**
1011      * @dev Sets the primary account to the one that is creating the Secondary contract.
1012      */
1013     constructor () internal {
1014         address msgSender = _msgSender();
1015         _primary = msgSender;
1016         emit PrimaryTransferred(msgSender);
1017     }
1018 
1019     /**
1020      * @dev Reverts if called from any account other than the primary.
1021      */
1022     modifier onlyPrimary() {
1023         require(_msgSender() == _primary, "Secondary: caller is not the primary account");
1024         _;
1025     }
1026 
1027     /**
1028      * @return the address of the primary.
1029      */
1030     function primary() public view returns (address) {
1031         return _primary;
1032     }
1033 
1034     /**
1035      * @dev Transfers contract to a new primary.
1036      * @param recipient The address of new primary.
1037      */
1038     function transferPrimary(address recipient) public onlyPrimary {
1039         require(recipient != address(0), "Secondary: new primary is the zero address");
1040         _primary = recipient;
1041         emit PrimaryTransferred(recipient);
1042     }
1043 }
1044 
1045 // File: contracts/sale/GraphSale.sol
1046 
1047 pragma solidity ^0.5.17;
1048 
1049 
1050 
1051 
1052 
1053 
1054 contract GraphSale is Ownable, AllowanceCrowdsale, CappedCrowdsale, TimedCrowdsale {
1055     using SafeMath for uint256;
1056 
1057     enum Phase { NotStarted, One, Two, Three, Closed }
1058     enum AllowStatus {
1059         Disallowed,
1060         Phase1Cap1,
1061         Phase1Cap2,
1062         Phase1Cap3,
1063         Phase1Cap4,
1064         Phase2Cap1,
1065         Phase2Cap2,
1066         Phase2Cap3,
1067         Phase2Cap4
1068     }
1069 
1070     uint256 private constant MAX_UINT = 2**256 - 1;
1071 
1072     // -- State --
1073 
1074     uint256 private _maxGasPriceWei;
1075 
1076     // Allow list
1077     mapping(address => AllowStatus) private _allowList;
1078 
1079     // Account capping
1080     uint256[4] private _capsPerAccount; // Contribution caps that are assigned to each account
1081     mapping(address => uint256) private _contributions; // Contributions from an account
1082 
1083     // Time conditions
1084     uint256 private _openingTimePhase2; // opening time (phase2) in unix epoch seconds
1085     uint256 private _openingTimePhase3; // opening time (phase3) in unix epoch seconds
1086 
1087     // Post delivery
1088     mapping(address => uint256) private _balances;
1089     __unstable__TokenVault private _vault;
1090 
1091     // -- Events --
1092 
1093     event AllowListUpdated(address indexed account, AllowStatus value);
1094 
1095     event GraphSaleDeployed(
1096         uint256 rate, // rate, in TKNbits
1097         address payable wallet, // wallet to send Ether
1098         address tokenWallet, // wallet to pull tokens
1099         IERC20 token, // the token
1100         uint256 cap, // total cap, in wei
1101         uint256 capPerAccount1, // limit for individual contribution, in wei
1102         uint256 capPerAccount2, // limit for individual contribution, in wei
1103         uint256 capPerAccount3, // limit for individual contribution, in wei
1104         uint256 capPerAccount4, // limit for individual contribution, in wei
1105         uint256 openingTimePhase1, // opening time (phase1) in unix epoch seconds
1106         uint256 openingTimePhase2, // opening time (phase2) in unix epoch seconds
1107         uint256 openingTimePhase3, // opening time (phase3) in unix epoch seconds
1108         uint256 closingTime, // closing time in unix epoch seconds
1109         uint256 maxGasPriceWei // max gas price allowed for purchase transacctions (in wei)
1110     );
1111 
1112     event MaxGasPriceUpdated(uint256 maxGasPriceWei);
1113 
1114     event CapsPerAccount(
1115         uint256 capPerAccount1,
1116         uint256 capPerAccount2,
1117         uint256 capPerAccount3,
1118         uint256 capPerAccount4
1119     );
1120 
1121     /**
1122      * @dev Constructor.
1123      */
1124     constructor(
1125         uint256 rate, // rate, in TKNbits
1126         address payable wallet, // wallet to send Ether
1127         address tokenWallet, // wallet to pull tokens
1128         IERC20 token, // the token
1129         uint256 cap, // total cap, in wei
1130         uint256[4] memory capsPerAccount,
1131         uint256 openingTimePhase1, // opening time (phase1) in unix epoch seconds
1132         uint256 openingTimePhase2, // opening time (phase2) in unix epoch seconds
1133         uint256 openingTimePhase3, // opening time (phase3) in unix epoch seconds
1134         uint256 closingTime, // closing time in unix epoch seconds
1135         uint256 maxGasPriceWei // max gas price allowed for transactions (wei)
1136     )
1137         public
1138         Crowdsale(rate, wallet, token)
1139         CappedCrowdsale(cap)
1140         TimedCrowdsale(openingTimePhase1, closingTime)
1141         AllowanceCrowdsale(tokenWallet)
1142     {
1143         require(
1144             openingTimePhase2 > openingTimePhase1,
1145             "PhasedCrowdsale: phase2 must be after phase1"
1146         );
1147         require(
1148             openingTimePhase3 > openingTimePhase2,
1149             "PhasedCrowdsale: phase3 must be after phase2"
1150         );
1151         require(
1152             closingTime > openingTimePhase3,
1153             "PhasedCrowdsale: closing time must be after phase3"
1154         );
1155 
1156         require(maxGasPriceWei > 0, "Gas price cannot be zero");
1157 
1158         _setCapsPerAccount(capsPerAccount);
1159         _setMaxGasPrice(maxGasPriceWei);
1160 
1161         _openingTimePhase2 = openingTimePhase2;
1162         _openingTimePhase3 = openingTimePhase3;
1163         _vault = new __unstable__TokenVault();
1164 
1165         emit GraphSaleDeployed(
1166             rate,
1167             wallet,
1168             tokenWallet,
1169             token,
1170             cap,
1171             _capsPerAccount[0],
1172             _capsPerAccount[1],
1173             _capsPerAccount[2],
1174             _capsPerAccount[3],
1175             openingTimePhase1,
1176             openingTimePhase2,
1177             openingTimePhase3,
1178             closingTime,
1179             maxGasPriceWei
1180         );
1181     }
1182 
1183     // -- Configuration --
1184 
1185     /**
1186      * @dev Set the max allowed gas price for purchase transactions.
1187      * @param maxGasPriceWei Amount of wei to be used as max gas price.
1188      */
1189     function setMaxGasPrice(uint256 maxGasPriceWei) external onlyOwner {
1190         _setMaxGasPrice(maxGasPriceWei);
1191     }
1192 
1193     /**
1194      * @dev Internal: Set the max allowed gas price for purchase transactions.
1195      * @param maxGasPriceWei Amount of wei to be used as max gas price.
1196      */
1197     function _setMaxGasPrice(uint256 maxGasPriceWei) internal {
1198         require(maxGasPriceWei > 0, "Gas price cannot be zero");
1199         _maxGasPriceWei = maxGasPriceWei;
1200         emit MaxGasPriceUpdated(_maxGasPriceWei);
1201     }
1202 
1203     /**
1204      * @dev Get the max allowed gas price for purchase transactions.
1205      * @return Maximum gas price allowed for purchase transactions.
1206      */
1207     function maxGasPrice() public view returns (uint256) {
1208         return _maxGasPriceWei;
1209     }
1210 
1211     // -- Phases --
1212 
1213     function openingTimePhase2() public view returns (uint256) {
1214         return _openingTimePhase2;
1215     }
1216 
1217     function openingTimePhase3() public view returns (uint256) {
1218         return _openingTimePhase3;
1219     }
1220 
1221     /**
1222      * @dev Returns the current sale phase.
1223      * @return Phase
1224      */
1225     function getCurrentPhase() public view returns (Phase) {
1226         uint256 current = block.timestamp;
1227         if (current >= openingTime() && current < _openingTimePhase2) {
1228             return Phase.One;
1229         }
1230         if (current >= _openingTimePhase2 && current < _openingTimePhase3) {
1231             return Phase.Two;
1232         }
1233         if (current >= _openingTimePhase3 && current < closingTime()) {
1234             return Phase.Three;
1235         }
1236         if (current >= closingTime()) {
1237             return Phase.Closed;
1238         }
1239         return Phase.NotStarted;
1240     }
1241 
1242     // -- Allowlist --
1243 
1244     /**
1245      * @dev Return the allow status of an account.
1246      * @param account Address to check.
1247      */
1248     function getAllowStatus(address account) public view returns (AllowStatus) {
1249         return _allowList[account];
1250     }
1251 
1252     /**
1253      * @dev Return true if the account is authorized to participate in the crowdsale.
1254      * @param account Address to check.
1255      */
1256     function isAllowed(address account) public view returns (bool) {
1257         return getAllowStatus(account) != AllowStatus.Disallowed;
1258     }
1259 
1260     /**
1261      * @dev Return true if the account is currently allowed to participate.
1262      * @param account Address to check.
1263      */
1264     function isCurrentPhaseAllowed(address account) public view returns (bool) {
1265         AllowStatus status = _allowList[account];
1266         Phase phase = getCurrentPhase();
1267 
1268         // Only priority accounts can participate in Phase1
1269         if (phase == Phase.One) {
1270             return
1271                 status == AllowStatus.Phase1Cap1 ||
1272                 status == AllowStatus.Phase1Cap2 ||
1273                 status == AllowStatus.Phase1Cap3 ||
1274                 status == AllowStatus.Phase1Cap4;
1275         }
1276 
1277         // After Phase1 anyone in the allowlist can participate
1278         if (phase == Phase.Two || phase == Phase.Three) {
1279             return status != AllowStatus.Disallowed;
1280         }
1281 
1282         return false;
1283     }
1284 
1285     /**
1286      * @dev Set multiple accounts to the allowlist.
1287      * @param accounts Addresses to load on the allowlist.
1288      */
1289     function setAllowListMany(address[] calldata accounts, AllowStatus status) external onlyOwner {
1290         for (uint256 i = 0; i < accounts.length; i++) {
1291             _allowList[accounts[i]] = status;
1292             emit AllowListUpdated(accounts[i], status);
1293         }
1294     }
1295 
1296     // -- Account Capping --
1297 
1298     /**
1299      * @dev Returns the cap of individual beneficiary at the current phase.
1300      * @return Current cap for individual beneficiary
1301      */
1302     function getCapPerAccount(address account) public view returns (uint256) {
1303         AllowStatus status = _allowList[account];
1304 
1305         // Return the cap only if allowed to participate in current phase
1306         if (isCurrentPhaseAllowed(account)) {
1307             // No cap on Phase 3 regardless of account
1308             if (getCurrentPhase() == Phase.Three) {
1309                 return MAX_UINT;
1310             }
1311 
1312             // cap1
1313             if (status == AllowStatus.Phase1Cap1 || status == AllowStatus.Phase2Cap1) {
1314                 return _capsPerAccount[0];
1315             }
1316             // cap2
1317             if (status == AllowStatus.Phase1Cap2 || status == AllowStatus.Phase2Cap2) {
1318                 return _capsPerAccount[1];
1319             }
1320             // cap3
1321             if (status == AllowStatus.Phase1Cap3 || status == AllowStatus.Phase2Cap3) {
1322                 return _capsPerAccount[2];
1323             }
1324             // cap4
1325             if (status == AllowStatus.Phase1Cap4 || status == AllowStatus.Phase2Cap4) {
1326                 return _capsPerAccount[3];
1327             }
1328         }
1329         return 0;
1330     }
1331 
1332     /**
1333      * @dev Sets the maximum contribution of all the individual beneficiaries.
1334      * @param capsPerAccount Array of wei limit for individual contribution for each cap tier
1335      */
1336     function setCapsPerAccount(uint256[4] calldata capsPerAccount) external onlyOwner {
1337         _setCapsPerAccount(capsPerAccount);
1338     }
1339 
1340     /**
1341      * @dev Internal: Sets the maximum contribution of all the individual beneficiaries.
1342      * @param capsPerAccount Array of wei limit for individual contribution for each cap tier
1343      */
1344     function _setCapsPerAccount(uint256[4] memory capsPerAccount) private {
1345         require(block.timestamp < openingTime(), "Can only update before start");
1346         for (uint256 i = 0; i < capsPerAccount.length; i++) {
1347             require(capsPerAccount[i] > 0, "AccountCappedCrowdsale: capPerAccount is 0");
1348         }
1349         require(capsPerAccount[0] > capsPerAccount[1], "Must be cap1 > cap2");
1350         require(capsPerAccount[1] > capsPerAccount[2], "Must be cap2 > cap3");
1351         require(capsPerAccount[2] > capsPerAccount[3], "Must be cap3 > cap4");
1352 
1353         _capsPerAccount = capsPerAccount;
1354 
1355         emit CapsPerAccount(
1356             _capsPerAccount[0],
1357             _capsPerAccount[1],
1358             _capsPerAccount[2],
1359             _capsPerAccount[3]
1360         );
1361     }
1362 
1363     /**
1364      * @dev Returns the maximum contribution for each cap tier.
1365      * @return Maximum contribution per account tier
1366      */
1367     function getCapsPerAccount()
1368         external
1369         view
1370         returns (
1371             uint256,
1372             uint256,
1373             uint256,
1374             uint256
1375         )
1376     {
1377         return (_capsPerAccount[0], _capsPerAccount[1], _capsPerAccount[2], _capsPerAccount[3]);
1378     }
1379 
1380     /**
1381      * @dev Returns the amount contributed so far by a specific beneficiary.
1382      * @param beneficiary Address of contributor
1383      * @return Beneficiary contribution so far
1384      */
1385     function getContribution(address beneficiary) public view returns (uint256) {
1386         return _contributions[beneficiary];
1387     }
1388 
1389     // -- Post Delivery --
1390 
1391     /**
1392      * @return the balance of an account.
1393      */
1394     function balanceOf(address account) public view returns (uint256) {
1395         return _balances[account];
1396     }
1397 
1398     // -- Hooks --
1399 
1400     /**
1401      * @dev Extend parent behavior to update beneficiary contributions.
1402      * @param beneficiary Token purchaser
1403      * @param weiAmount Amount of wei contributed
1404      */
1405     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
1406         super._updatePurchasingState(beneficiary, weiAmount);
1407         _contributions[beneficiary] = _contributions[beneficiary].add(weiAmount);
1408     }
1409 
1410     /**
1411      * @dev Overrides parent by storing due balances, and delivering tokens to the vault instead of the end user. This
1412      * ensures that the tokens will be available by the time they are withdrawn (which may not be the case if
1413      * `_deliverTokens` was called later).
1414      * @param beneficiary Token purchaser
1415      * @param tokenAmount Amount of tokens purchased
1416      */
1417     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
1418         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
1419         _deliverTokens(address(_vault), tokenAmount);
1420     }
1421 
1422     /**
1423      * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
1424      * Extend parent behavior requiring beneficiary to be allowlisted.
1425      * @param beneficiary Token purchaser
1426      * @param weiAmount Amount of wei contributed
1427      */
1428     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1429         require(tx.gasprice <= _maxGasPriceWei, "Gas price over limit");
1430 
1431         super._preValidatePurchase(beneficiary, weiAmount);
1432         require(
1433             isCurrentPhaseAllowed(beneficiary),
1434             "AllowListCrowdsale: beneficiary is not allowed in this phase"
1435         );
1436         require(
1437             _contributions[beneficiary].add(weiAmount) <= getCapPerAccount(beneficiary),
1438             "AccountCappedCrowdsale: beneficiary's cap exceeded"
1439         );
1440     }
1441 }
1442 
1443 /**
1444  * @title __unstable__TokenVault
1445  * @dev Similar to an Escrow for tokens, this contract allows its primary account to spend its tokens as it sees fit.
1446  * This contract is an internal helper for PostDeliveryCrowdsale, and should not be used outside of this context.
1447  */
1448 // solhint-disable-next-line contract-name-camelcase
1449 contract __unstable__TokenVault is Secondary {
1450     function transfer(
1451         IERC20 token,
1452         address to,
1453         uint256 amount
1454     ) public onlyPrimary {
1455         token.transfer(to, amount);
1456     }
1457 }