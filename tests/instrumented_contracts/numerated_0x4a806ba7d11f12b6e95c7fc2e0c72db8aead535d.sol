1 // File: installed_contracts/openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: installed_contracts/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 pragma solidity ^0.5.2;
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://eips.ethereum.org/EIPS/eip-20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: installed_contracts/openzeppelin-solidity/contracts/utils/Address.sol
96 
97 pragma solidity ^0.5.2;
98 
99 /**
100  * Utility library of inline functions on addresses
101  */
102 library Address {
103     /**
104      * Returns whether the target address is a contract
105      * @dev This function will return false if invoked during the constructor of a contract,
106      * as the code is not actually created until after the constructor finishes.
107      * @param account address of the account to check
108      * @return whether the target address is a contract
109      */
110     function isContract(address account) internal view returns (bool) {
111         uint256 size;
112         // XXX Currently there is no better way to check if there is a contract in an address
113         // than to check the size of the code at that address.
114         // See https://ethereum.stackexchange.com/a/14016/36603
115         // for more details about how this works.
116         // TODO Check this again before the Serenity release, because all addresses will be
117         // contracts then.
118         // solhint-disable-next-line no-inline-assembly
119         assembly { size := extcodesize(account) }
120         return size > 0;
121     }
122 }
123 
124 // File: installed_contracts/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
125 
126 pragma solidity ^0.5.2;
127 
128 
129 
130 
131 /**
132  * @title SafeERC20
133  * @dev Wrappers around ERC20 operations that throw on failure (when the token
134  * contract returns false). Tokens that return no value (and instead revert or
135  * throw on failure) are also supported, non-reverting calls are assumed to be
136  * successful.
137  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
138  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
139  */
140 library SafeERC20 {
141     using SafeMath for uint256;
142     using Address for address;
143 
144     function safeTransfer(IERC20 token, address to, uint256 value) internal {
145         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
146     }
147 
148     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
149         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
150     }
151 
152     function safeApprove(IERC20 token, address spender, uint256 value) internal {
153         // safeApprove should only be called when setting an initial allowance,
154         // or when resetting it to zero. To increase and decrease it, use
155         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
156         require((value == 0) || (token.allowance(address(this), spender) == 0));
157         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
158     }
159 
160     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
161         uint256 newAllowance = token.allowance(address(this), spender).add(value);
162         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
163     }
164 
165     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
166         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
167         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
168     }
169 
170     /**
171      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
172      * on the return value: the return value is optional (but if data is returned, it must equal true).
173      * @param token The token targeted by the call.
174      * @param data The call data (encoded using abi.encode or one of its variants).
175      */
176     function callOptionalReturn(IERC20 token, bytes memory data) private {
177         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
178         // we're implementing it ourselves.
179 
180         // A Solidity high level call has three parts:
181         //  1. The target address is checked to verify it contains contract code
182         //  2. The call itself is made, and success asserted
183         //  3. The return value is decoded, which in turn checks the size of the returned data.
184 
185         require(address(token).isContract());
186 
187         // solhint-disable-next-line avoid-low-level-calls
188         (bool success, bytes memory returndata) = address(token).call(data);
189         require(success);
190 
191         if (returndata.length > 0) { // Return data is optional
192             require(abi.decode(returndata, (bool)));
193         }
194     }
195 }
196 
197 // File: installed_contracts/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
198 
199 pragma solidity ^0.5.2;
200 
201 /**
202  * @title Helps contracts guard against reentrancy attacks.
203  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
204  * @dev If you mark a function `nonReentrant`, you should also
205  * mark it `external`.
206  */
207 contract ReentrancyGuard {
208     /// @dev counter to allow mutex lock with only one SSTORE operation
209     uint256 private _guardCounter;
210 
211     constructor () internal {
212         // The counter starts at one to prevent changing it from zero to a non-zero
213         // value, which is a more expensive operation.
214         _guardCounter = 1;
215     }
216 
217     /**
218      * @dev Prevents a contract from calling itself, directly or indirectly.
219      * Calling a `nonReentrant` function from another `nonReentrant`
220      * function is not supported. It is possible to prevent this from happening
221      * by making the `nonReentrant` function external, and make it call a
222      * `private` function that does the actual work.
223      */
224     modifier nonReentrant() {
225         _guardCounter += 1;
226         uint256 localCounter = _guardCounter;
227         _;
228         require(localCounter == _guardCounter);
229     }
230 }
231 
232 // File: installed_contracts/openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
233 
234 pragma solidity ^0.5.2;
235 
236 
237 
238 
239 
240 /**
241  * @title Crowdsale
242  * @dev Crowdsale is a base contract for managing a token crowdsale,
243  * allowing investors to purchase tokens with ether. This contract implements
244  * such functionality in its most fundamental form and can be extended to provide additional
245  * functionality and/or custom behavior.
246  * The external interface represents the basic interface for purchasing tokens, and conforms
247  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
248  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
249  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
250  * behavior.
251  */
252 contract Crowdsale is ReentrancyGuard {
253     using SafeMath for uint256;
254     using SafeERC20 for IERC20;
255 
256     // The token being sold
257     IERC20 private _token;
258 
259     // Address where funds are collected
260     address payable private _wallet;
261 
262     // How many token units a buyer gets per wei.
263     // The rate is the conversion between wei and the smallest and indivisible token unit.
264     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
265     // 1 wei will give you 1 unit, or 0.001 TOK.
266     uint256 private _rate;
267 
268     // Amount of wei raised
269     uint256 private _weiRaised;
270 
271     /**
272      * Event for token purchase logging
273      * @param purchaser who paid for the tokens
274      * @param beneficiary who got the tokens
275      * @param value weis paid for purchase
276      * @param amount amount of tokens purchased
277      */
278     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
279 
280     /**
281      * @param rate Number of token units a buyer gets per wei
282      * @dev The rate is the conversion between wei and the smallest and indivisible
283      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
284      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
285      * @param wallet Address where collected funds will be forwarded to
286      * @param token Address of the token being sold
287      */
288     constructor (uint256 rate, address payable wallet, IERC20 token) public {
289         require(rate > 0);
290         require(wallet != address(0));
291         require(address(token) != address(0));
292 
293         _rate = rate;
294         _wallet = wallet;
295         _token = token;
296     }
297 
298     /**
299      * @dev fallback function ***DO NOT OVERRIDE***
300      * Note that other contracts will transfer funds with a base gas stipend
301      * of 2300, which is not enough to call buyTokens. Consider calling
302      * buyTokens directly when purchasing tokens from a contract.
303      */
304     function () external payable {
305         buyTokens(msg.sender);
306     }
307 
308     /**
309      * @return the token being sold.
310      */
311     function token() public view returns (IERC20) {
312         return _token;
313     }
314 
315     /**
316      * @return the address where funds are collected.
317      */
318     function wallet() public view returns (address payable) {
319         return _wallet;
320     }
321 
322     /**
323      * @return the number of token units a buyer gets per wei.
324      */
325     function rate() public view returns (uint256) {
326         return _rate;
327     }
328 
329     /**
330      * @return the amount of wei raised.
331      */
332     function weiRaised() public view returns (uint256) {
333         return _weiRaised;
334     }
335 
336     /**
337      * @dev low level token purchase ***DO NOT OVERRIDE***
338      * This function has a non-reentrancy guard, so it shouldn't be called by
339      * another `nonReentrant` function.
340      * @param beneficiary Recipient of the token purchase
341      */
342     function buyTokens(address beneficiary) public nonReentrant payable {
343         uint256 weiAmount = msg.value;
344         _preValidatePurchase(beneficiary, weiAmount);
345 
346         // calculate token amount to be created
347         uint256 tokens = _getTokenAmount(weiAmount);
348 
349         // update state
350         _weiRaised = _weiRaised.add(weiAmount);
351 
352         _processPurchase(beneficiary, tokens);
353         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
354 
355         _updatePurchasingState(beneficiary, weiAmount);
356 
357         _forwardFunds();
358         _postValidatePurchase(beneficiary, weiAmount);
359     }
360 
361     /**
362      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
363      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
364      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
365      *     super._preValidatePurchase(beneficiary, weiAmount);
366      *     require(weiRaised().add(weiAmount) <= cap);
367      * @param beneficiary Address performing the token purchase
368      * @param weiAmount Value in wei involved in the purchase
369      */
370     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
371         require(beneficiary != address(0));
372         require(weiAmount != 0);
373     }
374 
375     /**
376      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
377      * conditions are not met.
378      * @param beneficiary Address performing the token purchase
379      * @param weiAmount Value in wei involved in the purchase
380      */
381     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
382         // solhint-disable-previous-line no-empty-blocks
383     }
384 
385     /**
386      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
387      * its tokens.
388      * @param beneficiary Address performing the token purchase
389      * @param tokenAmount Number of tokens to be emitted
390      */
391     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
392         _token.safeTransfer(beneficiary, tokenAmount);
393     }
394 
395     /**
396      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
397      * tokens.
398      * @param beneficiary Address receiving the tokens
399      * @param tokenAmount Number of tokens to be purchased
400      */
401     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
402         _deliverTokens(beneficiary, tokenAmount);
403     }
404 
405     /**
406      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
407      * etc.)
408      * @param beneficiary Address receiving the tokens
409      * @param weiAmount Value in wei involved in the purchase
410      */
411     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
412         // solhint-disable-previous-line no-empty-blocks
413     }
414 
415     /**
416      * @dev Override to extend the way in which ether is converted to tokens.
417      * @param weiAmount Value in wei to be converted into tokens
418      * @return Number of tokens that can be purchased with the specified _weiAmount
419      */
420     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
421         return weiAmount.mul(_rate);
422     }
423 
424     /**
425      * @dev Determines how ETH is stored/forwarded on purchases.
426      */
427     function _forwardFunds() internal {
428         _wallet.transfer(msg.value);
429     }
430 }
431 
432 // File: installed_contracts/openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
433 
434 pragma solidity ^0.5.2;
435 
436 
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
459         require(isOpen());
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
470         require(openingTime >= block.timestamp);
471         require(closingTime > openingTime);
472 
473         _openingTime = openingTime;
474         _closingTime = closingTime;
475     }
476 
477     /**
478      * @return the crowdsale opening time.
479      */
480     function openingTime() public view returns (uint256) {
481         return _openingTime;
482     }
483 
484     /**
485      * @return the crowdsale closing time.
486      */
487     function closingTime() public view returns (uint256) {
488         return _closingTime;
489     }
490 
491     /**
492      * @return true if the crowdsale is open, false otherwise.
493      */
494     function isOpen() public view returns (bool) {
495         // solhint-disable-next-line not-rely-on-time
496         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
497     }
498 
499     /**
500      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
501      * @return Whether crowdsale period has elapsed
502      */
503     function hasClosed() public view returns (bool) {
504         // solhint-disable-next-line not-rely-on-time
505         return block.timestamp > _closingTime;
506     }
507 
508     /**
509      * @dev Extend parent behavior requiring to be within contributing period
510      * @param beneficiary Token purchaser
511      * @param weiAmount Amount of wei contributed
512      */
513     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
514         super._preValidatePurchase(beneficiary, weiAmount);
515     }
516 
517     /**
518      * @dev Extend crowdsale
519      * @param newClosingTime Crowdsale closing time
520      */
521     function _extendTime(uint256 newClosingTime) internal {
522         require(!hasClosed());
523         require(newClosingTime > _closingTime);
524 
525         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
526         _closingTime = newClosingTime;
527     }
528 }
529 
530 // File: installed_contracts/openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
531 
532 pragma solidity ^0.5.2;
533 
534 
535 
536 /**
537  * @title FinalizableCrowdsale
538  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
539  * can do extra work after finishing.
540  */
541 contract FinalizableCrowdsale is TimedCrowdsale {
542     using SafeMath for uint256;
543 
544     bool private _finalized;
545 
546     event CrowdsaleFinalized();
547 
548     constructor () internal {
549         _finalized = false;
550     }
551 
552     /**
553      * @return true if the crowdsale is finalized, false otherwise.
554      */
555     function finalized() public view returns (bool) {
556         return _finalized;
557     }
558 
559     /**
560      * @dev Must be called after crowdsale ends, to do some extra finalization
561      * work. Calls the contract's finalization function.
562      */
563     function finalize() public {
564         require(!_finalized);
565         require(hasClosed());
566 
567         _finalized = true;
568 
569         _finalization();
570         emit CrowdsaleFinalized();
571     }
572 
573     /**
574      * @dev Can be overridden to add finalization logic. The overriding function
575      * should call super._finalization() to ensure the chain of finalization is
576      * executed entirely.
577      */
578     function _finalization() internal {
579         // solhint-disable-previous-line no-empty-blocks
580     }
581 }
582 
583 // File: installed_contracts/openzeppelin-solidity/contracts/ownership/Secondary.sol
584 
585 pragma solidity ^0.5.2;
586 
587 /**
588  * @title Secondary
589  * @dev A Secondary contract can only be used by its primary account (the one that created it)
590  */
591 contract Secondary {
592     address private _primary;
593 
594     event PrimaryTransferred(
595         address recipient
596     );
597 
598     /**
599      * @dev Sets the primary account to the one that is creating the Secondary contract.
600      */
601     constructor () internal {
602         _primary = msg.sender;
603         emit PrimaryTransferred(_primary);
604     }
605 
606     /**
607      * @dev Reverts if called from any account other than the primary.
608      */
609     modifier onlyPrimary() {
610         require(msg.sender == _primary);
611         _;
612     }
613 
614     /**
615      * @return the address of the primary.
616      */
617     function primary() public view returns (address) {
618         return _primary;
619     }
620 
621     /**
622      * @dev Transfers contract to a new primary.
623      * @param recipient The address of new primary.
624      */
625     function transferPrimary(address recipient) public onlyPrimary {
626         require(recipient != address(0));
627         _primary = recipient;
628         emit PrimaryTransferred(_primary);
629     }
630 }
631 
632 // File: installed_contracts/openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
633 
634 pragma solidity ^0.5.2;
635 
636 
637 
638  /**
639   * @title Escrow
640   * @dev Base escrow contract, holds funds designated for a payee until they
641   * withdraw them.
642   * @dev Intended usage: This contract (and derived escrow contracts) should be a
643   * standalone contract, that only interacts with the contract that instantiated
644   * it. That way, it is guaranteed that all Ether will be handled according to
645   * the Escrow rules, and there is no need to check for payable functions or
646   * transfers in the inheritance tree. The contract that uses the escrow as its
647   * payment method should be its primary, and provide public methods redirecting
648   * to the escrow's deposit and withdraw.
649   */
650 contract Escrow is Secondary {
651     using SafeMath for uint256;
652 
653     event Deposited(address indexed payee, uint256 weiAmount);
654     event Withdrawn(address indexed payee, uint256 weiAmount);
655 
656     mapping(address => uint256) private _deposits;
657 
658     function depositsOf(address payee) public view returns (uint256) {
659         return _deposits[payee];
660     }
661 
662     /**
663      * @dev Stores the sent amount as credit to be withdrawn.
664      * @param payee The destination address of the funds.
665      */
666     function deposit(address payee) public onlyPrimary payable {
667         uint256 amount = msg.value;
668         _deposits[payee] = _deposits[payee].add(amount);
669 
670         emit Deposited(payee, amount);
671     }
672 
673     /**
674      * @dev Withdraw accumulated balance for a payee.
675      * @param payee The address whose funds will be withdrawn and transferred to.
676      */
677     function withdraw(address payable payee) public onlyPrimary {
678         uint256 payment = _deposits[payee];
679 
680         _deposits[payee] = 0;
681 
682         payee.transfer(payment);
683 
684         emit Withdrawn(payee, payment);
685     }
686 }
687 
688 // File: installed_contracts/openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
689 
690 pragma solidity ^0.5.2;
691 
692 
693 /**
694  * @title ConditionalEscrow
695  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
696  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
697  */
698 contract ConditionalEscrow is Escrow {
699     /**
700      * @dev Returns whether an address is allowed to withdraw their funds. To be
701      * implemented by derived contracts.
702      * @param payee The destination address of the funds.
703      */
704     function withdrawalAllowed(address payee) public view returns (bool);
705 
706     function withdraw(address payable payee) public {
707         require(withdrawalAllowed(payee));
708         super.withdraw(payee);
709     }
710 }
711 
712 // File: installed_contracts/openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol
713 
714 pragma solidity ^0.5.2;
715 
716 
717 /**
718  * @title RefundEscrow
719  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
720  * parties.
721  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
722  * @dev The primary account (that is, the contract that instantiates this
723  * contract) may deposit, close the deposit period, and allow for either
724  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
725  * with RefundEscrow will be made through the primary contract. See the
726  * RefundableCrowdsale contract for an example of RefundEscrow’s use.
727  */
728 contract RefundEscrow is ConditionalEscrow {
729     enum State { Active, Refunding, Closed }
730 
731     event RefundsClosed();
732     event RefundsEnabled();
733 
734     State private _state;
735     address payable private _beneficiary;
736 
737     /**
738      * @dev Constructor.
739      * @param beneficiary The beneficiary of the deposits.
740      */
741     constructor (address payable beneficiary) public {
742         require(beneficiary != address(0));
743         _beneficiary = beneficiary;
744         _state = State.Active;
745     }
746 
747     /**
748      * @return the current state of the escrow.
749      */
750     function state() public view returns (State) {
751         return _state;
752     }
753 
754     /**
755      * @return the beneficiary of the escrow.
756      */
757     function beneficiary() public view returns (address) {
758         return _beneficiary;
759     }
760 
761     /**
762      * @dev Stores funds that may later be refunded.
763      * @param refundee The address funds will be sent to if a refund occurs.
764      */
765     function deposit(address refundee) public payable {
766         require(_state == State.Active);
767         super.deposit(refundee);
768     }
769 
770     /**
771      * @dev Allows for the beneficiary to withdraw their funds, rejecting
772      * further deposits.
773      */
774     function close() public onlyPrimary {
775         require(_state == State.Active);
776         _state = State.Closed;
777         emit RefundsClosed();
778     }
779 
780     /**
781      * @dev Allows for refunds to take place, rejecting further deposits.
782      */
783     function enableRefunds() public onlyPrimary {
784         require(_state == State.Active);
785         _state = State.Refunding;
786         emit RefundsEnabled();
787     }
788 
789     /**
790      * @dev Withdraws the beneficiary's funds.
791      */
792     function beneficiaryWithdraw() public {
793         require(_state == State.Closed);
794         _beneficiary.transfer(address(this).balance);
795     }
796 
797     /**
798      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
799      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
800      */
801     function withdrawalAllowed(address) public view returns (bool) {
802         return _state == State.Refunding;
803     }
804 }
805 
806 // File: installed_contracts/openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
807 
808 pragma solidity ^0.5.2;
809 
810 
811 
812 
813 /**
814  * @title RefundableCrowdsale
815  * @dev Extension of FinalizableCrowdsale contract that adds a funding goal, and the possibility of users
816  * getting a refund if goal is not met.
817  *
818  * Deprecated, use RefundablePostDeliveryCrowdsale instead. Note that if you allow tokens to be traded before the goal
819  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
820  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
821  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
822  */
823 contract RefundableCrowdsale is FinalizableCrowdsale {
824     using SafeMath for uint256;
825 
826     // minimum amount of funds to be raised in weis
827     uint256 private _goal;
828 
829     // refund escrow used to hold funds while crowdsale is running
830     RefundEscrow private _escrow;
831 
832     /**
833      * @dev Constructor, creates RefundEscrow.
834      * @param goal Funding goal
835      */
836     constructor (uint256 goal) public {
837         require(goal > 0);
838         _escrow = new RefundEscrow(wallet());
839         _goal = goal;
840     }
841 
842     /**
843      * @return minimum amount of funds to be raised in wei.
844      */
845     function goal() public view returns (uint256) {
846         return _goal;
847     }
848 
849     /**
850      * @dev Investors can claim refunds here if crowdsale is unsuccessful
851      * @param refundee Whose refund will be claimed.
852      */
853     function claimRefund(address payable refundee) public {
854         require(finalized());
855         require(!goalReached());
856 
857         _escrow.withdraw(refundee);
858     }
859 
860     /**
861      * @dev Checks whether funding goal was reached.
862      * @return Whether funding goal was reached
863      */
864     function goalReached() public view returns (bool) {
865         return weiRaised() >= _goal;
866     }
867 
868     /**
869      * @dev escrow finalization task, called when finalize() is called
870      */
871     function _finalization() internal {
872         if (goalReached()) {
873             _escrow.close();
874             _escrow.beneficiaryWithdraw();
875         } else {
876             _escrow.enableRefunds();
877         }
878 
879         super._finalization();
880     }
881 
882     /**
883      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
884      */
885     function _forwardFunds() internal {
886         _escrow.deposit.value(msg.value)(msg.sender);
887     }
888 }
889 
890 // File: installed_contracts/openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
891 
892 pragma solidity ^0.5.2;
893 
894 
895 
896 /**
897  * @title PostDeliveryCrowdsale
898  * @dev Crowdsale that locks tokens from withdrawal until it ends.
899  */
900 contract PostDeliveryCrowdsale is TimedCrowdsale {
901     using SafeMath for uint256;
902 
903     mapping(address => uint256) private _balances;
904 
905     /**
906      * @dev Withdraw tokens only after crowdsale ends.
907      * @param beneficiary Whose tokens will be withdrawn.
908      */
909     function withdrawTokens(address beneficiary) public {
910         require(hasClosed());
911         uint256 amount = _balances[beneficiary];
912         require(amount > 0);
913         _balances[beneficiary] = 0;
914         _deliverTokens(beneficiary, amount);
915     }
916 
917     /**
918      * @return the balance of an account.
919      */
920     function balanceOf(address account) public view returns (uint256) {
921         return _balances[account];
922     }
923 
924     /**
925      * @dev Overrides parent by storing balances instead of issuing tokens right away.
926      * @param beneficiary Token purchaser
927      * @param tokenAmount Amount of tokens purchased
928      */
929     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
930         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
931     }
932 
933 }
934 
935 // File: installed_contracts/openzeppelin-solidity/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol
936 
937 pragma solidity ^0.5.2;
938 
939 
940 
941 
942 /**
943  * @title RefundablePostDeliveryCrowdsale
944  * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
945  * once the crowdsale has closed and the goal met, preventing refunds to be issued
946  * to token holders.
947  */
948 contract RefundablePostDeliveryCrowdsale is RefundableCrowdsale, PostDeliveryCrowdsale {
949     function withdrawTokens(address beneficiary) public {
950         require(finalized());
951         require(goalReached());
952 
953         super.withdrawTokens(beneficiary);
954     }
955 }
956 
957 // File: installed_contracts/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
958 
959 pragma solidity ^0.5.2;
960 
961 
962 /**
963  * @title ERC20Detailed token
964  * @dev The decimals are only for visualization purposes.
965  * All the operations are done using the smallest and indivisible token unit,
966  * just as on Ethereum all the operations are done in wei.
967  */
968 contract ERC20Detailed is IERC20 {
969     string private _name;
970     string private _symbol;
971     uint8 private _decimals;
972 
973     constructor (string memory name, string memory symbol, uint8 decimals) public {
974         _name = name;
975         _symbol = symbol;
976         _decimals = decimals;
977     }
978 
979     /**
980      * @return the name of the token.
981      */
982     function name() public view returns (string memory) {
983         return _name;
984     }
985 
986     /**
987      * @return the symbol of the token.
988      */
989     function symbol() public view returns (string memory) {
990         return _symbol;
991     }
992 
993     /**
994      * @return the number of decimals of the token.
995      */
996     function decimals() public view returns (uint8) {
997         return _decimals;
998     }
999 }
1000 
1001 // File: installed_contracts/openzeppelin-solidity/contracts/ownership/Ownable.sol
1002 
1003 pragma solidity ^0.5.2;
1004 
1005 /**
1006  * @title Ownable
1007  * @dev The Ownable contract has an owner address, and provides basic authorization control
1008  * functions, this simplifies the implementation of "user permissions".
1009  */
1010 contract Ownable {
1011     address private _owner;
1012 
1013     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1014 
1015     /**
1016      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1017      * account.
1018      */
1019     constructor () internal {
1020         _owner = msg.sender;
1021         emit OwnershipTransferred(address(0), _owner);
1022     }
1023 
1024     /**
1025      * @return the address of the owner.
1026      */
1027     function owner() public view returns (address) {
1028         return _owner;
1029     }
1030 
1031     /**
1032      * @dev Throws if called by any account other than the owner.
1033      */
1034     modifier onlyOwner() {
1035         require(isOwner());
1036         _;
1037     }
1038 
1039     /**
1040      * @return true if `msg.sender` is the owner of the contract.
1041      */
1042     function isOwner() public view returns (bool) {
1043         return msg.sender == _owner;
1044     }
1045 
1046     /**
1047      * @dev Allows the current owner to relinquish control of the contract.
1048      * It will not be possible to call the functions with the `onlyOwner`
1049      * modifier anymore.
1050      * @notice Renouncing ownership will leave the contract without an owner,
1051      * thereby removing any functionality that is only available to the owner.
1052      */
1053     function renounceOwnership() public onlyOwner {
1054         emit OwnershipTransferred(_owner, address(0));
1055         _owner = address(0);
1056     }
1057 
1058     /**
1059      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1060      * @param newOwner The address to transfer ownership to.
1061      */
1062     function transferOwnership(address newOwner) public onlyOwner {
1063         _transferOwnership(newOwner);
1064     }
1065 
1066     /**
1067      * @dev Transfers control of the contract to a newOwner.
1068      * @param newOwner The address to transfer ownership to.
1069      */
1070     function _transferOwnership(address newOwner) internal {
1071         require(newOwner != address(0));
1072         emit OwnershipTransferred(_owner, newOwner);
1073         _owner = newOwner;
1074     }
1075 }
1076 
1077 // File: installed_contracts/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
1078 
1079 pragma solidity ^0.5.2;
1080 
1081 
1082 
1083 /**
1084  * @title Standard ERC20 token
1085  *
1086  * @dev Implementation of the basic standard token.
1087  * https://eips.ethereum.org/EIPS/eip-20
1088  * Originally based on code by FirstBlood:
1089  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1090  *
1091  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
1092  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
1093  * compliant implementations may not do it.
1094  */
1095 contract ERC20 is IERC20 {
1096     using SafeMath for uint256;
1097 
1098     mapping (address => uint256) private _balances;
1099 
1100     mapping (address => mapping (address => uint256)) private _allowed;
1101 
1102     uint256 private _totalSupply;
1103 
1104     /**
1105      * @dev Total number of tokens in existence
1106      */
1107     function totalSupply() public view returns (uint256) {
1108         return _totalSupply;
1109     }
1110 
1111     /**
1112      * @dev Gets the balance of the specified address.
1113      * @param owner The address to query the balance of.
1114      * @return A uint256 representing the amount owned by the passed address.
1115      */
1116     function balanceOf(address owner) public view returns (uint256) {
1117         return _balances[owner];
1118     }
1119 
1120     /**
1121      * @dev Function to check the amount of tokens that an owner allowed to a spender.
1122      * @param owner address The address which owns the funds.
1123      * @param spender address The address which will spend the funds.
1124      * @return A uint256 specifying the amount of tokens still available for the spender.
1125      */
1126     function allowance(address owner, address spender) public view returns (uint256) {
1127         return _allowed[owner][spender];
1128     }
1129 
1130     /**
1131      * @dev Transfer token to a specified address
1132      * @param to The address to transfer to.
1133      * @param value The amount to be transferred.
1134      */
1135     function transfer(address to, uint256 value) public returns (bool) {
1136         _transfer(msg.sender, to, value);
1137         return true;
1138     }
1139 
1140     /**
1141      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1142      * Beware that changing an allowance with this method brings the risk that someone may use both the old
1143      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1144      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1146      * @param spender The address which will spend the funds.
1147      * @param value The amount of tokens to be spent.
1148      */
1149     function approve(address spender, uint256 value) public returns (bool) {
1150         _approve(msg.sender, spender, value);
1151         return true;
1152     }
1153 
1154     /**
1155      * @dev Transfer tokens from one address to another.
1156      * Note that while this function emits an Approval event, this is not required as per the specification,
1157      * and other compliant implementations may not emit the event.
1158      * @param from address The address which you want to send tokens from
1159      * @param to address The address which you want to transfer to
1160      * @param value uint256 the amount of tokens to be transferred
1161      */
1162     function transferFrom(address from, address to, uint256 value) public returns (bool) {
1163         _transfer(from, to, value);
1164         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
1165         return true;
1166     }
1167 
1168     /**
1169      * @dev Increase the amount of tokens that an owner allowed to a spender.
1170      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
1171      * allowed value is better to use this function to avoid 2 calls (and wait until
1172      * the first transaction is mined)
1173      * From MonolithDAO Token.sol
1174      * Emits an Approval event.
1175      * @param spender The address which will spend the funds.
1176      * @param addedValue The amount of tokens to increase the allowance by.
1177      */
1178     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1179         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
1180         return true;
1181     }
1182 
1183     /**
1184      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1185      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
1186      * allowed value is better to use this function to avoid 2 calls (and wait until
1187      * the first transaction is mined)
1188      * From MonolithDAO Token.sol
1189      * Emits an Approval event.
1190      * @param spender The address which will spend the funds.
1191      * @param subtractedValue The amount of tokens to decrease the allowance by.
1192      */
1193     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1194         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
1195         return true;
1196     }
1197 
1198     /**
1199      * @dev Transfer token for a specified addresses
1200      * @param from The address to transfer from.
1201      * @param to The address to transfer to.
1202      * @param value The amount to be transferred.
1203      */
1204     function _transfer(address from, address to, uint256 value) internal {
1205         require(to != address(0));
1206 
1207         _balances[from] = _balances[from].sub(value);
1208         _balances[to] = _balances[to].add(value);
1209         emit Transfer(from, to, value);
1210     }
1211 
1212     /**
1213      * @dev Internal function that mints an amount of the token and assigns it to
1214      * an account. This encapsulates the modification of balances such that the
1215      * proper events are emitted.
1216      * @param account The account that will receive the created tokens.
1217      * @param value The amount that will be created.
1218      */
1219     function _mint(address account, uint256 value) internal {
1220         require(account != address(0));
1221 
1222         _totalSupply = _totalSupply.add(value);
1223         _balances[account] = _balances[account].add(value);
1224         emit Transfer(address(0), account, value);
1225     }
1226 
1227     /**
1228      * @dev Internal function that burns an amount of the token of a given
1229      * account.
1230      * @param account The account whose tokens will be burnt.
1231      * @param value The amount that will be burnt.
1232      */
1233     function _burn(address account, uint256 value) internal {
1234         require(account != address(0));
1235 
1236         _totalSupply = _totalSupply.sub(value);
1237         _balances[account] = _balances[account].sub(value);
1238         emit Transfer(account, address(0), value);
1239     }
1240 
1241     /**
1242      * @dev Approve an address to spend another addresses' tokens.
1243      * @param owner The address that owns the tokens.
1244      * @param spender The address that will spend the tokens.
1245      * @param value The number of tokens that can be spent.
1246      */
1247     function _approve(address owner, address spender, uint256 value) internal {
1248         require(spender != address(0));
1249         require(owner != address(0));
1250 
1251         _allowed[owner][spender] = value;
1252         emit Approval(owner, spender, value);
1253     }
1254 
1255     /**
1256      * @dev Internal function that burns an amount of the token of a given
1257      * account, deducting from the sender's allowance for said account. Uses the
1258      * internal burn function.
1259      * Emits an Approval event (reflecting the reduced allowance).
1260      * @param account The account whose tokens will be burnt.
1261      * @param value The amount that will be burnt.
1262      */
1263     function _burnFrom(address account, uint256 value) internal {
1264         _burn(account, value);
1265         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
1266     }
1267 }
1268 
1269 // File: contracts/token/InterfaceUpgradeAgent.sol
1270 
1271 pragma solidity ^0.5.2;
1272 
1273 /**
1274 * @title Upgrade agent interface
1275 */
1276 contract InterfaceUpgradeAgent {
1277 
1278     uint32 public revision;
1279 
1280     /**
1281      * @dev Reissue the tokens onto the new contract revision.
1282      * @param holder Holder (owner) of the tokens
1283      * @param tokenQty How many tokens to be issued
1284      * @return true if tokens properly reissued, false (or reverts) otherwise
1285      */
1286     function upgradeFrom(address holder, uint256 tokenQty) external returns (bool success);
1287 }
1288 
1289 // File: contracts/token/UpgradableToken.sol
1290 
1291 pragma solidity ^0.5.2;
1292 
1293 
1294 
1295 
1296 
1297 /**
1298  * @title UpgradableToken
1299  * @dev The UpgradableToken contract provides an option of upgrading the tokens to a new revision.
1300  * The contract owner only may enable the upgrade. After that anyone may trigger the upgrade.
1301  */
1302 
1303 contract UpgradableToken is ERC20, Ownable {
1304 
1305     using SafeMath for uint256;
1306 
1307     uint32 public REVISION;
1308 
1309     /** Address of the contract that issues the new revision tokens. */
1310     address public upgradeAgent = address(0);
1311 
1312     /** How many tokens are upgraded. */
1313     uint256 public totalUpgraded;
1314 
1315     event Upgrade(address indexed _from, uint256 _value);
1316     event UpgradeEnabled(address agent);
1317 
1318     /**
1319      * @dev Set the upgrade agent (once only) thus enabling the upgrade.
1320      * @param _upgradeAgent Upgrade agent contract address
1321      * @param _revision Unique ID that agent contract must return on ".revision()"
1322      */
1323     function setUpgradeAgent(address _upgradeAgent, uint32 _revision)
1324         onlyOwner whenUpgradeDisabled external
1325     {
1326         require((_upgradeAgent != address(0)) && (_revision != 0));
1327 
1328         InterfaceUpgradeAgent agent = InterfaceUpgradeAgent(_upgradeAgent);
1329         require(agent.revision() == _revision);
1330 
1331         upgradeAgent = _upgradeAgent;
1332         emit UpgradeEnabled(_upgradeAgent);
1333     }
1334 
1335     /**
1336      * @dev Upgrade tokens to the new revision.
1337      * @param from address tokens of which to be upgraded
1338      */
1339     function upgrade(address from) whenUpgradeEnabled external {
1340         require(from != address(0));
1341 
1342         uint256 value = balanceOf(from);
1343         require(value > 0);
1344 
1345         // Take tokens out from the old contract
1346         _burn(from, value);
1347         // Issue the new revision tokens
1348         totalUpgraded = totalUpgraded.add(value);
1349         InterfaceUpgradeAgent agent = InterfaceUpgradeAgent(upgradeAgent);
1350         require(agent.upgradeFrom(from, value));
1351 
1352         emit Upgrade(from, value);
1353     }
1354 
1355     /**
1356     * @dev Modifier to make a function callable only when the upgrade is enabled.
1357     */
1358     modifier whenUpgradeEnabled() {
1359         require(upgradeAgent != address(0));
1360         _;
1361     }
1362 
1363     /**
1364     * @dev Modifier to make a function callable only when the upgrade is impossible.
1365     */
1366     modifier whenUpgradeDisabled() {
1367         require(upgradeAgent == address(0));
1368         _;
1369     }
1370 
1371 }
1372 
1373 // File: contracts/token/InnouToken.sol
1374 
1375 pragma solidity ^0.5.2;
1376 
1377 
1378 
1379 
1380 
1381 contract InnToken is ERC20Detailed, UpgradableToken, Secondary {
1382     using SafeMath for uint256;
1383 
1384     string public constant NAME = "INNOU.IO Token";
1385     string public constant SYMBOL = "INNOU";
1386 
1387     /**
1388      * @dev The decimals are only for visualization purposes -
1389      * just as operations with ethers are done in wei,
1390      * all operations with the tokens are done in "atom"
1391      * that is the smallest and indivisible token unit:
1392      *     1 token = 1x10^DECIMALS atom(s)
1393      */
1394     uint8 public constant DECIMALS = 14;
1395 
1396     /**
1397      * @dev On top of tokens to investors the contract mints extra tokens to the primary account
1398      * (i.e. the one that created the contract) at this percent rate:
1399      */
1400     uint256 public constant PREMIUM_MINT_PCT = 15;
1401 
1402     constructor()
1403     ERC20Detailed(NAME, SYMBOL, DECIMALS)
1404     public
1405     {
1406     }
1407 
1408     /**
1409      * @dev Function to mint tokens
1410      * @param to The address that will receive the minted tokens.
1411      * @param value The amount of tokens to mint.
1412      * @return A boolean that indicates if the operation was successful.
1413      */
1414     function mint(address to, uint256 value) public onlyPrimary returns (bool) {
1415         // mint tokens to the requested address
1416         _mint(to, value);
1417         // mint extra tokens to the primary account
1418         uint256 premium = PREMIUM_MINT_PCT.mul(value).div(100);
1419         _mint(primary(), premium);
1420 
1421         return true;
1422     }
1423 
1424 }
1425 
1426 // File: contracts/crowdsale/InnouCrowdsale.sol
1427 
1428 pragma solidity ^0.5.2;
1429 
1430 
1431 
1432 /*
1433  * @title InnCrowdsale
1434  * @dev Before the goal (soft-cap) is reached the contract acts as openzeppelin RefundablePostDeliveryCrowdsale.
1435  * As soon as the goal is reached the contract behaves like openzeppelin MintedCrowdsale
1436  */
1437 
1438 contract InnCrowdsale is RefundablePostDeliveryCrowdsale {
1439 
1440     InnToken private _token = new InnToken();
1441     uint256 private _minPurchase;
1442 
1443     constructor(
1444         uint256 openingTime,
1445         uint256 closingTime,
1446         uint256 rate,
1447         address payable wallet,
1448         uint256 goal,
1449         uint256 minPurchase
1450     )
1451     Crowdsale(rate, wallet, _token)
1452     TimedCrowdsale(openingTime, closingTime)
1453     RefundableCrowdsale(goal)
1454     public{
1455         _minPurchase = minPurchase;
1456         _token.transferOwnership(msg.sender);
1457     }
1458 
1459     /**
1460     * @return the min purchase possible (in wei).
1461     */
1462     function minPurchase() public view returns (uint256) {
1463         return _minPurchase;
1464     }
1465 
1466     /**
1467      * @dev Transfer tokens held by the contract itself ("premium" tokens) to the wallet address.
1468      * Reverts if called by any address except the wallet.
1469      * @return true if tokens have been transferred.
1470      */
1471     function transferPremiumTokens() external returns (bool) {
1472         require(msg.sender == wallet());
1473         uint256 value = InnToken(_token).balanceOf(address(this));
1474         require(InnToken(_token).transfer(msg.sender, value));
1475         return true;
1476     }
1477 
1478     /**
1479      * @dev Like ERC20 tokens does, the contract provides the name the symbol and decimals for the token on sale.
1480      * It facilitates software wallets in getting info on the token.
1481      * @return the name of the token on sale.
1482      */
1483     function name() public view returns (string memory) {
1484         return _token.name();
1485     }
1486     /**
1487      * @return the symbol of the token on sale.
1488      */
1489     function symbol() public view returns (string memory) {
1490         return _token.symbol();
1491     }
1492     /**
1493      * @return the number of decimals of the token on sale.
1494      */
1495     function decimals() public view returns (uint8) {
1496         return _token.decimals();
1497     }
1498 
1499     /**
1500      * @return true if the crowdsale is open, false otherwise.
1501      */
1502     function isSaleOpen() public view returns (bool) {
1503         return TimedCrowdsale.isOpen();
1504     }
1505 
1506     /**
1507      * @dev Overrides parents by checking whether the REFUNDABLE part of the crowdsale is open.
1508      * (it considers if the goal has not yet been reached)
1509      * @return true if the refundable part of the crowdsale is open, false otherwise.
1510      */
1511     function isOpen() public view returns (bool) {
1512         if (goalReached()) {
1513             return false;
1514         }
1515         return super.isOpen();
1516     }
1517 
1518     /**
1519      * @dev Overrides parents by checking whether the REFUNDABLE part of the crowdsale has closed.
1520      * (i.e. considers if the goal has reached)
1521      * @return Whether the refundable part of the crowdsale has closed.
1522      */
1523     function hasClosed() public view returns (bool) {
1524         if (goalReached()) {
1525             return true;
1526         }
1527         return super.hasClosed();
1528     }
1529 
1530     /**
1531      * @dev Overrides parents by issuing tokens if the goal reached or storing the balance to mint them later otherwise.
1532      * @param beneficiary Token purchaser
1533      * @param tokenAmount Amount of tokens purchased
1534      */
1535     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
1536         if (goalReached()) {
1537             // mint tokens
1538             Crowdsale._processPurchase(beneficiary, tokenAmount);
1539         } else {
1540             // book balance to mint tokens later
1541             super._processPurchase(beneficiary, tokenAmount);
1542         }
1543     }
1544 
1545     /**
1546      * @dev Overrides fund forwarding.
1547      */
1548     function _forwardFunds() internal {
1549         if (goalReached()) {
1550             // directly to the wallet
1551             Crowdsale._forwardFunds();
1552         } else {
1553             // to the escrow
1554             RefundableCrowdsale._forwardFunds();
1555         }
1556     }
1557 
1558     /**
1559      * @dev Overrides pre-validation on token purchase transaction.
1560      * Replica of the openzeppelin methods except for re-defined isSaleOpen
1561      */
1562     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1563         // (note: this code runs before Crowdsale._weiRaised gets incremented with weiAmount)
1564         require(weiAmount >= _minPurchase);
1565         require(beneficiary != address(0));
1566         require(isSaleOpen());
1567     }
1568 
1569     /**
1570      * @dev Overrides delivery by minting tokens
1571      * (effectively, InnCrowdsale is MintedCrowdsale)
1572      * Replica of the openzeppelin MintedCrowdsale contract only own method
1573      * @param beneficiary Token purchaser
1574      * @param tokenAmount Number of tokens to be minted
1575      */
1576     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
1577         require(InnToken(address(token())).mint(beneficiary, tokenAmount));
1578     }
1579 
1580 }
1581 
1582 // File: contracts/crowdsale/InnouCrowdsaleReady.sol
1583 
1584 pragma solidity ^0.5.2;
1585 
1586 
1587 contract InnCrowdsaleReady is InnCrowdsale {
1588 
1589     // From 06/07/2019 @ 12:00am (UTC) to 07/18/2019 @ 11:59pm (UTC), Goal: 2000 ETH
1590     uint256 public constant OpeningTime = 1559865600;
1591     uint256 public constant ClosingTime = 1563494399;
1592     uint256 public constant Goal = 2000 ether;
1593 
1594     /**
1595      * all operations with tokens are done in "atom"
1596      * that is the smallest and indivisible token unit:
1597      *   1 token = 1e+14 atom
1598      *
1599      * token(s) exchanged for ether(s) at the fixed rate:
1600      *   1 ether => 10,000 token (1 wei => 1 atom)
1601      */
1602 
1603     // 1 wei gets this number of atom(s)
1604     uint256 public constant Rate = 1;
1605 
1606     //   1 szabo = 1e+12 wei = 1e-6 ether
1607     uint256 public constant MinPurchase = 5000 szabo;
1608 
1609     constructor(address payable wallet)
1610     InnCrowdsale(
1611         OpeningTime,
1612         ClosingTime,
1613         Rate,
1614         wallet,
1615         Goal,
1616         MinPurchase
1617     )
1618     public {
1619     }
1620 
1621 }