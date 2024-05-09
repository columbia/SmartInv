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
679 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
680 
681 pragma solidity ^0.5.0;
682 
683 
684 
685 
686 /**
687  * @dev Implementation of the {IERC20} interface.
688  *
689  * This implementation is agnostic to the way tokens are created. This means
690  * that a supply mechanism has to be added in a derived contract using {_mint}.
691  * For a generic mechanism see {ERC20Mintable}.
692  *
693  * TIP: For a detailed writeup see our guide
694  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
695  * to implement supply mechanisms].
696  *
697  * We have followed general OpenZeppelin guidelines: functions revert instead
698  * of returning `false` on failure. This behavior is nonetheless conventional
699  * and does not conflict with the expectations of ERC20 applications.
700  *
701  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
702  * This allows applications to reconstruct the allowance for all accounts just
703  * by listening to said events. Other implementations of the EIP may not emit
704  * these events, as it isn't required by the specification.
705  *
706  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
707  * functions have been added to mitigate the well-known issues around setting
708  * allowances. See {IERC20-approve}.
709  */
710 contract ERC20 is Context, IERC20 {
711     using SafeMath for uint256;
712 
713     mapping (address => uint256) private _balances;
714 
715     mapping (address => mapping (address => uint256)) private _allowances;
716 
717     uint256 private _totalSupply;
718 
719     /**
720      * @dev See {IERC20-totalSupply}.
721      */
722     function totalSupply() public view returns (uint256) {
723         return _totalSupply;
724     }
725 
726     /**
727      * @dev See {IERC20-balanceOf}.
728      */
729     function balanceOf(address account) public view returns (uint256) {
730         return _balances[account];
731     }
732 
733     /**
734      * @dev See {IERC20-transfer}.
735      *
736      * Requirements:
737      *
738      * - `recipient` cannot be the zero address.
739      * - the caller must have a balance of at least `amount`.
740      */
741     function transfer(address recipient, uint256 amount) public returns (bool) {
742         _transfer(_msgSender(), recipient, amount);
743         return true;
744     }
745 
746     /**
747      * @dev See {IERC20-allowance}.
748      */
749     function allowance(address owner, address spender) public view returns (uint256) {
750         return _allowances[owner][spender];
751     }
752 
753     /**
754      * @dev See {IERC20-approve}.
755      *
756      * Requirements:
757      *
758      * - `spender` cannot be the zero address.
759      */
760     function approve(address spender, uint256 amount) public returns (bool) {
761         _approve(_msgSender(), spender, amount);
762         return true;
763     }
764 
765     /**
766      * @dev See {IERC20-transferFrom}.
767      *
768      * Emits an {Approval} event indicating the updated allowance. This is not
769      * required by the EIP. See the note at the beginning of {ERC20};
770      *
771      * Requirements:
772      * - `sender` and `recipient` cannot be the zero address.
773      * - `sender` must have a balance of at least `amount`.
774      * - the caller must have allowance for `sender`'s tokens of at least
775      * `amount`.
776      */
777     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
778         _transfer(sender, recipient, amount);
779         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
780         return true;
781     }
782 
783     /**
784      * @dev Atomically increases the allowance granted to `spender` by the caller.
785      *
786      * This is an alternative to {approve} that can be used as a mitigation for
787      * problems described in {IERC20-approve}.
788      *
789      * Emits an {Approval} event indicating the updated allowance.
790      *
791      * Requirements:
792      *
793      * - `spender` cannot be the zero address.
794      */
795     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
796         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
797         return true;
798     }
799 
800     /**
801      * @dev Atomically decreases the allowance granted to `spender` by the caller.
802      *
803      * This is an alternative to {approve} that can be used as a mitigation for
804      * problems described in {IERC20-approve}.
805      *
806      * Emits an {Approval} event indicating the updated allowance.
807      *
808      * Requirements:
809      *
810      * - `spender` cannot be the zero address.
811      * - `spender` must have allowance for the caller of at least
812      * `subtractedValue`.
813      */
814     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
815         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
816         return true;
817     }
818 
819     /**
820      * @dev Moves tokens `amount` from `sender` to `recipient`.
821      *
822      * This is internal function is equivalent to {transfer}, and can be used to
823      * e.g. implement automatic token fees, slashing mechanisms, etc.
824      *
825      * Emits a {Transfer} event.
826      *
827      * Requirements:
828      *
829      * - `sender` cannot be the zero address.
830      * - `recipient` cannot be the zero address.
831      * - `sender` must have a balance of at least `amount`.
832      */
833     function _transfer(address sender, address recipient, uint256 amount) internal {
834         require(sender != address(0), "ERC20: transfer from the zero address");
835         require(recipient != address(0), "ERC20: transfer to the zero address");
836 
837         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
838         _balances[recipient] = _balances[recipient].add(amount);
839         emit Transfer(sender, recipient, amount);
840     }
841 
842     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
843      * the total supply.
844      *
845      * Emits a {Transfer} event with `from` set to the zero address.
846      *
847      * Requirements
848      *
849      * - `to` cannot be the zero address.
850      */
851     function _mint(address account, uint256 amount) internal {
852         require(account != address(0), "ERC20: mint to the zero address");
853 
854         _totalSupply = _totalSupply.add(amount);
855         _balances[account] = _balances[account].add(amount);
856         emit Transfer(address(0), account, amount);
857     }
858 
859     /**
860      * @dev Destroys `amount` tokens from `account`, reducing the
861      * total supply.
862      *
863      * Emits a {Transfer} event with `to` set to the zero address.
864      *
865      * Requirements
866      *
867      * - `account` cannot be the zero address.
868      * - `account` must have at least `amount` tokens.
869      */
870     function _burn(address account, uint256 amount) internal {
871         require(account != address(0), "ERC20: burn from the zero address");
872 
873         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
874         _totalSupply = _totalSupply.sub(amount);
875         emit Transfer(account, address(0), amount);
876     }
877 
878     /**
879      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
880      *
881      * This is internal function is equivalent to `approve`, and can be used to
882      * e.g. set automatic allowances for certain subsystems, etc.
883      *
884      * Emits an {Approval} event.
885      *
886      * Requirements:
887      *
888      * - `owner` cannot be the zero address.
889      * - `spender` cannot be the zero address.
890      */
891     function _approve(address owner, address spender, uint256 amount) internal {
892         require(owner != address(0), "ERC20: approve from the zero address");
893         require(spender != address(0), "ERC20: approve to the zero address");
894 
895         _allowances[owner][spender] = amount;
896         emit Approval(owner, spender, amount);
897     }
898 
899     /**
900      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
901      * from the caller's allowance.
902      *
903      * See {_burn} and {_approve}.
904      */
905     function _burnFrom(address account, uint256 amount) internal {
906         _burn(account, amount);
907         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
908     }
909 }
910 
911 // File: @openzeppelin/contracts/math/Math.sol
912 
913 pragma solidity ^0.5.0;
914 
915 /**
916  * @dev Standard math utilities missing in the Solidity language.
917  */
918 library Math {
919     /**
920      * @dev Returns the largest of two numbers.
921      */
922     function max(uint256 a, uint256 b) internal pure returns (uint256) {
923         return a >= b ? a : b;
924     }
925 
926     /**
927      * @dev Returns the smallest of two numbers.
928      */
929     function min(uint256 a, uint256 b) internal pure returns (uint256) {
930         return a < b ? a : b;
931     }
932 
933     /**
934      * @dev Returns the average of two numbers. The result is rounded towards
935      * zero.
936      */
937     function average(uint256 a, uint256 b) internal pure returns (uint256) {
938         // (a + b) / 2 can overflow, so we distribute
939         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
940     }
941 }
942 
943 // File: @openzeppelin/contracts/crowdsale/emission/AllowanceCrowdsale.sol
944 
945 pragma solidity ^0.5.0;
946 
947 
948 
949 
950 
951 
952 /**
953  * @title AllowanceCrowdsale
954  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
955  */
956 contract AllowanceCrowdsale is Crowdsale {
957     using SafeMath for uint256;
958     using SafeERC20 for IERC20;
959 
960     address private _tokenWallet;
961 
962     /**
963      * @dev Constructor, takes token wallet address.
964      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale.
965      */
966     constructor (address tokenWallet) public {
967         require(tokenWallet != address(0), "AllowanceCrowdsale: token wallet is the zero address");
968         _tokenWallet = tokenWallet;
969     }
970 
971     /**
972      * @return the address of the wallet that will hold the tokens.
973      */
974     function tokenWallet() public view returns (address) {
975         return _tokenWallet;
976     }
977 
978     /**
979      * @dev Checks the amount of tokens left in the allowance.
980      * @return Amount of tokens left in the allowance
981      */
982     function remainingTokens() public view returns (uint256) {
983         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
984     }
985 
986     /**
987      * @dev Overrides parent behavior by transferring tokens from wallet.
988      * @param beneficiary Token purchaser
989      * @param tokenAmount Amount of tokens purchased
990      */
991     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
992         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
993     }
994 }
995 
996 // File: @openzeppelin/contracts/access/Roles.sol
997 
998 pragma solidity ^0.5.0;
999 
1000 /**
1001  * @title Roles
1002  * @dev Library for managing addresses assigned to a Role.
1003  */
1004 library Roles {
1005     struct Role {
1006         mapping (address => bool) bearer;
1007     }
1008 
1009     /**
1010      * @dev Give an account access to this role.
1011      */
1012     function add(Role storage role, address account) internal {
1013         require(!has(role, account), "Roles: account already has role");
1014         role.bearer[account] = true;
1015     }
1016 
1017     /**
1018      * @dev Remove an account's access to this role.
1019      */
1020     function remove(Role storage role, address account) internal {
1021         require(has(role, account), "Roles: account does not have role");
1022         role.bearer[account] = false;
1023     }
1024 
1025     /**
1026      * @dev Check if an account has this role.
1027      * @return bool
1028      */
1029     function has(Role storage role, address account) internal view returns (bool) {
1030         require(account != address(0), "Roles: account is the zero address");
1031         return role.bearer[account];
1032     }
1033 }
1034 
1035 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
1036 
1037 pragma solidity ^0.5.0;
1038 
1039 
1040 
1041 contract PauserRole is Context {
1042     using Roles for Roles.Role;
1043 
1044     event PauserAdded(address indexed account);
1045     event PauserRemoved(address indexed account);
1046 
1047     Roles.Role private _pausers;
1048 
1049     constructor () internal {
1050         _addPauser(_msgSender());
1051     }
1052 
1053     modifier onlyPauser() {
1054         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
1055         _;
1056     }
1057 
1058     function isPauser(address account) public view returns (bool) {
1059         return _pausers.has(account);
1060     }
1061 
1062     function addPauser(address account) public onlyPauser {
1063         _addPauser(account);
1064     }
1065 
1066     function renouncePauser() public {
1067         _removePauser(_msgSender());
1068     }
1069 
1070     function _addPauser(address account) internal {
1071         _pausers.add(account);
1072         emit PauserAdded(account);
1073     }
1074 
1075     function _removePauser(address account) internal {
1076         _pausers.remove(account);
1077         emit PauserRemoved(account);
1078     }
1079 }
1080 
1081 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
1082 
1083 pragma solidity ^0.5.0;
1084 
1085 
1086 
1087 /**
1088  * @dev Contract module which allows children to implement an emergency stop
1089  * mechanism that can be triggered by an authorized account.
1090  *
1091  * This module is used through inheritance. It will make available the
1092  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1093  * the functions of your contract. Note that they will not be pausable by
1094  * simply including this module, only once the modifiers are put in place.
1095  */
1096 contract Pausable is Context, PauserRole {
1097     /**
1098      * @dev Emitted when the pause is triggered by a pauser (`account`).
1099      */
1100     event Paused(address account);
1101 
1102     /**
1103      * @dev Emitted when the pause is lifted by a pauser (`account`).
1104      */
1105     event Unpaused(address account);
1106 
1107     bool private _paused;
1108 
1109     /**
1110      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
1111      * to the deployer.
1112      */
1113     constructor () internal {
1114         _paused = false;
1115     }
1116 
1117     /**
1118      * @dev Returns true if the contract is paused, and false otherwise.
1119      */
1120     function paused() public view returns (bool) {
1121         return _paused;
1122     }
1123 
1124     /**
1125      * @dev Modifier to make a function callable only when the contract is not paused.
1126      */
1127     modifier whenNotPaused() {
1128         require(!_paused, "Pausable: paused");
1129         _;
1130     }
1131 
1132     /**
1133      * @dev Modifier to make a function callable only when the contract is paused.
1134      */
1135     modifier whenPaused() {
1136         require(_paused, "Pausable: not paused");
1137         _;
1138     }
1139 
1140     /**
1141      * @dev Called by a pauser to pause, triggers stopped state.
1142      */
1143     function pause() public onlyPauser whenNotPaused {
1144         _paused = true;
1145         emit Paused(_msgSender());
1146     }
1147 
1148     /**
1149      * @dev Called by a pauser to unpause, returns to normal state.
1150      */
1151     function unpause() public onlyPauser whenPaused {
1152         _paused = false;
1153         emit Unpaused(_msgSender());
1154     }
1155 }
1156 
1157 // File: @openzeppelin/contracts/crowdsale/validation/PausableCrowdsale.sol
1158 
1159 pragma solidity ^0.5.0;
1160 
1161 
1162 
1163 /**
1164  * @title PausableCrowdsale
1165  * @dev Extension of Crowdsale contract where purchases can be paused and unpaused by the pauser role.
1166  */
1167 contract PausableCrowdsale is Crowdsale, Pausable {
1168     /**
1169      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
1170      * Use super to concatenate validations.
1171      * Adds the validation that the crowdsale must not be paused.
1172      * @param _beneficiary Address performing the token purchase
1173      * @param _weiAmount Value in wei involved in the purchase
1174      */
1175     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view whenNotPaused {
1176         return super._preValidatePurchase(_beneficiary, _weiAmount);
1177     }
1178 }
1179 
1180 // File: contracts/SmartKeyCrowdsale.sol
1181 
1182 pragma solidity ^0.5.0 < 0.7.0;
1183 
1184 
1185 
1186 
1187 
1188 contract SmartKeyCrowdsale is PausableCrowdsale, AllowanceCrowdsale {
1189 
1190   uint256 private _changeableRate;
1191 
1192   constructor(
1193     uint256 _rate,
1194     address payable _wallet,
1195     ERC20 _token,
1196     address _tokenWallet
1197   )
1198     Crowdsale(_rate, _wallet, _token)
1199     AllowanceCrowdsale(_tokenWallet)
1200     public
1201   {
1202     _changeableRate = _rate;
1203   }
1204 
1205     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
1206       return weiAmount.div(_changeableRate);
1207     }
1208 }