1 pragma solidity ^0.4.13;
2 
3 contract Crowdsale {
4   using SafeMath for uint256;
5 
6   // The token being sold
7   ERC20 public token;
8 
9   // Address where funds are collected
10   address public wallet;
11 
12   // How many token units a buyer gets per wei.
13   // The rate is the conversion between wei and the smallest and indivisible token unit.
14   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
15   // 1 wei will give you 1 unit, or 0.001 TOK.
16   uint256 public rate;
17 
18   // Amount of wei raised
19   uint256 public weiRaised;
20 
21   /**
22    * Event for token purchase logging
23    * @param purchaser who paid for the tokens
24    * @param beneficiary who got the tokens
25    * @param value weis paid for purchase
26    * @param amount amount of tokens purchased
27    */
28   event TokenPurchase(
29     address indexed purchaser,
30     address indexed beneficiary,
31     uint256 value,
32     uint256 amount
33   );
34 
35   /**
36    * @param _rate Number of token units a buyer gets per wei
37    * @param _wallet Address where collected funds will be forwarded to
38    * @param _token Address of the token being sold
39    */
40   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
41     require(_rate > 0);
42     require(_wallet != address(0));
43     require(_token != address(0));
44 
45     rate = _rate;
46     wallet = _wallet;
47     token = _token;
48   }
49 
50   // -----------------------------------------
51   // Crowdsale external interface
52   // -----------------------------------------
53 
54   /**
55    * @dev fallback function ***DO NOT OVERRIDE***
56    */
57   function () external payable {
58     buyTokens(msg.sender);
59   }
60 
61   /**
62    * @dev low level token purchase ***DO NOT OVERRIDE***
63    * @param _beneficiary Address performing the token purchase
64    */
65   function buyTokens(address _beneficiary) public payable {
66 
67     uint256 weiAmount = msg.value;
68     _preValidatePurchase(_beneficiary, weiAmount);
69 
70     // calculate token amount to be created
71     uint256 tokens = _getTokenAmount(weiAmount);
72 
73     // update state
74     weiRaised = weiRaised.add(weiAmount);
75 
76     _processPurchase(_beneficiary, tokens);
77     emit TokenPurchase(
78       msg.sender,
79       _beneficiary,
80       weiAmount,
81       tokens
82     );
83 
84     _updatePurchasingState(_beneficiary, weiAmount);
85 
86     _forwardFunds();
87     _postValidatePurchase(_beneficiary, weiAmount);
88   }
89 
90   // -----------------------------------------
91   // Internal interface (extensible)
92   // -----------------------------------------
93 
94   /**
95    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
96    * @param _beneficiary Address performing the token purchase
97    * @param _weiAmount Value in wei involved in the purchase
98    */
99   function _preValidatePurchase(
100     address _beneficiary,
101     uint256 _weiAmount
102   )
103     internal
104   {
105     require(_beneficiary != address(0));
106     require(_weiAmount != 0);
107   }
108 
109   /**
110    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
111    * @param _beneficiary Address performing the token purchase
112    * @param _weiAmount Value in wei involved in the purchase
113    */
114   function _postValidatePurchase(
115     address _beneficiary,
116     uint256 _weiAmount
117   )
118     internal
119   {
120     // optional override
121   }
122 
123   /**
124    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
125    * @param _beneficiary Address performing the token purchase
126    * @param _tokenAmount Number of tokens to be emitted
127    */
128   function _deliverTokens(
129     address _beneficiary,
130     uint256 _tokenAmount
131   )
132     internal
133   {
134     token.transfer(_beneficiary, _tokenAmount);
135   }
136 
137   /**
138    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
139    * @param _beneficiary Address receiving the tokens
140    * @param _tokenAmount Number of tokens to be purchased
141    */
142   function _processPurchase(
143     address _beneficiary,
144     uint256 _tokenAmount
145   )
146     internal
147   {
148     _deliverTokens(_beneficiary, _tokenAmount);
149   }
150 
151   /**
152    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
153    * @param _beneficiary Address receiving the tokens
154    * @param _weiAmount Value in wei involved in the purchase
155    */
156   function _updatePurchasingState(
157     address _beneficiary,
158     uint256 _weiAmount
159   )
160     internal
161   {
162     // optional override
163   }
164 
165   /**
166    * @dev Override to extend the way in which ether is converted to tokens.
167    * @param _weiAmount Value in wei to be converted into tokens
168    * @return Number of tokens that can be purchased with the specified _weiAmount
169    */
170   function _getTokenAmount(uint256 _weiAmount)
171     internal view returns (uint256)
172   {
173     return _weiAmount.mul(rate);
174   }
175 
176   /**
177    * @dev Determines how ETH is stored/forwarded on purchases.
178    */
179   function _forwardFunds() internal {
180     wallet.transfer(msg.value);
181   }
182 }
183 
184 library SafeMath {
185 
186   /**
187   * @dev Multiplies two numbers, throws on overflow.
188   */
189   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
190     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
191     // benefit is lost if 'b' is also tested.
192     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
193     if (a == 0) {
194       return 0;
195     }
196 
197     c = a * b;
198     assert(c / a == b);
199     return c;
200   }
201 
202   /**
203   * @dev Integer division of two numbers, truncating the quotient.
204   */
205   function div(uint256 a, uint256 b) internal pure returns (uint256) {
206     // assert(b > 0); // Solidity automatically throws when dividing by 0
207     // uint256 c = a / b;
208     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209     return a / b;
210   }
211 
212   /**
213   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
214   */
215   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216     assert(b <= a);
217     return a - b;
218   }
219 
220   /**
221   * @dev Adds two numbers, throws on overflow.
222   */
223   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
224     c = a + b;
225     assert(c >= a);
226     return c;
227   }
228 }
229 
230 contract Ownable {
231   address public owner;
232 
233 
234   event OwnershipRenounced(address indexed previousOwner);
235   event OwnershipTransferred(
236     address indexed previousOwner,
237     address indexed newOwner
238   );
239 
240 
241   /**
242    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
243    * account.
244    */
245   constructor() public {
246     owner = msg.sender;
247   }
248 
249   /**
250    * @dev Throws if called by any account other than the owner.
251    */
252   modifier onlyOwner() {
253     require(msg.sender == owner);
254     _;
255   }
256 
257   /**
258    * @dev Allows the current owner to relinquish control of the contract.
259    */
260   function renounceOwnership() public onlyOwner {
261     emit OwnershipRenounced(owner);
262     owner = address(0);
263   }
264 
265   /**
266    * @dev Allows the current owner to transfer control of the contract to a newOwner.
267    * @param _newOwner The address to transfer ownership to.
268    */
269   function transferOwnership(address _newOwner) public onlyOwner {
270     _transferOwnership(_newOwner);
271   }
272 
273   /**
274    * @dev Transfers control of the contract to a newOwner.
275    * @param _newOwner The address to transfer ownership to.
276    */
277   function _transferOwnership(address _newOwner) internal {
278     require(_newOwner != address(0));
279     emit OwnershipTransferred(owner, _newOwner);
280     owner = _newOwner;
281   }
282 }
283 
284 contract WhitelistedCrowdsale is Crowdsale, Ownable {
285 
286   mapping(address => bool) public whitelist;
287 
288   /**
289    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
290    */
291   modifier isWhitelisted(address _beneficiary) {
292     require(whitelist[_beneficiary]);
293     _;
294   }
295 
296   /**
297    * @dev Adds single address to whitelist.
298    * @param _beneficiary Address to be added to the whitelist
299    */
300   function addToWhitelist(address _beneficiary) external onlyOwner {
301     whitelist[_beneficiary] = true;
302   }
303 
304   /**
305    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
306    * @param _beneficiaries Addresses to be added to the whitelist
307    */
308   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
309     for (uint256 i = 0; i < _beneficiaries.length; i++) {
310       whitelist[_beneficiaries[i]] = true;
311     }
312   }
313 
314   /**
315    * @dev Removes single address from whitelist.
316    * @param _beneficiary Address to be removed to the whitelist
317    */
318   function removeFromWhitelist(address _beneficiary) external onlyOwner {
319     whitelist[_beneficiary] = false;
320   }
321 
322   /**
323    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
324    * @param _beneficiary Token beneficiary
325    * @param _weiAmount Amount of wei contributed
326    */
327   function _preValidatePurchase(
328     address _beneficiary,
329     uint256 _weiAmount
330   )
331     internal
332     isWhitelisted(_beneficiary)
333   {
334     super._preValidatePurchase(_beneficiary, _weiAmount);
335   }
336 
337 }
338 
339 contract Pausable is Ownable {
340   event Pause();
341   event Unpause();
342 
343   bool public paused = false;
344 
345 
346   /**
347    * @dev Modifier to make a function callable only when the contract is not paused.
348    */
349   modifier whenNotPaused() {
350     require(!paused);
351     _;
352   }
353 
354   /**
355    * @dev Modifier to make a function callable only when the contract is paused.
356    */
357   modifier whenPaused() {
358     require(paused);
359     _;
360   }
361 
362   /**
363    * @dev called by the owner to pause, triggers stopped state
364    */
365   function pause() onlyOwner whenNotPaused public {
366     paused = true;
367     emit Pause();
368   }
369 
370   /**
371    * @dev called by the owner to unpause, returns to normal state
372    */
373   function unpause() onlyOwner whenPaused public {
374     paused = false;
375     emit Unpause();
376   }
377 }
378 
379 contract OMICrowdsale is WhitelistedCrowdsale, Pausable {
380   using SafeMath for uint256;
381 
382   /* 
383    *  Constants
384    */
385   uint256 constant crowdsaleStartTime = 1530273600; // Pacific/Auckland 2018-06-30 00:00:00 
386   uint256 constant crowdsaleUSDGoal = 22125000;
387   uint256 constant crowdsaleTokenGoal = 362500000*1e18;
388   uint256 constant minimumTokenPurchase = 2500*1e18;
389   uint256 constant maximumTokenPurchase = 5000000*1e18;
390 
391   /*
392    *  Storage
393    */
394   OMIToken public token;
395   OMITokenLock public tokenLock;
396 
397   uint256 public totalUSDRaised;
398   uint256 public totalTokensSold;
399   bool public isFinalized = false;
400   uint256 public crowdsaleFinishTime = 1540983599; // Pacific/Auckland 2018-10-31 11:59:59
401 
402   mapping(address => uint256) public purchaseRecords;
403 
404   /*
405    *  Events
406    */
407   event RateChanged(uint256 newRate);
408   event USDRaisedUpdated(uint256 newTotal);
409   event WhitelistAddressAdded(address newWhitelistAddress);
410   event WhitelistAddressRemoved(address removedWhitelistAddress);
411   event CrowdsaleStarted();
412   event CrowdsaleFinished();
413 
414 
415   /*
416    *  Modifiers
417    */
418   modifier whenNotFinalized () {
419     require(!isFinalized);
420     _;
421   }
422 
423   /*
424    *  Public Functions
425    */
426   /// @dev Contract constructor sets...
427   function OMICrowdsale (
428     uint256 _startingRate,
429     address _ETHWallet,
430     address _OMIToken,
431     address _OMITokenLock
432   )
433     Crowdsale(_startingRate, _ETHWallet, ERC20(_OMIToken))
434     public
435   {
436     token = OMIToken(_OMIToken);
437     require(token.isOMITokenContract());
438 
439     tokenLock = OMITokenLock(_OMITokenLock);
440     require(tokenLock.isOMITokenLockContract());
441 
442     rate = _startingRate;
443   }
444 
445   /// @dev Function to call from other contracts to ensure that this is the proper contract
446   function isOMICrowdsaleContract()
447     public 
448     pure 
449     returns(bool)
450   { 
451     return true; 
452   }
453 
454   /// @dev Function to check if crowdsale is open
455   function isOpen()
456     public
457     view
458     whenNotPaused
459     whenNotFinalized
460     returns(bool)
461   {
462     return now >= crowdsaleStartTime;
463   }
464 
465   /// @dev Allows the owner to set the current rate for calculating the number of tokens for a purchase.
466   /// @dev An external cron job will fetch the ETH/USD daily average from the cryptocompare API and call this function.
467   function setRate(uint256 _newRate)
468     public
469     onlyOwner
470     whenNotFinalized
471     returns(bool)
472   {
473     require(_newRate > 0);
474     rate = _newRate;
475     RateChanged(rate);
476     return true;
477   }
478 
479   /// @dev Allows the owner to update the total amount of USD raised. T
480   function setUSDRaised(uint256 _total)
481     public
482     onlyOwner
483     whenNotFinalized
484   {
485     require(_total > 0);
486     totalUSDRaised = _total;
487     USDRaisedUpdated(_total);
488   }
489 
490   /// @dev Gets the purchase records for a given address
491   /// @param _beneficiary Tokan purchaser
492   function getPurchaseRecord(address _beneficiary) 
493     public 
494     view 
495     isWhitelisted(_beneficiary)
496     returns(uint256)
497   {
498     return purchaseRecords[_beneficiary];
499   }
500 
501   /// @dev Adds single address to whitelist
502   /// @param _beneficiary Address to be added to the whitelist
503   function addToWhitelist(address _beneficiary) external onlyOwner {
504     whitelist[_beneficiary] = true;
505     WhitelistAddressAdded(_beneficiary);
506   }
507 
508   /// @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
509   /// @param _beneficiaries Addresses to be added to the whitelist
510   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
511     for (uint256 i = 0; i < _beneficiaries.length; i++) {
512       whitelist[_beneficiaries[i]] = true;
513       WhitelistAddressAdded(_beneficiaries[i]);
514     }
515   }
516 
517   /// @dev Removes single address from whitelist.
518   /// @param _beneficiary Address to be removed to the whitelist
519   function removeFromWhitelist(address _beneficiary) external onlyOwner {
520     whitelist[_beneficiary] = false;
521     WhitelistAddressRemoved(_beneficiary);
522   }
523 
524   /// @dev Finalizes the crowdsale
525   function finalize() external onlyOwner {
526     _finalization();
527   }
528 
529   /// @dev set finish time
530   function setFinishTime(uint256 _newCrowdsaleFinishTime) external
531     whenNotFinalized
532     onlyOwner
533   {
534     require(_newCrowdsaleFinishTime > crowdsaleStartTime);
535     crowdsaleFinishTime = _newCrowdsaleFinishTime;
536   }
537 
538   /*
539    *  Internal Functions
540    */
541   /// @dev Extend parent behavior to check if current stage should close. Must call super to ensure the enforcement of the whitelist.
542   /// @param _beneficiary Token purchaser
543   /// @param _weiAmount Amount of wei contributed
544   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
545     internal
546     whenNotPaused
547     whenNotFinalized
548    {
549     super._preValidatePurchase(_beneficiary, _weiAmount);
550 
551     // Beneficiary's total should be between the minimum and maximum purchase amounts
552     uint256 _totalPurchased = purchaseRecords[_beneficiary].add(_getTokenAmount(_weiAmount));
553     require(_totalPurchased >= minimumTokenPurchase);
554     require(_totalPurchased <= maximumTokenPurchase);
555 
556     // Must make the purchase from the intended whitelisted address
557     require(msg.sender == _beneficiary);
558 
559     // Must be after the start time
560     require(now >= crowdsaleStartTime);
561   }
562 
563   /// @dev Overrides parent by storing balances in timelock contract instead of issuing tokens right away.
564   /// @param _beneficiary Token purchaser
565   /// @param _tokenAmount Amount of tokens purchased
566   function _processPurchase(address _beneficiary, uint256 _tokenAmount)
567     internal
568   {
569     // Lock beneficiary's tokens
570     tokenLock.lockTokens(_beneficiary, 1 weeks, _tokenAmount);
571   }
572 
573   /// @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
574   /// @param _beneficiary Address receiving the tokens
575   /// @param _weiAmount Value in wei involved in the purchase
576   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount)
577     internal
578   {
579     uint256 _tokenAmount = _getTokenAmount(_weiAmount);
580 
581     // Add token amount to the purchase history
582     purchaseRecords[_beneficiary] = purchaseRecords[_beneficiary].add(_tokenAmount);
583     
584     // Add token amount to total tokens sold
585     totalTokensSold = totalTokensSold.add(_tokenAmount);
586 
587     // Finish the crowdsale...
588     // ...if there is not a minimum purchase left
589     if (crowdsaleTokenGoal.sub(totalTokensSold) < minimumTokenPurchase) {
590       _finalization();
591     }
592     // ...if USD funding goal has been reached
593     if (totalUSDRaised >= crowdsaleUSDGoal) {
594       _finalization();
595     }
596     // ...if the time is after the crowdsale end time
597     if (now > crowdsaleFinishTime) {
598       _finalization();
599     }
600   }
601 
602   /// @dev Finalizes crowdsale
603   function _finalization()
604     internal
605     whenNotFinalized
606   {
607     isFinalized = true;
608     tokenLock.finishCrowdsale();
609     CrowdsaleFinished();
610   }
611 }
612 
613 contract OMITokenLock is Ownable, Pausable {
614   using SafeMath for uint256;
615 
616   /*
617    *  Storage
618    */
619   OMIToken public token;
620   OMICrowdsale public crowdsale;
621   address public allowanceProvider;
622   bool public crowdsaleFinished = false;
623   uint256 public crowdsaleEndTime;
624 
625   struct Lock {
626     uint256 amount;
627     uint256 lockDuration;
628     bool released;
629     bool revoked;
630   }
631   struct TokenLockVault {
632     address beneficiary;
633     uint256 tokenBalance;
634     uint256 lockIndex;
635     Lock[] locks;
636   }
637   mapping(address => TokenLockVault) public tokenLocks;
638   address[] public lockIndexes;
639   uint256 public totalTokensLocked;
640 
641   /*
642    *  Modifiers
643    */
644   modifier ownerOrCrowdsale () {
645     require(msg.sender == owner || OMICrowdsale(msg.sender) == crowdsale);
646     _;
647   }
648 
649   /*
650    *  Events
651    */
652   event LockedTokens(address indexed beneficiary, uint256 amount, uint256 releaseTime);
653   event UnlockedTokens(address indexed beneficiary, uint256 amount);
654   event FinishedCrowdsale();
655 
656   /*
657    *  Public Functions
658    */
659   /// @dev Constructor function
660   function OMITokenLock (address _token, address _allowanceProvider) public {
661     token = OMIToken(_token);
662     require(token.isOMITokenContract());
663 
664     allowanceProvider = _allowanceProvider;
665   }
666 
667   /// @dev Function to call from other contracts to ensure that this is the proper contract
668   function isOMITokenLockContract()
669     public 
670     pure 
671     returns(bool)
672   { 
673     return true; 
674   }
675 
676   /// @dev Sets the crowdsale address to allow authorize locking permissions
677   /// @param _crowdsale The address of the crowdsale
678   function setCrowdsaleAddress (address _crowdsale)
679     public
680     onlyOwner
681     returns (bool)
682   {
683     crowdsale = OMICrowdsale(_crowdsale);
684     require(crowdsale.isOMICrowdsaleContract());
685 
686     return true;
687   }
688 
689   /// @dev Sets the token allowance provider address
690   /// @param _allowanceProvider The address of the token allowance provider
691   function setAllowanceAddress (address _allowanceProvider)
692     public
693     onlyOwner
694     returns (bool)
695   {
696     allowanceProvider = _allowanceProvider;
697     return true;
698   }
699 
700   /// @dev Marks the crowdsale as being finished and sets the crowdsale finish date
701   function finishCrowdsale()
702     public
703     ownerOrCrowdsale
704     whenNotPaused
705   {
706     require(!crowdsaleFinished);
707     crowdsaleFinished = true;
708     crowdsaleEndTime = now;
709     FinishedCrowdsale();
710   }
711 
712   /// @dev Gets the total amount of tokens for a given address
713   /// @param _beneficiary The address for which to look up the total token amount
714   function getTokenBalance(address _beneficiary)
715     public
716     view
717     returns (uint)
718   {
719     return tokenLocks[_beneficiary].tokenBalance;
720   }
721 
722   /// @dev Gets the total number of locks for a given address
723   /// @param _beneficiary The address for which to look up the total number of locks
724   function getNumberOfLocks(address _beneficiary)
725     public
726     view
727     returns (uint)
728   {
729     return tokenLocks[_beneficiary].locks.length;
730   }
731 
732   /// @dev Gets the lock at a given index for a given address
733   /// @param _beneficiary The address used to look up the lock
734   /// @param _lockIndex The index used to look up the lock
735   function getLockByIndex(address _beneficiary, uint256 _lockIndex)
736     public
737     view
738     returns (uint256 amount, uint256 lockDuration, bool released, bool revoked)
739   {
740     require(_lockIndex >= 0);
741     require(_lockIndex <= tokenLocks[_beneficiary].locks.length.sub(1));
742 
743     return (
744       tokenLocks[_beneficiary].locks[_lockIndex].amount,
745       tokenLocks[_beneficiary].locks[_lockIndex].lockDuration,
746       tokenLocks[_beneficiary].locks[_lockIndex].released,
747       tokenLocks[_beneficiary].locks[_lockIndex].revoked
748     );
749   }
750 
751   /// @dev Revokes the lock at a given index for a given address
752   /// @param _beneficiary The address used to look up the lock
753   /// @param _lockIndex The lock index to be revoked
754   function revokeLockByIndex(address _beneficiary, uint256 _lockIndex)
755     public
756     onlyOwner
757     returns (bool)
758   {
759     require(_lockIndex >= 0);
760     require(_lockIndex <= tokenLocks[_beneficiary].locks.length.sub(1));
761     require(!tokenLocks[_beneficiary].locks[_lockIndex].revoked);
762 
763     tokenLocks[_beneficiary].locks[_lockIndex].revoked = true;
764 
765     return true;
766   }
767 
768   /// @dev Locks tokens for a given beneficiary
769   /// @param _beneficiary The address to which the tokens will be released
770   /// @param _lockDuration The duration of time that must elapse after the crowdsale end date
771   /// @param _tokens The amount of tokens to be locked
772   function lockTokens(address _beneficiary, uint256 _lockDuration, uint256 _tokens)
773     external
774     ownerOrCrowdsale
775     whenNotPaused
776   {
777     // Lock duration must be greater than zero seconds
778     require(_lockDuration >= 0);
779     // Token amount must be greater than zero
780     require(_tokens > 0);
781 
782     // Token Lock must have a sufficient allowance prior to creating locks
783     require(_tokens.add(totalTokensLocked) <= token.allowance(allowanceProvider, address(this)));
784 
785     TokenLockVault storage lock = tokenLocks[_beneficiary];
786 
787     // If this is the first lock for this beneficiary, add their address to the lock indexes
788     if (lock.beneficiary == 0) {
789       lock.beneficiary = _beneficiary;
790       lock.lockIndex = lockIndexes.length;
791       lockIndexes.push(_beneficiary);
792     }
793 
794     // Add the lock
795     lock.locks.push(Lock(_tokens, _lockDuration, false, false));
796 
797     // Update the total tokens for this beneficiary
798     lock.tokenBalance = lock.tokenBalance.add(_tokens);
799 
800     // Update the number of locked tokens
801     totalTokensLocked = _tokens.add(totalTokensLocked);
802 
803     LockedTokens(_beneficiary, _tokens, _lockDuration);
804   }
805 
806   /// @dev Transfers any tokens held in a timelock vault to beneficiary if they are due for release.
807   function releaseTokens()
808     public
809     whenNotPaused
810     returns(bool)
811   {
812     require(crowdsaleFinished);
813     require(_release(msg.sender));
814     return true;
815   }
816 
817   /// @dev Transfers tokens held by timelock to all beneficiaries within the provided range.
818   /// @param _beneficiary The user for which token locks should be released.
819   function releaseTokensByAddress(address _beneficiary)
820     external
821     whenNotPaused
822     onlyOwner
823     returns (bool)
824   {
825     require(crowdsaleFinished);
826     require(_release(_beneficiary));
827     return true;
828   }
829 
830   /*
831    *  Internal Functions
832    */
833   /// @dev Reviews and releases token for a given beneficiary
834   /// @param _beneficiary address for which a token release should be attempted
835   function _release(address _beneficiary)
836     internal
837     whenNotPaused
838     returns (bool)
839   {
840     TokenLockVault memory lock = tokenLocks[_beneficiary];
841     require(lock.beneficiary == _beneficiary);
842     require(_beneficiary != 0x0);
843 
844     bool hasUnDueLocks = false;
845 
846     for (uint256 i = 0; i < lock.locks.length; i++) {
847       Lock memory currentLock = lock.locks[i];
848       // Skip any locks which are already released or revoked
849       if (currentLock.released || currentLock.revoked) {
850         continue;
851       }
852 
853       // Skip any locks that are not due for release
854       if (crowdsaleEndTime.add(currentLock.lockDuration) >= now) {
855         hasUnDueLocks = true;
856         continue;
857       }
858 
859       // The amount of tokens to transfer must be less than the number of locked tokens
860       require(currentLock.amount <= token.allowance(allowanceProvider, address(this)));
861 
862       // Release Tokens
863       UnlockedTokens(_beneficiary, currentLock.amount);
864       tokenLocks[_beneficiary].locks[i].released = true;
865       tokenLocks[_beneficiary].tokenBalance = tokenLocks[_beneficiary].tokenBalance.sub(currentLock.amount);
866       totalTokensLocked = totalTokensLocked.sub(currentLock.amount);
867       assert(token.transferFrom(allowanceProvider, _beneficiary, currentLock.amount));
868     }
869 
870     // If there are no future locks to be released, delete the lock vault
871     if (!hasUnDueLocks) {
872       delete tokenLocks[_beneficiary];
873       lockIndexes[lock.lockIndex] = 0x0;
874     }
875 
876     return true;
877   }
878 }
879 
880 contract ERC20Basic {
881   function totalSupply() public view returns (uint256);
882   function balanceOf(address who) public view returns (uint256);
883   function transfer(address to, uint256 value) public returns (bool);
884   event Transfer(address indexed from, address indexed to, uint256 value);
885 }
886 
887 contract BasicToken is ERC20Basic {
888   using SafeMath for uint256;
889 
890   mapping(address => uint256) balances;
891 
892   uint256 totalSupply_;
893 
894   /**
895   * @dev total number of tokens in existence
896   */
897   function totalSupply() public view returns (uint256) {
898     return totalSupply_;
899   }
900 
901   /**
902   * @dev transfer token for a specified address
903   * @param _to The address to transfer to.
904   * @param _value The amount to be transferred.
905   */
906   function transfer(address _to, uint256 _value) public returns (bool) {
907     require(_to != address(0));
908     require(_value <= balances[msg.sender]);
909 
910     balances[msg.sender] = balances[msg.sender].sub(_value);
911     balances[_to] = balances[_to].add(_value);
912     emit Transfer(msg.sender, _to, _value);
913     return true;
914   }
915 
916   /**
917   * @dev Gets the balance of the specified address.
918   * @param _owner The address to query the the balance of.
919   * @return An uint256 representing the amount owned by the passed address.
920   */
921   function balanceOf(address _owner) public view returns (uint256) {
922     return balances[_owner];
923   }
924 
925 }
926 
927 contract ERC20 is ERC20Basic {
928   function allowance(address owner, address spender)
929     public view returns (uint256);
930 
931   function transferFrom(address from, address to, uint256 value)
932     public returns (bool);
933 
934   function approve(address spender, uint256 value) public returns (bool);
935   event Approval(
936     address indexed owner,
937     address indexed spender,
938     uint256 value
939   );
940 }
941 
942 contract StandardToken is ERC20, BasicToken {
943 
944   mapping (address => mapping (address => uint256)) internal allowed;
945 
946 
947   /**
948    * @dev Transfer tokens from one address to another
949    * @param _from address The address which you want to send tokens from
950    * @param _to address The address which you want to transfer to
951    * @param _value uint256 the amount of tokens to be transferred
952    */
953   function transferFrom(
954     address _from,
955     address _to,
956     uint256 _value
957   )
958     public
959     returns (bool)
960   {
961     require(_to != address(0));
962     require(_value <= balances[_from]);
963     require(_value <= allowed[_from][msg.sender]);
964 
965     balances[_from] = balances[_from].sub(_value);
966     balances[_to] = balances[_to].add(_value);
967     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
968     emit Transfer(_from, _to, _value);
969     return true;
970   }
971 
972   /**
973    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
974    *
975    * Beware that changing an allowance with this method brings the risk that someone may use both the old
976    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
977    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
978    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
979    * @param _spender The address which will spend the funds.
980    * @param _value The amount of tokens to be spent.
981    */
982   function approve(address _spender, uint256 _value) public returns (bool) {
983     allowed[msg.sender][_spender] = _value;
984     emit Approval(msg.sender, _spender, _value);
985     return true;
986   }
987 
988   /**
989    * @dev Function to check the amount of tokens that an owner allowed to a spender.
990    * @param _owner address The address which owns the funds.
991    * @param _spender address The address which will spend the funds.
992    * @return A uint256 specifying the amount of tokens still available for the spender.
993    */
994   function allowance(
995     address _owner,
996     address _spender
997    )
998     public
999     view
1000     returns (uint256)
1001   {
1002     return allowed[_owner][_spender];
1003   }
1004 
1005   /**
1006    * @dev Increase the amount of tokens that an owner allowed to a spender.
1007    *
1008    * approve should be called when allowed[_spender] == 0. To increment
1009    * allowed value is better to use this function to avoid 2 calls (and wait until
1010    * the first transaction is mined)
1011    * From MonolithDAO Token.sol
1012    * @param _spender The address which will spend the funds.
1013    * @param _addedValue The amount of tokens to increase the allowance by.
1014    */
1015   function increaseApproval(
1016     address _spender,
1017     uint _addedValue
1018   )
1019     public
1020     returns (bool)
1021   {
1022     allowed[msg.sender][_spender] = (
1023       allowed[msg.sender][_spender].add(_addedValue));
1024     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1025     return true;
1026   }
1027 
1028   /**
1029    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1030    *
1031    * approve should be called when allowed[_spender] == 0. To decrement
1032    * allowed value is better to use this function to avoid 2 calls (and wait until
1033    * the first transaction is mined)
1034    * From MonolithDAO Token.sol
1035    * @param _spender The address which will spend the funds.
1036    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1037    */
1038   function decreaseApproval(
1039     address _spender,
1040     uint _subtractedValue
1041   )
1042     public
1043     returns (bool)
1044   {
1045     uint oldValue = allowed[msg.sender][_spender];
1046     if (_subtractedValue > oldValue) {
1047       allowed[msg.sender][_spender] = 0;
1048     } else {
1049       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1050     }
1051     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1052     return true;
1053   }
1054 
1055 }
1056 
1057 contract MintableToken is StandardToken, Ownable {
1058   event Mint(address indexed to, uint256 amount);
1059   event MintFinished();
1060 
1061   bool public mintingFinished = false;
1062 
1063 
1064   modifier canMint() {
1065     require(!mintingFinished);
1066     _;
1067   }
1068 
1069   modifier hasMintPermission() {
1070     require(msg.sender == owner);
1071     _;
1072   }
1073 
1074   /**
1075    * @dev Function to mint tokens
1076    * @param _to The address that will receive the minted tokens.
1077    * @param _amount The amount of tokens to mint.
1078    * @return A boolean that indicates if the operation was successful.
1079    */
1080   function mint(
1081     address _to,
1082     uint256 _amount
1083   )
1084     hasMintPermission
1085     canMint
1086     public
1087     returns (bool)
1088   {
1089     totalSupply_ = totalSupply_.add(_amount);
1090     balances[_to] = balances[_to].add(_amount);
1091     emit Mint(_to, _amount);
1092     emit Transfer(address(0), _to, _amount);
1093     return true;
1094   }
1095 
1096   /**
1097    * @dev Function to stop minting new tokens.
1098    * @return True if the operation was successful.
1099    */
1100   function finishMinting() onlyOwner canMint public returns (bool) {
1101     mintingFinished = true;
1102     emit MintFinished();
1103     return true;
1104   }
1105 }
1106 
1107 contract CappedToken is MintableToken {
1108 
1109   uint256 public cap;
1110 
1111   constructor(uint256 _cap) public {
1112     require(_cap > 0);
1113     cap = _cap;
1114   }
1115 
1116   /**
1117    * @dev Function to mint tokens
1118    * @param _to The address that will receive the minted tokens.
1119    * @param _amount The amount of tokens to mint.
1120    * @return A boolean that indicates if the operation was successful.
1121    */
1122   function mint(
1123     address _to,
1124     uint256 _amount
1125   )
1126     onlyOwner
1127     canMint
1128     public
1129     returns (bool)
1130   {
1131     require(totalSupply_.add(_amount) <= cap);
1132 
1133     return super.mint(_to, _amount);
1134   }
1135 
1136 }
1137 
1138 contract PausableToken is StandardToken, Pausable {
1139 
1140   function transfer(
1141     address _to,
1142     uint256 _value
1143   )
1144     public
1145     whenNotPaused
1146     returns (bool)
1147   {
1148     return super.transfer(_to, _value);
1149   }
1150 
1151   function transferFrom(
1152     address _from,
1153     address _to,
1154     uint256 _value
1155   )
1156     public
1157     whenNotPaused
1158     returns (bool)
1159   {
1160     return super.transferFrom(_from, _to, _value);
1161   }
1162 
1163   function approve(
1164     address _spender,
1165     uint256 _value
1166   )
1167     public
1168     whenNotPaused
1169     returns (bool)
1170   {
1171     return super.approve(_spender, _value);
1172   }
1173 
1174   function increaseApproval(
1175     address _spender,
1176     uint _addedValue
1177   )
1178     public
1179     whenNotPaused
1180     returns (bool success)
1181   {
1182     return super.increaseApproval(_spender, _addedValue);
1183   }
1184 
1185   function decreaseApproval(
1186     address _spender,
1187     uint _subtractedValue
1188   )
1189     public
1190     whenNotPaused
1191     returns (bool success)
1192   {
1193     return super.decreaseApproval(_spender, _subtractedValue);
1194   }
1195 }
1196 
1197 contract OMIToken is CappedToken, PausableToken {
1198   string public constant name = "Ecomi Token";
1199   string public constant symbol = "OMI";
1200   uint256 public decimals = 18;
1201 
1202   function OMIToken() public CappedToken(1000000000*1e18) {}
1203 
1204   /// @dev Function to call from other contracts to ensure that this is the proper contract
1205   function isOMITokenContract()
1206     public 
1207     pure 
1208     returns(bool)
1209   { 
1210     return true; 
1211   }
1212 }