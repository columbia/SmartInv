1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 interface IERC20 {
76     function totalSupply() external view returns (uint256);
77 
78     function balanceOf(address who) external view returns (uint256);
79 
80     function allowance(address owner, address spender)
81     external view returns (uint256);
82 
83     function transfer(address to, uint256 value) external returns (bool);
84 
85     function approve(address spender, uint256 value)
86     external returns (bool);
87 
88     function transferFrom(address from, address to, uint256 value)
89     external returns (bool);
90 
91     event Transfer(
92         address indexed from,
93         address indexed to,
94         uint256 value
95     );
96 
97     event Approval(
98         address indexed owner,
99         address indexed spender,
100         uint256 value
101     );
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
105 
106 /**
107  * @title SafeERC20
108  * @dev Wrappers around ERC20 operations that throw on failure.
109  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
110  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
111  */
112 library SafeERC20 {
113 
114     using SafeMath for uint256;
115 
116     function safeTransfer(
117         IERC20 token,
118         address to,
119         uint256 value
120     )
121     internal
122     {
123         require(token.transfer(to, value));
124     }
125 
126     function safeTransferFrom(
127         IERC20 token,
128         address from,
129         address to,
130         uint256 value
131     )
132     internal
133     {
134         require(token.transferFrom(from, to, value));
135     }
136 
137     function safeApprove(
138         IERC20 token,
139         address spender,
140         uint256 value
141     )
142     internal
143     {
144         // safeApprove should only be called when setting an initial allowance,
145         // or when resetting it to zero. To increase and decrease it, use
146         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
147         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
148         require(token.approve(spender, value));
149     }
150 
151     function safeIncreaseAllowance(
152         IERC20 token,
153         address spender,
154         uint256 value
155     )
156     internal
157     {
158         uint256 newAllowance = token.allowance(address(this), spender).add(value);
159         require(token.approve(spender, newAllowance));
160     }
161 
162     function safeDecreaseAllowance(
163         IERC20 token,
164         address spender,
165         uint256 value
166     )
167     internal
168     {
169         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
170         require(token.approve(spender, newAllowance));
171     }
172 }
173 
174 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
175 
176 /**
177  * @title Helps contracts guard against reentrancy attacks.
178  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
179  * @dev If you mark a function `nonReentrant`, you should also
180  * mark it `external`.
181  */
182 contract ReentrancyGuard {
183 
184     /// @dev counter to allow mutex lock with only one SSTORE operation
185     uint256 private _guardCounter;
186 
187     constructor() internal {
188         // The counter starts at one to prevent changing it from zero to a non-zero
189         // value, which is a more expensive operation.
190         _guardCounter = 1;
191     }
192 
193     /**
194      * @dev Prevents a contract from calling itself, directly or indirectly.
195      * Calling a `nonReentrant` function from another `nonReentrant`
196      * function is not supported. It is possible to prevent this from happening
197      * by making the `nonReentrant` function external, and make it call a
198      * `private` function that does the actual work.
199      */
200     modifier nonReentrant() {
201         _guardCounter += 1;
202         uint256 localCounter = _guardCounter;
203         _;
204         require(localCounter == _guardCounter);
205     }
206 
207 }
208 
209 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
210 
211 /**
212  * @title Crowdsale
213  * @dev Crowdsale is a base contract for managing a token crowdsale,
214  * allowing investors to purchase tokens with ether. This contract implements
215  * such functionality in its most fundamental form and can be extended to provide additional
216  * functionality and/or custom behavior.
217  * The external interface represents the basic interface for purchasing tokens, and conform
218  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
219  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
220  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
221  * behavior.
222  */
223 contract Crowdsale is ReentrancyGuard {
224     using SafeMath for uint256;
225     using SafeERC20 for IERC20;
226 
227     // The token being sold
228     IERC20 private _token;
229 
230     // Address where funds are collected
231     address private _wallet;
232 
233     // How many token units a buyer gets per wei.
234     // The rate is the conversion between wei and the smallest and indivisible token unit.
235     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
236     // 1 wei will give you 1 unit, or 0.001 TOK.
237     uint256 private _rate;
238 
239     // Amount of wei raised
240     uint256 private _weiRaised;
241 
242     /**
243      * Event for token purchase logging
244      * @param purchaser who paid for the tokens
245      * @param beneficiary who got the tokens
246      * @param value weis paid for purchase
247      * @param amount amount of tokens purchased
248      */
249     event TokensPurchased(
250         address indexed purchaser,
251         address indexed beneficiary,
252         uint256 value,
253         uint256 amount
254     );
255 
256     /**
257      * @param rate Number of token units a buyer gets per wei
258      * @dev The rate is the conversion between wei and the smallest and indivisible
259      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
260      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
261      * @param wallet Address where collected funds will be forwarded to
262      * @param token Address of the token being sold
263      */
264     constructor(uint256 rate, address wallet, IERC20 token) internal {
265         require(rate > 0);
266         require(wallet != address(0));
267         require(token != address(0));
268 
269         _rate = rate;
270         _wallet = wallet;
271         _token = token;
272     }
273 
274     // -----------------------------------------
275     // Crowdsale external interface
276     // -----------------------------------------
277 
278     /**
279      * @dev fallback function ***DO NOT OVERRIDE***
280      * Note that other contracts will transfer fund with a base gas stipend
281      * of 2300, which is not enough to call buyTokens. Consider calling
282      * buyTokens directly when purchasing tokens from a contract.
283      */
284     function () external payable {
285         buyTokens(msg.sender);
286     }
287 
288     /**
289      * @return the token being sold.
290      */
291     function token() public view returns(IERC20) {
292         return _token;
293     }
294 
295     /**
296      * @return the address where funds are collected.
297      */
298     function wallet() public view returns(address) {
299         return _wallet;
300     }
301 
302     /**
303      * @return the number of token units a buyer gets per wei.
304      */
305     function rate() public view returns(uint256) {
306         return _rate;
307     }
308 
309     /**
310      * @return the amount of wei raised.
311      */
312     function weiRaised() public view returns (uint256) {
313         return _weiRaised;
314     }
315 
316     /**
317      * @dev low level token purchase ***DO NOT OVERRIDE***
318      * This function has a non-reentrancy guard, so it shouldn't be called by
319      * another `nonReentrant` function.
320      * @param beneficiary Recipient of the token purchase
321      */
322     function buyTokens(address beneficiary) public nonReentrant payable {
323 
324         uint256 weiAmount = msg.value;
325         _preValidatePurchase(beneficiary, weiAmount);
326 
327         // calculate token amount to be created
328         uint256 tokens = _getTokenAmount(weiAmount);
329 
330         // update state
331         _weiRaised = _weiRaised.add(weiAmount);
332 
333         _processPurchase(beneficiary, tokens);
334         emit TokensPurchased(
335             msg.sender,
336             beneficiary,
337             weiAmount,
338             tokens
339         );
340 
341         _updatePurchasingState(beneficiary, weiAmount);
342 
343         _forwardFunds();
344         _postValidatePurchase(beneficiary, weiAmount);
345     }
346 
347     // -----------------------------------------
348     // Internal interface (extensible)
349     // -----------------------------------------
350 
351     /**
352      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
353      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
354      *   super._preValidatePurchase(beneficiary, weiAmount);
355      *   require(weiRaised().add(weiAmount) <= cap);
356      * @param beneficiary Address performing the token purchase
357      * @param weiAmount Value in wei involved in the purchase
358      */
359     function _preValidatePurchase(
360         address beneficiary,
361         uint256 weiAmount
362     )
363     internal
364     view
365     {
366         require(beneficiary != address(0));
367         require(weiAmount != 0);
368     }
369 
370     /**
371      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
372      * @param beneficiary Address performing the token purchase
373      * @param weiAmount Value in wei involved in the purchase
374      */
375     function _postValidatePurchase(
376         address beneficiary,
377         uint256 weiAmount
378     )
379     internal
380     view
381     {
382         // optional override
383     }
384 
385     /**
386      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
387      * @param beneficiary Address performing the token purchase
388      * @param tokenAmount Number of tokens to be emitted
389      */
390     function _deliverTokens(
391         address beneficiary,
392         uint256 tokenAmount
393     )
394     internal
395     {
396         _token.safeTransfer(beneficiary, tokenAmount);
397     }
398 
399     /**
400      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
401      * @param beneficiary Address receiving the tokens
402      * @param tokenAmount Number of tokens to be purchased
403      */
404     function _processPurchase(
405         address beneficiary,
406         uint256 tokenAmount
407     )
408     internal
409     {
410         _deliverTokens(beneficiary, tokenAmount);
411     }
412 
413     /**
414      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
415      * @param beneficiary Address receiving the tokens
416      * @param weiAmount Value in wei involved in the purchase
417      */
418     function _updatePurchasingState(
419         address beneficiary,
420         uint256 weiAmount
421     )
422     internal
423     {
424         // optional override
425     }
426 
427     /**
428      * @dev Override to extend the way in which ether is converted to tokens.
429      * @param weiAmount Value in wei to be converted into tokens
430      * @return Number of tokens that can be purchased with the specified _weiAmount
431      */
432     function _getTokenAmount(uint256 weiAmount)
433     internal view returns (uint256)
434     {
435         return weiAmount.mul(_rate);
436     }
437 
438     /**
439      * @dev Determines how ETH is stored/forwarded on purchases.
440      */
441     function _forwardFunds() internal {
442         _wallet.transfer(msg.value);
443     }
444 }
445 
446 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
447 
448 /**
449  * @title CappedCrowdsale
450  * @dev Crowdsale with a limit for total contributions.
451  */
452 contract CappedCrowdsale is Crowdsale {
453     using SafeMath for uint256;
454 
455     uint256 private _cap;
456 
457     /**
458      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
459      * @param cap Max amount of wei to be contributed
460      */
461     constructor(uint256 cap) internal {
462         require(cap > 0);
463         _cap = cap;
464     }
465 
466     /**
467      * @return the cap of the crowdsale.
468      */
469     function cap() public view returns(uint256) {
470         return _cap;
471     }
472 
473     /**
474      * @dev Checks whether the cap has been reached.
475      * @return Whether the cap was reached
476      */
477     function capReached() public view returns (bool) {
478         return weiRaised() >= _cap;
479     }
480 
481     /**
482      * @dev Extend parent behavior requiring purchase to respect the funding cap.
483      * @param beneficiary Token purchaser
484      * @param weiAmount Amount of wei contributed
485      */
486     function _preValidatePurchase(
487         address beneficiary,
488         uint256 weiAmount
489     )
490     internal
491     view
492     {
493         super._preValidatePurchase(beneficiary, weiAmount);
494         require(weiRaised().add(weiAmount) <= _cap);
495     }
496 
497 }
498 
499 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
500 
501 /**
502  * @title TimedCrowdsale
503  * @dev Crowdsale accepting contributions only within a time frame.
504  */
505 contract TimedCrowdsale is Crowdsale {
506     using SafeMath for uint256;
507 
508     uint256 private _openingTime;
509     uint256 private _closingTime;
510 
511     /**
512      * @dev Reverts if not in crowdsale time range.
513      */
514     modifier onlyWhileOpen {
515         require(isOpen());
516         _;
517     }
518 
519     /**
520      * @dev Constructor, takes crowdsale opening and closing times.
521      * @param openingTime Crowdsale opening time
522      * @param closingTime Crowdsale closing time
523      */
524     constructor(uint256 openingTime, uint256 closingTime) internal {
525         // solium-disable-next-line security/no-block-members
526         require(openingTime >= block.timestamp);
527         require(closingTime > openingTime);
528 
529         _openingTime = openingTime;
530         _closingTime = closingTime;
531     }
532 
533     /**
534      * @return the crowdsale opening time.
535      */
536     function openingTime() public view returns(uint256) {
537         return _openingTime;
538     }
539 
540     /**
541      * @return the crowdsale closing time.
542      */
543     function closingTime() public view returns(uint256) {
544         return _closingTime;
545     }
546 
547     /**
548      * @return true if the crowdsale is open, false otherwise.
549      */
550     function isOpen() public view returns (bool) {
551         // solium-disable-next-line security/no-block-members
552         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
553     }
554 
555     /**
556      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
557      * @return Whether crowdsale period has elapsed
558      */
559     function hasClosed() public view returns (bool) {
560         // solium-disable-next-line security/no-block-members
561         return block.timestamp > _closingTime;
562     }
563 
564     /**
565      * @dev Extend parent behavior requiring to be within contributing period
566      * @param beneficiary Token purchaser
567      * @param weiAmount Amount of wei contributed
568      */
569     function _preValidatePurchase(
570         address beneficiary,
571         uint256 weiAmount
572     )
573     internal
574     onlyWhileOpen
575     view
576     {
577         super._preValidatePurchase(beneficiary, weiAmount);
578     }
579 
580 }
581 
582 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
583 
584 /**
585  * @title FinalizableCrowdsale
586  * @dev Extension of Crowdsale with a one-off finalization action, where one
587  * can do extra work after finishing.
588  */
589 contract FinalizableCrowdsale is TimedCrowdsale {
590     using SafeMath for uint256;
591 
592     bool private _finalized;
593 
594     event CrowdsaleFinalized();
595 
596     constructor() internal {
597         _finalized = false;
598     }
599 
600     /**
601      * @return true if the crowdsale is finalized, false otherwise.
602      */
603     function finalized() public view returns (bool) {
604         return _finalized;
605     }
606 
607     /**
608      * @dev Must be called after crowdsale ends, to do some extra finalization
609      * work. Calls the contract's finalization function.
610      */
611     function finalize() public {
612         require(!_finalized);
613         require(hasClosed());
614 
615         _finalized = true;
616 
617         _finalization();
618         emit CrowdsaleFinalized();
619     }
620 
621     /**
622      * @dev Can be overridden to add finalization logic. The overriding function
623      * should call super._finalization() to ensure the chain of finalization is
624      * executed entirely.
625      */
626     function _finalization() internal {
627     }
628 }
629 
630 // File: openzeppelin-solidity/contracts/ownership/Secondary.sol
631 
632 /**
633  * @title Secondary
634  * @dev A Secondary contract can only be used by its primary account (the one that created it)
635  */
636 contract Secondary {
637     address private _primary;
638 
639     event PrimaryTransferred(
640         address recipient
641     );
642 
643     /**
644      * @dev Sets the primary account to the one that is creating the Secondary contract.
645      */
646     constructor() internal {
647         _primary = msg.sender;
648         emit PrimaryTransferred(_primary);
649     }
650 
651     /**
652      * @dev Reverts if called from any account other than the primary.
653      */
654     modifier onlyPrimary() {
655         require(msg.sender == _primary);
656         _;
657     }
658 
659     /**
660      * @return the address of the primary.
661      */
662     function primary() public view returns (address) {
663         return _primary;
664     }
665 
666     /**
667      * @dev Transfers contract to a new primary.
668      * @param recipient The address of new primary.
669      */
670     function transferPrimary(address recipient) public onlyPrimary {
671         require(recipient != address(0));
672         _primary = recipient;
673         emit PrimaryTransferred(_primary);
674     }
675 }
676 
677 // File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
678 
679 /**
680  * @title Escrow
681  * @dev Base escrow contract, holds funds designated for a payee until they
682  * withdraw them.
683  * @dev Intended usage: This contract (and derived escrow contracts) should be a
684  * standalone contract, that only interacts with the contract that instantiated
685  * it. That way, it is guaranteed that all Ether will be handled according to
686  * the Escrow rules, and there is no need to check for payable functions or
687  * transfers in the inheritance tree. The contract that uses the escrow as its
688  * payment method should be its primary, and provide public methods redirecting
689  * to the escrow's deposit and withdraw.
690  */
691 contract Escrow is Secondary {
692     using SafeMath for uint256;
693 
694     event Deposited(address indexed payee, uint256 weiAmount);
695     event Withdrawn(address indexed payee, uint256 weiAmount);
696 
697     mapping(address => uint256) private _deposits;
698 
699     function depositsOf(address payee) public view returns (uint256) {
700         return _deposits[payee];
701     }
702 
703     /**
704     * @dev Stores the sent amount as credit to be withdrawn.
705     * @param payee The destination address of the funds.
706     */
707     function deposit(address payee) public onlyPrimary payable {
708         uint256 amount = msg.value;
709         _deposits[payee] = _deposits[payee].add(amount);
710 
711         emit Deposited(payee, amount);
712     }
713 
714     /**
715     * @dev Withdraw accumulated balance for a payee.
716     * @param payee The address whose funds will be withdrawn and transferred to.
717     */
718     function withdraw(address payee) public onlyPrimary {
719         uint256 payment = _deposits[payee];
720 
721         _deposits[payee] = 0;
722 
723         payee.transfer(payment);
724 
725         emit Withdrawn(payee, payment);
726     }
727 }
728 
729 // File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
730 
731 /**
732  * @title ConditionalEscrow
733  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
734  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
735  */
736 contract ConditionalEscrow is Escrow {
737     /**
738     * @dev Returns whether an address is allowed to withdraw their funds. To be
739     * implemented by derived contracts.
740     * @param payee The destination address of the funds.
741     */
742     function withdrawalAllowed(address payee) public view returns (bool);
743 
744     function withdraw(address payee) public {
745         require(withdrawalAllowed(payee));
746         super.withdraw(payee);
747     }
748 }
749 
750 // File: openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol
751 
752 /**
753  * @title RefundEscrow
754  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
755  * parties.
756  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
757  * @dev The primary account (that is, the contract that instantiates this
758  * contract) may deposit, close the deposit period, and allow for either
759  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
760  * with RefundEscrow will be made through the primary contract. See the
761  * RefundableCrowdsale contract for an example of RefundEscrow’s use.
762  */
763 contract RefundEscrow is ConditionalEscrow {
764     enum State { Active, Refunding, Closed }
765 
766     event RefundsClosed();
767     event RefundsEnabled();
768 
769     State private _state;
770     address private _beneficiary;
771 
772     /**
773      * @dev Constructor.
774      * @param beneficiary The beneficiary of the deposits.
775      */
776     constructor(address beneficiary) public {
777         require(beneficiary != address(0));
778         _beneficiary = beneficiary;
779         _state = State.Active;
780     }
781 
782     /**
783      * @return the current state of the escrow.
784      */
785     function state() public view returns (State) {
786         return _state;
787     }
788 
789     /**
790      * @return the beneficiary of the escrow.
791      */
792     function beneficiary() public view returns (address) {
793         return _beneficiary;
794     }
795 
796     /**
797      * @dev Stores funds that may later be refunded.
798      * @param refundee The address funds will be sent to if a refund occurs.
799      */
800     function deposit(address refundee) public payable {
801         require(_state == State.Active);
802         super.deposit(refundee);
803     }
804 
805     /**
806      * @dev Allows for the beneficiary to withdraw their funds, rejecting
807      * further deposits.
808      */
809     function close() public onlyPrimary {
810         require(_state == State.Active);
811         _state = State.Closed;
812         emit RefundsClosed();
813     }
814 
815     /**
816      * @dev Allows for refunds to take place, rejecting further deposits.
817      */
818     function enableRefunds() public onlyPrimary {
819         require(_state == State.Active);
820         _state = State.Refunding;
821         emit RefundsEnabled();
822     }
823 
824     /**
825      * @dev Withdraws the beneficiary's funds.
826      */
827     function beneficiaryWithdraw() public {
828         require(_state == State.Closed);
829         _beneficiary.transfer(address(this).balance);
830     }
831 
832     /**
833      * @dev Returns whether refundees can withdraw their deposits (be refunded).
834      */
835     function withdrawalAllowed(address payee) public view returns (bool) {
836         return _state == State.Refunding;
837     }
838 }
839 
840 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
841 
842 /**
843  * @title RefundableCrowdsale
844  * @dev Extension of Crowdsale contract that adds a funding goal, and
845  * the possibility of users getting a refund if goal is not met.
846  * WARNING: note that if you allow tokens to be traded before the goal
847  * is met, then an attack is possible in which the attacker purchases
848  * tokens from the crowdsale and when they sees that the goal is
849  * unlikely to be met, they sell their tokens (possibly at a discount).
850  * The attacker will be refunded when the crowdsale is finalized, and
851  * the users that purchased from them will be left with worthless
852  * tokens. There are many possible ways to avoid this, like making the
853  * the crowdsale inherit from PostDeliveryCrowdsale, or imposing
854  * restrictions on token trading until the crowdsale is finalized.
855  * This is being discussed in
856  * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/877
857  * This contract will be updated when we agree on a general solution
858  * for this problem.
859  */
860 contract RefundableCrowdsale is FinalizableCrowdsale {
861     using SafeMath for uint256;
862 
863     // minimum amount of funds to be raised in weis
864     uint256 private _goal;
865 
866     // refund escrow used to hold funds while crowdsale is running
867     RefundEscrow private _escrow;
868 
869     /**
870      * @dev Constructor, creates RefundEscrow.
871      * @param goal Funding goal
872      */
873     constructor(uint256 goal) internal {
874         require(goal > 0);
875         _escrow = new RefundEscrow(wallet());
876         _goal = goal;
877     }
878 
879     /**
880      * @return minimum amount of funds to be raised in wei.
881      */
882     function goal() public view returns(uint256) {
883         return _goal;
884     }
885 
886     /**
887      * @dev Investors can claim refunds here if crowdsale is unsuccessful
888      * @param beneficiary Whose refund will be claimed.
889      */
890     function claimRefund(address beneficiary) public {
891         require(finalized());
892         require(!goalReached());
893 
894         _escrow.withdraw(beneficiary);
895     }
896 
897     /**
898      * @dev Checks whether funding goal was reached.
899      * @return Whether funding goal was reached
900      */
901     function goalReached() public view returns (bool) {
902         return weiRaised() >= _goal;
903     }
904 
905     /**
906      * @dev escrow finalization task, called when finalize() is called
907      */
908     function _finalization() internal {
909         if (goalReached()) {
910             _escrow.close();
911             _escrow.beneficiaryWithdraw();
912         } else {
913             _escrow.enableRefunds();
914         }
915 
916         super._finalization();
917     }
918 
919     /**
920      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
921      */
922     function _forwardFunds() internal {
923         _escrow.deposit.value(msg.value)(msg.sender);
924     }
925 
926 }
927 
928 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
929 
930 /**
931  * @title Standard ERC20 token
932  *
933  * @dev Implementation of the basic standard token.
934  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
935  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
936  */
937 contract ERC20 is IERC20 {
938     using SafeMath for uint256;
939 
940     mapping (address => uint256) private _balances;
941 
942     mapping (address => mapping (address => uint256)) private _allowed;
943 
944     uint256 private _totalSupply;
945 
946     /**
947     * @dev Total number of tokens in existence
948     */
949     function totalSupply() public view returns (uint256) {
950         return _totalSupply;
951     }
952 
953     /**
954     * @dev Gets the balance of the specified address.
955     * @param owner The address to query the balance of.
956     * @return An uint256 representing the amount owned by the passed address.
957     */
958     function balanceOf(address owner) public view returns (uint256) {
959         return _balances[owner];
960     }
961 
962     /**
963      * @dev Function to check the amount of tokens that an owner allowed to a spender.
964      * @param owner address The address which owns the funds.
965      * @param spender address The address which will spend the funds.
966      * @return A uint256 specifying the amount of tokens still available for the spender.
967      */
968     function allowance(
969         address owner,
970         address spender
971     )
972     public
973     view
974     returns (uint256)
975     {
976         return _allowed[owner][spender];
977     }
978 
979     /**
980     * @dev Transfer token for a specified address
981     * @param to The address to transfer to.
982     * @param value The amount to be transferred.
983     */
984     function transfer(address to, uint256 value) public returns (bool) {
985         _transfer(msg.sender, to, value);
986         return true;
987     }
988 
989     /**
990      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
991      * Beware that changing an allowance with this method brings the risk that someone may use both the old
992      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
993      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
994      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
995      * @param spender The address which will spend the funds.
996      * @param value The amount of tokens to be spent.
997      */
998     function approve(address spender, uint256 value) public returns (bool) {
999         require(spender != address(0));
1000 
1001         _allowed[msg.sender][spender] = value;
1002         emit Approval(msg.sender, spender, value);
1003         return true;
1004     }
1005 
1006     /**
1007      * @dev Transfer tokens from one address to another
1008      * @param from address The address which you want to send tokens from
1009      * @param to address The address which you want to transfer to
1010      * @param value uint256 the amount of tokens to be transferred
1011      */
1012     function transferFrom(
1013         address from,
1014         address to,
1015         uint256 value
1016     )
1017     public
1018     returns (bool)
1019     {
1020         require(value <= _allowed[from][msg.sender]);
1021 
1022         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
1023         _transfer(from, to, value);
1024         return true;
1025     }
1026 
1027     /**
1028      * @dev Increase the amount of tokens that an owner allowed to a spender.
1029      * approve should be called when allowed_[_spender] == 0. To increment
1030      * allowed value is better to use this function to avoid 2 calls (and wait until
1031      * the first transaction is mined)
1032      * From MonolithDAO Token.sol
1033      * @param spender The address which will spend the funds.
1034      * @param addedValue The amount of tokens to increase the allowance by.
1035      */
1036     function increaseAllowance(
1037         address spender,
1038         uint256 addedValue
1039     )
1040     public
1041     returns (bool)
1042     {
1043         require(spender != address(0));
1044 
1045         _allowed[msg.sender][spender] = (
1046         _allowed[msg.sender][spender].add(addedValue));
1047         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1048         return true;
1049     }
1050 
1051     /**
1052      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1053      * approve should be called when allowed_[_spender] == 0. To decrement
1054      * allowed value is better to use this function to avoid 2 calls (and wait until
1055      * the first transaction is mined)
1056      * From MonolithDAO Token.sol
1057      * @param spender The address which will spend the funds.
1058      * @param subtractedValue The amount of tokens to decrease the allowance by.
1059      */
1060     function decreaseAllowance(
1061         address spender,
1062         uint256 subtractedValue
1063     )
1064     public
1065     returns (bool)
1066     {
1067         require(spender != address(0));
1068 
1069         _allowed[msg.sender][spender] = (
1070         _allowed[msg.sender][spender].sub(subtractedValue));
1071         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1072         return true;
1073     }
1074 
1075     /**
1076     * @dev Transfer token for a specified addresses
1077     * @param from The address to transfer from.
1078     * @param to The address to transfer to.
1079     * @param value The amount to be transferred.
1080     */
1081     function _transfer(address from, address to, uint256 value) internal {
1082         require(value <= _balances[from]);
1083         require(to != address(0));
1084 
1085         _balances[from] = _balances[from].sub(value);
1086         _balances[to] = _balances[to].add(value);
1087         emit Transfer(from, to, value);
1088     }
1089 
1090     /**
1091      * @dev Internal function that mints an amount of the token and assigns it to
1092      * an account. This encapsulates the modification of balances such that the
1093      * proper events are emitted.
1094      * @param account The account that will receive the created tokens.
1095      * @param value The amount that will be created.
1096      */
1097     function _mint(address account, uint256 value) internal {
1098         require(account != 0);
1099         _totalSupply = _totalSupply.add(value);
1100         _balances[account] = _balances[account].add(value);
1101         emit Transfer(address(0), account, value);
1102     }
1103 
1104     /**
1105      * @dev Internal function that burns an amount of the token of a given
1106      * account.
1107      * @param account The account whose tokens will be burnt.
1108      * @param value The amount that will be burnt.
1109      */
1110     function _burn(address account, uint256 value) internal {
1111         require(account != 0);
1112         require(value <= _balances[account]);
1113 
1114         _totalSupply = _totalSupply.sub(value);
1115         _balances[account] = _balances[account].sub(value);
1116         emit Transfer(account, address(0), value);
1117     }
1118 
1119     /**
1120      * @dev Internal function that burns an amount of the token of a given
1121      * account, deducting from the sender's allowance for said account. Uses the
1122      * internal burn function.
1123      * @param account The account whose tokens will be burnt.
1124      * @param value The amount that will be burnt.
1125      */
1126     function _burnFrom(address account, uint256 value) internal {
1127         require(value <= _allowed[account][msg.sender]);
1128 
1129         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
1130         // this function needs to emit an event with the updated approval.
1131         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
1132             value);
1133         _burn(account, value);
1134     }
1135 }
1136 
1137 // File: openzeppelin-solidity/contracts/access/Roles.sol
1138 
1139 /**
1140  * @title Roles
1141  * @dev Library for managing addresses assigned to a Role.
1142  */
1143 library Roles {
1144     struct Role {
1145         mapping (address => bool) bearer;
1146     }
1147 
1148     /**
1149      * @dev give an account access to this role
1150      */
1151     function add(Role storage role, address account) internal {
1152         require(account != address(0));
1153         require(!has(role, account));
1154 
1155         role.bearer[account] = true;
1156     }
1157 
1158     /**
1159      * @dev remove an account's access to this role
1160      */
1161     function remove(Role storage role, address account) internal {
1162         require(account != address(0));
1163         require(has(role, account));
1164 
1165         role.bearer[account] = false;
1166     }
1167 
1168     /**
1169      * @dev check if an account has this role
1170      * @return bool
1171      */
1172     function has(Role storage role, address account)
1173     internal
1174     view
1175     returns (bool)
1176     {
1177         require(account != address(0));
1178         return role.bearer[account];
1179     }
1180 }
1181 
1182 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1183 
1184 contract MinterRole {
1185     using Roles for Roles.Role;
1186 
1187     event MinterAdded(address indexed account);
1188     event MinterRemoved(address indexed account);
1189 
1190     Roles.Role private minters;
1191 
1192     constructor() internal {
1193         _addMinter(msg.sender);
1194     }
1195 
1196     modifier onlyMinter() {
1197         require(isMinter(msg.sender));
1198         _;
1199     }
1200 
1201     function isMinter(address account) public view returns (bool) {
1202         return minters.has(account);
1203     }
1204 
1205     function addMinter(address account) public onlyMinter {
1206         _addMinter(account);
1207     }
1208 
1209     function renounceMinter() public {
1210         _removeMinter(msg.sender);
1211     }
1212 
1213     function _addMinter(address account) internal {
1214         minters.add(account);
1215         emit MinterAdded(account);
1216     }
1217 
1218     function _removeMinter(address account) internal {
1219         minters.remove(account);
1220         emit MinterRemoved(account);
1221     }
1222 }
1223 
1224 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
1225 
1226 /**
1227  * @title ERC20Mintable
1228  * @dev ERC20 minting logic
1229  */
1230 contract ERC20Mintable is ERC20, MinterRole {
1231     /**
1232      * @dev Function to mint tokens
1233      * @param to The address that will receive the minted tokens.
1234      * @param value The amount of tokens to mint.
1235      * @return A boolean that indicates if the operation was successful.
1236      */
1237     function mint(
1238         address to,
1239         uint256 value
1240     )
1241     public
1242     onlyMinter
1243     returns (bool)
1244     {
1245         _mint(to, value);
1246         return true;
1247     }
1248 }
1249 
1250 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
1251 
1252 /**
1253  * @title MintedCrowdsale
1254  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1255  * Token ownership should be transferred to MintedCrowdsale for minting.
1256  */
1257 contract MintedCrowdsale is Crowdsale {
1258     constructor() internal {}
1259 
1260     /**
1261      * @dev Overrides delivery by minting tokens upon purchase.
1262      * @param beneficiary Token purchaser
1263      * @param tokenAmount Number of tokens to be minted
1264      */
1265     function _deliverTokens(
1266         address beneficiary,
1267         uint256 tokenAmount
1268     )
1269     internal
1270     {
1271         // Potentially dangerous assumption about the type of the token.
1272         require(
1273             ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
1274     }
1275 }
1276 
1277 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
1278 
1279 /**
1280  * @title Capped token
1281  * @dev Mintable token with a token cap.
1282  */
1283 contract ERC20Capped is ERC20Mintable {
1284 
1285     uint256 private _cap;
1286 
1287     constructor(uint256 cap)
1288     public
1289     {
1290         require(cap > 0);
1291         _cap = cap;
1292     }
1293 
1294     /**
1295      * @return the cap for the token minting.
1296      */
1297     function cap() public view returns(uint256) {
1298         return _cap;
1299     }
1300 
1301     function _mint(address account, uint256 value) internal {
1302         require(totalSupply().add(value) <= _cap);
1303         super._mint(account, value);
1304     }
1305 }
1306 
1307 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
1308 
1309 /**
1310  * @title Burnable Token
1311  * @dev Token that can be irreversibly burned (destroyed).
1312  */
1313 contract ERC20Burnable is ERC20 {
1314 
1315     /**
1316      * @dev Burns a specific amount of tokens.
1317      * @param value The amount of token to be burned.
1318      */
1319     function burn(uint256 value) public {
1320         _burn(msg.sender, value);
1321     }
1322 
1323     /**
1324      * @dev Burns a specific amount of tokens from the target address and decrements allowance
1325      * @param from address The address which you want to send tokens from
1326      * @param value uint256 The amount of token to be burned
1327      */
1328     function burnFrom(address from, uint256 value) public {
1329         _burnFrom(from, value);
1330     }
1331 }
1332 
1333 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1334 
1335 /**
1336  * @title ERC20Detailed token
1337  * @dev The decimals are only for visualization purposes.
1338  * All the operations are done using the smallest and indivisible token unit,
1339  * just as on Ethereum all the operations are done in wei.
1340  */
1341 contract ERC20Detailed is IERC20 {
1342     string private _name;
1343     string private _symbol;
1344     uint8 private _decimals;
1345 
1346     constructor(string name, string symbol, uint8 decimals) public {
1347         _name = name;
1348         _symbol = symbol;
1349         _decimals = decimals;
1350     }
1351 
1352     /**
1353      * @return the name of the token.
1354      */
1355     function name() public view returns(string) {
1356         return _name;
1357     }
1358 
1359     /**
1360      * @return the symbol of the token.
1361      */
1362     function symbol() public view returns(string) {
1363         return _symbol;
1364     }
1365 
1366     /**
1367      * @return the number of decimals of the token.
1368      */
1369     function decimals() public view returns(uint8) {
1370         return _decimals;
1371     }
1372 }
1373 
1374 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
1375 
1376 contract PauserRole {
1377     using Roles for Roles.Role;
1378 
1379     event PauserAdded(address indexed account);
1380     event PauserRemoved(address indexed account);
1381 
1382     Roles.Role private pausers;
1383 
1384     constructor() internal {
1385         _addPauser(msg.sender);
1386     }
1387 
1388     modifier onlyPauser() {
1389         require(isPauser(msg.sender));
1390         _;
1391     }
1392 
1393     function isPauser(address account) public view returns (bool) {
1394         return pausers.has(account);
1395     }
1396 
1397     function addPauser(address account) public onlyPauser {
1398         _addPauser(account);
1399     }
1400 
1401     function renouncePauser() public {
1402         _removePauser(msg.sender);
1403     }
1404 
1405     function _addPauser(address account) internal {
1406         pausers.add(account);
1407         emit PauserAdded(account);
1408     }
1409 
1410     function _removePauser(address account) internal {
1411         pausers.remove(account);
1412         emit PauserRemoved(account);
1413     }
1414 }
1415 
1416 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
1417 
1418 /**
1419  * @title Pausable
1420  * @dev Base contract which allows children to implement an emergency stop mechanism.
1421  */
1422 contract Pausable is PauserRole {
1423     event Paused(address account);
1424     event Unpaused(address account);
1425 
1426     bool private _paused;
1427 
1428     constructor() internal {
1429         _paused = false;
1430     }
1431 
1432     /**
1433      * @return true if the contract is paused, false otherwise.
1434      */
1435     function paused() public view returns(bool) {
1436         return _paused;
1437     }
1438 
1439     /**
1440      * @dev Modifier to make a function callable only when the contract is not paused.
1441      */
1442     modifier whenNotPaused() {
1443         require(!_paused);
1444         _;
1445     }
1446 
1447     /**
1448      * @dev Modifier to make a function callable only when the contract is paused.
1449      */
1450     modifier whenPaused() {
1451         require(_paused);
1452         _;
1453     }
1454 
1455     /**
1456      * @dev called by the owner to pause, triggers stopped state
1457      */
1458     function pause() public onlyPauser whenNotPaused {
1459         _paused = true;
1460         emit Paused(msg.sender);
1461     }
1462 
1463     /**
1464      * @dev called by the owner to unpause, returns to normal state
1465      */
1466     function unpause() public onlyPauser whenPaused {
1467         _paused = false;
1468         emit Unpaused(msg.sender);
1469     }
1470 }
1471 
1472 // File: contracts\Zion.sol
1473 
1474 contract Zion is ERC20Mintable, ERC20Detailed,  Pausable {
1475 
1476     // define initial coin supply here
1477     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals()));
1478 
1479     /**
1480      * @dev Constructor that gives msg.sender all of existing tokens.
1481      */
1482     constructor () public ERC20Detailed("Zion", "ZION", 18) {
1483         _mint(msg.sender, INITIAL_SUPPLY);
1484     }
1485 
1486     /**
1487      * @dev Burns a specific amount of tokens.
1488      * @param value The amount of token to be burned.
1489      */
1490     function burn(uint256 value) public {
1491         _burn(msg.sender, value);
1492     }
1493 
1494     /**
1495      * @dev Burns a specific amount of tokens from the target address and decrements allowance
1496      * @param from address The address which you want to send tokens from
1497      * @param value uint256 The amount of token to be burned
1498      */
1499     function burnFrom(address from, uint256 value) public {
1500         _burnFrom(from, value);
1501     }
1502 
1503     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
1504         return super.transfer(to, value);
1505     }
1506 
1507     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
1508         return super.transferFrom(from, to, value);
1509     }
1510 
1511     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
1512         return super.approve(spender, value);
1513     }
1514 
1515     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
1516         return super.increaseAllowance(spender, addedValue);
1517     }
1518 
1519     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
1520         return super.decreaseAllowance(spender, subtractedValue);
1521     }
1522 
1523 }