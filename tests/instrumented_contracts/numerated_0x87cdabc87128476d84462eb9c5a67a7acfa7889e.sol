1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     c = _a * _b;
58     assert(c / _a == _b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     // assert(_b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = _a / _b;
68     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69     return _a / _b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     assert(_b <= _a);
77     return _a - _b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     c = _a + _b;
85     assert(c >= _a);
86     return c;
87   }
88 }
89 
90 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
91 
92 /**
93  * @title Ownable
94  * @dev The Ownable contract has an owner address, and provides basic authorization control
95  * functions, this simplifies the implementation of "user permissions".
96  */
97 contract Ownable {
98   address public owner;
99 
100 
101   event OwnershipRenounced(address indexed previousOwner);
102   event OwnershipTransferred(
103     address indexed previousOwner,
104     address indexed newOwner
105   );
106 
107 
108   /**
109    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
110    * account.
111    */
112   constructor() public {
113     owner = msg.sender;
114   }
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(msg.sender == owner);
121     _;
122   }
123 
124   /**
125    * @dev Allows the current owner to relinquish control of the contract.
126    * @notice Renouncing to ownership will leave the contract without an owner.
127    * It will not be possible to call the functions with the `onlyOwner`
128    * modifier anymore.
129    */
130   function renounceOwnership() public onlyOwner {
131     emit OwnershipRenounced(owner);
132     owner = address(0);
133   }
134 
135   /**
136    * @dev Allows the current owner to transfer control of the contract to a newOwner.
137    * @param _newOwner The address to transfer ownership to.
138    */
139   function transferOwnership(address _newOwner) public onlyOwner {
140     _transferOwnership(_newOwner);
141   }
142 
143   /**
144    * @dev Transfers control of the contract to a newOwner.
145    * @param _newOwner The address to transfer ownership to.
146    */
147   function _transferOwnership(address _newOwner) internal {
148     require(_newOwner != address(0));
149     emit OwnershipTransferred(owner, _newOwner);
150     owner = _newOwner;
151   }
152 }
153 
154 // File: openzeppelin-solidity/contracts/payment/Escrow.sol
155 
156 /**
157  * @title Escrow
158  * @dev Base escrow contract, holds funds destinated to a payee until they
159  * withdraw them. The contract that uses the escrow as its payment method
160  * should be its owner, and provide public methods redirecting to the escrow's
161  * deposit and withdraw.
162  */
163 contract Escrow is Ownable {
164   using SafeMath for uint256;
165 
166   event Deposited(address indexed payee, uint256 weiAmount);
167   event Withdrawn(address indexed payee, uint256 weiAmount);
168 
169   mapping(address => uint256) private deposits;
170 
171   function depositsOf(address _payee) public view returns (uint256) {
172     return deposits[_payee];
173   }
174 
175   /**
176   * @dev Stores the sent amount as credit to be withdrawn.
177   * @param _payee The destination address of the funds.
178   */
179   function deposit(address _payee) public onlyOwner payable {
180     uint256 amount = msg.value;
181     deposits[_payee] = deposits[_payee].add(amount);
182 
183     emit Deposited(_payee, amount);
184   }
185 
186   /**
187   * @dev Withdraw accumulated balance for a payee.
188   * @param _payee The address whose funds will be withdrawn and transferred to.
189   */
190   function withdraw(address _payee) public onlyOwner {
191     uint256 payment = deposits[_payee];
192     assert(address(this).balance >= payment);
193 
194     deposits[_payee] = 0;
195 
196     _payee.transfer(payment);
197 
198     emit Withdrawn(_payee, payment);
199   }
200 }
201 
202 // File: openzeppelin-solidity/contracts/payment/ConditionalEscrow.sol
203 
204 /**
205  * @title ConditionalEscrow
206  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
207  */
208 contract ConditionalEscrow is Escrow {
209   /**
210   * @dev Returns whether an address is allowed to withdraw their funds. To be
211   * implemented by derived contracts.
212   * @param _payee The destination address of the funds.
213   */
214   function withdrawalAllowed(address _payee) public view returns (bool);
215 
216   function withdraw(address _payee) public {
217     require(withdrawalAllowed(_payee));
218     super.withdraw(_payee);
219   }
220 }
221 
222 // File: openzeppelin-solidity/contracts/payment/RefundEscrow.sol
223 
224 /**
225  * @title RefundEscrow
226  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
227  * The contract owner may close the deposit period, and allow for either withdrawal
228  * by the beneficiary, or refunds to the depositors.
229  */
230 contract RefundEscrow is Ownable, ConditionalEscrow {
231   enum State { Active, Refunding, Closed }
232 
233   event Closed();
234   event RefundsEnabled();
235 
236   State public state;
237   address public beneficiary;
238 
239   /**
240    * @dev Constructor.
241    * @param _beneficiary The beneficiary of the deposits.
242    */
243   constructor(address _beneficiary) public {
244     require(_beneficiary != address(0));
245     beneficiary = _beneficiary;
246     state = State.Active;
247   }
248 
249   /**
250    * @dev Stores funds that may later be refunded.
251    * @param _refundee The address funds will be sent to if a refund occurs.
252    */
253   function deposit(address _refundee) public payable {
254     require(state == State.Active);
255     super.deposit(_refundee);
256   }
257 
258   /**
259    * @dev Allows for the beneficiary to withdraw their funds, rejecting
260    * further deposits.
261    */
262   function close() public onlyOwner {
263     require(state == State.Active);
264     state = State.Closed;
265     emit Closed();
266   }
267 
268   /**
269    * @dev Allows for refunds to take place, rejecting further deposits.
270    */
271   function enableRefunds() public onlyOwner {
272     require(state == State.Active);
273     state = State.Refunding;
274     emit RefundsEnabled();
275   }
276 
277   /**
278    * @dev Withdraws the beneficiary's funds.
279    */
280   function beneficiaryWithdraw() public {
281     require(state == State.Closed);
282     beneficiary.transfer(address(this).balance);
283   }
284 
285   /**
286    * @dev Returns whether refundees can withdraw their deposits (be refunded).
287    */
288   function withdrawalAllowed(address _payee) public view returns (bool) {
289     return state == State.Refunding;
290   }
291 }
292 
293 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
294 
295 /**
296  * @title SafeERC20
297  * @dev Wrappers around ERC20 operations that throw on failure.
298  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
299  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
300  */
301 library SafeERC20 {
302   function safeTransfer(
303     ERC20Basic _token,
304     address _to,
305     uint256 _value
306   )
307     internal
308   {
309     require(_token.transfer(_to, _value));
310   }
311 
312   function safeTransferFrom(
313     ERC20 _token,
314     address _from,
315     address _to,
316     uint256 _value
317   )
318     internal
319   {
320     require(_token.transferFrom(_from, _to, _value));
321   }
322 
323   function safeApprove(
324     ERC20 _token,
325     address _spender,
326     uint256 _value
327   )
328     internal
329   {
330     require(_token.approve(_spender, _value));
331   }
332 }
333 
334 // File: contracts/crowdsale/Crowdsale.sol
335 
336 /**
337  * @title Crowdsale
338  * @dev Crowdsale is a base contract for managing a token crowdsale,
339  * allowing investors to purchase tokens with ether. This contract implements
340  * such functionality in its most fundamental form and can be extended to provide additional
341  * functionality and/or custom behavior.
342  * The external interface represents the basic interface for purchasing tokens, and conform
343  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
344  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
345  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
346  * behavior.
347  */
348 contract Crowdsale {
349     using SafeMath for uint256;
350     using SafeERC20 for ERC20;
351 
352     // The token being sold
353     ERC20 public token;
354 
355     // Address where funds are collected
356     address public wallet;
357 
358     // How many token units a buyer gets per wei.
359     // The rate is the conversion between wei and the smallest and indivisible token unit.
360     // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
361     // 1 wei will give you 1 unit, or 0.001 TOK.
362     uint256 public rate;
363 
364     // Amount of wei raised
365     uint256 public weiRaised;
366 
367     // Amount tokens Sold
368     uint256 public tokensSold;
369     
370     /**
371     * Event for token purchase logging
372     * @param purchaser who paid for the tokens
373     * @param beneficiary who got the tokens
374     * @param value weis paid for purchase
375     * @param amount amount of tokens purchased
376     */
377     event TokenPurchase(
378         address indexed purchaser,
379         address indexed beneficiary,
380         uint256 value,
381         uint256 amount
382     );
383 
384     /**
385     * @param _rate Number of token units a buyer gets per wei
386     * @param _wallet Address where collected funds will be forwarded to
387     * @param _token Address of the token being sold
388     */
389     constructor(uint256 _rate, address _wallet, ERC20 _token) public {
390         require(_rate > 0);
391         require(_wallet != address(0));
392         require(_token != address(0));
393 
394         rate = _rate;
395         wallet = _wallet;
396         token = _token;
397     }
398 
399     // -----------------------------------------
400     // Crowdsale external interface
401     // -----------------------------------------
402 
403     /**
404     * @dev fallback function ***DO NOT OVERRIDE***
405     */
406     function () external payable {
407         buyTokens(msg.sender);
408     }
409 
410     /**
411     * @dev low level token purchase ***DO NOT OVERRIDE***
412     * @param _beneficiary Address performing the token purchase
413     */
414     function buyTokens(address _beneficiary) public payable {
415 
416         uint256 weiAmount = msg.value;
417 
418         // calculate token amount to be created
419         uint256 tokens = _getTokenAmount(weiAmount);
420 
421         _preValidatePurchase(_beneficiary, weiAmount, tokens);
422 
423         // update state
424         weiRaised = weiRaised.add(weiAmount);
425         tokensSold = tokensSold.add(tokens);
426 
427         _processPurchase(_beneficiary, tokens);
428         emit TokenPurchase(
429             msg.sender,
430             _beneficiary,
431             weiAmount,
432             tokens
433         );
434 
435         _updatePurchasingState(_beneficiary, weiAmount, tokens);
436 
437         _forwardFunds();
438         _postValidatePurchase(_beneficiary, weiAmount, tokens);
439     }
440 
441     // -----------------------------------------
442     // Internal interface (extensible)
443     // -----------------------------------------
444 
445     /**
446     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
447     * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
448     *   super._preValidatePurchase(_beneficiary, _weiAmount);
449     *   require(weiRaised.add(_weiAmount) <= cap);
450     * @param _beneficiary Address performing the token purchase
451     * @param _weiAmount Value in wei involved in the purchase
452     * @param _tokenAmount Value in token involved in the purchase
453     */
454     function _preValidatePurchase(
455         address _beneficiary,
456         uint256 _weiAmount,
457         uint256 _tokenAmount
458     )
459         internal
460     {
461         require(_beneficiary != address(0));
462         require(_weiAmount != 0);
463     }
464 
465     /**
466     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
467     * @param _beneficiary Address performing the token purchase
468     * @param _weiAmount Value in wei involved in the purchase
469     * @param _tokenAmount Value in token involved in the purchase
470     */
471     function _postValidatePurchase(
472         address _beneficiary,
473         uint256 _weiAmount,
474         uint256 _tokenAmount
475     )
476         internal
477     {
478         // optional override
479     }
480 
481     /**
482     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
483     * @param _beneficiary Address performing the token purchase
484     * @param _tokenAmount Number of tokens to be emitted
485     */
486     function _deliverTokens(
487         address _beneficiary,
488         uint256 _tokenAmount
489     )
490         internal
491     {
492         token.safeTransfer(_beneficiary, _tokenAmount);
493     }
494 
495     /**
496     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
497     * @param _beneficiary Address receiving the tokens
498     * @param _tokenAmount Number of tokens to be purchased
499     */
500     function _processPurchase(
501         address _beneficiary,
502         uint256 _tokenAmount
503     )
504         internal
505     {
506         _deliverTokens(_beneficiary, _tokenAmount);
507     }
508 
509     /**
510     * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
511     * @param _beneficiary Address receiving the tokens
512     * @param _weiAmount Value in wei involved in the purchase
513     * @param _tokenAmount Value in token involved in the purchase
514     */
515     function _updatePurchasingState(
516         address _beneficiary,
517         uint256 _weiAmount,
518         uint256 _tokenAmount
519     )
520         internal
521     {
522         // optional override
523     }
524 
525     /**
526     * @dev Override to extend the way in which ether is converted to tokens.
527     * @param _weiAmount Value in wei to be converted into tokens
528     * @return Number of tokens that can be purchased with the specified _weiAmount
529     */
530     function _getTokenAmount(uint256 _weiAmount)
531         internal view returns (uint256)
532     {
533         return _weiAmount.mul(rate);
534     }
535 
536     /**
537     * @dev Determines how ETH is stored/forwarded on purchases.
538     */
539     function _forwardFunds() internal {
540         wallet.transfer(msg.value);
541     }
542 }
543 
544 // File: contracts/crowdsale/validation/TimedCrowdsale.sol
545 
546 /**
547  * @title TimedCrowdsale
548  * @dev Crowdsale accepting contributions only within a time frame.
549  */
550 contract TimedCrowdsale is Crowdsale {
551     using SafeMath for uint256;
552 
553     uint256 public openingTime;
554     uint256 public closingTime;
555 
556     /**
557     * @dev Reverts if not in crowdsale time range.
558     */
559     modifier onlyWhileOpen {
560         // solium-disable-next-line security/no-block-members
561         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
562         _;
563     }
564 
565     /**
566     * @dev Constructor, takes crowdsale opening and closing times.
567     * @param _openingTime Crowdsale opening time
568     * @param _closingTime Crowdsale closing time
569     */
570     constructor(uint256 _openingTime, uint256 _closingTime) public {
571         // solium-disable-next-line security/no-block-members
572         require(_openingTime >= block.timestamp);
573         require(_closingTime > _openingTime);
574 
575         openingTime = _openingTime;
576         closingTime = _closingTime;
577     }
578 
579     /**
580     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
581     * @return Whether crowdsale period has elapsed
582     */
583     function hasClosed() public view returns (bool) {
584         // solium-disable-next-line security/no-block-members
585         return block.timestamp > closingTime;
586     }
587 
588     /**
589     * @dev Extend parent behavior requiring to be within contributing period
590     * @param _beneficiary Token purchaser
591     * @param _weiAmount Amount of wei contributed
592     * @param _tokenAmount Amount of token purchased
593     */
594     function _preValidatePurchase(
595         address _beneficiary,
596         uint256 _weiAmount,
597         uint256 _tokenAmount
598     )
599         internal
600         onlyWhileOpen
601     {
602         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
603     }
604 
605 }
606 
607 // File: contracts/crowdsale/validation/MilestoneCrowdsale.sol
608 
609 /**
610  * @title MilestoneCrowdsale
611  * @dev Crowdsale with multiple milestones separated by time and cap
612  * @author Nikola Wyatt <nikola.wyatt@foodnation.io>
613  */
614 contract MilestoneCrowdsale is TimedCrowdsale {
615     using SafeMath for uint256;
616 
617     uint256 public constant MAX_MILESTONE = 10;
618 
619     /**
620     * Define pricing schedule using milestones.
621     */
622     struct Milestone {
623 
624         // Milestone index in array
625         uint256 index;
626 
627         // UNIX timestamp when this milestone starts
628         uint256 startTime;
629 
630         // Amount of tokens sold in milestone
631         uint256 tokensSold;
632 
633         // Maximum amount of Tokens accepted in the current Milestone.
634         uint256 cap;
635 
636         // How many tokens per wei you will get after this milestone has been passed
637         uint256 rate;
638 
639     }
640 
641     /**
642     * Store milestones in a fixed array, so that it can be seen in a blockchain explorer
643     * Milestone 0 is always (0, 0)
644     * (TODO: change this when we confirm dynamic arrays are explorable)
645     */
646     Milestone[10] public milestones;
647 
648     // How many active milestones have been created
649     uint256 public milestoneCount = 0;
650 
651 
652     bool public milestoningFinished = false;
653 
654     constructor(        
655         uint256 _openingTime,
656         uint256 _closingTime
657         ) 
658         TimedCrowdsale(_openingTime, _closingTime)
659         public 
660         {
661         }
662 
663     /**
664     * @dev Contruction, setting a list of milestones
665     * @param _milestoneStartTime uint[] milestones start time 
666     * @param _milestoneCap uint[] milestones cap 
667     * @param _milestoneRate uint[] milestones price 
668     */
669     function setMilestonesList(uint256[] _milestoneStartTime, uint256[] _milestoneCap, uint256[] _milestoneRate) public {
670         // Need to have tuples, length check
671         require(!milestoningFinished);
672         require(_milestoneStartTime.length > 0);
673         require(_milestoneStartTime.length == _milestoneCap.length && _milestoneCap.length == _milestoneRate.length);
674         require(_milestoneStartTime[0] == openingTime);
675         require(_milestoneStartTime[_milestoneStartTime.length-1] < closingTime);
676 
677         for (uint iterator = 0; iterator < _milestoneStartTime.length; iterator++) {
678             if (iterator > 0) {
679                 assert(_milestoneStartTime[iterator] > milestones[iterator-1].startTime);
680             }
681             milestones[iterator] = Milestone({
682                 index: iterator,
683                 startTime: _milestoneStartTime[iterator],
684                 tokensSold: 0,
685                 cap: _milestoneCap[iterator],
686                 rate: _milestoneRate[iterator]
687             });
688             milestoneCount++;
689         }
690         milestoningFinished = true;
691     }
692 
693     /**
694     * @dev Iterate through milestones. You reach end of milestones when rate = 0
695     * @return tuple (time, rate)
696     */
697     function getMilestoneTimeAndRate(uint256 n) public view returns (uint256, uint256) {
698         return (milestones[n].startTime, milestones[n].rate);
699     }
700 
701     /**
702     * @dev Checks whether the cap of a milestone has been reached.
703     * @return Whether the cap was reached
704     */
705     function capReached(uint256 n) public view returns (bool) {
706         return milestones[n].tokensSold >= milestones[n].cap;
707     }
708 
709     /**
710     * @dev Checks amount of tokens sold in milestone.
711     * @return Amount of tokens sold in milestone
712     */
713     function getTokensSold(uint256 n) public view returns (uint256) {
714         return milestones[n].tokensSold;
715     }
716 
717     function getFirstMilestone() private view returns (Milestone) {
718         return milestones[0];
719     }
720 
721     function getLastMilestone() private view returns (Milestone) {
722         return milestones[milestoneCount-1];
723     }
724 
725     function getFirstMilestoneStartsAt() public view returns (uint256) {
726         return getFirstMilestone().startTime;
727     }
728 
729     function getLastMilestoneStartsAt() public view returns (uint256) {
730         return getLastMilestone().startTime;
731     }
732 
733     /**
734     * @dev Get the current milestone or bail out if we are not in the milestone periods.
735     * @return {[type]} [description]
736     */
737     function getCurrentMilestoneIndex() internal view onlyWhileOpen returns  (uint256) {
738         uint256 index;
739 
740         // Found the current milestone by evaluating time. 
741         // If (now < next start) the current milestone is the previous
742         // Stops loop if finds current
743         for(uint i = 0; i < milestoneCount; i++) {
744             index = i;
745             // solium-disable-next-line security/no-block-members
746             if(block.timestamp < milestones[i].startTime) {
747                 index = i - 1;
748                 break;
749             }
750         }
751 
752         // For the next code, you may ask why not assert if last milestone surpass cap...
753         // Because if its last and it is capped we would like to finish not sell any more tokens 
754         // Check if the current milestone has reached it's cap
755         if (milestones[index].tokensSold > milestones[index].cap) {
756             index = index + 1;
757         }
758 
759         return index;
760     }
761 
762     /**
763     * @dev Extend parent behavior requiring purchase to respect the funding cap from the currentMilestone.
764     * @param _beneficiary Token purchaser
765     * @param _weiAmount Amount of wei contributed
766     * @param _tokenAmount Amount of token purchased
767     
768     */
769     function _preValidatePurchase(
770         address _beneficiary,
771         uint256 _weiAmount,
772         uint256 _tokenAmount
773     )
774         internal
775     {
776         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
777         require(milestones[getCurrentMilestoneIndex()].tokensSold.add(_tokenAmount) <= milestones[getCurrentMilestoneIndex()].cap);
778     }
779 
780     /**
781     * @dev Extend parent behavior to update current milestone state and index
782     * @param _beneficiary Token purchaser
783     * @param _weiAmount Amount of wei contributed
784     * @param _tokenAmount Amount of token purchased
785     */
786     function _updatePurchasingState(
787         address _beneficiary,
788         uint256 _weiAmount,
789         uint256 _tokenAmount
790     )
791         internal
792     {
793         super._updatePurchasingState(_beneficiary, _weiAmount, _tokenAmount);
794         milestones[getCurrentMilestoneIndex()].tokensSold = milestones[getCurrentMilestoneIndex()].tokensSold.add(_tokenAmount);
795     }
796 
797     /**
798     * @dev Get the current price.
799     * @return The current price or 0 if we are outside milestone period
800     */
801     function getCurrentRate() internal view returns (uint result) {
802         return milestones[getCurrentMilestoneIndex()].rate;
803     }
804 
805     /**
806     * @dev Override to extend the way in which ether is converted to tokens.
807     * @param _weiAmount Value in wei to be converted into tokens
808     * @return Number of tokens that can be purchased with the specified _weiAmount
809     */
810     function _getTokenAmount(uint256 _weiAmount)
811         internal view returns (uint256)
812     {
813         return _weiAmount.mul(getCurrentRate());
814     }
815 
816 }
817 
818 // File: contracts/price/USDPrice.sol
819 
820 /**
821 * @title USDPrice
822 * @dev Contract that calculates the price of tokens in USD cents.
823 * Note that this contracts needs to be updated
824 */
825 contract USDPrice is Ownable {
826 
827     using SafeMath for uint256;
828 
829     // PRICE of 1 ETHER in USD in cents
830     // So, if price is: $271.90, the value in variable will be: 27190
831     uint256 public ETHUSD;
832 
833     // Time of Last Updated Price
834     uint256 public updatedTime;
835 
836     // Historic price of ETH in USD in cents
837     mapping (uint256 => uint256) public priceHistory;
838 
839     event PriceUpdated(uint256 price);
840 
841     constructor() public {
842     }
843 
844     function getHistoricPrice(uint256 time) public view returns (uint256) {
845         return priceHistory[time];
846     } 
847 
848     function updatePrice(uint256 price) public onlyOwner {
849         require(price > 0);
850 
851         priceHistory[updatedTime] = ETHUSD;
852 
853         ETHUSD = price;
854         // solium-disable-next-line security/no-block-members
855         updatedTime = block.timestamp;
856 
857         emit PriceUpdated(ETHUSD);
858     }
859 
860     /**
861     * @dev Override to extend the way in which ether is converted to USD.
862     * @param _weiAmount Value in wei to be converted into tokens
863     * @return The value of wei amount in USD cents
864     */
865     function getPrice(uint256 _weiAmount)
866         public view returns (uint256)
867     {
868         return _weiAmount.mul(ETHUSD);
869     }
870     
871 }
872 
873 // File: contracts/PreSale.sol
874 
875 interface MintableERC20 {
876     function mint(address _to, uint256 _amount) public returns (bool);
877 }
878 /**
879  * @title PreSale
880  * @dev Crowdsale accepting contributions only within a time frame, 
881  * having milestones defined, the price is defined in USD
882  * having a mechanism to refund sales if soft cap not capReached();
883  * And an escrow to support the refund.
884  */
885 contract PreSale is Ownable, Crowdsale, MilestoneCrowdsale {
886     using SafeMath for uint256;
887 
888     /// Max amount of tokens to be contributed
889     uint256 public cap;
890 
891     /// Minimum amount of wei per contribution
892     uint256 public minimumContribution;
893 
894     /// minimum amount of funds to be raised in weis
895     uint256 public goal;
896     
897     bool public isFinalized = false;
898 
899     /// refund escrow used to hold funds while crowdsale is running
900     RefundEscrow private escrow;
901 
902     USDPrice private usdPrice; 
903 
904     event Finalized();
905 
906     constructor(
907         uint256 _rate,
908         address _wallet,
909         ERC20 _token,
910         uint256 _openingTime,
911         uint256 _closingTime,
912         uint256 _goal,
913         uint256 _cap,
914         uint256 _minimumContribution,
915         USDPrice _usdPrice
916     )
917         Crowdsale(_rate, _wallet, _token)
918         MilestoneCrowdsale(_openingTime, _closingTime)
919         public
920     {  
921         require(_cap > 0);
922         require(_minimumContribution > 0);
923         require(_goal > 0);
924         
925         cap = _cap;
926         minimumContribution = _minimumContribution;
927 
928         escrow = new RefundEscrow(wallet);
929         goal = _goal;
930         usdPrice = _usdPrice;
931     }
932 
933 
934     /**
935     * @dev Checks whether the cap has been reached.
936     * @return Whether the cap was reached
937     */
938     function capReached() public view returns (bool) {
939         return tokensSold >= cap;
940     }
941 
942     /**
943     * @dev Investors can claim refunds here if crowdsale is unsuccessful
944     */
945     function claimRefund() public {
946         require(isFinalized);
947         require(!goalReached());
948 
949         escrow.withdraw(msg.sender);
950     }
951 
952     /**
953     * @dev Checks whether funding goal was reached.
954     * @return Whether funding goal was reached
955     */
956     function goalReached() public view returns (bool) {
957         return tokensSold >= goal;
958     }
959 
960     /**
961     * @dev Must be called after crowdsale ends, to do some extra finalization
962     * work. Calls the contract's finalization function.
963     */
964     function finalize() public onlyOwner {
965         require(!isFinalized);
966         require(goalReached() || hasClosed());
967 
968         finalization();
969         emit Finalized();
970 
971         isFinalized = true;
972     }
973 
974     /**
975     * @dev Override to extend the way in which ether is converted to tokens.
976     * @param _weiAmount Value in wei to be converted into tokens
977     * @return Number of tokens that can be purchased with the specified _weiAmount
978     */
979     function _getTokenAmount(uint256 _weiAmount)
980         internal view returns (uint256)
981     {
982         return usdPrice.getPrice(_weiAmount).div(getCurrentRate());
983     }
984 
985     /**
986     * @dev Extend parent behavior sending heartbeat to token.
987     * @param _beneficiary Address receiving the tokens
988     * @param _weiAmount Value in wei involved in the purchase
989     * @param _tokenAmount Value in token involved in the purchase
990     */
991     function _updatePurchasingState(
992         address _beneficiary,
993         uint256 _weiAmount,
994         uint256 _tokenAmount
995     )
996         internal
997     {
998         super._updatePurchasingState(_beneficiary, _weiAmount, _tokenAmount);
999     }
1000     
1001     /**
1002     * @dev Overrides delivery by minting tokens upon purchase. - MINTED Crowdsale
1003     * @param _beneficiary Token purchaser
1004     * @param _tokenAmount Number of tokens to be minted
1005     */
1006     function _deliverTokens(
1007         address _beneficiary,
1008         uint256 _tokenAmount
1009     )
1010         internal
1011     {
1012         // Potentially dangerous assumption about the type of the token.
1013         require(MintableERC20(address(token)).mint(_beneficiary, _tokenAmount));
1014     }
1015 
1016 
1017     /**
1018     * @dev Extend parent behavior requiring purchase to respect the funding cap.
1019     * @param _beneficiary Token purchaser
1020     * @param _weiAmount Amount of wei contributed
1021     * @param _tokenAmount Amount of token purchased
1022     */
1023     function _preValidatePurchase(
1024         address _beneficiary,
1025         uint256 _weiAmount,
1026         uint256 _tokenAmount
1027     )
1028         internal
1029     {
1030         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
1031         require(_weiAmount >= minimumContribution);
1032         require(tokensSold.add(_tokenAmount) <= cap);
1033     }
1034 
1035     /**
1036     * @dev escrow finalization task, called when owner calls finalize()
1037     */
1038     function finalization() internal {
1039         if (goalReached()) {
1040             escrow.close();
1041             escrow.beneficiaryWithdraw();
1042         } else {
1043             escrow.enableRefunds();
1044         }
1045     }
1046 
1047     /**
1048     * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1049     */
1050     function _forwardFunds() internal {
1051         escrow.deposit.value(msg.value)(msg.sender);
1052     }
1053 
1054 }