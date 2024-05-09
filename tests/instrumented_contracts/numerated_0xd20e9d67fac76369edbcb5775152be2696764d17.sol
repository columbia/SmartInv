1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    */
33   function renounceOwnership() public onlyOwner {
34     emit OwnershipRenounced(owner);
35     owner = address(0);
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param _newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address _newOwner) public onlyOwner {
43     _transferOwnership(_newOwner);
44   }
45 
46   /**
47    * @dev Transfers control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function _transferOwnership(address _newOwner) internal {
51     require(_newOwner != address(0));
52     emit OwnershipTransferred(owner, _newOwner);
53     owner = _newOwner;
54   }
55 }
56 
57 contract EthicHubStorageInterface {
58 
59     //modifier for access in sets and deletes
60     modifier onlyEthicHubContracts() {_;}
61 
62     // Setters
63     function setAddress(bytes32 _key, address _value) external;
64     function setUint(bytes32 _key, uint _value) external;
65     function setString(bytes32 _key, string _value) external;
66     function setBytes(bytes32 _key, bytes _value) external;
67     function setBool(bytes32 _key, bool _value) external;
68     function setInt(bytes32 _key, int _value) external;
69     // Deleters
70     function deleteAddress(bytes32 _key) external;
71     function deleteUint(bytes32 _key) external;
72     function deleteString(bytes32 _key) external;
73     function deleteBytes(bytes32 _key) external;
74     function deleteBool(bytes32 _key) external;
75     function deleteInt(bytes32 _key) external;
76 
77     // Getters
78     function getAddress(bytes32 _key) external view returns (address);
79     function getUint(bytes32 _key) external view returns (uint);
80     function getString(bytes32 _key) external view returns (string);
81     function getBytes(bytes32 _key) external view returns (bytes);
82     function getBool(bytes32 _key) external view returns (bool);
83     function getInt(bytes32 _key) external view returns (int);
84 }
85 
86 contract EthicHubBase {
87 
88     uint8 public version;
89 
90     EthicHubStorageInterface public ethicHubStorage = EthicHubStorageInterface(0);
91 
92     constructor(address _storageAddress) public {
93         require(_storageAddress != address(0));
94         ethicHubStorage = EthicHubStorageInterface(_storageAddress);
95     }
96 
97 }
98 
99 library SafeMath {
100 
101   /**
102   * @dev Multiplies two numbers, throws on overflow.
103   */
104   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
105     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
106     // benefit is lost if 'b' is also tested.
107     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
108     if (a == 0) {
109       return 0;
110     }
111 
112     c = a * b;
113     assert(c / a == b);
114     return c;
115   }
116 
117   /**
118   * @dev Integer division of two numbers, truncating the quotient.
119   */
120   function div(uint256 a, uint256 b) internal pure returns (uint256) {
121     // assert(b > 0); // Solidity automatically throws when dividing by 0
122     // uint256 c = a / b;
123     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124     return a / b;
125   }
126 
127   /**
128   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
129   */
130   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131     assert(b <= a);
132     return a - b;
133   }
134 
135   /**
136   * @dev Adds two numbers, throws on overflow.
137   */
138   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
139     c = a + b;
140     assert(c >= a);
141     return c;
142   }
143 }
144 
145 contract EthicHubReputationInterface {
146     modifier onlyUsersContract(){_;}
147     modifier onlyLendingContract(){_;}
148     function burnReputation(uint delayDays)  external;
149     function incrementReputation(uint completedProjectsByTier)  external;
150     function initLocalNodeReputation(address localNode)  external;
151     function initCommunityReputation(address community)  external;
152     function getCommunityReputation(address target) public view returns(uint256);
153     function getLocalNodeReputation(address target) public view returns(uint256);
154 }
155 
156 contract Pausable is Ownable {
157   event Pause();
158   event Unpause();
159 
160   bool public paused = false;
161 
162 
163   /**
164    * @dev Modifier to make a function callable only when the contract is not paused.
165    */
166   modifier whenNotPaused() {
167     require(!paused);
168     _;
169   }
170 
171   /**
172    * @dev Modifier to make a function callable only when the contract is paused.
173    */
174   modifier whenPaused() {
175     require(paused);
176     _;
177   }
178 
179   /**
180    * @dev called by the owner to pause, triggers stopped state
181    */
182   function pause() onlyOwner whenNotPaused public {
183     paused = true;
184     emit Pause();
185   }
186 
187   /**
188    * @dev called by the owner to unpause, returns to normal state
189    */
190   function unpause() onlyOwner whenPaused public {
191     paused = false;
192     emit Unpause();
193   }
194 }
195 
196 contract EthicHubLending is EthicHubBase, Ownable, Pausable {
197     using SafeMath for uint256;
198     uint256 public minContribAmount = 0.1 ether;                          // 0.01 ether
199     enum LendingState {
200         Uninitialized,
201         AcceptingContributions,
202         ExchangingToFiat,
203         AwaitingReturn,
204         ProjectNotFunded,
205         ContributionReturned,
206         Default
207     }
208     mapping(address => Investor) public investors;
209     uint256 public investorCount;
210     uint256 public fundingStartTime;                                     // Start time of contribution period in UNIX time
211     uint256 public fundingEndTime;                                       // End time of contribution period in UNIX time
212     uint256 public totalContributed;
213     bool public capReached;
214     LendingState public state;
215     uint256 public annualInterest;
216     uint256 public totalLendingAmount;
217     uint256 public lendingDays;
218     uint256 public initialEthPerFiatRate;
219     uint256 public totalLendingFiatAmount;
220     address public borrower;
221     address public localNode;
222     address public ethicHubTeam;
223     uint256 public borrowerReturnDate;
224     uint256 public borrowerReturnEthPerFiatRate;
225     uint256 public ethichubFee;
226     uint256 public localNodeFee;
227     uint256 public tier;
228     // interest rate is using base uint 100 and 100% 10000, this means 1% is 100
229     // this guarantee we can have a 2 decimal presicion in our calculation
230     uint256 public constant interestBaseUint = 100;
231     uint256 public constant interestBasePercent = 10000;
232     bool public localNodeFeeReclaimed;
233     bool public ethicHubTeamFeeReclaimed;
234     uint256 public surplusEth;
235     uint256 public returnedEth;
236 
237     struct Investor {
238         uint256 amount;
239         bool isCompensated;
240         bool surplusEthReclaimed;
241     }
242 
243     // events
244     event onCapReached(uint endTime);
245     event onContribution(uint totalContributed, address indexed investor, uint amount, uint investorsCount);
246     event onCompensated(address indexed contributor, uint amount);
247     event onSurplusSent(uint256 amount);
248     event onSurplusReclaimed(address indexed contributor, uint amount);
249     event StateChange(uint state);
250     event onInitalRateSet(uint rate);
251     event onReturnRateSet(uint rate);
252     event onReturnAmount(address indexed borrower, uint amount);
253     event onBorrowerChanged(address indexed newBorrower);
254 
255     // modifiers
256     modifier checkProfileRegistered(string profile) {
257         bool isRegistered = ethicHubStorage.getBool(keccak256("user", profile, msg.sender));
258         require(isRegistered);
259         _;
260     }
261 
262     modifier checkIfArbiter() {
263         address arbiter = ethicHubStorage.getAddress(keccak256("arbiter", this));
264         require(arbiter == msg.sender);
265         _;
266     }
267 
268     modifier onlyOwnerOrLocalNode() {
269         require(localNode == msg.sender || owner == msg.sender);
270         _;
271     }
272 
273     constructor(
274         uint256 _fundingStartTime,
275         uint256 _fundingEndTime,
276         address _borrower,
277         uint256 _annualInterest,
278         uint256 _totalLendingAmount,
279         uint256 _lendingDays,
280         address _storageAddress,
281         address _localNode,
282         address _ethicHubTeam,
283         uint256 _ethichubFee, 
284         uint256 _localNodeFee 
285         )
286         EthicHubBase(_storageAddress)
287         public {
288         require(_fundingStartTime > now);
289         require(_fundingEndTime > fundingStartTime);
290         require(_borrower != address(0));
291         require(ethicHubStorage.getBool(keccak256("user", "representative", _borrower)));
292         require(_localNode != address(0));
293         require(_ethicHubTeam != address(0));
294         require(ethicHubStorage.getBool(keccak256("user", "localNode", _localNode)));
295         require(_totalLendingAmount > 0);
296         require(_lendingDays > 0);
297         require(_annualInterest > 0 && _annualInterest < 100);
298         version = 2;
299         fundingStartTime = _fundingStartTime;
300         fundingEndTime = _fundingEndTime;
301         localNode = _localNode;
302         ethicHubTeam = _ethicHubTeam;
303         borrower = _borrower;
304         annualInterest = _annualInterest;
305         totalLendingAmount = _totalLendingAmount;
306         lendingDays = _lendingDays;
307         ethichubFee = _ethichubFee;
308         localNodeFee = _localNodeFee;
309         state = LendingState.Uninitialized;
310     }
311 
312     function saveInitialParametersToStorage(uint256 _maxDelayDays, uint256 _tier, uint256 _communityMembers, address _community) external onlyOwnerOrLocalNode {
313         require(_maxDelayDays != 0);
314         require(state == LendingState.Uninitialized);
315         require(_tier > 0);
316         require(_communityMembers > 0);
317         require(ethicHubStorage.getBool(keccak256("user", "community", _community)));
318         ethicHubStorage.setUint(keccak256("lending.maxDelayDays", this), _maxDelayDays);
319         ethicHubStorage.setAddress(keccak256("lending.community", this), _community);
320         ethicHubStorage.setAddress(keccak256("lending.localNode", this), localNode);
321         ethicHubStorage.setUint(keccak256("lending.tier", this), _tier);
322         ethicHubStorage.setUint(keccak256("lending.communityMembers", this), _communityMembers);
323         tier = _tier;
324         state = LendingState.AcceptingContributions;
325         emit StateChange(uint(state));
326 
327     }
328 
329     function setBorrower(address _borrower) external checkIfArbiter {
330         require(_borrower != address(0));
331         require(ethicHubStorage.getBool(keccak256("user", "representative", _borrower)));
332         borrower = _borrower;
333         emit onBorrowerChanged(borrower);
334     }
335 
336     function() public payable whenNotPaused {
337         require(state == LendingState.AwaitingReturn || state == LendingState.AcceptingContributions || state == LendingState.ExchangingToFiat);
338         if(state == LendingState.AwaitingReturn) {
339             returnBorrowedEth();
340         } else if (state == LendingState.ExchangingToFiat) {
341             // borrower can send surplus eth back to contract to avoid paying interest
342             sendBackSurplusEth();
343         } else {
344             contributeWithAddress(msg.sender);
345         }
346     }
347 
348     function sendBackSurplusEth() internal {
349         require(state == LendingState.ExchangingToFiat);
350         require(msg.sender == borrower);
351         surplusEth = surplusEth.add(msg.value);
352         require(surplusEth <= totalLendingAmount);
353         emit onSurplusSent(msg.value);
354     }
355 
356     /**
357      * After the contribution period ends unsuccesfully, this method enables the contributor
358      *  to retrieve their contribution
359      */
360     function declareProjectNotFunded() external onlyOwnerOrLocalNode {
361         require(totalContributed < totalLendingAmount);
362         require(state == LendingState.AcceptingContributions);
363         require(now > fundingEndTime);
364         state = LendingState.ProjectNotFunded;
365         emit StateChange(uint(state));
366     }
367 
368     function declareProjectDefault() external onlyOwnerOrLocalNode {
369         require(state == LendingState.AwaitingReturn);
370         uint maxDelayDays = getMaxDelayDays();
371         require(getDelayDays(now) >= maxDelayDays);
372         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
373         require(reputation != address(0));
374         ethicHubStorage.setUint(keccak256("lending.delayDays", this), maxDelayDays);
375         reputation.burnReputation(maxDelayDays);
376         state = LendingState.Default;
377         emit StateChange(uint(state));
378     }
379 
380     function setBorrowerReturnEthPerFiatRate(uint256 _borrowerReturnEthPerFiatRate) external onlyOwnerOrLocalNode {
381         require(state == LendingState.AwaitingReturn);
382         borrowerReturnEthPerFiatRate = _borrowerReturnEthPerFiatRate;
383         emit onReturnRateSet(borrowerReturnEthPerFiatRate);
384     }
385 
386     function finishInitialExchangingPeriod(uint256 _initialEthPerFiatRate) external onlyOwnerOrLocalNode {
387         require(capReached == true);
388         require(state == LendingState.ExchangingToFiat);
389         initialEthPerFiatRate = _initialEthPerFiatRate;
390         if (surplusEth > 0) {
391             totalLendingAmount = totalLendingAmount.sub(surplusEth);
392         }
393         totalLendingFiatAmount = totalLendingAmount.mul(initialEthPerFiatRate);
394         emit onInitalRateSet(initialEthPerFiatRate);
395         state = LendingState.AwaitingReturn;
396         emit StateChange(uint(state));
397     }
398 
399     /**
400      * Method to reclaim contribution after project is declared default (% of partial funds)
401      * @param  beneficiary the contributor
402      *
403      */
404     function reclaimContributionDefault(address beneficiary) external {
405         require(state == LendingState.Default);
406         require(!investors[beneficiary].isCompensated);
407         // contribution = contribution * partial_funds / total_funds
408         uint256 contribution = checkInvestorReturns(beneficiary);
409         require(contribution > 0);
410         investors[beneficiary].isCompensated = true;
411         beneficiary.transfer(contribution);
412     }
413 
414     /**
415      * Method to reclaim contribution after a project is declared as not funded
416      * @param  beneficiary the contributor
417      *
418      */
419     function reclaimContribution(address beneficiary) external {
420         require(state == LendingState.ProjectNotFunded);
421         require(!investors[beneficiary].isCompensated);
422         uint256 contribution = investors[beneficiary].amount;
423         require(contribution > 0);
424         investors[beneficiary].isCompensated = true;
425         beneficiary.transfer(contribution);
426     }
427 
428     function reclaimSurplusEth(address beneficiary) external {
429         require(surplusEth > 0);
430         // only can be reclaimed after cap reduced
431         require(state != LendingState.ExchangingToFiat);
432         require(!investors[beneficiary].surplusEthReclaimed);
433         uint256 surplusContribution = investors[beneficiary].amount.mul(surplusEth).div(surplusEth.add(totalLendingAmount));
434         require(surplusContribution > 0);
435         investors[beneficiary].surplusEthReclaimed = true;
436         emit onSurplusReclaimed(beneficiary, surplusContribution);
437         beneficiary.transfer(surplusContribution);
438     }
439 
440     function reclaimContributionWithInterest(address beneficiary) external {
441         require(state == LendingState.ContributionReturned);
442         require(!investors[beneficiary].isCompensated);
443         uint256 contribution = checkInvestorReturns(beneficiary);
444         require(contribution > 0);
445         investors[beneficiary].isCompensated = true;
446         beneficiary.transfer(contribution);
447     }
448 
449     function reclaimLocalNodeFee() external {
450         require(state == LendingState.ContributionReturned);
451         require(localNodeFeeReclaimed == false);
452         uint256 fee = totalLendingFiatAmount.mul(localNodeFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
453         require(fee > 0);
454         localNodeFeeReclaimed = true;
455         localNode.transfer(fee);
456     }
457 
458     function reclaimEthicHubTeamFee() external {
459         require(state == LendingState.ContributionReturned);
460         require(ethicHubTeamFeeReclaimed == false);
461         uint256 fee = totalLendingFiatAmount.mul(ethichubFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
462         require(fee > 0);
463         ethicHubTeamFeeReclaimed = true;
464         ethicHubTeam.transfer(fee);
465     }
466 
467     function returnBorrowedEth() internal {
468         require(state == LendingState.AwaitingReturn);
469         require(msg.sender == borrower);
470         require(borrowerReturnEthPerFiatRate > 0);
471         bool projectRepayed = false;
472         uint excessRepayment = 0;
473         uint newReturnedEth = 0;
474         emit onReturnAmount(msg.sender, msg.value);
475         (newReturnedEth, projectRepayed, excessRepayment) = calculatePaymentGoal(
476                                                                                     borrowerReturnAmount(),
477                                                                                     returnedEth,
478                                                                                     msg.value);
479         returnedEth = newReturnedEth;
480         if (projectRepayed == true) {
481             state = LendingState.ContributionReturned;
482             emit StateChange(uint(state));
483             updateReputation();
484         }
485         if (excessRepayment > 0) {
486             msg.sender.transfer(excessRepayment);
487         }
488     }
489 
490     // @notice Function to participate in contribution period
491     //  Amounts from the same address should be added up
492     //  If cap is reached, end time should be modified
493     //  Funds should be transferred into multisig wallet
494     // @param contributor Address
495     function contributeWithAddress(address contributor) internal checkProfileRegistered('investor') whenNotPaused {
496         require(state == LendingState.AcceptingContributions);
497         require(msg.value >= minContribAmount);
498         require(isContribPeriodRunning());
499 
500         uint oldTotalContributed = totalContributed;
501         uint newTotalContributed = 0;
502         uint excessContribValue = 0;
503         (newTotalContributed, capReached, excessContribValue) = calculatePaymentGoal(
504                                                                                     totalLendingAmount,
505                                                                                     oldTotalContributed,
506                                                                                     msg.value);
507         totalContributed = newTotalContributed;
508         if (capReached) {
509             fundingEndTime = now;
510             emit onCapReached(fundingEndTime);
511         }
512         if (investors[contributor].amount == 0) {
513             investorCount = investorCount.add(1);
514         }
515         if (excessContribValue > 0) {
516             msg.sender.transfer(excessContribValue);
517             investors[contributor].amount = investors[contributor].amount.add(msg.value).sub(excessContribValue);
518             emit onContribution(newTotalContributed, contributor, msg.value.sub(excessContribValue), investorCount);
519         } else {
520             investors[contributor].amount = investors[contributor].amount.add(msg.value);
521             emit onContribution(newTotalContributed, contributor, msg.value, investorCount);
522         }
523     }
524 
525     function calculatePaymentGoal(uint goal, uint oldTotal, uint contribValue) internal pure returns(uint, bool, uint) {
526         uint newTotal = oldTotal.add(contribValue);
527         bool goalReached = false;
528         uint excess = 0;
529         if (newTotal >= goal && oldTotal < goal) {
530             goalReached = true;
531             excess = newTotal.sub(goal);
532             contribValue = contribValue.sub(excess);
533             newTotal = goal;
534         }
535         return (newTotal, goalReached, excess);
536     }
537 
538     function sendFundsToBorrower() external onlyOwnerOrLocalNode {
539       //Waiting for Exchange
540         require(state == LendingState.AcceptingContributions);
541         require(capReached);
542         state = LendingState.ExchangingToFiat;
543         emit StateChange(uint(state));
544         borrower.transfer(totalContributed);
545     }
546 
547     function updateReputation() internal {
548         uint delayDays = getDelayDays(now);
549         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
550         require(reputation != address(0));
551         if (delayDays > 0) {
552             ethicHubStorage.setUint(keccak256("lending.delayDays", this), delayDays);
553             reputation.burnReputation(delayDays);
554         } else {
555             uint completedProjectsByTier  = ethicHubStorage.getUint(keccak256("community.completedProjectsByTier", this, tier)).add(1);
556             ethicHubStorage.setUint(keccak256("community.completedProjectsByTier", this, tier), completedProjectsByTier);
557             reputation.incrementReputation(completedProjectsByTier);
558         }
559     }
560 
561     function getDelayDays(uint date) public view returns(uint) {
562         uint lendingDaysSeconds = lendingDays * 1 days;
563         uint defaultTime = fundingEndTime.add(lendingDaysSeconds);
564         if (date < defaultTime) {
565             return 0;
566         } else {
567             return date.sub(defaultTime).div(60).div(60).div(24);
568         }
569     }
570 
571     // lendingInterestRate with 2 decimal
572     // 15 * (lending days)/ 365 + 4% local node fee + 3% LendingDev fee
573     function lendingInterestRatePercentage() public view returns(uint256){
574         return annualInterest.mul(interestBaseUint).mul(lendingDays.add(getDelayDays(now))).div(365).add(localNodeFee.mul(interestBaseUint)).add(ethichubFee.mul(interestBaseUint)).add(interestBasePercent);
575     }
576 
577     // lendingInterestRate with 2 decimal
578     function investorInterest() public view returns(uint256){
579         return annualInterest.mul(interestBaseUint).mul(lendingDays.add(getDelayDays(now))).div(365).add(interestBasePercent);
580     }
581 
582     function borrowerReturnFiatAmount() public view returns(uint256) {
583         return totalLendingFiatAmount.mul(lendingInterestRatePercentage()).div(interestBasePercent);
584     }
585 
586     function borrowerReturnAmount() public view returns(uint256) {
587         return borrowerReturnFiatAmount().div(borrowerReturnEthPerFiatRate);
588     }
589 
590     function isContribPeriodRunning() public view returns(bool) {
591         return fundingStartTime <= now && fundingEndTime > now && !capReached;
592     }
593 
594     function checkInvestorContribution(address investor) public view returns(uint256){
595         return investors[investor].amount;
596     }
597 
598     function checkInvestorReturns(address investor) public view returns(uint256) {
599         uint256 investorAmount = 0;
600         if (state == LendingState.ContributionReturned) {
601             investorAmount = investors[investor].amount;
602             if (surplusEth > 0){
603                 investorAmount  = investors[investor].amount.mul(totalLendingAmount).div(totalContributed);
604             }
605             return investorAmount.mul(initialEthPerFiatRate).mul(investorInterest()).div(borrowerReturnEthPerFiatRate).div(interestBasePercent);
606         } else if (state == LendingState.Default){
607             investorAmount = investors[investor].amount;
608             // contribution = contribution * partial_funds / total_funds
609             return investorAmount.mul(returnedEth).div(totalLendingAmount);
610         } else {
611             return 0;
612         }
613     }
614 
615     function getMaxDelayDays() public view returns(uint256){
616         return ethicHubStorage.getUint(keccak256("lending.maxDelayDays", this));
617     }
618 
619     function getUserContributionReclaimStatus(address userAddress) public view returns(bool isCompensated, bool surplusEthReclaimed){
620         isCompensated = investors[userAddress].isCompensated;
621         surplusEthReclaimed = investors[userAddress].surplusEthReclaimed;
622     }
623 }