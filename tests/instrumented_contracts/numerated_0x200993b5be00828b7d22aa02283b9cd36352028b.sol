1 pragma solidity ^0.4.13;
2 
3 contract Owned {
4 	modifier only_owner {
5 		if (msg.sender != owner)
6 			return;
7 		_; 
8 	}
9 
10 	event NewOwner(address indexed old, address indexed current);
11 
12 	function setOwner(address _new) only_owner { NewOwner(owner, _new); owner = _new; }
13 
14 	address public owner = msg.sender;
15 }
16 
17 library Math {
18   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
19     return a >= b ? a : b;
20   }
21 
22   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
23     return a < b ? a : b;
24   }
25 
26   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
27     return a >= b ? a : b;
28   }
29 
30   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a < b ? a : b;
32   }
33 }
34 
35 library SafeMath {
36   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a * b;
38     assert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal constant returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 contract Ownable {
62   address public owner;
63 
64 
65   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   function Ownable() {
73     owner = msg.sender;
74   }
75 
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address newOwner) public onlyOwner {
91     require(newOwner != address(0));
92     OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94   }
95 
96 }
97 
98 contract Pausable is Ownable {
99   event Pause();
100   event Unpause();
101 
102   bool public paused = false;
103 
104 
105   /**
106    * @dev modifier to allow actions only when the contract IS paused
107    */
108   modifier whenNotPaused() {
109     require(!paused);
110     _;
111   }
112 
113   /**
114    * @dev modifier to allow actions only when the contract IS NOT paused
115    */
116   modifier whenPaused {
117     require(paused);
118     _;
119   }
120 
121   /**
122    * @dev called by the owner to pause, triggers stopped state
123    */
124   function pause() onlyOwner whenNotPaused returns (bool) {
125     paused = true;
126     Pause();
127     return true;
128   }
129 
130   /**
131    * @dev called by the owner to unpause, returns to normal state
132    */
133   function unpause() onlyOwner whenPaused returns (bool) {
134     paused = false;
135     Unpause();
136     return true;
137   }
138 }
139 
140 contract LegalLazyScheduler is Ownable {
141     uint64 public lastUpdate;
142     uint64 public intervalDuration;
143     bool schedulerEnabled = false;
144     function() internal callback;
145 
146     event LogRegisteredInterval(uint64 date, uint64 duration);
147     event LogProcessedInterval(uint64 date, uint64 intervals);    
148     /**
149     * Triggers the registered callback function for the number of periods passed since last update
150     */
151     modifier intervalTrigger() {
152         uint64 currentTime = uint64(now);
153         uint64 requiredIntervals = (currentTime - lastUpdate) / intervalDuration;
154         if( schedulerEnabled && (requiredIntervals > 0)) {
155             LogProcessedInterval(lastUpdate, requiredIntervals);
156             while (requiredIntervals-- > 0) {
157                 callback();
158             }
159             lastUpdate = currentTime;
160         }
161         _;
162     }
163     
164     function LegalLazyScheduler() {
165         lastUpdate = uint64(now);
166     }
167 
168     function enableScheduler() onlyOwner public {
169         schedulerEnabled = true;
170     }
171 
172     function registerIntervalCall(uint64 _intervalDuration, function() internal _callback) internal {
173         lastUpdate = uint64(now);
174         intervalDuration = _intervalDuration;
175         callback = _callback;
176         LogRegisteredInterval(lastUpdate, intervalDuration);        
177     }
178 }
179 
180 contract RefundVault is Ownable {
181   using SafeMath for uint256;
182 
183   enum State { Active, Refunding, Closed }
184 
185   mapping (address => uint256) public deposited;
186   address public wallet;
187   State public state;
188 
189   event Closed();
190   event RefundsEnabled();
191   event Refunded(address indexed beneficiary, uint256 weiAmount);
192 
193   function RefundVault(address _wallet) {
194     require(_wallet != 0x0);
195     wallet = _wallet;
196     state = State.Active;
197   }
198 
199   function deposit(address investor) onlyOwner public payable {
200     require(state == State.Active);
201     deposited[investor] = deposited[investor].add(msg.value);
202   }
203 
204   function close() onlyOwner {
205     require(state == State.Active);
206     state = State.Closed;
207     Closed();
208     wallet.transfer(this.balance);
209   }
210 
211   function enableRefunds() onlyOwner {
212     require(state == State.Active);
213     state = State.Refunding;
214     RefundsEnabled();
215   }
216 
217   function refund(address investor) public {
218     require(state == State.Refunding);
219     uint256 depositedValue = deposited[investor];
220     deposited[investor] = 0;
221     investor.transfer(depositedValue);
222     Refunded(investor, depositedValue);
223   }
224 }
225 
226 contract LegalTGE is Ownable, Pausable {
227   /**
228   * The safe math library for safety math opertations provided by Zeppelin
229   */
230   using SafeMath for uint256;
231   /** State machine
232    * - PreparePreContribution: During this phase SmartOne adjust conversionRate and start/end date
233    * - PreContribution: During this phase only registered users can contribute to the TGE and therefore receive a bonus until cap or end date is reached
234    * - PrepareContribution: During this phase SmartOne adjusts conversionRate by the ETHUSD depreciation during PreContribution and change start and end date in case of an unforseen event 
235    * - Contribution: During this all users can contribute until cap or end date is reached
236    * - Auditing: SmartOne awaits recommendation by auditor and board of foundation will then finalize contribution or enable refunding
237    * - Finalized: Token are released
238    * - Refunding: Refunds can be claimed
239    */
240   enum States{PreparePreContribution, PreContribution, PrepareContribution, Contribution, Auditing, Finalized, Refunding}
241 
242   enum VerificationLevel { None, SMSVerified, KYCVerified }
243 
244  /**
245   * Whenever the state of the contract changes, this event will be fired.
246   */
247   event LogStateChange(States _states);
248 
249 
250   /**
251   * This event is fired when a user has been successfully verified by the external KYC verification process
252   */
253   event LogKYCConfirmation(address sender);
254 
255   /**
256   * Whenever a legalToken is assigned to this contract, this event will be fired.
257   */
258   event LogTokenAssigned(address sender, address newToken);
259 
260   /**
261   * Every timed transition must be loged for auditing 
262   */
263   event LogTimedTransition(uint _now, States _newState);
264   
265   /**
266   * This event is fired when PreContribution data is changed during the PreparePreContribution phase
267   */
268   event LogPreparePreContribution(address sender, uint conversionRate, uint startDate, uint endDate);
269 
270   /**
271   * A user has transfered Ether and received unreleasead tokens in return
272   */
273   event LogContribution(address contributor, uint256 weiAmount, uint256 tokenAmount, VerificationLevel verificationLevel, States _state);
274 
275   /**
276   * This event will be fired when SmartOne finalizes the TGE 
277   */
278   event LogFinalized(address sender);
279 
280   /**
281   * This event will be fired when the auditor confirms the confirms regularity confirmity 
282   */
283   event LogRegularityConfirmation(address sender, bool _regularity, bytes32 _comment);
284   
285   /**
286   * This event will be fired when refunding is enabled by the auditor 
287   */
288   event LogRefundsEnabled(address sender);
289 
290   /**
291   * This event is fired when PreContribution data is changed during the PreparePreContribution phase
292   */
293   event LogPrepareContribution(address sender, uint conversionRate, uint startDate, uint endDate);
294 
295   /**
296   * This refund vault used to hold funds while TGE is running.
297   * Uses the default implementation provided by the OpenZeppelin community.
298   */ 
299   RefundVault public vault;
300 
301   /**
302   * Defines the state of the conotribution process
303   */
304   States public state;
305 
306   /**
307   * The token we are giving the contributors in return for their contributions
308   */ 
309   LegalToken public token;
310   
311   /**
312   * The contract provided by Parity Tech (Gav Woods) to verify the mobile number during user registration
313   */ 
314   ProofOfSMS public proofOfSMS;
315 
316   /** 
317   * The contribution (wei) will be forwarded to this address after the token has been finalized by the foundation board
318   */
319   address public multisigWallet;
320 
321   /** 
322   * Maximum amount of wei this TGE can raise.
323   */
324   uint256 public tokenCap;
325 
326   /** 
327   * The amount of wei a contributor has contributed. 
328   * Used to check whether the total of contributions per user exceeds the max limit (depending on his verification level)
329   */
330   mapping (address => uint) public weiPerContributor;
331 
332   /** 
333   * Minimum amount of tokens a contributor is able to buy
334   */
335   uint256 public minWeiPerContributor;
336 
337   /** 
338   * Maximum amount of tokens an SMS verified user can contribute.
339   */
340   uint256 public maxWeiSMSVerified;
341 
342   /** 
343   * Maximum amount of tokens an none-verified user can contribute.
344   */
345   uint256 public maxWeiUnverified;
346 
347   /* 
348   * The number of token units a contributor receives per ETHER during pre-contribtion phase
349   */ 
350   uint public preSaleConversionRate;
351 
352   /* 
353   * The UNIX timestamp (in seconds) defining when the pre-contribution phase will start
354   */
355   uint public preSaleStartDate;
356 
357   /* 
358   * The UNIX timestamp (in seconds) defining when the TGE will end
359   */
360   uint public preSaleEndDate;
361 
362   /* 
363   * The number of token units a contributor receives per ETHER during contribution phase
364   */ 
365   uint public saleConversionRate;
366 
367   /* 
368   * The UNIX timestamp (in seconds) defining when the TGE will start
369   */
370   uint public saleStartDate;
371 
372   /* 
373   * The UNIX timestamp (in seconds) defining when the TGE would end if cap will not be reached
374   */
375   uint public saleEndDate;
376 
377   /* 
378   * The bonus a sms verified user will receive for a contribution during pre-contribution phase in base points
379   */
380   uint public smsVerifiedBonusBps;
381 
382   /* 
383   * The bonus a kyc verified user will receive for a contribution during pre-contribution phase in base points
384   */
385   uint public kycVerifiedBonusBps;
386 
387   /**
388   * Total percent of tokens minted to the team at the end of the sale as base points
389   * 1BP -> 0.01%
390   */
391   uint public maxTeamBonusBps;
392 
393   /**
394   * Only the foundation board is able to finalize the TGE.
395   * Two of four members have to confirm the finalization. Therefore a multisig contract is used.
396   */
397   address public foundationBoard;
398 
399   /**
400   * Only the KYC confirmation account is allowed to confirm a successfull KYC verification
401   */
402   address public kycConfirmer;
403 
404   /**
405   * Once the contribution has ended an auditor will verify whether all regulations have been fullfilled
406   */
407   address public auditor;
408 
409   /**
410   * The tokens for the insitutional investors will be allocated to this wallet
411   */
412   address public instContWallet;
413 
414   /**
415   * This flag ist set by auditor before finalizing the TGE to indicate whether all regualtions have been fulfilled
416   */
417   bool public regulationsFulfilled;
418 
419   /**
420   * The auditor can comment the confirmation (e.g. in case of deviations)
421   */
422   bytes32 public auditorComment;
423 
424   /**
425   * The total number of institutional and public tokens sold during pre- and contribution phase
426   */
427   uint256 public tokensSold = 0;
428 
429   /*
430   * The number of tokens pre allocated to insitutional contributors
431   */
432   uint public instContAllocatedTokens;
433 
434   /**
435   * The amount of wei totally raised by the public TGE
436   */
437   uint256 public weiRaised = 0;
438 
439   /* 
440   * The amount of wei raised during the preContribution phase 
441   */
442   uint256 public preSaleWeiRaised = 0;
443 
444   /*
445   * How much wei we have given back to contributors.
446   */
447   uint256 public weiRefunded = 0;
448 
449   /*
450   * The number of tokens allocated to the team when the TGE was finalized.
451   * The calculation is based on the predefined maxTeamBonusBps
452   */
453   uint public teamBonusAllocatedTokens;
454 
455   /**
456   * The number of contributors which have contributed to the TGE
457   */
458   uint public numberOfContributors = 0;
459 
460   /**
461   * dictionary that maps addresses to contributors which have sucessfully been verified by the external KYC process 
462   */
463   mapping (address => bool) public kycRegisteredContributors;
464 
465   struct TeamBonus {
466     address toAddress;
467     uint64 tokenBps;
468     uint64 cliffDate;
469     uint64 vestingDate;
470   }
471 
472   /*
473   * Defines the percentage (base points) distribution of the team-allocated bonus rewards among members which will be vested ..
474   * 1 Bp -> 0.01%
475   */
476   TeamBonus[] public teamBonuses;
477 
478   /**
479    * @dev Check whether the TGE is currently in the state provided
480    */
481 
482  function LegalTGE (address _foundationBoard, address _multisigWallet, address _instContWallet, uint256 _instContAllocatedTokens, uint256 _tokenCap, uint256 _smsVerifiedBonusBps, uint256 _kycVerifiedBonusBps, uint256 _maxTeamBonusBps, address _auditor, address _kycConfirmer, ProofOfSMS _proofOfSMS, RefundVault _vault) {
483      // --------------------------------------------------------------------------------
484     // -- Validate all variables which are not passed to the constructor first
485     // --------------------------------------------------------------------------------
486     // the address of the account used for auditing
487     require(_foundationBoard != 0x0);
488     
489     // the address of the multisig must not be 'undefined'
490     require(_multisigWallet != 0x0);
491 
492     // the address of the wallet for constitutional contributors must not be 'undefined'
493     require(_instContWallet != 0x0);
494 
495     // the address of the account used for auditing
496     require(_auditor != 0x0);
497     
498     // the address of the cap for this TGE must not be 'undefined'
499     require(_tokenCap > 0); 
500 
501     // pre-contribution and contribution phases must not overlap
502     // require(_preSaleStartDate <= _preSaleEndDate);
503 
504     multisigWallet = _multisigWallet;
505     instContWallet = _instContWallet;
506     instContAllocatedTokens = _instContAllocatedTokens;
507     tokenCap = _tokenCap;
508     smsVerifiedBonusBps = _smsVerifiedBonusBps;
509     kycVerifiedBonusBps = _kycVerifiedBonusBps;
510     maxTeamBonusBps = _maxTeamBonusBps;
511     auditor = _auditor;
512     foundationBoard = _foundationBoard;
513     kycConfirmer = _kycConfirmer;
514     proofOfSMS = _proofOfSMS;
515 
516     // --------------------------------------------------------------------------------
517     // -- Initialize all variables which are not passed to the constructor first
518     // --------------------------------------------------------------------------------
519     state = States.PreparePreContribution;
520     vault = _vault;
521   }
522 
523   /** =============================================================================================================================
524   * All logic related to the TGE contribution is currently placed below.
525   * ============================================================================================================================= */
526 
527   function setMaxWeiForVerificationLevels(uint _minWeiPerContributor, uint _maxWeiUnverified, uint  _maxWeiSMSVerified) public onlyOwner inState(States.PreparePreContribution) {
528     require(_minWeiPerContributor >= 0);
529     require(_maxWeiUnverified > _minWeiPerContributor);
530     require(_maxWeiSMSVerified > _minWeiPerContributor);
531 
532     // the minimum number of wei an unverified user can contribute
533     minWeiPerContributor = _minWeiPerContributor;
534 
535     // the maximum number of wei an unverified user can contribute
536     maxWeiUnverified = _maxWeiUnverified;
537 
538     // the maximum number of wei an SMS verified user can contribute    
539     maxWeiSMSVerified = _maxWeiSMSVerified;
540   }
541 
542   function setLegalToken(LegalToken _legalToken) public onlyOwner inState(States.PreparePreContribution) {
543     token = _legalToken;
544     if ( instContAllocatedTokens > 0 ) {
545       // mint the pre allocated tokens for the institutional investors
546       token.mint(instContWallet, instContAllocatedTokens);
547       tokensSold += instContAllocatedTokens;
548     }    
549     LogTokenAssigned(msg.sender, _legalToken);
550   }
551 
552   function validatePreContribution(uint _preSaleConversionRate, uint _preSaleStartDate, uint _preSaleEndDate) constant internal {
553     // the pre-contribution conversion rate must not be 'undefined'
554     require(_preSaleConversionRate >= 0);
555 
556     // the pre-contribution start date must not be in the past
557     require(_preSaleStartDate >= now);
558 
559     // the pre-contribution start date must not be in the past
560     require(_preSaleEndDate >= _preSaleStartDate);
561   }
562 
563   function validateContribution(uint _saleConversionRate, uint _saleStartDate, uint _saleEndDate) constant internal {
564     // the contribution conversion rate must not be 'undefined'
565     require(_saleConversionRate >= 0);
566 
567     // the contribution start date must not be in the past
568     require(_saleStartDate >= now);
569 
570     // the contribution end date must not be before start date 
571     require(_saleEndDate >= _saleStartDate);
572   }
573 
574   function isNowBefore(uint _date) constant internal returns (bool) {
575     return ( now < _date );
576   }
577 
578   function evalTransitionState() public returns (States) {
579     // once the TGE is in state finalized or refunding, there is now way to transit to another state!
580     if ( hasState(States.Finalized))
581       return States.Finalized;
582     if ( hasState(States.Refunding))
583       return States.Refunding;
584     if ( isCapReached()) 
585       return States.Auditing;
586     if ( isNowBefore(preSaleStartDate))
587       return States.PreparePreContribution; 
588     if ( isNowBefore(preSaleEndDate))
589       return States.PreContribution;
590     if ( isNowBefore(saleStartDate))  
591       return States.PrepareContribution;
592     if ( isNowBefore(saleEndDate))    
593       return States.Contribution;
594     return States.Auditing;
595   }
596 
597   modifier stateTransitions() {
598     States evaluatedState = evalTransitionState();
599     setState(evaluatedState);
600     _;
601   }
602 
603   function hasState(States _state) constant private returns (bool) {
604     return (state == _state);
605   }
606 
607   function setState(States _state) private {
608   	if ( _state != state ) {
609       state = _state;
610 	  LogStateChange(state);
611 	  }
612   }
613 
614   modifier inState(States  _state) {
615     require(hasState(_state));
616     _;
617   }
618 
619   function updateState() public stateTransitions {
620   }  
621   
622   /**
623    * @dev Checks whether contract is in a state in which contributions will be accepted
624    */
625   modifier inPreOrContributionState() {
626     require(hasState(States.PreContribution) || (hasState(States.Contribution)));
627     _;
628   }
629   modifier inPrePrepareOrPreContributionState() {
630     require(hasState(States.PreparePreContribution) || (hasState(States.PreContribution)));
631     _;
632   }
633 
634   modifier inPrepareState() {
635     // we can relay on state since modifer since already evaluated by stateTransitions modifier
636     require(hasState(States.PreparePreContribution) || (hasState(States.PrepareContribution)));
637     _;
638   }
639   /** 
640   * This modifier makes sure that not more tokens as specified can be allocated
641   */
642   modifier teamBonusLimit(uint64 _tokenBps) {
643     uint teamBonusBps = 0; 
644     for ( uint i = 0; i < teamBonuses.length; i++ ) {
645       teamBonusBps = teamBonusBps.add(teamBonuses[i].tokenBps);
646     }
647     require(maxTeamBonusBps >= teamBonusBps);
648     _;
649   }
650 
651   /**
652   * Allocates the team bonus with a specific vesting rule
653   */
654   function allocateTeamBonus(address _toAddress, uint64 _tokenBps, uint64 _cliffDate, uint64 _vestingDate) public onlyOwner teamBonusLimit(_tokenBps) inState(States.PreparePreContribution) {
655     teamBonuses.push(TeamBonus(_toAddress, _tokenBps, _cliffDate, _vestingDate));
656   }
657 
658   /**
659   * This method can optional be called by the owner to adjust the conversionRate, startDate and endDate before contribution phase starts.
660   * Pre-conditions:
661   * - Caller is owner (deployer)
662   * - TGE is in state PreContribution
663   * Post-conditions:
664   */
665   function preparePreContribution(uint _preSaleConversionRate, uint _preSaleStartDate, uint _preSaleEndDate) public onlyOwner inState(States.PreparePreContribution) {
666     validatePreContribution(_preSaleConversionRate, _preSaleStartDate, _preSaleEndDate);    
667     preSaleConversionRate = _preSaleConversionRate;
668     preSaleStartDate = _preSaleStartDate;
669     preSaleEndDate = _preSaleEndDate;
670     LogPreparePreContribution(msg.sender, preSaleConversionRate, preSaleStartDate, preSaleEndDate);
671   }
672 
673   /**
674   * This method can optional be called by the owner to adjust the conversionRate, startDate and endDate before pre contribution phase starts.
675   * Pre-conditions:
676   * - Caller is owner (deployer)
677   * - Crowdsale is in state PreparePreContribution
678   * Post-conditions:
679   */
680   function prepareContribution(uint _saleConversionRate, uint _saleStartDate, uint _saleEndDate) public onlyOwner inPrepareState {
681     validateContribution(_saleConversionRate, _saleStartDate, _saleEndDate);
682     saleConversionRate = _saleConversionRate;
683     saleStartDate = _saleStartDate;
684     saleEndDate = _saleEndDate;
685 
686     LogPrepareContribution(msg.sender, saleConversionRate, saleStartDate, saleEndDate);
687   }
688 
689   // fallback function can be used to buy tokens
690   function () payable public {
691     contribute();  
692   }
693   function getWeiPerContributor(address _contributor) public constant returns (uint) {
694   	return weiPerContributor[_contributor];
695   }
696 
697   function contribute() whenNotPaused stateTransitions inPreOrContributionState public payable {
698     require(msg.sender != 0x0);
699     require(msg.value >= minWeiPerContributor);
700 
701     VerificationLevel verificationLevel = getVerificationLevel();
702     
703     // we only allow verified users to participate during pre-contribution phase
704     require(hasState(States.Contribution) || verificationLevel > VerificationLevel.None);
705 
706     // we need to keep track of all contributions per user to limit total contributions
707     weiPerContributor[msg.sender] = weiPerContributor[msg.sender].add(msg.value);
708 
709     // the total amount of ETH a KYC verified user can contribute is unlimited, so we do not need to check
710 
711     if ( verificationLevel == VerificationLevel.SMSVerified ) {
712       // the total amount of ETH a non-KYC user can contribute is limited to maxWeiPerContributor
713       require(weiPerContributor[msg.sender] <= maxWeiSMSVerified);
714     }
715 
716     if ( verificationLevel == VerificationLevel.None ) {
717       // the total amount of ETH a non-verified user can contribute is limited to maxWeiUnverified
718       require(weiPerContributor[msg.sender] <= maxWeiUnverified);
719     }
720 
721     if (hasState(States.PreContribution)) {
722       preSaleWeiRaised = preSaleWeiRaised.add(msg.value);
723     }
724 
725     weiRaised = weiRaised.add(msg.value);
726 
727     // calculate the token amount to be created
728     uint256 tokenAmount = calculateTokenAmount(msg.value, verificationLevel);
729 
730     tokensSold = tokensSold.add(tokenAmount);
731 
732     if ( token.balanceOf(msg.sender) == 0 ) {
733        numberOfContributors++;
734     }
735 
736     if ( isCapReached()) {
737       updateState();
738     }
739 
740     token.mint(msg.sender, tokenAmount);
741 
742     forwardFunds();
743 
744     LogContribution(msg.sender, msg.value, tokenAmount, verificationLevel, state);    
745   }
746 
747  
748   function calculateTokenAmount(uint256 _weiAmount, VerificationLevel _verificationLevel) public constant returns (uint256) {
749     uint256 conversionRate = saleConversionRate;
750     if ( state == States.PreContribution) {
751       conversionRate = preSaleConversionRate;
752     }
753     uint256 tokenAmount = _weiAmount.mul(conversionRate);
754     
755     // an anonymous user (Level-0) gets no bonus
756     uint256 bonusTokenAmount = 0;
757 
758     if ( _verificationLevel == VerificationLevel.SMSVerified ) {
759       // a SMS verified user (Level-1) gets a bonus
760       bonusTokenAmount = tokenAmount.mul(smsVerifiedBonusBps).div(10000);
761     } else if ( _verificationLevel == VerificationLevel.KYCVerified ) {
762       // a KYC verified user (Level-2) gets the highest bonus
763       bonusTokenAmount = tokenAmount.mul(kycVerifiedBonusBps).div(10000);
764     }
765     return tokenAmount.add(bonusTokenAmount);
766   }
767 
768   function getVerificationLevel() constant public returns (VerificationLevel) {
769     if (kycRegisteredContributors[msg.sender]) {
770       return VerificationLevel.KYCVerified;
771     } else if (proofOfSMS.certified(msg.sender)) {
772       return VerificationLevel.SMSVerified;
773     }
774     return VerificationLevel.None;
775   }
776 
777   modifier onlyKycConfirmer() {
778     require(msg.sender == kycConfirmer);
779     _;
780   }
781 
782   function confirmKYC(address addressId) onlyKycConfirmer inPrePrepareOrPreContributionState() public returns (bool) {
783     LogKYCConfirmation(msg.sender);
784     return kycRegisteredContributors[addressId] = true;
785   }
786 
787 // =============================================================================================================================
788 // All functions related to the TGE cap come here
789 // =============================================================================================================================
790   function isCapReached() constant internal returns (bool) {
791     if (tokensSold >= tokenCap) {
792       return true;
793     }
794     return false;
795   }
796 
797 // =============================================================================================================================
798 // Everything which is related tof the auditing process comes here.
799 // =============================================================================================================================
800   /**
801    * @dev Throws if called by any account other than the foundation board
802    */
803   modifier onlyFoundationBoard() {
804     require(msg.sender == foundationBoard);
805     _;
806   }
807 
808   /**
809    * @dev Throws if called by any account other than the auditor.
810    */
811   modifier onlyAuditor() {
812     require(msg.sender == auditor);
813     _;
814   }
815   
816   /**
817    * @dev Throws if auditor has not yet confirmed TGE
818    */
819   modifier auditorConfirmed() {
820     require(auditorComment != 0x0);
821     _;
822   }
823 
824  /*
825  * After the TGE reaches state 'auditing', the auditor will verify the legal and regulatory obligations 
826  */
827  function confirmLawfulness(bool _regulationsFulfilled, bytes32 _auditorComment) public onlyAuditor stateTransitions inState ( States.Auditing ) {
828     regulationsFulfilled = _regulationsFulfilled;
829     auditorComment = _auditorComment;
830     LogRegularityConfirmation(msg.sender, _regulationsFulfilled, _auditorComment);
831   }
832 
833   /**
834    * After the auditor has verified the the legal and regulatory obligations of the TGE, the foundation board is able to finalize the TGE.
835    * The finalization consists of the following steps:
836    * - Transit state
837    * - close the RefundVault and transfer funds to the foundation wallet
838    * - release tokens (make transferable)
839    * - enable scheduler for the inflation compensation
840    * - Min the defined amount of token per team and make them vestable
841    */
842   function finalize() public onlyFoundationBoard stateTransitions inState ( States.Auditing ) auditorConfirmed {
843     setState(States.Finalized);
844     // Make token transferable otherwise the transfer call used when granting vesting to teams will be rejected.
845     token.releaseTokenTransfer();
846     
847     // mint bonusus for 
848     allocateTeamBonusTokens();
849 
850     // the funds can now be transfered to the multisig wallet of the foundation
851     vault.close();
852 
853     // disable minting for the TGE (though tokens will still be minted to compensate an inflation period) 
854     token.finishMinting();
855 
856     // now we can safely enable the shceduler for inflation compensation
857     token.enableScheduler();
858 
859     // pass ownership from contract to SmartOne
860     token.transferOwnership(owner);
861 
862     LogFinalized(msg.sender);
863   }
864 
865   function enableRefunds() public onlyFoundationBoard stateTransitions inState ( States.Auditing ) auditorConfirmed {
866     setState(States.Refunding);
867 
868     LogRefundsEnabled(msg.sender);
869 
870     // no need to trigger event here since this allready done in RefundVault (see event RefundsEnabled) 
871     vault.enableRefunds(); 
872   }
873   
874 
875 // =============================================================================================================================
876 // Postallocation Reward Tokens
877 // =============================================================================================================================
878   
879   /** 
880   * Called once by TGE finalize() if the sale was success.
881   */
882   function allocateTeamBonusTokens() private {
883 
884     for (uint i = 0; i < teamBonuses.length; i++) {
885       // How many % of tokens the team member receive as rewards
886       uint _teamBonusTokens = (tokensSold.mul(teamBonuses[i].tokenBps)).div(10000);
887 
888       // mint new tokens for contributors
889       token.mint(this, _teamBonusTokens);
890       token.grantVestedTokens(teamBonuses[i].toAddress, _teamBonusTokens, uint64(now), teamBonuses[i].cliffDate, teamBonuses[i].vestingDate, false, false);
891       teamBonusAllocatedTokens = teamBonusAllocatedTokens.add(_teamBonusTokens);
892     }
893   }
894 
895   // =============================================================================================================================
896   // All functions related to Refunding can be found here. 
897   // Uses some slightly modifed logic from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundableTGE.sol
898   // =============================================================================================================================
899 
900   /** We're overriding the fund forwarding from TGE.
901   * In addition to sending the funds, we want to call
902   * the RefundVault deposit function
903   */
904   function forwardFunds() internal {
905     vault.deposit.value(msg.value)(msg.sender);
906   }
907 
908   /**
909   * If TGE was not successfull refunding process will be released by SmartOne
910   */
911   function claimRefund() public stateTransitions inState ( States.Refunding ) {
912     // workaround since vault refund does not return refund value
913     weiRefunded = weiRefunded.add(vault.deposited(msg.sender));
914     vault.refund(msg.sender);
915   }
916 }
917 
918 contract ERC20Basic {
919   uint256 public totalSupply;
920   function balanceOf(address who) public constant returns (uint256);
921   function transfer(address to, uint256 value) public returns (bool);
922   event Transfer(address indexed from, address indexed to, uint256 value);
923 }
924 
925 contract ERC20 is ERC20Basic {
926   function allowance(address owner, address spender) public constant returns (uint256);
927   function transferFrom(address from, address to, uint256 value) public returns (bool);
928   function approve(address spender, uint256 value) public returns (bool);
929   event Approval(address indexed owner, address indexed spender, uint256 value);
930 }
931 
932 contract BasicToken is ERC20Basic {
933   using SafeMath for uint256;
934 
935   mapping(address => uint256) balances;
936 
937   /**
938   * @dev transfer token for a specified address
939   * @param _to The address to transfer to.
940   * @param _value The amount to be transferred.
941   */
942   function transfer(address _to, uint256 _value) public returns (bool) {
943     require(_to != address(0));
944 
945     // SafeMath.sub will throw if there is not enough balance.
946     balances[msg.sender] = balances[msg.sender].sub(_value);
947     balances[_to] = balances[_to].add(_value);
948     Transfer(msg.sender, _to, _value);
949     return true;
950   }
951 
952   /**
953   * @dev Gets the balance of the specified address.
954   * @param _owner The address to query the the balance of.
955   * @return An uint256 representing the amount owned by the passed address.
956   */
957   function balanceOf(address _owner) public constant returns (uint256 balance) {
958     return balances[_owner];
959   }
960 
961 }
962 
963 contract StandardToken is ERC20, BasicToken {
964 
965   mapping (address => mapping (address => uint256)) allowed;
966 
967 
968   /**
969    * @dev Transfer tokens from one address to another
970    * @param _from address The address which you want to send tokens from
971    * @param _to address The address which you want to transfer to
972    * @param _value uint256 the amount of tokens to be transferred
973    */
974   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
975     require(_to != address(0));
976 
977     uint256 _allowance = allowed[_from][msg.sender];
978 
979     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
980     // require (_value <= _allowance);
981 
982     balances[_from] = balances[_from].sub(_value);
983     balances[_to] = balances[_to].add(_value);
984     allowed[_from][msg.sender] = _allowance.sub(_value);
985     Transfer(_from, _to, _value);
986     return true;
987   }
988 
989   /**
990    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
991    *
992    * Beware that changing an allowance with this method brings the risk that someone may use both the old
993    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
994    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
995    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
996    * @param _spender The address which will spend the funds.
997    * @param _value The amount of tokens to be spent.
998    */
999   function approve(address _spender, uint256 _value) public returns (bool) {
1000     allowed[msg.sender][_spender] = _value;
1001     Approval(msg.sender, _spender, _value);
1002     return true;
1003   }
1004 
1005   /**
1006    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1007    * @param _owner address The address which owns the funds.
1008    * @param _spender address The address which will spend the funds.
1009    * @return A uint256 specifying the amount of tokens still available for the spender.
1010    */
1011   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
1012     return allowed[_owner][_spender];
1013   }
1014 
1015   /**
1016    * approve should be called when allowed[_spender] == 0. To increment
1017    * allowed value is better to use this function to avoid 2 calls (and wait until
1018    * the first transaction is mined)
1019    * From MonolithDAO Token.sol
1020    */
1021   function increaseApproval (address _spender, uint _addedValue)
1022     returns (bool success) {
1023     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1024     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1025     return true;
1026   }
1027 
1028   function decreaseApproval (address _spender, uint _subtractedValue)
1029     returns (bool success) {
1030     uint oldValue = allowed[msg.sender][_spender];
1031     if (_subtractedValue > oldValue) {
1032       allowed[msg.sender][_spender] = 0;
1033     } else {
1034       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1035     }
1036     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1037     return true;
1038   }
1039 
1040 }
1041 
1042 contract MintableToken is StandardToken, Ownable {
1043   event Mint(address indexed to, uint256 amount);
1044   event MintFinished();
1045 
1046   bool public mintingFinished = false;
1047 
1048 
1049   modifier canMint() {
1050     require(!mintingFinished);
1051     _;
1052   }
1053 
1054   /**
1055    * @dev Function to mint tokens
1056    * @param _to The address that will receive the minted tokens.
1057    * @param _amount The amount of tokens to mint.
1058    * @return A boolean that indicates if the operation was successful.
1059    */
1060   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
1061     totalSupply = totalSupply.add(_amount);
1062     balances[_to] = balances[_to].add(_amount);
1063     Mint(_to, _amount);
1064     Transfer(0x0, _to, _amount);
1065     return true;
1066   }
1067 
1068   /**
1069    * @dev Function to stop minting new tokens.
1070    * @return True if the operation was successful.
1071    */
1072   function finishMinting() onlyOwner public returns (bool) {
1073     mintingFinished = true;
1074     MintFinished();
1075     return true;
1076   }
1077 }
1078 
1079 contract LimitedTransferToken is ERC20 {
1080 
1081   /**
1082    * @dev Checks whether it can transfer or otherwise throws.
1083    */
1084   modifier canTransfer(address _sender, uint256 _value) {
1085     require(_value <= transferableTokens(_sender, uint64(now)));
1086    _;
1087   }
1088 
1089   /**
1090    * @dev Checks modifier and allows transfer if tokens are not locked.
1091    * @param _to The address that will receive the tokens.
1092    * @param _value The amount of tokens to be transferred.
1093    */
1094   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
1095     return super.transfer(_to, _value);
1096   }
1097 
1098   /**
1099   * @dev Checks modifier and allows transfer if tokens are not locked.
1100   * @param _from The address that will send the tokens.
1101   * @param _to The address that will receive the tokens.
1102   * @param _value The amount of tokens to be transferred.
1103   */
1104   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
1105     return super.transferFrom(_from, _to, _value);
1106   }
1107 
1108   /**
1109    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
1110    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
1111    * specific logic for limiting token transferability for a holder over time.
1112    */
1113   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
1114     return balanceOf(holder);
1115   }
1116 }
1117 
1118 contract VestedToken is StandardToken, LimitedTransferToken, Ownable {
1119 
1120   uint256 MAX_GRANTS_PER_ADDRESS = 20;
1121 
1122   struct TokenGrant {
1123     address granter;     // 20 bytes
1124     uint256 value;       // 32 bytes
1125     uint64 cliff;
1126     uint64 vesting;
1127     uint64 start;        // 3 * 8 = 24 bytes
1128     bool revokable;
1129     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
1130   } // total 78 bytes = 3 sstore per operation (32 per sstore)
1131 
1132   mapping (address => TokenGrant[]) public grants;
1133 
1134   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
1135 
1136   /**
1137    * @dev Grant tokens to a specified address
1138    * @param _to address The address which the tokens will be granted to.
1139    * @param _value uint256 The amount of tokens to be granted.
1140    * @param _start uint64 Time of the beginning of the grant.
1141    * @param _cliff uint64 Time of the cliff period.
1142    * @param _vesting uint64 The vesting period.
1143    */
1144   function grantVestedTokens(
1145     address _to,
1146     uint256 _value,
1147     uint64 _start,
1148     uint64 _cliff,
1149     uint64 _vesting,
1150     bool _revokable,
1151     bool _burnsOnRevoke
1152   ) onlyOwner public {
1153 
1154     // Check for date inconsistencies that may cause unexpected behavior
1155     require(_cliff >= _start && _vesting >= _cliff);
1156 
1157     require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
1158 
1159     uint256 count = grants[_to].push(
1160                 TokenGrant(
1161                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
1162                   _value,
1163                   _cliff,
1164                   _vesting,
1165                   _start,
1166                   _revokable,
1167                   _burnsOnRevoke
1168                 )
1169               );
1170 
1171     transfer(_to, _value);
1172 
1173     NewTokenGrant(msg.sender, _to, _value, count - 1);
1174   }
1175 
1176   /**
1177    * @dev Revoke the grant of tokens of a specifed address.
1178    * @param _holder The address which will have its tokens revoked.
1179    * @param _grantId The id of the token grant.
1180    */
1181   function revokeTokenGrant(address _holder, uint256 _grantId) public {
1182     TokenGrant storage grant = grants[_holder][_grantId];
1183 
1184     require(grant.revokable);
1185     require(grant.granter == msg.sender); // Only granter can revoke it
1186 
1187     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
1188 
1189     uint256 nonVested = nonVestedTokens(grant, uint64(now));
1190 
1191     // remove grant from array
1192     delete grants[_holder][_grantId];
1193     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
1194     grants[_holder].length -= 1;
1195 
1196     balances[receiver] = balances[receiver].add(nonVested);
1197     balances[_holder] = balances[_holder].sub(nonVested);
1198 
1199     Transfer(_holder, receiver, nonVested);
1200   }
1201 
1202 
1203   /**
1204    * @dev Calculate the total amount of transferable tokens of a holder at a given time
1205    * @param holder address The address of the holder
1206    * @param time uint64 The specific time.
1207    * @return An uint256 representing a holder's total amount of transferable tokens.
1208    */
1209   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
1210     uint256 grantIndex = tokenGrantsCount(holder);
1211 
1212     if (grantIndex == 0) 
1213       return super.transferableTokens(holder, time); // shortcut for holder without grants
1214 
1215     // Iterate through all the grants the holder has, and add all non-vested tokens
1216     uint256 nonVested = 0;
1217     for (uint256 i = 0; i < grantIndex; i++) {
1218       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
1219     }
1220 
1221     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
1222     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
1223 
1224     // Return the minimum of how many vested can transfer and other value
1225     // in case there are other limiting transferability factors (default is balanceOf)
1226     return Math.min256(vestedTransferable, super.transferableTokens(holder, time));
1227   }
1228 
1229   /**
1230    * @dev Check the amount of grants that an address has.
1231    * @param _holder The holder of the grants.
1232    * @return A uint256 representing the total amount of grants.
1233    */
1234   function tokenGrantsCount(address _holder) public constant returns (uint256 index) {
1235     return grants[_holder].length;
1236   }
1237 
1238   /**
1239    * @dev Calculate amount of vested tokens at a specific time
1240    * @param tokens uint256 The amount of tokens granted
1241    * @param time uint64 The time to be checked
1242    * @param start uint64 The time representing the beginning of the grant
1243    * @param cliff uint64  The cliff period, the period before nothing can be paid out
1244    * @param vesting uint64 The vesting period
1245    * @return An uint256 representing the amount of vested tokens of a specific grant
1246    *  transferableTokens
1247    *   |                         _/--------   vestedTokens rect
1248    *   |                       _/
1249    *   |                     _/
1250    *   |                   _/
1251    *   |                 _/
1252    *   |                /
1253    *   |              .|
1254    *   |            .  |
1255    *   |          .    |
1256    *   |        .      |
1257    *   |      .        |
1258    *   |    .          |
1259    *   +===+===========+---------+----------> time
1260    *      Start       Cliff    Vesting
1261    */
1262   function calculateVestedTokens(
1263     uint256 tokens,
1264     uint256 time,
1265     uint256 start,
1266     uint256 cliff,
1267     uint256 vesting) public constant returns (uint256)
1268     {
1269       // Shortcuts for before cliff and after vesting cases.
1270       if (time < cliff) return 0;
1271       if (time >= vesting) return tokens;
1272 
1273       // Interpolate all vested tokens.
1274       // As before cliff the shortcut returns 0, we can use just calculate a value
1275       // in the vesting rect (as shown in above's figure)
1276 
1277       // vestedTokens = (tokens * (time - start)) / (vesting - start)
1278       uint256 vestedTokens = SafeMath.div(
1279                                     SafeMath.mul(
1280                                       tokens,
1281                                       SafeMath.sub(time, start)
1282                                       ),
1283                                     SafeMath.sub(vesting, start)
1284                                     );
1285 
1286       return vestedTokens;
1287   }
1288 
1289   /**
1290    * @dev Get all information about a specific grant.
1291    * @param _holder The address which will have its tokens revoked.
1292    * @param _grantId The id of the token grant.
1293    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
1294    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
1295    */
1296   function tokenGrant(address _holder, uint256 _grantId) public constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
1297     TokenGrant storage grant = grants[_holder][_grantId];
1298 
1299     granter = grant.granter;
1300     value = grant.value;
1301     start = grant.start;
1302     cliff = grant.cliff;
1303     vesting = grant.vesting;
1304     revokable = grant.revokable;
1305     burnsOnRevoke = grant.burnsOnRevoke;
1306 
1307     vested = vestedTokens(grant, uint64(now));
1308   }
1309 
1310   /**
1311    * @dev Get the amount of vested tokens at a specific time.
1312    * @param grant TokenGrant The grant to be checked.
1313    * @param time The time to be checked
1314    * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
1315    */
1316   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
1317     return calculateVestedTokens(
1318       grant.value,
1319       uint256(time),
1320       uint256(grant.start),
1321       uint256(grant.cliff),
1322       uint256(grant.vesting)
1323     );
1324   }
1325 
1326   /**
1327    * @dev Calculate the amount of non vested tokens at a specific time.
1328    * @param grant TokenGrant The grant to be checked.
1329    * @param time uint64 The time to be checked
1330    * @return An uint256 representing the amount of non vested tokens of a specific grant on the
1331    * passed time frame.
1332    */
1333   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
1334     return grant.value.sub(vestedTokens(grant, time));
1335   }
1336 
1337   /**
1338    * @dev Calculate the date when the holder can transfer all its tokens
1339    * @param holder address The address of the holder
1340    * @return An uint256 representing the date of the last transferable tokens.
1341    */
1342   function lastTokenIsTransferableDate(address holder) public constant returns (uint64 date) {
1343     date = uint64(now);
1344     uint256 grantIndex = grants[holder].length;
1345     for (uint256 i = 0; i < grantIndex; i++) {
1346       date = Math.max64(grants[holder][i].vesting, date);
1347     }
1348   }
1349 }
1350 
1351 contract Certifier {
1352 	event Confirmed(address indexed who);
1353 	event Revoked(address indexed who);
1354 	function certified(address _who) constant returns (bool);
1355 	// function get(address _who, string _field) constant returns (bytes32) {}
1356 	// function getAddress(address _who, string _field) constant returns (address) {}
1357 	// function getUint(address _who, string _field) constant returns (uint) {}
1358 }
1359 
1360 contract SimpleCertifier is Owned, Certifier {
1361 
1362 	modifier only_delegate {
1363 		assert(msg.sender == delegate);
1364 		_; 
1365 	}
1366 	modifier only_certified(address _who) {
1367 		if (!certs[_who].active)
1368 			return;
1369 		_; 
1370 	}
1371 
1372 	struct Certification {
1373 		bool active;
1374 		mapping (string => bytes32) meta;
1375 	}
1376 
1377 	function certify(address _who) only_delegate {
1378 		certs[_who].active = true;
1379 		Confirmed(_who);
1380 	}
1381 	function revoke(address _who) only_delegate only_certified(_who) {
1382 		certs[_who].active = false;
1383 		Revoked(_who);
1384 	}
1385 	function certified(address _who) constant returns (bool) { return certs[_who].active; }
1386 	// function get(address _who, string _field) constant returns (bytes32) { return certs[_who].meta[_field]; }
1387 	// function getAddress(address _who, string _field) constant returns (address) { return address(certs[_who].meta[_field]); }
1388 	// function getUint(address _who, string _field) constant returns (uint) { return uint(certs[_who].meta[_field]); }
1389 	function setDelegate(address _new) only_owner { delegate = _new; }
1390 
1391 	mapping (address => Certification) certs;
1392 	// So that the server posting puzzles doesn't have access to the ETH.
1393 	address public delegate = msg.sender;
1394 }
1395 
1396 contract ProofOfSMS is SimpleCertifier {
1397 
1398 	modifier when_fee_paid {
1399 		if (msg.value < fee)  {
1400 		RequiredFeeNotMet(fee, msg.value);
1401 			return;
1402 		}
1403 		_; 
1404 	}
1405 	event RequiredFeeNotMet(uint required, uint provided);
1406 	event Requested(address indexed who);
1407 	event Puzzled(address who, bytes32 puzzle);
1408 
1409 	event LogAddress(address test);
1410 
1411 	function request() payable when_fee_paid {
1412 		if (certs[msg.sender].active) {
1413 			return;
1414 		}
1415 		Requested(msg.sender);
1416 	}
1417 
1418 	function puzzle (address _who, bytes32 _puzzle) only_delegate {
1419 		puzzles[_who] = _puzzle;
1420 		Puzzled(_who, _puzzle);
1421 	}
1422 
1423 	function confirm(bytes32 _code) returns (bool) {
1424 		LogAddress(msg.sender);
1425 		if (puzzles[msg.sender] != sha3(_code))
1426 			return;
1427 
1428 		delete puzzles[msg.sender];
1429 		certs[msg.sender].active = true;
1430 		Confirmed(msg.sender);
1431 		return true;
1432 	}
1433 
1434 	function setFee(uint _new) only_owner {
1435 		fee = _new;
1436 	}
1437 
1438 	function drain() only_owner {
1439 		require(msg.sender.send(this.balance));
1440 	}
1441 
1442 	function certified(address _who) constant returns (bool) {
1443 		return certs[_who].active;
1444 	}
1445 
1446 	mapping (address => bytes32) puzzles;
1447 
1448 	uint public fee = 30 finney;
1449 }
1450 
1451 contract LegalToken is LegalLazyScheduler, MintableToken, VestedToken {
1452     /**
1453     * The name of the token
1454     */
1455     bytes32 public name;
1456 
1457     /**
1458     * The symbol used for exchange
1459     */
1460     bytes32 public symbol;
1461 
1462     /**
1463     * Use to convert to number of tokens.
1464     */
1465     uint public decimals = 18;
1466 
1467     /**
1468     * The yearly expected inflation rate in base points.
1469     */
1470     uint32 public inflationCompBPS;
1471 
1472     /**
1473     * The tokens are locked until the end of the TGE.
1474     * The contract can release the tokens if TGE successful. If false we are in transfer lock up period.
1475     */
1476     bool public released = false;
1477 
1478     /**
1479     * Annually new minted tokens will be transferred to this wallet.
1480     * Publications will be rewarded with funds (incentives).  
1481     */
1482     address public rewardWallet;
1483 
1484     /**
1485     * Name and symbol were updated. 
1486     */
1487     event UpdatedTokenInformation(bytes32 newName, bytes32 newSymbol);
1488 
1489     /**
1490     * @dev Constructor that gives msg.sender all of existing tokens. 
1491     */
1492     function LegalToken(address _rewardWallet, uint32 _inflationCompBPS, uint32 _inflationCompInterval) onlyOwner public {
1493         setTokenInformation("Legal Token", "LGL");
1494         totalSupply = 0;        
1495         rewardWallet = _rewardWallet;
1496         inflationCompBPS = _inflationCompBPS;
1497         registerIntervalCall(_inflationCompInterval, mintInflationPeriod);
1498     }    
1499 
1500     /**
1501     * This function allows the token owner to rename the token after the operations
1502     * have been completed and then point the audience to use the token contract.
1503     */
1504     function setTokenInformation(bytes32 _name, bytes32 _symbol) onlyOwner public {
1505         name = _name;
1506         symbol = _symbol;
1507         UpdatedTokenInformation(name, symbol);
1508     }
1509 
1510     /**
1511     * Mint new tokens for the predefined inflation period and assign them to the reward wallet. 
1512     */
1513     function mintInflationPeriod() private {
1514         uint256 tokensToMint = totalSupply.mul(inflationCompBPS).div(10000);
1515         totalSupply = totalSupply.add(tokensToMint);
1516         balances[rewardWallet] = balances[rewardWallet].add(tokensToMint);
1517         Mint(rewardWallet, tokensToMint);
1518         Transfer(0x0, rewardWallet, tokensToMint);
1519     }     
1520     
1521     function setRewardWallet(address _rewardWallet) public onlyOwner {
1522         rewardWallet = _rewardWallet;
1523     }
1524 
1525     /**
1526     * Limit token transfer until the TGE is over.
1527     */
1528     modifier tokenReleased(address _sender) {
1529         require(released);
1530         _;
1531     }
1532 
1533     /**
1534     * This will make the tokens transferable
1535     */
1536     function releaseTokenTransfer() public onlyOwner {
1537         released = true;
1538     }
1539 
1540     // error: canTransfer(msg.sender, _value)
1541     function transfer(address _to, uint _value) public tokenReleased(msg.sender) intervalTrigger returns (bool success) {
1542         // Calls StandardToken.transfer()
1543         // error: super.transfer(_to, _value);
1544         return super.transfer(_to, _value);
1545     }
1546 
1547     function transferFrom(address _from, address _to, uint _value) public tokenReleased(_from) intervalTrigger returns (bool success) {
1548         // Calls StandardToken.transferForm()
1549         return super.transferFrom(_from, _to, _value);
1550     }
1551 
1552     function approve(address _spender, uint256 _value) public tokenReleased(msg.sender) intervalTrigger returns (bool) {
1553         // calls StandardToken.approve(..)
1554         return super.approve(_spender, _value);
1555     }
1556 
1557     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
1558         // calls StandardToken.allowance(..)
1559         return super.allowance(_owner, _spender);
1560     }
1561 
1562     function increaseApproval (address _spender, uint _addedValue) public tokenReleased(msg.sender) intervalTrigger returns (bool success) {
1563         // calls StandardToken.increaseApproval(..)
1564         return super.increaseApproval(_spender, _addedValue);
1565     }
1566 
1567     function decreaseApproval (address _spender, uint _subtractedValue) public tokenReleased(msg.sender) intervalTrigger returns (bool success) {
1568         // calls StandardToken.decreaseApproval(..)
1569         return super.decreaseApproval(_spender, _subtractedValue);
1570     }
1571 }