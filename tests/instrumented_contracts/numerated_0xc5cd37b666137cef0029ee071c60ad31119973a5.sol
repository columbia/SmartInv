1 pragma solidity ^0.5.0;
2 /**
3  * @title Math
4  * @dev Assorted math operations.
5  */
6 library Math {
7     /**
8      * @dev Returns the largest of two numbers.
9      */
10     function max(uint256 a, uint256 b) internal pure returns (uint256) {
11         return a >= b ? a : b;
12     }
13 
14     /**
15      * @dev Returns the smallest of two numbers.
16      */
17     function min(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a < b ? a : b;
19     }
20 
21     /**
22      * @dev Calculates the average of two numbers. Since these are integers,
23      * averages of an even and odd number cannot be represented, and will be
24      * rounded down.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
32 /**
33  * @title SafeMath
34  * @dev Unsigned math operations with safety checks that revert on error.
35  */
36 library SafeMath {
37     /**
38      * @dev Multiplies two unsigned integers, reverts on overflow.
39      */
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42         // benefit is lost if 'b' is also tested.
43         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53 
54     /**
55      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
56      */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // Solidity only automatically asserts when dividing by 0
59         require(b > 0, "SafeMath: division by zero");
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 
66     /**
67      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b <= a, "SafeMath: subtraction overflow");
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77      * @dev Adds two unsigned integers, reverts on overflow.
78      */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82 
83         return c;
84     }
85 
86     /**
87      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
88      * reverts when dividing by zero.
89      */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0, "SafeMath: modulo by zero");
92         return a % b;
93     }
94 }
95 
96 /**
97  * Utility library of inline functions on addresses
98  */
99 library Address {
100     /**
101      * Returns whether the target address is a contract
102      * @dev This function will return false if invoked during the constructor of a contract,
103      * as the code is not actually created until after the constructor finishes.
104      * @param account address of the account to check
105      * @return whether the target address is a contract
106      */
107     function isContract(address account) internal view returns (bool) {
108         uint256 size;
109         // XXX Currently there is no better way to check if there is a contract in an address
110         // than to check the size of the code at that address.
111         // See https://ethereum.stackexchange.com/a/14016/36603
112         // for more details about how this works.
113         // TODO Check this again before the Serenity release, because all addresses will be
114         // contracts then.
115         // solhint-disable-next-line no-inline-assembly
116         assembly { size := extcodesize(account) }
117         return size > 0;
118     }
119 }
120 
121 /**
122  * @title SafeERC20
123  * @dev Wrappers around ERC20 operations that throw on failure (when the token
124  * contract returns false). Tokens that return no value (and instead revert or
125  * throw on failure) are also supported, non-reverting calls are assumed to be
126  * successful.
127  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
128  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
129  */
130 library SafeERC20 {
131     using SafeMath for uint256;
132     using Address for address;
133 
134     function safeTransfer(IERC20 token, address to, uint256 value) internal {
135         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
136     }
137 
138     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
139         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
140     }
141 
142     function safeApprove(IERC20 token, address spender, uint256 value) internal {
143         // safeApprove should only be called when setting an initial allowance,
144         // or when resetting it to zero. To increase and decrease it, use
145         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
146         // solhint-disable-next-line max-line-length
147         require((value == 0) || (token.allowance(address(this), spender) == 0),
148             "SafeERC20: approve from non-zero to non-zero allowance"
149         );
150         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
151     }
152 
153     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
154         uint256 newAllowance = token.allowance(address(this), spender).add(value);
155         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
156     }
157 
158     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
159         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
160         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
161     }
162 
163     /**
164      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
165      * on the return value: the return value is optional (but if data is returned, it must not be false).
166      * @param token The token targeted by the call.
167      * @param data The call data (encoded using abi.encode or one of its variants).
168      */
169     function callOptionalReturn(IERC20 token, bytes memory data) private {
170         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
171         // we're implementing it ourselves.
172 
173         // A Solidity high level call has three parts:
174         //  1. The target address is checked to verify it contains contract code
175         //  2. The call itself is made, and success asserted
176         //  3. The return value is decoded, which in turn checks the size of the returned data.
177         // solhint-disable-next-line max-line-length
178         require(address(token).isContract(), "SafeERC20: call to non-contract");
179 
180         // solhint-disable-next-line avoid-low-level-calls
181         (bool success, bytes memory returndata) = address(token).call(data);
182         require(success, "SafeERC20: low-level call failed");
183 
184         if (returndata.length > 0) { // Return data is optional
185             // solhint-disable-next-line max-line-length
186             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
187         }
188     }
189 }
190 /**
191  * @title Helps contracts guard against reentrancy attacks.
192  * @author Remco Bloemen <remco@2?.com>, Eenae <alexey@mixbytes.io>
193  * @dev If you mark a function `nonReentrant`, you should also
194  * mark it `external`.
195  */
196 contract ReentrancyGuard {
197     /// @dev counter to allow mutex lock with only one SSTORE operation
198     uint256 private _guardCounter;
199 
200     constructor () internal {
201         // The counter starts at one to prevent changing it from zero to a non-zero
202         // value, which is a more expensive operation.
203         _guardCounter = 1;
204     }
205 
206     /**
207      * @dev Prevents a contract from calling itself, directly or indirectly.
208      * Calling a `nonReentrant` function from another `nonReentrant`
209      * function is not supported. It is possible to prevent this from happening
210      * by making the `nonReentrant` function external, and make it call a
211      * `private` function that does the actual work.
212      */
213     modifier nonReentrant() {
214         _guardCounter += 1;
215         uint256 localCounter = _guardCounter;
216         _;
217         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
218     }
219 }
220 
221 /**
222  * @title Crowdsale
223  * @dev Crowdsale is a base contract for managing a token crowdsale,
224  * allowing investors to purchase tokens with ether. This contract implements
225  * such functionality in its most fundamental form and can be extended to provide additional
226  * functionality and/or custom behavior.
227  * The external interface represents the basic interface for purchasing tokens, and conforms
228  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
229  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
230  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
231  * behavior.
232  */
233 contract Crowdsale is ReentrancyGuard {
234     using SafeMath for uint256;
235     using SafeERC20 for IERC20;
236 
237     // The token being sold
238     IERC20 private _token;
239 
240     // Address where funds are collected
241     address payable private _wallet;
242 
243     // How many token units a buyer gets per wei.
244     // The rate is the conversion between wei and the smallest and indivisible token unit.
245     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
246     // 1 wei will give you 1 unit, or 0.001 TOK.
247     uint256 private _rate;
248 
249     // Amount of wei raised
250     uint256 private _weiRaised;
251 
252     /**
253      * Event for token purchase logging
254      * @param purchaser who paid for the tokens
255      * @param beneficiary who got the tokens
256      * @param value weis paid for purchase
257      * @param amount amount of tokens purchased
258      */
259     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
260 
261     /**
262      * @param rate Number of token units a buyer gets per wei
263      * @dev The rate is the conversion between wei and the smallest and indivisible
264      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
265      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
266      * @param wallet Address where collected funds will be forwarded to
267      * @param token Address of the token being sold
268      */
269     constructor (uint256 rate, address payable wallet, IERC20 token) public {
270         require(rate > 0, "Crowdsale: rate is 0");
271         require(wallet != address(0), "Crowdsale: wallet is the zero address");
272         require(address(token) != address(0), "Crowdsale: token is the zero address");
273 
274         _rate = rate;
275         _wallet = wallet;
276         _token = token;
277     }
278 
279     /**
280      * @dev fallback function ***DO NOT OVERRIDE***
281      * Note that other contracts will transfer funds with a base gas stipend
282      * of 2300, which is not enough to call buyTokens. Consider calling
283      * buyTokens directly when purchasing tokens from a contract.
284      */
285     function () external payable {
286         buyTokens(msg.sender);
287     }
288 
289     /**
290      * @return the token being sold.
291      */
292     function token() public view returns (IERC20) {
293         return _token;
294     }
295 
296     /**
297      * @return the address where funds are collected.
298      */
299     function wallet() public view returns (address payable) {
300         return _wallet;
301     }
302     function _setRate(uint256 rate) internal{
303         _rate = rate;
304     }
305     /**
306      * @return the number of token units a buyer gets per wei.
307      */
308     function rate() public view returns (uint256) {
309         return _rate;
310     }
311 
312     /**
313      * @return the amount of wei raised.
314      */
315     function weiRaised() public view returns (uint256) {
316         return _weiRaised;
317     }
318 
319     /**
320      * @dev low level token purchase ***DO NOT OVERRIDE***
321      * This function has a non-reentrancy guard, so it shouldn't be called by
322      * another `nonReentrant` function.
323      * @param beneficiary Recipient of the token purchase
324      */
325     function buyTokens(address beneficiary) public nonReentrant payable {
326         uint256 weiAmount = msg.value;
327         _preValidatePurchase(beneficiary, weiAmount);
328 
329         // calculate token amount to be created
330         uint256 tokens = _getTokenAmount(weiAmount);
331 
332         // update state
333         _weiRaised = _weiRaised.add(weiAmount);
334 
335         _processPurchase(beneficiary, tokens);
336         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
337 
338         _forwardFunds();
339 
340     }
341 
342     /**
343      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
344      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
345      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
346      *     super._preValidatePurchase(beneficiary, weiAmount);
347      *     require(weiRaised().add(weiAmount) <= cap);
348      * @param beneficiary Address performing the token purchase
349      * @param weiAmount Value in wei involved in the purchase
350      */
351     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
352         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
353         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
354     }
355 
356     /**
357      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
358      * its tokens.
359      * @param beneficiary Address performing the token purchase
360      * @param tokenAmount Number of tokens to be emitted
361      */
362     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
363         _token.safeTransfer(beneficiary, tokenAmount);
364     }
365 
366     /**
367      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
368      * tokens.
369      * @param beneficiary Address receiving the tokens
370      * @param tokenAmount Number of tokens to be purchased
371      */
372     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
373         _deliverTokens(beneficiary, tokenAmount);
374     }
375 
376     /**
377      * @dev Override to extend the way in which ether is converted to tokens.
378      * @param weiAmount Value in wei to be converted into tokens
379      * @return Number of tokens that can be purchased with the specified _weiAmount
380      */
381     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
382         return weiAmount.mul(_rate);
383     }
384 
385     /**
386      * @dev Determines how ETH is stored/forwarded on purchases.
387      */
388     function _forwardFunds() internal {
389         _wallet.transfer(msg.value);
390     }
391 }
392 
393 
394 /**
395  * @title CappedCrowdsale
396  * @dev Crowdsale with a limit for total contributions.
397  */
398 contract CappedCrowdsale is Crowdsale {
399     using SafeMath for uint256;
400 
401     uint256 private _cap;
402 
403     /**
404      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
405      * @param cap Max amount of wei to be contributed
406      */
407     constructor (uint256 cap) public {
408         require(cap > 0, "CappedCrowdsale: cap is 0");
409         _cap = cap;
410     }
411 
412     /**
413      * @return the cap of the crowdsale.
414      */
415     function cap() public view returns (uint256) {
416         return _cap;
417     }
418 
419     /**
420      * @dev Checks whether the cap has been reached.
421      * @return Whether the cap was reached
422      */
423     function capReached() public view returns (bool) {
424         return weiRaised() >= _cap;
425     }
426 
427     /**
428      * @dev Extend parent behavior requiring purchase to respect the funding cap.
429      * @param beneficiary Token purchaser
430      * @param weiAmount Amount of wei contributed
431      */
432     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
433         super._preValidatePurchase(beneficiary, weiAmount);
434         require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
435     }
436 }
437 
438 /**
439  * @title TimedCrowdsale
440  * @dev Crowdsale accepting contributions only within a time frame.
441  */
442 contract TimedCrowdsale is Crowdsale {
443     using SafeMath for uint256;
444 
445     uint256 private _openingTime;
446     uint256 private _closingTime;
447 
448     /**
449      * Event for crowdsale extending
450      * @param newClosingTime new closing time
451      * @param prevClosingTime old closing time
452      */
453     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
454 
455     /**
456      * @dev Reverts if not in crowdsale time range.
457      */
458     modifier onlyWhileOpen {
459         require(isOpen(), "TimedCrowdsale: not open");
460         _;
461     }
462 
463     /**
464      * @dev Constructor, takes crowdsale opening and closing times.
465      * @param openingTime Crowdsale opening time
466      * @param closingTime Crowdsale closing time
467      */
468     constructor (uint256 openingTime, uint256 closingTime) public {
469         // solhint-disable-next-line not-rely-on-time
470         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
471         // solhint-disable-next-line max-line-length
472         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
473 
474         _openingTime = openingTime;
475         _closingTime = closingTime;
476     }
477 
478     /**
479      * @return the crowdsale opening time.
480      */
481     function openingTime() public view returns (uint256) {
482         return _openingTime;
483     }
484 
485     /**
486      * @return the crowdsale closing time.
487      */
488     function closingTime() public view returns (uint256) {
489         return _closingTime;
490     }
491 
492     /**
493      * @return true if the crowdsale is open, false otherwise.
494      */
495     function isOpen() public view returns (bool) {
496         // solhint-disable-next-line not-rely-on-time
497         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
498     }
499 
500     /**
501      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
502      * @return Whether crowdsale period has elapsed
503      */
504     function hasClosed() public view returns (bool) {
505         // solhint-disable-next-line not-rely-on-time
506         return block.timestamp > _closingTime;
507     }
508 
509     /**
510      * @dev Extend parent behavior requiring to be within contributing period.
511      * @param beneficiary Token purchaser
512      * @param weiAmount Amount of wei contributed
513      */
514     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
515         super._preValidatePurchase(beneficiary, weiAmount);
516     }
517 
518     /**
519      * @dev Extend crowdsale.
520      * @param newClosingTime Crowdsale closing time
521      */
522     function _extendTime(uint256 newClosingTime) internal {
523         require(!hasClosed(), "TimedCrowdsale: already closed");
524         // solhint-disable-next-line max-line-length
525         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
526 
527         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
528         _closingTime = newClosingTime;
529     }
530 }
531 
532 /**
533  * @title FinalizableCrowdsale
534  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
535  * can do extra work after finishing.
536  */
537 contract FinalizableCrowdsale is TimedCrowdsale {
538     using SafeMath for uint256;
539 
540     bool private _finalized;
541 
542     event CrowdsaleFinalized();
543 
544     constructor () internal {
545         _finalized = false;
546     }
547 
548     /**
549      * @return true if the crowdsale is finalized, false otherwise.
550      */
551     function finalized() public view returns (bool) {
552         return _finalized;
553     }
554 
555     /**
556      * @dev Must be called after crowdsale ends, to do some extra finalization
557      * work. Calls the contract's finalization function.
558      */
559     function finalize() public {
560         require(!_finalized, "FinalizableCrowdsale: already finalized");
561         require(hasClosed(), "FinalizableCrowdsale: not closed");
562 
563         _finalized = true;
564 
565         _finalization();
566         emit CrowdsaleFinalized();
567     }
568 
569     /**
570      * @dev Can be overridden to add finalization logic. The overriding function
571      * should call super._finalization() to ensure the chain of finalization is
572      * executed entirely.
573      */
574     function _finalization() internal {
575         // solhint-disable-previous-line no-empty-blocks
576     }
577 }
578 /**
579  * @title Secondary
580  * @dev A Secondary contract can only be used by its primary account (the one that created it).
581  */
582 contract Secondary {
583     address private _primary;
584 
585     event PrimaryTransferred(
586         address recipient
587     );
588 
589     /**
590      * @dev Sets the primary account to the one that is creating the Secondary contract.
591      */
592     constructor () internal {
593         _primary = msg.sender;
594         emit PrimaryTransferred(_primary);
595     }
596 
597     /**
598      * @dev Reverts if called from any account other than the primary.
599      */
600     modifier onlyPrimary() {
601         require(msg.sender == _primary, "Secondary: caller is not the primary account");
602         _;
603     }
604 
605     /**
606      * @return the address of the primary.
607      */
608     function primary() public view returns (address) {
609         return _primary;
610     }
611 
612     /**
613      * @dev Transfers contract to a new primary.
614      * @param recipient The address of new primary.
615      */
616     function transferPrimary(address recipient) public onlyPrimary {
617         require(recipient != address(0), "Secondary: new primary is the zero address");
618         _primary = recipient;
619         emit PrimaryTransferred(_primary);
620     }
621 }
622 
623  /**
624   * @title Escrow
625   * @dev Base escrow contract, holds funds designated for a payee until they
626   * withdraw them.
627   * @dev Intended usage: This contract (and derived escrow contracts) should be a
628   * standalone contract, that only interacts with the contract that instantiated
629   * it. That way, it is guaranteed that all Ether will be handled according to
630   * the Escrow rules, and there is no need to check for payable functions or
631   * transfers in the inheritance tree. The contract that uses the escrow as its
632   * payment method should be its primary, and provide public methods redirecting
633   * to the escrow's deposit and withdraw.
634   */
635 contract Escrow is Secondary {
636     using SafeMath for uint256;
637 
638     event Deposited(address indexed payee, uint256 weiAmount);
639     event Withdrawn(address indexed payee, uint256 weiAmount);
640 
641     mapping(address => uint256) private _deposits;
642 
643     function depositsOf(address payee) public view returns (uint256) {
644         return _deposits[payee];
645     }
646 
647     /**
648      * @dev Stores the sent amount as credit to be withdrawn.
649      * @param payee The destination address of the funds.
650      */
651     function deposit(address payee) public onlyPrimary payable {
652         uint256 amount = msg.value;
653         _deposits[payee] = _deposits[payee].add(amount);
654 
655         emit Deposited(payee, amount);
656     }
657 
658     /**
659      * @dev Withdraw accumulated balance for a payee.
660      * @param payee The address whose funds will be withdrawn and transferred to.
661      */
662     function withdraw(address payable payee) public onlyPrimary {
663         uint256 payment = _deposits[payee];
664 
665         _deposits[payee] = 0;
666 
667         payee.transfer(payment);
668 
669         emit Withdrawn(payee, payment);
670     }
671 }
672 
673 /**
674  * @title ConditionalEscrow
675  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
676  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
677  */
678 contract ConditionalEscrow is Escrow {
679     /**
680      * @dev Returns whether an address is allowed to withdraw their funds. To be
681      * implemented by derived contracts.
682      * @param payee The destination address of the funds.
683      */
684     function withdrawalAllowed(address payee) public view returns (bool);
685 
686     function withdraw(address payable payee) public {
687         require(withdrawalAllowed(payee), "ConditionalEscrow: payee is not allowed to withdraw");
688         super.withdraw(payee);
689     }
690 }
691 
692 /**
693  * @title RefundEscrow
694  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
695  * parties.
696  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
697  * @dev The primary account (that is, the contract that instantiates this
698  * contract) may deposit, close the deposit period, and allow for either
699  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
700  * with RefundEscrow will be made through the primary contract. See the
701  * RefundableCrowdsale contract for an example of RefundEscrow’s use.
702  */
703 contract RefundEscrow is ConditionalEscrow {
704     enum State { Active, Refunding, Closed }
705 
706     event RefundsClosed();
707     event RefundsEnabled();
708 
709     State private _state;
710     address payable private _beneficiary;
711 
712     /**
713      * @dev Constructor.
714      * @param beneficiary The beneficiary of the deposits.
715      */
716     constructor (address payable beneficiary) public {
717         require(beneficiary != address(0), "RefundEscrow: beneficiary is the zero address");
718         _beneficiary = beneficiary;
719         _state = State.Active;
720     }
721 
722     /**
723      * @return The current state of the escrow.
724      */
725     function state() public view returns (State) {
726         return _state;
727     }
728 
729     /**
730      * @return The beneficiary of the escrow.
731      */
732     function beneficiary() public view returns (address) {
733         return _beneficiary;
734     }
735 
736     /**
737      * @dev Stores funds that may later be refunded.
738      * @param refundee The address funds will be sent to if a refund occurs.
739      */
740     function deposit(address refundee) public payable {
741         require(_state == State.Active, "RefundEscrow: can only deposit while active");
742         super.deposit(refundee);
743     }
744 
745     /**
746      * @dev Allows for the beneficiary to withdraw their funds, rejecting
747      * further deposits.
748      */
749     function close() public onlyPrimary {
750         require(_state == State.Active, "RefundEscrow: can only close while active");
751         _state = State.Closed;
752         emit RefundsClosed();
753     }
754 
755     /**
756      * @dev Allows for refunds to take place, rejecting further deposits.
757      */
758     function enableRefunds() public onlyPrimary {
759         require(_state == State.Active, "RefundEscrow: can only enable refunds while active");
760         _state = State.Refunding;
761         emit RefundsEnabled();
762     }
763 
764     /**
765      * @dev Withdraws the beneficiary's funds.
766      */
767     function beneficiaryWithdraw() public {
768         require(_state == State.Closed, "RefundEscrow: beneficiary can only withdraw while closed");
769         _beneficiary.transfer(address(this).balance);
770     }
771 
772     /**
773      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
774      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
775      */
776     function withdrawalAllowed(address) public view returns (bool) {
777         return _state == State.Refunding;
778     }
779 }
780 
781 /**
782  * @title RefundableCrowdsale
783  * @dev Extension of FinalizableCrowdsale contract that adds a funding goal, and the possibility of users
784  * getting a refund if goal is not met.
785  *
786  * Deprecated, use RefundablePostDeliveryCrowdsale instead. Note that if you allow tokens to be traded before the goal
787  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
788  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
789  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
790  */
791 contract RefundableCrowdsale is FinalizableCrowdsale {
792     using SafeMath for uint256;
793 
794     // minimum amount of funds to be raised in weis
795     uint256 private _goal;
796 
797     // refund escrow used to hold funds while crowdsale is running
798     RefundEscrow private _escrow;
799 
800     /**
801      * @dev Constructor, creates RefundEscrow.
802      * @param goal Funding goal
803      */
804     constructor (uint256 goal) public {
805         require(goal > 0, "RefundableCrowdsale: goal is 0");
806         _escrow = new RefundEscrow(wallet());
807         _goal = goal;
808     }
809 
810     /**
811      * @return minimum amount of funds to be raised in wei.
812      */
813     function goal() public view returns (uint256) {
814         return _goal;
815     }
816 
817     /**
818      * @dev Investors can claim refunds here if crowdsale is unsuccessful.
819      * @param refundee Whose refund will be claimed.
820      */
821     function claimRefund(address payable refundee) public {
822         require(finalized(), "RefundableCrowdsale: not finalized");
823         require(!goalReached(), "RefundableCrowdsale: goal reached");
824 
825         _escrow.withdraw(refundee);
826     }
827 
828     /**
829      * @dev Checks whether funding goal was reached.
830      * @return Whether funding goal was reached
831      */
832     function goalReached() public view returns (bool) {
833         return weiRaised() >= _goal;
834     }
835 
836     /**
837      * @dev Escrow finalization task, called when finalize() is called.
838      */
839     function _finalization() internal {
840         if (goalReached()) {
841             _escrow.close();
842             _escrow.beneficiaryWithdraw();
843         } else {
844             _escrow.enableRefunds();
845         }
846 
847         super._finalization();
848     }
849 
850     /**
851      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
852      */
853     function _forwardFunds() internal {
854         _escrow.deposit.value(msg.value)(msg.sender);
855     }
856 }
857 /**
858  * @title MintedCrowdsale
859  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
860  * Token ownership should be transferred to MintedCrowdsale for minting.
861  */
862 contract MintedCrowdsale is Crowdsale {
863     /**
864      * @dev Overrides delivery by minting tokens upon purchase.
865      * @param beneficiary Token purchaser
866      * @param tokenAmount Number of tokens to be minted
867      */
868     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
869         // Potentially dangerous assumption about the type of the token.
870         require(
871             ERC20Mintable(address(token())).mint(beneficiary, tokenAmount),
872                 "MintedCrowdsale: minting failed"
873         );
874     }
875 }
876 
877 /**
878  * @title ERC20 interface
879  * @dev see https://eips.ethereum.org/EIPS/eip-20
880  */
881 interface IERC20 {
882     function transfer(address to, uint256 value) external returns (bool);
883 
884     function approve(address spender, uint256 value) external returns (bool);
885 
886     function transferFrom(address from, address to, uint256 value) external returns (bool);
887 
888     function totalSupply() external view returns (uint256);
889 
890     function balanceOf(address who) external view returns (uint256);
891 
892     function allowance(address owner, address spender) external view returns (uint256);
893 
894     event Transfer(address indexed from, address indexed to, uint256 value);
895 
896     event Approval(address indexed owner, address indexed spender, uint256 value);
897 }
898 
899 
900 /**
901  * @title Standard ERC20 token
902  *
903  * @dev Implementation of the basic standard token.
904  * https://eips.ethereum.org/EIPS/eip-20
905  * Originally based on code by FirstBlood:
906  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
907  *
908  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
909  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
910  * compliant implementations may not do it.
911  */
912 contract ERC20 is IERC20 {
913     using SafeMath for uint256;
914 
915     mapping (address => uint256) private _balances;
916 
917     mapping (address => mapping (address => uint256)) private _allowances;
918 
919     uint256 private _totalSupply;
920 
921     /**
922      * @dev Total number of tokens in existence.
923      */
924     function totalSupply() public view returns (uint256) {
925         return _totalSupply;
926     }
927 
928     /**
929      * @dev Gets the balance of the specified address.
930      * @param owner The address to query the balance of.
931      * @return A uint256 representing the amount owned by the passed address.
932      */
933     function balanceOf(address owner) public view returns (uint256) {
934         return _balances[owner];
935     }
936 
937     /**
938      * @dev Function to check the amount of tokens that an owner allowed to a spender.
939      * @param owner address The address which owns the funds.
940      * @param spender address The address which will spend the funds.
941      * @return A uint256 specifying the amount of tokens still available for the spender.
942      */
943     function allowance(address owner, address spender) public view returns (uint256) {
944         return _allowances[owner][spender];
945     }
946 
947     /**
948      * @dev Transfer token to a specified address.
949      * @param to The address to transfer to.
950      * @param value The amount to be transferred.
951      */
952     function transfer(address to, uint256 value) public returns (bool) {
953         _transfer(msg.sender, to, value);
954         return true;
955     }
956 
957     /**
958      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
959      * Beware that changing an allowance with this method brings the risk that someone may use both the old
960      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
961      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
962      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
963      * @param spender The address which will spend the funds.
964      * @param value The amount of tokens to be spent.
965      */
966     function approve(address spender, uint256 value) public returns (bool) {
967         _approve(msg.sender, spender, value);
968         return true;
969     }
970 
971     /**
972      * @dev Transfer tokens from one address to another.
973      * Note that while this function emits an Approval event, this is not required as per the specification,
974      * and other compliant implementations may not emit the event.
975      * @param from address The address which you want to send tokens from
976      * @param to address The address which you want to transfer to
977      * @param value uint256 the amount of tokens to be transferred
978      */
979     function transferFrom(address from, address to, uint256 value) public returns (bool) {
980         _transfer(from, to, value);
981         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
982         return true;
983     }
984 
985     /**
986      * @dev Increase the amount of tokens that an owner allowed to a spender.
987      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
988      * allowed value is better to use this function to avoid 2 calls (and wait until
989      * the first transaction is mined)
990      * From MonolithDAO Token.sol
991      * Emits an Approval event.
992      * @param spender The address which will spend the funds.
993      * @param addedValue The amount of tokens to increase the allowance by.
994      */
995     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
996         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
997         return true;
998     }
999 
1000     /**
1001      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1002      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
1003      * allowed value is better to use this function to avoid 2 calls (and wait until
1004      * the first transaction is mined)
1005      * From MonolithDAO Token.sol
1006      * Emits an Approval event.
1007      * @param spender The address which will spend the funds.
1008      * @param subtractedValue The amount of tokens to decrease the allowance by.
1009      */
1010     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1011         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
1012         return true;
1013     }
1014 
1015     /**
1016      * @dev Transfer token for a specified addresses.
1017      * @param from The address to transfer from.
1018      * @param to The address to transfer to.
1019      * @param value The amount to be transferred.
1020      */
1021     function _transfer(address from, address to, uint256 value) internal {
1022         require(to != address(0), "ERC20: transfer to the zero address");
1023 
1024         _balances[from] = _balances[from].sub(value);
1025         _balances[to] = _balances[to].add(value);
1026         emit Transfer(from, to, value);
1027     }
1028 
1029     /**
1030      * @dev Internal function that mints an amount of the token and assigns it to
1031      * an account. This encapsulates the modification of balances such that the
1032      * proper events are emitted.
1033      * @param account The account that will receive the created tokens.
1034      * @param value The amount that will be created.
1035      */
1036     function _mint(address account, uint256 value) internal {
1037         require(account != address(0), "ERC20: mint to the zero address");
1038 
1039         _totalSupply = _totalSupply.add(value);
1040         _balances[account] = _balances[account].add(value);
1041         emit Transfer(address(0), account, value);
1042     }
1043 
1044     /**
1045      * @dev Internal function that burns an amount of the token of a given
1046      * account.
1047      * @param account The account whose tokens will be burnt.
1048      * @param value The amount that will be burnt.
1049      */
1050     function _burn(address account, uint256 value) internal {
1051         require(account != address(0), "ERC20: burn from the zero address");
1052 
1053         _totalSupply = _totalSupply.sub(value);
1054         _balances[account] = _balances[account].sub(value);
1055         emit Transfer(account, address(0), value);
1056     }
1057 
1058     /**
1059      * @dev Approve an address to spend another addresses' tokens.
1060      * @param owner The address that owns the tokens.
1061      * @param spender The address that will spend the tokens.
1062      * @param value The number of tokens that can be spent.
1063      */
1064     function _approve(address owner, address spender, uint256 value) internal {
1065         require(owner != address(0), "ERC20: approve from the zero address");
1066         require(spender != address(0), "ERC20: approve to the zero address");
1067 
1068         _allowances[owner][spender] = value;
1069         emit Approval(owner, spender, value);
1070     }
1071 
1072     /**
1073      * @dev Internal function that burns an amount of the token of a given
1074      * account, deducting from the sender's allowance for said account. Uses the
1075      * internal burn function.
1076      * Emits an Approval event (reflecting the reduced allowance).
1077      * @param account The account whose tokens will be burnt.
1078      * @param value The amount that will be burnt.
1079      */
1080     function _burnFrom(address account, uint256 value) internal {
1081         _burn(account, value);
1082         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
1083     }
1084 }
1085 /**
1086  * @title Roles
1087  * @dev Library for managing addresses assigned to a Role.
1088  */
1089 library Roles {
1090     struct Role {
1091         mapping (address => bool) bearer;
1092     }
1093 
1094     /**
1095      * @dev Give an account access to this role.
1096      */
1097     function add(Role storage role, address account) internal {
1098         require(!has(role, account), "Roles: account already has role");
1099         role.bearer[account] = true;
1100     }
1101 
1102     /**
1103      * @dev Remove an account's access to this role.
1104      */
1105     function remove(Role storage role, address account) internal {
1106         require(has(role, account), "Roles: account does not have role");
1107         role.bearer[account] = false;
1108     }
1109 
1110     /**
1111      * @dev Check if an account has this role.
1112      * @return bool
1113      */
1114     function has(Role storage role, address account) internal view returns (bool) {
1115         require(account != address(0), "Roles: account is the zero address");
1116         return role.bearer[account];
1117     }
1118 }
1119 
1120 contract MinterRole {
1121     using Roles for Roles.Role;
1122 
1123     event MinterAdded(address indexed account);
1124     event MinterRemoved(address indexed account);
1125 
1126     Roles.Role private _minters;
1127 
1128     constructor () internal {
1129         _addMinter(msg.sender);
1130     }
1131 
1132     modifier onlyMinter() {
1133         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
1134         _;
1135     }
1136 
1137     function isMinter(address account) public view returns (bool) {
1138         return _minters.has(account);
1139     }
1140 
1141     function addMinter(address account) public onlyMinter {
1142         _addMinter(account);
1143     }
1144 
1145     function renounceMinter() public {
1146         _removeMinter(msg.sender);
1147     }
1148 
1149     function _addMinter(address account) internal {
1150         _minters.add(account);
1151         emit MinterAdded(account);
1152     }
1153 
1154     function _removeMinter(address account) internal {
1155         _minters.remove(account);
1156         emit MinterRemoved(account);
1157     }
1158 }
1159 
1160 /**
1161  * @title ERC20Mintable
1162  * @dev ERC20 minting logic.
1163  */
1164 contract ERC20Mintable is ERC20, MinterRole {
1165     /**
1166      * @dev Function to mint tokens
1167      * @param to The address that will receive the minted tokens.
1168      * @param value The amount of tokens to mint.
1169      * @return A boolean that indicates if the operation was successful.
1170      */
1171     function mint(address to, uint256 value) public onlyMinter returns (bool) {
1172         _mint(to, value);
1173         return true;
1174     }
1175 }
1176 
1177 /**
1178  * @title ERC20Detailed token
1179  * @dev The decimals are only for visualization purposes.
1180  * All the operations are done using the smallest and indivisible token unit,
1181  * just as on Ethereum all the operations are done in wei.
1182  */
1183 contract ERC20Detailed is IERC20 {
1184     string private _name;
1185     string private _symbol;
1186     uint8 private _decimals;
1187 
1188     constructor (string memory name, string memory symbol, uint8 decimals) public {
1189         _name = name;
1190         _symbol = symbol;
1191         _decimals = decimals;
1192     }
1193 
1194     /**
1195      * @return the name of the token.
1196      */
1197     function name() public view returns (string memory) {
1198         return _name;
1199     }
1200 
1201     /**
1202      * @return the symbol of the token.
1203      */
1204     function symbol() public view returns (string memory) {
1205         return _symbol;
1206     }
1207 
1208     /**
1209      * @return the number of decimals of the token.
1210      */
1211     function decimals() public view returns (uint8) {
1212         return _decimals;
1213     }
1214 }
1215 
1216 /**
1217  * @title AI247Token
1218  */
1219 contract AI247Token is ERC20Mintable, ERC20Detailed {
1220     constructor () public ERC20Detailed("AI247 Token", "AI247", 18) {
1221         // solhint-disable-previous-line no-empty-blocks
1222     }
1223 }
1224 
1225 /**
1226  * @title Ownable
1227  * @dev The Ownable contract has an owner address, and provides basic authorization control
1228  * functions, this simplifies the implementation of "user permissions".
1229  */
1230 contract Ownable {
1231     address private _owner;
1232 
1233     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1234 
1235     /**
1236      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1237      * account.
1238      */
1239     constructor () internal {
1240         _owner = msg.sender;
1241         emit OwnershipTransferred(address(0), _owner);
1242     }
1243 
1244     /**
1245      * @return the address of the owner.
1246      */
1247     function owner() public view returns (address) {
1248         return _owner;
1249     }
1250 
1251     /**
1252      * @dev Throws if called by any account other than the owner.
1253      */
1254     modifier onlyOwner() {
1255         require(isOwner(), "Ownable: caller is not the owner");
1256         _;
1257     }
1258 
1259     /**
1260      * @return true if `msg.sender` is the owner of the contract.
1261      */
1262     function isOwner() public view returns (bool) {
1263         return msg.sender == _owner;
1264     }
1265 
1266     /**
1267      * @dev Allows the current owner to relinquish control of the contract.
1268      * It will not be possible to call the functions with the `onlyOwner`
1269      * modifier anymore.
1270      * @notice Renouncing ownership will leave the contract without an owner,
1271      * thereby removing any functionality that is only available to the owner.
1272      */
1273     function renounceOwnership() public onlyOwner {
1274         emit OwnershipTransferred(_owner, address(0));
1275         _owner = address(0);
1276     }
1277 
1278     /**
1279      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1280      * @param newOwner The address to transfer ownership to.
1281      */
1282     function transferOwnership(address newOwner) public onlyOwner {
1283         _transferOwnership(newOwner);
1284     }
1285 
1286     /**
1287      * @dev Transfers control of the contract to a newOwner.
1288      * @param newOwner The address to transfer ownership to.
1289      */
1290     function _transferOwnership(address newOwner) internal {
1291         require(newOwner != address(0), "Ownable: new owner is the zero address");
1292         emit OwnershipTransferred(_owner, newOwner);
1293         _owner = newOwner;
1294     }
1295 }
1296 
1297 contract AI247Crowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale, Ownable {
1298     constructor (
1299         uint256 openingTime,
1300         uint256 closingTime,
1301         uint256 rate,
1302         address payable wallet,
1303         uint256 cap,
1304         ERC20Mintable token,
1305         uint256 goal
1306     )
1307         public
1308         Crowdsale(rate, wallet, token)
1309         CappedCrowdsale(cap)
1310         TimedCrowdsale(openingTime, closingTime)
1311         RefundableCrowdsale(goal)
1312     {
1313         //As goal needs to be met for a successful crowdsale
1314         //the value needs to less or equal than a cap which is limit for accepted funds
1315         require(goal <= cap, "AI247CrowdSale: goal is greater than cap");
1316     }
1317     function setRate(uint256 rate) public onlyOwner{
1318         _setRate(rate);
1319     }
1320 }