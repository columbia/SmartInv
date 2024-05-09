1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 contract EthicHubReputationInterface {
104     modifier onlyUsersContract(){_;}
105     modifier onlyLendingContract(){_;}
106     function burnReputation(uint delayDays)  external;
107     function incrementReputation(uint completedProjectsByTier)  external;
108     function initLocalNodeReputation(address localNode)  external;
109     function initCommunityReputation(address community)  external;
110     function getCommunityReputation(address target) public view returns(uint256);
111     function getLocalNodeReputation(address target) public view returns(uint256);
112 }
113 
114 contract EthicHubBase {
115 
116     uint8 public version;
117 
118     EthicHubStorageInterface public ethicHubStorage = EthicHubStorageInterface(0);
119 
120     constructor(address _storageAddress) public {
121         require(_storageAddress != address(0));
122         ethicHubStorage = EthicHubStorageInterface(_storageAddress);
123     }
124 
125 }
126 
127 contract Pausable is Ownable {
128   event Pause();
129   event Unpause();
130 
131   bool public paused = false;
132 
133 
134   /**
135    * @dev Modifier to make a function callable only when the contract is not paused.
136    */
137   modifier whenNotPaused() {
138     require(!paused);
139     _;
140   }
141 
142   /**
143    * @dev Modifier to make a function callable only when the contract is paused.
144    */
145   modifier whenPaused() {
146     require(paused);
147     _;
148   }
149 
150   /**
151    * @dev called by the owner to pause, triggers stopped state
152    */
153   function pause() onlyOwner whenNotPaused public {
154     paused = true;
155     emit Pause();
156   }
157 
158   /**
159    * @dev called by the owner to unpause, returns to normal state
160    */
161   function unpause() onlyOwner whenPaused public {
162     paused = false;
163     emit Unpause();
164   }
165 }
166 
167 contract EthicHubLending is EthicHubBase, Ownable, Pausable {
168     using SafeMath for uint256;
169     uint256 public minContribAmount = 0.1 ether;                          // 0.01 ether
170     enum LendingState {
171         Uninitialized,
172         AcceptingContributions,
173         ExchangingToFiat,
174         AwaitingReturn,
175         ProjectNotFunded,
176         ContributionReturned,
177         Default
178     }
179     mapping(address => Investor) public investors;
180     uint256 public investorCount;
181     uint256 public fundingStartTime;                                     // Start time of contribution period in UNIX time
182     uint256 public fundingEndTime;                                       // End time of contribution period in UNIX time
183     uint256 public totalContributed;
184     bool public capReached;
185     LendingState public state;
186     uint256 public annualInterest;
187     uint256 public totalLendingAmount;
188     uint256 public lendingDays;
189     uint256 public initialEthPerFiatRate;
190     uint256 public totalLendingFiatAmount;
191     address public borrower;
192     address public localNode;
193     address public ethicHubTeam;
194     uint256 public borrowerReturnDate;
195     uint256 public borrowerReturnEthPerFiatRate;
196     uint256 public constant ethichubFee = 3;
197     uint256 public constant localNodeFee = 4;
198     uint256 public tier;
199     // interest rate is using base uint 100 and 100% 10000, this means 1% is 100
200     // this guarantee we can have a 2 decimal presicion in our calculation
201     uint256 public constant interestBaseUint = 100;
202     uint256 public constant interestBasePercent = 10000;
203     bool public localNodeFeeReclaimed;
204     bool public ethicHubTeamFeeReclaimed;
205     uint256 public surplusEth;
206     uint256 public returnedEth;
207 
208     struct Investor {
209         uint256 amount;
210         bool isCompensated;
211         bool surplusEthReclaimed;
212     }
213 
214     // events
215     event onCapReached(uint endTime);
216     event onContribution(uint totalContributed, address indexed investor, uint amount, uint investorsCount);
217     event onCompensated(address indexed contributor, uint amount);
218     event onSurplusSent(uint256 amount);
219     event onSurplusReclaimed(address indexed contributor, uint amount);
220     event StateChange(uint state);
221     event onInitalRateSet(uint rate);
222     event onReturnRateSet(uint rate);
223     event onReturnAmount(address indexed borrower, uint amount);
224 
225     // modifiers
226     modifier checkProfileRegistered(string profile) {
227         bool isRegistered = ethicHubStorage.getBool(keccak256("user", profile, msg.sender));
228         require(isRegistered);
229         _;
230     }
231 
232     modifier onlyOwnerOrLocalNode() {
233         require(localNode == msg.sender || owner == msg.sender);
234         _;
235     }
236 
237     constructor(
238         uint256 _fundingStartTime,
239         uint256 _fundingEndTime,
240         address _borrower,
241         uint256 _annualInterest,
242         uint256 _totalLendingAmount,
243         uint256 _lendingDays,
244         address _storageAddress,
245         address _localNode,
246         address _ethicHubTeam
247         )
248         EthicHubBase(_storageAddress)
249         public {
250         require(_fundingStartTime > now);
251         require(_fundingEndTime > fundingStartTime);
252         require(_borrower != address(0));
253         require(ethicHubStorage.getBool(keccak256("user", "representative", _borrower)));
254         require(_localNode != address(0));
255         require(_ethicHubTeam != address(0));
256         require(ethicHubStorage.getBool(keccak256("user", "localNode", _localNode)));
257         require(_totalLendingAmount > 0);
258         require(_lendingDays > 0);
259         require(_annualInterest > 0 && _annualInterest < 100);
260         version = 1;
261         fundingStartTime = _fundingStartTime;
262         fundingEndTime = _fundingEndTime;
263         localNode = _localNode;
264         ethicHubTeam = _ethicHubTeam;
265         borrower = _borrower;
266         annualInterest = _annualInterest;
267         totalLendingAmount = _totalLendingAmount;
268         lendingDays = _lendingDays;
269         state = LendingState.Uninitialized;
270     }
271 
272     function saveInitialParametersToStorage(uint256 _maxDelayDays, uint256 _tier, uint256 _communityMembers, address _community) external onlyOwnerOrLocalNode {
273         require(_maxDelayDays != 0);
274         require(state == LendingState.Uninitialized);
275         require(_tier > 0);
276         require(_communityMembers >= 20);
277         require(ethicHubStorage.getBool(keccak256("user", "community", _community)));
278         ethicHubStorage.setUint(keccak256("lending.maxDelayDays", this), _maxDelayDays);
279         ethicHubStorage.setAddress(keccak256("lending.community", this), _community);
280         ethicHubStorage.setAddress(keccak256("lending.localNode", this), localNode);
281         ethicHubStorage.setUint(keccak256("lending.tier", this), _tier);
282         ethicHubStorage.setUint(keccak256("lending.communityMembers", this), _communityMembers);
283         tier = _tier;
284         state = LendingState.AcceptingContributions;
285         emit StateChange(uint(state));
286 
287     }
288 
289     function() public payable whenNotPaused {
290         require(state == LendingState.AwaitingReturn || state == LendingState.AcceptingContributions || state == LendingState.ExchangingToFiat);
291         if(state == LendingState.AwaitingReturn) {
292             returnBorrowedEth();
293         } else if (state == LendingState.ExchangingToFiat) {
294             // borrower can send surplus eth back to contract to avoid paying interest
295             sendBackSurplusEth();
296         } else {
297             contributeWithAddress(msg.sender);
298         }
299     }
300 
301     function sendBackSurplusEth() internal {
302         require(state == LendingState.ExchangingToFiat);
303         surplusEth = surplusEth.add(msg.value);
304         require(surplusEth <= totalLendingAmount);
305         emit onSurplusSent(msg.value);
306     }
307 
308     /**
309      * After the contribution period ends unsuccesfully, this method enables the contributor
310      *  to retrieve their contribution
311      */
312     function declareProjectNotFunded() external onlyOwnerOrLocalNode {
313         require(totalContributed < totalLendingAmount);
314         require(state == LendingState.AcceptingContributions);
315         require(now > fundingEndTime);
316         state = LendingState.ProjectNotFunded;
317         emit StateChange(uint(state));
318     }
319 
320     function declareProjectDefault() external onlyOwnerOrLocalNode {
321         require(state == LendingState.AwaitingReturn);
322         uint maxDelayDays = getMaxDelayDays();
323         require(getDelayDays(now) >= maxDelayDays);
324         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
325         require(reputation != address(0));
326         ethicHubStorage.setUint(keccak256("lending.delayDays", this), maxDelayDays);
327         reputation.burnReputation(maxDelayDays);
328         state = LendingState.Default;
329         emit StateChange(uint(state));
330     }
331 
332     function setBorrowerReturnEthPerFiatRate(uint256 _borrowerReturnEthPerFiatRate) external onlyOwnerOrLocalNode {
333         require(state == LendingState.AwaitingReturn);
334         borrowerReturnEthPerFiatRate = _borrowerReturnEthPerFiatRate;
335         emit onReturnRateSet(borrowerReturnEthPerFiatRate);
336     }
337 
338     function finishInitialExchangingPeriod(uint256 _initialEthPerFiatRate) external onlyOwnerOrLocalNode {
339         require(capReached == true);
340         require(state == LendingState.ExchangingToFiat);
341         initialEthPerFiatRate = _initialEthPerFiatRate;
342         if (surplusEth > 0) {
343             totalLendingAmount = totalLendingAmount.sub(surplusEth);
344         }
345         totalLendingFiatAmount = totalLendingAmount.mul(initialEthPerFiatRate);
346         emit onInitalRateSet(initialEthPerFiatRate);
347         state = LendingState.AwaitingReturn;
348         emit StateChange(uint(state));
349     }
350 
351     /**
352      * Method to reclaim contribution after project is declared default (% of partial funds)
353      * @param  beneficiary the contributor
354      *
355      */
356     function reclaimContributionDefault(address beneficiary) external {
357         require(state == LendingState.Default);
358         require(!investors[beneficiary].isCompensated);
359         // contribution = contribution * partial_funds / total_funds
360         uint256 contribution = checkInvestorReturns(beneficiary);
361         require(contribution > 0);
362         investors[beneficiary].isCompensated = true;
363         beneficiary.transfer(contribution);
364     }
365 
366     /**
367      * Method to reclaim contribution after a project is declared as not funded
368      * @param  beneficiary the contributor
369      *
370      */
371     function reclaimContribution(address beneficiary) external {
372         require(state == LendingState.ProjectNotFunded);
373         require(!investors[beneficiary].isCompensated);
374         uint256 contribution = investors[beneficiary].amount;
375         require(contribution > 0);
376         investors[beneficiary].isCompensated = true;
377         beneficiary.transfer(contribution);
378     }
379 
380     function reclaimSurplusEth(address beneficiary) external {
381         require(surplusEth > 0);
382         // only can be reclaimed after cap reduced
383         require(state != LendingState.ExchangingToFiat);
384         require(!investors[beneficiary].surplusEthReclaimed);
385         uint256 surplusContribution = investors[beneficiary].amount.mul(surplusEth).div(surplusEth.add(totalLendingAmount));
386         require(surplusContribution > 0);
387         investors[beneficiary].surplusEthReclaimed = true;
388         emit onSurplusReclaimed(beneficiary, surplusContribution);
389         beneficiary.transfer(surplusContribution);
390     }
391 
392     function reclaimContributionWithInterest(address beneficiary) external {
393         require(state == LendingState.ContributionReturned);
394         require(!investors[beneficiary].isCompensated);
395         uint256 contribution = checkInvestorReturns(beneficiary);
396         require(contribution > 0);
397         investors[beneficiary].isCompensated = true;
398         beneficiary.transfer(contribution);
399     }
400 
401     function reclaimLocalNodeFee() external {
402         require(state == LendingState.ContributionReturned);
403         require(localNodeFeeReclaimed == false);
404         uint256 fee = totalLendingFiatAmount.mul(localNodeFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
405         require(fee > 0);
406         localNodeFeeReclaimed = true;
407         localNode.transfer(fee);
408     }
409 
410     function reclaimEthicHubTeamFee() external {
411         require(state == LendingState.ContributionReturned);
412         require(ethicHubTeamFeeReclaimed == false);
413         uint256 fee = totalLendingFiatAmount.mul(ethichubFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
414         require(fee > 0);
415         ethicHubTeamFeeReclaimed = true;
416         ethicHubTeam.transfer(fee);
417     }
418 
419     function returnBorrowedEth() internal {
420         require(state == LendingState.AwaitingReturn);
421         require(borrowerReturnEthPerFiatRate > 0);
422         bool projectRepayed = false;
423         uint excessRepayment = 0;
424         uint newReturnedEth = 0;
425         emit onReturnAmount(msg.sender, msg.value);
426         (newReturnedEth, projectRepayed, excessRepayment) = calculatePaymentGoal(
427                                                                                     borrowerReturnAmount(),
428                                                                                     returnedEth,
429                                                                                     msg.value);
430         returnedEth = newReturnedEth;
431         if (projectRepayed == true) {
432             state = LendingState.ContributionReturned;
433             emit StateChange(uint(state));
434             updateReputation();
435         }
436         if (excessRepayment > 0) {
437             msg.sender.transfer(excessRepayment);
438         }
439     }
440 
441     // @notice Function to participate in contribution period
442     //  Amounts from the same address should be added up
443     //  If cap is reached, end time should be modified
444     //  Funds should be transferred into multisig wallet
445     // @param contributor Address
446     function contributeWithAddress(address contributor) internal checkProfileRegistered('investor') whenNotPaused {
447         require(state == LendingState.AcceptingContributions);
448         require(msg.value >= minContribAmount);
449         require(isContribPeriodRunning());
450 
451         uint oldTotalContributed = totalContributed;
452         uint newTotalContributed = 0;
453         uint excessContribValue = 0;
454         (newTotalContributed, capReached, excessContribValue) = calculatePaymentGoal(
455                                                                                     totalLendingAmount,
456                                                                                     oldTotalContributed,
457                                                                                     msg.value);
458         totalContributed = newTotalContributed;
459         if (capReached) {
460             fundingEndTime = now;
461             emit onCapReached(fundingEndTime);
462         }
463         if (investors[contributor].amount == 0) {
464             investorCount = investorCount.add(1);
465         }
466         investors[contributor].amount = investors[contributor].amount.add(msg.value);
467 
468         if (excessContribValue > 0) {
469             msg.sender.transfer(excessContribValue);
470         }
471         emit onContribution(newTotalContributed, contributor, msg.value, investorCount);
472     }
473 
474     function calculatePaymentGoal(uint goal, uint oldTotal, uint contribValue) internal pure returns(uint, bool, uint) {
475         uint newTotal = oldTotal.add(contribValue);
476         bool goalReached = false;
477         uint excess = 0;
478         if (newTotal >= goal &&
479             oldTotal < goal) {
480             goalReached = true;
481             excess = newTotal.sub(goal);
482             contribValue = contribValue.sub(excess);
483             newTotal = goal;
484         }
485         return (newTotal, goalReached, excess);
486     }
487 
488     function sendFundsToBorrower() external onlyOwnerOrLocalNode {
489       //Waiting for Exchange
490         require(state == LendingState.AcceptingContributions);
491         require(capReached);
492         state = LendingState.ExchangingToFiat;
493         emit StateChange(uint(state));
494         borrower.transfer(totalContributed);
495     }
496 
497     function updateReputation() internal {
498         uint delayDays = getDelayDays(now);
499         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
500         require(reputation != address(0));
501         if (delayDays > 0) {
502             ethicHubStorage.setUint(keccak256("lending.delayDays", this), delayDays);
503             reputation.burnReputation(delayDays);
504         } else {
505             uint completedProjectsByTier  = ethicHubStorage.getUint(keccak256("community.completedProjectsByTier", this, tier)).add(1);
506             ethicHubStorage.setUint(keccak256("community.completedProjectsByTier", this, tier), completedProjectsByTier);
507             reputation.incrementReputation(completedProjectsByTier);
508         }
509     }
510 
511     function getDelayDays(uint date) public view returns(uint) {
512         uint lendingDaysSeconds = lendingDays * 1 days;
513         uint defaultTime = fundingEndTime.add(lendingDaysSeconds);
514         if (date < defaultTime) {
515             return 0;
516         } else {
517             return date.sub(defaultTime).div(60).div(60).div(24);
518         }
519     }
520 
521     // lendingInterestRate with 2 decimal
522     // 15 * (lending days)/ 365 + 4% local node fee + 3% LendingDev fee
523     function lendingInterestRatePercentage() public view returns(uint256){
524         return annualInterest.mul(interestBaseUint).mul(lendingDays.add(getDelayDays(now))).div(365).add(localNodeFee.mul(interestBaseUint)).add(ethichubFee.mul(interestBaseUint)).add(interestBasePercent);
525     }
526 
527     // lendingInterestRate with 2 decimal
528     function investorInterest() public view returns(uint256){
529         return annualInterest.mul(interestBaseUint).mul(lendingDays.add(getDelayDays(now))).div(365).add(interestBasePercent);
530     }
531 
532     function borrowerReturnFiatAmount() public view returns(uint256) {
533         return totalLendingFiatAmount.mul(lendingInterestRatePercentage()).div(interestBasePercent);
534     }
535 
536     function borrowerReturnAmount() public view returns(uint256) {
537         return borrowerReturnFiatAmount().div(borrowerReturnEthPerFiatRate);
538     }
539 
540     function isContribPeriodRunning() public view returns(bool) {
541         return fundingStartTime <= now && fundingEndTime > now && !capReached;
542     }
543 
544     function checkInvestorContribution(address investor) public view returns(uint256){
545         return investors[investor].amount;
546     }
547 
548     function checkInvestorReturns(address investor) public view returns(uint256) {
549         uint256 investorAmount = 0;
550         if (state == LendingState.ContributionReturned) {
551             investorAmount = investors[investor].amount;
552             if (surplusEth > 0){
553                 investorAmount  = investors[investor].amount.mul(totalLendingAmount).div(totalContributed);
554             }
555             return investorAmount.mul(initialEthPerFiatRate).mul(investorInterest()).div(borrowerReturnEthPerFiatRate).div(interestBasePercent);
556         } else if (state == LendingState.Default){
557             investorAmount = investors[investor].amount;
558             // contribution = contribution * partial_funds / total_funds
559             return investorAmount.mul(returnedEth).div(totalLendingAmount);
560         } else {
561             return 0;
562         }
563     }
564 
565     function getMaxDelayDays() public view returns(uint256){
566         return ethicHubStorage.getUint(keccak256("lending.maxDelayDays", this));
567     }
568 }
569 
570 contract EthicHubStorageInterface {
571 
572     //modifier for access in sets and deletes
573     modifier onlyEthicHubContracts() {_;}
574 
575     // Setters
576     function setAddress(bytes32 _key, address _value) external;
577     function setUint(bytes32 _key, uint _value) external;
578     function setString(bytes32 _key, string _value) external;
579     function setBytes(bytes32 _key, bytes _value) external;
580     function setBool(bytes32 _key, bool _value) external;
581     function setInt(bytes32 _key, int _value) external;
582     // Deleters
583     function deleteAddress(bytes32 _key) external;
584     function deleteUint(bytes32 _key) external;
585     function deleteString(bytes32 _key) external;
586     function deleteBytes(bytes32 _key) external;
587     function deleteBool(bytes32 _key) external;
588     function deleteInt(bytes32 _key) external;
589 
590     // Getters
591     function getAddress(bytes32 _key) external view returns (address);
592     function getUint(bytes32 _key) external view returns (uint);
593     function getString(bytes32 _key) external view returns (string);
594     function getBytes(bytes32 _key) external view returns (bytes);
595     function getBool(bytes32 _key) external view returns (bool);
596     function getInt(bytes32 _key) external view returns (int);
597 }