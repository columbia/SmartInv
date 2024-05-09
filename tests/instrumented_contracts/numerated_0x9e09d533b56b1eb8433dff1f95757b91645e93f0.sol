1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-20
3 */
4 
5 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @dev Contract module which provides a basic access control mechanism, where
11  * there is an account (an owner) that can be granted exclusive access to
12  * specific functions.
13  *
14  * This module is used through inheritance. It will make available the modifier
15  * `onlyOwner`, which can be aplied to your functions to restrict their use to
16  * the owner.
17  */
18 contract Ownable {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor () internal {
27         _owner = msg.sender;
28         emit OwnershipTransferred(address(0), _owner);
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(isOwner(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Returns true if the caller is the current owner.
48      */
49     function isOwner() public view returns (bool) {
50         return msg.sender == _owner;
51     }
52 
53     /**
54      * @dev Leaves the contract without owner. It will not be possible to call
55      * `onlyOwner` functions anymore. Can only be called by the current owner.
56      *
57      * > Note: Renouncing ownership will leave the contract without an owner,
58      * thereby removing any functionality that is only available to the owner.
59      */
60     function renounceOwnership() public onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 
65     /**
66      * @dev Transfers ownership of the contract to a new account (`newOwner`).
67      * Can only be called by the current owner.
68      */
69     function transferOwnership(address newOwner) public onlyOwner {
70         _transferOwnership(newOwner);
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      */
76     function _transferOwnership(address newOwner) internal {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81 }
82 
83 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
84 
85 
86 
87 /**
88  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
89  * the optional functions; to access them see `ERC20Detailed`.
90  */
91 interface IERC20 {
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101 
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `recipient`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a `Transfer` event.
108      */
109     function transfer(address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through `transferFrom`. This is
114      * zero by default.
115      *
116      * This value changes when `approve` or `transferFrom` are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119 
120     /**
121      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * > Beware that changing an allowance with this method brings the risk
126      * that someone may use both the old and the new allowance by unfortunate
127      * transaction ordering. One possible solution to mitigate this race
128      * condition is to first reduce the spender's allowance to 0 and set the
129      * desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Emits an `Approval` event.
133      */
134     function approve(address spender, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Moves `amount` tokens from `sender` to `recipient` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a `Transfer` event.
144      */
145     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to `approve`. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
163 
164 
165 
166 /**
167  * @dev Wrappers over Solidity's arithmetic operations with added overflow
168  * checks.
169  *
170  * Arithmetic operations in Solidity wrap on overflow. This can easily result
171  * in bugs, because programmers usually assume that an overflow raises an
172  * error, which is the standard behavior in high level programming languages.
173  * `SafeMath` restores this intuition by reverting the transaction when an
174  * operation overflows.
175  *
176  * Using this library instead of the unchecked operations eliminates an entire
177  * class of bugs, so it's recommended to use it always.
178  */
179 library SafeMath {
180     /**
181      * @dev Returns the addition of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `+` operator.
185      *
186      * Requirements:
187      * - Addition cannot overflow.
188      */
189     function add(uint256 a, uint256 b) internal pure returns (uint256) {
190         uint256 c = a + b;
191         require(c >= a, "SafeMath: addition overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         require(b <= a, "SafeMath: subtraction overflow");
207         uint256 c = a - b;
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the multiplication of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `*` operator.
217      *
218      * Requirements:
219      * - Multiplication cannot overflow.
220      */
221     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
223         // benefit is lost if 'b' is also tested.
224         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
225         if (a == 0) {
226             return 0;
227         }
228 
229         uint256 c = a * b;
230         require(c / a == b, "SafeMath: multiplication overflow");
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers. Reverts on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function div(uint256 a, uint256 b) internal pure returns (uint256) {
247         // Solidity only automatically asserts when dividing by 0
248         require(b > 0, "SafeMath: division by zero");
249         uint256 c = a / b;
250         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
267         require(b != 0, "SafeMath: modulo by zero");
268         return a % b;
269     }
270 }
271 
272 // File: node_modules\openzeppelin-solidity\contracts\utils\Address.sol
273 
274 
275 
276 /**
277  * @dev Collection of functions related to the address type,
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * This test is non-exhaustive, and there may be false-negatives: during the
284      * execution of a contract's constructor, its address will be reported as
285      * not containing a contract.
286      *
287      * > It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      */
290     function isContract(address account) internal view returns (bool) {
291         // This method relies in extcodesize, which returns 0 for contracts in
292         // construction, since the code is only stored at the end of the
293         // constructor execution.
294 
295         uint256 size;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { size := extcodesize(account) }
298         return size > 0;
299     }
300 }
301 
302 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
303 
304 
305 
306 
307 
308 
309 /**
310  * @title SafeERC20
311  * @dev Wrappers around ERC20 operations that throw on failure (when the token
312  * contract returns false). Tokens that return no value (and instead revert or
313  * throw on failure) are also supported, non-reverting calls are assumed to be
314  * successful.
315  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
316  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
317  */
318 library SafeERC20 {
319     using SafeMath for uint256;
320     using Address for address;
321 
322     function safeTransfer(IERC20 token, address to, uint256 value) internal {
323         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
324     }
325 
326     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
327         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
328     }
329 
330     function safeApprove(IERC20 token, address spender, uint256 value) internal {
331         // safeApprove should only be called when setting an initial allowance,
332         // or when resetting it to zero. To increase and decrease it, use
333         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
334         // solhint-disable-next-line max-line-length
335         require((value == 0) || (token.allowance(address(this), spender) == 0),
336             "SafeERC20: approve from non-zero to non-zero allowance"
337         );
338         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
339     }
340 
341     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
342         uint256 newAllowance = token.allowance(address(this), spender).add(value);
343         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
344     }
345 
346     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
347         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
348         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
349     }
350 
351     /**
352      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
353      * on the return value: the return value is optional (but if data is returned, it must not be false).
354      * @param token The token targeted by the call.
355      * @param data The call data (encoded using abi.encode or one of its variants).
356      */
357     function callOptionalReturn(IERC20 token, bytes memory data) private {
358         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
359         // we're implementing it ourselves.
360 
361         // A Solidity high level call has three parts:
362         //  1. The target address is checked to verify it contains contract code
363         //  2. The call itself is made, and success asserted
364         //  3. The return value is decoded, which in turn checks the size of the returned data.
365         // solhint-disable-next-line max-line-length
366         require(address(token).isContract(), "SafeERC20: call to non-contract");
367 
368         // solhint-disable-next-line avoid-low-level-calls
369         (bool success, bytes memory returndata) = address(token).call(data);
370         require(success, "SafeERC20: low-level call failed");
371 
372         if (returndata.length > 0) { // Return data is optional
373             // solhint-disable-next-line max-line-length
374             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
375         }
376     }
377 }
378 
379 // File: node_modules\openzeppelin-solidity\contracts\utils\ReentrancyGuard.sol
380 
381 
382 
383 /**
384  * @dev Contract module that helps prevent reentrant calls to a function.
385  *
386  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
387  * available, which can be aplied to functions to make sure there are no nested
388  * (reentrant) calls to them.
389  *
390  * Note that because there is a single `nonReentrant` guard, functions marked as
391  * `nonReentrant` may not call one another. This can be worked around by making
392  * those functions `private`, and then adding `external` `nonReentrant` entry
393  * points to them.
394  */
395 contract ReentrancyGuard {
396     /// @dev counter to allow mutex lock with only one SSTORE operation
397     uint256 private _guardCounter;
398 
399     constructor () internal {
400         // The counter starts at one to prevent changing it from zero to a non-zero
401         // value, which is a more expensive operation.
402         _guardCounter = 1;
403     }
404 
405     /**
406      * @dev Prevents a contract from calling itself, directly or indirectly.
407      * Calling a `nonReentrant` function from another `nonReentrant`
408      * function is not supported. It is possible to prevent this from happening
409      * by making the `nonReentrant` function external, and make it call a
410      * `private` function that does the actual work.
411      */
412     modifier nonReentrant() {
413         _guardCounter += 1;
414         uint256 localCounter = _guardCounter;
415         _;
416         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
417     }
418 }
419 
420 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\Crowdsale.sol
421 
422 
423 
424 
425 
426 
427 
428 /**
429  * @title Crowdsale
430  * @dev Crowdsale is a base contract for managing a token crowdsale,
431  * allowing investors to purchase tokens with ether. This contract implements
432  * such functionality in its most fundamental form and can be extended to provide additional
433  * functionality and/or custom behavior.
434  * The external interface represents the basic interface for purchasing tokens, and conforms
435  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
436  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
437  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
438  * behavior.
439  */
440 contract Crowdsale is ReentrancyGuard {
441     using SafeMath for uint256;
442     using SafeERC20 for IERC20;
443 
444     // The token being sold
445     IERC20 private _token;
446 
447     // Address where funds are collected
448     address payable private _wallet;
449 
450     // How many token units a buyer gets per wei.
451     // The rate is the conversion between wei and the smallest and indivisible token unit.
452     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
453     // 1 wei will give you 1 unit, or 0.001 TOK.
454     uint256 private _rate;
455 
456     // Amount of wei raised
457     uint256 private _weiRaised;
458 
459     /**
460      * Event for token purchase logging
461      * @param purchaser who paid for the tokens
462      * @param beneficiary who got the tokens
463      * @param value weis paid for purchase
464      * @param amount amount of tokens purchased
465      */
466     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
467 
468     /**
469      * @param rate Number of token units a buyer gets per wei
470      * @dev The rate is the conversion between wei and the smallest and indivisible
471      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
472      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
473      * @param wallet Address where collected funds will be forwarded to
474      * @param token Address of the token being sold
475      */
476     constructor (uint256 rate, address payable wallet, IERC20 token) public {
477         require(rate > 0, "Crowdsale: rate is 0");
478         require(wallet != address(0), "Crowdsale: wallet is the zero address");
479         require(address(token) != address(0), "Crowdsale: token is the zero address");
480 
481         _rate = rate;
482         _wallet = wallet;
483         _token = token;
484     }
485 
486     /**
487      * @dev fallback function ***DO NOT OVERRIDE***
488      * Note that other contracts will transfer funds with a base gas stipend
489      * of 2300, which is not enough to call buyTokens. Consider calling
490      * buyTokens directly when purchasing tokens from a contract.
491      */
492     function () external payable {
493         buyTokens(msg.sender);
494     }
495 
496     /**
497      * @return the token being sold.
498      */
499     function token() public view returns (IERC20) {
500         return _token;
501     }
502 
503     /**
504      * @return the address where funds are collected.
505      */
506     function wallet() public view returns (address payable) {
507         return _wallet;
508     }
509 
510     /**
511      * @return the number of token units a buyer gets per wei.
512      */
513     function rate() public view returns (uint256) {
514         return _rate;
515     }
516 
517     /**
518      * @return the amount of wei raised.
519      */
520     function weiRaised() public view returns (uint256) {
521         return _weiRaised;
522     }
523 
524     /**
525      * @dev low level token purchase ***DO NOT OVERRIDE***
526      * This function has a non-reentrancy guard, so it shouldn't be called by
527      * another `nonReentrant` function.
528      * @param beneficiary Recipient of the token purchase
529      */
530     function buyTokens(address beneficiary) public nonReentrant payable {
531         uint256 weiAmount = msg.value;
532         _preValidatePurchase(beneficiary, weiAmount);
533 
534         // calculate token amount to be created
535         uint256 tokens = _getTokenAmount(weiAmount);
536 
537         // update state
538         _weiRaised = _weiRaised.add(weiAmount);
539 
540         _processPurchase(beneficiary, tokens);
541         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
542 
543         _updatePurchasingState(beneficiary, weiAmount);
544 
545         _forwardFunds();
546         _postValidatePurchase(beneficiary, weiAmount);
547     }
548 
549     /**
550      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
551      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
552      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
553      *     super._preValidatePurchase(beneficiary, weiAmount);
554      *     require(weiRaised().add(weiAmount) <= cap);
555      * @param beneficiary Address performing the token purchase
556      * @param weiAmount Value in wei involved in the purchase
557      */
558     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
559         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
560         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
561     }
562 
563     /**
564      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
565      * conditions are not met.
566      * @param beneficiary Address performing the token purchase
567      * @param weiAmount Value in wei involved in the purchase
568      */
569     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
570         // solhint-disable-previous-line no-empty-blocks
571     }
572 
573     /**
574      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
575      * its tokens.
576      * @param beneficiary Address performing the token purchase
577      * @param tokenAmount Number of tokens to be emitted
578      */
579     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
580         _token.safeTransfer(beneficiary, tokenAmount);
581     }
582 
583     /**
584      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
585      * tokens.
586      * @param beneficiary Address receiving the tokens
587      * @param tokenAmount Number of tokens to be purchased
588      */
589     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
590         _deliverTokens(beneficiary, tokenAmount);
591     }
592 
593     /**
594      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
595      * etc.)
596      * @param beneficiary Address receiving the tokens
597      * @param weiAmount Value in wei involved in the purchase
598      */
599     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
600         // solhint-disable-previous-line no-empty-blocks
601     }
602 
603     /**
604      * @dev Override to extend the way in which ether is converted to tokens.
605      * @param weiAmount Value in wei to be converted into tokens
606      * @return Number of tokens that can be purchased with the specified _weiAmount
607      */
608     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
609         return weiAmount.mul(_rate);
610     }
611 
612     /**
613      * @dev Determines how ETH is stored/forwarded on purchases.
614      */
615     function _forwardFunds() internal {
616         _wallet.transfer(msg.value);
617     }
618 }
619 
620 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\validation\CappedCrowdsale.sol
621 
622 /**
623  * @dev Standard math utilities missing in the Solidity language.
624  */
625 library Math {
626     /**
627      * @dev Returns the largest of two numbers.
628      */
629     function max(uint256 a, uint256 b) internal pure returns (uint256) {
630         return a >= b ? a : b;
631     }
632 
633     /**
634      * @dev Returns the smallest of two numbers.
635      */
636     function min(uint256 a, uint256 b) internal pure returns (uint256) {
637         return a < b ? a : b;
638     }
639 
640     /**
641      * @dev Returns the average of two numbers. The result is rounded towards
642      * zero.
643      */
644     function average(uint256 a, uint256 b) internal pure returns (uint256) {
645         // (a + b) / 2 can overflow, so we distribute
646         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
647     }
648 }
649 
650 
651 /**
652  * @title CappedCrowdsale
653  * @dev Crowdsale with a limit for total contributions.
654  */
655 contract CappedCrowdsale is Crowdsale {
656     using SafeMath for uint256;
657 
658     uint256 private _cap;
659 
660     /**
661      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
662      * @param cap Max amount of wei to be contributed
663      */
664     constructor (uint256 cap) public {
665         require(cap > 0, "CappedCrowdsale: cap is 0");
666         _cap = cap;
667     }
668 
669     /**
670      * @return the cap of the crowdsale.
671      */
672     function cap() public view returns (uint256) {
673         return _cap;
674     }
675 
676     /**
677      * @dev Checks whether the cap has been reached.
678      * @return Whether the cap was reached
679      */
680     function capReached() public view returns (bool) {
681         return weiRaised() >= _cap;
682     }
683 
684     /**
685      * @dev Extend parent behavior requiring purchase to respect the funding cap.
686      * @param beneficiary Token purchaser
687      * @param weiAmount Amount of wei contributed
688      */
689     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
690         super._preValidatePurchase(beneficiary, weiAmount);
691         require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
692     }
693 }
694 
695 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\validation\TimedCrowdsale.sol
696 
697 
698 
699 
700 
701 /**
702  * @title TimedCrowdsale
703  * @dev Crowdsale accepting contributions only within a time frame.
704  */
705 contract TimedCrowdsale is Crowdsale {
706     using SafeMath for uint256;
707 
708     uint256 private _openingTime;
709     uint256 private _closingTime;
710 
711     /**
712      * Event for crowdsale extending
713      * @param newClosingTime new closing time
714      * @param prevClosingTime old closing time
715      */
716     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
717 
718     /**
719      * @dev Reverts if not in crowdsale time range.
720      */
721     modifier onlyWhileOpen {
722         require(isOpen(), "TimedCrowdsale: not open");
723         _;
724     }
725 
726     /**
727      * @dev Constructor, takes crowdsale opening and closing times.
728      * @param openingTime Crowdsale opening time
729      * @param closingTime Crowdsale closing time
730      */
731     constructor (uint256 openingTime, uint256 closingTime) public {
732         // solhint-disable-next-line not-rely-on-time
733         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
734         // solhint-disable-next-line max-line-length
735         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
736 
737         _openingTime = openingTime;
738         _closingTime = closingTime;
739     }
740 
741     /**
742      * @return the crowdsale opening time.
743      */
744     function openingTime() public view returns (uint256) {
745         return _openingTime;
746     }
747 
748     /**
749      * @return the crowdsale closing time.
750      */
751     function closingTime() public view returns (uint256) {
752         return _closingTime;
753     }
754 
755     /**
756      * @return true if the crowdsale is open, false otherwise.
757      */
758     function isOpen() public view returns (bool) {
759         // solhint-disable-next-line not-rely-on-time
760         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
761     }
762 
763     /**
764      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
765      * @return Whether crowdsale period has elapsed
766      */
767     function hasClosed() public view returns (bool) {
768         // solhint-disable-next-line not-rely-on-time
769         return block.timestamp > _closingTime;
770     }
771 
772     /**
773      * @dev Extend parent behavior requiring to be within contributing period.
774      * @param beneficiary Token purchaser
775      * @param weiAmount Amount of wei contributed
776      */
777     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
778         super._preValidatePurchase(beneficiary, weiAmount);
779     }
780 
781     /**
782      * @dev Extend crowdsale.
783      * @param newClosingTime Crowdsale closing time
784      */
785     function _extendTime(uint256 newClosingTime) internal {
786         require(!hasClosed(), "TimedCrowdsale: already closed");
787         // solhint-disable-next-line max-line-length
788         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
789 
790         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
791         _closingTime = newClosingTime;
792     }
793 }
794 
795 // File: node_modules\openzeppelin-solidity\contracts\access\Roles.sol
796 
797 
798 
799 /**
800  * @title Roles
801  * @dev Library for managing addresses assigned to a Role.
802  */
803 library Roles {
804     struct Role {
805         mapping (address => bool) bearer;
806     }
807 
808     /**
809      * @dev Give an account access to this role.
810      */
811     function add(Role storage role, address account) internal {
812         require(!has(role, account), "Roles: account already has role");
813         role.bearer[account] = true;
814     }
815 
816     /**
817      * @dev Remove an account's access to this role.
818      */
819     function remove(Role storage role, address account) internal {
820         require(has(role, account), "Roles: account does not have role");
821         role.bearer[account] = false;
822     }
823 
824     /**
825      * @dev Check if an account has this role.
826      * @return bool
827      */
828     function has(Role storage role, address account) internal view returns (bool) {
829         require(account != address(0), "Roles: account is the zero address");
830         return role.bearer[account];
831     }
832 }
833 
834 contract AllowanceCrowdsale is Crowdsale {
835     using SafeMath for uint256;
836     using SafeERC20 for IERC20;
837 
838     address private _tokenWallet;
839 
840     /**
841      * @dev Constructor, takes token wallet address.
842      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale.
843      */
844     constructor (address tokenWallet) public {
845         require(tokenWallet != address(0), "AllowanceCrowdsale: token wallet is the zero address");
846         _tokenWallet = tokenWallet;
847     }
848 
849     /**
850      * @return the address of the wallet that will hold the tokens.
851      */
852     function tokenWallet() public view returns (address) {
853         return _tokenWallet;
854     }
855 
856     /**
857      * @dev Checks the amount of tokens left in the allowance.
858      * @return Amount of tokens left in the allowance
859      */
860     function remainingTokens() public view returns (uint256) {
861         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
862     }
863 
864     /**
865      * @dev Overrides parent behavior by transferring tokens from wallet.
866      * @param beneficiary Token purchaser
867      * @param tokenAmount Amount of tokens purchased
868      */
869     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
870         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
871     }
872 }
873 /**
874  * @title __unstable__TokenVault
875  * @dev Similar to an Escrow for tokens, this contract allows its primary account to spend its tokens as it sees fit.
876  * This contract is an internal helper for PostDeliveryCrowdsale, and should not be used outside of this context.
877  */
878 // solhint-disable-next-line contract-name-camelcase
879 
880 // File: contracts\TonCrowdsale.sol
881 
882 contract TonCrowdsale is
883 Crowdsale,
884 CappedCrowdsale,
885 TimedCrowdsale,
886 AllowanceCrowdsale,
887 Ownable
888 {
889   // Track investor contributions
890   uint256 public investorMinCap  =   10000000000000000;    // 0.01 ether
891   uint256 public investorHardCap = 2000000000000000000;    // 2 ether
892   uint256 constant public maxGasPrice =  1000000000000;    // 1000 Gwei
893   uint256 _rate = 40000;
894   uint256 _cap  = 621539400000000000000;
895   mapping(address => uint256) public contributions;
896 
897   constructor(
898     IERC20 _token,
899     address  _walletAddress,
900     address payable _fundAddress,
901     uint256 _openingTime,
902     uint256 _closingTime
903   )
904     Crowdsale(_rate, _fundAddress, _token)
905     CappedCrowdsale(_cap)
906     AllowanceCrowdsale(_walletAddress)
907     TimedCrowdsale(_openingTime, _closingTime)
908     public
909   {
910 
911   }
912 
913   /**
914   * @dev Returns the amount contributed so far by a sepecific user.
915   * @param _beneficiary Address of contributor
916   * @return User contribution so far
917   */
918   function getContribution(address _beneficiary)
919     public view returns (uint256)
920   {
921     return contributions[_beneficiary];
922   }
923 
924   /**
925   * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
926   * @param beneficiary Token purchaser
927   * @param weiAmount Amount of wei contributed
928   */
929   function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
930       uint256 newContribution = contributions[beneficiary].add(weiAmount);
931       require(tx.gasprice <= maxGasPrice,"TonCrowdsale: beneficiary's max Gas Price exceeded");
932       require(newContribution <= investorHardCap, "TonCrowdsale: beneficiary's max cap exceeded");
933       require(newContribution >= investorMinCap, "TonCrowdsale: beneficiary's min cap not reached");
934       super._preValidatePurchase(beneficiary, weiAmount);
935       // solhint-disable-next-line max-line-length
936   }
937 
938   /**
939   * @dev Extend parent behavior to update beneficiary contributions.
940   * @param beneficiary Token purchaser
941   * @param weiAmount Amount of wei contributed
942   */
943   function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
944       super._updatePurchasingState(beneficiary, weiAmount);
945       contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
946   }
947 
948 }