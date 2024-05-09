1 pragma solidity ^0.4.13;
2 
3 contract EthicHubStorageInterface {
4 
5     //modifier for access in sets and deletes
6     modifier onlyEthicHubContracts() {_;}
7 
8     // Setters
9     function setAddress(bytes32 _key, address _value) external;
10     function setUint(bytes32 _key, uint _value) external;
11     function setString(bytes32 _key, string _value) external;
12     function setBytes(bytes32 _key, bytes _value) external;
13     function setBool(bytes32 _key, bool _value) external;
14     function setInt(bytes32 _key, int _value) external;
15     // Deleters
16     function deleteAddress(bytes32 _key) external;
17     function deleteUint(bytes32 _key) external;
18     function deleteString(bytes32 _key) external;
19     function deleteBytes(bytes32 _key) external;
20     function deleteBool(bytes32 _key) external;
21     function deleteInt(bytes32 _key) external;
22 
23     // Getters
24     function getAddress(bytes32 _key) external view returns (address);
25     function getUint(bytes32 _key) external view returns (uint);
26     function getString(bytes32 _key) external view returns (string);
27     function getBytes(bytes32 _key) external view returns (bytes);
28     function getBool(bytes32 _key) external view returns (bool);
29     function getInt(bytes32 _key) external view returns (int);
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipRenounced(address indexed previousOwner);
37   event OwnershipTransferred(
38     address indexed previousOwner,
39     address indexed newOwner
40   );
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   constructor() public {
48     owner = msg.sender;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to relinquish control of the contract.
61    */
62   function renounceOwnership() public onlyOwner {
63     emit OwnershipRenounced(owner);
64     owner = address(0);
65   }
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param _newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address _newOwner) public onlyOwner {
72     _transferOwnership(_newOwner);
73   }
74 
75   /**
76    * @dev Transfers control of the contract to a newOwner.
77    * @param _newOwner The address to transfer ownership to.
78    */
79   function _transferOwnership(address _newOwner) internal {
80     require(_newOwner != address(0));
81     emit OwnershipTransferred(owner, _newOwner);
82     owner = _newOwner;
83   }
84 }
85 
86 library SafeMath {
87 
88   /**
89   * @dev Multiplies two numbers, throws on overflow.
90   */
91   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
92     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
93     // benefit is lost if 'b' is also tested.
94     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
95     if (a == 0) {
96       return 0;
97     }
98 
99     c = a * b;
100     assert(c / a == b);
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers, truncating the quotient.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     // uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return a / b;
112   }
113 
114   /**
115   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
116   */
117   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   /**
123   * @dev Adds two numbers, throws on overflow.
124   */
125   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
126     c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 }
131 
132 contract EthicHubReputationInterface {
133     modifier onlyUsersContract(){_;}
134     modifier onlyLendingContract(){_;}
135     function burnReputation(uint delayDays)  external;
136     function incrementReputation(uint completedProjectsByTier)  external;
137     function initLocalNodeReputation(address localNode)  external;
138     function initCommunityReputation(address community)  external;
139     function getCommunityReputation(address target) public view returns(uint256);
140     function getLocalNodeReputation(address target) public view returns(uint256);
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
254     event onInvestorChanged(address indexed oldInvestor, address indexed newInvestor);
255 
256     // modifiers
257     modifier checkProfileRegistered(string profile) {
258         bool isRegistered = ethicHubStorage.getBool(keccak256("user", profile, msg.sender));
259         require(isRegistered);
260         _;
261     }
262 
263     modifier checkIfArbiter() {
264         address arbiter = ethicHubStorage.getAddress(keccak256("arbiter", this));
265         require(arbiter == msg.sender);
266         _;
267     }
268 
269     modifier onlyOwnerOrLocalNode() {
270         require(localNode == msg.sender || owner == msg.sender);
271         _;
272     }
273 
274     modifier onlyInvestorOrPaymentGateway() {
275         bool isInvestor = ethicHubStorage.getBool(keccak256("user", "investor", msg.sender));
276         bool isPaymentGateway = ethicHubStorage.getBool(keccak256("user", "paymentGateway", msg.sender));
277         require(isPaymentGateway || isInvestor);
278         _;
279     }
280 
281     constructor(
282         uint256 _fundingStartTime,
283         uint256 _fundingEndTime,
284         address _borrower,
285         uint256 _annualInterest,
286         uint256 _totalLendingAmount,
287         uint256 _lendingDays,
288         address _storageAddress,
289         address _localNode,
290         address _ethicHubTeam,
291         uint256 _ethichubFee, 
292         uint256 _localNodeFee 
293         )
294         EthicHubBase(_storageAddress)
295         public {
296         require(_fundingStartTime > now);
297         require(_fundingEndTime > fundingStartTime);
298         require(_borrower != address(0));
299         require(ethicHubStorage.getBool(keccak256("user", "representative", _borrower)));
300         require(_localNode != address(0));
301         require(_ethicHubTeam != address(0));
302         require(ethicHubStorage.getBool(keccak256("user", "localNode", _localNode)));
303         require(_totalLendingAmount > 0);
304         require(_lendingDays > 0);
305         require(_annualInterest > 0 && _annualInterest < 100);
306         version = 3;
307         fundingStartTime = _fundingStartTime;
308         fundingEndTime = _fundingEndTime;
309         localNode = _localNode;
310         ethicHubTeam = _ethicHubTeam;
311         borrower = _borrower;
312         annualInterest = _annualInterest;
313         totalLendingAmount = _totalLendingAmount;
314         lendingDays = _lendingDays;
315         ethichubFee = _ethichubFee;
316         localNodeFee = _localNodeFee;
317         state = LendingState.Uninitialized;
318     }
319 
320     function saveInitialParametersToStorage(uint256 _maxDelayDays, uint256 _tier, uint256 _communityMembers, address _community) external onlyOwnerOrLocalNode {
321         require(_maxDelayDays != 0);
322         require(state == LendingState.Uninitialized);
323         require(_tier > 0);
324         require(_communityMembers > 0);
325         require(ethicHubStorage.getBool(keccak256("user", "community", _community)));
326         ethicHubStorage.setUint(keccak256("lending.maxDelayDays", this), _maxDelayDays);
327         ethicHubStorage.setAddress(keccak256("lending.community", this), _community);
328         ethicHubStorage.setAddress(keccak256("lending.localNode", this), localNode);
329         ethicHubStorage.setUint(keccak256("lending.tier", this), _tier);
330         ethicHubStorage.setUint(keccak256("lending.communityMembers", this), _communityMembers);
331         tier = _tier;
332         state = LendingState.AcceptingContributions;
333         emit StateChange(uint(state));
334 
335     }
336 
337     function setBorrower(address _borrower) external checkIfArbiter {
338         require(_borrower != address(0));
339         require(ethicHubStorage.getBool(keccak256("user", "representative", _borrower)));
340         borrower = _borrower;
341         emit onBorrowerChanged(borrower);
342     }
343 
344     function changeInvestorAddress(address oldInvestor, address newInvestor) external checkIfArbiter {
345         require(newInvestor != address(0));
346         require(ethicHubStorage.getBool(keccak256("user", "investor", newInvestor)));
347         //oldInvestor should have invested in this project
348         require(investors[oldInvestor].amount != 0);
349         //newInvestor should not have invested anything in this project to not complicate return calculation
350         require(investors[newInvestor].amount == 0);
351         investors[newInvestor].amount = investors[oldInvestor].amount;
352         investors[newInvestor].isCompensated = investors[oldInvestor].isCompensated;
353         investors[newInvestor].surplusEthReclaimed = investors[oldInvestor].surplusEthReclaimed;
354         delete investors[oldInvestor];
355         emit onInvestorChanged(oldInvestor, newInvestor);
356     }
357 
358     function() public payable whenNotPaused {
359         require(state == LendingState.AwaitingReturn || state == LendingState.AcceptingContributions || state == LendingState.ExchangingToFiat);
360         if(state == LendingState.AwaitingReturn) {
361             returnBorrowedEth();
362         } else if (state == LendingState.ExchangingToFiat) {
363             // borrower can send surplus eth back to contract to avoid paying interest
364             sendBackSurplusEth();
365         } else {
366             require(ethicHubStorage.getBool(keccak256("user", "investor", msg.sender)));
367             contributeWithAddress(msg.sender);
368         }
369     }
370 
371     function sendBackSurplusEth() internal {
372         require(state == LendingState.ExchangingToFiat);
373         require(msg.sender == borrower);
374         surplusEth = surplusEth.add(msg.value);
375         require(surplusEth <= totalLendingAmount);
376         emit onSurplusSent(msg.value);
377     }
378 
379     /**
380      * After the contribution period ends unsuccesfully, this method enables the contributor
381      *  to retrieve their contribution
382      */
383     function declareProjectNotFunded() external onlyOwnerOrLocalNode {
384         require(totalContributed < totalLendingAmount);
385         require(state == LendingState.AcceptingContributions);
386         require(now > fundingEndTime);
387         state = LendingState.ProjectNotFunded;
388         emit StateChange(uint(state));
389     }
390 
391     function declareProjectDefault() external onlyOwnerOrLocalNode {
392         require(state == LendingState.AwaitingReturn);
393         uint maxDelayDays = getMaxDelayDays();
394         require(getDelayDays(now) >= maxDelayDays);
395         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
396         require(reputation != address(0));
397         ethicHubStorage.setUint(keccak256("lending.delayDays", this), maxDelayDays);
398         reputation.burnReputation(maxDelayDays);
399         state = LendingState.Default;
400         emit StateChange(uint(state));
401     }
402 
403     function setBorrowerReturnEthPerFiatRate(uint256 _borrowerReturnEthPerFiatRate) external onlyOwnerOrLocalNode {
404         require(state == LendingState.AwaitingReturn);
405         borrowerReturnEthPerFiatRate = _borrowerReturnEthPerFiatRate;
406         emit onReturnRateSet(borrowerReturnEthPerFiatRate);
407     }
408 
409     function finishInitialExchangingPeriod(uint256 _initialEthPerFiatRate) external onlyOwnerOrLocalNode {
410         require(capReached == true);
411         require(state == LendingState.ExchangingToFiat);
412         initialEthPerFiatRate = _initialEthPerFiatRate;
413         if (surplusEth > 0) {
414             totalLendingAmount = totalLendingAmount.sub(surplusEth);
415         }
416         totalLendingFiatAmount = totalLendingAmount.mul(initialEthPerFiatRate);
417         emit onInitalRateSet(initialEthPerFiatRate);
418         state = LendingState.AwaitingReturn;
419         emit StateChange(uint(state));
420     }
421 
422     /**
423      * Method to reclaim contribution after project is declared default (% of partial funds)
424      * @param  beneficiary the contributor
425      *
426      */
427     function reclaimContributionDefault(address beneficiary) external {
428         require(state == LendingState.Default);
429         require(!investors[beneficiary].isCompensated);
430         // contribution = contribution * partial_funds / total_funds
431         uint256 contribution = checkInvestorReturns(beneficiary);
432         require(contribution > 0);
433         investors[beneficiary].isCompensated = true;
434         beneficiary.transfer(contribution);
435     }
436 
437     /**
438      * Method to reclaim contribution after a project is declared as not funded
439      * @param  beneficiary the contributor
440      *
441      */
442     function reclaimContribution(address beneficiary) external {
443         require(state == LendingState.ProjectNotFunded);
444         require(!investors[beneficiary].isCompensated);
445         uint256 contribution = investors[beneficiary].amount;
446         require(contribution > 0);
447         investors[beneficiary].isCompensated = true;
448         beneficiary.transfer(contribution);
449     }
450 
451     function reclaimSurplusEth(address beneficiary) external {
452         require(surplusEth > 0);
453         // only can be reclaimed after cap reduced
454         require(state != LendingState.ExchangingToFiat);
455         require(!investors[beneficiary].surplusEthReclaimed);
456         uint256 surplusContribution = investors[beneficiary].amount.mul(surplusEth).div(surplusEth.add(totalLendingAmount));
457         require(surplusContribution > 0);
458         investors[beneficiary].surplusEthReclaimed = true;
459         emit onSurplusReclaimed(beneficiary, surplusContribution);
460         beneficiary.transfer(surplusContribution);
461     }
462 
463     function reclaimContributionWithInterest(address beneficiary) external {
464         require(state == LendingState.ContributionReturned);
465         require(!investors[beneficiary].isCompensated);
466         uint256 contribution = checkInvestorReturns(beneficiary);
467         require(contribution > 0);
468         investors[beneficiary].isCompensated = true;
469         beneficiary.transfer(contribution);
470     }
471 
472     function reclaimLocalNodeFee() external {
473         require(state == LendingState.ContributionReturned);
474         require(localNodeFeeReclaimed == false);
475         uint256 fee = totalLendingFiatAmount.mul(localNodeFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
476         require(fee > 0);
477         localNodeFeeReclaimed = true;
478         localNode.transfer(fee);
479     }
480 
481     function reclaimEthicHubTeamFee() external {
482         require(state == LendingState.ContributionReturned);
483         require(ethicHubTeamFeeReclaimed == false);
484         uint256 fee = totalLendingFiatAmount.mul(ethichubFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
485         require(fee > 0);
486         ethicHubTeamFeeReclaimed = true;
487         ethicHubTeam.transfer(fee);
488     }
489 
490     function returnBorrowedEth() internal {
491         require(state == LendingState.AwaitingReturn);
492         require(msg.sender == borrower);
493         require(borrowerReturnEthPerFiatRate > 0);
494         bool projectRepayed = false;
495         uint excessRepayment = 0;
496         uint newReturnedEth = 0;
497         emit onReturnAmount(msg.sender, msg.value);
498         (newReturnedEth, projectRepayed, excessRepayment) = calculatePaymentGoal(
499                                                                                     borrowerReturnAmount(),
500                                                                                     returnedEth,
501                                                                                     msg.value);
502         returnedEth = newReturnedEth;
503         if (projectRepayed == true) {
504             state = LendingState.ContributionReturned;
505             emit StateChange(uint(state));
506             updateReputation();
507         }
508         if (excessRepayment > 0) {
509             msg.sender.transfer(excessRepayment);
510         }
511     }
512 
513     // @notice make cotribution throught a paymentGateway
514     // @param contributor Address
515     function contributeForAddress(address contributor) external checkProfileRegistered('paymentGateway') payable whenNotPaused {
516         contributeWithAddress(contributor);
517     }
518 
519     // @notice Function to participate in contribution period
520     //  Amounts from the same address should be added up
521     //  If cap is reached, end time should be modified
522     //  Funds should be transferred into multisig wallet
523     // @param contributor Address
524     function contributeWithAddress(address contributor) internal whenNotPaused {
525         require(state == LendingState.AcceptingContributions);
526         //require(msg.value >= minContribAmount);
527         require(isContribPeriodRunning());
528 
529         uint oldTotalContributed = totalContributed;
530         uint newTotalContributed = 0;
531         uint excessContribValue = 0;
532         (newTotalContributed, capReached, excessContribValue) = calculatePaymentGoal(
533                                                                                     totalLendingAmount,
534                                                                                     oldTotalContributed,
535                                                                                     msg.value);
536         totalContributed = newTotalContributed;
537         if (capReached) {
538             fundingEndTime = now;
539             emit onCapReached(fundingEndTime);
540         }
541         if (investors[contributor].amount == 0) {
542             investorCount = investorCount.add(1);
543         }
544         if (excessContribValue > 0) {
545             msg.sender.transfer(excessContribValue);
546             investors[contributor].amount = investors[contributor].amount.add(msg.value).sub(excessContribValue);
547             emit onContribution(newTotalContributed, contributor, msg.value.sub(excessContribValue), investorCount);
548         } else {
549             investors[contributor].amount = investors[contributor].amount.add(msg.value);
550             emit onContribution(newTotalContributed, contributor, msg.value, investorCount);
551         }
552     }
553 
554     function calculatePaymentGoal(uint goal, uint oldTotal, uint contribValue) internal pure returns(uint, bool, uint) {
555         uint newTotal = oldTotal.add(contribValue);
556         bool goalReached = false;
557         uint excess = 0;
558         if (newTotal >= goal && oldTotal < goal) {
559             goalReached = true;
560             excess = newTotal.sub(goal);
561             contribValue = contribValue.sub(excess);
562             newTotal = goal;
563         }
564         return (newTotal, goalReached, excess);
565     }
566 
567     function sendFundsToBorrower() external onlyOwnerOrLocalNode {
568       //Waiting for Exchange
569         require(state == LendingState.AcceptingContributions);
570         require(capReached);
571         state = LendingState.ExchangingToFiat;
572         emit StateChange(uint(state));
573         borrower.transfer(totalContributed);
574     }
575 
576     function updateReputation() internal {
577         uint delayDays = getDelayDays(now);
578         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256("contract.name", "reputation")));
579         require(reputation != address(0));
580         if (delayDays > 0) {
581             ethicHubStorage.setUint(keccak256("lending.delayDays", this), delayDays);
582             reputation.burnReputation(delayDays);
583         } else {
584             uint completedProjectsByTier  = ethicHubStorage.getUint(keccak256("community.completedProjectsByTier", this, tier)).add(1);
585             ethicHubStorage.setUint(keccak256("community.completedProjectsByTier", this, tier), completedProjectsByTier);
586             reputation.incrementReputation(completedProjectsByTier);
587         }
588     }
589 
590     function getDelayDays(uint date) public view returns(uint) {
591         uint lendingDaysSeconds = lendingDays * 1 days;
592         uint defaultTime = fundingEndTime.add(lendingDaysSeconds);
593         if (date < defaultTime) {
594             return 0;
595         } else {
596             return date.sub(defaultTime).div(60).div(60).div(24);
597         }
598     }
599 
600     // lendingInterestRate with 2 decimal
601     // 15 * (lending days)/ 365 + 4% local node fee + 3% LendingDev fee
602     function lendingInterestRatePercentage() public view returns(uint256){
603         return annualInterest.mul(interestBaseUint).mul(lendingDays.add(getDelayDays(now))).div(365).add(localNodeFee.mul(interestBaseUint)).add(ethichubFee.mul(interestBaseUint)).add(interestBasePercent);
604     }
605 
606     // lendingInterestRate with 2 decimal
607     function investorInterest() public view returns(uint256){
608         return annualInterest.mul(interestBaseUint).mul(lendingDays.add(getDelayDays(now))).div(365).add(interestBasePercent);
609     }
610 
611     function borrowerReturnFiatAmount() public view returns(uint256) {
612         return totalLendingFiatAmount.mul(lendingInterestRatePercentage()).div(interestBasePercent);
613     }
614 
615     function borrowerReturnAmount() public view returns(uint256) {
616         return borrowerReturnFiatAmount().div(borrowerReturnEthPerFiatRate);
617     }
618 
619     function isContribPeriodRunning() public view returns(bool) {
620         return fundingStartTime <= now && fundingEndTime > now && !capReached;
621     }
622 
623     function checkInvestorContribution(address investor) public view returns(uint256){
624         return investors[investor].amount;
625     }
626 
627     function checkInvestorReturns(address investor) public view returns(uint256) {
628         uint256 investorAmount = 0;
629         if (state == LendingState.ContributionReturned) {
630             investorAmount = investors[investor].amount;
631             if (surplusEth > 0){
632                 investorAmount  = investors[investor].amount.mul(totalLendingAmount).div(totalContributed);
633             }
634             return investorAmount.mul(initialEthPerFiatRate).mul(investorInterest()).div(borrowerReturnEthPerFiatRate).div(interestBasePercent);
635         } else if (state == LendingState.Default){
636             investorAmount = investors[investor].amount;
637             // contribution = contribution * partial_funds / total_funds
638             return investorAmount.mul(returnedEth).div(totalLendingAmount);
639         } else {
640             return 0;
641         }
642     }
643 
644     function getMaxDelayDays() public view returns(uint256){
645         return ethicHubStorage.getUint(keccak256("lending.maxDelayDays", this));
646     }
647 
648     function getUserContributionReclaimStatus(address userAddress) public view returns(bool isCompensated, bool surplusEthReclaimed){
649         isCompensated = investors[userAddress].isCompensated;
650         surplusEthReclaimed = investors[userAddress].surplusEthReclaimed;
651     }
652 }