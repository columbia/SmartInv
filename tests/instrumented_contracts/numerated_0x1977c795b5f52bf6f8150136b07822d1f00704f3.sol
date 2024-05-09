1 /**
2  *Submitted for verification at Etherscan.io on 2019-02-15
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that revert on error
12  */
13 library SafeMath {
14 
15     /**
16     * @dev Multiplies two numbers, reverts on overflow.
17     */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
20         // benefit is lost if 'b' is also tested.
21         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b);
28 
29         return c;
30     }
31 
32     /**
33     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
34     */
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b > 0); // Solidity only automatically asserts when dividing by 0
37         uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 
40         return c;
41     }
42 
43     /**
44     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54     * @dev Adds two numbers, reverts on overflow.
55     */
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a);
59 
60         return c;
61     }
62 
63     /**
64     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
65     * reverts when dividing by zero.
66     */
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b != 0);
69         return a % b;
70     }
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
74 
75 /**
76  * @title ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 interface IERC20 {
80     function totalSupply() external view returns (uint256);
81 
82     function balanceOf(address who) external view returns (uint256);
83 
84     function allowance(address owner, address spender)
85     external view returns (uint256);
86 
87     function transfer(address to, uint256 value) external returns (bool);
88 
89     function approve(address spender, uint256 value)
90     external returns (bool);
91 
92     function transferFrom(address from, address to, uint256 value)
93     external returns (bool);
94 
95     event Transfer(
96         address indexed from,
97         address indexed to,
98         uint256 value
99     );
100 
101     event Approval(
102         address indexed owner,
103         address indexed spender,
104         uint256 value
105     );
106 }
107 
108 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
109 
110 /**
111  * @title SafeERC20
112  * @dev Wrappers around ERC20 operations that throw on failure.
113  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
114  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
115  */
116 library SafeERC20 {
117 
118     using SafeMath for uint256;
119 
120     function safeTransfer(
121         IERC20 token,
122         address to,
123         uint256 value
124     )
125     internal
126     {
127         require(token.transfer(to, value));
128     }
129 
130     function safeTransferFrom(
131         IERC20 token,
132         address from,
133         address to,
134         uint256 value
135     )
136     internal
137     {
138         require(token.transferFrom(from, to, value));
139     }
140 
141     function safeApprove(
142         IERC20 token,
143         address spender,
144         uint256 value
145     )
146     internal
147     {
148         // safeApprove should only be called when setting an initial allowance,
149         // or when resetting it to zero. To increase and decrease it, use
150         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
151         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
152         require(token.approve(spender, value));
153     }
154 
155     function safeIncreaseAllowance(
156         IERC20 token,
157         address spender,
158         uint256 value
159     )
160     internal
161     {
162         uint256 newAllowance = token.allowance(address(this), spender).add(value);
163         require(token.approve(spender, newAllowance));
164     }
165 
166     function safeDecreaseAllowance(
167         IERC20 token,
168         address spender,
169         uint256 value
170     )
171     internal
172     {
173         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
174         require(token.approve(spender, newAllowance));
175     }
176 }
177 
178 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
179 
180 /**
181  * @title Helps contracts guard against reentrancy attacks.
182  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
183  * @dev If you mark a function `nonReentrant`, you should also
184  * mark it `external`.
185  */
186 contract ReentrancyGuard {
187 
188     /// @dev counter to allow mutex lock with only one SSTORE operation
189     uint256 private _guardCounter;
190 
191     constructor() internal {
192         // The counter starts at one to prevent changing it from zero to a non-zero
193         // value, which is a more expensive operation.
194         _guardCounter = 1;
195     }
196 
197     /**
198      * @dev Prevents a contract from calling itself, directly or indirectly.
199      * Calling a `nonReentrant` function from another `nonReentrant`
200      * function is not supported. It is possible to prevent this from happening
201      * by making the `nonReentrant` function external, and make it call a
202      * `private` function that does the actual work.
203      */
204     modifier nonReentrant() {
205         _guardCounter += 1;
206         uint256 localCounter = _guardCounter;
207         _;
208         require(localCounter == _guardCounter);
209     }
210 
211 }
212 
213 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
214 
215 /**
216  * @title Crowdsale
217  * @dev Crowdsale is a base contract for managing a token crowdsale,
218  * allowing investors to purchase tokens with ether. This contract implements
219  * such functionality in its most fundamental form and can be extended to provide additional
220  * functionality and/or custom behavior.
221  * The external interface represents the basic interface for purchasing tokens, and conform
222  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
223  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
224  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
225  * behavior.
226  */
227 contract Crowdsale is ReentrancyGuard {
228     using SafeMath for uint256;
229     using SafeERC20 for IERC20;
230 
231     // The token being sold
232     IERC20 private _token;
233 
234     // Address where funds are collected
235     address private _wallet;
236 
237     // How many token units a buyer gets per wei.
238     // The rate is the conversion between wei and the smallest and indivisible token unit.
239     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
240     // 1 wei will give you 1 unit, or 0.001 TOK.
241     uint256 private _rate;
242 
243     // Amount of wei raised
244     uint256 private _weiRaised;
245 
246     /**
247      * Event for token purchase logging
248      * @param purchaser who paid for the tokens
249      * @param beneficiary who got the tokens
250      * @param value weis paid for purchase
251      * @param amount amount of tokens purchased
252      */
253     event TokensPurchased(
254         address indexed purchaser,
255         address indexed beneficiary,
256         uint256 value,
257         uint256 amount
258     );
259 
260     /**
261      * @param rate Number of token units a buyer gets per wei
262      * @dev The rate is the conversion between wei and the smallest and indivisible
263      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
264      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
265      * @param wallet Address where collected funds will be forwarded to
266      * @param token Address of the token being sold
267      */
268     constructor(uint256 rate, address wallet, IERC20 token) internal {
269         require(rate > 0);
270         require(wallet != address(0));
271         require(token != address(0));
272 
273         _rate = rate;
274         _wallet = wallet;
275         _token = token;
276     }
277 
278     // -----------------------------------------
279     // Crowdsale external interface
280     // -----------------------------------------
281 
282     /**
283      * @dev fallback function ***DO NOT OVERRIDE***
284      * Note that other contracts will transfer fund with a base gas stipend
285      * of 2300, which is not enough to call buyTokens. Consider calling
286      * buyTokens directly when purchasing tokens from a contract.
287      */
288     function () external payable {
289         buyTokens(msg.sender);
290     }
291 
292     /**
293      * @return the token being sold.
294      */
295     function token() public view returns(IERC20) {
296         return _token;
297     }
298 
299     /**
300      * @return the address where funds are collected.
301      */
302     function wallet() public view returns(address) {
303         return _wallet;
304     }
305 
306     /**
307      * @return the number of token units a buyer gets per wei.
308      */
309     function rate() public view returns(uint256) {
310         return _rate;
311     }
312 
313     /**
314      * @return the amount of wei raised.
315      */
316     function weiRaised() public view returns (uint256) {
317         return _weiRaised;
318     }
319 
320     /**
321      * @dev low level token purchase ***DO NOT OVERRIDE***
322      * This function has a non-reentrancy guard, so it shouldn't be called by
323      * another `nonReentrant` function.
324      * @param beneficiary Recipient of the token purchase
325      */
326     function buyTokens(address beneficiary) public nonReentrant payable {
327 
328         uint256 weiAmount = msg.value;
329         _preValidatePurchase(beneficiary, weiAmount);
330 
331         // calculate token amount to be created
332         uint256 tokens = _getTokenAmount(weiAmount);
333 
334         // update state
335         _weiRaised = _weiRaised.add(weiAmount);
336 
337         _processPurchase(beneficiary, tokens);
338         emit TokensPurchased(
339             msg.sender,
340             beneficiary,
341             weiAmount,
342             tokens
343         );
344 
345         _updatePurchasingState(beneficiary, weiAmount);
346 
347         _forwardFunds();
348         _postValidatePurchase(beneficiary, weiAmount);
349     }
350 
351     // -----------------------------------------
352     // Internal interface (extensible)
353     // -----------------------------------------
354 
355     /**
356      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
357      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
358      *   super._preValidatePurchase(beneficiary, weiAmount);
359      *   require(weiRaised().add(weiAmount) <= cap);
360      * @param beneficiary Address performing the token purchase
361      * @param weiAmount Value in wei involved in the purchase
362      */
363     function _preValidatePurchase(
364         address beneficiary,
365         uint256 weiAmount
366     )
367     internal
368     view
369     {
370         require(beneficiary != address(0));
371         require(weiAmount != 0);
372     }
373 
374     /**
375      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
376      * @param beneficiary Address performing the token purchase
377      * @param weiAmount Value in wei involved in the purchase
378      */
379     function _postValidatePurchase(
380         address beneficiary,
381         uint256 weiAmount
382     )
383     internal
384     view
385     {
386         // optional override
387     }
388 
389     /**
390      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
391      * @param beneficiary Address performing the token purchase
392      * @param tokenAmount Number of tokens to be emitted
393      */
394     function _deliverTokens(
395         address beneficiary,
396         uint256 tokenAmount
397     )
398     internal
399     {
400         _token.safeTransfer(beneficiary, tokenAmount);
401     }
402 
403     /**
404      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
405      * @param beneficiary Address receiving the tokens
406      * @param tokenAmount Number of tokens to be purchased
407      */
408     function _processPurchase(
409         address beneficiary,
410         uint256 tokenAmount
411     )
412     internal
413     {
414         _deliverTokens(beneficiary, tokenAmount);
415     }
416 
417     /**
418      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
419      * @param beneficiary Address receiving the tokens
420      * @param weiAmount Value in wei involved in the purchase
421      */
422     function _updatePurchasingState(
423         address beneficiary,
424         uint256 weiAmount
425     )
426     internal
427     {
428         // optional override
429     }
430 
431     /**
432      * @dev Override to extend the way in which ether is converted to tokens.
433      * @param weiAmount Value in wei to be converted into tokens
434      * @return Number of tokens that can be purchased with the specified _weiAmount
435      */
436     function _getTokenAmount(uint256 weiAmount)
437     internal view returns (uint256)
438     {
439         return weiAmount.mul(_rate);
440     }
441 
442     /**
443      * @dev Determines how ETH is stored/forwarded on purchases.
444      */
445     function _forwardFunds() internal {
446         _wallet.transfer(msg.value);
447     }
448 }
449 
450 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
451 
452 /**
453  * @title CappedCrowdsale
454  * @dev Crowdsale with a limit for total contributions.
455  */
456 contract CappedCrowdsale is Crowdsale {
457     using SafeMath for uint256;
458 
459     uint256 private _cap;
460 
461     /**
462      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
463      * @param cap Max amount of wei to be contributed
464      */
465     constructor(uint256 cap) internal {
466         require(cap > 0);
467         _cap = cap;
468     }
469 
470     /**
471      * @return the cap of the crowdsale.
472      */
473     function cap() public view returns(uint256) {
474         return _cap;
475     }
476 
477     /**
478      * @dev Checks whether the cap has been reached.
479      * @return Whether the cap was reached
480      */
481     function capReached() public view returns (bool) {
482         return weiRaised() >= _cap;
483     }
484 
485     /**
486      * @dev Extend parent behavior requiring purchase to respect the funding cap.
487      * @param beneficiary Token purchaser
488      * @param weiAmount Amount of wei contributed
489      */
490     function _preValidatePurchase(
491         address beneficiary,
492         uint256 weiAmount
493     )
494     internal
495     view
496     {
497         super._preValidatePurchase(beneficiary, weiAmount);
498         require(weiRaised().add(weiAmount) <= _cap);
499     }
500 
501 }
502 
503 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
504 
505 /**
506  * @title TimedCrowdsale
507  * @dev Crowdsale accepting contributions only within a time frame.
508  */
509 contract TimedCrowdsale is Crowdsale {
510     using SafeMath for uint256;
511 
512     uint256 private _openingTime;
513     uint256 private _closingTime;
514 
515     /**
516      * @dev Reverts if not in crowdsale time range.
517      */
518     modifier onlyWhileOpen {
519         require(isOpen());
520         _;
521     }
522 
523     /**
524      * @dev Constructor, takes crowdsale opening and closing times.
525      * @param openingTime Crowdsale opening time
526      * @param closingTime Crowdsale closing time
527      */
528     constructor(uint256 openingTime, uint256 closingTime) internal {
529         // solium-disable-next-line security/no-block-members
530         require(openingTime >= block.timestamp);
531         require(closingTime > openingTime);
532 
533         _openingTime = openingTime;
534         _closingTime = closingTime;
535     }
536 
537     /**
538      * @return the crowdsale opening time.
539      */
540     function openingTime() public view returns(uint256) {
541         return _openingTime;
542     }
543 
544     /**
545      * @return the crowdsale closing time.
546      */
547     function closingTime() public view returns(uint256) {
548         return _closingTime;
549     }
550 
551     /**
552      * @return true if the crowdsale is open, false otherwise.
553      */
554     function isOpen() public view returns (bool) {
555         // solium-disable-next-line security/no-block-members
556         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
557     }
558 
559     /**
560      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
561      * @return Whether crowdsale period has elapsed
562      */
563     function hasClosed() public view returns (bool) {
564         // solium-disable-next-line security/no-block-members
565         return block.timestamp > _closingTime;
566     }
567 
568     /**
569      * @dev Extend parent behavior requiring to be within contributing period
570      * @param beneficiary Token purchaser
571      * @param weiAmount Amount of wei contributed
572      */
573     function _preValidatePurchase(
574         address beneficiary,
575         uint256 weiAmount
576     )
577     internal
578     onlyWhileOpen
579     view
580     {
581         super._preValidatePurchase(beneficiary, weiAmount);
582     }
583 
584 }
585 
586 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
587 
588 /**
589  * @title FinalizableCrowdsale
590  * @dev Extension of Crowdsale with a one-off finalization action, where one
591  * can do extra work after finishing.
592  */
593 contract FinalizableCrowdsale is TimedCrowdsale {
594     using SafeMath for uint256;
595 
596     bool private _finalized;
597 
598     event CrowdsaleFinalized();
599 
600     constructor() internal {
601         _finalized = false;
602     }
603 
604     /**
605      * @return true if the crowdsale is finalized, false otherwise.
606      */
607     function finalized() public view returns (bool) {
608         return _finalized;
609     }
610 
611     /**
612      * @dev Must be called after crowdsale ends, to do some extra finalization
613      * work. Calls the contract's finalization function.
614      */
615     function finalize() public {
616         require(!_finalized);
617         require(hasClosed());
618 
619         _finalized = true;
620 
621         _finalization();
622         emit CrowdsaleFinalized();
623     }
624 
625     /**
626      * @dev Can be overridden to add finalization logic. The overriding function
627      * should call super._finalization() to ensure the chain of finalization is
628      * executed entirely.
629      */
630     function _finalization() internal {
631     }
632 }
633 
634 // File: openzeppelin-solidity/contracts/ownership/Secondary.sol
635 
636 /**
637  * @title Secondary
638  * @dev A Secondary contract can only be used by its primary account (the one that created it)
639  */
640 contract Secondary {
641     address private _primary;
642 
643     event PrimaryTransferred(
644         address recipient
645     );
646 
647     /**
648      * @dev Sets the primary account to the one that is creating the Secondary contract.
649      */
650     constructor() internal {
651         _primary = msg.sender;
652         emit PrimaryTransferred(_primary);
653     }
654 
655     /**
656      * @dev Reverts if called from any account other than the primary.
657      */
658     modifier onlyPrimary() {
659         require(msg.sender == _primary);
660         _;
661     }
662 
663     /**
664      * @return the address of the primary.
665      */
666     function primary() public view returns (address) {
667         return _primary;
668     }
669 
670     /**
671      * @dev Transfers contract to a new primary.
672      * @param recipient The address of new primary.
673      */
674     function transferPrimary(address recipient) public onlyPrimary {
675         require(recipient != address(0));
676         _primary = recipient;
677         emit PrimaryTransferred(_primary);
678     }
679 }
680 
681 // File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
682 
683 /**
684  * @title Escrow
685  * @dev Base escrow contract, holds funds designated for a payee until they
686  * withdraw them.
687  * @dev Intended usage: This contract (and derived escrow contracts) should be a
688  * standalone contract, that only interacts with the contract that instantiated
689  * it. That way, it is guaranteed that all Ether will be handled according to
690  * the Escrow rules, and there is no need to check for payable functions or
691  * transfers in the inheritance tree. The contract that uses the escrow as its
692  * payment method should be its primary, and provide public methods redirecting
693  * to the escrow's deposit and withdraw.
694  */
695 contract Escrow is Secondary {
696     using SafeMath for uint256;
697 
698     event Deposited(address indexed payee, uint256 weiAmount);
699     event Withdrawn(address indexed payee, uint256 weiAmount);
700 
701     mapping(address => uint256) private _deposits;
702 
703     function depositsOf(address payee) public view returns (uint256) {
704         return _deposits[payee];
705     }
706 
707     /**
708     * @dev Stores the sent amount as credit to be withdrawn.
709     * @param payee The destination address of the funds.
710     */
711     function deposit(address payee) public onlyPrimary payable {
712         uint256 amount = msg.value;
713         _deposits[payee] = _deposits[payee].add(amount);
714 
715         emit Deposited(payee, amount);
716     }
717 
718     /**
719     * @dev Withdraw accumulated balance for a payee.
720     * @param payee The address whose funds will be withdrawn and transferred to.
721     */
722     function withdraw(address payee) public onlyPrimary {
723         uint256 payment = _deposits[payee];
724 
725         _deposits[payee] = 0;
726 
727         payee.transfer(payment);
728 
729         emit Withdrawn(payee, payment);
730     }
731 }
732 
733 // File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
734 
735 /**
736  * @title ConditionalEscrow
737  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
738  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
739  */
740 contract ConditionalEscrow is Escrow {
741     /**
742     * @dev Returns whether an address is allowed to withdraw their funds. To be
743     * implemented by derived contracts.
744     * @param payee The destination address of the funds.
745     */
746     function withdrawalAllowed(address payee) public view returns (bool);
747 
748     function withdraw(address payee) public {
749         require(withdrawalAllowed(payee));
750         super.withdraw(payee);
751     }
752 }
753 
754 // File: openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol
755 
756 /**
757  * @title RefundEscrow
758  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
759  * parties.
760  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
761  * @dev The primary account (that is, the contract that instantiates this
762  * contract) may deposit, close the deposit period, and allow for either
763  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
764  * with RefundEscrow will be made through the primary contract. See the
765  * RefundableCrowdsale contract for an example of RefundEscrow’s use.
766  */
767 contract RefundEscrow is ConditionalEscrow {
768     enum State { Active, Refunding, Closed }
769 
770     event RefundsClosed();
771     event RefundsEnabled();
772 
773     State private _state;
774     address private _beneficiary;
775 
776     /**
777      * @dev Constructor.
778      * @param beneficiary The beneficiary of the deposits.
779      */
780     constructor(address beneficiary) public {
781         require(beneficiary != address(0));
782         _beneficiary = beneficiary;
783         _state = State.Active;
784     }
785 
786     /**
787      * @return the current state of the escrow.
788      */
789     function state() public view returns (State) {
790         return _state;
791     }
792 
793     /**
794      * @return the beneficiary of the escrow.
795      */
796     function beneficiary() public view returns (address) {
797         return _beneficiary;
798     }
799 
800     /**
801      * @dev Stores funds that may later be refunded.
802      * @param refundee The address funds will be sent to if a refund occurs.
803      */
804     function deposit(address refundee) public payable {
805         require(_state == State.Active);
806         super.deposit(refundee);
807     }
808 
809     /**
810      * @dev Allows for the beneficiary to withdraw their funds, rejecting
811      * further deposits.
812      */
813     function close() public onlyPrimary {
814         require(_state == State.Active);
815         _state = State.Closed;
816         emit RefundsClosed();
817     }
818 
819     /**
820      * @dev Allows for refunds to take place, rejecting further deposits.
821      */
822     function enableRefunds() public onlyPrimary {
823         require(_state == State.Active);
824         _state = State.Refunding;
825         emit RefundsEnabled();
826     }
827 
828     /**
829      * @dev Withdraws the beneficiary's funds.
830      */
831     function beneficiaryWithdraw() public {
832         require(_state == State.Closed);
833         _beneficiary.transfer(address(this).balance);
834     }
835 
836     /**
837      * @dev Returns whether refundees can withdraw their deposits (be refunded).
838      */
839     function withdrawalAllowed(address payee) public view returns (bool) {
840         return _state == State.Refunding;
841     }
842 }
843 
844 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
845 
846 /**
847  * @title RefundableCrowdsale
848  * @dev Extension of Crowdsale contract that adds a funding goal, and
849  * the possibility of users getting a refund if goal is not met.
850  * WARNING: note that if you allow tokens to be traded before the goal
851  * is met, then an attack is possible in which the attacker purchases
852  * tokens from the crowdsale and when they sees that the goal is
853  * unlikely to be met, they sell their tokens (possibly at a discount).
854  * The attacker will be refunded when the crowdsale is finalized, and
855  * the users that purchased from them will be left with worthless
856  * tokens. There are many possible ways to avoid this, like making the
857  * the crowdsale inherit from PostDeliveryCrowdsale, or imposing
858  * restrictions on token trading until the crowdsale is finalized.
859  * This is being discussed in
860  * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/877
861  * This contract will be updated when we agree on a general solution
862  * for this problem.
863  */
864 contract RefundableCrowdsale is FinalizableCrowdsale {
865     using SafeMath for uint256;
866 
867     // minimum amount of funds to be raised in weis
868     uint256 private _goal;
869 
870     // refund escrow used to hold funds while crowdsale is running
871     RefundEscrow private _escrow;
872 
873     /**
874      * @dev Constructor, creates RefundEscrow.
875      * @param goal Funding goal
876      */
877     constructor(uint256 goal) internal {
878         require(goal > 0);
879         _escrow = new RefundEscrow(wallet());
880         _goal = goal;
881     }
882 
883     /**
884      * @return minimum amount of funds to be raised in wei.
885      */
886     function goal() public view returns(uint256) {
887         return _goal;
888     }
889 
890     /**
891      * @dev Investors can claim refunds here if crowdsale is unsuccessful
892      * @param beneficiary Whose refund will be claimed.
893      */
894     function claimRefund(address beneficiary) public {
895         require(finalized());
896         require(!goalReached());
897 
898         _escrow.withdraw(beneficiary);
899     }
900 
901     /**
902      * @dev Checks whether funding goal was reached.
903      * @return Whether funding goal was reached
904      */
905     function goalReached() public view returns (bool) {
906         return weiRaised() >= _goal;
907     }
908 
909     /**
910      * @dev escrow finalization task, called when finalize() is called
911      */
912     function _finalization() internal {
913         if (goalReached()) {
914             _escrow.close();
915             _escrow.beneficiaryWithdraw();
916         } else {
917             _escrow.enableRefunds();
918         }
919 
920         super._finalization();
921     }
922 
923     /**
924      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
925      */
926     function _forwardFunds() internal {
927         _escrow.deposit.value(msg.value)(msg.sender);
928     }
929 
930 }
931 
932 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
933 
934 /**
935  * @title Standard ERC20 token
936  *
937  * @dev Implementation of the basic standard token.
938  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
939  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
940  */
941 contract ERC20 is IERC20 {
942     using SafeMath for uint256;
943 
944     mapping (address => uint256) private _balances;
945 
946     mapping (address => mapping (address => uint256)) private _allowed;
947 
948     uint256 private _totalSupply;
949 
950     /**
951     * @dev Total number of tokens in existence
952     */
953     function totalSupply() public view returns (uint256) {
954         return _totalSupply;
955     }
956 
957     /**
958     * @dev Gets the balance of the specified address.
959     * @param owner The address to query the balance of.
960     * @return An uint256 representing the amount owned by the passed address.
961     */
962     function balanceOf(address owner) public view returns (uint256) {
963         return _balances[owner];
964     }
965 
966     /**
967      * @dev Function to check the amount of tokens that an owner allowed to a spender.
968      * @param owner address The address which owns the funds.
969      * @param spender address The address which will spend the funds.
970      * @return A uint256 specifying the amount of tokens still available for the spender.
971      */
972     function allowance(
973         address owner,
974         address spender
975     )
976     public
977     view
978     returns (uint256)
979     {
980         return _allowed[owner][spender];
981     }
982 
983     /**
984     * @dev Transfer token for a specified address
985     * @param to The address to transfer to.
986     * @param value The amount to be transferred.
987     */
988     function transfer(address to, uint256 value) public returns (bool) {
989         _transfer(msg.sender, to, value);
990         return true;
991     }
992 
993     /**
994      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
995      * Beware that changing an allowance with this method brings the risk that someone may use both the old
996      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
997      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
998      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
999      * @param spender The address which will spend the funds.
1000      * @param value The amount of tokens to be spent.
1001      */
1002     function approve(address spender, uint256 value) public returns (bool) {
1003         require(spender != address(0));
1004 
1005         _allowed[msg.sender][spender] = value;
1006         emit Approval(msg.sender, spender, value);
1007         return true;
1008     }
1009 
1010     /**
1011      * @dev Transfer tokens from one address to another
1012      * @param from address The address which you want to send tokens from
1013      * @param to address The address which you want to transfer to
1014      * @param value uint256 the amount of tokens to be transferred
1015      */
1016     function transferFrom(
1017         address from,
1018         address to,
1019         uint256 value
1020     )
1021     public
1022     returns (bool)
1023     {
1024         require(value <= _allowed[from][msg.sender]);
1025 
1026         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
1027         _transfer(from, to, value);
1028         return true;
1029     }
1030 
1031     /**
1032      * @dev Increase the amount of tokens that an owner allowed to a spender.
1033      * approve should be called when allowed_[_spender] == 0. To increment
1034      * allowed value is better to use this function to avoid 2 calls (and wait until
1035      * the first transaction is mined)
1036      * From MonolithDAO Token.sol
1037      * @param spender The address which will spend the funds.
1038      * @param addedValue The amount of tokens to increase the allowance by.
1039      */
1040     function increaseAllowance(
1041         address spender,
1042         uint256 addedValue
1043     )
1044     public
1045     returns (bool)
1046     {
1047         require(spender != address(0));
1048 
1049         _allowed[msg.sender][spender] = (
1050         _allowed[msg.sender][spender].add(addedValue));
1051         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1052         return true;
1053     }
1054 
1055     /**
1056      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1057      * approve should be called when allowed_[_spender] == 0. To decrement
1058      * allowed value is better to use this function to avoid 2 calls (and wait until
1059      * the first transaction is mined)
1060      * From MonolithDAO Token.sol
1061      * @param spender The address which will spend the funds.
1062      * @param subtractedValue The amount of tokens to decrease the allowance by.
1063      */
1064     function decreaseAllowance(
1065         address spender,
1066         uint256 subtractedValue
1067     )
1068     public
1069     returns (bool)
1070     {
1071         require(spender != address(0));
1072 
1073         _allowed[msg.sender][spender] = (
1074         _allowed[msg.sender][spender].sub(subtractedValue));
1075         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1076         return true;
1077     }
1078 
1079     /**
1080     * @dev Transfer token for a specified addresses
1081     * @param from The address to transfer from.
1082     * @param to The address to transfer to.
1083     * @param value The amount to be transferred.
1084     */
1085     function _transfer(address from, address to, uint256 value) internal {
1086         require(value <= _balances[from]);
1087         require(to != address(0));
1088 
1089         _balances[from] = _balances[from].sub(value);
1090         _balances[to] = _balances[to].add(value);
1091         emit Transfer(from, to, value);
1092     }
1093 
1094     /**
1095      * @dev Internal function that mints an amount of the token and assigns it to
1096      * an account. This encapsulates the modification of balances such that the
1097      * proper events are emitted.
1098      * @param account The account that will receive the created tokens.
1099      * @param value The amount that will be created.
1100      */
1101     function _mint(address account, uint256 value) internal {
1102         require(account != 0);
1103         _totalSupply = _totalSupply.add(value);
1104         _balances[account] = _balances[account].add(value);
1105         emit Transfer(address(0), account, value);
1106     }
1107 
1108     /**
1109      * @dev Internal function that burns an amount of the token of a given
1110      * account.
1111      * @param account The account whose tokens will be burnt.
1112      * @param value The amount that will be burnt.
1113      */
1114     function _burn(address account, uint256 value) internal {
1115         require(account != 0);
1116         require(value <= _balances[account]);
1117 
1118         _totalSupply = _totalSupply.sub(value);
1119         _balances[account] = _balances[account].sub(value);
1120         emit Transfer(account, address(0), value);
1121     }
1122 
1123     /**
1124      * @dev Internal function that burns an amount of the token of a given
1125      * account, deducting from the sender's allowance for said account. Uses the
1126      * internal burn function.
1127      * @param account The account whose tokens will be burnt.
1128      * @param value The amount that will be burnt.
1129      */
1130     function _burnFrom(address account, uint256 value) internal {
1131         require(value <= _allowed[account][msg.sender]);
1132 
1133         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
1134         // this function needs to emit an event with the updated approval.
1135         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
1136             value);
1137         _burn(account, value);
1138     }
1139 }
1140 
1141 // File: openzeppelin-solidity/contracts/access/Roles.sol
1142 
1143 /**
1144  * @title Roles
1145  * @dev Library for managing addresses assigned to a Role.
1146  */
1147 library Roles {
1148     struct Role {
1149         mapping (address => bool) bearer;
1150     }
1151 
1152     /**
1153      * @dev give an account access to this role
1154      */
1155     function add(Role storage role, address account) internal {
1156         require(account != address(0));
1157         require(!has(role, account));
1158 
1159         role.bearer[account] = true;
1160     }
1161 
1162     /**
1163      * @dev remove an account's access to this role
1164      */
1165     function remove(Role storage role, address account) internal {
1166         require(account != address(0));
1167         require(has(role, account));
1168 
1169         role.bearer[account] = false;
1170     }
1171 
1172     /**
1173      * @dev check if an account has this role
1174      * @return bool
1175      */
1176     function has(Role storage role, address account)
1177     internal
1178     view
1179     returns (bool)
1180     {
1181         require(account != address(0));
1182         return role.bearer[account];
1183     }
1184 }
1185 
1186 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1187 
1188 contract MinterRole {
1189     using Roles for Roles.Role;
1190 
1191     event MinterAdded(address indexed account);
1192     event MinterRemoved(address indexed account);
1193 
1194     Roles.Role private minters;
1195 
1196     constructor() internal {
1197         _addMinter(msg.sender);
1198     }
1199 
1200     modifier onlyMinter() {
1201         require(isMinter(msg.sender));
1202         _;
1203     }
1204 
1205     function isMinter(address account) public view returns (bool) {
1206         return minters.has(account);
1207     }
1208 
1209     function addMinter(address account) public onlyMinter {
1210         _addMinter(account);
1211     }
1212 
1213     function renounceMinter() public {
1214         _removeMinter(msg.sender);
1215     }
1216 
1217     function _addMinter(address account) internal {
1218         minters.add(account);
1219         emit MinterAdded(account);
1220     }
1221 
1222     function _removeMinter(address account) internal {
1223         minters.remove(account);
1224         emit MinterRemoved(account);
1225     }
1226 }
1227 
1228 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
1229 
1230 /**
1231  * @title ERC20Mintable
1232  * @dev ERC20 minting logic
1233  */
1234 contract ERC20Mintable is ERC20, MinterRole {
1235     /**
1236      * @dev Function to mint tokens
1237      * @param to The address that will receive the minted tokens.
1238      * @param value The amount of tokens to mint.
1239      * @return A boolean that indicates if the operation was successful.
1240      */
1241     function mint(
1242         address to,
1243         uint256 value
1244     )
1245     public
1246     onlyMinter
1247     returns (bool)
1248     {
1249         _mint(to, value);
1250         return true;
1251     }
1252 }
1253 
1254 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
1255 
1256 /**
1257  * @title MintedCrowdsale
1258  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1259  * Token ownership should be transferred to MintedCrowdsale for minting.
1260  */
1261 contract MintedCrowdsale is Crowdsale {
1262     constructor() internal {}
1263 
1264     /**
1265      * @dev Overrides delivery by minting tokens upon purchase.
1266      * @param beneficiary Token purchaser
1267      * @param tokenAmount Number of tokens to be minted
1268      */
1269     function _deliverTokens(
1270         address beneficiary,
1271         uint256 tokenAmount
1272     )
1273     internal
1274     {
1275         // Potentially dangerous assumption about the type of the token.
1276         require(
1277             ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
1278     }
1279 }
1280 
1281 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
1282 
1283 /**
1284  * @title Capped token
1285  * @dev Mintable token with a token cap.
1286  */
1287 contract ERC20Capped is ERC20Mintable {
1288 
1289     uint256 private _cap;
1290 
1291     constructor(uint256 cap)
1292     public
1293     {
1294         require(cap > 0);
1295         _cap = cap;
1296     }
1297 
1298     /**
1299      * @return the cap for the token minting.
1300      */
1301     function cap() public view returns(uint256) {
1302         return _cap;
1303     }
1304 
1305     function _mint(address account, uint256 value) internal {
1306         require(totalSupply().add(value) <= _cap);
1307         super._mint(account, value);
1308     }
1309 }
1310 
1311 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
1312 
1313 /**
1314  * @title Burnable Token
1315  * @dev Token that can be irreversibly burned (destroyed).
1316  */
1317 contract ERC20Burnable is ERC20 {
1318 
1319     /**
1320      * @dev Burns a specific amount of tokens.
1321      * @param value The amount of token to be burned.
1322      */
1323     function burn(uint256 value) public {
1324         _burn(msg.sender, value);
1325     }
1326 
1327     /**
1328      * @dev Burns a specific amount of tokens from the target address and decrements allowance
1329      * @param from address The address which you want to send tokens from
1330      * @param value uint256 The amount of token to be burned
1331      */
1332     function burnFrom(address from, uint256 value) public {
1333         _burnFrom(from, value);
1334     }
1335 }
1336 
1337 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1338 
1339 /**
1340  * @title ERC20Detailed token
1341  * @dev The decimals are only for visualization purposes.
1342  * All the operations are done using the smallest and indivisible token unit,
1343  * just as on Ethereum all the operations are done in wei.
1344  */
1345 contract ERC20Detailed is IERC20 {
1346     string private _name;
1347     string private _symbol;
1348     uint8 private _decimals;
1349 
1350     constructor(string name, string symbol, uint8 decimals) public {
1351         _name = name;
1352         _symbol = symbol;
1353         _decimals = decimals;
1354     }
1355 
1356     /**
1357      * @return the name of the token.
1358      */
1359     function name() public view returns(string) {
1360         return _name;
1361     }
1362 
1363     /**
1364      * @return the symbol of the token.
1365      */
1366     function symbol() public view returns(string) {
1367         return _symbol;
1368     }
1369 
1370     /**
1371      * @return the number of decimals of the token.
1372      */
1373     function decimals() public view returns(uint8) {
1374         return _decimals;
1375     }
1376 }
1377 
1378 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
1379 
1380 contract PauserRole {
1381     using Roles for Roles.Role;
1382 
1383     event PauserAdded(address indexed account);
1384     event PauserRemoved(address indexed account);
1385 
1386     Roles.Role private pausers;
1387 
1388     constructor() internal {
1389         _addPauser(msg.sender);
1390     }
1391 
1392     modifier onlyPauser() {
1393         require(isPauser(msg.sender));
1394         _;
1395     }
1396 
1397     function isPauser(address account) public view returns (bool) {
1398         return pausers.has(account);
1399     }
1400 
1401     function addPauser(address account) public onlyPauser {
1402         _addPauser(account);
1403     }
1404 
1405     function renouncePauser() public {
1406         _removePauser(msg.sender);
1407     }
1408 
1409     function _addPauser(address account) internal {
1410         pausers.add(account);
1411         emit PauserAdded(account);
1412     }
1413 
1414     function _removePauser(address account) internal {
1415         pausers.remove(account);
1416         emit PauserRemoved(account);
1417     }
1418 }
1419 
1420 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
1421 
1422 /**
1423  * @title Pausable
1424  * @dev Base contract which allows children to implement an emergency stop mechanism.
1425  */
1426 contract Pausable is PauserRole {
1427     event Paused(address account);
1428     event Unpaused(address account);
1429 
1430     bool private _paused;
1431 
1432     constructor() internal {
1433         _paused = false;
1434     }
1435 
1436     /**
1437      * @return true if the contract is paused, false otherwise.
1438      */
1439     function paused() public view returns(bool) {
1440         return _paused;
1441     }
1442 
1443     /**
1444      * @dev Modifier to make a function callable only when the contract is not paused.
1445      */
1446     modifier whenNotPaused() {
1447         require(!_paused);
1448         _;
1449     }
1450 
1451     /**
1452      * @dev Modifier to make a function callable only when the contract is paused.
1453      */
1454     modifier whenPaused() {
1455         require(_paused);
1456         _;
1457     }
1458 
1459     /**
1460      * @dev called by the owner to pause, triggers stopped state
1461      */
1462     function pause() public onlyPauser whenNotPaused {
1463         _paused = true;
1464         emit Paused(msg.sender);
1465     }
1466 
1467     /**
1468      * @dev called by the owner to unpause, returns to normal state
1469      */
1470     function unpause() public onlyPauser whenPaused {
1471         _paused = false;
1472         emit Unpaused(msg.sender);
1473     }
1474 }
1475 
1476 // File: contracts\MysteriousSound.sol
1477 contract MysteriousSound is ERC20Mintable, ERC20Detailed,  Pausable {
1478 
1479     // define initial coin supply here
1480     uint256 public constant INITIAL_SUPPLY = 6000000000 * (10 ** uint256(decimals()));
1481 
1482     /**
1483      * @dev Constructor that gives msg.sender all of existing tokens.
1484      */
1485     constructor () public ERC20Detailed("MysteriousSound", "MST", 18) {
1486         _mint(msg.sender, INITIAL_SUPPLY);
1487     }
1488 
1489     /**
1490      * @dev Burns a specific amount of tokens.
1491      * @param value The amount of token to be burned.
1492      */
1493     function burn(uint256 value) public {
1494         _burn(msg.sender, value);
1495     }
1496 
1497     /**
1498      * @dev Burns a specific amount of tokens from the target address and decrements allowance
1499      * @param from address The address which you want to send tokens from
1500      * @param value uint256 The amount of token to be burned
1501      */
1502     function burnFrom(address from, uint256 value) public {
1503         _burnFrom(from, value);
1504     }
1505 
1506     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
1507         return super.transfer(to, value);
1508     }
1509 
1510     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
1511         return super.transferFrom(from, to, value);
1512     }
1513 
1514     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
1515         return super.approve(spender, value);
1516     }
1517 
1518     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
1519         return super.increaseAllowance(spender, addedValue);
1520     }
1521 
1522     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
1523         return super.decreaseAllowance(spender, subtractedValue);
1524     }
1525 
1526 }