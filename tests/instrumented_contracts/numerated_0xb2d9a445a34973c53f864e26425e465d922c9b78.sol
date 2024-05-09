1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender)
138     public view returns (uint256);
139 
140   function transferFrom(address from, address to, uint256 value)
141     public returns (bool);
142 
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(
145     address indexed owner,
146     address indexed spender,
147     uint256 value
148   );
149 }
150 
151 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
152 
153 /**
154  * @title Crowdsale
155  * @dev Crowdsale is a base contract for managing a token crowdsale,
156  * allowing investors to purchase tokens with ether. This contract implements
157  * such functionality in its most fundamental form and can be extended to provide additional
158  * functionality and/or custom behavior.
159  * The external interface represents the basic interface for purchasing tokens, and conform
160  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
161  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
162  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
163  * behavior.
164  */
165 contract Crowdsale {
166   using SafeMath for uint256;
167 
168   // The token being sold
169   ERC20 public token;
170 
171   // Address where funds are collected
172   address public wallet;
173 
174   // How many token units a buyer gets per wei.
175   // The rate is the conversion between wei and the smallest and indivisible token unit.
176   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
177   // 1 wei will give you 1 unit, or 0.001 TOK.
178   uint256 public rate;
179 
180   // Amount of wei raised
181   uint256 public weiRaised;
182 
183   /**
184    * Event for token purchase logging
185    * @param purchaser who paid for the tokens
186    * @param beneficiary who got the tokens
187    * @param value weis paid for purchase
188    * @param amount amount of tokens purchased
189    */
190   event TokenPurchase(
191     address indexed purchaser,
192     address indexed beneficiary,
193     uint256 value,
194     uint256 amount
195   );
196 
197   /**
198    * @param _rate Number of token units a buyer gets per wei
199    * @param _wallet Address where collected funds will be forwarded to
200    * @param _token Address of the token being sold
201    */
202   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
203     require(_rate > 0);
204     require(_wallet != address(0));
205     require(_token != address(0));
206 
207     rate = _rate;
208     wallet = _wallet;
209     token = _token;
210   }
211 
212   // -----------------------------------------
213   // Crowdsale external interface
214   // -----------------------------------------
215 
216   /**
217    * @dev fallback function ***DO NOT OVERRIDE***
218    */
219   function () external payable {
220     buyTokens(msg.sender);
221   }
222 
223   /**
224    * @dev low level token purchase ***DO NOT OVERRIDE***
225    * @param _beneficiary Address performing the token purchase
226    */
227   function buyTokens(address _beneficiary) public payable {
228 
229     uint256 weiAmount = msg.value;
230     _preValidatePurchase(_beneficiary, weiAmount);
231 
232     // calculate token amount to be created
233     uint256 tokens = _getTokenAmount(weiAmount);
234 
235     // update state
236     weiRaised = weiRaised.add(weiAmount);
237 
238     _processPurchase(_beneficiary, tokens);
239     emit TokenPurchase(
240       msg.sender,
241       _beneficiary,
242       weiAmount,
243       tokens
244     );
245 
246     _updatePurchasingState(_beneficiary, weiAmount);
247 
248     _forwardFunds();
249     _postValidatePurchase(_beneficiary, weiAmount);
250   }
251 
252   // -----------------------------------------
253   // Internal interface (extensible)
254   // -----------------------------------------
255 
256   /**
257    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
258    * @param _beneficiary Address performing the token purchase
259    * @param _weiAmount Value in wei involved in the purchase
260    */
261   function _preValidatePurchase(
262     address _beneficiary,
263     uint256 _weiAmount
264   )
265     internal
266   {
267     require(_beneficiary != address(0));
268     require(_weiAmount != 0);
269   }
270 
271   /**
272    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
273    * @param _beneficiary Address performing the token purchase
274    * @param _weiAmount Value in wei involved in the purchase
275    */
276   function _postValidatePurchase(
277     address _beneficiary,
278     uint256 _weiAmount
279   )
280     internal
281   {
282     // optional override
283   }
284 
285   /**
286    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
287    * @param _beneficiary Address performing the token purchase
288    * @param _tokenAmount Number of tokens to be emitted
289    */
290   function _deliverTokens(
291     address _beneficiary,
292     uint256 _tokenAmount
293   )
294     internal
295   {
296     token.transfer(_beneficiary, _tokenAmount);
297   }
298 
299   /**
300    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
301    * @param _beneficiary Address receiving the tokens
302    * @param _tokenAmount Number of tokens to be purchased
303    */
304   function _processPurchase(
305     address _beneficiary,
306     uint256 _tokenAmount
307   )
308     internal
309   {
310     _deliverTokens(_beneficiary, _tokenAmount);
311   }
312 
313   /**
314    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
315    * @param _beneficiary Address receiving the tokens
316    * @param _weiAmount Value in wei involved in the purchase
317    */
318   function _updatePurchasingState(
319     address _beneficiary,
320     uint256 _weiAmount
321   )
322     internal
323   {
324     // optional override
325   }
326 
327   /**
328    * @dev Override to extend the way in which ether is converted to tokens.
329    * @param _weiAmount Value in wei to be converted into tokens
330    * @return Number of tokens that can be purchased with the specified _weiAmount
331    */
332   function _getTokenAmount(uint256 _weiAmount)
333     internal view returns (uint256)
334   {
335     return _weiAmount.mul(rate);
336   }
337 
338   /**
339    * @dev Determines how ETH is stored/forwarded on purchases.
340    */
341   function _forwardFunds() internal {
342     wallet.transfer(msg.value);
343   }
344 }
345 
346 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
347 
348 /**
349  * @title TimedCrowdsale
350  * @dev Crowdsale accepting contributions only within a time frame.
351  */
352 contract TimedCrowdsale is Crowdsale {
353   using SafeMath for uint256;
354 
355   uint256 public openingTime;
356   uint256 public closingTime;
357 
358   /**
359    * @dev Reverts if not in crowdsale time range.
360    */
361   modifier onlyWhileOpen {
362     // solium-disable-next-line security/no-block-members
363     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
364     _;
365   }
366 
367   /**
368    * @dev Constructor, takes crowdsale opening and closing times.
369    * @param _openingTime Crowdsale opening time
370    * @param _closingTime Crowdsale closing time
371    */
372   constructor(uint256 _openingTime, uint256 _closingTime) public {
373     // solium-disable-next-line security/no-block-members
374     require(_openingTime >= block.timestamp);
375     require(_closingTime >= _openingTime);
376 
377     openingTime = _openingTime;
378     closingTime = _closingTime;
379   }
380 
381   /**
382    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
383    * @return Whether crowdsale period has elapsed
384    */
385   function hasClosed() public view returns (bool) {
386     // solium-disable-next-line security/no-block-members
387     return block.timestamp > closingTime;
388   }
389 
390   /**
391    * @dev Extend parent behavior requiring to be within contributing period
392    * @param _beneficiary Token purchaser
393    * @param _weiAmount Amount of wei contributed
394    */
395   function _preValidatePurchase(
396     address _beneficiary,
397     uint256 _weiAmount
398   )
399     internal
400     onlyWhileOpen
401   {
402     super._preValidatePurchase(_beneficiary, _weiAmount);
403   }
404 
405 }
406 
407 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
408 
409 /**
410  * @title FinalizableCrowdsale
411  * @dev Extension of Crowdsale where an owner can do extra work
412  * after finishing.
413  */
414 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
415   using SafeMath for uint256;
416 
417   bool public isFinalized = false;
418 
419   event Finalized();
420 
421   /**
422    * @dev Must be called after crowdsale ends, to do some extra finalization
423    * work. Calls the contract's finalization function.
424    */
425   function finalize() onlyOwner public {
426     require(!isFinalized);
427     require(hasClosed());
428 
429     finalization();
430     emit Finalized();
431 
432     isFinalized = true;
433   }
434 
435   /**
436    * @dev Can be overridden to add finalization logic. The overriding function
437    * should call super.finalization() to ensure the chain of finalization is
438    * executed entirely.
439    */
440   function finalization() internal {
441   }
442 
443 }
444 
445 // File: contracts/crowdsale/StageCrowdsale.sol
446 
447 contract StageCrowdsale is FinalizableCrowdsale {
448     bool public previousStageIsFinalized = false;
449     StageCrowdsale public previousStage;
450 
451     constructor(
452         uint256 _rate,
453         address _wallet,
454         ERC20 _token,
455         uint256 _openingTime,
456         uint256 _closingTime,
457         StageCrowdsale _previousStage
458     )
459         public
460         Crowdsale(_rate, _wallet, _token)
461         TimedCrowdsale(_openingTime, _closingTime)
462     {
463         previousStage = _previousStage;
464         if (_previousStage == address(0)) {
465             previousStageIsFinalized = true;
466         }
467     }
468 
469     modifier isNotFinalized() {
470         require(!isFinalized, "Call on finalized.");
471         _;
472     }
473 
474     modifier previousIsFinalized() {
475         require(isPreviousStageFinalized(), "Call on previous stage finalized.");
476         _;
477     }
478 
479     function finalizeStage() public onlyOwner isNotFinalized {
480         _finalizeStage();
481     }
482 
483     function proxyBuyTokens(address _beneficiary) public payable {
484         uint256 weiAmount = msg.value;
485         _preValidatePurchase(_beneficiary, weiAmount);
486 
487         // calculate token amount to be created
488         uint256 tokens = _getTokenAmount(weiAmount);
489 
490         // update state
491         weiRaised = weiRaised.add(weiAmount);
492 
493         _processPurchase(_beneficiary, tokens);
494         // solium-disable-next-line security/no-tx-origin
495         emit TokenPurchase(tx.origin, _beneficiary, weiAmount, tokens);
496 
497         _updatePurchasingState(_beneficiary, weiAmount);
498 
499         _forwardFunds();
500         _postValidatePurchase(_beneficiary, weiAmount);
501     }
502 
503     function isPreviousStageFinalized() public returns (bool) {
504         if (previousStageIsFinalized) {
505             return true;
506         }
507         if (previousStage.isFinalized()) {
508             previousStageIsFinalized = true;
509         }
510         return previousStageIsFinalized;
511     }
512 
513     function _finalizeStage() internal isNotFinalized {
514         finalization();
515         emit Finalized();
516         isFinalized = true;
517     }
518 
519     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isNotFinalized previousIsFinalized {
520         super._preValidatePurchase(_beneficiary, _weiAmount);
521     }
522 }
523 
524 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
525 
526 /**
527  * @title CappedCrowdsale
528  * @dev Crowdsale with a limit for total contributions.
529  */
530 contract CappedCrowdsale is Crowdsale {
531   using SafeMath for uint256;
532 
533   uint256 public cap;
534 
535   /**
536    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
537    * @param _cap Max amount of wei to be contributed
538    */
539   constructor(uint256 _cap) public {
540     require(_cap > 0);
541     cap = _cap;
542   }
543 
544   /**
545    * @dev Checks whether the cap has been reached.
546    * @return Whether the cap was reached
547    */
548   function capReached() public view returns (bool) {
549     return weiRaised >= cap;
550   }
551 
552   /**
553    * @dev Extend parent behavior requiring purchase to respect the funding cap.
554    * @param _beneficiary Token purchaser
555    * @param _weiAmount Amount of wei contributed
556    */
557   function _preValidatePurchase(
558     address _beneficiary,
559     uint256 _weiAmount
560   )
561     internal
562   {
563     super._preValidatePurchase(_beneficiary, _weiAmount);
564     require(weiRaised.add(_weiAmount) <= cap);
565   }
566 
567 }
568 
569 // File: contracts/crowdsale/CappedStageCrowdsale.sol
570 
571 contract CappedStageCrowdsale is CappedCrowdsale, StageCrowdsale {
572     using SafeMath for uint256;
573 
574     /**
575      * @dev Returns value left to reaching crowdsale's cap.
576      * @return Wei to cap
577      */
578     function weiToCap() public view returns (uint256) {
579         return cap.sub(weiRaised);
580     }
581 
582     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
583         super._postValidatePurchase(_beneficiary, _weiAmount);
584         if (weiRaised >= cap) {
585             _finalizeStage();
586         }
587     }
588 }
589 
590 // File: contracts/crowdsale/TokensSoldCountingCrowdsale.sol
591 
592 contract TokensSoldCountingCrowdsale is Crowdsale {
593     using SafeMath for uint256;
594 
595     uint256 public tokensSoldCount;
596 
597     /**
598     * @dev Update tokensSoldCount.
599     * @param _beneficiary Address receiving the tokens
600     * @param _weiAmount Value in wei involved in the purchase
601     */
602     function _updatePurchasingState(
603         address _beneficiary,
604         uint256 _weiAmount
605     )
606     internal
607     {
608         uint256 tokens = _getTokenAmount(_weiAmount);
609         tokensSoldCount = tokensSoldCount.add(tokens);
610     }
611 }
612 
613 // File: contracts/crowdsale/ManualTokenDistributionCrowdsale.sol
614 
615 /**
616  * @title ManualTokenDistributionCrowdsale
617  * @dev Crowdsale with a functionality of manual assignment of tokens
618  */
619 contract ManualTokenDistributionCrowdsale is Crowdsale, Ownable, TokensSoldCountingCrowdsale {
620     
621     using SafeMath for uint256;
622 
623     /**
624     * Event for manual token assignment
625     * @param beneficiary who got the tokens
626     * @param amount amount of tokens purchased
627     */
628     event TokenAssignment(address indexed beneficiary, uint256 amount);
629 
630 
631     /**
632     * @dev Manual send tokens to the specified address.
633     * @param _beneficiary The address of a investor.
634     * @param _tokensAmount Amount of tokens.
635     */
636     function manualSendTokens(address _beneficiary, uint256 _tokensAmount) public  onlyOwner {
637         require(_beneficiary != address(0));
638         require(_tokensAmount > 0);
639 
640         super._deliverTokens(_beneficiary, _tokensAmount);
641         tokensSoldCount = tokensSoldCount.add(_tokensAmount);
642         emit TokenAssignment(_beneficiary, _tokensAmount);
643     }
644 }
645 
646 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
647 
648 /**
649  * @title Pausable
650  * @dev Base contract which allows children to implement an emergency stop mechanism.
651  */
652 contract Pausable is Ownable {
653   event Pause();
654   event Unpause();
655 
656   bool public paused = false;
657 
658 
659   /**
660    * @dev Modifier to make a function callable only when the contract is not paused.
661    */
662   modifier whenNotPaused() {
663     require(!paused);
664     _;
665   }
666 
667   /**
668    * @dev Modifier to make a function callable only when the contract is paused.
669    */
670   modifier whenPaused() {
671     require(paused);
672     _;
673   }
674 
675   /**
676    * @dev called by the owner to pause, triggers stopped state
677    */
678   function pause() onlyOwner whenNotPaused public {
679     paused = true;
680     emit Pause();
681   }
682 
683   /**
684    * @dev called by the owner to unpause, returns to normal state
685    */
686   function unpause() onlyOwner whenPaused public {
687     paused = false;
688     emit Unpause();
689   }
690 }
691 
692 // File: contracts/crowdsale/PausableCrowdsale.sol
693 
694 contract PausableCrowdsale is Crowdsale, Pausable {
695     /**
696      * @dev Extend parent behavior requiring purchase to respect paused state.
697      * @param _beneficiary Token beneficiary
698      * @param _weiAmount Amount of wei contributed
699      */
700     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
701         super._preValidatePurchase(_beneficiary, _weiAmount);
702     }
703 }
704 
705 // File: contracts/crowdsale/TokensRollStageCrowdsale.sol
706 
707 /**
708  * @title TokensRollStageCrowdsale
709  * @dev Crowdsale transferring remaining token balance to a specified address on finalization.
710  */
711 contract TokensRollStageCrowdsale is FinalizableCrowdsale {
712 
713     // Wallet to transfer remaining token balance to.
714     address public rollAddress;
715 
716     /**
717      * @dev Requires that the roll address was set.
718      */
719     modifier havingRollAddress() {
720         require(rollAddress != address(0), "Call when no roll address set.");
721         _;
722     }
723 
724     /**
725      * @dev Transfers remaining token balance to the roll address. Called when owner calls finalize().
726      */
727     function finalization() internal havingRollAddress {
728         super.finalization();
729         token.transfer(rollAddress, token.balanceOf(this));
730     }
731 
732     /**
733      * @dev Sets address to transfer tokens to upon crowdsale finalization.
734      * @param _rollAddress Address to transfer tokens to.
735      */
736     function setRollAddress(address _rollAddress) public onlyOwner {
737         require(_rollAddress != address(0), "Call with invalid _rollAddress.");
738         rollAddress = _rollAddress;
739     }
740 }
741 
742 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
743 
744 /**
745  * @title Roles
746  * @author Francisco Giordano (@frangio)
747  * @dev Library for managing addresses assigned to a Role.
748  *      See RBAC.sol for example usage.
749  */
750 library Roles {
751   struct Role {
752     mapping (address => bool) bearer;
753   }
754 
755   /**
756    * @dev give an address access to this role
757    */
758   function add(Role storage role, address addr)
759     internal
760   {
761     role.bearer[addr] = true;
762   }
763 
764   /**
765    * @dev remove an address' access to this role
766    */
767   function remove(Role storage role, address addr)
768     internal
769   {
770     role.bearer[addr] = false;
771   }
772 
773   /**
774    * @dev check if an address has this role
775    * // reverts
776    */
777   function check(Role storage role, address addr)
778     view
779     internal
780   {
781     require(has(role, addr));
782   }
783 
784   /**
785    * @dev check if an address has this role
786    * @return bool
787    */
788   function has(Role storage role, address addr)
789     view
790     internal
791     returns (bool)
792   {
793     return role.bearer[addr];
794   }
795 }
796 
797 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
798 
799 /**
800  * @title RBAC (Role-Based Access Control)
801  * @author Matt Condon (@Shrugs)
802  * @dev Stores and provides setters and getters for roles and addresses.
803  * @dev Supports unlimited numbers of roles and addresses.
804  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
805  * This RBAC method uses strings to key roles. It may be beneficial
806  *  for you to write your own implementation of this interface using Enums or similar.
807  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
808  *  to avoid typos.
809  */
810 contract RBAC {
811   using Roles for Roles.Role;
812 
813   mapping (string => Roles.Role) private roles;
814 
815   event RoleAdded(address addr, string roleName);
816   event RoleRemoved(address addr, string roleName);
817 
818   /**
819    * @dev reverts if addr does not have role
820    * @param addr address
821    * @param roleName the name of the role
822    * // reverts
823    */
824   function checkRole(address addr, string roleName)
825     view
826     public
827   {
828     roles[roleName].check(addr);
829   }
830 
831   /**
832    * @dev determine if addr has role
833    * @param addr address
834    * @param roleName the name of the role
835    * @return bool
836    */
837   function hasRole(address addr, string roleName)
838     view
839     public
840     returns (bool)
841   {
842     return roles[roleName].has(addr);
843   }
844 
845   /**
846    * @dev add a role to an address
847    * @param addr address
848    * @param roleName the name of the role
849    */
850   function addRole(address addr, string roleName)
851     internal
852   {
853     roles[roleName].add(addr);
854     emit RoleAdded(addr, roleName);
855   }
856 
857   /**
858    * @dev remove a role from an address
859    * @param addr address
860    * @param roleName the name of the role
861    */
862   function removeRole(address addr, string roleName)
863     internal
864   {
865     roles[roleName].remove(addr);
866     emit RoleRemoved(addr, roleName);
867   }
868 
869   /**
870    * @dev modifier to scope access to a single role (uses msg.sender as addr)
871    * @param roleName the name of the role
872    * // reverts
873    */
874   modifier onlyRole(string roleName)
875   {
876     checkRole(msg.sender, roleName);
877     _;
878   }
879 
880   /**
881    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
882    * @param roleNames the names of the roles to scope access to
883    * // reverts
884    *
885    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
886    *  see: https://github.com/ethereum/solidity/issues/2467
887    */
888   // modifier onlyRoles(string[] roleNames) {
889   //     bool hasAnyRole = false;
890   //     for (uint8 i = 0; i < roleNames.length; i++) {
891   //         if (hasRole(msg.sender, roleNames[i])) {
892   //             hasAnyRole = true;
893   //             break;
894   //         }
895   //     }
896 
897   //     require(hasAnyRole);
898 
899   //     _;
900   // }
901 }
902 
903 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
904 
905 /**
906  * @title Whitelist
907  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
908  * @dev This simplifies the implementation of "user permissions".
909  */
910 contract Whitelist is Ownable, RBAC {
911   event WhitelistedAddressAdded(address addr);
912   event WhitelistedAddressRemoved(address addr);
913 
914   string public constant ROLE_WHITELISTED = "whitelist";
915 
916   /**
917    * @dev Throws if called by any account that's not whitelisted.
918    */
919   modifier onlyWhitelisted() {
920     checkRole(msg.sender, ROLE_WHITELISTED);
921     _;
922   }
923 
924   /**
925    * @dev add an address to the whitelist
926    * @param addr address
927    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
928    */
929   function addAddressToWhitelist(address addr)
930     onlyOwner
931     public
932   {
933     addRole(addr, ROLE_WHITELISTED);
934     emit WhitelistedAddressAdded(addr);
935   }
936 
937   /**
938    * @dev getter to determine if address is in whitelist
939    */
940   function whitelist(address addr)
941     public
942     view
943     returns (bool)
944   {
945     return hasRole(addr, ROLE_WHITELISTED);
946   }
947 
948   /**
949    * @dev add addresses to the whitelist
950    * @param addrs addresses
951    * @return true if at least one address was added to the whitelist,
952    * false if all addresses were already in the whitelist
953    */
954   function addAddressesToWhitelist(address[] addrs)
955     onlyOwner
956     public
957   {
958     for (uint256 i = 0; i < addrs.length; i++) {
959       addAddressToWhitelist(addrs[i]);
960     }
961   }
962 
963   /**
964    * @dev remove an address from the whitelist
965    * @param addr address
966    * @return true if the address was removed from the whitelist,
967    * false if the address wasn't in the whitelist in the first place
968    */
969   function removeAddressFromWhitelist(address addr)
970     onlyOwner
971     public
972   {
973     removeRole(addr, ROLE_WHITELISTED);
974     emit WhitelistedAddressRemoved(addr);
975   }
976 
977   /**
978    * @dev remove addresses from the whitelist
979    * @param addrs addresses
980    * @return true if at least one address was removed from the whitelist,
981    * false if all addresses weren't in the whitelist in the first place
982    */
983   function removeAddressesFromWhitelist(address[] addrs)
984     onlyOwner
985     public
986   {
987     for (uint256 i = 0; i < addrs.length; i++) {
988       removeAddressFromWhitelist(addrs[i]);
989     }
990   }
991 
992 }
993 
994 // File: contracts/crowdsale/WhitelistedCrowdsale.sol
995 
996 contract WhitelistedCrowdsale is Crowdsale, Ownable {
997     Whitelist public whitelist;
998 
999     constructor (Whitelist _whitelist) public {
1000         require(_whitelist != address(0));
1001         whitelist = _whitelist;
1002     }
1003 
1004     /**
1005     * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
1006     */
1007     modifier onlyWhitelisted(address _beneficiary) {
1008         require(whitelist.whitelist(_beneficiary));
1009         _;
1010     }
1011 
1012     function isWhitelisted(address _beneficiary) public view returns(bool) {
1013         return whitelist.whitelist(_beneficiary);
1014     }
1015 
1016     function changeWhitelist(Whitelist _whitelist) public onlyOwner {
1017         whitelist = _whitelist;
1018     }
1019 
1020     /**
1021     * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1022     * @param _beneficiary Token beneficiary
1023     * @param _weiAmount Amount of wei contributed
1024     */
1025     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhitelisted(_beneficiary) {
1026         super._preValidatePurchase(_beneficiary, _weiAmount);
1027     }
1028 }
1029 
1030 // File: openzeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
1031 
1032 /**
1033  * @title RefundVault
1034  * @dev This contract is used for storing funds while a crowdsale
1035  * is in progress. Supports refunding the money if crowdsale fails,
1036  * and forwarding it if crowdsale is successful.
1037  */
1038 contract RefundVault is Ownable {
1039   using SafeMath for uint256;
1040 
1041   enum State { Active, Refunding, Closed }
1042 
1043   mapping (address => uint256) public deposited;
1044   address public wallet;
1045   State public state;
1046 
1047   event Closed();
1048   event RefundsEnabled();
1049   event Refunded(address indexed beneficiary, uint256 weiAmount);
1050 
1051   /**
1052    * @param _wallet Vault address
1053    */
1054   constructor(address _wallet) public {
1055     require(_wallet != address(0));
1056     wallet = _wallet;
1057     state = State.Active;
1058   }
1059 
1060   /**
1061    * @param investor Investor address
1062    */
1063   function deposit(address investor) onlyOwner public payable {
1064     require(state == State.Active);
1065     deposited[investor] = deposited[investor].add(msg.value);
1066   }
1067 
1068   function close() onlyOwner public {
1069     require(state == State.Active);
1070     state = State.Closed;
1071     emit Closed();
1072     wallet.transfer(address(this).balance);
1073   }
1074 
1075   function enableRefunds() onlyOwner public {
1076     require(state == State.Active);
1077     state = State.Refunding;
1078     emit RefundsEnabled();
1079   }
1080 
1081   /**
1082    * @param investor Investor address
1083    */
1084   function refund(address investor) public {
1085     require(state == State.Refunding);
1086     uint256 depositedValue = deposited[investor];
1087     deposited[investor] = 0;
1088     investor.transfer(depositedValue);
1089     emit Refunded(investor, depositedValue);
1090   }
1091 }
1092 
1093 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
1094 
1095 /**
1096  * @title RefundableCrowdsale
1097  * @dev Extension of Crowdsale contract that adds a funding goal, and
1098  * the possibility of users getting a refund if goal is not met.
1099  * Uses a RefundVault as the crowdsale's vault.
1100  */
1101 contract RefundableCrowdsale is FinalizableCrowdsale {
1102   using SafeMath for uint256;
1103 
1104   // minimum amount of funds to be raised in weis
1105   uint256 public goal;
1106 
1107   // refund vault used to hold funds while crowdsale is running
1108   RefundVault public vault;
1109 
1110   /**
1111    * @dev Constructor, creates RefundVault.
1112    * @param _goal Funding goal
1113    */
1114   constructor(uint256 _goal) public {
1115     require(_goal > 0);
1116     vault = new RefundVault(wallet);
1117     goal = _goal;
1118   }
1119 
1120   /**
1121    * @dev Investors can claim refunds here if crowdsale is unsuccessful
1122    */
1123   function claimRefund() public {
1124     require(isFinalized);
1125     require(!goalReached());
1126 
1127     vault.refund(msg.sender);
1128   }
1129 
1130   /**
1131    * @dev Checks whether funding goal was reached.
1132    * @return Whether funding goal was reached
1133    */
1134   function goalReached() public view returns (bool) {
1135     return weiRaised >= goal;
1136   }
1137 
1138   /**
1139    * @dev vault finalization task, called when owner calls finalize()
1140    */
1141   function finalization() internal {
1142     if (goalReached()) {
1143       vault.close();
1144     } else {
1145       vault.enableRefunds();
1146     }
1147 
1148     super.finalization();
1149   }
1150 
1151   /**
1152    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
1153    */
1154   function _forwardFunds() internal {
1155     vault.deposit.value(msg.value)(msg.sender);
1156   }
1157 
1158 }
1159 
1160 // File: contracts/BlockFollowPreSaleStageCrowdsale.sol
1161 
1162 contract BlockFollowPreSaleStageCrowdsale is StageCrowdsale, CappedStageCrowdsale, TokensRollStageCrowdsale,
1163     ManualTokenDistributionCrowdsale, PausableCrowdsale, WhitelistedCrowdsale {
1164 
1165     uint256 public ratePerEth;
1166 
1167     constructor(
1168         address _wallet,
1169         ERC20 _token,
1170         uint256 _openingTime,
1171         uint256 _ratePerEth,
1172         uint256 _maxCap,
1173         Whitelist _whitelist
1174     )
1175         public
1176         CappedCrowdsale(_maxCap)
1177         StageCrowdsale(_ratePerEth, _wallet, _token, _openingTime, _openingTime + 2 weeks, StageCrowdsale(address(0)))
1178         WhitelistedCrowdsale(_whitelist)
1179     {
1180         require(_ratePerEth > 0, "Rate per ETH cannot be null");
1181         ratePerEth = _ratePerEth;
1182     }
1183 
1184    /**
1185     * @dev Defines the way in which ether is converted to tokens.
1186     * @param _weiAmount Value in wei to be converted into tokens
1187     * @return Number of tokens that can be purchased with the specified _weiAmount
1188     */
1189     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1190         return _weiAmount.div(1e10).mul(ratePerEth);
1191     }
1192 }