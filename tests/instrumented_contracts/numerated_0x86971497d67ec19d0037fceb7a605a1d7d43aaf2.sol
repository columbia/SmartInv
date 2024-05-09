1 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
80 
81 
82 
83 /**
84  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
85  * the optional functions; to access them see `ERC20Detailed`.
86  */
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92 
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
95      */
96     function balanceOf(address account) external view returns (uint256);
97 
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `recipient`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a `Transfer` event.
104      */
105     function transfer(address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through `transferFrom`. This is
110      * zero by default.
111      *
112      * This value changes when `approve` or `transferFrom` are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     /**
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * > Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an `Approval` event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Moves `amount` tokens from `sender` to `recipient` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a `Transfer` event.
140      */
141     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Emitted when `value` tokens are moved from one account (`from`) to
145      * another (`to`).
146      *
147      * Note that `value` may be zero.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 value);
150 
151     /**
152      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
153      * a call to `approve`. `value` is the new allowance.
154      */
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
159 
160 
161 
162 /**
163  * @dev Wrappers over Solidity's arithmetic operations with added overflow
164  * checks.
165  *
166  * Arithmetic operations in Solidity wrap on overflow. This can easily result
167  * in bugs, because programmers usually assume that an overflow raises an
168  * error, which is the standard behavior in high level programming languages.
169  * `SafeMath` restores this intuition by reverting the transaction when an
170  * operation overflows.
171  *
172  * Using this library instead of the unchecked operations eliminates an entire
173  * class of bugs, so it's recommended to use it always.
174  */
175 library SafeMath {
176     /**
177      * @dev Returns the addition of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `+` operator.
181      *
182      * Requirements:
183      * - Addition cannot overflow.
184      */
185     function add(uint256 a, uint256 b) internal pure returns (uint256) {
186         uint256 c = a + b;
187         require(c >= a, "SafeMath: addition overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting on
194      * overflow (when the result is negative).
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      * - Subtraction cannot overflow.
200      */
201     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202         require(b <= a, "SafeMath: subtraction overflow");
203         uint256 c = a - b;
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the multiplication of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `*` operator.
213      *
214      * Requirements:
215      * - Multiplication cannot overflow.
216      */
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
219         // benefit is lost if 'b' is also tested.
220         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
221         if (a == 0) {
222             return 0;
223         }
224 
225         uint256 c = a * b;
226         require(c / a == b, "SafeMath: multiplication overflow");
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b) internal pure returns (uint256) {
243         // Solidity only automatically asserts when dividing by 0
244         require(b > 0, "SafeMath: division by zero");
245         uint256 c = a / b;
246         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         require(b != 0, "SafeMath: modulo by zero");
264         return a % b;
265     }
266 }
267 
268 // File: node_modules\openzeppelin-solidity\contracts\utils\Address.sol
269 
270 
271 
272 /**
273  * @dev Collection of functions related to the address type,
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * This test is non-exhaustive, and there may be false-negatives: during the
280      * execution of a contract's constructor, its address will be reported as
281      * not containing a contract.
282      *
283      * > It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      */
286     function isContract(address account) internal view returns (bool) {
287         // This method relies in extcodesize, which returns 0 for contracts in
288         // construction, since the code is only stored at the end of the
289         // constructor execution.
290 
291         uint256 size;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { size := extcodesize(account) }
294         return size > 0;
295     }
296 }
297 
298 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
299 
300 
301 
302 
303 
304 
305 /**
306  * @title SafeERC20
307  * @dev Wrappers around ERC20 operations that throw on failure (when the token
308  * contract returns false). Tokens that return no value (and instead revert or
309  * throw on failure) are also supported, non-reverting calls are assumed to be
310  * successful.
311  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
312  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
313  */
314 library SafeERC20 {
315     using SafeMath for uint256;
316     using Address for address;
317 
318     function safeTransfer(IERC20 token, address to, uint256 value) internal {
319         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
320     }
321 
322     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
323         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
324     }
325 
326     function safeApprove(IERC20 token, address spender, uint256 value) internal {
327         // safeApprove should only be called when setting an initial allowance,
328         // or when resetting it to zero. To increase and decrease it, use
329         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
330         // solhint-disable-next-line max-line-length
331         require((value == 0) || (token.allowance(address(this), spender) == 0),
332             "SafeERC20: approve from non-zero to non-zero allowance"
333         );
334         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
335     }
336 
337     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
338         uint256 newAllowance = token.allowance(address(this), spender).add(value);
339         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
340     }
341 
342     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
343         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
344         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
345     }
346 
347     /**
348      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
349      * on the return value: the return value is optional (but if data is returned, it must not be false).
350      * @param token The token targeted by the call.
351      * @param data The call data (encoded using abi.encode or one of its variants).
352      */
353     function callOptionalReturn(IERC20 token, bytes memory data) private {
354         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
355         // we're implementing it ourselves.
356 
357         // A Solidity high level call has three parts:
358         //  1. The target address is checked to verify it contains contract code
359         //  2. The call itself is made, and success asserted
360         //  3. The return value is decoded, which in turn checks the size of the returned data.
361         // solhint-disable-next-line max-line-length
362         require(address(token).isContract(), "SafeERC20: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = address(token).call(data);
366         require(success, "SafeERC20: low-level call failed");
367 
368         if (returndata.length > 0) { // Return data is optional
369             // solhint-disable-next-line max-line-length
370             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
371         }
372     }
373 }
374 
375 // File: node_modules\openzeppelin-solidity\contracts\utils\ReentrancyGuard.sol
376 
377 
378 
379 /**
380  * @dev Contract module that helps prevent reentrant calls to a function.
381  *
382  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
383  * available, which can be aplied to functions to make sure there are no nested
384  * (reentrant) calls to them.
385  *
386  * Note that because there is a single `nonReentrant` guard, functions marked as
387  * `nonReentrant` may not call one another. This can be worked around by making
388  * those functions `private`, and then adding `external` `nonReentrant` entry
389  * points to them.
390  */
391 contract ReentrancyGuard {
392     /// @dev counter to allow mutex lock with only one SSTORE operation
393     uint256 private _guardCounter;
394 
395     constructor () internal {
396         // The counter starts at one to prevent changing it from zero to a non-zero
397         // value, which is a more expensive operation.
398         _guardCounter = 1;
399     }
400 
401     /**
402      * @dev Prevents a contract from calling itself, directly or indirectly.
403      * Calling a `nonReentrant` function from another `nonReentrant`
404      * function is not supported. It is possible to prevent this from happening
405      * by making the `nonReentrant` function external, and make it call a
406      * `private` function that does the actual work.
407      */
408     modifier nonReentrant() {
409         _guardCounter += 1;
410         uint256 localCounter = _guardCounter;
411         _;
412         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
413     }
414 }
415 
416 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\Crowdsale.sol
417 
418 
419 
420 
421 
422 
423 
424 /**
425  * @title Crowdsale
426  * @dev Crowdsale is a base contract for managing a token crowdsale,
427  * allowing investors to purchase tokens with ether. This contract implements
428  * such functionality in its most fundamental form and can be extended to provide additional
429  * functionality and/or custom behavior.
430  * The external interface represents the basic interface for purchasing tokens, and conforms
431  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
432  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
433  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
434  * behavior.
435  */
436 contract Crowdsale is ReentrancyGuard {
437     using SafeMath for uint256;
438     using SafeERC20 for IERC20;
439 
440     // The token being sold
441     IERC20 private _token;
442 
443     // Address where funds are collected
444     address payable private _wallet;
445 
446     // How many token units a buyer gets per wei.
447     // The rate is the conversion between wei and the smallest and indivisible token unit.
448     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
449     // 1 wei will give you 1 unit, or 0.001 TOK.
450     uint256 private _rate;
451 
452     // Amount of wei raised
453     uint256 private _weiRaised;
454 
455     /**
456      * Event for token purchase logging
457      * @param purchaser who paid for the tokens
458      * @param beneficiary who got the tokens
459      * @param value weis paid for purchase
460      * @param amount amount of tokens purchased
461      */
462     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
463 
464     /**
465      * @param rate Number of token units a buyer gets per wei
466      * @dev The rate is the conversion between wei and the smallest and indivisible
467      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
468      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
469      * @param wallet Address where collected funds will be forwarded to
470      * @param token Address of the token being sold
471      */
472     constructor (uint256 rate, address payable wallet, IERC20 token) public {
473         require(rate > 0, "Crowdsale: rate is 0");
474         require(wallet != address(0), "Crowdsale: wallet is the zero address");
475         require(address(token) != address(0), "Crowdsale: token is the zero address");
476 
477         _rate = rate;
478         _wallet = wallet;
479         _token = token;
480     }
481 
482     /**
483      * @dev fallback function ***DO NOT OVERRIDE***
484      * Note that other contracts will transfer funds with a base gas stipend
485      * of 2300, which is not enough to call buyTokens. Consider calling
486      * buyTokens directly when purchasing tokens from a contract.
487      */
488     function () external payable {
489         buyTokens(msg.sender);
490     }
491 
492     /**
493      * @return the token being sold.
494      */
495     function token() public view returns (IERC20) {
496         return _token;
497     }
498 
499     /**
500      * @return the address where funds are collected.
501      */
502     function wallet() public view returns (address payable) {
503         return _wallet;
504     }
505 
506     /**
507      * @return the number of token units a buyer gets per wei.
508      */
509     function rate() public view returns (uint256) {
510         return _rate;
511     }
512 
513     /**
514      * @return the amount of wei raised.
515      */
516     function weiRaised() public view returns (uint256) {
517         return _weiRaised;
518     }
519 
520     /**
521      * @dev low level token purchase ***DO NOT OVERRIDE***
522      * This function has a non-reentrancy guard, so it shouldn't be called by
523      * another `nonReentrant` function.
524      * @param beneficiary Recipient of the token purchase
525      */
526     function buyTokens(address beneficiary) public nonReentrant payable {
527         uint256 weiAmount = msg.value;
528         _preValidatePurchase(beneficiary, weiAmount);
529 
530         // calculate token amount to be created
531         uint256 tokens = _getTokenAmount(weiAmount);
532 
533         // update state
534         _weiRaised = _weiRaised.add(weiAmount);
535 
536         _processPurchase(beneficiary, tokens);
537         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
538 
539         _updatePurchasingState(beneficiary, weiAmount);
540 
541         _forwardFunds();
542         _postValidatePurchase(beneficiary, weiAmount);
543     }
544 
545     /**
546      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
547      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
548      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
549      *     super._preValidatePurchase(beneficiary, weiAmount);
550      *     require(weiRaised().add(weiAmount) <= cap);
551      * @param beneficiary Address performing the token purchase
552      * @param weiAmount Value in wei involved in the purchase
553      */
554     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
555         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
556         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
557     }
558 
559     /**
560      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
561      * conditions are not met.
562      * @param beneficiary Address performing the token purchase
563      * @param weiAmount Value in wei involved in the purchase
564      */
565     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
566         // solhint-disable-previous-line no-empty-blocks
567     }
568 
569     /**
570      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
571      * its tokens.
572      * @param beneficiary Address performing the token purchase
573      * @param tokenAmount Number of tokens to be emitted
574      */
575     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
576         _token.safeTransfer(beneficiary, tokenAmount);
577     }
578 
579     /**
580      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
581      * tokens.
582      * @param beneficiary Address receiving the tokens
583      * @param tokenAmount Number of tokens to be purchased
584      */
585     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
586         _deliverTokens(beneficiary, tokenAmount);
587     }
588 
589     /**
590      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
591      * etc.)
592      * @param beneficiary Address receiving the tokens
593      * @param weiAmount Value in wei involved in the purchase
594      */
595     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
596         // solhint-disable-previous-line no-empty-blocks
597     }
598 
599     /**
600      * @dev Override to extend the way in which ether is converted to tokens.
601      * @param weiAmount Value in wei to be converted into tokens
602      * @return Number of tokens that can be purchased with the specified _weiAmount
603      */
604     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
605         return weiAmount.mul(_rate);
606     }
607 
608     /**
609      * @dev Determines how ETH is stored/forwarded on purchases.
610      */
611     function _forwardFunds() internal {
612         _wallet.transfer(msg.value);
613     }
614 }
615 
616 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\validation\CappedCrowdsale.sol
617 
618 
619 
620 
621 
622 /**
623  * @title CappedCrowdsale
624  * @dev Crowdsale with a limit for total contributions.
625  */
626 contract CappedCrowdsale is Crowdsale {
627     using SafeMath for uint256;
628 
629     uint256 private _cap;
630 
631     /**
632      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
633      * @param cap Max amount of wei to be contributed
634      */
635     constructor (uint256 cap) public {
636         require(cap > 0, "CappedCrowdsale: cap is 0");
637         _cap = cap;
638     }
639 
640     /**
641      * @return the cap of the crowdsale.
642      */
643     function cap() public view returns (uint256) {
644         return _cap;
645     }
646 
647     /**
648      * @dev Checks whether the cap has been reached.
649      * @return Whether the cap was reached
650      */
651     function capReached() public view returns (bool) {
652         return weiRaised() >= _cap;
653     }
654 
655     /**
656      * @dev Extend parent behavior requiring purchase to respect the funding cap.
657      * @param beneficiary Token purchaser
658      * @param weiAmount Amount of wei contributed
659      */
660     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
661         super._preValidatePurchase(beneficiary, weiAmount);
662         require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
663     }
664 }
665 
666 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\validation\TimedCrowdsale.sol
667 
668 
669 
670 
671 
672 /**
673  * @title TimedCrowdsale
674  * @dev Crowdsale accepting contributions only within a time frame.
675  */
676 contract TimedCrowdsale is Crowdsale {
677     using SafeMath for uint256;
678 
679     uint256 private _openingTime;
680     uint256 private _closingTime;
681 
682     /**
683      * Event for crowdsale extending
684      * @param newClosingTime new closing time
685      * @param prevClosingTime old closing time
686      */
687     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
688 
689     /**
690      * @dev Reverts if not in crowdsale time range.
691      */
692     modifier onlyWhileOpen {
693         require(isOpen(), "TimedCrowdsale: not open");
694         _;
695     }
696 
697     /**
698      * @dev Constructor, takes crowdsale opening and closing times.
699      * @param openingTime Crowdsale opening time
700      * @param closingTime Crowdsale closing time
701      */
702     constructor (uint256 openingTime, uint256 closingTime) public {
703         // solhint-disable-next-line not-rely-on-time
704         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
705         // solhint-disable-next-line max-line-length
706         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
707 
708         _openingTime = openingTime;
709         _closingTime = closingTime;
710     }
711 
712     /**
713      * @return the crowdsale opening time.
714      */
715     function openingTime() public view returns (uint256) {
716         return _openingTime;
717     }
718 
719     /**
720      * @return the crowdsale closing time.
721      */
722     function closingTime() public view returns (uint256) {
723         return _closingTime;
724     }
725 
726     /**
727      * @return true if the crowdsale is open, false otherwise.
728      */
729     function isOpen() public view returns (bool) {
730         // solhint-disable-next-line not-rely-on-time
731         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
732     }
733 
734     /**
735      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
736      * @return Whether crowdsale period has elapsed
737      */
738     function hasClosed() public view returns (bool) {
739         // solhint-disable-next-line not-rely-on-time
740         return block.timestamp > _closingTime;
741     }
742 
743     /**
744      * @dev Extend parent behavior requiring to be within contributing period.
745      * @param beneficiary Token purchaser
746      * @param weiAmount Amount of wei contributed
747      */
748     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
749         super._preValidatePurchase(beneficiary, weiAmount);
750     }
751 
752     /**
753      * @dev Extend crowdsale.
754      * @param newClosingTime Crowdsale closing time
755      */
756     function _extendTime(uint256 newClosingTime) internal {
757         require(!hasClosed(), "TimedCrowdsale: already closed");
758         // solhint-disable-next-line max-line-length
759         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
760 
761         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
762         _closingTime = newClosingTime;
763     }
764 }
765 
766 // File: node_modules\openzeppelin-solidity\contracts\access\Roles.sol
767 
768 
769 
770 /**
771  * @title Roles
772  * @dev Library for managing addresses assigned to a Role.
773  */
774 library Roles {
775     struct Role {
776         mapping (address => bool) bearer;
777     }
778 
779     /**
780      * @dev Give an account access to this role.
781      */
782     function add(Role storage role, address account) internal {
783         require(!has(role, account), "Roles: account already has role");
784         role.bearer[account] = true;
785     }
786 
787     /**
788      * @dev Remove an account's access to this role.
789      */
790     function remove(Role storage role, address account) internal {
791         require(has(role, account), "Roles: account does not have role");
792         role.bearer[account] = false;
793     }
794 
795     /**
796      * @dev Check if an account has this role.
797      * @return bool
798      */
799     function has(Role storage role, address account) internal view returns (bool) {
800         require(account != address(0), "Roles: account is the zero address");
801         return role.bearer[account];
802     }
803 }
804 
805 // File: node_modules\openzeppelin-solidity\contracts\access\roles\WhitelistAdminRole.sol
806 
807 
808 
809 
810 /**
811  * @title WhitelistAdminRole
812  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
813  */
814 contract WhitelistAdminRole {
815     using Roles for Roles.Role;
816 
817     event WhitelistAdminAdded(address indexed account);
818     event WhitelistAdminRemoved(address indexed account);
819 
820     Roles.Role private _whitelistAdmins;
821 
822     constructor () internal {
823         _addWhitelistAdmin(msg.sender);
824     }
825 
826     modifier onlyWhitelistAdmin() {
827         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
828         _;
829     }
830 
831     function isWhitelistAdmin(address account) public view returns (bool) {
832         return _whitelistAdmins.has(account);
833     }
834 
835     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
836         _addWhitelistAdmin(account);
837     }
838 
839     function renounceWhitelistAdmin() public {
840         _removeWhitelistAdmin(msg.sender);
841     }
842 
843     function _addWhitelistAdmin(address account) internal {
844         _whitelistAdmins.add(account);
845         emit WhitelistAdminAdded(account);
846     }
847 
848     function _removeWhitelistAdmin(address account) internal {
849         _whitelistAdmins.remove(account);
850         emit WhitelistAdminRemoved(account);
851     }
852 }
853 
854 // File: node_modules\openzeppelin-solidity\contracts\access\roles\WhitelistedRole.sol
855 
856 
857 
858 
859 
860 /**
861  * @title WhitelistedRole
862  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
863  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
864  * it), and not Whitelisteds themselves.
865  */
866 contract WhitelistedRole is WhitelistAdminRole {
867     using Roles for Roles.Role;
868 
869     event WhitelistedAdded(address indexed account);
870     event WhitelistedRemoved(address indexed account);
871 
872     Roles.Role private _whitelisteds;
873 
874     modifier onlyWhitelisted() {
875         require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");
876         _;
877     }
878 
879     function isWhitelisted(address account) public view returns (bool) {
880         return _whitelisteds.has(account);
881     }
882 
883     function addWhitelisted(address account) public onlyWhitelistAdmin {
884         _addWhitelisted(account);
885     }
886 
887     function removeWhitelisted(address account) public onlyWhitelistAdmin {
888         _removeWhitelisted(account);
889     }
890 
891     function renounceWhitelisted() public {
892         _removeWhitelisted(msg.sender);
893     }
894 
895     function _addWhitelisted(address account) internal {
896         _whitelisteds.add(account);
897         emit WhitelistedAdded(account);
898     }
899 
900     function _removeWhitelisted(address account) internal {
901         _whitelisteds.remove(account);
902         emit WhitelistedRemoved(account);
903     }
904 }
905 
906 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\validation\WhitelistCrowdsale.sol
907 
908 
909 
910 
911 
912 
913 /**
914  * @title WhitelistCrowdsale
915  * @dev Crowdsale in which only whitelisted users can contribute.
916  */
917 contract WhitelistCrowdsale is WhitelistedRole, Crowdsale {
918     /**
919      * @dev Extend parent behavior requiring beneficiary to be whitelisted. Note that no
920      * restriction is imposed on the account sending the transaction.
921      * @param _beneficiary Token beneficiary
922      * @param _weiAmount Amount of wei contributed
923      */
924     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
925         require(isWhitelisted(_beneficiary), "WhitelistCrowdsale: beneficiary doesn't have the Whitelisted role");
926         super._preValidatePurchase(_beneficiary, _weiAmount);
927     }
928 }
929 
930 // File: node_modules\openzeppelin-solidity\contracts\ownership\Secondary.sol
931 
932 
933 
934 /**
935  * @dev A Secondary contract can only be used by its primary account (the one that created it).
936  */
937 contract Secondary {
938     address private _primary;
939 
940     /**
941      * @dev Emitted when the primary contract changes.
942      */
943     event PrimaryTransferred(
944         address recipient
945     );
946 
947     /**
948      * @dev Sets the primary account to the one that is creating the Secondary contract.
949      */
950     constructor () internal {
951         _primary = msg.sender;
952         emit PrimaryTransferred(_primary);
953     }
954 
955     /**
956      * @dev Reverts if called from any account other than the primary.
957      */
958     modifier onlyPrimary() {
959         require(msg.sender == _primary, "Secondary: caller is not the primary account");
960         _;
961     }
962 
963     /**
964      * @return the address of the primary.
965      */
966     function primary() public view returns (address) {
967         return _primary;
968     }
969 
970     /**
971      * @dev Transfers contract to a new primary.
972      * @param recipient The address of new primary.
973      */
974     function transferPrimary(address recipient) public onlyPrimary {
975         require(recipient != address(0), "Secondary: new primary is the zero address");
976         _primary = recipient;
977         emit PrimaryTransferred(_primary);
978     }
979 }
980 
981 // File: node_modules\openzeppelin-solidity\contracts\crowdsale\distribution\PostDeliveryCrowdsale.sol
982 
983 
984 
985 
986 
987 
988 
989 /**
990  * @title PostDeliveryCrowdsale
991  * @dev Crowdsale that locks tokens from withdrawal until it ends.
992  */
993 contract PostDeliveryCrowdsale is TimedCrowdsale {
994     using SafeMath for uint256;
995 
996     mapping(address => uint256) private _balances;
997     __unstable__TokenVault private _vault;
998 
999     constructor() public {
1000         _vault = new __unstable__TokenVault();
1001     }
1002 
1003     /**
1004      * @dev Withdraw tokens only after crowdsale ends.
1005      * @param beneficiary Whose tokens will be withdrawn.
1006      */
1007     function withdrawTokens(address beneficiary) public {
1008         require(hasClosed(), "PostDeliveryCrowdsale: not closed");
1009         uint256 amount = _balances[beneficiary];
1010         require(amount > 0, "PostDeliveryCrowdsale: beneficiary is not due any tokens");
1011 
1012         _balances[beneficiary] = 0;
1013         _vault.transfer(token(), beneficiary, amount);
1014     }
1015 
1016     /**
1017      * @return the balance of an account.
1018      */
1019     function balanceOf(address account) public view returns (uint256) {
1020         return _balances[account];
1021     }
1022 
1023     /**
1024      * @dev Overrides parent by storing due balances, and delivering tokens to the vault instead of the end user. This
1025      * ensures that the tokens will be available by the time they are withdrawn (which may not be the case if
1026      * `_deliverTokens` was called later).
1027      * @param beneficiary Token purchaser
1028      * @param tokenAmount Amount of tokens purchased
1029      */
1030     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
1031         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
1032         _deliverTokens(address(_vault), tokenAmount);
1033     }
1034 }
1035 
1036 /**
1037  * @title __unstable__TokenVault
1038  * @dev Similar to an Escrow for tokens, this contract allows its primary account to spend its tokens as it sees fit.
1039  * This contract is an internal helper for PostDeliveryCrowdsale, and should not be used outside of this context.
1040  */
1041 // solhint-disable-next-line contract-name-camelcase
1042 contract __unstable__TokenVault is Secondary {
1043     function transfer(IERC20 token, address to, uint256 amount) public onlyPrimary {
1044         token.transfer(to, amount);
1045     }
1046 }
1047 
1048 // File: contracts\JarvisPlusTokenCrowdsale.sol
1049 
1050 
1051 
1052 
1053 
1054 
1055 
1056 
1057 
1058 
1059 
1060 contract JarvisPlusTokenCrowdsale is
1061 Crowdsale,
1062 CappedCrowdsale,
1063 TimedCrowdsale,
1064 WhitelistCrowdsale,
1065 PostDeliveryCrowdsale,
1066 Ownable
1067 {
1068   // Track investor contributions
1069   uint256 public investorMinCap  = 500000000000000000;      // 0.5 ether
1070   uint256 public investorHardCap = 10000000000000000000;    // 10 ether
1071   uint256 _rate = 7200;
1072   mapping(address => uint256) public contributions;
1073 
1074   constructor(
1075     IERC20 _token,
1076     uint256 _cap,
1077     uint256 _openingTime,
1078     uint256 _closingTime,
1079     address[] memory _operators
1080   )
1081     Crowdsale(_rate, msg.sender, _token)
1082     CappedCrowdsale(_cap)
1083     TimedCrowdsale(_openingTime, _closingTime)
1084     public
1085   {
1086     for (uint i = 0; i < _operators.length; i++) {
1087       _addWhitelisted(_operators[i]);
1088     }
1089   }
1090 
1091   /**
1092   * @dev Returns the amount contributed so far by a sepecific user.
1093   * @param _beneficiary Address of contributor
1094   * @return User contribution so far
1095   */
1096   function getContribution(address _beneficiary)
1097     public view returns (uint256)
1098   {
1099     return contributions[_beneficiary];
1100   }
1101 
1102   /**
1103   * @dev Owner could redeem surplus tokens from the crowdsale contract address
1104   */
1105   function redeem() public onlyOwner
1106   {
1107     IERC20 token = token();
1108     uint256 balance = token.balanceOf(address(this));
1109     require(balance > 0, "JarvisPlusTokenCrowdsale: no tokens to redeem");
1110     token.safeTransfer(owner(), balance);
1111   }
1112 
1113   /**
1114   * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
1115   * @param beneficiary Token purchaser
1116   * @param weiAmount Amount of wei contributed
1117   */
1118   function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1119       super._preValidatePurchase(beneficiary, weiAmount);
1120       // solhint-disable-next-line max-line-length
1121       uint256 newContribution = contributions[beneficiary].add(weiAmount);
1122       require(newContribution <= investorHardCap, "JarvisPlusTokenCrowdsale: beneficiary's max cap exceeded");
1123       require(newContribution >= investorMinCap, "JarvisPlusTokenCrowdsale: beneficiary's min cap not reached");
1124   }
1125 
1126   /**
1127   * @dev Extend parent behavior to update beneficiary contributions.
1128   * @param beneficiary Token purchaser
1129   * @param weiAmount Amount of wei contributed
1130   */
1131   function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
1132       super._updatePurchasingState(beneficiary, weiAmount);
1133       contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
1134   }
1135 
1136 }