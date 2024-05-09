1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 /**
106  * @title HolderBase
107  * @notice HolderBase handles data & funcitons for token or ether holders.
108  * HolderBase contract can distribute only one of ether or token.
109  */
110 contract HolderBase is Ownable {
111   using SafeMath for uint256;
112 
113   uint8 public constant MAX_HOLDERS = 64; // TODO: tokyo-input should verify # of holders
114   uint256 public coeff;
115   bool public distributed;
116   bool public initialized;
117 
118   struct Holder {
119     address addr;
120     uint96 ratio;
121   }
122 
123   Holder[] public holders;
124 
125   event Distributed();
126 
127   function HolderBase(uint256 _coeff) public {
128     require(_coeff != 0);
129     coeff = _coeff;
130   }
131 
132   function getHolderCount() public view returns (uint256) {
133     return holders.length;
134   }
135 
136   function initHolders(address[] _addrs, uint96[] _ratios) public onlyOwner {
137     require(!initialized);
138     require(holders.length == 0);
139     require(_addrs.length != 0);
140     require(_addrs.length <= MAX_HOLDERS);
141     require(_addrs.length == _ratios.length);
142 
143     uint256 accRatio;
144 
145     for(uint8 i = 0; i < _addrs.length; i++) {
146       if (_addrs[i] != address(0)) {
147         // address will be 0x00 in case of "crowdsale".
148         holders.push(Holder(_addrs[i], _ratios[i]));
149       }
150 
151       accRatio = accRatio.add(uint256(_ratios[i]));
152     }
153 
154     require(accRatio <= coeff);
155 
156     initialized = true;
157   }
158 
159   /**
160    * @dev Distribute ether to `holder`s according to ratio.
161    * Remaining ether is transfered to `wallet` from the close
162    * function of RefundVault contract.
163    */
164   function distribute() internal {
165     require(!distributed, "Already distributed");
166     uint256 balance = this.balance;
167 
168     require(balance > 0, "No ether to distribute");
169     distributed = true;
170 
171     for (uint8 i = 0; i < holders.length; i++) {
172       uint256 holderAmount = balance.mul(uint256(holders[i].ratio)).div(coeff);
173 
174       holders[i].addr.transfer(holderAmount);
175     }
176 
177     emit Distributed(); // A single log to reduce gas
178   }
179 
180   /**
181    * @dev Distribute ERC20 token to `holder`s according to ratio.
182    */
183   function distributeToken(ERC20Basic _token, uint256 _targetTotalSupply) internal {
184     require(!distributed, "Already distributed");
185     distributed = true;
186 
187     for (uint8 i = 0; i < holders.length; i++) {
188       uint256 holderAmount = _targetTotalSupply.mul(uint256(holders[i].ratio)).div(coeff);
189       deliverTokens(_token, holders[i].addr, holderAmount);
190     }
191 
192     emit Distributed(); // A single log to reduce gas
193   }
194 
195   // Override to distribute tokens
196   function deliverTokens(ERC20Basic _token, address _beneficiary, uint256 _tokens) internal {}
197 }
198 
199 
200 /**
201  * @title ERC20 interface
202  * @dev see https://github.com/ethereum/EIPs/issues/20
203  */
204 contract ERC20 is ERC20Basic {
205   function allowance(address owner, address spender) public view returns (uint256);
206   function transferFrom(address from, address to, uint256 value) public returns (bool);
207   function approve(address spender, uint256 value) public returns (bool);
208   event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210 
211 
212 /**
213  * @title SafeERC20
214  * @dev Wrappers around ERC20 operations that throw on failure.
215  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
216  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
217  */
218 library SafeERC20 {
219   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
220     assert(token.transfer(to, value));
221   }
222 
223   function safeTransferFrom(
224     ERC20 token,
225     address from,
226     address to,
227     uint256 value
228   )
229     internal
230   {
231     assert(token.transferFrom(from, to, value));
232   }
233 
234   function safeApprove(ERC20 token, address spender, uint256 value) internal {
235     assert(token.approve(spender, value));
236   }
237 }
238 
239 
240 /**
241  * @title Locker
242  * @notice Locker holds tokens and releases them at a certain time.
243  */
244 contract Locker is Ownable {
245   using SafeMath for uint;
246   using SafeERC20 for ERC20Basic;
247 
248   /**
249    * It is init state only when adding release info is possible.
250    * beneficiary only can release tokens when Locker is active.
251    * After all tokens are released, locker is drawn.
252    */
253   enum State { Init, Ready, Active, Drawn }
254 
255   struct Beneficiary {
256     uint ratio;             // ratio based on Locker's initial balance.
257     uint withdrawAmount;    // accumulated tokens beneficiary released
258     bool releaseAllTokens;
259   }
260 
261   /**
262    * @notice Release has info to release tokens.
263    * If lock type is straight, only two release infos is required.
264    *
265    *     |
266    * 100 |                _______________
267    *     |              _/
268    *  50 |            _/
269    *     |         . |
270    *     |       .   |
271    *     |     .     |
272    *     +===+=======+----*----------> time
273    *     Locker  First    Last
274    *  Activated  Release  Release
275    *
276    *
277    * If lock type is variable, the release graph will be
278    *
279    *     |
280    * 100 |                                 _________
281    *     |                                |
282    *  70 |                      __________|
283    *     |                     |
284    *  30 |            _________|
285    *     |           |
286    *     +===+=======+---------+----------*------> time
287    *     Locker   First        Second     Last
288    *  Activated   Release      Release    Release
289    *
290    *
291    *
292    * For the first straight release graph, parameters would be
293    *   coeff: 100
294    *   releaseTimes: [
295    *     first release time,
296    *     second release time
297    *   ]
298    *   releaseRatios: [
299    *     50,
300    *     100,
301    *   ]
302    *
303    * For the second variable release graph, parameters would be
304    *   coeff: 100
305    *   releaseTimes: [
306    *     first release time,
307    *     second release time,
308    *     last release time
309    *   ]
310    *   releaseRatios: [
311    *     30,
312    *     70,
313    *     100,
314    *   ]
315    *
316    */
317   struct Release {
318     bool isStraight;        // lock type : straight or variable
319     uint[] releaseTimes;    //
320     uint[] releaseRatios;   //
321   }
322 
323   uint public activeTime;
324 
325   // ERC20 basic token contract being held
326   ERC20Basic public token;
327 
328   uint public coeff;
329   uint public initialBalance;
330   uint public withdrawAmount; // total amount of tokens released
331 
332   mapping (address => Beneficiary) public beneficiaries;
333   mapping (address => Release) public releases;  // beneficiary's lock
334   mapping (address => bool) public locked; // whether beneficiary's lock is instantiated
335 
336   uint public numBeneficiaries;
337   uint public numLocks;
338 
339   State public state;
340 
341   modifier onlyState(State v) {
342     require(state == v);
343     _;
344   }
345 
346   modifier onlyBeneficiary(address _addr) {
347     require(beneficiaries[_addr].ratio > 0);
348     _;
349   }
350 
351   event StateChanged(State _state);
352   event Locked(address indexed _beneficiary, bool _isStraight);
353   event Released(address indexed _beneficiary, uint256 _amount);
354 
355   function Locker(address _token, uint _coeff, address[] _beneficiaries, uint[] _ratios) public {
356     require(_token != address(0));
357     require(_beneficiaries.length == _ratios.length);
358 
359     token = ERC20Basic(_token);
360     coeff = _coeff;
361     numBeneficiaries = _beneficiaries.length;
362 
363     uint accRatio;
364 
365     for(uint i = 0; i < numBeneficiaries; i++) {
366       require(_ratios[i] > 0);
367       beneficiaries[_beneficiaries[i]].ratio = _ratios[i];
368 
369       accRatio = accRatio.add(_ratios[i]);
370     }
371 
372     require(coeff == accRatio);
373   }
374 
375   /**
376    * @notice beneficiary can release their tokens after activated
377    */
378   function activate() external onlyOwner onlyState(State.Ready) {
379     require(numLocks == numBeneficiaries); // double check : assert all releases are recorded
380 
381     initialBalance = token.balanceOf(this);
382     require(initialBalance > 0);
383 
384     activeTime = now; // solium-disable-line security/no-block-members
385 
386     // set locker as active state
387     state = State.Active;
388     emit StateChanged(state);
389   }
390 
391   function getReleaseType(address _beneficiary)
392     public
393     view
394     onlyBeneficiary(_beneficiary)
395     returns (bool)
396   {
397     return releases[_beneficiary].isStraight;
398   }
399 
400   function getTotalLockedAmounts(address _beneficiary)
401     public
402     view
403     onlyBeneficiary(_beneficiary)
404     returns (uint)
405   {
406     return getPartialAmount(beneficiaries[_beneficiary].ratio, coeff, initialBalance);
407   }
408 
409   function getReleaseTimes(address _beneficiary)
410     public
411     view
412     onlyBeneficiary(_beneficiary)
413     returns (uint[])
414   {
415     return releases[_beneficiary].releaseTimes;
416   }
417 
418   function getReleaseRatios(address _beneficiary)
419     public
420     view
421     onlyBeneficiary(_beneficiary)
422     returns (uint[])
423   {
424     return releases[_beneficiary].releaseRatios;
425   }
426 
427   /**
428    * @notice add new release record for beneficiary
429    */
430   function lock(address _beneficiary, bool _isStraight, uint[] _releaseTimes, uint[] _releaseRatios)
431     external
432     onlyOwner
433     onlyState(State.Init)
434     onlyBeneficiary(_beneficiary)
435   {
436     require(!locked[_beneficiary]);
437     require(_releaseRatios.length != 0);
438     require(_releaseRatios.length == _releaseTimes.length);
439 
440     uint i;
441     uint len = _releaseRatios.length;
442 
443     // finally should release all tokens
444     require(_releaseRatios[len - 1] == coeff);
445 
446     // check two array are ascending sorted
447     for(i = 0; i < len - 1; i++) {
448       require(_releaseTimes[i] < _releaseTimes[i + 1]);
449       require(_releaseRatios[i] < _releaseRatios[i + 1]);
450     }
451 
452     // 2 release times for straight locking type
453     if (_isStraight) {
454       require(len == 2);
455     }
456 
457     numLocks = numLocks.add(1);
458 
459     // create Release for the beneficiary
460     releases[_beneficiary].isStraight = _isStraight;
461 
462     // copy array of uint
463     releases[_beneficiary].releaseTimes = _releaseTimes;
464     releases[_beneficiary].releaseRatios = _releaseRatios;
465 
466     // lock beneficiary
467     locked[_beneficiary] = true;
468     emit Locked(_beneficiary, _isStraight);
469 
470     //  if all beneficiaries locked, change Locker state to change
471     if (numLocks == numBeneficiaries) {
472       state = State.Ready;
473       emit StateChanged(state);
474     }
475   }
476 
477   /**
478    * @notice transfer releasable tokens for beneficiary wrt the release graph
479    */
480   function release() external onlyState(State.Active) onlyBeneficiary(msg.sender) {
481     require(!beneficiaries[msg.sender].releaseAllTokens);
482 
483     uint releasableAmount = getReleasableAmount(msg.sender);
484     beneficiaries[msg.sender].withdrawAmount = beneficiaries[msg.sender].withdrawAmount.add(releasableAmount);
485 
486     beneficiaries[msg.sender].releaseAllTokens = beneficiaries[msg.sender].withdrawAmount == getPartialAmount(
487       beneficiaries[msg.sender].ratio,
488       coeff,
489       initialBalance);
490 
491     withdrawAmount = withdrawAmount.add(releasableAmount);
492 
493     if (withdrawAmount == initialBalance) {
494       state = State.Drawn;
495       emit StateChanged(state);
496     }
497 
498     token.transfer(msg.sender, releasableAmount);
499     emit Released(msg.sender, releasableAmount);
500   }
501 
502   function getReleasableAmount(address _beneficiary) internal view returns (uint) {
503     if (releases[_beneficiary].isStraight) {
504       return getStraightReleasableAmount(_beneficiary);
505     } else {
506       return getVariableReleasableAmount(_beneficiary);
507     }
508   }
509 
510   /**
511    * @notice return releaseable amount for beneficiary in case of straight type of release
512    */
513   function getStraightReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {
514     Beneficiary memory _b = beneficiaries[_beneficiary];
515     Release memory _r = releases[_beneficiary];
516 
517     // total amount of tokens beneficiary can release
518     uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);
519 
520     uint firstTime = _r.releaseTimes[0];
521     uint lastTime = _r.releaseTimes[1];
522 
523     // solium-disable security/no-block-members
524     require(now >= firstTime); // pass if can release
525     // solium-enable security/no-block-members
526 
527     if(now >= lastTime) { // inclusive to reduce calculation
528       releasableAmount = totalReleasableAmount;
529     } else {
530       // releasable amount at first time
531       uint firstAmount = getPartialAmount(
532         _r.releaseRatios[0],
533         coeff,
534         totalReleasableAmount);
535 
536       // partial amount without first amount
537       releasableAmount = getPartialAmount(
538         now.sub(firstTime),
539         lastTime.sub(firstTime),
540         totalReleasableAmount.sub(firstAmount));
541       releasableAmount = releasableAmount.add(firstAmount);
542     }
543 
544     // subtract already withdrawn amounts
545     releasableAmount = releasableAmount.sub(_b.withdrawAmount);
546   }
547 
548   /**
549    * @notice return releaseable amount for beneficiary in case of variable type of release
550    */
551   function getVariableReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {
552     Beneficiary memory _b = beneficiaries[_beneficiary];
553     Release memory _r = releases[_beneficiary];
554 
555     // total amount of tokens beneficiary will receive
556     uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);
557 
558     uint releaseRatio;
559 
560     // reverse order for short curcit
561     for(uint i = _r.releaseTimes.length - 1; i >= 0; i--) {
562       if (now >= _r.releaseTimes[i]) {
563         releaseRatio = _r.releaseRatios[i];
564         break;
565       }
566     }
567 
568     require(releaseRatio > 0);
569 
570     releasableAmount = getPartialAmount(
571       releaseRatio,
572       coeff,
573       totalReleasableAmount);
574     releasableAmount = releasableAmount.sub(_b.withdrawAmount);
575   }
576 
577   /// https://github.com/0xProject/0x.js/blob/05aae368132a81ddb9fd6a04ac5b0ff1cbb24691/packages/contracts/src/current/protocol/Exchange/Exchange.sol#L497
578   /// @notice Calculates partial value given a numerator and denominator.
579   /// @param numerator Numerator.
580   /// @param denominator Denominator.
581   /// @param target Value to calculate partial of.
582   /// @return Partial value of target.
583   function getPartialAmount(uint numerator, uint denominator, uint target) public pure returns (uint) {
584     return numerator.mul(target).div(denominator);
585   }
586 }
587 
588 
589 /**
590  * @title RefundVault
591  * @dev This contract is used for storing funds while a crowdsale
592  * is in progress. Supports refunding the money if crowdsale fails,
593  * and forwarding it if crowdsale is successful.
594  */
595 contract RefundVault is Ownable {
596   using SafeMath for uint256;
597 
598   enum State { Active, Refunding, Closed }
599 
600   mapping (address => uint256) public deposited;
601   address public wallet;
602   State public state;
603 
604   event Closed();
605   event RefundsEnabled();
606   event Refunded(address indexed beneficiary, uint256 weiAmount);
607 
608   /**
609    * @param _wallet Vault address
610    */
611   function RefundVault(address _wallet) public {
612     require(_wallet != address(0));
613     wallet = _wallet;
614     state = State.Active;
615   }
616 
617   /**
618    * @param investor Investor address
619    */
620   function deposit(address investor) onlyOwner public payable {
621     require(state == State.Active);
622     deposited[investor] = deposited[investor].add(msg.value);
623   }
624 
625   function close() onlyOwner public {
626     require(state == State.Active);
627     state = State.Closed;
628     emit Closed();
629     wallet.transfer(address(this).balance);
630   }
631 
632   function enableRefunds() onlyOwner public {
633     require(state == State.Active);
634     state = State.Refunding;
635     emit RefundsEnabled();
636   }
637 
638   /**
639    * @param investor Investor address
640    */
641   function refund(address investor) public {
642     require(state == State.Refunding);
643     uint256 depositedValue = deposited[investor];
644     deposited[investor] = 0;
645     investor.transfer(depositedValue);
646     emit Refunded(investor, depositedValue);
647   }
648 }
649 
650 
651 /**
652  * @title MultiHolderVault
653  * @dev This contract distribute ether to multiple address.
654  */
655 contract MultiHolderVault is HolderBase, RefundVault {
656   using SafeMath for uint256;
657 
658   function MultiHolderVault(address _wallet, uint256 _ratioCoeff)
659     public
660     HolderBase(_ratioCoeff)
661     RefundVault(_wallet)
662   {}
663 
664   function close() public onlyOwner {
665     require(state == State.Active);
666     require(initialized);
667 
668     super.distribute(); // distribute ether to holders
669     super.close(); // transfer remaining ether to wallet
670   }
671 }
672 
673 
674 /**
675  * @title Pausable
676  * @dev Base contract which allows children to implement an emergency stop mechanism.
677  */
678 contract Pausable is Ownable {
679   event Pause();
680   event Unpause();
681 
682   bool public paused = false;
683 
684 
685   /**
686    * @dev Modifier to make a function callable only when the contract is not paused.
687    */
688   modifier whenNotPaused() {
689     require(!paused);
690     _;
691   }
692 
693   /**
694    * @dev Modifier to make a function callable only when the contract is paused.
695    */
696   modifier whenPaused() {
697     require(paused);
698     _;
699   }
700 
701   /**
702    * @dev called by the owner to pause, triggers stopped state
703    */
704   function pause() onlyOwner whenNotPaused public {
705     paused = true;
706     emit Pause();
707   }
708 
709   /**
710    * @dev called by the owner to unpause, returns to normal state
711    */
712   function unpause() onlyOwner whenPaused public {
713     paused = false;
714     emit Unpause();
715   }
716 }
717 
718 
719 contract BaseCrowdsale is HolderBase, Pausable {
720   using SafeMath for uint256;
721 
722   Locker public locker;     // token locker
723 
724   // start and end timestamps where investments are allowed (both inclusive)
725   uint256 public startTime;
726   uint256 public endTime;
727 
728   // how many token units a buyer gets per wei
729   // use coeff ratio from HolderBase
730   uint256 public rate;
731 
732 
733   // amount of raised money in wei
734   uint256 public weiRaised;
735 
736   // ratio of tokens for crowdsale
737   uint256 public crowdsaleRatio;
738 
739   bool public isFinalized = false;
740 
741   uint256 public cap;
742 
743   // minimum amount of funds to be raised in weis
744   uint256 public goal;
745 
746   // refund vault used to hold funds while crowdsale is running
747   MultiHolderVault public vault;
748 
749   address public nextTokenOwner;
750 
751   /**
752    * event for token purchase logging
753    * @param purchaser who paid for the tokens
754    * @param beneficiary who got the tokens
755    * @param value weis paid for purchase
756    * @param amount amount of tokens purchased
757    */
758   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
759   event Finalized();
760   event ClaimTokens(address indexed _token, uint256 _amount);
761 
762   function BaseCrowdsale(uint256 _coeff) HolderBase(_coeff) public {}
763 
764   // fallback function can be used to buy tokens
765   function () external payable {
766     buyTokens(msg.sender);
767   }
768 
769   function buyTokens(address beneficiary) public payable whenNotPaused {
770     require(beneficiary != address(0));
771     require(validPurchase());
772 
773     uint256 weiAmount = msg.value;
774 
775     uint256 toFund = calculateToFund(beneficiary, weiAmount);
776     require(toFund > 0);
777 
778     uint256 toReturn = weiAmount.sub(toFund);
779 
780     buyTokensPreHook(beneficiary, toFund);
781 
782     // calculate token amount to be created
783     uint256 tokens = getTokenAmount(toFund);
784 
785     // update state
786     weiRaised = weiRaised.add(toFund);
787 
788     if (toReturn > 0) {
789       msg.sender.transfer(toReturn);
790     }
791 
792     buyTokensPostHook(beneficiary, tokens, toFund);
793 
794     generateTokens(beneficiary, tokens);
795     emit TokenPurchase(msg.sender, beneficiary, toFund, tokens);
796     forwardFunds(toFund);
797   }
798 
799   /**
800    * @dev Must be called after crowdsale ends, to do some extra finalization
801    * work. Calls the contract's finalization function.
802    */
803   function finalize() onlyOwner public {
804     require(!isFinalized);
805     require(hasEnded());
806 
807     finalization();
808     emit Finalized();
809 
810     isFinalized = true;
811   }
812 
813 
814   // vault finalization task, called when owner calls finalize()
815   function finalization() internal {
816     if (goalReached()) {
817       finalizationSuccessHook();
818     } else {
819       finalizationFailHook();
820     }
821   }
822 
823   // if crowdsale is unsuccessful, investors can claim refunds here
824   function claimRefund() public {
825     require(isFinalized);
826     require(!goalReached());
827 
828     vault.refund(msg.sender);
829   }
830 
831   function goalReached() public view returns (bool) {
832     return weiRaised >= goal;
833   }
834 
835   /// @return true if crowdsale event has ended
836   function hasEnded() public view returns (bool) {
837     bool capReached = weiRaised >= cap;
838     return capReached || now > endTime; // solium-disable-line security/no-block-members
839   }
840 
841   // Override this method to have a way to add business logic to your crowdsale when buying
842   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
843     return weiAmount.mul(rate);
844   }
845 
846   /**
847    * @notice forwardd ether to vault
848    */
849   function forwardFunds(uint256 toFund) internal {
850     vault.deposit.value(toFund)(msg.sender);
851   }
852 
853   // @return true if the transaction can buy tokens
854   function validPurchase() internal view returns (bool) {
855     bool withinPeriod = now >= startTime && now <= endTime; // solium-disable-line security/no-block-members
856     bool nonZeroPurchase = msg.value != 0;
857     return withinPeriod && nonZeroPurchase;
858   }
859 
860   /**
861    * @notice calculate fund wrt sale cap. Override this function to control ether cap.
862    * @param _beneficiary address address to receive tokens
863    * @param _weiAmount uint256 amount of ether in wei
864    */
865   function calculateToFund(address _beneficiary, uint256 _weiAmount) internal view returns (uint256) {
866     uint256 toFund;
867     uint256 postWeiRaised = weiRaised.add(_weiAmount);
868 
869     if (postWeiRaised > cap) {
870       toFund = cap.sub(weiRaised);
871     } else {
872       toFund = _weiAmount;
873     }
874     return toFund;
875   }
876 
877   /**
878    * @notice interface to initialize crowdsale parameters.
879    * init should be implemented by Crowdsale Generator.
880    */
881   function init(bytes32[] args) public;
882 
883   /**
884    * @notice pre hook for buyTokens function
885    * @param _beneficiary address address to receive tokens
886    * @param _toFund uint256 amount of ether in wei
887    */
888   function buyTokensPreHook(address _beneficiary, uint256 _toFund) internal {}
889 
890   /**
891    * @notice post hook for buyTokens function
892    * @param _beneficiary address address to receive tokens
893    * @param _tokens uint256 amount of tokens to receive
894    * @param _toFund uint256 amount of ether in wei
895    */
896   function buyTokensPostHook(address _beneficiary, uint256 _tokens, uint256 _toFund) internal {}
897 
898   function finalizationFailHook() internal {
899     vault.enableRefunds();
900   }
901 
902   function finalizationSuccessHook() internal {
903     // calculate target total supply including all token holders
904     uint256 targetTotalSupply = getTotalSupply().mul(coeff).div(crowdsaleRatio);
905     ERC20Basic token = ERC20Basic(getTokenAddress());
906 
907     super.distributeToken(token, targetTotalSupply);
908     afterGeneratorHook();
909 
910     locker.activate();
911     vault.close();
912 
913     transferTokenOwnership(nextTokenOwner);
914   }
915 
916   function afterGeneratorHook() internal {}
917 
918   /**
919    * @notice common interfaces for both of MiniMe and Mintable token.
920    */
921   function generateTokens(address _beneficiary, uint256 _tokens) internal;
922   function transferTokenOwnership(address _to) internal;
923   function getTotalSupply() internal returns (uint256);
924   function finishMinting() internal returns (bool);
925   function getTokenAddress() internal returns (address);
926 
927   /**
928    * @notice helper function to generate tokens with ratio
929    */
930   function generateTargetTokens(address _beneficiary, uint256 _targetTotalSupply, uint256 _ratio) internal {
931     uint256 tokens = _targetTotalSupply.mul(_ratio).div(coeff);
932     generateTokens(_beneficiary, tokens);
933   }
934 
935   /**
936    * @notice claim ERC20Basic compatible tokens
937    */
938   function claimTokens(ERC20Basic _token) external onlyOwner {
939     require(isFinalized);
940     uint256 balance = _token.balanceOf(this);
941     _token.transfer(owner, balance);
942     emit ClaimTokens(_token, balance);
943   }
944 
945   /**
946    * @notice Override HolderBase.deliverTokens
947    * @param _token ERC20Basic token contract
948    * @param _beneficiary Address to receive tokens
949    * @param _tokens Amount of tokens
950    */
951   function deliverTokens(ERC20Basic _token, address _beneficiary, uint256 _tokens) internal {
952     generateTokens(_beneficiary, _tokens);
953   }
954 
955 }
956 
957 
958 /**
959  * @title BlockIntervalCrowdsale
960  * @notice BlockIntervalCrowdsale limit purchaser to take participate too frequently.
961  */
962 contract BlockIntervalCrowdsale is BaseCrowdsale {
963   uint256 public blockInterval;
964   mapping (address => uint256) public recentBlock;
965 
966   function BlockIntervalCrowdsale(uint256 _blockInterval) public {
967     require(_blockInterval != 0);
968     blockInterval = _blockInterval;
969   }
970 
971   /**
972    * @return true if the block number is over the block internal.
973    */
974   function validPurchase() internal view returns (bool) {
975     bool withinBlock = recentBlock[msg.sender].add(blockInterval) < block.number;
976     return withinBlock && super.validPurchase();
977   }
978 
979   /**
980    * @notice save the block number
981    */
982   function buyTokensPreHook(address _beneficiary, uint256 _toFund) internal {
983     recentBlock[msg.sender] = block.number;
984     super.buyTokensPreHook(_beneficiary, _toFund);
985   }
986 }
987 
988 
989 // https://github.com/bitclave/crowdsale/blob/master/contracts/BonusCrowdsale.sol
990 
991 pragma solidity ^0.4.24;
992 
993 
994 
995 
996 
997 /**
998 * @dev Parent crowdsale contract with support for time-based and amount based bonuses
999 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
1000 *
1001 */
1002 contract BonusCrowdsale is BaseCrowdsale {
1003 
1004   // Constants
1005   // The following will be populated by main crowdsale contract
1006   uint32[] public BONUS_TIMES;
1007   uint32[] public BONUS_TIMES_VALUES;
1008   uint128[] public BONUS_AMOUNTS;
1009   uint32[] public BONUS_AMOUNTS_VALUES;
1010 
1011   /**
1012   * @dev Retrieve length of bonuses by time array
1013   * @return Bonuses by time array length
1014   */
1015   function bonusesForTimesCount() public view returns(uint) {
1016     return BONUS_TIMES.length;
1017   }
1018 
1019   /**
1020   * @dev Sets bonuses for time
1021   */
1022   function setBonusesForTimes(uint32[] times, uint32[] values) public onlyOwner {
1023     require(times.length == values.length);
1024     for (uint i = 0; i + 1 < times.length; i++) {
1025       require(times[i] < times[i+1]);
1026     }
1027 
1028     BONUS_TIMES = times;
1029     BONUS_TIMES_VALUES = values;
1030   }
1031 
1032   /**
1033   * @dev Retrieve length of bonuses by amounts array
1034   * @return Bonuses by amounts array length
1035   */
1036   function bonusesForAmountsCount() public view returns(uint) {
1037     return BONUS_AMOUNTS.length;
1038   }
1039 
1040   /**
1041   * @dev Sets bonuses for USD amounts
1042   */
1043   function setBonusesForAmounts(uint128[] amounts, uint32[] values) public onlyOwner {
1044     require(amounts.length == values.length);
1045     for (uint i = 0; i + 1 < amounts.length; i++) {
1046       require(amounts[i] > amounts[i+1]);
1047     }
1048 
1049     BONUS_AMOUNTS = amounts;
1050     BONUS_AMOUNTS_VALUES = values;
1051   }
1052 
1053   /**
1054   * @notice Overrided getTokenAmount function of parent Crowdsale contract
1055     to calculate the token with time and amount bonus.
1056   * @param weiAmount walelt of investor to receive tokens
1057   */
1058   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
1059     // Compute time and amount bonus
1060     uint256 bonus = computeBonus(weiAmount);
1061     uint256 rateWithBonus = rate.mul(coeff.add(bonus)).div(coeff);
1062     return weiAmount.mul(rateWithBonus);
1063   }
1064 
1065   /**
1066   * @dev Computes overall bonus based on time of contribution and amount of contribution.
1067   * The total bonus is the sum of bonus by time and bonus by amount
1068   * @return bonus percentage scaled by 10
1069   */
1070   function computeBonus(uint256 weiAmount) public view returns(uint256) {
1071     return computeAmountBonus(weiAmount).add(computeTimeBonus());
1072   }
1073 
1074   /**
1075   * @dev Computes bonus based on time of contribution relative to the beginning of crowdsale
1076   * @return bonus percentage scaled by 10
1077   */
1078   function computeTimeBonus() public view returns(uint256) {
1079     require(now >= startTime); // solium-disable-line security/no-block-members
1080 
1081     for (uint i = 0; i < BONUS_TIMES.length; i++) {
1082       if (now <= BONUS_TIMES[i]) { // solium-disable-line security/no-block-members
1083         return BONUS_TIMES_VALUES[i];
1084       }
1085     }
1086 
1087     return 0;
1088   }
1089 
1090   /**
1091   * @dev Computes bonus based on amount of contribution
1092   * @return bonus percentage scaled by 10
1093   */
1094   function computeAmountBonus(uint256 weiAmount) public view returns(uint256) {
1095     for (uint i = 0; i < BONUS_AMOUNTS.length; i++) {
1096       if (weiAmount >= BONUS_AMOUNTS[i]) {
1097         return BONUS_AMOUNTS_VALUES[i];
1098       }
1099     }
1100 
1101     return 0;
1102   }
1103 
1104 }
1105 
1106 
1107 /**
1108  * @title KYC
1109  * @dev KYC contract handles the white list for PLCCrowdsale contract
1110  * Only accounts registered in KYC contract can buy PLC token.
1111  * Admins can register account, and the reason why
1112  */
1113 contract KYC is Ownable {
1114   // check the address is registered for token sale
1115   mapping (address => bool) public registeredAddress;
1116 
1117   // check the address is admin of kyc contract
1118   mapping (address => bool) public admin;
1119 
1120   event Registered(address indexed _addr);
1121   event Unregistered(address indexed _addr);
1122   event SetAdmin(address indexed _addr, bool indexed _isAdmin);
1123 
1124   /**
1125    * @dev check whether the msg.sender is admin or not
1126    */
1127   modifier onlyAdmin() {
1128     require(admin[msg.sender]);
1129     _;
1130   }
1131 
1132   function KYC() public {
1133     admin[msg.sender] = true;
1134   }
1135 
1136   /**
1137    * @dev set new admin as admin of KYC contract
1138    * @param _addr address The address to set as admin of KYC contract
1139    */
1140   function setAdmin(address _addr, bool _isAdmin)
1141     public
1142     onlyOwner
1143   {
1144     require(_addr != address(0));
1145     admin[_addr] = _isAdmin;
1146 
1147     emit SetAdmin(_addr, _isAdmin);
1148   }
1149 
1150   /**
1151    * @dev register the address for token sale
1152    * @param _addr address The address to register for token sale
1153    */
1154   function register(address _addr)
1155     public
1156     onlyAdmin
1157   {
1158     require(_addr != address(0));
1159 
1160     registeredAddress[_addr] = true;
1161 
1162     emit Registered(_addr);
1163   }
1164 
1165   /**
1166    * @dev register the addresses for token sale
1167    * @param _addrs address[] The addresses to register for token sale
1168    */
1169   function registerByList(address[] _addrs)
1170     public
1171     onlyAdmin
1172   {
1173     for(uint256 i = 0; i < _addrs.length; i++) {
1174       require(_addrs[i] != address(0));
1175 
1176       registeredAddress[_addrs[i]] = true;
1177 
1178       emit Registered(_addrs[i]);
1179     }
1180   }
1181 
1182   /**
1183    * @dev unregister the registered address
1184    * @param _addr address The address to unregister for token sale
1185    */
1186   function unregister(address _addr)
1187     public
1188     onlyAdmin
1189   {
1190     registeredAddress[_addr] = false;
1191 
1192     emit Unregistered(_addr);
1193   }
1194 
1195   /**
1196    * @dev unregister the registered addresses
1197    * @param _addrs address[] The addresses to unregister for token sale
1198    */
1199   function unregisterByList(address[] _addrs)
1200     public
1201     onlyAdmin
1202   {
1203     for(uint256 i = 0; i < _addrs.length; i++) {
1204       registeredAddress[_addrs[i]] = false;
1205 
1206       emit Unregistered(_addrs[i]);
1207     }
1208   }
1209 }
1210 
1211 
1212 /**
1213  * @title KYCCrowdsale
1214  * @notice KYCCrowdsale checks kyc information and
1215  */
1216 contract KYCCrowdsale is BaseCrowdsale {
1217 
1218   KYC kyc;
1219 
1220   function KYCCrowdsale (address _kyc) public {
1221     require(_kyc != 0x0);
1222     kyc = KYC(_kyc);
1223   }
1224 
1225   function registered(address _addr) public view returns (bool) {
1226     return kyc.registeredAddress(_addr);
1227   }
1228 }
1229 
1230 
1231 contract Controlled {
1232     /// @notice The address of the controller is the only address that can call
1233     ///  a function with this modifier
1234     modifier onlyController { require(msg.sender == controller); _; }
1235 
1236     address public controller;
1237 
1238     function Controlled() public { controller = msg.sender;}
1239 
1240     /// @notice Changes the controller of the contract
1241     /// @param _newController The new controller of the contract
1242     function changeController(address _newController) public onlyController {
1243         controller = _newController;
1244     }
1245 }
1246 
1247 
1248 /// @dev The token controller contract must implement these functions
1249 contract TokenController {
1250     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
1251     /// @param _owner The address that sent the ether to create tokens
1252     /// @return True if the ether is accepted, false if it throws
1253     function proxyPayment(address _owner) public payable returns(bool);
1254 
1255     /// @notice Notifies the controller about a token transfer allowing the
1256     ///  controller to react if desired
1257     /// @param _from The origin of the transfer
1258     /// @param _to The destination of the transfer
1259     /// @param _amount The amount of the transfer
1260     /// @return False if the controller does not authorize the transfer
1261     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
1262 
1263     /// @notice Notifies the controller about an approval allowing the
1264     ///  controller to react if desired
1265     /// @param _owner The address that calls `approve()`
1266     /// @param _spender The spender in the `approve()` call
1267     /// @param _amount The amount in the `approve()` call
1268     /// @return False if the controller does not authorize the approval
1269     function onApprove(address _owner, address _spender, uint _amount) public
1270         returns(bool);
1271 }
1272 
1273 
1274 /*
1275     Copyright 2016, Jordi Baylina
1276 
1277     This program is free software: you can redistribute it and/or modify
1278     it under the terms of the GNU General Public License as published by
1279     the Free Software Foundation, either version 3 of the License, or
1280     (at your option) any later version.
1281 
1282     This program is distributed in the hope that it will be useful,
1283     but WITHOUT ANY WARRANTY; without even the implied warranty of
1284     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1285     GNU General Public License for more details.
1286 
1287     You should have received a copy of the GNU General Public License
1288     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1289  */
1290 
1291 /// @title MiniMeToken Contract
1292 /// @author Jordi Baylina
1293 /// @dev This token contract's goal is to make it easy for anyone to clone this
1294 ///  token using the token distribution at a given block, this will allow DAO's
1295 ///  and DApps to upgrade their features in a decentralized manner without
1296 ///  affecting the original token
1297 /// @dev It is ERC20 compliant, but still needs to under go further testing.
1298 
1299 
1300 
1301 contract ApproveAndCallFallBack {
1302     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
1303 }
1304 
1305 /// @dev The actual token contract, the default controller is the msg.sender
1306 ///  that deploys the contract, so usually this token will be deployed by a
1307 ///  token controller contract, which Giveth will call a "Campaign"
1308 contract MiniMeToken is Controlled {
1309 
1310     string public name;                //The Token's name: e.g. DigixDAO Tokens
1311     uint8 public decimals;             //Number of decimals of the smallest unit
1312     string public symbol;              //An identifier: e.g. REP
1313     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
1314 
1315 
1316     /// @dev `Checkpoint` is the structure that attaches a block number to a
1317     ///  given value, the block number attached is the one that last changed the
1318     ///  value
1319     struct  Checkpoint {
1320 
1321         // `fromBlock` is the block number that the value was generated from
1322         uint128 fromBlock;
1323 
1324         // `value` is the amount of tokens at a specific block number
1325         uint128 value;
1326     }
1327 
1328     // `parentToken` is the Token address that was cloned to produce this token;
1329     //  it will be 0x0 for a token that was not cloned
1330     MiniMeToken public parentToken;
1331 
1332     // `parentSnapShotBlock` is the block number from the Parent Token that was
1333     //  used to determine the initial distribution of the Clone Token
1334     uint public parentSnapShotBlock;
1335 
1336     // `creationBlock` is the block number that the Clone Token was created
1337     uint public creationBlock;
1338 
1339     // `balances` is the map that tracks the balance of each address, in this
1340     //  contract when the balance changes the block number that the change
1341     //  occurred is also included in the map
1342     mapping (address => Checkpoint[]) balances;
1343 
1344     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
1345     mapping (address => mapping (address => uint256)) allowed;
1346 
1347     // Tracks the history of the `totalSupply` of the token
1348     Checkpoint[] totalSupplyHistory;
1349 
1350     // Flag that determines if the token is transferable or not.
1351     bool public transfersEnabled;
1352 
1353     // The factory used to create new clone tokens
1354     MiniMeTokenFactory public tokenFactory;
1355 
1356 ////////////////
1357 // Constructor
1358 ////////////////
1359 
1360     /// @notice Constructor to create a MiniMeToken
1361     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
1362     ///  will create the Clone token contracts, the token factory needs to be
1363     ///  deployed first
1364     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
1365     ///  new token
1366     /// @param _parentSnapShotBlock Block of the parent token that will
1367     ///  determine the initial distribution of the clone token, set to 0 if it
1368     ///  is a new token
1369     /// @param _tokenName Name of the new token
1370     /// @param _decimalUnits Number of decimals of the new token
1371     /// @param _tokenSymbol Token Symbol for the new token
1372     /// @param _transfersEnabled If true, tokens will be able to be transferred
1373     function MiniMeToken(
1374         address _tokenFactory,
1375         address _parentToken,
1376         uint _parentSnapShotBlock,
1377         string _tokenName,
1378         uint8 _decimalUnits,
1379         string _tokenSymbol,
1380         bool _transfersEnabled
1381     ) public {
1382         tokenFactory = MiniMeTokenFactory(_tokenFactory);
1383         name = _tokenName;                                 // Set the name
1384         decimals = _decimalUnits;                          // Set the decimals
1385         symbol = _tokenSymbol;                             // Set the symbol
1386         parentToken = MiniMeToken(_parentToken);
1387         parentSnapShotBlock = _parentSnapShotBlock;
1388         transfersEnabled = _transfersEnabled;
1389         creationBlock = block.number;
1390     }
1391 
1392 
1393 ///////////////////
1394 // ERC20 Methods
1395 ///////////////////
1396 
1397     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
1398     /// @param _to The address of the recipient
1399     /// @param _amount The amount of tokens to be transferred
1400     /// @return Whether the transfer was successful or not
1401     function transfer(address _to, uint256 _amount) public returns (bool success) {
1402         require(transfersEnabled);
1403         return doTransfer(msg.sender, _to, _amount);
1404     }
1405 
1406     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1407     ///  is approved by `_from`
1408     /// @param _from The address holding the tokens being transferred
1409     /// @param _to The address of the recipient
1410     /// @param _amount The amount of tokens to be transferred
1411     /// @return True if the transfer was successful
1412     function transferFrom(address _from, address _to, uint256 _amount
1413     ) public returns (bool success) {
1414 
1415         // The controller of this contract can move tokens around at will,
1416         //  this is important to recognize! Confirm that you trust the
1417         //  controller of this contract, which in most situations should be
1418         //  another open source smart contract or 0x0
1419         if (msg.sender != controller) {
1420             require(transfersEnabled);
1421 
1422             // The standard ERC 20 transferFrom functionality
1423             if (allowed[_from][msg.sender] < _amount) return false;
1424             allowed[_from][msg.sender] -= _amount;
1425         }
1426         return doTransfer(_from, _to, _amount);
1427     }
1428 
1429     /// @dev This is the actual transfer function in the token contract, it can
1430     ///  only be called by other functions in this contract.
1431     /// @param _from The address holding the tokens being transferred
1432     /// @param _to The address of the recipient
1433     /// @param _amount The amount of tokens to be transferred
1434     /// @return True if the transfer was successful
1435     function doTransfer(address _from, address _to, uint _amount
1436     ) internal returns(bool) {
1437 
1438            if (_amount == 0) {
1439                return true;
1440            }
1441 
1442            require(parentSnapShotBlock < block.number);
1443 
1444            // Do not allow transfer to 0x0 or the token contract itself
1445            require((_to != 0) && (_to != address(this)));
1446 
1447            // If the amount being transfered is more than the balance of the
1448            //  account the transfer returns false
1449            var previousBalanceFrom = balanceOfAt(_from, block.number);
1450            if (previousBalanceFrom < _amount) {
1451                return false;
1452            }
1453 
1454            // Alerts the token controller of the transfer
1455            if (isContract(controller)) {
1456                require(TokenController(controller).onTransfer(_from, _to, _amount));
1457            }
1458 
1459            // First update the balance array with the new value for the address
1460            //  sending the tokens
1461            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
1462 
1463            // Then update the balance array with the new value for the address
1464            //  receiving the tokens
1465            var previousBalanceTo = balanceOfAt(_to, block.number);
1466            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
1467            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
1468 
1469            // An event to make the transfer easy to find on the blockchain
1470            Transfer(_from, _to, _amount);
1471 
1472            return true;
1473     }
1474 
1475     /// @param _owner The address that's balance is being requested
1476     /// @return The balance of `_owner` at the current block
1477     function balanceOf(address _owner) public constant returns (uint256 balance) {
1478         return balanceOfAt(_owner, block.number);
1479     }
1480 
1481     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1482     ///  its behalf. This is a modified version of the ERC20 approve function
1483     ///  to be a little bit safer
1484     /// @param _spender The address of the account able to transfer the tokens
1485     /// @param _amount The amount of tokens to be approved for transfer
1486     /// @return True if the approval was successful
1487     function approve(address _spender, uint256 _amount) public returns (bool success) {
1488         require(transfersEnabled);
1489 
1490         // To change the approve amount you first have to reduce the addresses`
1491         //  allowance to zero by calling `approve(_spender,0)` if it is not
1492         //  already 0 to mitigate the race condition described here:
1493         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1494         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
1495 
1496         // Alerts the token controller of the approve function call
1497         if (isContract(controller)) {
1498             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
1499         }
1500 
1501         allowed[msg.sender][_spender] = _amount;
1502         Approval(msg.sender, _spender, _amount);
1503         return true;
1504     }
1505 
1506     /// @dev This function makes it easy to read the `allowed[]` map
1507     /// @param _owner The address of the account that owns the token
1508     /// @param _spender The address of the account able to transfer the tokens
1509     /// @return Amount of remaining tokens of _owner that _spender is allowed
1510     ///  to spend
1511     function allowance(address _owner, address _spender
1512     ) public constant returns (uint256 remaining) {
1513         return allowed[_owner][_spender];
1514     }
1515 
1516     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
1517     ///  its behalf, and then a function is triggered in the contract that is
1518     ///  being approved, `_spender`. This allows users to use their tokens to
1519     ///  interact with contracts in one function call instead of two
1520     /// @param _spender The address of the contract able to transfer the tokens
1521     /// @param _amount The amount of tokens to be approved for transfer
1522     /// @return True if the function call was successful
1523     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
1524     ) public returns (bool success) {
1525         require(approve(_spender, _amount));
1526 
1527         ApproveAndCallFallBack(_spender).receiveApproval(
1528             msg.sender,
1529             _amount,
1530             this,
1531             _extraData
1532         );
1533 
1534         return true;
1535     }
1536 
1537     /// @dev This function makes it easy to get the total number of tokens
1538     /// @return The total number of tokens
1539     function totalSupply() public constant returns (uint) {
1540         return totalSupplyAt(block.number);
1541     }
1542 
1543 
1544 ////////////////
1545 // Query balance and totalSupply in History
1546 ////////////////
1547 
1548     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
1549     /// @param _owner The address from which the balance will be retrieved
1550     /// @param _blockNumber The block number when the balance is queried
1551     /// @return The balance at `_blockNumber`
1552     function balanceOfAt(address _owner, uint _blockNumber) public constant
1553         returns (uint) {
1554 
1555         // These next few lines are used when the balance of the token is
1556         //  requested before a check point was ever created for this token, it
1557         //  requires that the `parentToken.balanceOfAt` be queried at the
1558         //  genesis block for that token as this contains initial balance of
1559         //  this token
1560         if ((balances[_owner].length == 0)
1561             || (balances[_owner][0].fromBlock > _blockNumber)) {
1562             if (address(parentToken) != 0) {
1563                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
1564             } else {
1565                 // Has no parent
1566                 return 0;
1567             }
1568 
1569         // This will return the expected balance during normal situations
1570         } else {
1571             return getValueAt(balances[_owner], _blockNumber);
1572         }
1573     }
1574 
1575     /// @notice Total amount of tokens at a specific `_blockNumber`.
1576     /// @param _blockNumber The block number when the totalSupply is queried
1577     /// @return The total amount of tokens at `_blockNumber`
1578     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
1579 
1580         // These next few lines are used when the totalSupply of the token is
1581         //  requested before a check point was ever created for this token, it
1582         //  requires that the `parentToken.totalSupplyAt` be queried at the
1583         //  genesis block for this token as that contains totalSupply of this
1584         //  token at this block number.
1585         if ((totalSupplyHistory.length == 0)
1586             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
1587             if (address(parentToken) != 0) {
1588                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
1589             } else {
1590                 return 0;
1591             }
1592 
1593         // This will return the expected totalSupply during normal situations
1594         } else {
1595             return getValueAt(totalSupplyHistory, _blockNumber);
1596         }
1597     }
1598 
1599 ////////////////
1600 // Clone Token Method
1601 ////////////////
1602 
1603     /// @notice Creates a new clone token with the initial distribution being
1604     ///  this token at `_snapshotBlock`
1605     /// @param _cloneTokenName Name of the clone token
1606     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
1607     /// @param _cloneTokenSymbol Symbol of the clone token
1608     /// @param _snapshotBlock Block when the distribution of the parent token is
1609     ///  copied to set the initial distribution of the new clone token;
1610     ///  if the block is zero than the actual block, the current block is used
1611     /// @param _transfersEnabled True if transfers are allowed in the clone
1612     /// @return The address of the new MiniMeToken Contract
1613     function createCloneToken(
1614         string _cloneTokenName,
1615         uint8 _cloneDecimalUnits,
1616         string _cloneTokenSymbol,
1617         uint _snapshotBlock,
1618         bool _transfersEnabled
1619         ) public returns(address) {
1620         if (_snapshotBlock == 0) _snapshotBlock = block.number;
1621         MiniMeToken cloneToken = tokenFactory.createCloneToken(
1622             this,
1623             _snapshotBlock,
1624             _cloneTokenName,
1625             _cloneDecimalUnits,
1626             _cloneTokenSymbol,
1627             _transfersEnabled
1628             );
1629 
1630         cloneToken.changeController(msg.sender);
1631 
1632         // An event to make the token easy to find on the blockchain
1633         NewCloneToken(address(cloneToken), _snapshotBlock);
1634         return address(cloneToken);
1635     }
1636 
1637 ////////////////
1638 // Generate and destroy tokens
1639 ////////////////
1640 
1641     /// @notice Generates `_amount` tokens that are assigned to `_owner`
1642     /// @param _owner The address that will be assigned the new tokens
1643     /// @param _amount The quantity of tokens generated
1644     /// @return True if the tokens are generated correctly
1645     function generateTokens(address _owner, uint _amount
1646     ) public onlyController returns (bool) {
1647         uint curTotalSupply = totalSupply();
1648         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
1649         uint previousBalanceTo = balanceOf(_owner);
1650         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
1651         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
1652         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
1653         Transfer(0, _owner, _amount);
1654         return true;
1655     }
1656 
1657 
1658     /// @notice Burns `_amount` tokens from `_owner`
1659     /// @param _owner The address that will lose the tokens
1660     /// @param _amount The quantity of tokens to burn
1661     /// @return True if the tokens are burned correctly
1662     function destroyTokens(address _owner, uint _amount
1663     ) onlyController public returns (bool) {
1664         uint curTotalSupply = totalSupply();
1665         require(curTotalSupply >= _amount);
1666         uint previousBalanceFrom = balanceOf(_owner);
1667         require(previousBalanceFrom >= _amount);
1668         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
1669         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
1670         Transfer(_owner, 0, _amount);
1671         return true;
1672     }
1673 
1674 ////////////////
1675 // Enable tokens transfers
1676 ////////////////
1677 
1678 
1679     /// @notice Enables token holders to transfer their tokens freely if true
1680     /// @param _transfersEnabled True if transfers are allowed in the clone
1681     function enableTransfers(bool _transfersEnabled) public onlyController {
1682         transfersEnabled = _transfersEnabled;
1683     }
1684 
1685 ////////////////
1686 // Internal helper functions to query and set a value in a snapshot array
1687 ////////////////
1688 
1689     /// @dev `getValueAt` retrieves the number of tokens at a given block number
1690     /// @param checkpoints The history of values being queried
1691     /// @param _block The block number to retrieve the value at
1692     /// @return The number of tokens being queried
1693     function getValueAt(Checkpoint[] storage checkpoints, uint _block
1694     ) constant internal returns (uint) {
1695         if (checkpoints.length == 0) return 0;
1696 
1697         // Shortcut for the actual value
1698         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
1699             return checkpoints[checkpoints.length-1].value;
1700         if (_block < checkpoints[0].fromBlock) return 0;
1701 
1702         // Binary search of the value in the array
1703         uint min = 0;
1704         uint max = checkpoints.length-1;
1705         while (max > min) {
1706             uint mid = (max + min + 1)/ 2;
1707             if (checkpoints[mid].fromBlock<=_block) {
1708                 min = mid;
1709             } else {
1710                 max = mid-1;
1711             }
1712         }
1713         return checkpoints[min].value;
1714     }
1715 
1716     /// @dev `updateValueAtNow` used to update the `balances` map and the
1717     ///  `totalSupplyHistory`
1718     /// @param checkpoints The history of data being updated
1719     /// @param _value The new number of tokens
1720     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
1721     ) internal  {
1722         if ((checkpoints.length == 0)
1723         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
1724                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
1725                newCheckPoint.fromBlock =  uint128(block.number);
1726                newCheckPoint.value = uint128(_value);
1727            } else {
1728                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
1729                oldCheckPoint.value = uint128(_value);
1730            }
1731     }
1732 
1733     /// @dev Internal function to determine if an address is a contract
1734     /// @param _addr The address being queried
1735     /// @return True if `_addr` is a contract
1736     function isContract(address _addr) constant internal returns(bool) {
1737         uint size;
1738         if (_addr == 0) return false;
1739         assembly {
1740             size := extcodesize(_addr)
1741         }
1742         return size>0;
1743     }
1744 
1745     /// @dev Helper function to return a min betwen the two uints
1746     function min(uint a, uint b) pure internal returns (uint) {
1747         return a < b ? a : b;
1748     }
1749 
1750     /// @notice The fallback function: If the contract's controller has not been
1751     ///  set to 0, then the `proxyPayment` method is called which relays the
1752     ///  ether and creates tokens as described in the token controller contract
1753     function () public payable {
1754         require(isContract(controller));
1755         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
1756     }
1757 
1758 //////////
1759 // Safety Methods
1760 //////////
1761 
1762     /// @notice This method can be used by the controller to extract mistakenly
1763     ///  sent tokens to this contract.
1764     /// @param _token The address of the token contract that you want to recover
1765     ///  set to 0 in case you want to extract ether.
1766     function claimTokens(address _token) public onlyController {
1767         if (_token == 0x0) {
1768             controller.transfer(this.balance);
1769             return;
1770         }
1771 
1772         MiniMeToken token = MiniMeToken(_token);
1773         uint balance = token.balanceOf(this);
1774         token.transfer(controller, balance);
1775         ClaimedTokens(_token, controller, balance);
1776     }
1777 
1778 ////////////////
1779 // Events
1780 ////////////////
1781     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1782     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
1783     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
1784     event Approval(
1785         address indexed _owner,
1786         address indexed _spender,
1787         uint256 _amount
1788         );
1789 
1790 }
1791 
1792 
1793 ////////////////
1794 // MiniMeTokenFactory
1795 ////////////////
1796 
1797 /// @dev This contract is used to generate clone contracts from a contract.
1798 ///  In solidity this is the way to create a contract from a contract of the
1799 ///  same class
1800 contract MiniMeTokenFactory {
1801 
1802     /// @notice Update the DApp by creating a new token with new functionalities
1803     ///  the msg.sender becomes the controller of this clone token
1804     /// @param _parentToken Address of the token being cloned
1805     /// @param _snapshotBlock Block of the parent token that will
1806     ///  determine the initial distribution of the clone token
1807     /// @param _tokenName Name of the new token
1808     /// @param _decimalUnits Number of decimals of the new token
1809     /// @param _tokenSymbol Token Symbol for the new token
1810     /// @param _transfersEnabled If true, tokens will be able to be transferred
1811     /// @return The address of the new token contract
1812     function createCloneToken(
1813         address _parentToken,
1814         uint _snapshotBlock,
1815         string _tokenName,
1816         uint8 _decimalUnits,
1817         string _tokenSymbol,
1818         bool _transfersEnabled
1819     ) public returns (MiniMeToken) {
1820         MiniMeToken newToken = new MiniMeToken(
1821             this,
1822             _parentToken,
1823             _snapshotBlock,
1824             _tokenName,
1825             _decimalUnits,
1826             _tokenSymbol,
1827             _transfersEnabled
1828             );
1829 
1830         newToken.changeController(msg.sender);
1831         return newToken;
1832     }
1833 }
1834 
1835 
1836 /**
1837  * @title NoMintMiniMeToken
1838  * @dev Token that can be irreversibly burned (destroyed).
1839  */
1840 contract NoMintMiniMeToken is MiniMeToken {
1841   event MintFinished();
1842   bool public mintingFinished = false;
1843 
1844   modifier canMint() {
1845     require(!mintingFinished);
1846     _;
1847   }
1848 
1849   function generateTokens(address _owner, uint _amount) public onlyController canMint returns (bool) {
1850     return super.generateTokens(_owner, _amount);
1851   }
1852 
1853   /**
1854    * @dev Function to stop minting new tokens.
1855    * @return True if the operation was successful.
1856    */
1857   function finishMinting() public onlyController canMint returns (bool) {
1858     mintingFinished = true;
1859     emit MintFinished();
1860     return true;
1861   }
1862 }
1863 
1864 
1865 contract MiniMeBaseCrowdsale is BaseCrowdsale {
1866 
1867   MiniMeToken token;
1868 
1869   function MiniMeBaseCrowdsale (address _token) public {
1870     require(_token != address(0));
1871     token = MiniMeToken(_token);
1872   }
1873 
1874 
1875   function generateTokens(address _beneficiary, uint256 _tokens) internal {
1876     token.generateTokens(_beneficiary, _tokens);
1877   }
1878 
1879   function transferTokenOwnership(address _to) internal {
1880     token.changeController(_to);
1881   }
1882 
1883   function getTotalSupply() internal returns (uint256) {
1884     return token.totalSupply();
1885   }
1886 
1887   function finishMinting() internal returns (bool) {
1888     require(NoMintMiniMeToken(token).finishMinting());
1889     return true;
1890   }
1891 
1892   function getTokenAddress() internal returns (address) {
1893     return address(token);
1894   }
1895 }
1896 
1897 
1898 /**
1899  * @title StagedCrowdsale
1900  * @notice StagedCrowdsale seperates sale period with start time & end time.
1901  * For each period, seperate max cap and kyc could be setup.
1902  * Both startTime and endTime are inclusive.
1903  */
1904 contract StagedCrowdsale is KYCCrowdsale {
1905 
1906   uint8 public numPeriods;
1907 
1908   Stage[] public stages;
1909 
1910   struct Stage {
1911     uint128 cap;
1912     uint128 maxPurchaseLimit;
1913     uint128 minPurchaseLimit;
1914     uint128 weiRaised; // stage's weiAmount raised
1915     uint32 startTime;
1916     uint32 endTime;
1917     bool kyc;
1918   }
1919 
1920   function StagedCrowdsale(uint _numPeriods) public {
1921     numPeriods = uint8(_numPeriods);
1922     require(numPeriods > 0);
1923   }
1924 
1925   function initStages(
1926     uint32[] _startTimes,
1927     uint32[] _endTimes,
1928     uint128[] _capRatios,
1929     uint128[] _maxPurchaseLimits,
1930     uint128[] _minPurchaseLimits,
1931     bool[] _kycs)
1932     public
1933   {
1934     uint len = numPeriods;
1935 
1936     require(stages.length == 0);
1937     // solium-disable
1938     require(len == _startTimes.length &&
1939       len == _endTimes.length &&
1940       len == _capRatios.length &&
1941       len == _maxPurchaseLimits.length &&
1942       len == _minPurchaseLimits.length &&
1943       len == _kycs.length);
1944     // solium-enable
1945 
1946     for (uint i = 0; i < len; i++) {
1947       require(_endTimes[i] >= _startTimes[i]);
1948 
1949       uint stageCap;
1950 
1951       if (_capRatios[i] != 0) {
1952         stageCap = cap.mul(uint(_capRatios[i])).div(coeff);
1953       } else {
1954         stageCap = 0;
1955       }
1956 
1957       stages.push(Stage({
1958         startTime: _startTimes[i],
1959         endTime: _endTimes[i],
1960         cap: uint128(stageCap),
1961         maxPurchaseLimit: _maxPurchaseLimits[i],
1962         minPurchaseLimit: _minPurchaseLimits[i],
1963         kyc: _kycs[i],
1964         weiRaised: 0
1965       }));
1966     }
1967 
1968     require(validPeriods());
1969   }
1970 
1971   /**
1972    * @notice if period is on sale, return index of the period.
1973    */
1974   function getStageIndex() public view returns (uint8 currentStage, bool onSale) {
1975     onSale = true;
1976     Stage memory p;
1977 
1978     for (currentStage = 0; currentStage < stages.length; currentStage++) {
1979       p = stages[currentStage];
1980       if (p.startTime <= now && now <= p.endTime) {
1981         return;
1982       }
1983     }
1984 
1985     onSale = false;
1986   }
1987 
1988   /**
1989    * @notice return if all period is finished.
1990    */
1991   function saleFinished() public view returns (bool) {
1992     require(stages.length == numPeriods);
1993     return stages[stages.length - 1].endTime < now;
1994   }
1995 
1996 
1997   function validPeriods() internal view returns (bool) {
1998     if (stages.length != numPeriods) {
1999       return false;
2000     }
2001 
2002     // check stages are overlapped.
2003     for (uint8 i = 0; i < stages.length - 1; i++) {
2004       if (stages[i].endTime >= stages[i + 1].startTime) {
2005         return false;
2006       }
2007     }
2008 
2009     return true;
2010   }
2011 
2012   /**
2013    * @notice Override BaseCrowdsale.calculateToFund function.
2014    * Check if period is on sale and apply cap if needed.
2015    */
2016   function calculateToFund(address _beneficiary, uint256 _weiAmount) internal view returns (uint256) {
2017     uint256 weiAmount = _weiAmount;
2018     uint8 currentStage;
2019     bool onSale;
2020 
2021     (currentStage, onSale) = getStageIndex();
2022 
2023     require(onSale);
2024 
2025     Stage memory p = stages[currentStage];
2026 
2027     // Check kyc if needed for this period
2028     if (p.kyc) {
2029       require(super.registered(_beneficiary));
2030     }
2031 
2032     // check min purchase limit of the period
2033     require(weiAmount >= uint(p.minPurchaseLimit));
2034 
2035     // reduce up to max purchase limit of the period
2036     if (p.maxPurchaseLimit != 0 && weiAmount > uint(p.maxPurchaseLimit)) {
2037       weiAmount = uint(p.maxPurchaseLimit);
2038     }
2039 
2040     // pre-calculate `toFund` with the period's cap
2041     if (p.cap > 0) {
2042       uint256 postWeiRaised = uint256(p.weiRaised).add(weiAmount);
2043 
2044       if (postWeiRaised > p.cap) {
2045         weiAmount = uint256(p.cap).sub(p.weiRaised);
2046       }
2047     }
2048 
2049     // get `toFund` with the cap of the sale
2050     return super.calculateToFund(_beneficiary, weiAmount);
2051   }
2052 
2053   function buyTokensPreHook(address _beneficiary, uint256 _toFund) internal {
2054     uint8 currentStage;
2055     bool onSale;
2056 
2057     (currentStage, onSale) = getStageIndex();
2058 
2059     require(onSale);
2060 
2061     Stage storage p = stages[currentStage];
2062 
2063     p.weiRaised = uint128(_toFund.add(uint256(p.weiRaised)));
2064     super.buyTokensPreHook(_beneficiary, _toFund);
2065   }
2066 }
2067 
2068 
2069 pragma solidity^0.4.18;
2070 
2071 
2072 
2073 
2074 
2075 
2076 
2077 contract RankingBallGoldCrowdsale is BaseCrowdsale, MiniMeBaseCrowdsale, BonusCrowdsale, BlockIntervalCrowdsale, KYCCrowdsale, StagedCrowdsale {
2078 
2079   bool public initialized;
2080 
2081   // constructor parameters are left padded bytes32.
2082 
2083   function RankingBallGoldCrowdsale(bytes32[5] args) 
2084     BaseCrowdsale(
2085       parseUint(args[0]))
2086     MiniMeBaseCrowdsale(
2087       parseAddress(args[1]))
2088     BonusCrowdsale()
2089     BlockIntervalCrowdsale(
2090       parseUint(args[2]))
2091     KYCCrowdsale(
2092       parseAddress(args[3]))
2093     StagedCrowdsale(
2094       parseUint(args[4])) public {}
2095   
2096 
2097   function parseBool(bytes32 b) internal pure returns (bool) {
2098     return b == 0x1;
2099   }
2100 
2101   function parseUint(bytes32 b) internal pure returns (uint) {
2102     return uint(b);
2103   }
2104 
2105   function parseAddress(bytes32 b) internal pure returns (address) {
2106     return address(b & 0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff);
2107   }
2108 
2109   function init(bytes32[] args) public {
2110     uint _startTime = uint(args[0]);
2111     uint _endTime = uint(args[1]);
2112     uint _rate = uint(args[2]);
2113     uint _cap = uint(args[3]);
2114     uint _goal = uint(args[4]);
2115     uint _crowdsaleRatio = uint(args[5]);
2116     address _vault = address(args[6]);
2117     address _locker = address(args[7]);
2118     address _nextTokenOwner = address(args[8]);
2119 
2120     require(_endTime > _startTime);
2121     require(_rate > 0);
2122     require(_cap > 0);
2123     require(_goal > 0);
2124     require(_cap > _goal);
2125     require(_crowdsaleRatio > 0);
2126     require(_vault != address(0));
2127     require(_locker != address(0));
2128     require(_nextTokenOwner != address(0));
2129     
2130     startTime = _startTime;
2131     endTime = _endTime;
2132     rate = _rate;
2133     cap = _cap;
2134     goal = _goal;
2135     crowdsaleRatio = _crowdsaleRatio;
2136     vault = MultiHolderVault(_vault);
2137     locker = Locker(_locker);
2138     nextTokenOwner = _nextTokenOwner;
2139   }
2140 }