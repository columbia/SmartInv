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
679 // File: @openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol
680 
681 pragma solidity ^0.5.0;
682 
683 
684 
685 /**
686  * @title TimedCrowdsale
687  * @dev Crowdsale accepting contributions only within a time frame.
688  */
689 contract TimedCrowdsale is Crowdsale {
690     using SafeMath for uint256;
691 
692     uint256 private _openingTime;
693     uint256 private _closingTime;
694 
695     /**
696      * Event for crowdsale extending
697      * @param newClosingTime new closing time
698      * @param prevClosingTime old closing time
699      */
700     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
701 
702     /**
703      * @dev Reverts if not in crowdsale time range.
704      */
705     modifier onlyWhileOpen {
706         require(isOpen(), "TimedCrowdsale: not open");
707         _;
708     }
709 
710     /**
711      * @dev Constructor, takes crowdsale opening and closing times.
712      * @param openingTime Crowdsale opening time
713      * @param closingTime Crowdsale closing time
714      */
715     constructor (uint256 openingTime, uint256 closingTime) public {
716         // solhint-disable-next-line not-rely-on-time
717         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
718         // solhint-disable-next-line max-line-length
719         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
720 
721         _openingTime = openingTime;
722         _closingTime = closingTime;
723     }
724 
725     /**
726      * @return the crowdsale opening time.
727      */
728     function openingTime() public view returns (uint256) {
729         return _openingTime;
730     }
731 
732     /**
733      * @return the crowdsale closing time.
734      */
735     function closingTime() public view returns (uint256) {
736         return _closingTime;
737     }
738 
739     /**
740      * @return true if the crowdsale is open, false otherwise.
741      */
742     function isOpen() public view returns (bool) {
743         // solhint-disable-next-line not-rely-on-time
744         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
745     }
746 
747     /**
748      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
749      * @return Whether crowdsale period has elapsed
750      */
751     function hasClosed() public view returns (bool) {
752         // solhint-disable-next-line not-rely-on-time
753         return block.timestamp > _closingTime;
754     }
755 
756     /**
757      * @dev Extend parent behavior requiring to be within contributing period.
758      * @param beneficiary Token purchaser
759      * @param weiAmount Amount of wei contributed
760      */
761     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
762         super._preValidatePurchase(beneficiary, weiAmount);
763     }
764 
765     /**
766      * @dev Extend crowdsale.
767      * @param newClosingTime Crowdsale closing time
768      */
769     function _extendTime(uint256 newClosingTime) internal {
770         require(!hasClosed(), "TimedCrowdsale: already closed");
771         // solhint-disable-next-line max-line-length
772         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
773 
774         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
775         _closingTime = newClosingTime;
776     }
777 }
778 
779 // File: @openzeppelin/contracts/ownership/Secondary.sol
780 
781 pragma solidity ^0.5.0;
782 
783 /**
784  * @dev A Secondary contract can only be used by its primary account (the one that created it).
785  */
786 contract Secondary is Context {
787     address private _primary;
788 
789     /**
790      * @dev Emitted when the primary contract changes.
791      */
792     event PrimaryTransferred(
793         address recipient
794     );
795 
796     /**
797      * @dev Sets the primary account to the one that is creating the Secondary contract.
798      */
799     constructor () internal {
800         address msgSender = _msgSender();
801         _primary = msgSender;
802         emit PrimaryTransferred(msgSender);
803     }
804 
805     /**
806      * @dev Reverts if called from any account other than the primary.
807      */
808     modifier onlyPrimary() {
809         require(_msgSender() == _primary, "Secondary: caller is not the primary account");
810         _;
811     }
812 
813     /**
814      * @return the address of the primary.
815      */
816     function primary() public view returns (address) {
817         return _primary;
818     }
819 
820     /**
821      * @dev Transfers contract to a new primary.
822      * @param recipient The address of new primary.
823      */
824     function transferPrimary(address recipient) public onlyPrimary {
825         require(recipient != address(0), "Secondary: new primary is the zero address");
826         _primary = recipient;
827         emit PrimaryTransferred(recipient);
828     }
829 }
830 
831 // File: @openzeppelin/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
832 
833 pragma solidity ^0.5.0;
834 
835 
836 
837 
838 
839 /**
840  * @title PostDeliveryCrowdsale
841  * @dev Crowdsale that locks tokens from withdrawal until it ends.
842  */
843 contract PostDeliveryCrowdsale is TimedCrowdsale {
844     using SafeMath for uint256;
845 
846     mapping(address => uint256) private _balances;
847     __unstable__TokenVault private _vault;
848 
849     constructor() public {
850         _vault = new __unstable__TokenVault();
851     }
852 
853     /**
854      * @dev Withdraw tokens only after crowdsale ends.
855      * @param beneficiary Whose tokens will be withdrawn.
856      */
857     function withdrawTokens(address beneficiary) public {
858         require(hasClosed(), "PostDeliveryCrowdsale: not closed");
859         uint256 amount = _balances[beneficiary];
860         require(amount > 0, "PostDeliveryCrowdsale: beneficiary is not due any tokens");
861 
862         _balances[beneficiary] = 0;
863         _vault.transfer(token(), beneficiary, amount);
864     }
865 
866     /**
867      * @return the balance of an account.
868      */
869     function balanceOf(address account) public view returns (uint256) {
870         return _balances[account];
871     }
872 
873     /**
874      * @dev Overrides parent by storing due balances, and delivering tokens to the vault instead of the end user. This
875      * ensures that the tokens will be available by the time they are withdrawn (which may not be the case if
876      * `_deliverTokens` was called later).
877      * @param beneficiary Token purchaser
878      * @param tokenAmount Amount of tokens purchased
879      */
880     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
881         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
882         _deliverTokens(address(_vault), tokenAmount);
883     }
884 }
885 
886 /**
887  * @title __unstable__TokenVault
888  * @dev Similar to an Escrow for tokens, this contract allows its primary account to spend its tokens as it sees fit.
889  * This contract is an internal helper for PostDeliveryCrowdsale, and should not be used outside of this context.
890  */
891 // solhint-disable-next-line contract-name-camelcase
892 contract __unstable__TokenVault is Secondary {
893     function transfer(IERC20 token, address to, uint256 amount) public onlyPrimary {
894         token.transfer(to, amount);
895     }
896 }
897 
898 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
899 
900 pragma solidity ^0.5.0;
901 
902 
903 
904 
905 /**
906  * @dev Implementation of the {IERC20} interface.
907  *
908  * This implementation is agnostic to the way tokens are created. This means
909  * that a supply mechanism has to be added in a derived contract using {_mint}.
910  * For a generic mechanism see {ERC20Mintable}.
911  *
912  * TIP: For a detailed writeup see our guide
913  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
914  * to implement supply mechanisms].
915  *
916  * We have followed general OpenZeppelin guidelines: functions revert instead
917  * of returning `false` on failure. This behavior is nonetheless conventional
918  * and does not conflict with the expectations of ERC20 applications.
919  *
920  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
921  * This allows applications to reconstruct the allowance for all accounts just
922  * by listening to said events. Other implementations of the EIP may not emit
923  * these events, as it isn't required by the specification.
924  *
925  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
926  * functions have been added to mitigate the well-known issues around setting
927  * allowances. See {IERC20-approve}.
928  */
929 contract ERC20 is Context, IERC20 {
930     using SafeMath for uint256;
931 
932     mapping (address => uint256) private _balances;
933 
934     mapping (address => mapping (address => uint256)) private _allowances;
935 
936     uint256 private _totalSupply;
937 
938     /**
939      * @dev See {IERC20-totalSupply}.
940      */
941     function totalSupply() public view returns (uint256) {
942         return _totalSupply;
943     }
944 
945     /**
946      * @dev See {IERC20-balanceOf}.
947      */
948     function balanceOf(address account) public view returns (uint256) {
949         return _balances[account];
950     }
951 
952     /**
953      * @dev See {IERC20-transfer}.
954      *
955      * Requirements:
956      *
957      * - `recipient` cannot be the zero address.
958      * - the caller must have a balance of at least `amount`.
959      */
960     function transfer(address recipient, uint256 amount) public returns (bool) {
961         _transfer(_msgSender(), recipient, amount);
962         return true;
963     }
964 
965     /**
966      * @dev See {IERC20-allowance}.
967      */
968     function allowance(address owner, address spender) public view returns (uint256) {
969         return _allowances[owner][spender];
970     }
971 
972     /**
973      * @dev See {IERC20-approve}.
974      *
975      * Requirements:
976      *
977      * - `spender` cannot be the zero address.
978      */
979     function approve(address spender, uint256 amount) public returns (bool) {
980         _approve(_msgSender(), spender, amount);
981         return true;
982     }
983 
984     /**
985      * @dev See {IERC20-transferFrom}.
986      *
987      * Emits an {Approval} event indicating the updated allowance. This is not
988      * required by the EIP. See the note at the beginning of {ERC20};
989      *
990      * Requirements:
991      * - `sender` and `recipient` cannot be the zero address.
992      * - `sender` must have a balance of at least `amount`.
993      * - the caller must have allowance for `sender`'s tokens of at least
994      * `amount`.
995      */
996     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
997         _transfer(sender, recipient, amount);
998         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
999         return true;
1000     }
1001 
1002     /**
1003      * @dev Atomically increases the allowance granted to `spender` by the caller.
1004      *
1005      * This is an alternative to {approve} that can be used as a mitigation for
1006      * problems described in {IERC20-approve}.
1007      *
1008      * Emits an {Approval} event indicating the updated allowance.
1009      *
1010      * Requirements:
1011      *
1012      * - `spender` cannot be the zero address.
1013      */
1014     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1015         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1016         return true;
1017     }
1018 
1019     /**
1020      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1021      *
1022      * This is an alternative to {approve} that can be used as a mitigation for
1023      * problems described in {IERC20-approve}.
1024      *
1025      * Emits an {Approval} event indicating the updated allowance.
1026      *
1027      * Requirements:
1028      *
1029      * - `spender` cannot be the zero address.
1030      * - `spender` must have allowance for the caller of at least
1031      * `subtractedValue`.
1032      */
1033     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1034         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1035         return true;
1036     }
1037 
1038     /**
1039      * @dev Moves tokens `amount` from `sender` to `recipient`.
1040      *
1041      * This is internal function is equivalent to {transfer}, and can be used to
1042      * e.g. implement automatic token fees, slashing mechanisms, etc.
1043      *
1044      * Emits a {Transfer} event.
1045      *
1046      * Requirements:
1047      *
1048      * - `sender` cannot be the zero address.
1049      * - `recipient` cannot be the zero address.
1050      * - `sender` must have a balance of at least `amount`.
1051      */
1052     function _transfer(address sender, address recipient, uint256 amount) internal {
1053         require(sender != address(0), "ERC20: transfer from the zero address");
1054         require(recipient != address(0), "ERC20: transfer to the zero address");
1055 
1056         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1057         _balances[recipient] = _balances[recipient].add(amount);
1058         emit Transfer(sender, recipient, amount);
1059     }
1060 
1061     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1062      * the total supply.
1063      *
1064      * Emits a {Transfer} event with `from` set to the zero address.
1065      *
1066      * Requirements
1067      *
1068      * - `to` cannot be the zero address.
1069      */
1070     function _mint(address account, uint256 amount) internal {
1071         require(account != address(0), "ERC20: mint to the zero address");
1072 
1073         _totalSupply = _totalSupply.add(amount);
1074         _balances[account] = _balances[account].add(amount);
1075         emit Transfer(address(0), account, amount);
1076     }
1077 
1078     /**
1079      * @dev Destroys `amount` tokens from `account`, reducing the
1080      * total supply.
1081      *
1082      * Emits a {Transfer} event with `to` set to the zero address.
1083      *
1084      * Requirements
1085      *
1086      * - `account` cannot be the zero address.
1087      * - `account` must have at least `amount` tokens.
1088      */
1089     function _burn(address account, uint256 amount) internal {
1090         require(account != address(0), "ERC20: burn from the zero address");
1091 
1092         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1093         _totalSupply = _totalSupply.sub(amount);
1094         emit Transfer(account, address(0), amount);
1095     }
1096 
1097     /**
1098      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1099      *
1100      * This is internal function is equivalent to `approve`, and can be used to
1101      * e.g. set automatic allowances for certain subsystems, etc.
1102      *
1103      * Emits an {Approval} event.
1104      *
1105      * Requirements:
1106      *
1107      * - `owner` cannot be the zero address.
1108      * - `spender` cannot be the zero address.
1109      */
1110     function _approve(address owner, address spender, uint256 amount) internal {
1111         require(owner != address(0), "ERC20: approve from the zero address");
1112         require(spender != address(0), "ERC20: approve to the zero address");
1113 
1114         _allowances[owner][spender] = amount;
1115         emit Approval(owner, spender, amount);
1116     }
1117 
1118     /**
1119      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
1120      * from the caller's allowance.
1121      *
1122      * See {_burn} and {_approve}.
1123      */
1124     function _burnFrom(address account, uint256 amount) internal {
1125         _burn(account, amount);
1126         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
1127     }
1128 }
1129 
1130 // File: @openzeppelin/contracts/access/Roles.sol
1131 
1132 pragma solidity ^0.5.0;
1133 
1134 /**
1135  * @title Roles
1136  * @dev Library for managing addresses assigned to a Role.
1137  */
1138 library Roles {
1139     struct Role {
1140         mapping (address => bool) bearer;
1141     }
1142 
1143     /**
1144      * @dev Give an account access to this role.
1145      */
1146     function add(Role storage role, address account) internal {
1147         require(!has(role, account), "Roles: account already has role");
1148         role.bearer[account] = true;
1149     }
1150 
1151     /**
1152      * @dev Remove an account's access to this role.
1153      */
1154     function remove(Role storage role, address account) internal {
1155         require(has(role, account), "Roles: account does not have role");
1156         role.bearer[account] = false;
1157     }
1158 
1159     /**
1160      * @dev Check if an account has this role.
1161      * @return bool
1162      */
1163     function has(Role storage role, address account) internal view returns (bool) {
1164         require(account != address(0), "Roles: account is the zero address");
1165         return role.bearer[account];
1166     }
1167 }
1168 
1169 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
1170 
1171 pragma solidity ^0.5.0;
1172 
1173 
1174 
1175 contract MinterRole is Context {
1176     using Roles for Roles.Role;
1177 
1178     event MinterAdded(address indexed account);
1179     event MinterRemoved(address indexed account);
1180 
1181     Roles.Role private _minters;
1182 
1183     constructor () internal {
1184         _addMinter(_msgSender());
1185     }
1186 
1187     modifier onlyMinter() {
1188         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1189         _;
1190     }
1191 
1192     function isMinter(address account) public view returns (bool) {
1193         return _minters.has(account);
1194     }
1195 
1196     function addMinter(address account) public onlyMinter {
1197         _addMinter(account);
1198     }
1199 
1200     function renounceMinter() public {
1201         _removeMinter(_msgSender());
1202     }
1203 
1204     function _addMinter(address account) internal {
1205         _minters.add(account);
1206         emit MinterAdded(account);
1207     }
1208 
1209     function _removeMinter(address account) internal {
1210         _minters.remove(account);
1211         emit MinterRemoved(account);
1212     }
1213 }
1214 
1215 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
1216 
1217 pragma solidity ^0.5.0;
1218 
1219 
1220 
1221 /**
1222  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1223  * which have permission to mint (create) new tokens as they see fit.
1224  *
1225  * At construction, the deployer of the contract is the only minter.
1226  */
1227 contract ERC20Mintable is ERC20, MinterRole {
1228     /**
1229      * @dev See {ERC20-_mint}.
1230      *
1231      * Requirements:
1232      *
1233      * - the caller must have the {MinterRole}.
1234      */
1235     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1236         _mint(account, amount);
1237         return true;
1238     }
1239 }
1240 
1241 // File: @openzeppelin/contracts/crowdsale/emission/MintedCrowdsale.sol
1242 
1243 pragma solidity ^0.5.0;
1244 
1245 
1246 
1247 /**
1248  * @title MintedCrowdsale
1249  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1250  * Token ownership should be transferred to MintedCrowdsale for minting.
1251  */
1252 contract MintedCrowdsale is Crowdsale {
1253     /**
1254      * @dev Overrides delivery by minting tokens upon purchase.
1255      * @param beneficiary Token purchaser
1256      * @param tokenAmount Number of tokens to be minted
1257      */
1258     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
1259         // Potentially dangerous assumption about the type of the token.
1260         require(
1261             ERC20Mintable(address(token())).mint(beneficiary, tokenAmount),
1262                 "MintedCrowdsale: minting failed"
1263         );
1264     }
1265 }
1266 
1267 // File: @openzeppelin/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
1268 
1269 pragma solidity ^0.5.0;
1270 
1271 
1272 
1273 /**
1274  * @title FinalizableCrowdsale
1275  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
1276  * can do extra work after finishing.
1277  */
1278 contract FinalizableCrowdsale is TimedCrowdsale {
1279     using SafeMath for uint256;
1280 
1281     bool private _finalized;
1282 
1283     event CrowdsaleFinalized();
1284 
1285     constructor () internal {
1286         _finalized = false;
1287     }
1288 
1289     /**
1290      * @return true if the crowdsale is finalized, false otherwise.
1291      */
1292     function finalized() public view returns (bool) {
1293         return _finalized;
1294     }
1295 
1296     /**
1297      * @dev Must be called after crowdsale ends, to do some extra finalization
1298      * work. Calls the contract's finalization function.
1299      */
1300     function finalize() public {
1301         require(!_finalized, "FinalizableCrowdsale: already finalized");
1302         require(hasClosed(), "FinalizableCrowdsale: not closed");
1303 
1304         _finalized = true;
1305 
1306         _finalization();
1307         emit CrowdsaleFinalized();
1308     }
1309 
1310     /**
1311      * @dev Can be overridden to add finalization logic. The overriding function
1312      * should call super._finalization() to ensure the chain of finalization is
1313      * executed entirely.
1314      */
1315     function _finalization() internal {
1316         // solhint-disable-previous-line no-empty-blocks
1317     }
1318 }
1319 
1320 // File: contracts/crowdsale/WhitelistCrowdsale.sol
1321 
1322 pragma solidity ^0.5.0;
1323 
1324 
1325 // custom validation using the whitelister contract
1326 
1327 contract WhitelistCrowdsale is Crowdsale {
1328     address public whitelister;
1329 
1330     constructor(address _whitelister) public {
1331         whitelister = _whitelister;
1332     }
1333 
1334     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
1335         require(IWhitelister(whitelister).whitelisted(_beneficiary) == true, "WhitelistCrowdsale: beneficiary not whitelisted");
1336         super._preValidatePurchase(_beneficiary, _weiAmount);
1337     }
1338 
1339     function isWhitelisted(address _address) external view returns (bool) {
1340     	return IWhitelister(whitelister).whitelisted(_address);
1341     }
1342 }
1343 
1344 interface IWhitelister {
1345     function whitelisted(address _address) external view returns (bool);
1346 }
1347 
1348 // File: @openzeppelin/contracts/access/roles/CapperRole.sol
1349 
1350 pragma solidity ^0.5.0;
1351 
1352 
1353 
1354 contract CapperRole is Context {
1355     using Roles for Roles.Role;
1356 
1357     event CapperAdded(address indexed account);
1358     event CapperRemoved(address indexed account);
1359 
1360     Roles.Role private _cappers;
1361 
1362     constructor () internal {
1363         _addCapper(_msgSender());
1364     }
1365 
1366     modifier onlyCapper() {
1367         require(isCapper(_msgSender()), "CapperRole: caller does not have the Capper role");
1368         _;
1369     }
1370 
1371     function isCapper(address account) public view returns (bool) {
1372         return _cappers.has(account);
1373     }
1374 
1375     function addCapper(address account) public onlyCapper {
1376         _addCapper(account);
1377     }
1378 
1379     function renounceCapper() public {
1380         _removeCapper(_msgSender());
1381     }
1382 
1383     function _addCapper(address account) internal {
1384         _cappers.add(account);
1385         emit CapperAdded(account);
1386     }
1387 
1388     function _removeCapper(address account) internal {
1389         _cappers.remove(account);
1390         emit CapperRemoved(account);
1391     }
1392 }
1393 
1394 // File: contracts/crowdsale/IndividuallyCappedCrowdsale.sol
1395 
1396 pragma solidity ^0.5.0;
1397 
1398 
1399 
1400 
1401 // a single cap applied to all users
1402 
1403 /**
1404  * @title IndividuallyCappedCrowdsale
1405  * @dev Crowdsale with per-beneficiary caps.
1406  */
1407 contract IndividuallyCappedCrowdsale is Crowdsale {
1408     using SafeMath for uint256;
1409 
1410     mapping(address => uint256) private _contributions;
1411     // mapping(address => uint256) private _caps;
1412     uint256 public individualCap;
1413 
1414     constructor(uint256 _individualCap) public {
1415         individualCap = _individualCap;
1416     }
1417 
1418     /**
1419      * @dev Sets a specific beneficiary's maximum contribution.
1420      * @param beneficiary Address to be capped
1421      * @param cap Wei limit for individual contribution
1422      */
1423     // function setCap(address beneficiary, uint256 cap) external onlyCapper {
1424     //     _caps[beneficiary] = cap;
1425     // }
1426 
1427     /**
1428      * @dev Returns the cap of a specific beneficiary.
1429      * @param beneficiary Address whose cap is to be checked
1430      * @return Current cap for individual beneficiary
1431      */
1432     // function getCap(address beneficiary) public view returns (uint256) {
1433         // return _caps[beneficiary];
1434     // }
1435 
1436     /**
1437      * @dev Returns the amount contributed so far by a specific beneficiary.
1438      * @param beneficiary Address of contributor
1439      * @return Beneficiary contribution so far
1440      */
1441     function getContribution(address beneficiary) public view returns (uint256) {
1442         return _contributions[beneficiary];
1443     }
1444 
1445     /**
1446      * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
1447      * @param beneficiary Token purchaser
1448      * @param weiAmount Amount of wei contributed
1449      */
1450     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1451         super._preValidatePurchase(beneficiary, weiAmount);
1452         // solhint-disable-next-line max-line-length
1453         // require(_contributions[beneficiary].add(weiAmount) <= _caps[beneficiary], "IndividuallyCappedCrowdsale: beneficiary's cap exceeded");
1454         require(_contributions[beneficiary].add(weiAmount) <= individualCap, "IndividuallyCappedCrowdsale: beneficiary's cap exceeded");
1455     }
1456 
1457     /**
1458      * @dev Extend parent behavior to update beneficiary contributions.
1459      * @param beneficiary Token purchaser
1460      * @param weiAmount Amount of wei contributed
1461      */
1462     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
1463         super._updatePurchasingState(beneficiary, weiAmount);
1464         _contributions[beneficiary] = _contributions[beneficiary].add(weiAmount);
1465     }
1466 }
1467 
1468 // File: contracts/crowdsale/IncreasingPriceCrowdsale.sol
1469 
1470 pragma solidity ^0.5.0;
1471 
1472 
1473 
1474 /**
1475  * @title IncreasingPriceCrowdsale
1476  * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
1477  * Note that what should be provided to the constructor is the initial and final _rates_, that is,
1478  * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
1479  */
1480 contract IncreasingPriceCrowdsale is TimedCrowdsale {
1481     using SafeMath for uint256;
1482 
1483     // uint256 private _initialRate;
1484     uint256 private _finalRate;
1485 
1486     address public referrers;
1487 
1488     /**
1489      * @dev Constructor, takes initial and final rates of tokens received per wei contributed.
1490      * @param finalRate Number of tokens a buyer gets per wei at the end of the crowdsale
1491      */
1492     constructor (uint256 finalRate, address _referrers) public {
1493         require(finalRate > 0, "IncreasingPriceCrowdsale: final rate is 0");
1494         // solhint-disable-next-line max-line-length
1495         _finalRate = finalRate;
1496         referrers = _referrers;
1497     }
1498 
1499     function isReferrer(address _address) public view returns (bool) {
1500         if (referrers == address(0)) {
1501             return false;
1502         }
1503         return IReferrers(referrers).isReferrer(_address);
1504     }
1505 
1506     /**
1507      * The base rate function is overridden to revert, since this crowdsale doesn't use it, and
1508      * all calls to it are a mistake.
1509      */
1510     function rate() public view returns (uint256) {
1511         revert("IncreasingPriceCrowdsale: rate() called");
1512     }
1513 
1514 
1515     // function initialRate() public view returns (uint256) {
1516     //     return _initialRate;
1517     // }
1518 
1519     /**
1520      * @return the final rate of the crowdsale.
1521      */
1522     function finalRate() public view returns (uint256) {
1523         return _finalRate;
1524     }
1525 
1526     /**
1527      * @dev Returns the rate of tokens per wei at the present time.
1528      * Note that, as price _increases_ with time, the rate _decreases_.
1529      * @return The number of tokens a buyer gets per wei at a given time
1530      */
1531     function getCurrentRate() public view returns (uint256) {
1532         if (!isOpen()) {
1533             return 0;
1534         }
1535 
1536         uint256 _weiRaised = weiRaised();
1537         uint256 _rate = _finalRate;
1538 
1539         if (isReferrer(msg.sender)) {
1540             _rate = _rate.mul(110).div(100);
1541         }
1542 
1543         if (_weiRaised < 15e18) {
1544             return _rate.mul(250).div(100);
1545         }
1546         if (_weiRaised < 30e18) {
1547             return _rate.mul(200).div(100);
1548         }
1549         if (_weiRaised < 45e18) {
1550             return _rate.mul(175).div(100);
1551         }
1552         if (_weiRaised < 75e18) {
1553             return _rate.mul(150).div(100);
1554         }
1555         if (_weiRaised < 105e18) {
1556             return _rate.mul(120).div(100);
1557         }
1558         if (_weiRaised < 135e18) {
1559             return _rate.mul(110).div(100);
1560         }
1561         if (_weiRaised < 165e18) {
1562             return _rate.mul(105).div(100);
1563         }
1564         return _rate;
1565     }
1566 
1567     /**
1568      * @dev Overrides parent method taking into account variable rate.
1569      * @param weiAmount The value in wei to be converted into tokens
1570      * @return The number of tokens _weiAmount wei will buy at present time
1571      */
1572     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
1573         uint256 currentRate = getCurrentRate();
1574         return currentRate.mul(weiAmount);
1575     }
1576 }
1577 
1578 interface IReferrers {
1579     function isReferrer(address _address) external view returns (bool);
1580 }
1581 
1582 // File: contracts/RugProofCrowdsale.sol
1583 
1584 pragma solidity ^0.5.17;
1585 
1586 
1587 
1588 
1589 
1590 
1591 
1592 
1593 
1594 contract RugProofCrowdsale is
1595     Crowdsale,
1596     MintedCrowdsale,
1597     WhitelistCrowdsale,
1598     TimedCrowdsale,
1599     PostDeliveryCrowdsale,
1600     IndividuallyCappedCrowdsale,
1601     IncreasingPriceCrowdsale,
1602     FinalizableCrowdsale
1603 {
1604     uint256 private _finalRate = 5000;
1605     uint256 private _individualCap = 2e18;
1606     constructor(
1607         address payable crowdsaleWallet,
1608         IERC20 token,
1609         uint256 openingTime,
1610         uint256 closingTime,
1611         address whitelister,
1612         address referrers
1613     )
1614         FinalizableCrowdsale()
1615         WhitelistCrowdsale(whitelister)
1616         IncreasingPriceCrowdsale(_finalRate, referrers)
1617         PostDeliveryCrowdsale()
1618         TimedCrowdsale(openingTime, closingTime)
1619         IndividuallyCappedCrowdsale(_individualCap)
1620         MintedCrowdsale()
1621         Crowdsale(_finalRate, crowdsaleWallet, token)
1622         public
1623     {}
1624 }