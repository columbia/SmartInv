1 pragma solidity ^0.4.24;
2 
3 contract INotInitedOwnable {
4     
5     function init() public;
6     
7     function transferOwnership(address newOwner) public;
8 }
9 
10 contract IOwnableUpgradeableImplementation is INotInitedOwnable {
11     
12     function transferOwnership(address newOwner) public;
13     
14     function getOwner() constant public returns(address);
15     
16     function upgradeImplementation(address _newImpl) public;
17     
18     function getImplementation() constant public returns(address);
19 }
20 
21 contract IHookOperator is IOwnableUpgradeableImplementation {
22 
23     event LogSetBalancePercentageLimit(uint256 limit);
24     event LogSetOverBalanceLimitHolder(address holderAddress, bool isHolder);
25     event LogSetUserManager(address userManagerAddress);
26     event LogSetICOToken(address icoTokenAddress);
27 
28     event LogOnTransfer(address from, address to, uint tokens);
29     event LogOnMint(address to, uint256 amount);
30     event LogOnBurn(uint amount);
31     event LogOnTaxTransfer(address indexed taxableUser, uint tokensAmount);
32 
33     event LogSetKYCVerificationContract(address _kycVerificationContractAddress);
34     event LogUpdateUserRatio(uint256 generationRatio, address indexed userContractAddress);
35 
36     /**
37         Setters
38     */
39     function setBalancePercentageLimit(uint256 limit) public;
40     function getBalancePercentageLimit() public view returns(uint256);
41     
42     function setOverBalanceLimitHolder(address holderAddress, bool isHolder) public;
43 
44     function setUserManager(address userManagerAddress) public;
45     function getUserManager() public view returns(address userManagerAddress);
46    
47     function setICOToken(address icoTokenAddress) public;
48     function getICOToken() public view returns(address icoTokenAddress);
49 
50     /**
51         Main Functions
52     */
53     function onTransfer(address from, address to, uint256 tokensAmount) public;
54 
55     function onMint(address to, uint256 tokensAmount) public;
56 
57     function onBurn(uint256 amount) public;
58 
59     function onTaxTransfer(address taxableUser, uint256 tokensAmount) public;
60 
61     /**
62         KYC Verification
63     */
64     function kycVerification(address from, address to, uint256 tokensAmount) public;
65 
66     function setKYCVerificationContract(address _kycVerificationContractAddress) public;
67 
68     function getKYCVerificationContractAddress() public view returns(address _kycVerificationContractAddress);
69     
70     /**
71         Helper functions
72     */
73     function updateUserRatio(uint256 generationRatio, address userContractAddress) public;
74 
75     function isOverBalanceLimitHolder(address holderAddress) public view returns(bool);
76 
77     function isInBalanceLimit(address userAddress, uint256 tokensAmount) public view returns(bool);
78 }
79 
80 contract IUserContract {
81     event LogNewExchangeUserCreate(uint256 _KYCStatus);
82     event LogNewUserCreate(uint256 _KYCStatus);
83     
84     event LogGenerationRatioUpdate(uint256 _generationRatio);
85     event LogKYCStatusUpdate(uint256 _KYCStatus);
86     event LogLastTransactionTimeUpdate(uint256 _lastTransactionTime);
87     event LogUserPolicyUpdate(bool _termsAndConditions, bool _AML, bool _constitution, bool _CLA);
88 
89     event LogAsFounderMark();
90     event LogUserBlacklistedStatusSet(bool _blacklistedStatus);
91     event LogUserBan();
92 
93     event LogDailyTransactionVolumeSendingIncrease(uint256 _currentDay, uint256 _transactionVolume);
94     event LogDailyTransactionVolumeReceivingIncrease(uint256 _currentDay, uint256 _transactionVolume);
95 
96     event LogWeeklyTransactionVolumeSendingIncrease(uint256 _currentWeek, uint256 _transactionVolume);
97     event LogWeeklyTransactionVolumeReceivingIncrease(uint256 _currentWeek, uint256 _transactionVolume);
98     
99     event LogMonthlyTransactionVolumeSendingIncrease(uint256 _currentMonth, uint256 _transactionVolume);
100     event LogMonthlyTransactionVolumeReceivingIncrease(uint256 _currentMonth, uint256 _transactionVolume);
101 
102     /**
103         Main Functions
104     */
105     function initExchangeUser(uint256 _KYCStatus) external;
106 
107     function initKYCUser(uint256 _KYCStatus) external;
108 
109     function initUser(uint256 _KYCStatus) internal;
110 
111     function isValidUser() external view returns(bool);
112 
113     function getUserData() external view returns
114     (
115         uint256 _generationRatio, 
116         uint256 _KYCStatus, 
117         uint256 _lastTransactionTime, 
118         bool _isBlacklistedUser,
119         bool _termsAndConditionsAcceptance,
120         bool _AMLAcceptance,
121         bool _constitutionSign,
122         bool _commonLicenseAgreementSign,
123         bool _isFounder
124     ); 
125 
126     function isExchangeUser() public view returns(bool);
127 
128     function updateUserPolicy(bool _termsAndConditions, bool _AML, bool _constitution, bool _CLA) external;
129 
130     function isUserPolicyAccepted() public view returns(bool);
131 
132     function updateGenerationRatio(uint256 _generationRatio) external;
133     
134     function updateKYCStatus(uint256 _newKYCStatus) external;
135 
136     function updateLastTransactionTime(uint256 _lastTransactionTime) external;
137 
138     /**
139         Founder - User
140     */
141     function markAsFounder() external;
142 
143     function isFounderUser() external view returns(bool);
144 
145     /**
146         Blacklisted - User
147     */
148     function setUserBlacklistedStatus(bool _shouldBeBlacklisted) external;
149 
150     function isUserBlacklisted() external view returns(bool _isBlacklisted);
151     /**
152         Banned - User
153     */
154     function banUser() external;
155 
156     function isUserBanned() external view returns(bool _isBanned);
157 
158     /**
159         Daily transaction volume
160     */
161     function increaseDailyTransactionVolumeSending(uint256 _transactionVolume) external;
162 
163     function getDailyTransactionVolumeSending() external view returns(uint256 _dailyTransactionVolume);
164 
165     /**
166         Daily transaction volume - Receiving
167     */
168     function increaseDailyTransactionVolumeReceiving(uint256 _transactionVolume) external;
169 
170     function getDailyTransactionVolumeReceiving() external view returns(uint256 _dailyTransactionVolume);
171 
172     /**
173         Weekly transaction volume
174     */
175     function increaseWeeklyTransactionVolumeSending(uint256 _transactionVolume) external;
176 
177     function getWeeklyTransactionVolumeSending() external view returns(uint256 _weeklyTransactionVolume);
178 
179     /**
180         Weekly transaction volume - Receiving
181     */
182     function increaseWeeklyTransactionVolumeReceiving(uint256 _transactionVolume) external;
183 
184     function getWeeklyTransactionVolumeReceiving() external view returns(uint256 _weeklyTransactionVolume);
185 
186     /**
187         Monthly transaction volume
188     */
189     function increaseMonthlyTransactionVolumeSending(uint256 _transactionVolume) external;
190 
191     function getMonthlyTransactionVolumeSending() external view returns(uint256 _monthlyTransactionVolume);
192 
193     /**
194         Monthly transaction volume - Receiving
195     */
196     function increaseMonthlyTransactionVolumeReceiving(uint256 _transactionVolume) external;
197 
198     function getMonthlyTransactionVolumeReceiving() external view returns(uint256 _monthlyTransactionVolume);
199 }
200 
201 contract IUserManager is IOwnableUpgradeableImplementation {
202     event LogSetDataContract(address _dataContractAddress);
203     event LogSetTaxPercentage(uint256 _taxPercentage);
204     event LogSetTaxationPeriod(uint256 _taxationPeriod);
205 
206     event LogSetUserFactoryContract(address _userFactoryContract);
207     event LogSetHookOperatorContract(address _HookOperatorContract);
208 
209     event LogUpdateGenerationRatio(uint256 _generationRatio, address userContractAddress);
210     event LogUpdateLastTransactionTime(address _userAddress);
211 
212     event LogUserAsFounderMark(address userAddress);
213 
214     /**
215         Data Contract
216     */
217     function setDataContract(address _dataContractAddress) public;
218 
219     function getDataContractAddress() public view returns(address _dataContractAddress);
220 
221     function setTaxPercentage(uint256 _taxPercentage) public;
222 
223     function setTaxationPeriod(uint256 _taxationPeriod) public;
224 
225     /**
226         User Factory
227     */
228     function setUserFactoryContract(address _userFactoryContract) public;
229 
230     function getUserFactoryContractAddress() public view returns(address _userFactoryContractAddress);
231     /**
232         Hook Operator
233     */
234     function setHookOperatorContract(address _HookOperatorContract) public;
235 
236     function getHookOperatorContractAddress() public view returns(address _HookOperatorContractAddress);
237     
238     /**
239         Users Functions
240     */
241 
242     function isUserKYCVerified(address _userAddress) public view returns(uint256 KYCStatus);
243 
244     function isBlacklisted(address _userAddress) public view returns(bool _isBlacklisted);
245 
246     function isBannedUser(address userAddress) public view returns(bool _isBannedUser);
247 
248     function updateGenerationRatio(uint256 _generationRatio, address userContractAddress) public;
249 
250     function updateLastTransactionTime(address _userAddress) public;
251 
252     function getUserContractAddress(address _userAddress) public view returns(IUserContract _userContract);
253 
254     function isValidUser(address userAddress) public view returns(bool);
255 
256     function setCrowdsaleContract(address crowdsaleInstance) external;
257 
258     function getCrowdsaleContract() external view returns(address);
259 
260     function markUserAsFounder(address userAddress) external;
261 }
262 
263 contract Crowdsale {
264   using SafeMath for uint256;
265 
266   // The token being sold
267   MintableToken public token;
268 
269   // start and end timestamps where investments are allowed (both inclusive)
270   uint256 public startTime;
271   uint256 public endTime;
272 
273   // address where funds are collected
274   address public wallet;
275 
276   // how many token units a buyer gets per wei
277   uint256 public rate;
278 
279   // amount of raised money in wei
280   uint256 public weiRaised;
281 
282   /**
283    * event for token purchase logging
284    * @param purchaser who paid for the tokens
285    * @param beneficiary who got the tokens
286    * @param value weis paid for purchase
287    * @param amount amount of tokens purchased
288    */
289   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
290 
291 
292   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
293     require(_startTime >= now);
294     require(_endTime >= _startTime);
295     require(_rate > 0);
296     require(_wallet != address(0));
297 
298     token = createTokenContract();
299     startTime = _startTime;
300     endTime = _endTime;
301     rate = _rate;
302     wallet = _wallet;
303   }
304 
305   // creates the token to be sold.
306   // override this method to have crowdsale of a specific mintable token.
307   function createTokenContract() internal returns (MintableToken) {
308     return new MintableToken();
309   }
310 
311 
312   // fallback function can be used to buy tokens
313   function () external payable {
314     buyTokens(msg.sender);
315   }
316 
317   // low level token purchase function
318   function buyTokens(address beneficiary) public payable {
319     require(beneficiary != address(0));
320     require(validPurchase());
321 
322     uint256 weiAmount = msg.value;
323 
324     // calculate token amount to be created
325     uint256 tokens = weiAmount.mul(rate);
326 
327     // update state
328     weiRaised = weiRaised.add(weiAmount);
329 
330     token.mint(beneficiary, tokens);
331     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
332 
333     forwardFunds();
334   }
335 
336   // send ether to the fund collection wallet
337   // override to create custom fund forwarding mechanisms
338   function forwardFunds() internal {
339     wallet.transfer(msg.value);
340   }
341 
342   // @return true if the transaction can buy tokens
343   function validPurchase() internal view returns (bool) {
344     bool withinPeriod = now >= startTime && now <= endTime;
345     bool nonZeroPurchase = msg.value != 0;
346     return withinPeriod && nonZeroPurchase;
347   }
348 
349   // @return true if crowdsale event has ended
350   function hasEnded() public view returns (bool) {
351     return now > endTime;
352   }
353 
354 
355 }
356 
357 contract CappedCrowdsale is Crowdsale {
358   using SafeMath for uint256;
359 
360   uint256 public cap;
361 
362   function CappedCrowdsale(uint256 _cap) public {
363     require(_cap > 0);
364     cap = _cap;
365   }
366 
367   // overriding Crowdsale#validPurchase to add extra cap logic
368   // @return true if investors can buy at the moment
369   function validPurchase() internal view returns (bool) {
370     bool withinCap = weiRaised.add(msg.value) <= cap;
371     return super.validPurchase() && withinCap;
372   }
373 
374   // overriding Crowdsale#hasEnded to add cap logic
375   // @return true if crowdsale event has ended
376   function hasEnded() public view returns (bool) {
377     bool capReached = weiRaised >= cap;
378     return super.hasEnded() || capReached;
379   }
380 
381 }
382 
383 library SafeMath {
384   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
385     if (a == 0) {
386       return 0;
387     }
388     uint256 c = a * b;
389     assert(c / a == b);
390     return c;
391   }
392 
393   function div(uint256 a, uint256 b) internal pure returns (uint256) {
394     // assert(b > 0); // Solidity automatically throws when dividing by 0
395     uint256 c = a / b;
396     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
397     return c;
398   }
399 
400   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
401     assert(b <= a);
402     return a - b;
403   }
404 
405   function add(uint256 a, uint256 b) internal pure returns (uint256) {
406     uint256 c = a + b;
407     assert(c >= a);
408     return c;
409   }
410 }
411 
412 contract Ownable {
413   address public owner;
414 
415 
416   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
417 
418 
419   /**
420    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
421    * account.
422    */
423   function Ownable() public {
424     owner = msg.sender;
425   }
426 
427 
428   /**
429    * @dev Throws if called by any account other than the owner.
430    */
431   modifier onlyOwner() {
432     require(msg.sender == owner);
433     _;
434   }
435 
436 
437   /**
438    * @dev Allows the current owner to transfer control of the contract to a newOwner.
439    * @param newOwner The address to transfer ownership to.
440    */
441   function transferOwnership(address newOwner) public onlyOwner {
442     require(newOwner != address(0));
443     OwnershipTransferred(owner, newOwner);
444     owner = newOwner;
445   }
446 
447 }
448 
449 contract RefundVault is Ownable {
450     using SafeMath for uint256;
451 
452     /* 
453         To cover the costs for paying investor related functions by ourself as: 
454             "add investor in the whitelist" and etc.
455 
456         We are getting 3% of the investor's deposit only if the soft cap
457         is not reached and the investor refund his contribution
458     */
459     uint256 public constant DEDUCTION = 3;
460     uint256 public totalDeductedValue;
461 
462     enum State { Active, Refunding, Closed }
463 
464     mapping (address => uint256) public deposited;
465     address public wallet;
466     State public state;
467 
468     event Closed();
469     event RefundsEnabled();
470     event Refunded(address indexed beneficiary, uint256 weiAmount);
471 
472     constructor(address _wallet) public {
473         require(_wallet != address(0));
474         
475         wallet = _wallet;
476         state = State.Active;
477     }
478 
479     function deposit(address investor) onlyOwner external payable {
480         require(state == State.Active);
481 
482         deposited[investor] = deposited[investor].add(msg.value);
483     }
484 
485     function close() onlyOwner external {
486         require(state == State.Active);
487         
488         state = State.Closed;
489         emit Closed();
490         wallet.transfer(address(this).balance);
491     }
492 
493     function enableRefunds() external onlyOwner {
494         require(state == State.Active);
495 
496         state = State.Refunding;
497         emit RefundsEnabled();
498     }
499 
500     function refund(address investor) external {
501         require(state == State.Refunding);
502 
503         uint256 depositedValue = deposited[investor];
504         uint256 deductedValue = depositedValue.mul(DEDUCTION).div(100);
505         
506         deposited[investor] = 0;
507 
508         wallet.transfer(deductedValue);
509         investor.transfer(depositedValue.sub(deductedValue));
510         
511         totalDeductedValue = totalDeductedValue.add(deductedValue);
512 
513         emit Refunded(investor, depositedValue);
514     }
515 }
516 
517 contract WhitelistedCrowdsale is Ownable {
518 
519     /*
520         We need a count limit for the users array, 
521         which is passed to setMultiple functions
522 
523         Without the limit, the set could be so big that the transaction required gas is over the block maximum gas
524         The count is calculated on:
525             How much gas it costs to process one user
526             The maximum gas is 5 000 000
527     */
528     uint public constant MAX_INPUT_USERS_COUNT = 200;
529 
530     mapping(address => uint) public preSalesSpecialUsers;
531 
532     mapping(address => bool) public publicSalesSpecialUsers;
533 
534     address public lister;
535 
536     event LogPresalesSpecialUserSet(address userAddress, uint userRate);
537     event LogMultiplePresalesSpecialUsersSet(address[] userAddresses, uint userRate);
538     event LogPublicsalesSpecialUserAdd(address addedUser);
539     event LogMultiplePublicsalesSpecialUsersSet(address[] userAddresses);
540     event LogPublicsalesSpecialUserRemove(address removedUser);
541     event LogListerSet(address listerAddress);
542 
543     modifier onlyLister() {
544         require(msg.sender == lister);
545         
546         _;
547     }
548 
549     modifier notZeroAddress(address addressForValidation) {
550         require(addressForValidation != address(0));
551 
552         _;
553     }
554 
555     function setPreSalesSpecialUser(address user, uint userRate) external onlyLister notZeroAddress(user) {
556         preSalesSpecialUsers[user] = userRate;
557 
558         emit LogPresalesSpecialUserSet(user, userRate);
559     }
560 
561     function setMultiplePreSalesSpecialUsers(address[] users, uint userRate) external onlyLister {
562         require(users.length <= MAX_INPUT_USERS_COUNT);
563 
564         for(uint i = 0; i < users.length; i++) { 
565             preSalesSpecialUsers[users[i]] = userRate;
566         }
567 
568         emit LogMultiplePresalesSpecialUsersSet(users, userRate);
569     }
570 
571     function addPublicSalesSpecialUser(address user) external onlyLister notZeroAddress(user) {
572         publicSalesSpecialUsers[user] = true;
573 
574         emit LogPublicsalesSpecialUserAdd(user);
575     }
576 
577     function addMultiplePublicSalesSpecialUser(address[] users) external onlyLister {
578         require(users.length <= MAX_INPUT_USERS_COUNT);
579 
580         for(uint i = 0; i < users.length; i++) { 
581             publicSalesSpecialUsers[users[i]] = true;
582         }
583 
584         emit LogMultiplePublicsalesSpecialUsersSet(users);
585     }
586 
587     function removePublicSalesSpecialUser(address user) external onlyLister notZeroAddress(user) {
588         publicSalesSpecialUsers[user] = false;
589 
590         emit LogPublicsalesSpecialUserRemove(user);
591     }
592 
593     function setLister(address newLister) external onlyOwner notZeroAddress(newLister) {
594         lister = newLister;
595 
596         emit LogListerSet(newLister);
597     }
598 }
599 
600 contract FinalizableCrowdsale is Crowdsale, Ownable {
601   using SafeMath for uint256;
602 
603   bool public isFinalized = false;
604 
605   event Finalized();
606 
607   /**
608    * @dev Must be called after crowdsale ends, to do some extra finalization
609    * work. Calls the contract's finalization function.
610    */
611   function finalize() onlyOwner public {
612     require(!isFinalized);
613     require(hasEnded());
614 
615     finalization();
616     Finalized();
617 
618     isFinalized = true;
619   }
620 
621   /**
622    * @dev Can be overridden to add finalization logic. The overriding function
623    * should call super.finalization() to ensure the chain of finalization is
624    * executed entirely.
625    */
626   function finalization() internal {
627   }
628 }
629 
630 contract RefundableCrowdsale is FinalizableCrowdsale {
631     using SafeMath for uint256;
632 
633     uint256 public goal;
634 
635     RefundVault public vault;
636 
637     constructor(uint256 _goal) public {
638         require(_goal > 0);
639         vault = new RefundVault(wallet);
640         goal = _goal;
641     }
642 
643     function forwardFunds() internal {
644         vault.deposit.value(msg.value)(msg.sender);
645     }
646 
647     function claimRefund() external {
648         require(isFinalized);
649         require(!goalReached());
650 
651         vault.refund(msg.sender);
652     }
653 
654     function finalization() internal {
655         if (goalReached()) {
656             vault.close();
657         } else {
658             vault.enableRefunds();
659         }
660 
661         super.finalization();
662     }
663 
664     function goalReached() public view returns (bool) {
665         return weiRaised >= goal;
666     }
667 }
668 
669 contract ICOCrowdsale is Ownable, FinalizableCrowdsale, WhitelistedCrowdsale {
670     using SafeMath for uint256;
671 
672     IUserManager public userManagerContract;
673 
674     uint256 public preSalesEndDate;
675     uint256 public totalMintedBountyTokens;
676     bool public isPresalesNotEndedInAdvance = true;
677 
678     uint256 public constant MIN_CONTRIBUTION_AMOUNT = 50 finney; // 0.05 ETH
679     uint256 public constant MAX_BOUNTYTOKENS_AMOUNT = 100000 * (10**18); // 100 000 tokens
680     uint256 public constant MAX_FUNDS_RAISED_DURING_PRESALE = 20000 ether;
681     
682     /*
683         The limit below allows a user to have maximum tokens balance of 2%(400 000 tokens) of the hard cap(167 000 ethers)
684         It only applies through crowdsale period
685     */
686     uint256 public constant MAX_USER_TOKENS_BALANCE = 400000 * (10**18); // 400 000 tokens
687 
688     // 0.01 eth = 1 token
689     uint256 public constant REGULAR_RATE = 100;
690     uint256 public constant PUBLIC_SALES_SPECIAL_USERS_RATE = 120; // 20% bonus
691 
692     uint256 public constant DEFAULT_PRESALES_DURATION = 7 weeks;
693     uint256 public constant MAX_PRESALES_EXTENSION= 12 weeks;
694 
695     /*
696         The public sales periods ends:
697             PUBLIC_SALES_1_PERIOD_END = 1 weeks / Public sales 1 period starts from private sales period and expires one week after the private sales end
698             PUBLIC_SALES_2_PERIOD_END = 2 weeks / Public sales 2 period starts from public sales 1 period and expires on the 2-nd week after the private sales end
699             PUBLIC_SALES_3_PERIOD_END = 3 weeks / Public sales 3 period starts from public sales 2 period and expires on the 3-th week after the private sales end
700     */
701     uint256 public constant PUBLIC_SALES_1_PERIOD_END = 1 weeks;
702     uint256 public constant PUBLIC_SALES_2_PERIOD_END = 2 weeks;
703     uint256 public constant PUBLIC_SALES_3_PERIOD_END = 3 weeks;
704 
705     uint256 public constant PUBLIC_SALES_1_RATE = 115; // 15% bonus
706     uint256 public constant PUBLIC_SALES_2_RATE = 110; // 10% bonus
707     uint256 public constant PUBLIC_SALES_3_RATE = 105; // 5% bonus
708 
709     event LogBountyTokenMinted(address minter, address beneficiary, uint256 amount);
710     event LogPrivatesaleExtend(uint extensionTime);
711 
712     constructor(uint256 startTime, uint256 endTime, address wallet, address hookOperatorAddress) public
713         FinalizableCrowdsale()
714         Crowdsale(startTime, endTime, REGULAR_RATE, wallet)
715     {
716         // Set default presales end date
717         preSalesEndDate = startTime.add(DEFAULT_PRESALES_DURATION);
718         
719 
720         ICOTokenExtended icoToken = ICOTokenExtended(token);
721         icoToken.setHookOperator(hookOperatorAddress);
722     }
723 
724     function createTokenContract() internal returns (MintableToken) {
725 
726         ICOTokenExtended icoToken = new ICOTokenExtended();
727 
728         icoToken.pause();
729 
730         return icoToken;
731     }
732 
733     function finalization() internal {
734         super.finalization();
735 
736         ICOTokenExtended icoToken = ICOTokenExtended(token);
737 
738         icoToken.transferOwnership(owner);
739     }
740 
741     // The extensionTime is in seconds
742     function extendPreSalesPeriodWith(uint extensionTime) public onlyOwner {
743         require(extensionTime <= MAX_PRESALES_EXTENSION);
744         
745         preSalesEndDate = preSalesEndDate.add(extensionTime);
746         endTime = endTime.add(extensionTime);
747 
748         emit LogPrivatesaleExtend(extensionTime);
749     }
750 
751     function buyTokens(address beneficiary) public payable {
752         require(msg.value >= MIN_CONTRIBUTION_AMOUNT);
753         require(beneficiary != address(0));
754         require(validPurchase());
755 
756         uint256 weiAmount = msg.value;
757 
758         // calculate token amount to be created
759         uint256 tokens = getTokenAmount(weiAmount, beneficiary);
760 
761         // Check for maximum user's tokens amount overflow
762         uint256 beneficiaryBalance = token.balanceOf(beneficiary);
763         require(beneficiaryBalance.add(tokens) <= MAX_USER_TOKENS_BALANCE);
764 
765         // // update state
766         weiRaised = weiRaised.add(weiAmount);
767 
768         if(weiRaised >= MAX_FUNDS_RAISED_DURING_PRESALE && isPresalesNotEndedInAdvance){
769             preSalesEndDate = now;
770             isPresalesNotEndedInAdvance = false;
771         }
772 
773         token.mint(beneficiary, tokens);
774 
775         userManagerContract.markUserAsFounder(beneficiary);
776 
777         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
778 
779         forwardFunds();
780     }
781 
782     function getTokenAmount(uint256 weiAmount, address beneficiaryAddress) internal view returns(uint256 tokenAmount) {
783         uint256 crowdsaleRate = getRate(beneficiaryAddress);
784 
785         return weiAmount.mul(crowdsaleRate);
786     }
787 
788     function getRate(address beneficiary) internal view returns(uint256) {
789 
790         if(now <= preSalesEndDate && weiRaised < MAX_FUNDS_RAISED_DURING_PRESALE){
791             if(preSalesSpecialUsers[beneficiary] > 0){
792                 return preSalesSpecialUsers[beneficiary];
793             }
794 
795             return REGULAR_RATE;
796         }
797 
798         if(publicSalesSpecialUsers[beneficiary]){
799             return PUBLIC_SALES_SPECIAL_USERS_RATE;
800         }
801 
802         if(now <= preSalesEndDate.add(PUBLIC_SALES_1_PERIOD_END)) {
803             return PUBLIC_SALES_1_RATE;
804         }
805 
806         if(now <= preSalesEndDate.add(PUBLIC_SALES_2_PERIOD_END)) {
807             return PUBLIC_SALES_2_RATE;
808         }
809 
810         if(now <= preSalesEndDate.add(PUBLIC_SALES_3_PERIOD_END)) {
811             return PUBLIC_SALES_3_RATE;
812         }
813 
814         return REGULAR_RATE;
815     }
816 
817     function createBountyToken(address beneficiary, uint256 amount) public onlyOwner returns(bool) {
818         require(!hasEnded());
819         require(totalMintedBountyTokens.add(amount) <= MAX_BOUNTYTOKENS_AMOUNT);
820 
821         totalMintedBountyTokens = totalMintedBountyTokens.add(amount);
822         token.mint(beneficiary, amount);
823         emit LogBountyTokenMinted(msg.sender, beneficiary, amount);
824 
825         return true;
826     }
827 
828     function setUserManagerContract(address userManagerInstance) public onlyOwner {
829         require(userManagerInstance != address(0));
830 
831         userManagerContract = IUserManager(userManagerInstance);
832     }
833 }
834 
835 contract ICOCappedRefundableCrowdsale is CappedCrowdsale, ICOCrowdsale, RefundableCrowdsale {
836 
837     constructor(uint256 startTime, uint256 endTime, uint256 hardCap, uint256 softCap, address wallet, address HookOperatorContractAddress) public
838         FinalizableCrowdsale()
839         ICOCrowdsale(startTime, endTime, wallet, HookOperatorContractAddress)
840         CappedCrowdsale(hardCap)
841         RefundableCrowdsale(softCap)
842     {
843         require(softCap <= hardCap);
844     }
845 }
846 
847 contract Pausable is Ownable {
848   event Pause();
849   event Unpause();
850 
851   bool public paused = false;
852 
853 
854   /**
855    * @dev Modifier to make a function callable only when the contract is not paused.
856    */
857   modifier whenNotPaused() {
858     require(!paused);
859     _;
860   }
861 
862   /**
863    * @dev Modifier to make a function callable only when the contract is paused.
864    */
865   modifier whenPaused() {
866     require(paused);
867     _;
868   }
869 
870   /**
871    * @dev called by the owner to pause, triggers stopped state
872    */
873   function pause() onlyOwner whenNotPaused public {
874     paused = true;
875     Pause();
876   }
877 
878   /**
879    * @dev called by the owner to unpause, returns to normal state
880    */
881   function unpause() onlyOwner whenPaused public {
882     paused = false;
883     Unpause();
884   }
885 }
886 
887 contract ExchangeOracle is Ownable, Pausable {
888 
889     using SafeMath for uint;
890 
891     bool public isIrisOracle = true;
892 
893     uint public rate = 0;
894     uint public minWeiAmount = 1000; 
895 
896     event LogRateChanged(uint oldRate, uint newRate, address changer);
897     event LogMinWeiAmountChanged(uint oldMinWeiAmount, uint newMinWeiAmount, address changer);
898 
899     constructor(uint initialRate) public {
900         require(initialRate > 0);
901         rate = initialRate;
902     }
903 
904     function rate() external view whenNotPaused returns(uint) {
905         return rate;
906     }
907 
908     /*
909         The new rate has to be passed in format:
910             100 rate = 100 000 passed rate ( 1 ether = 100 tokens )
911             1 rate = 1 000 passed rate ( 1 ether = 1 token )
912             0.01 rate = 10 passed rate ( 100 ethers = 1 token )
913     **/
914     function setRate(uint newRate) external onlyOwner whenNotPaused returns(bool) {
915         require(newRate > 0);
916         
917         uint oldRate = rate;
918         rate = newRate;
919 
920         emit LogRateChanged(oldRate, newRate, msg.sender);
921 
922         return true;
923     }
924 
925     /*
926         By default minWeiAmount = 1000
927         With min wei amount we can set the rate to be a float number
928 
929         We use it as a multiplier because we can not pass float numbers in ethereum
930         If the token price becomes bigger than ether one, for example -> 1 token = 10 ethers
931         We will pass 100 as rate and this will be relevant to 0.1 token = 1 ether
932     **/
933     function setMinWeiAmount(uint newMinWeiAmount) external onlyOwner whenNotPaused returns(bool) {
934         require(newMinWeiAmount > 0);
935         require(newMinWeiAmount % 10 == 0); 
936 
937         uint oldMinWeiAmount = minWeiAmount;
938         minWeiAmount = newMinWeiAmount;
939 
940         emit LogMinWeiAmountChanged(oldMinWeiAmount, minWeiAmount, msg.sender);
941 
942         return true;
943     }
944 
945     function convertTokensAmountInWeiAtRate(uint tokensAmount, uint convertRate) external whenNotPaused view returns(uint) {
946 
947         uint weiAmount = tokensAmount.mul(minWeiAmount);
948         weiAmount = weiAmount.div(convertRate);
949 
950         if ((tokensAmount % convertRate) != 0) {
951             weiAmount++;
952         } 
953 
954         return weiAmount;
955     }
956 
957     function calcWeiForTokensAmount(uint tokensAmount) external view whenNotPaused returns(uint) {
958         
959         uint weiAmount = tokensAmount.mul(minWeiAmount);
960         weiAmount = weiAmount.div(rate);
961 
962         if ((tokensAmount % rate) != 0) {
963             weiAmount++;
964         } 
965 
966         return weiAmount;
967     }
968 }
969 
970 contract ERC20Basic {
971   uint256 public totalSupply;
972   function balanceOf(address who) public view returns (uint256);
973   function transfer(address to, uint256 value) public returns (bool);
974   event Transfer(address indexed from, address indexed to, uint256 value);
975 }
976 
977 contract BasicToken is ERC20Basic {
978   using SafeMath for uint256;
979 
980   mapping(address => uint256) balances;
981 
982   /**
983   * @dev transfer token for a specified address
984   * @param _to The address to transfer to.
985   * @param _value The amount to be transferred.
986   */
987   function transfer(address _to, uint256 _value) public returns (bool) {
988     require(_to != address(0));
989     require(_value <= balances[msg.sender]);
990 
991     // SafeMath.sub will throw if there is not enough balance.
992     balances[msg.sender] = balances[msg.sender].sub(_value);
993     balances[_to] = balances[_to].add(_value);
994     Transfer(msg.sender, _to, _value);
995     return true;
996   }
997 
998   /**
999   * @dev Gets the balance of the specified address.
1000   * @param _owner The address to query the the balance of.
1001   * @return An uint256 representing the amount owned by the passed address.
1002   */
1003   function balanceOf(address _owner) public view returns (uint256 balance) {
1004     return balances[_owner];
1005   }
1006 
1007 }
1008 
1009 contract BurnableToken is BasicToken {
1010 
1011     event Burn(address indexed burner, uint256 value);
1012 
1013     /**
1014      * @dev Burns a specific amount of tokens.
1015      * @param _value The amount of token to be burned.
1016      */
1017     function burn(uint256 _value) public {
1018         require(_value <= balances[msg.sender]);
1019         // no need to require value <= totalSupply, since that would imply the
1020         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1021 
1022         address burner = msg.sender;
1023         balances[burner] = balances[burner].sub(_value);
1024         totalSupply = totalSupply.sub(_value);
1025         Burn(burner, _value);
1026     }
1027 }
1028 
1029 contract ERC20 is ERC20Basic {
1030   function allowance(address owner, address spender) public view returns (uint256);
1031   function transferFrom(address from, address to, uint256 value) public returns (bool);
1032   function approve(address spender, uint256 value) public returns (bool);
1033   event Approval(address indexed owner, address indexed spender, uint256 value);
1034 }
1035 
1036 contract StandardToken is ERC20, BasicToken {
1037 
1038   mapping (address => mapping (address => uint256)) internal allowed;
1039 
1040 
1041   /**
1042    * @dev Transfer tokens from one address to another
1043    * @param _from address The address which you want to send tokens from
1044    * @param _to address The address which you want to transfer to
1045    * @param _value uint256 the amount of tokens to be transferred
1046    */
1047   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1048     require(_to != address(0));
1049     require(_value <= balances[_from]);
1050     require(_value <= allowed[_from][msg.sender]);
1051 
1052     balances[_from] = balances[_from].sub(_value);
1053     balances[_to] = balances[_to].add(_value);
1054     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1055     Transfer(_from, _to, _value);
1056     return true;
1057   }
1058 
1059   /**
1060    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1061    *
1062    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1063    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1064    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1065    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1066    * @param _spender The address which will spend the funds.
1067    * @param _value The amount of tokens to be spent.
1068    */
1069   function approve(address _spender, uint256 _value) public returns (bool) {
1070     allowed[msg.sender][_spender] = _value;
1071     Approval(msg.sender, _spender, _value);
1072     return true;
1073   }
1074 
1075   /**
1076    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1077    * @param _owner address The address which owns the funds.
1078    * @param _spender address The address which will spend the funds.
1079    * @return A uint256 specifying the amount of tokens still available for the spender.
1080    */
1081   function allowance(address _owner, address _spender) public view returns (uint256) {
1082     return allowed[_owner][_spender];
1083   }
1084 
1085   /**
1086    * @dev Increase the amount of tokens that an owner allowed to a spender.
1087    *
1088    * approve should be called when allowed[_spender] == 0. To increment
1089    * allowed value is better to use this function to avoid 2 calls (and wait until
1090    * the first transaction is mined)
1091    * From MonolithDAO Token.sol
1092    * @param _spender The address which will spend the funds.
1093    * @param _addedValue The amount of tokens to increase the allowance by.
1094    */
1095   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1096     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1097     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1098     return true;
1099   }
1100 
1101   /**
1102    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1103    *
1104    * approve should be called when allowed[_spender] == 0. To decrement
1105    * allowed value is better to use this function to avoid 2 calls (and wait until
1106    * the first transaction is mined)
1107    * From MonolithDAO Token.sol
1108    * @param _spender The address which will spend the funds.
1109    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1110    */
1111   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1112     uint oldValue = allowed[msg.sender][_spender];
1113     if (_subtractedValue > oldValue) {
1114       allowed[msg.sender][_spender] = 0;
1115     } else {
1116       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1117     }
1118     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1119     return true;
1120   }
1121 
1122 }
1123 
1124 contract MintableToken is StandardToken, Ownable {
1125   event Mint(address indexed to, uint256 amount);
1126   event MintFinished();
1127 
1128   bool public mintingFinished = false;
1129 
1130 
1131   modifier canMint() {
1132     require(!mintingFinished);
1133     _;
1134   }
1135 
1136   /**
1137    * @dev Function to mint tokens
1138    * @param _to The address that will receive the minted tokens.
1139    * @param _amount The amount of tokens to mint.
1140    * @return A boolean that indicates if the operation was successful.
1141    */
1142   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
1143     totalSupply = totalSupply.add(_amount);
1144     balances[_to] = balances[_to].add(_amount);
1145     Mint(_to, _amount);
1146     Transfer(address(0), _to, _amount);
1147     return true;
1148   }
1149 
1150   /**
1151    * @dev Function to stop minting new tokens.
1152    * @return True if the operation was successful.
1153    */
1154   function finishMinting() onlyOwner canMint public returns (bool) {
1155     mintingFinished = true;
1156     MintFinished();
1157     return true;
1158   }
1159 }
1160 
1161 contract PausableToken is StandardToken, Pausable {
1162 
1163   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
1164     return super.transfer(_to, _value);
1165   }
1166 
1167   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
1168     return super.transferFrom(_from, _to, _value);
1169   }
1170 
1171   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
1172     return super.approve(_spender, _value);
1173   }
1174 
1175   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
1176     return super.increaseApproval(_spender, _addedValue);
1177   }
1178 
1179   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
1180     return super.decreaseApproval(_spender, _subtractedValue);
1181   }
1182 }
1183 
1184 contract ICOToken is BurnableToken, MintableToken, PausableToken {
1185 
1186     string public constant name = "AIUR Token";
1187     string public constant symbol = "AIUR";
1188     uint8 public constant decimals = 18;
1189 }
1190 
1191 contract ICOTokenExtended is ICOToken {
1192 
1193     address public refunder;
1194 
1195     IHookOperator public hookOperator;
1196     ExchangeOracle public aiurExchangeOracle;
1197 
1198     mapping(address => bool) public minters;
1199 
1200     uint256 public constant MIN_REFUND_RATE_DELIMITER = 2; // Refund rate has to be minimum 50% of the AIUR ExchangeOracle rate
1201 
1202     event LogRefunderSet(address refunderAddress);
1203     event LogTransferOverFunds(address from, address to, uint ethersAmount, uint tokensAmount);
1204     event LogTaxTransfer(address from, address to, uint amount);
1205     event LogMinterAdd(address addedMinter);
1206     event LogMinterRemove(address removedMinter);
1207 
1208     modifier onlyMinter(){
1209         require(minters[msg.sender]);
1210         
1211         _;
1212     }
1213 
1214     modifier onlyCurrentHookOperator() {
1215         require(msg.sender == address(hookOperator));
1216 
1217         _;
1218     }
1219 
1220     modifier nonZeroAddress(address inputAddress) {
1221         require(inputAddress != address(0));
1222 
1223         _;
1224     }
1225 
1226     modifier onlyRefunder() {
1227         require(msg.sender == refunder);
1228 
1229         _;
1230     }
1231 
1232     constructor() public {
1233         minters[msg.sender] = true;
1234     }
1235 
1236     function setRefunder(address refunderAddress) external onlyOwner nonZeroAddress(refunderAddress) {
1237         refunder = refunderAddress;
1238 
1239         emit LogRefunderSet(refunderAddress);
1240     }
1241 
1242     // Set the exchange oracle after crowdsale 
1243     function setExchangeOracle(address exchangeOracleAddress) external onlyOwner nonZeroAddress(exchangeOracleAddress) {
1244         aiurExchangeOracle = ExchangeOracle(exchangeOracleAddress);
1245     }
1246 
1247     function setHookOperator(address hookOperatorAddress) external onlyOwner nonZeroAddress(hookOperatorAddress) {
1248         hookOperator = IHookOperator(hookOperatorAddress);
1249     }
1250 
1251     function addMinter(address minterAddress) external onlyOwner nonZeroAddress(minterAddress) {
1252         minters[minterAddress] = true;    
1253 
1254         emit LogMinterAdd(minterAddress);
1255     }
1256 
1257     function removeMinter(address minterAddress) external onlyOwner nonZeroAddress(minterAddress) {
1258         minters[minterAddress] = false;    
1259 
1260         emit LogMinterRemove(minterAddress);
1261     }
1262 
1263     function mint(address to, uint256 tokensAmount) public onlyMinter canMint nonZeroAddress(to) returns(bool) {
1264         hookOperator.onMint(to, tokensAmount);
1265 
1266         totalSupply = totalSupply.add(tokensAmount);
1267         balances[to] = balances[to].add(tokensAmount);
1268 
1269         emit Mint(to, tokensAmount);
1270         emit Transfer(address(0), to, tokensAmount);
1271         return true;
1272     } 
1273 
1274     function burn(uint tokensAmount) public {
1275         hookOperator.onBurn(tokensAmount);       
1276 
1277         super.burn(tokensAmount);  
1278     } 
1279 
1280     function transfer(address to, uint tokensAmount) public nonZeroAddress(to) returns(bool) {
1281         hookOperator.onTransfer(msg.sender, to, tokensAmount);
1282 
1283         return super.transfer(to, tokensAmount);
1284     }
1285     
1286     function transferFrom(address from, address to, uint tokensAmount) public nonZeroAddress(from) nonZeroAddress(to) returns(bool) {
1287         hookOperator.onTransfer(from, to, tokensAmount);
1288         
1289         return super.transferFrom(from, to, tokensAmount);
1290     }
1291 
1292     /*
1293         This function is used for taxation purposes and will be used after pre-defined requirement are met
1294     */
1295     function taxTransfer(address from, address to, uint tokensAmount) external onlyCurrentHookOperator nonZeroAddress(from) nonZeroAddress(to) returns(bool) {  
1296         require(balances[from] >= tokensAmount);
1297 
1298         transferDirectly(from, to, tokensAmount);
1299 
1300         hookOperator.onTaxTransfer(from, tokensAmount);
1301         emit LogTaxTransfer(from, to, tokensAmount);
1302 
1303         return true;
1304     }
1305 
1306     function transferOverBalanceFunds(address from, address to, uint rate) external payable onlyRefunder nonZeroAddress(from) nonZeroAddress(to) returns(bool) {
1307         require(!hookOperator.isOverBalanceLimitHolder(from));
1308 
1309         uint256 oracleRate = aiurExchangeOracle.rate();
1310         require(rate <= oracleRate.add(oracleRate.div(MIN_REFUND_RATE_DELIMITER)));
1311 
1312         uint256 fromBalance = balanceOf(from);
1313         
1314         // Calculate percentage limit in tokens
1315         uint256 maxTokensBalance = totalSupply.mul(hookOperator.getBalancePercentageLimit()).div(100);
1316 
1317         require(fromBalance > maxTokensBalance);
1318 
1319         uint256 tokensToTake = fromBalance.sub(maxTokensBalance);
1320         uint256 weiToRefund = aiurExchangeOracle.convertTokensAmountInWeiAtRate(tokensToTake, rate);
1321 
1322         require(hookOperator.isInBalanceLimit(to, tokensToTake));
1323         require(msg.value == weiToRefund);
1324 
1325         transferDirectly(from, to, tokensToTake);
1326         from.transfer(msg.value);
1327 
1328         emit LogTransferOverFunds(from, to, weiToRefund, tokensToTake);
1329 
1330         return true;
1331     }
1332 
1333     function transferDirectly(address from, address to, uint tokensAmount) private {
1334         balances[from] = balances[from].sub(tokensAmount);
1335         balances[to] = balances[to].add(tokensAmount);
1336     }
1337 }