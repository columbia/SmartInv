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
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    */
90   function renounceOwnership() public onlyOwner {
91     emit OwnershipRenounced(owner);
92     owner = address(0);
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address _newOwner) public onlyOwner {
100     _transferOwnership(_newOwner);
101   }
102 
103   /**
104    * @dev Transfers control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function _transferOwnership(address _newOwner) internal {
108     require(_newOwner != address(0));
109     emit OwnershipTransferred(owner, _newOwner);
110     owner = _newOwner;
111   }
112 }
113 
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 
128 /**
129  * @title HolderBase
130  * @notice HolderBase handles data & funcitons for token or ether holders.
131  * HolderBase contract can distribute only one of ether or token.
132  */
133 contract HolderBase is Ownable {
134   using SafeMath for uint256;
135 
136   uint8 public constant MAX_HOLDERS = 64; // TODO: tokyo-input should verify # of holders
137   uint256 public coeff;
138   bool public distributed;
139   bool public initialized;
140 
141   struct Holder {
142     address addr;
143     uint96 ratio;
144   }
145 
146   Holder[] public holders;
147 
148   event Distributed();
149 
150   function HolderBase(uint256 _coeff) public {
151     require(_coeff != 0);
152     coeff = _coeff;
153   }
154 
155   function getHolderCount() public view returns (uint256) {
156     return holders.length;
157   }
158 
159   function initHolders(address[] _addrs, uint96[] _ratios) public onlyOwner {
160     require(!initialized);
161     require(holders.length == 0);
162     require(_addrs.length != 0);
163     require(_addrs.length <= MAX_HOLDERS);
164     require(_addrs.length == _ratios.length);
165 
166     uint256 accRatio;
167 
168     for(uint8 i = 0; i < _addrs.length; i++) {
169       if (_addrs[i] != address(0)) {
170         // address will be 0x00 in case of "crowdsale".
171         holders.push(Holder(_addrs[i], _ratios[i]));
172       }
173 
174       accRatio = accRatio.add(uint256(_ratios[i]));
175     }
176 
177     require(accRatio <= coeff);
178 
179     initialized = true;
180   }
181 
182   /**
183    * @dev Distribute ether to `holder`s according to ratio.
184    * Remaining ether is transfered to `wallet` from the close
185    * function of RefundVault contract.
186    */
187   function distribute() internal {
188     require(!distributed, "Already distributed");
189     uint256 balance = this.balance;
190 
191     require(balance > 0, "No ether to distribute");
192     distributed = true;
193 
194     for (uint8 i = 0; i < holders.length; i++) {
195       uint256 holderAmount = balance.mul(uint256(holders[i].ratio)).div(coeff);
196 
197       holders[i].addr.transfer(holderAmount);
198     }
199 
200     emit Distributed(); // A single log to reduce gas
201   }
202 
203   /**
204    * @dev Distribute ERC20 token to `holder`s according to ratio.
205    */
206   function distributeToken(ERC20Basic _token, uint256 _targetTotalSupply) internal {
207     require(!distributed, "Already distributed");
208     distributed = true;
209 
210     for (uint8 i = 0; i < holders.length; i++) {
211       uint256 holderAmount = _targetTotalSupply.mul(uint256(holders[i].ratio)).div(coeff);
212       deliverTokens(_token, holders[i].addr, holderAmount);
213     }
214 
215     emit Distributed(); // A single log to reduce gas
216   }
217 
218   // Override to distribute tokens
219   function deliverTokens(ERC20Basic _token, address _beneficiary, uint256 _tokens) internal {}
220 }
221 
222 
223 /**
224  * @title ERC20 interface
225  * @dev see https://github.com/ethereum/EIPs/issues/20
226  */
227 contract ERC20 is ERC20Basic {
228   function allowance(address owner, address spender)
229     public view returns (uint256);
230 
231   function transferFrom(address from, address to, uint256 value)
232     public returns (bool);
233 
234   function approve(address spender, uint256 value) public returns (bool);
235   event Approval(
236     address indexed owner,
237     address indexed spender,
238     uint256 value
239   );
240 }
241 
242 
243 /**
244  * @title SafeERC20
245  * @dev Wrappers around ERC20 operations that throw on failure.
246  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
247  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
248  */
249 library SafeERC20 {
250   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
251     require(token.transfer(to, value));
252   }
253 
254   function safeTransferFrom(
255     ERC20 token,
256     address from,
257     address to,
258     uint256 value
259   )
260     internal
261   {
262     require(token.transferFrom(from, to, value));
263   }
264 
265   function safeApprove(ERC20 token, address spender, uint256 value) internal {
266     require(token.approve(spender, value));
267   }
268 }
269 
270 
271 /**
272  * @title Locker
273  * @notice Locker holds tokens and releases them at a certain time.
274  */
275 contract Locker is Ownable {
276   using SafeMath for uint;
277   using SafeERC20 for ERC20Basic;
278 
279   /**
280    * It is init state only when adding release info is possible.
281    * beneficiary only can release tokens when Locker is active.
282    * After all tokens are released, locker is drawn.
283    */
284   enum State { Init, Ready, Active, Drawn }
285 
286   struct Beneficiary {
287     uint ratio;             // ratio based on Locker's initial balance.
288     uint withdrawAmount;    // accumulated tokens beneficiary released
289     bool releaseAllTokens;
290   }
291 
292   /**
293    * @notice Release has info to release tokens.
294    * If lock type is straight, only two release infos is required.
295    *
296    *     |
297    * 100 |                _______________
298    *     |              _/
299    *  50 |            _/
300    *     |         . |
301    *     |       .   |
302    *     |     .     |
303    *     +===+=======+----*----------> time
304    *     Locker  First    Last
305    *  Activated  Release  Release
306    *
307    *
308    * If lock type is variable, the release graph will be
309    *
310    *     |
311    * 100 |                                 _________
312    *     |                                |
313    *  70 |                      __________|
314    *     |                     |
315    *  30 |            _________|
316    *     |           |
317    *     +===+=======+---------+----------*------> time
318    *     Locker   First        Second     Last
319    *  Activated   Release      Release    Release
320    *
321    *
322    *
323    * For the first straight release graph, parameters would be
324    *   coeff: 100
325    *   releaseTimes: [
326    *     first release time,
327    *     second release time
328    *   ]
329    *   releaseRatios: [
330    *     50,
331    *     100,
332    *   ]
333    *
334    * For the second variable release graph, parameters would be
335    *   coeff: 100
336    *   releaseTimes: [
337    *     first release time,
338    *     second release time,
339    *     last release time
340    *   ]
341    *   releaseRatios: [
342    *     30,
343    *     70,
344    *     100,
345    *   ]
346    *
347    */
348   struct Release {
349     bool isStraight;        // lock type : straight or variable
350     uint[] releaseTimes;    //
351     uint[] releaseRatios;   //
352   }
353 
354   uint public activeTime;
355 
356   // ERC20 basic token contract being held
357   ERC20Basic public token;
358 
359   uint public coeff;
360   uint public initialBalance;
361   uint public withdrawAmount; // total amount of tokens released
362 
363   mapping (address => Beneficiary) public beneficiaries;
364   mapping (address => Release) public releases;  // beneficiary's lock
365   mapping (address => bool) public locked; // whether beneficiary's lock is instantiated
366 
367   uint public numBeneficiaries;
368   uint public numLocks;
369 
370   State public state;
371 
372   modifier onlyState(State v) {
373     require(state == v);
374     _;
375   }
376 
377   modifier onlyBeneficiary(address _addr) {
378     require(beneficiaries[_addr].ratio > 0);
379     _;
380   }
381 
382   event StateChanged(State _state);
383   event Locked(address indexed _beneficiary, bool _isStraight);
384   event Released(address indexed _beneficiary, uint256 _amount);
385 
386   function Locker(address _token, uint _coeff, address[] _beneficiaries, uint[] _ratios) public {
387     require(_token != address(0));
388     require(_beneficiaries.length == _ratios.length);
389 
390     token = ERC20Basic(_token);
391     coeff = _coeff;
392     numBeneficiaries = _beneficiaries.length;
393 
394     uint accRatio;
395 
396     for(uint i = 0; i < numBeneficiaries; i++) {
397       require(_ratios[i] > 0);
398       beneficiaries[_beneficiaries[i]].ratio = _ratios[i];
399 
400       accRatio = accRatio.add(_ratios[i]);
401     }
402 
403     require(coeff == accRatio);
404   }
405 
406   /**
407    * @notice beneficiary can release their tokens after activated
408    */
409   function activate() external onlyOwner onlyState(State.Ready) {
410     require(numLocks == numBeneficiaries); // double check : assert all releases are recorded
411 
412     initialBalance = token.balanceOf(this);
413     require(initialBalance > 0);
414 
415     activeTime = now; // solium-disable-line security/no-block-members
416 
417     // set locker as active state
418     state = State.Active;
419     emit StateChanged(state);
420   }
421 
422   function getReleaseType(address _beneficiary)
423     public
424     view
425     onlyBeneficiary(_beneficiary)
426     returns (bool)
427   {
428     return releases[_beneficiary].isStraight;
429   }
430 
431   function getTotalLockedAmounts(address _beneficiary)
432     public
433     view
434     onlyBeneficiary(_beneficiary)
435     returns (uint)
436   {
437     return getPartialAmount(beneficiaries[_beneficiary].ratio, coeff, initialBalance);
438   }
439 
440   function getReleaseTimes(address _beneficiary)
441     public
442     view
443     onlyBeneficiary(_beneficiary)
444     returns (uint[])
445   {
446     return releases[_beneficiary].releaseTimes;
447   }
448 
449   function getReleaseRatios(address _beneficiary)
450     public
451     view
452     onlyBeneficiary(_beneficiary)
453     returns (uint[])
454   {
455     return releases[_beneficiary].releaseRatios;
456   }
457 
458   /**
459    * @notice add new release record for beneficiary
460    */
461   function lock(address _beneficiary, bool _isStraight, uint[] _releaseTimes, uint[] _releaseRatios)
462     external
463     onlyOwner
464     onlyState(State.Init)
465     onlyBeneficiary(_beneficiary)
466   {
467     require(!locked[_beneficiary]);
468     require(_releaseRatios.length != 0);
469     require(_releaseRatios.length == _releaseTimes.length);
470 
471     uint i;
472     uint len = _releaseRatios.length;
473 
474     // finally should release all tokens
475     require(_releaseRatios[len - 1] == coeff);
476 
477     // check two array are ascending sorted
478     for(i = 0; i < len - 1; i++) {
479       require(_releaseTimes[i] < _releaseTimes[i + 1]);
480       require(_releaseRatios[i] < _releaseRatios[i + 1]);
481     }
482 
483     // 2 release times for straight locking type
484     if (_isStraight) {
485       require(len == 2);
486     }
487 
488     numLocks = numLocks.add(1);
489 
490     // create Release for the beneficiary
491     releases[_beneficiary].isStraight = _isStraight;
492 
493     // copy array of uint
494     releases[_beneficiary].releaseTimes = _releaseTimes;
495     releases[_beneficiary].releaseRatios = _releaseRatios;
496 
497     // lock beneficiary
498     locked[_beneficiary] = true;
499     emit Locked(_beneficiary, _isStraight);
500 
501     //  if all beneficiaries locked, change Locker state to change
502     if (numLocks == numBeneficiaries) {
503       state = State.Ready;
504       emit StateChanged(state);
505     }
506   }
507 
508   /**
509    * @notice transfer releasable tokens for beneficiary wrt the release graph
510    */
511   function release() external onlyState(State.Active) onlyBeneficiary(msg.sender) {
512     require(!beneficiaries[msg.sender].releaseAllTokens);
513 
514     uint releasableAmount = getReleasableAmount(msg.sender);
515     beneficiaries[msg.sender].withdrawAmount = beneficiaries[msg.sender].withdrawAmount.add(releasableAmount);
516 
517     beneficiaries[msg.sender].releaseAllTokens = beneficiaries[msg.sender].withdrawAmount == getPartialAmount(
518       beneficiaries[msg.sender].ratio,
519       coeff,
520       initialBalance);
521 
522     withdrawAmount = withdrawAmount.add(releasableAmount);
523 
524     if (withdrawAmount == initialBalance) {
525       state = State.Drawn;
526       emit StateChanged(state);
527     }
528 
529     token.transfer(msg.sender, releasableAmount);
530     emit Released(msg.sender, releasableAmount);
531   }
532 
533   function getReleasableAmount(address _beneficiary) internal view returns (uint) {
534     if (releases[_beneficiary].isStraight) {
535       return getStraightReleasableAmount(_beneficiary);
536     } else {
537       return getVariableReleasableAmount(_beneficiary);
538     }
539   }
540 
541   /**
542    * @notice return releaseable amount for beneficiary in case of straight type of release
543    */
544   function getStraightReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {
545     Beneficiary memory _b = beneficiaries[_beneficiary];
546     Release memory _r = releases[_beneficiary];
547 
548     // total amount of tokens beneficiary can release
549     uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);
550 
551     uint firstTime = _r.releaseTimes[0];
552     uint lastTime = _r.releaseTimes[1];
553 
554     // solium-disable security/no-block-members
555     require(now >= firstTime); // pass if can release
556     // solium-enable security/no-block-members
557 
558     if(now >= lastTime) { // inclusive to reduce calculation
559       releasableAmount = totalReleasableAmount;
560     } else {
561       // releasable amount at first time
562       uint firstAmount = getPartialAmount(
563         _r.releaseRatios[0],
564         coeff,
565         totalReleasableAmount);
566 
567       // partial amount without first amount
568       releasableAmount = getPartialAmount(
569         now.sub(firstTime),
570         lastTime.sub(firstTime),
571         totalReleasableAmount.sub(firstAmount));
572       releasableAmount = releasableAmount.add(firstAmount);
573     }
574 
575     // subtract already withdrawn amounts
576     releasableAmount = releasableAmount.sub(_b.withdrawAmount);
577   }
578 
579   /**
580    * @notice return releaseable amount for beneficiary in case of variable type of release
581    */
582   function getVariableReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {
583     Beneficiary memory _b = beneficiaries[_beneficiary];
584     Release memory _r = releases[_beneficiary];
585 
586     // total amount of tokens beneficiary will receive
587     uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);
588 
589     uint releaseRatio;
590 
591     // reverse order for short curcit
592     for(uint i = _r.releaseTimes.length - 1; i >= 0; i--) {
593       if (now >= _r.releaseTimes[i]) {
594         releaseRatio = _r.releaseRatios[i];
595         break;
596       }
597     }
598 
599     require(releaseRatio > 0);
600 
601     releasableAmount = getPartialAmount(
602       releaseRatio,
603       coeff,
604       totalReleasableAmount);
605     releasableAmount = releasableAmount.sub(_b.withdrawAmount);
606   }
607 
608   /// https://github.com/0xProject/0x.js/blob/05aae368132a81ddb9fd6a04ac5b0ff1cbb24691/packages/contracts/src/current/protocol/Exchange/Exchange.sol#L497
609   /// @notice Calculates partial value given a numerator and denominator.
610   /// @param numerator Numerator.
611   /// @param denominator Denominator.
612   /// @param target Value to calculate partial of.
613   /// @return Partial value of target.
614   function getPartialAmount(uint numerator, uint denominator, uint target) public pure returns (uint) {
615     return numerator.mul(target).div(denominator);
616   }
617 }
618 
619 
620 /**
621  * @title RefundVault
622  * @dev This contract is used for storing funds while a crowdsale
623  * is in progress. Supports refunding the money if crowdsale fails,
624  * and forwarding it if crowdsale is successful.
625  */
626 contract RefundVault is Ownable {
627   using SafeMath for uint256;
628 
629   enum State { Active, Refunding, Closed }
630 
631   mapping (address => uint256) public deposited;
632   address public wallet;
633   State public state;
634 
635   event Closed();
636   event RefundsEnabled();
637   event Refunded(address indexed beneficiary, uint256 weiAmount);
638 
639   /**
640    * @param _wallet Vault address
641    */
642   constructor(address _wallet) public {
643     require(_wallet != address(0));
644     wallet = _wallet;
645     state = State.Active;
646   }
647 
648   /**
649    * @param investor Investor address
650    */
651   function deposit(address investor) onlyOwner public payable {
652     require(state == State.Active);
653     deposited[investor] = deposited[investor].add(msg.value);
654   }
655 
656   function close() onlyOwner public {
657     require(state == State.Active);
658     state = State.Closed;
659     emit Closed();
660     wallet.transfer(address(this).balance);
661   }
662 
663   function enableRefunds() onlyOwner public {
664     require(state == State.Active);
665     state = State.Refunding;
666     emit RefundsEnabled();
667   }
668 
669   /**
670    * @param investor Investor address
671    */
672   function refund(address investor) public {
673     require(state == State.Refunding);
674     uint256 depositedValue = deposited[investor];
675     deposited[investor] = 0;
676     investor.transfer(depositedValue);
677     emit Refunded(investor, depositedValue);
678   }
679 }
680 
681 
682 /**
683  * @title MultiHolderVault
684  * @dev This contract distribute ether to multiple address.
685  */
686 contract MultiHolderVault is HolderBase, RefundVault {
687   using SafeMath for uint256;
688 
689   function MultiHolderVault(address _wallet, uint256 _ratioCoeff)
690     public
691     HolderBase(_ratioCoeff)
692     RefundVault(_wallet)
693   {}
694 
695   function close() public onlyOwner {
696     require(state == State.Active);
697     require(initialized);
698 
699     super.distribute(); // distribute ether to holders
700     super.close(); // transfer remaining ether to wallet
701   }
702 }
703 
704 
705 /**
706  * @title Pausable
707  * @dev Base contract which allows children to implement an emergency stop mechanism.
708  */
709 contract Pausable is Ownable {
710   event Pause();
711   event Unpause();
712 
713   bool public paused = false;
714 
715 
716   /**
717    * @dev Modifier to make a function callable only when the contract is not paused.
718    */
719   modifier whenNotPaused() {
720     require(!paused);
721     _;
722   }
723 
724   /**
725    * @dev Modifier to make a function callable only when the contract is paused.
726    */
727   modifier whenPaused() {
728     require(paused);
729     _;
730   }
731 
732   /**
733    * @dev called by the owner to pause, triggers stopped state
734    */
735   function pause() onlyOwner whenNotPaused public {
736     paused = true;
737     emit Pause();
738   }
739 
740   /**
741    * @dev called by the owner to unpause, returns to normal state
742    */
743   function unpause() onlyOwner whenPaused public {
744     paused = false;
745     emit Unpause();
746   }
747 }
748 
749 
750 contract BaseCrowdsale is HolderBase, Pausable {
751   using SafeMath for uint256;
752 
753   Locker public locker;     // token locker
754 
755   // start and end timestamps where investments are allowed (both inclusive)
756   uint256 public startTime;
757   uint256 public endTime;
758 
759   // how many token units a buyer gets per wei
760   // use coeff ratio from HolderBase
761   uint256 public rate;
762 
763 
764   // amount of raised money in wei
765   uint256 public weiRaised;
766 
767   // ratio of tokens for crowdsale
768   uint256 public crowdsaleRatio;
769 
770   bool public isFinalized = false;
771 
772   uint256 public cap;
773 
774   // minimum amount of funds to be raised in weis
775   uint256 public goal;
776 
777   // refund vault used to hold funds while crowdsale is running
778   MultiHolderVault public vault;
779 
780   address public nextTokenOwner;
781 
782   /**
783    * event for token purchase logging
784    * @param purchaser who paid for the tokens
785    * @param beneficiary who got the tokens
786    * @param value weis paid for purchase
787    * @param amount amount of tokens purchased
788    */
789   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
790   event Finalized();
791   event ClaimTokens(address indexed _token, uint256 _amount);
792 
793   function BaseCrowdsale(uint256 _coeff) HolderBase(_coeff) public {}
794 
795   // fallback function can be used to buy tokens
796   function () external payable {
797     buyTokens(msg.sender);
798   }
799 
800   function buyTokens(address beneficiary) public payable whenNotPaused {
801     require(beneficiary != address(0));
802     require(validPurchase());
803 
804     uint256 weiAmount = msg.value;
805 
806     uint256 toFund = calculateToFund(beneficiary, weiAmount);
807     require(toFund > 0);
808 
809     uint256 toReturn = weiAmount.sub(toFund);
810 
811     buyTokensPreHook(beneficiary, toFund);
812 
813     // calculate token amount to be created
814     uint256 tokens = getTokenAmount(toFund);
815 
816     // update state
817     weiRaised = weiRaised.add(toFund);
818 
819     if (toReturn > 0) {
820       msg.sender.transfer(toReturn);
821     }
822 
823     buyTokensPostHook(beneficiary, tokens, toFund);
824 
825     generateTokens(beneficiary, tokens);
826     emit TokenPurchase(msg.sender, beneficiary, toFund, tokens);
827     forwardFunds(toFund);
828   }
829 
830   /**
831    * @dev Must be called after crowdsale ends, to do some extra finalization
832    * work. Calls the contract's finalization function.
833    */
834   function finalize() onlyOwner public {
835     require(!isFinalized);
836     require(hasEnded());
837 
838     finalization();
839     emit Finalized();
840 
841     isFinalized = true;
842   }
843 
844 
845   // vault finalization task, called when owner calls finalize()
846   function finalization() internal {
847     if (goalReached()) {
848       finalizationSuccessHook();
849     } else {
850       finalizationFailHook();
851     }
852   }
853 
854   // if crowdsale is unsuccessful, investors can claim refunds here
855   function claimRefund() public {
856     require(isFinalized);
857     require(!goalReached());
858 
859     vault.refund(msg.sender);
860   }
861 
862   function goalReached() public view returns (bool) {
863     return weiRaised >= goal;
864   }
865 
866   /// @return true if crowdsale event has ended
867   function hasEnded() public view returns (bool) {
868     bool capReached = weiRaised >= cap;
869     return capReached || now > endTime; // solium-disable-line security/no-block-members
870   }
871 
872   // Override this method to have a way to add business logic to your crowdsale when buying
873   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
874     return weiAmount.mul(rate);
875   }
876 
877   /**
878    * @notice forwardd ether to vault
879    */
880   function forwardFunds(uint256 toFund) internal {
881     vault.deposit.value(toFund)(msg.sender);
882   }
883 
884   // @return true if the transaction can buy tokens
885   function validPurchase() internal view returns (bool) {
886     bool withinPeriod = now >= startTime && now <= endTime; // solium-disable-line security/no-block-members
887     bool nonZeroPurchase = msg.value != 0;
888     return withinPeriod && nonZeroPurchase;
889   }
890 
891   /**
892    * @notice calculate fund wrt sale cap. Override this function to control ether cap.
893    * @param _beneficiary address address to receive tokens
894    * @param _weiAmount uint256 amount of ether in wei
895    */
896   function calculateToFund(address _beneficiary, uint256 _weiAmount) internal view returns (uint256) {
897     uint256 toFund;
898     uint256 postWeiRaised = weiRaised.add(_weiAmount);
899 
900     if (postWeiRaised > cap) {
901       toFund = cap.sub(weiRaised);
902     } else {
903       toFund = _weiAmount;
904     }
905     return toFund;
906   }
907 
908   /**
909    * @notice interface to initialize crowdsale parameters.
910    * init should be implemented by Crowdsale Generator.
911    */
912   function init(bytes32[] args) public;
913 
914   /**
915    * @notice pre hook for buyTokens function
916    * @param _beneficiary address address to receive tokens
917    * @param _toFund uint256 amount of ether in wei
918    */
919   function buyTokensPreHook(address _beneficiary, uint256 _toFund) internal {}
920 
921   /**
922    * @notice post hook for buyTokens function
923    * @param _beneficiary address address to receive tokens
924    * @param _tokens uint256 amount of tokens to receive
925    * @param _toFund uint256 amount of ether in wei
926    */
927   function buyTokensPostHook(address _beneficiary, uint256 _tokens, uint256 _toFund) internal {}
928 
929   function finalizationFailHook() internal {
930     vault.enableRefunds();
931   }
932 
933   function finalizationSuccessHook() internal {
934     // calculate target total supply including all token holders
935     uint256 targetTotalSupply = getTotalSupply().mul(coeff).div(crowdsaleRatio);
936     ERC20Basic token = ERC20Basic(getTokenAddress());
937 
938     super.distributeToken(token, targetTotalSupply);
939     afterGeneratorHook();
940 
941     locker.activate();
942     vault.close();
943 
944     transferTokenOwnership(nextTokenOwner);
945   }
946 
947   function afterGeneratorHook() internal {}
948 
949   /**
950    * @notice common interfaces for both of MiniMe and Mintable token.
951    */
952   function generateTokens(address _beneficiary, uint256 _tokens) internal;
953   function transferTokenOwnership(address _to) internal;
954   function getTotalSupply() internal returns (uint256);
955   function finishMinting() internal returns (bool);
956   function getTokenAddress() internal returns (address);
957 
958   /**
959    * @notice helper function to generate tokens with ratio
960    */
961   function generateTargetTokens(address _beneficiary, uint256 _targetTotalSupply, uint256 _ratio) internal {
962     uint256 tokens = _targetTotalSupply.mul(_ratio).div(coeff);
963     generateTokens(_beneficiary, tokens);
964   }
965 
966   /**
967    * @notice claim ERC20Basic compatible tokens
968    */
969   function claimTokens(ERC20Basic _token) external onlyOwner {
970     require(isFinalized);
971     uint256 balance = _token.balanceOf(this);
972     _token.transfer(owner, balance);
973     emit ClaimTokens(_token, balance);
974   }
975 
976   /**
977    * @notice Override HolderBase.deliverTokens
978    * @param _token ERC20Basic token contract
979    * @param _beneficiary Address to receive tokens
980    * @param _tokens Amount of tokens
981    */
982   function deliverTokens(ERC20Basic _token, address _beneficiary, uint256 _tokens) internal {
983     generateTokens(_beneficiary, _tokens);
984   }
985 
986 }
987 
988 
989 /**
990  * @title BlockIntervalCrowdsale
991  * @notice BlockIntervalCrowdsale limit purchaser to take participate too frequently.
992  */
993 contract BlockIntervalCrowdsale is BaseCrowdsale {
994   uint256 public blockInterval;
995   mapping (address => uint256) public recentBlock;
996 
997   function BlockIntervalCrowdsale(uint256 _blockInterval) public {
998     require(_blockInterval != 0);
999     blockInterval = _blockInterval;
1000   }
1001 
1002   /**
1003    * @return true if the block number is over the block internal.
1004    */
1005   function validPurchase() internal view returns (bool) {
1006     bool withinBlock = recentBlock[msg.sender].add(blockInterval) < block.number;
1007     return withinBlock && super.validPurchase();
1008   }
1009 
1010   /**
1011    * @notice save the block number
1012    */
1013   function buyTokensPreHook(address _beneficiary, uint256 _toFund) internal {
1014     recentBlock[msg.sender] = block.number;
1015     super.buyTokensPreHook(_beneficiary, _toFund);
1016   }
1017 }
1018 
1019 
1020 // https://github.com/bitclave/crowdsale/blob/master/contracts/BonusCrowdsale.sol
1021 
1022 pragma solidity ^0.4.24;
1023 
1024 
1025 
1026 
1027 
1028 /**
1029 * @dev Parent crowdsale contract with support for time-based and amount based bonuses
1030 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
1031 *
1032 */
1033 contract BonusCrowdsale is BaseCrowdsale {
1034 
1035   // Constants
1036   // The following will be populated by main crowdsale contract
1037   uint32[] public BONUS_TIMES;
1038   uint32[] public BONUS_TIMES_VALUES;
1039   uint128[] public BONUS_AMOUNTS;
1040   uint32[] public BONUS_AMOUNTS_VALUES;
1041 
1042   /**
1043   * @dev Retrieve length of bonuses by time array
1044   * @return Bonuses by time array length
1045   */
1046   function bonusesForTimesCount() public view returns(uint) {
1047     return BONUS_TIMES.length;
1048   }
1049 
1050   /**
1051   * @dev Sets bonuses for time
1052   */
1053   function setBonusesForTimes(uint32[] times, uint32[] values) public onlyOwner {
1054     require(times.length == values.length);
1055     for (uint i = 0; i + 1 < times.length; i++) {
1056       require(times[i] < times[i+1]);
1057     }
1058 
1059     BONUS_TIMES = times;
1060     BONUS_TIMES_VALUES = values;
1061   }
1062 
1063   /**
1064   * @dev Retrieve length of bonuses by amounts array
1065   * @return Bonuses by amounts array length
1066   */
1067   function bonusesForAmountsCount() public view returns(uint) {
1068     return BONUS_AMOUNTS.length;
1069   }
1070 
1071   /**
1072   * @dev Sets bonuses for USD amounts
1073   */
1074   function setBonusesForAmounts(uint128[] amounts, uint32[] values) public onlyOwner {
1075     require(amounts.length == values.length);
1076     for (uint i = 0; i + 1 < amounts.length; i++) {
1077       require(amounts[i] > amounts[i+1]);
1078     }
1079 
1080     BONUS_AMOUNTS = amounts;
1081     BONUS_AMOUNTS_VALUES = values;
1082   }
1083 
1084   /**
1085   * @notice Overrided getTokenAmount function of parent Crowdsale contract
1086     to calculate the token with time and amount bonus.
1087   * @param weiAmount walelt of investor to receive tokens
1088   */
1089   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
1090     // Compute time and amount bonus
1091     uint256 bonus = computeBonus(weiAmount);
1092     uint256 rateWithBonus = rate.mul(coeff.add(bonus)).div(coeff);
1093     return weiAmount.mul(rateWithBonus);
1094   }
1095 
1096   /**
1097   * @dev Computes overall bonus based on time of contribution and amount of contribution.
1098   * The total bonus is the sum of bonus by time and bonus by amount
1099   * @return bonus percentage scaled by 10
1100   */
1101   function computeBonus(uint256 weiAmount) public view returns(uint256) {
1102     return computeAmountBonus(weiAmount).add(computeTimeBonus());
1103   }
1104 
1105   /**
1106   * @dev Computes bonus based on time of contribution relative to the beginning of crowdsale
1107   * @return bonus percentage scaled by 10
1108   */
1109   function computeTimeBonus() public view returns(uint256) {
1110     require(now >= startTime); // solium-disable-line security/no-block-members
1111 
1112     for (uint i = 0; i < BONUS_TIMES.length; i++) {
1113       if (now <= BONUS_TIMES[i]) { // solium-disable-line security/no-block-members
1114         return BONUS_TIMES_VALUES[i];
1115       }
1116     }
1117 
1118     return 0;
1119   }
1120 
1121   /**
1122   * @dev Computes bonus based on amount of contribution
1123   * @return bonus percentage scaled by 10
1124   */
1125   function computeAmountBonus(uint256 weiAmount) public view returns(uint256) {
1126     for (uint i = 0; i < BONUS_AMOUNTS.length; i++) {
1127       if (weiAmount >= BONUS_AMOUNTS[i]) {
1128         return BONUS_AMOUNTS_VALUES[i];
1129       }
1130     }
1131 
1132     return 0;
1133   }
1134 
1135 }
1136 
1137 
1138 /**
1139  * @title FinishMintingCrowdsale
1140  * @notice FinishMintingCrowdsale prevents token generation after sale ended.
1141  */
1142 contract FinishMintingCrowdsale is BaseCrowdsale {
1143   function afterGeneratorHook() internal {
1144     require(finishMinting());
1145     super.afterGeneratorHook();
1146   }
1147 }
1148 
1149 
1150 /**
1151  * @title KYC
1152  * @dev KYC contract handles the white list for PLCCrowdsale contract
1153  * Only accounts registered in KYC contract can buy PLC token.
1154  * Admins can register account, and the reason why
1155  */
1156 contract KYC is Ownable {
1157   // check the address is registered for token sale
1158   mapping (address => bool) public registeredAddress;
1159 
1160   // check the address is admin of kyc contract
1161   mapping (address => bool) public admin;
1162 
1163   event Registered(address indexed _addr);
1164   event Unregistered(address indexed _addr);
1165   event SetAdmin(address indexed _addr, bool indexed _isAdmin);
1166 
1167   /**
1168    * @dev check whether the msg.sender is admin or not
1169    */
1170   modifier onlyAdmin() {
1171     require(admin[msg.sender]);
1172     _;
1173   }
1174 
1175   function KYC() public {
1176     admin[msg.sender] = true;
1177   }
1178 
1179   /**
1180    * @dev set new admin as admin of KYC contract
1181    * @param _addr address The address to set as admin of KYC contract
1182    */
1183   function setAdmin(address _addr, bool _isAdmin)
1184     public
1185     onlyOwner
1186   {
1187     require(_addr != address(0));
1188     admin[_addr] = _isAdmin;
1189 
1190     emit SetAdmin(_addr, _isAdmin);
1191   }
1192 
1193   /**
1194    * @dev register the address for token sale
1195    * @param _addr address The address to register for token sale
1196    */
1197   function register(address _addr)
1198     public
1199     onlyAdmin
1200   {
1201     require(_addr != address(0));
1202 
1203     registeredAddress[_addr] = true;
1204 
1205     emit Registered(_addr);
1206   }
1207 
1208   /**
1209    * @dev register the addresses for token sale
1210    * @param _addrs address[] The addresses to register for token sale
1211    */
1212   function registerByList(address[] _addrs)
1213     public
1214     onlyAdmin
1215   {
1216     for(uint256 i = 0; i < _addrs.length; i++) {
1217       require(_addrs[i] != address(0));
1218 
1219       registeredAddress[_addrs[i]] = true;
1220 
1221       emit Registered(_addrs[i]);
1222     }
1223   }
1224 
1225   /**
1226    * @dev unregister the registered address
1227    * @param _addr address The address to unregister for token sale
1228    */
1229   function unregister(address _addr)
1230     public
1231     onlyAdmin
1232   {
1233     registeredAddress[_addr] = false;
1234 
1235     emit Unregistered(_addr);
1236   }
1237 
1238   /**
1239    * @dev unregister the registered addresses
1240    * @param _addrs address[] The addresses to unregister for token sale
1241    */
1242   function unregisterByList(address[] _addrs)
1243     public
1244     onlyAdmin
1245   {
1246     for(uint256 i = 0; i < _addrs.length; i++) {
1247       registeredAddress[_addrs[i]] = false;
1248 
1249       emit Unregistered(_addrs[i]);
1250     }
1251   }
1252 }
1253 
1254 
1255 /**
1256  * @title KYCCrowdsale
1257  * @notice KYCCrowdsale checks kyc information and
1258  */
1259 contract KYCCrowdsale is BaseCrowdsale {
1260 
1261   KYC kyc;
1262 
1263   function KYCCrowdsale (address _kyc) public {
1264     require(_kyc != 0x0);
1265     kyc = KYC(_kyc);
1266   }
1267 
1268   function registered(address _addr) public view returns (bool) {
1269     return kyc.registeredAddress(_addr);
1270   }
1271 }
1272 
1273 
1274 /**
1275  * @title Basic token
1276  * @dev Basic version of StandardToken, with no allowances.
1277  */
1278 contract BasicToken is ERC20Basic {
1279   using SafeMath for uint256;
1280 
1281   mapping(address => uint256) balances;
1282 
1283   uint256 totalSupply_;
1284 
1285   /**
1286   * @dev total number of tokens in existence
1287   */
1288   function totalSupply() public view returns (uint256) {
1289     return totalSupply_;
1290   }
1291 
1292   /**
1293   * @dev transfer token for a specified address
1294   * @param _to The address to transfer to.
1295   * @param _value The amount to be transferred.
1296   */
1297   function transfer(address _to, uint256 _value) public returns (bool) {
1298     require(_to != address(0));
1299     require(_value <= balances[msg.sender]);
1300 
1301     balances[msg.sender] = balances[msg.sender].sub(_value);
1302     balances[_to] = balances[_to].add(_value);
1303     emit Transfer(msg.sender, _to, _value);
1304     return true;
1305   }
1306 
1307   /**
1308   * @dev Gets the balance of the specified address.
1309   * @param _owner The address to query the the balance of.
1310   * @return An uint256 representing the amount owned by the passed address.
1311   */
1312   function balanceOf(address _owner) public view returns (uint256) {
1313     return balances[_owner];
1314   }
1315 
1316 }
1317 
1318 
1319 /**
1320  * @title Standard ERC20 token
1321  *
1322  * @dev Implementation of the basic standard token.
1323  * @dev https://github.com/ethereum/EIPs/issues/20
1324  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1325  */
1326 contract StandardToken is ERC20, BasicToken {
1327 
1328   mapping (address => mapping (address => uint256)) internal allowed;
1329 
1330 
1331   /**
1332    * @dev Transfer tokens from one address to another
1333    * @param _from address The address which you want to send tokens from
1334    * @param _to address The address which you want to transfer to
1335    * @param _value uint256 the amount of tokens to be transferred
1336    */
1337   function transferFrom(
1338     address _from,
1339     address _to,
1340     uint256 _value
1341   )
1342     public
1343     returns (bool)
1344   {
1345     require(_to != address(0));
1346     require(_value <= balances[_from]);
1347     require(_value <= allowed[_from][msg.sender]);
1348 
1349     balances[_from] = balances[_from].sub(_value);
1350     balances[_to] = balances[_to].add(_value);
1351     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1352     emit Transfer(_from, _to, _value);
1353     return true;
1354   }
1355 
1356   /**
1357    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1358    *
1359    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1360    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1361    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1362    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1363    * @param _spender The address which will spend the funds.
1364    * @param _value The amount of tokens to be spent.
1365    */
1366   function approve(address _spender, uint256 _value) public returns (bool) {
1367     allowed[msg.sender][_spender] = _value;
1368     emit Approval(msg.sender, _spender, _value);
1369     return true;
1370   }
1371 
1372   /**
1373    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1374    * @param _owner address The address which owns the funds.
1375    * @param _spender address The address which will spend the funds.
1376    * @return A uint256 specifying the amount of tokens still available for the spender.
1377    */
1378   function allowance(
1379     address _owner,
1380     address _spender
1381    )
1382     public
1383     view
1384     returns (uint256)
1385   {
1386     return allowed[_owner][_spender];
1387   }
1388 
1389   /**
1390    * @dev Increase the amount of tokens that an owner allowed to a spender.
1391    *
1392    * approve should be called when allowed[_spender] == 0. To increment
1393    * allowed value is better to use this function to avoid 2 calls (and wait until
1394    * the first transaction is mined)
1395    * From MonolithDAO Token.sol
1396    * @param _spender The address which will spend the funds.
1397    * @param _addedValue The amount of tokens to increase the allowance by.
1398    */
1399   function increaseApproval(
1400     address _spender,
1401     uint _addedValue
1402   )
1403     public
1404     returns (bool)
1405   {
1406     allowed[msg.sender][_spender] = (
1407       allowed[msg.sender][_spender].add(_addedValue));
1408     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1409     return true;
1410   }
1411 
1412   /**
1413    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1414    *
1415    * approve should be called when allowed[_spender] == 0. To decrement
1416    * allowed value is better to use this function to avoid 2 calls (and wait until
1417    * the first transaction is mined)
1418    * From MonolithDAO Token.sol
1419    * @param _spender The address which will spend the funds.
1420    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1421    */
1422   function decreaseApproval(
1423     address _spender,
1424     uint _subtractedValue
1425   )
1426     public
1427     returns (bool)
1428   {
1429     uint oldValue = allowed[msg.sender][_spender];
1430     if (_subtractedValue > oldValue) {
1431       allowed[msg.sender][_spender] = 0;
1432     } else {
1433       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1434     }
1435     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1436     return true;
1437   }
1438 
1439 }
1440 
1441 
1442 /**
1443  * @title Mintable token
1444  * @dev Simple ERC20 Token example, with mintable token creation
1445  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
1446  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
1447  */
1448 contract MintableToken is StandardToken, Ownable {
1449   event Mint(address indexed to, uint256 amount);
1450   event MintFinished();
1451 
1452   bool public mintingFinished = false;
1453 
1454 
1455   modifier canMint() {
1456     require(!mintingFinished);
1457     _;
1458   }
1459 
1460   modifier hasMintPermission() {
1461     require(msg.sender == owner);
1462     _;
1463   }
1464 
1465   /**
1466    * @dev Function to mint tokens
1467    * @param _to The address that will receive the minted tokens.
1468    * @param _amount The amount of tokens to mint.
1469    * @return A boolean that indicates if the operation was successful.
1470    */
1471   function mint(
1472     address _to,
1473     uint256 _amount
1474   )
1475     hasMintPermission
1476     canMint
1477     public
1478     returns (bool)
1479   {
1480     totalSupply_ = totalSupply_.add(_amount);
1481     balances[_to] = balances[_to].add(_amount);
1482     emit Mint(_to, _amount);
1483     emit Transfer(address(0), _to, _amount);
1484     return true;
1485   }
1486 
1487   /**
1488    * @dev Function to stop minting new tokens.
1489    * @return True if the operation was successful.
1490    */
1491   function finishMinting() onlyOwner canMint public returns (bool) {
1492     mintingFinished = true;
1493     emit MintFinished();
1494     return true;
1495   }
1496 }
1497 
1498 
1499 contract MintableBaseCrowdsale is BaseCrowdsale {
1500 
1501   MintableToken token;
1502 
1503   function MintableBaseCrowdsale (address _token) public {
1504     require(_token != address(0));
1505     token = MintableToken(_token);
1506   }
1507 
1508 
1509   function generateTokens(address _beneficiary, uint256 _tokens) internal {
1510     token.mint(_beneficiary, _tokens);
1511   }
1512 
1513   function transferTokenOwnership(address _to) internal {
1514     token.transferOwnership(_to);
1515   }
1516 
1517   function getTotalSupply() internal returns (uint256) {
1518     return token.totalSupply();
1519   }
1520 
1521   function finishMinting() internal returns (bool) {
1522     require(token.finishMinting());
1523     return true;
1524   }
1525 
1526   function getTokenAddress() internal returns (address) {
1527     return address(token);
1528   }
1529 }
1530 
1531 
1532 /**
1533  * @title StagedCrowdsale
1534  * @notice StagedCrowdsale seperates sale period with start time & end time.
1535  * For each period, seperate max cap and kyc could be setup.
1536  * Both startTime and endTime are inclusive.
1537  */
1538 contract StagedCrowdsale is KYCCrowdsale {
1539 
1540   uint8 public numPeriods;
1541 
1542   Stage[] public stages;
1543 
1544   struct Stage {
1545     uint128 cap;
1546     uint128 maxPurchaseLimit;
1547     uint128 minPurchaseLimit;
1548     uint128 weiRaised; // stage's weiAmount raised
1549     uint32 startTime;
1550     uint32 endTime;
1551     bool kyc;
1552   }
1553 
1554   function StagedCrowdsale(uint _numPeriods) public {
1555     numPeriods = uint8(_numPeriods);
1556     require(numPeriods > 0);
1557   }
1558 
1559   function initStages(
1560     uint32[] _startTimes,
1561     uint32[] _endTimes,
1562     uint128[] _capRatios,
1563     uint128[] _maxPurchaseLimits,
1564     uint128[] _minPurchaseLimits,
1565     bool[] _kycs)
1566     public
1567   {
1568     uint len = numPeriods;
1569 
1570     require(stages.length == 0);
1571     // solium-disable
1572     require(len == _startTimes.length &&
1573       len == _endTimes.length &&
1574       len == _capRatios.length &&
1575       len == _maxPurchaseLimits.length &&
1576       len == _minPurchaseLimits.length &&
1577       len == _kycs.length);
1578     // solium-enable
1579 
1580     for (uint i = 0; i < len; i++) {
1581       require(_endTimes[i] >= _startTimes[i]);
1582 
1583       uint stageCap;
1584 
1585       if (_capRatios[i] != 0) {
1586         stageCap = cap.mul(uint(_capRatios[i])).div(coeff);
1587       } else {
1588         stageCap = 0;
1589       }
1590 
1591       stages.push(Stage({
1592         startTime: _startTimes[i],
1593         endTime: _endTimes[i],
1594         cap: uint128(stageCap),
1595         maxPurchaseLimit: _maxPurchaseLimits[i],
1596         minPurchaseLimit: _minPurchaseLimits[i],
1597         kyc: _kycs[i],
1598         weiRaised: 0
1599       }));
1600     }
1601 
1602     require(validPeriods());
1603   }
1604 
1605   /**
1606    * @notice if period is on sale, return index of the period.
1607    */
1608   function getStageIndex() public view returns (uint8 currentStage, bool onSale) {
1609     onSale = true;
1610     Stage memory p;
1611 
1612     for (currentStage = 0; currentStage < stages.length; currentStage++) {
1613       p = stages[currentStage];
1614       if (p.startTime <= now && now <= p.endTime) {
1615         return;
1616       }
1617     }
1618 
1619     onSale = false;
1620   }
1621 
1622   /**
1623    * @notice return if all period is finished.
1624    */
1625   function saleFinished() public view returns (bool) {
1626     require(stages.length == numPeriods);
1627     return stages[stages.length - 1].endTime < now;
1628   }
1629 
1630 
1631   function validPeriods() internal view returns (bool) {
1632     if (stages.length != numPeriods) {
1633       return false;
1634     }
1635 
1636     // check stages are overlapped.
1637     for (uint8 i = 0; i < stages.length - 1; i++) {
1638       if (stages[i].endTime >= stages[i + 1].startTime) {
1639         return false;
1640       }
1641     }
1642 
1643     return true;
1644   }
1645 
1646   /**
1647    * @notice Override BaseCrowdsale.calculateToFund function.
1648    * Check if period is on sale and apply cap if needed.
1649    */
1650   function calculateToFund(address _beneficiary, uint256 _weiAmount) internal view returns (uint256) {
1651     uint256 weiAmount = _weiAmount;
1652     uint8 currentStage;
1653     bool onSale;
1654 
1655     (currentStage, onSale) = getStageIndex();
1656 
1657     require(onSale);
1658 
1659     Stage memory p = stages[currentStage];
1660 
1661     // Check kyc if needed for this period
1662     if (p.kyc) {
1663       require(super.registered(_beneficiary));
1664     }
1665 
1666     // check min purchase limit of the period
1667     require(weiAmount >= uint(p.minPurchaseLimit));
1668 
1669     // reduce up to max purchase limit of the period
1670     if (p.maxPurchaseLimit != 0 && weiAmount > uint(p.maxPurchaseLimit)) {
1671       weiAmount = uint(p.maxPurchaseLimit);
1672     }
1673 
1674     // pre-calculate `toFund` with the period's cap
1675     if (p.cap > 0) {
1676       uint256 postWeiRaised = uint256(p.weiRaised).add(weiAmount);
1677 
1678       if (postWeiRaised > p.cap) {
1679         weiAmount = uint256(p.cap).sub(p.weiRaised);
1680       }
1681     }
1682 
1683     // get `toFund` with the cap of the sale
1684     return super.calculateToFund(_beneficiary, weiAmount);
1685   }
1686 
1687   function buyTokensPreHook(address _beneficiary, uint256 _toFund) internal {
1688     uint8 currentStage;
1689     bool onSale;
1690 
1691     (currentStage, onSale) = getStageIndex();
1692 
1693     require(onSale);
1694 
1695     Stage storage p = stages[currentStage];
1696 
1697     p.weiRaised = uint128(_toFund.add(uint256(p.weiRaised)));
1698     super.buyTokensPreHook(_beneficiary, _toFund);
1699   }
1700 }
1701 
1702 
1703 pragma solidity^0.4.18;
1704 
1705 
1706 
1707 
1708 
1709 
1710 
1711 
1712 contract AlphaconCrowdsale is BaseCrowdsale, MintableBaseCrowdsale, BonusCrowdsale, BlockIntervalCrowdsale, KYCCrowdsale, StagedCrowdsale, FinishMintingCrowdsale {
1713 
1714   bool public initialized;
1715 
1716   // constructor parameters are left padded bytes32.
1717 
1718   function AlphaconCrowdsale(bytes32[5] args) 
1719     BaseCrowdsale(
1720       parseUint(args[0]))
1721     MintableBaseCrowdsale(
1722       parseAddress(args[1]))
1723     BonusCrowdsale()
1724     BlockIntervalCrowdsale(
1725       parseUint(args[2]))
1726     KYCCrowdsale(
1727       parseAddress(args[3]))
1728     StagedCrowdsale(
1729       parseUint(args[4]))
1730     FinishMintingCrowdsale() public {}
1731   
1732 
1733   function parseBool(bytes32 b) internal pure returns (bool) {
1734     return b == 0x1;
1735   }
1736 
1737   function parseUint(bytes32 b) internal pure returns (uint) {
1738     return uint(b);
1739   }
1740 
1741   function parseAddress(bytes32 b) internal pure returns (address) {
1742     return address(b & 0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff);
1743   }
1744 
1745   function init(bytes32[] args) public {
1746     uint _startTime = uint(args[0]);
1747     uint _endTime = uint(args[1]);
1748     uint _rate = uint(args[2]);
1749     uint _cap = uint(args[3]);
1750     uint _goal = uint(args[4]);
1751     uint _crowdsaleRatio = uint(args[5]);
1752     address _vault = address(args[6]);
1753     address _locker = address(args[7]);
1754     address _nextTokenOwner = address(args[8]);
1755 
1756     require(_endTime > _startTime);
1757     require(_rate > 0);
1758     require(_cap > 0);
1759     require(_goal > 0);
1760     require(_cap > _goal);
1761     require(_crowdsaleRatio > 0);
1762     require(_vault != address(0));
1763     require(_locker != address(0));
1764     require(_nextTokenOwner != address(0));
1765     
1766     startTime = _startTime;
1767     endTime = _endTime;
1768     rate = _rate;
1769     cap = _cap;
1770     goal = _goal;
1771     crowdsaleRatio = _crowdsaleRatio;
1772     vault = MultiHolderVault(_vault);
1773     locker = Locker(_locker);
1774     nextTokenOwner = _nextTokenOwner;
1775   }
1776 }