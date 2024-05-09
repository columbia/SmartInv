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
386   uint256 constant crowdsaleFinishTime = 1538222400; // Pacific/Auckland 2018-09-30 00:00:00
387   uint256 constant crowdsaleUSDGoal = 22125000;
388   uint256 constant crowdsaleTokenGoal = 362500000*1e18;
389   uint256 constant minimumTokenPurchase = 2500*1e18;
390   uint256 constant maximumTokenPurchase = 5000000*1e18;
391 
392   /*
393    *  Storage
394    */
395   OMIToken public token;
396   OMITokenLock public tokenLock;
397 
398   uint256 public totalUSDRaised;
399   uint256 public totalTokensSold;
400   bool public isFinalized = false;
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
529   /*
530    *  Internal Functions
531    */
532   /// @dev Extend parent behavior to check if current stage should close. Must call super to ensure the enforcement of the whitelist.
533   /// @param _beneficiary Token purchaser
534   /// @param _weiAmount Amount of wei contributed
535   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
536     internal
537     whenNotPaused
538     whenNotFinalized
539    {
540     super._preValidatePurchase(_beneficiary, _weiAmount);
541 
542     // Beneficiary's total should be between the minimum and maximum purchase amounts
543     uint256 _totalPurchased = purchaseRecords[_beneficiary].add(_getTokenAmount(_weiAmount));
544     require(_totalPurchased >= minimumTokenPurchase);
545     require(_totalPurchased <= maximumTokenPurchase);
546 
547     // Must make the purchase from the intended whitelisted address
548     require(msg.sender == _beneficiary);
549 
550     // Must be after the start time
551     require(now >= crowdsaleStartTime);
552   }
553 
554   /// @dev Overrides parent by storing balances in timelock contract instead of issuing tokens right away.
555   /// @param _beneficiary Token purchaser
556   /// @param _tokenAmount Amount of tokens purchased
557   function _processPurchase(address _beneficiary, uint256 _tokenAmount)
558     internal
559   {
560     // Lock beneficiary's tokens
561     tokenLock.lockTokens(_beneficiary, 1 weeks, _tokenAmount);
562   }
563 
564   /// @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
565   /// @param _beneficiary Address receiving the tokens
566   /// @param _weiAmount Value in wei involved in the purchase
567   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount)
568     internal
569   {
570     uint256 _tokenAmount = _getTokenAmount(_weiAmount);
571 
572     // Add token amount to the purchase history
573     purchaseRecords[_beneficiary] = purchaseRecords[_beneficiary].add(_tokenAmount);
574     
575     // Add token amount to total tokens sold
576     totalTokensSold = totalTokensSold.add(_tokenAmount);
577 
578     // Finish the crowdsale...
579     // ...if there is not a minimum purchase left
580     if (crowdsaleTokenGoal.sub(totalTokensSold) < minimumTokenPurchase) {
581       _finalization();
582     }
583     // ...if USD funding goal has been reached
584     if (totalUSDRaised >= crowdsaleUSDGoal) {
585       _finalization();
586     }
587     // ...if the time is after the crowdsale end time
588     if (now > crowdsaleFinishTime) {
589       _finalization();
590     }
591   }
592 
593   /// @dev Finalizes crowdsale
594   function _finalization()
595     internal
596     whenNotFinalized
597   {
598     isFinalized = true;
599     tokenLock.finishCrowdsale();
600     CrowdsaleFinished();
601   }
602 }
603 
604 contract OMITokenLock is Ownable, Pausable {
605   using SafeMath for uint256;
606 
607   /*
608    *  Storage
609    */
610   OMIToken public token;
611   OMICrowdsale public crowdsale;
612   address public allowanceProvider;
613   bool public crowdsaleFinished = false;
614   uint256 public crowdsaleEndTime;
615 
616   struct Lock {
617     uint256 amount;
618     uint256 lockDuration;
619     bool released;
620     bool revoked;
621   }
622   struct TokenLockVault {
623     address beneficiary;
624     uint256 tokenBalance;
625     uint256 lockIndex;
626     Lock[] locks;
627   }
628   mapping(address => TokenLockVault) public tokenLocks;
629   address[] public lockIndexes;
630   uint256 public totalTokensLocked;
631 
632   /*
633    *  Modifiers
634    */
635   modifier ownerOrCrowdsale () {
636     require(msg.sender == owner || OMICrowdsale(msg.sender) == crowdsale);
637     _;
638   }
639 
640   /*
641    *  Events
642    */
643   event LockedTokens(address indexed beneficiary, uint256 amount, uint256 releaseTime);
644   event UnlockedTokens(address indexed beneficiary, uint256 amount);
645   event FinishedCrowdsale();
646 
647   /*
648    *  Public Functions
649    */
650   /// @dev Constructor function
651   function OMITokenLock (address _token, address _allowanceProvider) public {
652     token = OMIToken(_token);
653     require(token.isOMITokenContract());
654 
655     allowanceProvider = _allowanceProvider;
656   }
657 
658   /// @dev Function to call from other contracts to ensure that this is the proper contract
659   function isOMITokenLockContract()
660     public 
661     pure 
662     returns(bool)
663   { 
664     return true; 
665   }
666 
667   /// @dev Sets the crowdsale address to allow authorize locking permissions
668   /// @param _crowdsale The address of the crowdsale
669   function setCrowdsaleAddress (address _crowdsale)
670     public
671     onlyOwner
672     returns (bool)
673   {
674     crowdsale = OMICrowdsale(_crowdsale);
675     require(crowdsale.isOMICrowdsaleContract());
676 
677     return true;
678   }
679 
680   /// @dev Sets the token allowance provider address
681   /// @param _allowanceProvider The address of the token allowance provider
682   function setAllowanceAddress (address _allowanceProvider)
683     public
684     onlyOwner
685     returns (bool)
686   {
687     allowanceProvider = _allowanceProvider;
688     return true;
689   }
690 
691   /// @dev Marks the crowdsale as being finished and sets the crowdsale finish date
692   function finishCrowdsale()
693     public
694     ownerOrCrowdsale
695     whenNotPaused
696   {
697     require(!crowdsaleFinished);
698     crowdsaleFinished = true;
699     crowdsaleEndTime = now;
700     FinishedCrowdsale();
701   }
702 
703   /// @dev Gets the total amount of tokens for a given address
704   /// @param _beneficiary The address for which to look up the total token amount
705   function getTokenBalance(address _beneficiary)
706     public
707     view
708     returns (uint)
709   {
710     return tokenLocks[_beneficiary].tokenBalance;
711   }
712 
713   /// @dev Gets the total number of locks for a given address
714   /// @param _beneficiary The address for which to look up the total number of locks
715   function getNumberOfLocks(address _beneficiary)
716     public
717     view
718     returns (uint)
719   {
720     return tokenLocks[_beneficiary].locks.length;
721   }
722 
723   /// @dev Gets the lock at a given index for a given address
724   /// @param _beneficiary The address used to look up the lock
725   /// @param _lockIndex The index used to look up the lock
726   function getLockByIndex(address _beneficiary, uint256 _lockIndex)
727     public
728     view
729     returns (uint256 amount, uint256 lockDuration, bool released, bool revoked)
730   {
731     require(_lockIndex >= 0);
732     require(_lockIndex <= tokenLocks[_beneficiary].locks.length.sub(1));
733 
734     return (
735       tokenLocks[_beneficiary].locks[_lockIndex].amount,
736       tokenLocks[_beneficiary].locks[_lockIndex].lockDuration,
737       tokenLocks[_beneficiary].locks[_lockIndex].released,
738       tokenLocks[_beneficiary].locks[_lockIndex].revoked
739     );
740   }
741 
742   /// @dev Revokes the lock at a given index for a given address
743   /// @param _beneficiary The address used to look up the lock
744   /// @param _lockIndex The lock index to be revoked
745   function revokeLockByIndex(address _beneficiary, uint256 _lockIndex)
746     public
747     onlyOwner
748     returns (bool)
749   {
750     require(_lockIndex >= 0);
751     require(_lockIndex <= tokenLocks[_beneficiary].locks.length.sub(1));
752     require(!tokenLocks[_beneficiary].locks[_lockIndex].revoked);
753 
754     tokenLocks[_beneficiary].locks[_lockIndex].revoked = true;
755 
756     return true;
757   }
758 
759   /// @dev Locks tokens for a given beneficiary
760   /// @param _beneficiary The address to which the tokens will be released
761   /// @param _lockDuration The duration of time that must elapse after the crowdsale end date
762   /// @param _tokens The amount of tokens to be locked
763   function lockTokens(address _beneficiary, uint256 _lockDuration, uint256 _tokens)
764     external
765     ownerOrCrowdsale
766     whenNotPaused
767   {
768     // Lock duration must be greater than zero seconds
769     require(_lockDuration >= 0);
770     // Token amount must be greater than zero
771     require(_tokens > 0);
772 
773     // Token Lock must have a sufficient allowance prior to creating locks
774     require(_tokens.add(totalTokensLocked) <= token.allowance(allowanceProvider, address(this)));
775 
776     TokenLockVault storage lock = tokenLocks[_beneficiary];
777 
778     // If this is the first lock for this beneficiary, add their address to the lock indexes
779     if (lock.beneficiary == 0) {
780       lock.beneficiary = _beneficiary;
781       lock.lockIndex = lockIndexes.length;
782       lockIndexes.push(_beneficiary);
783     }
784 
785     // Add the lock
786     lock.locks.push(Lock(_tokens, _lockDuration, false, false));
787 
788     // Update the total tokens for this beneficiary
789     lock.tokenBalance = lock.tokenBalance.add(_tokens);
790 
791     // Update the number of locked tokens
792     totalTokensLocked = _tokens.add(totalTokensLocked);
793 
794     LockedTokens(_beneficiary, _tokens, _lockDuration);
795   }
796 
797   /// @dev Transfers any tokens held in a timelock vault to beneficiary if they are due for release.
798   function releaseTokens()
799     public
800     whenNotPaused
801     returns(bool)
802   {
803     require(crowdsaleFinished);
804     require(_release(msg.sender));
805     return true;
806   }
807 
808   /// @dev Transfers tokens held by timelock to all beneficiaries within the provided range.
809   /// @param _beneficiary The user for which token locks should be released.
810   function releaseTokensByAddress(address _beneficiary)
811     external
812     whenNotPaused
813     onlyOwner
814     returns (bool)
815   {
816     require(crowdsaleFinished);
817     require(_release(_beneficiary));
818     return true;
819   }
820 
821   /*
822    *  Internal Functions
823    */
824   /// @dev Reviews and releases token for a given beneficiary
825   /// @param _beneficiary address for which a token release should be attempted
826   function _release(address _beneficiary)
827     internal
828     whenNotPaused
829     returns (bool)
830   {
831     TokenLockVault memory lock = tokenLocks[_beneficiary];
832     require(lock.beneficiary == _beneficiary);
833     require(_beneficiary != 0x0);
834 
835     bool hasUnDueLocks = false;
836 
837     for (uint256 i = 0; i < lock.locks.length; i++) {
838       Lock memory currentLock = lock.locks[i];
839       // Skip any locks which are already released or revoked
840       if (currentLock.released || currentLock.revoked) {
841         continue;
842       }
843 
844       // Skip any locks that are not due for release
845       if (crowdsaleEndTime.add(currentLock.lockDuration) >= now) {
846         hasUnDueLocks = true;
847         continue;
848       }
849 
850       // The amount of tokens to transfer must be less than the number of locked tokens
851       require(currentLock.amount <= token.allowance(allowanceProvider, address(this)));
852 
853       // Release Tokens
854       UnlockedTokens(_beneficiary, currentLock.amount);
855       tokenLocks[_beneficiary].locks[i].released = true;
856       tokenLocks[_beneficiary].tokenBalance = tokenLocks[_beneficiary].tokenBalance.sub(currentLock.amount);
857       totalTokensLocked = totalTokensLocked.sub(currentLock.amount);
858       assert(token.transferFrom(allowanceProvider, _beneficiary, currentLock.amount));
859     }
860 
861     // If there are no future locks to be released, delete the lock vault
862     if (!hasUnDueLocks) {
863       delete tokenLocks[_beneficiary];
864       lockIndexes[lock.lockIndex] = 0x0;
865     }
866 
867     return true;
868   }
869 }
870 
871 contract ERC20Basic {
872   function totalSupply() public view returns (uint256);
873   function balanceOf(address who) public view returns (uint256);
874   function transfer(address to, uint256 value) public returns (bool);
875   event Transfer(address indexed from, address indexed to, uint256 value);
876 }
877 
878 contract BasicToken is ERC20Basic {
879   using SafeMath for uint256;
880 
881   mapping(address => uint256) balances;
882 
883   uint256 totalSupply_;
884 
885   /**
886   * @dev total number of tokens in existence
887   */
888   function totalSupply() public view returns (uint256) {
889     return totalSupply_;
890   }
891 
892   /**
893   * @dev transfer token for a specified address
894   * @param _to The address to transfer to.
895   * @param _value The amount to be transferred.
896   */
897   function transfer(address _to, uint256 _value) public returns (bool) {
898     require(_to != address(0));
899     require(_value <= balances[msg.sender]);
900 
901     balances[msg.sender] = balances[msg.sender].sub(_value);
902     balances[_to] = balances[_to].add(_value);
903     emit Transfer(msg.sender, _to, _value);
904     return true;
905   }
906 
907   /**
908   * @dev Gets the balance of the specified address.
909   * @param _owner The address to query the the balance of.
910   * @return An uint256 representing the amount owned by the passed address.
911   */
912   function balanceOf(address _owner) public view returns (uint256) {
913     return balances[_owner];
914   }
915 
916 }
917 
918 contract ERC20 is ERC20Basic {
919   function allowance(address owner, address spender)
920     public view returns (uint256);
921 
922   function transferFrom(address from, address to, uint256 value)
923     public returns (bool);
924 
925   function approve(address spender, uint256 value) public returns (bool);
926   event Approval(
927     address indexed owner,
928     address indexed spender,
929     uint256 value
930   );
931 }
932 
933 contract StandardToken is ERC20, BasicToken {
934 
935   mapping (address => mapping (address => uint256)) internal allowed;
936 
937 
938   /**
939    * @dev Transfer tokens from one address to another
940    * @param _from address The address which you want to send tokens from
941    * @param _to address The address which you want to transfer to
942    * @param _value uint256 the amount of tokens to be transferred
943    */
944   function transferFrom(
945     address _from,
946     address _to,
947     uint256 _value
948   )
949     public
950     returns (bool)
951   {
952     require(_to != address(0));
953     require(_value <= balances[_from]);
954     require(_value <= allowed[_from][msg.sender]);
955 
956     balances[_from] = balances[_from].sub(_value);
957     balances[_to] = balances[_to].add(_value);
958     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
959     emit Transfer(_from, _to, _value);
960     return true;
961   }
962 
963   /**
964    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
965    *
966    * Beware that changing an allowance with this method brings the risk that someone may use both the old
967    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
968    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
969    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
970    * @param _spender The address which will spend the funds.
971    * @param _value The amount of tokens to be spent.
972    */
973   function approve(address _spender, uint256 _value) public returns (bool) {
974     allowed[msg.sender][_spender] = _value;
975     emit Approval(msg.sender, _spender, _value);
976     return true;
977   }
978 
979   /**
980    * @dev Function to check the amount of tokens that an owner allowed to a spender.
981    * @param _owner address The address which owns the funds.
982    * @param _spender address The address which will spend the funds.
983    * @return A uint256 specifying the amount of tokens still available for the spender.
984    */
985   function allowance(
986     address _owner,
987     address _spender
988    )
989     public
990     view
991     returns (uint256)
992   {
993     return allowed[_owner][_spender];
994   }
995 
996   /**
997    * @dev Increase the amount of tokens that an owner allowed to a spender.
998    *
999    * approve should be called when allowed[_spender] == 0. To increment
1000    * allowed value is better to use this function to avoid 2 calls (and wait until
1001    * the first transaction is mined)
1002    * From MonolithDAO Token.sol
1003    * @param _spender The address which will spend the funds.
1004    * @param _addedValue The amount of tokens to increase the allowance by.
1005    */
1006   function increaseApproval(
1007     address _spender,
1008     uint _addedValue
1009   )
1010     public
1011     returns (bool)
1012   {
1013     allowed[msg.sender][_spender] = (
1014       allowed[msg.sender][_spender].add(_addedValue));
1015     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1016     return true;
1017   }
1018 
1019   /**
1020    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1021    *
1022    * approve should be called when allowed[_spender] == 0. To decrement
1023    * allowed value is better to use this function to avoid 2 calls (and wait until
1024    * the first transaction is mined)
1025    * From MonolithDAO Token.sol
1026    * @param _spender The address which will spend the funds.
1027    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1028    */
1029   function decreaseApproval(
1030     address _spender,
1031     uint _subtractedValue
1032   )
1033     public
1034     returns (bool)
1035   {
1036     uint oldValue = allowed[msg.sender][_spender];
1037     if (_subtractedValue > oldValue) {
1038       allowed[msg.sender][_spender] = 0;
1039     } else {
1040       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1041     }
1042     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1043     return true;
1044   }
1045 
1046 }
1047 
1048 contract MintableToken is StandardToken, Ownable {
1049   event Mint(address indexed to, uint256 amount);
1050   event MintFinished();
1051 
1052   bool public mintingFinished = false;
1053 
1054 
1055   modifier canMint() {
1056     require(!mintingFinished);
1057     _;
1058   }
1059 
1060   modifier hasMintPermission() {
1061     require(msg.sender == owner);
1062     _;
1063   }
1064 
1065   /**
1066    * @dev Function to mint tokens
1067    * @param _to The address that will receive the minted tokens.
1068    * @param _amount The amount of tokens to mint.
1069    * @return A boolean that indicates if the operation was successful.
1070    */
1071   function mint(
1072     address _to,
1073     uint256 _amount
1074   )
1075     hasMintPermission
1076     canMint
1077     public
1078     returns (bool)
1079   {
1080     totalSupply_ = totalSupply_.add(_amount);
1081     balances[_to] = balances[_to].add(_amount);
1082     emit Mint(_to, _amount);
1083     emit Transfer(address(0), _to, _amount);
1084     return true;
1085   }
1086 
1087   /**
1088    * @dev Function to stop minting new tokens.
1089    * @return True if the operation was successful.
1090    */
1091   function finishMinting() onlyOwner canMint public returns (bool) {
1092     mintingFinished = true;
1093     emit MintFinished();
1094     return true;
1095   }
1096 }
1097 
1098 contract CappedToken is MintableToken {
1099 
1100   uint256 public cap;
1101 
1102   constructor(uint256 _cap) public {
1103     require(_cap > 0);
1104     cap = _cap;
1105   }
1106 
1107   /**
1108    * @dev Function to mint tokens
1109    * @param _to The address that will receive the minted tokens.
1110    * @param _amount The amount of tokens to mint.
1111    * @return A boolean that indicates if the operation was successful.
1112    */
1113   function mint(
1114     address _to,
1115     uint256 _amount
1116   )
1117     onlyOwner
1118     canMint
1119     public
1120     returns (bool)
1121   {
1122     require(totalSupply_.add(_amount) <= cap);
1123 
1124     return super.mint(_to, _amount);
1125   }
1126 
1127 }
1128 
1129 contract PausableToken is StandardToken, Pausable {
1130 
1131   function transfer(
1132     address _to,
1133     uint256 _value
1134   )
1135     public
1136     whenNotPaused
1137     returns (bool)
1138   {
1139     return super.transfer(_to, _value);
1140   }
1141 
1142   function transferFrom(
1143     address _from,
1144     address _to,
1145     uint256 _value
1146   )
1147     public
1148     whenNotPaused
1149     returns (bool)
1150   {
1151     return super.transferFrom(_from, _to, _value);
1152   }
1153 
1154   function approve(
1155     address _spender,
1156     uint256 _value
1157   )
1158     public
1159     whenNotPaused
1160     returns (bool)
1161   {
1162     return super.approve(_spender, _value);
1163   }
1164 
1165   function increaseApproval(
1166     address _spender,
1167     uint _addedValue
1168   )
1169     public
1170     whenNotPaused
1171     returns (bool success)
1172   {
1173     return super.increaseApproval(_spender, _addedValue);
1174   }
1175 
1176   function decreaseApproval(
1177     address _spender,
1178     uint _subtractedValue
1179   )
1180     public
1181     whenNotPaused
1182     returns (bool success)
1183   {
1184     return super.decreaseApproval(_spender, _subtractedValue);
1185   }
1186 }
1187 
1188 contract OMIToken is CappedToken, PausableToken {
1189   string public constant name = "Ecomi Token";
1190   string public constant symbol = "OMI";
1191   uint256 public decimals = 18;
1192 
1193   function OMIToken() public CappedToken(1000000000*1e18) {}
1194 
1195   /// @dev Function to call from other contracts to ensure that this is the proper contract
1196   function isOMITokenContract()
1197     public 
1198     pure 
1199     returns(bool)
1200   { 
1201     return true; 
1202   }
1203 }