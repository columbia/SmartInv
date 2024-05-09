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
49 contract EthicHubReputationInterface {
50     modifier onlyUsersContract(){_;}
51     modifier onlyLendingContract(){_;}
52     function burnReputation(uint delayDays)  external;
53     function incrementReputation(uint completedProjectsByTier)  external;
54     function initLocalNodeReputation(address localNode)  external;
55     function initCommunityReputation(address community)  external;
56     function getCommunityReputation(address target) public view returns(uint256);
57     function getLocalNodeReputation(address target) public view returns(uint256);
58 }
59 
60 contract EthicHubStorageInterface {
61 
62     //modifier for access in sets and deletes
63     modifier onlyEthicHubContracts() {_;}
64 
65     // Setters
66     function setAddress(bytes32 _key, address _value) external;
67     function setUint(bytes32 _key, uint _value) external;
68     function setString(bytes32 _key, string _value) external;
69     function setBytes(bytes32 _key, bytes _value) external;
70     function setBool(bytes32 _key, bool _value) external;
71     function setInt(bytes32 _key, int _value) external;
72     // Deleters
73     function deleteAddress(bytes32 _key) external;
74     function deleteUint(bytes32 _key) external;
75     function deleteString(bytes32 _key) external;
76     function deleteBytes(bytes32 _key) external;
77     function deleteBool(bytes32 _key) external;
78     function deleteInt(bytes32 _key) external;
79 
80     // Getters
81     function getAddress(bytes32 _key) external view returns (address);
82     function getUint(bytes32 _key) external view returns (uint);
83     function getString(bytes32 _key) external view returns (string);
84     function getBytes(bytes32 _key) external view returns (bytes);
85     function getBool(bytes32 _key) external view returns (bool);
86     function getInt(bytes32 _key) external view returns (int);
87 }
88 
89 contract Ownable {
90   address public owner;
91 
92 
93   event OwnershipRenounced(address indexed previousOwner);
94   event OwnershipTransferred(
95     address indexed previousOwner,
96     address indexed newOwner
97   );
98 
99 
100   /**
101    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102    * account.
103    */
104   constructor() public {
105     owner = msg.sender;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116   /**
117    * @dev Allows the current owner to relinquish control of the contract.
118    */
119   function renounceOwnership() public onlyOwner {
120     emit OwnershipRenounced(owner);
121     owner = address(0);
122   }
123 
124   /**
125    * @dev Allows the current owner to transfer control of the contract to a newOwner.
126    * @param _newOwner The address to transfer ownership to.
127    */
128   function transferOwnership(address _newOwner) public onlyOwner {
129     _transferOwnership(_newOwner);
130   }
131 
132   /**
133    * @dev Transfers control of the contract to a newOwner.
134    * @param _newOwner The address to transfer ownership to.
135    */
136   function _transferOwnership(address _newOwner) internal {
137     require(_newOwner != address(0));
138     emit OwnershipTransferred(owner, _newOwner);
139     owner = _newOwner;
140   }
141 }
142 
143 contract Pausable is Ownable {
144   event Pause();
145   event Unpause();
146 
147   bool public paused = false;
148 
149 
150   /**
151    * @dev Modifier to make a function callable only when the contract is not paused.
152    */
153   modifier whenNotPaused() {
154     require(!paused);
155     _;
156   }
157 
158   /**
159    * @dev Modifier to make a function callable only when the contract is paused.
160    */
161   modifier whenPaused() {
162     require(paused);
163     _;
164   }
165 
166   /**
167    * @dev called by the owner to pause, triggers stopped state
168    */
169   function pause() onlyOwner whenNotPaused public {
170     paused = true;
171     emit Pause();
172   }
173 
174   /**
175    * @dev called by the owner to unpause, returns to normal state
176    */
177   function unpause() onlyOwner whenPaused public {
178     paused = false;
179     emit Unpause();
180   }
181 }
182 
183 contract EthicHubBase {
184 
185     uint8 public version;
186 
187     EthicHubStorageInterface public ethicHubStorage = EthicHubStorageInterface(0);
188 
189     constructor(address _storageAddress) public {
190         require(_storageAddress != address(0));
191         ethicHubStorage = EthicHubStorageInterface(_storageAddress);
192     }
193 
194 }
195 
196 contract EthicHubLending is EthicHubBase, Ownable, Pausable {
197     using SafeMath for uint256;
198     //uint256 public minContribAmount = 0.1 ether;                          // 0.1 ether
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
210     uint256 public reclaimedContributions;
211     uint256 public reclaimedSurpluses;
212     uint256 public fundingStartTime;                                     // Start time of contribution period in UNIX time
213     uint256 public fundingEndTime;                                       // End time of contribution period in UNIX time
214     uint256 public totalContributed;
215     bool public capReached;
216     LendingState public state;
217     uint256 public annualInterest;
218     uint256 public totalLendingAmount;
219     uint256 public lendingDays;
220     uint256 public initialEthPerFiatRate;
221     uint256 public totalLendingFiatAmount;
222     address public borrower;
223     address public localNode;
224     address public ethicHubTeam;
225     uint256 public borrowerReturnDate;
226     uint256 public borrowerReturnEthPerFiatRate;
227     uint256 public ethichubFee;
228     uint256 public localNodeFee;
229     uint256 public tier;
230     // interest rate is using base uint 100 and 100% 10000, this means 1% is 100
231     // this guarantee we can have a 2 decimal presicion in our calculation
232     uint256 public constant interestBaseUint = 100;
233     uint256 public constant interestBasePercent = 10000;
234     bool public localNodeFeeReclaimed;
235     bool public ethicHubTeamFeeReclaimed;
236     uint256 public surplusEth;
237     uint256 public returnedEth;
238 
239     struct Investor {
240         uint256 amount;
241         bool isCompensated;
242         bool surplusEthReclaimed;
243     }
244 
245     // events
246     event onCapReached(uint endTime);
247     event onContribution(uint totalContributed, address indexed investor, uint amount, uint investorsCount);
248     event onCompensated(address indexed contributor, uint amount);
249     event onSurplusSent(uint256 amount);
250     event onSurplusReclaimed(address indexed contributor, uint amount);
251     event StateChange(uint state);
252     event onInitalRateSet(uint rate);
253     event onReturnRateSet(uint rate);
254     event onReturnAmount(address indexed borrower, uint amount);
255     event onBorrowerChanged(address indexed newBorrower);
256     event onInvestorChanged(address indexed oldInvestor, address indexed newInvestor);
257 
258     // modifiers
259     modifier checkProfileRegistered(string profile) {
260         bool isRegistered = ethicHubStorage.getBool(keccak256("user", profile, msg.sender));
261         require(isRegistered);
262         _;
263     }
264 
265     modifier checkIfArbiter() {
266         address arbiter = ethicHubStorage.getAddress(keccak256("arbiter", this));
267         require(arbiter == msg.sender);
268         _;
269     }
270 
271     modifier onlyOwnerOrLocalNode() {
272         require(localNode == msg.sender || owner == msg.sender);
273         _;
274     }
275 
276     modifier onlyInvestorOrPaymentGateway() {
277         bool isInvestor = ethicHubStorage.getBool(keccak256("user", "investor", msg.sender));
278         bool isPaymentGateway = ethicHubStorage.getBool(keccak256("user", "paymentGateway", msg.sender));
279         require(isPaymentGateway || isInvestor);
280         _;
281     }
282 
283     constructor(
284         uint256 _fundingStartTime,
285         uint256 _fundingEndTime,
286         address _borrower,
287         uint256 _annualInterest,
288         uint256 _totalLendingAmount,
289         uint256 _lendingDays,
290         address _storageAddress,
291         address _localNode,
292         address _ethicHubTeam,
293         uint256 _ethichubFee,
294         uint256 _localNodeFee
295         )
296         EthicHubBase(_storageAddress)
297         public {
298         require(_fundingStartTime > now);
299         require(_fundingEndTime > fundingStartTime);
300         require(_borrower != address(0));
301         require(ethicHubStorage.getBool(keccak256("user", "representative", _borrower)));
302         require(_localNode != address(0));
303         require(_ethicHubTeam != address(0));
304         require(ethicHubStorage.getBool(keccak256("user", "localNode", _localNode)));
305         require(_totalLendingAmount > 0);
306         require(_lendingDays > 0);
307         require(_annualInterest > 0 && _annualInterest < 100);
308         version = 4;
309         reclaimedContributions = 0;
310         reclaimedSurpluses = 0;
311         fundingStartTime = _fundingStartTime;
312         fundingEndTime = _fundingEndTime;
313         localNode = _localNode;
314         ethicHubTeam = _ethicHubTeam;
315         borrower = _borrower;
316         annualInterest = _annualInterest;
317         totalLendingAmount = _totalLendingAmount;
318         lendingDays = _lendingDays;
319         ethichubFee = _ethichubFee;
320         localNodeFee = _localNodeFee;
321         state = LendingState.Uninitialized;
322     }
323 
324     function saveInitialParametersToStorage(uint256 _maxDelayDays, uint256 _tier, uint256 _communityMembers, address _community) external onlyOwnerOrLocalNode {
325         require(_maxDelayDays != 0);
326         require(state == LendingState.Uninitialized);
327         require(_tier > 0);
328         require(_communityMembers > 0);
329         require(ethicHubStorage.getBool(keccak256("user", "community", _community)));
330         ethicHubStorage.setUint(keccak256("lending.maxDelayDays", this), _maxDelayDays);
331         ethicHubStorage.setAddress(keccak256("lending.community", this), _community);
332         ethicHubStorage.setAddress(keccak256("lending.localNode", this), localNode);
333         ethicHubStorage.setUint(keccak256("lending.tier", this), _tier);
334         ethicHubStorage.setUint(keccak256("lending.communityMembers", this), _communityMembers);
335         tier = _tier;
336         state = LendingState.AcceptingContributions;
337         emit StateChange(uint(state));
338 
339     }
340 
341     function setBorrower(address _borrower) external checkIfArbiter {
342         require(_borrower != address(0));
343         require(ethicHubStorage.getBool(keccak256("user", "representative", _borrower)));
344         borrower = _borrower;
345         emit onBorrowerChanged(borrower);
346     }
347 
348     function changeInvestorAddress(address oldInvestor, address newInvestor) external checkIfArbiter {
349         require(newInvestor != address(0));
350         require(ethicHubStorage.getBool(keccak256("user", "investor", newInvestor)));
351         //oldInvestor should have invested in this project
352         require(investors[oldInvestor].amount != 0);
353         //newInvestor should not have invested anything in this project to not complicate return calculation
354         require(investors[newInvestor].amount == 0);
355         investors[newInvestor].amount = investors[oldInvestor].amount;
356         investors[newInvestor].isCompensated = investors[oldInvestor].isCompensated;
357         investors[newInvestor].surplusEthReclaimed = investors[oldInvestor].surplusEthReclaimed;
358         delete investors[oldInvestor];
359         emit onInvestorChanged(oldInvestor, newInvestor);
360     }
361 
362     function() public payable whenNotPaused {
363         require(state == LendingState.AwaitingReturn || state == LendingState.AcceptingContributions || state == LendingState.ExchangingToFiat);
364         if(state == LendingState.AwaitingReturn) {
365             returnBorrowedEth();
366         } else if (state == LendingState.ExchangingToFiat) {
367             // borrower can send surplus eth back to contract to avoid paying interest
368             sendBackSurplusEth();
369         } else {
370             require(ethicHubStorage.getBool(keccak256("user", "investor", msg.sender)));
371             contributeWithAddress(msg.sender);
372         }
373     }
374 
375     function sendBackSurplusEth() internal {
376         require(state == LendingState.ExchangingToFiat);
377         require(msg.sender == borrower);
378         surplusEth = surplusEth.add(msg.value);
379         require(surplusEth <= totalLendingAmount);
380         emit onSurplusSent(msg.value);
381     }
382 
383     /**
384      * After the contribution period ends unsuccesfully, this method enables the contributor
385      *  to retrieve their contribution
386      */
387     function declareProjectNotFunded() external onlyOwnerOrLocalNode {
388         require(totalContributed < totalLendingAmount);
389         require(state == LendingState.AcceptingContributions);
390         require(now > fundingEndTime);
391         state = LendingState.ProjectNotFunded;
392         emit StateChange(uint(state));
393     }
394 
395     function declareProjectDefault() external onlyOwnerOrLocalNode {
396         require(state == LendingState.AwaitingReturn);
397         uint maxDelayDays = getMaxDelayDays();
398         require(getDelayDays(now) >= maxDelayDays);
399         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
400         require(reputation != address(0));
401         ethicHubStorage.setUint(keccak256("lending.delayDays", this), maxDelayDays);
402         reputation.burnReputation(maxDelayDays);
403         state = LendingState.Default;
404         emit StateChange(uint(state));
405     }
406 
407     function setBorrowerReturnEthPerFiatRate(uint256 _borrowerReturnEthPerFiatRate) external onlyOwnerOrLocalNode {
408         require(state == LendingState.AwaitingReturn);
409         borrowerReturnEthPerFiatRate = _borrowerReturnEthPerFiatRate;
410         emit onReturnRateSet(borrowerReturnEthPerFiatRate);
411     }
412 
413     function finishInitialExchangingPeriod(uint256 _initialEthPerFiatRate) external onlyOwnerOrLocalNode {
414         require(capReached == true);
415         require(state == LendingState.ExchangingToFiat);
416         initialEthPerFiatRate = _initialEthPerFiatRate;
417         if (surplusEth > 0) {
418             totalLendingAmount = totalLendingAmount.sub(surplusEth);
419         }
420         totalLendingFiatAmount = totalLendingAmount.mul(initialEthPerFiatRate);
421         emit onInitalRateSet(initialEthPerFiatRate);
422         state = LendingState.AwaitingReturn;
423         emit StateChange(uint(state));
424     }
425 
426     /**
427      * Method to reclaim contribution after project is declared default (% of partial funds)
428      * @param  beneficiary the contributor
429      *
430      */
431     function reclaimContributionDefault(address beneficiary) external {
432         require(state == LendingState.Default);
433         require(!investors[beneficiary].isCompensated);
434         // contribution = contribution * partial_funds / total_funds
435         uint256 contribution = checkInvestorReturns(beneficiary);
436         require(contribution > 0);
437         investors[beneficiary].isCompensated = true;
438         reclaimedContributions = reclaimedContributions.add(1);
439         doReclaim(beneficiary, contribution);
440     }
441 
442     /**
443      * Method to reclaim contribution after a project is declared as not funded
444      * @param  beneficiary the contributor
445      *
446      */
447     function reclaimContribution(address beneficiary) external {
448         require(state == LendingState.ProjectNotFunded);
449         require(!investors[beneficiary].isCompensated);
450         uint256 contribution = investors[beneficiary].amount;
451         require(contribution > 0);
452         investors[beneficiary].isCompensated = true;
453         reclaimedContributions = reclaimedContributions.add(1);
454         doReclaim(beneficiary, contribution);
455     }
456 
457     function reclaimSurplusEth(address beneficiary) external {
458         require(surplusEth > 0);
459         // only can be reclaimed after cap reduced
460         require(state != LendingState.ExchangingToFiat);
461         require(!investors[beneficiary].surplusEthReclaimed);
462         uint256 surplusContribution = investors[beneficiary].amount.mul(surplusEth).div(surplusEth.add(totalLendingAmount));
463         require(surplusContribution > 0);
464         investors[beneficiary].surplusEthReclaimed = true;
465         reclaimedSurpluses = reclaimedSurpluses.add(1);
466         emit onSurplusReclaimed(beneficiary, surplusContribution);
467         doReclaim(beneficiary, surplusContribution);
468     }
469 
470     function reclaimContributionWithInterest(address beneficiary) external {
471         require(state == LendingState.ContributionReturned);
472         require(!investors[beneficiary].isCompensated);
473         uint256 contribution = checkInvestorReturns(beneficiary);
474         require(contribution > 0);
475         investors[beneficiary].isCompensated = true;
476         reclaimedContributions = reclaimedContributions.add(1);
477         doReclaim(beneficiary, contribution);
478     }
479 
480     function reclaimLocalNodeFee() external {
481         require(state == LendingState.ContributionReturned);
482         require(localNodeFeeReclaimed == false);
483         uint256 fee = totalLendingFiatAmount.mul(localNodeFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
484         require(fee > 0);
485         localNodeFeeReclaimed = true;
486         doReclaim(localNode, fee);
487     }
488 
489     function reclaimEthicHubTeamFee() external {
490         require(state == LendingState.ContributionReturned);
491         require(ethicHubTeamFeeReclaimed == false);
492         uint256 fee = totalLendingFiatAmount.mul(ethichubFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
493         require(fee > 0);
494         ethicHubTeamFeeReclaimed = true;
495         doReclaim(ethicHubTeam, fee);
496     }
497 
498     function reclaimLeftoverEth() external checkIfArbiter {
499       require(state == LendingState.ContributionReturned || state == LendingState.Default);
500       require(localNodeFeeReclaimed);
501       require(ethicHubTeamFeeReclaimed);
502       require(investorCount == reclaimedContributions);
503       if(surplusEth > 0) {
504         require(investorCount == reclaimedSurpluses);
505       }
506       doReclaim(ethicHubTeam, this.balance);
507     }
508 
509     function doReclaim(address target, uint256 amount) internal {
510       if(this.balance < amount) {
511         target.transfer(this.balance);
512       } else {
513         target.transfer(amount);
514       }
515     }
516 
517     function returnBorrowedEth() internal {
518         require(state == LendingState.AwaitingReturn);
519         require(msg.sender == borrower);
520         require(borrowerReturnEthPerFiatRate > 0);
521         bool projectRepayed = false;
522         uint excessRepayment = 0;
523         uint newReturnedEth = 0;
524         emit onReturnAmount(msg.sender, msg.value);
525         (newReturnedEth, projectRepayed, excessRepayment) = calculatePaymentGoal(
526                                                                                     borrowerReturnAmount(),
527                                                                                     returnedEth,
528                                                                                     msg.value);
529         returnedEth = newReturnedEth;
530         if (projectRepayed == true) {
531             state = LendingState.ContributionReturned;
532             emit StateChange(uint(state));
533             updateReputation();
534         }
535         if (excessRepayment > 0) {
536             msg.sender.transfer(excessRepayment);
537         }
538     }
539 
540 
541 
542     // @notice make cotribution throught a paymentGateway
543     // @param contributor Address
544     function contributeForAddress(address contributor) external checkProfileRegistered('paymentGateway') payable whenNotPaused {
545         contributeWithAddress(contributor);
546     }
547 
548     // @notice Function to participate in contribution period
549     //  Amounts from the same address should be added up
550     //  If cap is reached, end time should be modified
551     //  Funds should be transferred into multisig wallet
552     // @param contributor Address
553     function contributeWithAddress(address contributor) internal whenNotPaused {
554         require(state == LendingState.AcceptingContributions);
555         //require(msg.value >= minContribAmount);
556         require(isContribPeriodRunning());
557 
558         uint oldTotalContributed = totalContributed;
559         uint newTotalContributed = 0;
560         uint excessContribValue = 0;
561         (newTotalContributed, capReached, excessContribValue) = calculatePaymentGoal(
562                                                                                     totalLendingAmount,
563                                                                                     oldTotalContributed,
564                                                                                     msg.value);
565         totalContributed = newTotalContributed;
566         if (capReached) {
567             fundingEndTime = now;
568             emit onCapReached(fundingEndTime);
569         }
570         if (investors[contributor].amount == 0) {
571             investorCount = investorCount.add(1);
572         }
573         if (excessContribValue > 0) {
574             msg.sender.transfer(excessContribValue);
575             investors[contributor].amount = investors[contributor].amount.add(msg.value).sub(excessContribValue);
576             emit onContribution(newTotalContributed, contributor, msg.value.sub(excessContribValue), investorCount);
577         } else {
578             investors[contributor].amount = investors[contributor].amount.add(msg.value);
579             emit onContribution(newTotalContributed, contributor, msg.value, investorCount);
580         }
581     }
582 
583     function calculatePaymentGoal(uint goal, uint oldTotal, uint contribValue) internal pure returns(uint, bool, uint) {
584         uint newTotal = oldTotal.add(contribValue);
585         bool goalReached = false;
586         uint excess = 0;
587         if (newTotal >= goal && oldTotal < goal) {
588             goalReached = true;
589             excess = newTotal.sub(goal);
590             contribValue = contribValue.sub(excess);
591             newTotal = goal;
592         }
593         return (newTotal, goalReached, excess);
594     }
595 
596     function sendFundsToBorrower() external onlyOwnerOrLocalNode {
597       //Waiting for Exchange
598         require(state == LendingState.AcceptingContributions);
599         require(capReached);
600         state = LendingState.ExchangingToFiat;
601         emit StateChange(uint(state));
602         borrower.transfer(totalContributed);
603     }
604 
605     function updateReputation() internal {
606         uint delayDays = getDelayDays(now);
607         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
608         require(reputation != address(0));
609         if (delayDays > 0) {
610             ethicHubStorage.setUint(keccak256("lending.delayDays", this), delayDays);
611             reputation.burnReputation(delayDays);
612         } else {
613             uint completedProjectsByTier  = ethicHubStorage.getUint(keccak256("community.completedProjectsByTier", this, tier)).add(1);
614             ethicHubStorage.setUint(keccak256("community.completedProjectsByTier", this, tier), completedProjectsByTier);
615             reputation.incrementReputation(completedProjectsByTier);
616         }
617     }
618 
619     function getDelayDays(uint date) public view returns(uint) {
620         uint lendingDaysSeconds = lendingDays * 1 days;
621         uint defaultTime = fundingEndTime.add(lendingDaysSeconds);
622         if (date < defaultTime) {
623             return 0;
624         } else {
625             return date.sub(defaultTime).div(60).div(60).div(24);
626         }
627     }
628 
629     // lendingInterestRate with 2 decimal
630     // 15 * (lending days)/ 365 + 4% local node fee + 3% LendingDev fee
631     function lendingInterestRatePercentage() public view returns(uint256){
632         return annualInterest.mul(interestBaseUint).mul(lendingDays.add(getDelayDays(now))).div(365).add(localNodeFee.mul(interestBaseUint)).add(ethichubFee.mul(interestBaseUint)).add(interestBasePercent);
633     }
634 
635     // lendingInterestRate with 2 decimal
636     function investorInterest() public view returns(uint256){
637         return annualInterest.mul(interestBaseUint).mul(lendingDays.add(getDelayDays(now))).div(365).add(interestBasePercent);
638     }
639 
640     function borrowerReturnFiatAmount() public view returns(uint256) {
641         return totalLendingFiatAmount.mul(lendingInterestRatePercentage()).div(interestBasePercent);
642     }
643 
644     function borrowerReturnAmount() public view returns(uint256) {
645         return borrowerReturnFiatAmount().div(borrowerReturnEthPerFiatRate);
646     }
647 
648     function isContribPeriodRunning() public view returns(bool) {
649         return fundingStartTime <= now && fundingEndTime > now && !capReached;
650     }
651 
652     function checkInvestorContribution(address investor) public view returns(uint256){
653         return investors[investor].amount;
654     }
655 
656     function checkInvestorReturns(address investor) public view returns(uint256) {
657         uint256 investorAmount = 0;
658         if (state == LendingState.ContributionReturned) {
659             investorAmount = investors[investor].amount;
660             if (surplusEth > 0){
661                 investorAmount  = investors[investor].amount.mul(totalLendingAmount).div(totalContributed);
662             }
663             return investorAmount.mul(initialEthPerFiatRate).mul(investorInterest()).div(borrowerReturnEthPerFiatRate).div(interestBasePercent);
664         } else if (state == LendingState.Default){
665             investorAmount = investors[investor].amount;
666             // contribution = contribution * partial_funds / total_funds
667             return investorAmount.mul(returnedEth).div(totalLendingAmount);
668         } else {
669             return 0;
670         }
671     }
672 
673     function getMaxDelayDays() public view returns(uint256){
674         return ethicHubStorage.getUint(keccak256("lending.maxDelayDays", this));
675     }
676 
677     function getUserContributionReclaimStatus(address userAddress) public view returns(bool isCompensated, bool surplusEthReclaimed){
678         isCompensated = investors[userAddress].isCompensated;
679         surplusEthReclaimed = investors[userAddress].surplusEthReclaimed;
680     }
681 }