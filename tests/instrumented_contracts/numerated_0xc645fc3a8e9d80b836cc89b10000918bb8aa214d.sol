1 pragma solidity ^0.4.13;
2 
3 contract EthicHubReputationInterface {
4     modifier onlyUsersContract(){_;}
5     modifier onlyLendingContract(){_;}
6     function burnReputation(uint delayDays)  external;
7     function incrementReputation(uint completedProjectsByTier)  external;
8     function initLocalNodeReputation(address localNode)  external;
9     function initCommunityReputation(address community)  external;
10     function getCommunityReputation(address target) public view returns(uint256);
11     function getLocalNodeReputation(address target) public view returns(uint256);
12 }
13 
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipRenounced(address indexed previousOwner);
19   event OwnershipTransferred(
20     address indexed previousOwner,
21     address indexed newOwner
22   );
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   constructor() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to relinquish control of the contract.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 contract Pausable is Ownable {
69   event Pause();
70   event Unpause();
71 
72   bool public paused = false;
73 
74 
75   /**
76    * @dev Modifier to make a function callable only when the contract is not paused.
77    */
78   modifier whenNotPaused() {
79     require(!paused);
80     _;
81   }
82 
83   /**
84    * @dev Modifier to make a function callable only when the contract is paused.
85    */
86   modifier whenPaused() {
87     require(paused);
88     _;
89   }
90 
91   /**
92    * @dev called by the owner to pause, triggers stopped state
93    */
94   function pause() onlyOwner whenNotPaused public {
95     paused = true;
96     emit Pause();
97   }
98 
99   /**
100    * @dev called by the owner to unpause, returns to normal state
101    */
102   function unpause() onlyOwner whenPaused public {
103     paused = false;
104     emit Unpause();
105   }
106 }
107 
108 contract EthicHubBase {
109 
110     uint8 public version;
111 
112     EthicHubStorageInterface public ethicHubStorage = EthicHubStorageInterface(0);
113 
114     constructor(address _storageAddress) public {
115         require(_storageAddress != address(0));
116         ethicHubStorage = EthicHubStorageInterface(_storageAddress);
117     }
118 
119 }
120 
121 contract EthicHubLending is EthicHubBase, Ownable, Pausable {
122     using SafeMath for uint256;
123     uint256 public minContribAmount = 0.1 ether;                          // 0.01 ether
124     enum LendingState {
125         Uninitialized,
126         AcceptingContributions,
127         ExchangingToFiat,
128         AwaitingReturn,
129         ProjectNotFunded,
130         ContributionReturned,
131         Default
132     }
133     mapping(address => Investor) public investors;
134     uint256 public investorCount;
135     uint256 public fundingStartTime;                                     // Start time of contribution period in UNIX time
136     uint256 public fundingEndTime;                                       // End time of contribution period in UNIX time
137     uint256 public totalContributed;
138     bool public capReached;
139     LendingState public state;
140     uint256 public annualInterest;
141     uint256 public totalLendingAmount;
142     uint256 public lendingDays;
143     uint256 public initialEthPerFiatRate;
144     uint256 public totalLendingFiatAmount;
145     address public borrower;
146     address public localNode;
147     address public ethicHubTeam;
148     uint256 public borrowerReturnDate;
149     uint256 public borrowerReturnEthPerFiatRate;
150     uint256 public constant ethichubFee = 3;
151     uint256 public constant localNodeFee = 4;
152     uint256 public tier;
153     // interest rate is using base uint 100 and 100% 10000, this means 1% is 100
154     // this guarantee we can have a 2 decimal presicion in our calculation
155     uint256 public constant interestBaseUint = 100;
156     uint256 public constant interestBasePercent = 10000;
157     bool public localNodeFeeReclaimed;
158     bool public ethicHubTeamFeeReclaimed;
159     uint256 public surplusEth;
160     uint256 public returnedEth;
161 
162     struct Investor {
163         uint256 amount;
164         bool isCompensated;
165         bool surplusEthReclaimed;
166     }
167 
168     // events
169     event onCapReached(uint endTime);
170     event onContribution(uint totalContributed, address indexed investor, uint amount, uint investorsCount);
171     event onCompensated(address indexed contributor, uint amount);
172     event onSurplusSent(uint256 amount);
173     event onSurplusReclaimed(address indexed contributor, uint amount);
174     event StateChange(uint state);
175     event onInitalRateSet(uint rate);
176     event onReturnRateSet(uint rate);
177     event onReturnAmount(address indexed borrower, uint amount);
178     event onBorrowerChanged(address indexed newBorrower);
179 
180     // modifiers
181     modifier checkProfileRegistered(string profile) {
182         bool isRegistered = ethicHubStorage.getBool(keccak256("user", profile, msg.sender));
183         require(isRegistered);
184         _;
185     }
186 
187     modifier checkIfArbiter() {
188         address arbiter = ethicHubStorage.getAddress(keccak256("arbiter", this));
189         require(arbiter == msg.sender);
190         _;
191     }
192 
193     modifier onlyOwnerOrLocalNode() {
194         require(localNode == msg.sender || owner == msg.sender);
195         _;
196     }
197 
198     constructor(
199         uint256 _fundingStartTime,
200         uint256 _fundingEndTime,
201         address _borrower,
202         uint256 _annualInterest,
203         uint256 _totalLendingAmount,
204         uint256 _lendingDays,
205         address _storageAddress,
206         address _localNode,
207         address _ethicHubTeam
208         )
209         EthicHubBase(_storageAddress)
210         public {
211         require(_fundingStartTime > now);
212         require(_fundingEndTime > fundingStartTime);
213         require(_borrower != address(0));
214         require(ethicHubStorage.getBool(keccak256("user", "representative", _borrower)));
215         require(_localNode != address(0));
216         require(_ethicHubTeam != address(0));
217         require(ethicHubStorage.getBool(keccak256("user", "localNode", _localNode)));
218         require(_totalLendingAmount > 0);
219         require(_lendingDays > 0);
220         require(_annualInterest > 0 && _annualInterest < 100);
221         version = 2;
222         fundingStartTime = _fundingStartTime;
223         fundingEndTime = _fundingEndTime;
224         localNode = _localNode;
225         ethicHubTeam = _ethicHubTeam;
226         borrower = _borrower;
227         annualInterest = _annualInterest;
228         totalLendingAmount = _totalLendingAmount;
229         lendingDays = _lendingDays;
230         state = LendingState.Uninitialized;
231     }
232 
233     function saveInitialParametersToStorage(uint256 _maxDelayDays, uint256 _tier, uint256 _communityMembers, address _community) external onlyOwnerOrLocalNode {
234         require(_maxDelayDays != 0);
235         require(state == LendingState.Uninitialized);
236         require(_tier > 0);
237         require(_communityMembers > 0);
238         require(ethicHubStorage.getBool(keccak256("user", "community", _community)));
239         ethicHubStorage.setUint(keccak256("lending.maxDelayDays", this), _maxDelayDays);
240         ethicHubStorage.setAddress(keccak256("lending.community", this), _community);
241         ethicHubStorage.setAddress(keccak256("lending.localNode", this), localNode);
242         ethicHubStorage.setUint(keccak256("lending.tier", this), _tier);
243         ethicHubStorage.setUint(keccak256("lending.communityMembers", this), _communityMembers);
244         tier = _tier;
245         state = LendingState.AcceptingContributions;
246         emit StateChange(uint(state));
247 
248     }
249 
250     function setBorrower(address _borrower) external checkIfArbiter {
251         require(_borrower != address(0));
252         require(ethicHubStorage.getBool(keccak256("user", "representative", _borrower)));
253         borrower = _borrower;
254         emit onBorrowerChanged(borrower);
255     }
256 
257     function() public payable whenNotPaused {
258         require(state == LendingState.AwaitingReturn || state == LendingState.AcceptingContributions || state == LendingState.ExchangingToFiat);
259         if(state == LendingState.AwaitingReturn) {
260             returnBorrowedEth();
261         } else if (state == LendingState.ExchangingToFiat) {
262             // borrower can send surplus eth back to contract to avoid paying interest
263             sendBackSurplusEth();
264         } else {
265             contributeWithAddress(msg.sender);
266         }
267     }
268 
269     function sendBackSurplusEth() internal {
270         require(state == LendingState.ExchangingToFiat);
271         require(msg.sender == borrower);
272         surplusEth = surplusEth.add(msg.value);
273         require(surplusEth <= totalLendingAmount);
274         emit onSurplusSent(msg.value);
275     }
276 
277     /**
278      * After the contribution period ends unsuccesfully, this method enables the contributor
279      *  to retrieve their contribution
280      */
281     function declareProjectNotFunded() external onlyOwnerOrLocalNode {
282         require(totalContributed < totalLendingAmount);
283         require(state == LendingState.AcceptingContributions);
284         require(now > fundingEndTime);
285         state = LendingState.ProjectNotFunded;
286         emit StateChange(uint(state));
287     }
288 
289     function declareProjectDefault() external onlyOwnerOrLocalNode {
290         require(state == LendingState.AwaitingReturn);
291         uint maxDelayDays = getMaxDelayDays();
292         require(getDelayDays(now) >= maxDelayDays);
293         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
294         require(reputation != address(0));
295         ethicHubStorage.setUint(keccak256("lending.delayDays", this), maxDelayDays);
296         reputation.burnReputation(maxDelayDays);
297         state = LendingState.Default;
298         emit StateChange(uint(state));
299     }
300 
301     function setBorrowerReturnEthPerFiatRate(uint256 _borrowerReturnEthPerFiatRate) external onlyOwnerOrLocalNode {
302         require(state == LendingState.AwaitingReturn);
303         borrowerReturnEthPerFiatRate = _borrowerReturnEthPerFiatRate;
304         emit onReturnRateSet(borrowerReturnEthPerFiatRate);
305     }
306 
307     function finishInitialExchangingPeriod(uint256 _initialEthPerFiatRate) external onlyOwnerOrLocalNode {
308         require(capReached == true);
309         require(state == LendingState.ExchangingToFiat);
310         initialEthPerFiatRate = _initialEthPerFiatRate;
311         if (surplusEth > 0) {
312             totalLendingAmount = totalLendingAmount.sub(surplusEth);
313         }
314         totalLendingFiatAmount = totalLendingAmount.mul(initialEthPerFiatRate);
315         emit onInitalRateSet(initialEthPerFiatRate);
316         state = LendingState.AwaitingReturn;
317         emit StateChange(uint(state));
318     }
319 
320     /**
321      * Method to reclaim contribution after project is declared default (% of partial funds)
322      * @param  beneficiary the contributor
323      *
324      */
325     function reclaimContributionDefault(address beneficiary) external {
326         require(state == LendingState.Default);
327         require(!investors[beneficiary].isCompensated);
328         // contribution = contribution * partial_funds / total_funds
329         uint256 contribution = checkInvestorReturns(beneficiary);
330         require(contribution > 0);
331         investors[beneficiary].isCompensated = true;
332         beneficiary.transfer(contribution);
333     }
334 
335     /**
336      * Method to reclaim contribution after a project is declared as not funded
337      * @param  beneficiary the contributor
338      *
339      */
340     function reclaimContribution(address beneficiary) external {
341         require(state == LendingState.ProjectNotFunded);
342         require(!investors[beneficiary].isCompensated);
343         uint256 contribution = investors[beneficiary].amount;
344         require(contribution > 0);
345         investors[beneficiary].isCompensated = true;
346         beneficiary.transfer(contribution);
347     }
348 
349     function reclaimSurplusEth(address beneficiary) external {
350         require(surplusEth > 0);
351         // only can be reclaimed after cap reduced
352         require(state != LendingState.ExchangingToFiat);
353         require(!investors[beneficiary].surplusEthReclaimed);
354         uint256 surplusContribution = investors[beneficiary].amount.mul(surplusEth).div(surplusEth.add(totalLendingAmount));
355         require(surplusContribution > 0);
356         investors[beneficiary].surplusEthReclaimed = true;
357         emit onSurplusReclaimed(beneficiary, surplusContribution);
358         beneficiary.transfer(surplusContribution);
359     }
360 
361     function reclaimContributionWithInterest(address beneficiary) external {
362         require(state == LendingState.ContributionReturned);
363         require(!investors[beneficiary].isCompensated);
364         uint256 contribution = checkInvestorReturns(beneficiary);
365         require(contribution > 0);
366         investors[beneficiary].isCompensated = true;
367         beneficiary.transfer(contribution);
368     }
369 
370     function reclaimLocalNodeFee() external {
371         require(state == LendingState.ContributionReturned);
372         require(localNodeFeeReclaimed == false);
373         uint256 fee = totalLendingFiatAmount.mul(localNodeFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
374         require(fee > 0);
375         localNodeFeeReclaimed = true;
376         localNode.transfer(fee);
377     }
378 
379     function reclaimEthicHubTeamFee() external {
380         require(state == LendingState.ContributionReturned);
381         require(ethicHubTeamFeeReclaimed == false);
382         uint256 fee = totalLendingFiatAmount.mul(ethichubFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
383         require(fee > 0);
384         ethicHubTeamFeeReclaimed = true;
385         ethicHubTeam.transfer(fee);
386     }
387 
388     function returnBorrowedEth() internal {
389         require(state == LendingState.AwaitingReturn);
390         require(msg.sender == borrower);
391         require(borrowerReturnEthPerFiatRate > 0);
392         bool projectRepayed = false;
393         uint excessRepayment = 0;
394         uint newReturnedEth = 0;
395         emit onReturnAmount(msg.sender, msg.value);
396         (newReturnedEth, projectRepayed, excessRepayment) = calculatePaymentGoal(
397                                                                                     borrowerReturnAmount(),
398                                                                                     returnedEth,
399                                                                                     msg.value);
400         returnedEth = newReturnedEth;
401         if (projectRepayed == true) {
402             state = LendingState.ContributionReturned;
403             emit StateChange(uint(state));
404             updateReputation();
405         }
406         if (excessRepayment > 0) {
407             msg.sender.transfer(excessRepayment);
408         }
409     }
410 
411     // @notice Function to participate in contribution period
412     //  Amounts from the same address should be added up
413     //  If cap is reached, end time should be modified
414     //  Funds should be transferred into multisig wallet
415     // @param contributor Address
416     function contributeWithAddress(address contributor) internal checkProfileRegistered('investor') whenNotPaused {
417         require(state == LendingState.AcceptingContributions);
418         require(msg.value >= minContribAmount);
419         require(isContribPeriodRunning());
420 
421         uint oldTotalContributed = totalContributed;
422         uint newTotalContributed = 0;
423         uint excessContribValue = 0;
424         (newTotalContributed, capReached, excessContribValue) = calculatePaymentGoal(
425                                                                                     totalLendingAmount,
426                                                                                     oldTotalContributed,
427                                                                                     msg.value);
428         totalContributed = newTotalContributed;
429         if (capReached) {
430             fundingEndTime = now;
431             emit onCapReached(fundingEndTime);
432         }
433         if (investors[contributor].amount == 0) {
434             investorCount = investorCount.add(1);
435         }
436         if (excessContribValue > 0) {
437             msg.sender.transfer(excessContribValue);
438             investors[contributor].amount = investors[contributor].amount.add(msg.value).sub(excessContribValue);
439             emit onContribution(newTotalContributed, contributor, msg.value.sub(excessContribValue), investorCount);
440         } else {
441             investors[contributor].amount = investors[contributor].amount.add(msg.value);
442             emit onContribution(newTotalContributed, contributor, msg.value, investorCount);
443         }
444     }
445 
446     function calculatePaymentGoal(uint goal, uint oldTotal, uint contribValue) internal pure returns(uint, bool, uint) {
447         uint newTotal = oldTotal.add(contribValue);
448         bool goalReached = false;
449         uint excess = 0;
450         if (newTotal >= goal && oldTotal < goal) {
451             goalReached = true;
452             excess = newTotal.sub(goal);
453             contribValue = contribValue.sub(excess);
454             newTotal = goal;
455         }
456         return (newTotal, goalReached, excess);
457     }
458 
459     function sendFundsToBorrower() external onlyOwnerOrLocalNode {
460       //Waiting for Exchange
461         require(state == LendingState.AcceptingContributions);
462         require(capReached);
463         state = LendingState.ExchangingToFiat;
464         emit StateChange(uint(state));
465         borrower.transfer(totalContributed);
466     }
467 
468     function updateReputation() internal {
469         uint delayDays = getDelayDays(now);
470         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
471         require(reputation != address(0));
472         if (delayDays > 0) {
473             ethicHubStorage.setUint(keccak256("lending.delayDays", this), delayDays);
474             reputation.burnReputation(delayDays);
475         } else {
476             uint completedProjectsByTier  = ethicHubStorage.getUint(keccak256("community.completedProjectsByTier", this, tier)).add(1);
477             ethicHubStorage.setUint(keccak256("community.completedProjectsByTier", this, tier), completedProjectsByTier);
478             reputation.incrementReputation(completedProjectsByTier);
479         }
480     }
481 
482     function getDelayDays(uint date) public view returns(uint) {
483         uint lendingDaysSeconds = lendingDays * 1 days;
484         uint defaultTime = fundingEndTime.add(lendingDaysSeconds);
485         if (date < defaultTime) {
486             return 0;
487         } else {
488             return date.sub(defaultTime).div(60).div(60).div(24);
489         }
490     }
491 
492     // lendingInterestRate with 2 decimal
493     // 15 * (lending days)/ 365 + 4% local node fee + 3% LendingDev fee
494     function lendingInterestRatePercentage() public view returns(uint256){
495         return annualInterest.mul(interestBaseUint).mul(lendingDays.add(getDelayDays(now))).div(365).add(localNodeFee.mul(interestBaseUint)).add(ethichubFee.mul(interestBaseUint)).add(interestBasePercent);
496     }
497 
498     // lendingInterestRate with 2 decimal
499     function investorInterest() public view returns(uint256){
500         return annualInterest.mul(interestBaseUint).mul(lendingDays.add(getDelayDays(now))).div(365).add(interestBasePercent);
501     }
502 
503     function borrowerReturnFiatAmount() public view returns(uint256) {
504         return totalLendingFiatAmount.mul(lendingInterestRatePercentage()).div(interestBasePercent);
505     }
506 
507     function borrowerReturnAmount() public view returns(uint256) {
508         return borrowerReturnFiatAmount().div(borrowerReturnEthPerFiatRate);
509     }
510 
511     function isContribPeriodRunning() public view returns(bool) {
512         return fundingStartTime <= now && fundingEndTime > now && !capReached;
513     }
514 
515     function checkInvestorContribution(address investor) public view returns(uint256){
516         return investors[investor].amount;
517     }
518 
519     function checkInvestorReturns(address investor) public view returns(uint256) {
520         uint256 investorAmount = 0;
521         if (state == LendingState.ContributionReturned) {
522             investorAmount = investors[investor].amount;
523             if (surplusEth > 0){
524                 investorAmount  = investors[investor].amount.mul(totalLendingAmount).div(totalContributed);
525             }
526             return investorAmount.mul(initialEthPerFiatRate).mul(investorInterest()).div(borrowerReturnEthPerFiatRate).div(interestBasePercent);
527         } else if (state == LendingState.Default){
528             investorAmount = investors[investor].amount;
529             // contribution = contribution * partial_funds / total_funds
530             return investorAmount.mul(returnedEth).div(totalLendingAmount);
531         } else {
532             return 0;
533         }
534     }
535 
536     function getMaxDelayDays() public view returns(uint256){
537         return ethicHubStorage.getUint(keccak256("lending.maxDelayDays", this));
538     }
539 
540     function getUserContributionReclaimStatus(address userAddress) public view returns(bool isCompensated, bool surplusEthReclaimed){
541         isCompensated = investors[userAddress].isCompensated;
542         surplusEthReclaimed = investors[userAddress].surplusEthReclaimed;
543     }
544 }
545 
546 library SafeMath {
547 
548   /**
549   * @dev Multiplies two numbers, throws on overflow.
550   */
551   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
552     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
553     // benefit is lost if 'b' is also tested.
554     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
555     if (a == 0) {
556       return 0;
557     }
558 
559     c = a * b;
560     assert(c / a == b);
561     return c;
562   }
563 
564   /**
565   * @dev Integer division of two numbers, truncating the quotient.
566   */
567   function div(uint256 a, uint256 b) internal pure returns (uint256) {
568     // assert(b > 0); // Solidity automatically throws when dividing by 0
569     // uint256 c = a / b;
570     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
571     return a / b;
572   }
573 
574   /**
575   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
576   */
577   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
578     assert(b <= a);
579     return a - b;
580   }
581 
582   /**
583   * @dev Adds two numbers, throws on overflow.
584   */
585   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
586     c = a + b;
587     assert(c >= a);
588     return c;
589   }
590 }
591 
592 contract EthicHubStorageInterface {
593 
594     //modifier for access in sets and deletes
595     modifier onlyEthicHubContracts() {_;}
596 
597     // Setters
598     function setAddress(bytes32 _key, address _value) external;
599     function setUint(bytes32 _key, uint _value) external;
600     function setString(bytes32 _key, string _value) external;
601     function setBytes(bytes32 _key, bytes _value) external;
602     function setBool(bytes32 _key, bool _value) external;
603     function setInt(bytes32 _key, int _value) external;
604     // Deleters
605     function deleteAddress(bytes32 _key) external;
606     function deleteUint(bytes32 _key) external;
607     function deleteString(bytes32 _key) external;
608     function deleteBytes(bytes32 _key) external;
609     function deleteBool(bytes32 _key) external;
610     function deleteInt(bytes32 _key) external;
611 
612     // Getters
613     function getAddress(bytes32 _key) external view returns (address);
614     function getUint(bytes32 _key) external view returns (uint);
615     function getString(bytes32 _key) external view returns (string);
616     function getBytes(bytes32 _key) external view returns (bytes);
617     function getBool(bytes32 _key) external view returns (bool);
618     function getInt(bytes32 _key) external view returns (int);
619 }