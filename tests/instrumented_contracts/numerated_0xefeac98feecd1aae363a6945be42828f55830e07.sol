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
49 contract EthicHubBase {
50 
51     uint8 public version;
52 
53     EthicHubStorageInterface public ethicHubStorage = EthicHubStorageInterface(0);
54 
55     constructor(address _storageAddress) public {
56         require(_storageAddress != address(0));
57         ethicHubStorage = EthicHubStorageInterface(_storageAddress);
58     }
59 
60 }
61 
62 contract EthicHubStorageInterface {
63 
64     //modifier for access in sets and deletes
65     modifier onlyEthicHubContracts() {_;}
66 
67     // Setters
68     function setAddress(bytes32 _key, address _value) external;
69     function setUint(bytes32 _key, uint _value) external;
70     function setString(bytes32 _key, string _value) external;
71     function setBytes(bytes32 _key, bytes _value) external;
72     function setBool(bytes32 _key, bool _value) external;
73     function setInt(bytes32 _key, int _value) external;
74     // Deleters
75     function deleteAddress(bytes32 _key) external;
76     function deleteUint(bytes32 _key) external;
77     function deleteString(bytes32 _key) external;
78     function deleteBytes(bytes32 _key) external;
79     function deleteBool(bytes32 _key) external;
80     function deleteInt(bytes32 _key) external;
81 
82     // Getters
83     function getAddress(bytes32 _key) external view returns (address);
84     function getUint(bytes32 _key) external view returns (uint);
85     function getString(bytes32 _key) external view returns (string);
86     function getBytes(bytes32 _key) external view returns (bytes);
87     function getBool(bytes32 _key) external view returns (bool);
88     function getInt(bytes32 _key) external view returns (int);
89 }
90 
91 contract EthicHubReputationInterface {
92     modifier onlyUsersContract(){_;}
93     modifier onlyLendingContract(){_;}
94     function burnReputation(uint delayDays)  external;
95     function incrementReputation(uint completedProjectsByTier)  external;
96     function initLocalNodeReputation(address localNode)  external;
97     function initCommunityReputation(address community)  external;
98     function getCommunityReputation(address target) public view returns(uint256);
99     function getLocalNodeReputation(address target) public view returns(uint256);
100 }
101 
102 contract Ownable {
103   address public owner;
104 
105 
106   event OwnershipRenounced(address indexed previousOwner);
107   event OwnershipTransferred(
108     address indexed previousOwner,
109     address indexed newOwner
110   );
111 
112 
113   /**
114    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
115    * account.
116    */
117   constructor() public {
118     owner = msg.sender;
119   }
120 
121   /**
122    * @dev Throws if called by any account other than the owner.
123    */
124   modifier onlyOwner() {
125     require(msg.sender == owner);
126     _;
127   }
128 
129   /**
130    * @dev Allows the current owner to relinquish control of the contract.
131    */
132   function renounceOwnership() public onlyOwner {
133     emit OwnershipRenounced(owner);
134     owner = address(0);
135   }
136 
137   /**
138    * @dev Allows the current owner to transfer control of the contract to a newOwner.
139    * @param _newOwner The address to transfer ownership to.
140    */
141   function transferOwnership(address _newOwner) public onlyOwner {
142     _transferOwnership(_newOwner);
143   }
144 
145   /**
146    * @dev Transfers control of the contract to a newOwner.
147    * @param _newOwner The address to transfer ownership to.
148    */
149   function _transferOwnership(address _newOwner) internal {
150     require(_newOwner != address(0));
151     emit OwnershipTransferred(owner, _newOwner);
152     owner = _newOwner;
153   }
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
220     uint256 public borrowerReturnDays;
221     uint256 public initialEthPerFiatRate;
222     uint256 public totalLendingFiatAmount;
223     address public borrower;
224     address public localNode;
225     address public ethicHubTeam;
226     uint256 public borrowerReturnDate;
227     uint256 public borrowerReturnEthPerFiatRate;
228     uint256 public ethichubFee;
229     uint256 public localNodeFee;
230     uint256 public tier;
231     // interest rate is using base uint 100 and 100% 10000, this means 1% is 100
232     // this guarantee we can have a 2 decimal presicion in our calculation
233     uint256 public constant interestBaseUint = 100;
234     uint256 public constant interestBasePercent = 10000;
235     bool public localNodeFeeReclaimed;
236     bool public ethicHubTeamFeeReclaimed;
237     uint256 public surplusEth;
238     uint256 public returnedEth;
239 
240     struct Investor {
241         uint256 amount;
242         bool isCompensated;
243         bool surplusEthReclaimed;
244     }
245 
246     // events
247     event onCapReached(uint endTime);
248     event onContribution(uint totalContributed, address indexed investor, uint amount, uint investorsCount);
249     event onCompensated(address indexed contributor, uint amount);
250     event onSurplusSent(uint256 amount);
251     event onSurplusReclaimed(address indexed contributor, uint amount);
252     event StateChange(uint state);
253     event onInitalRateSet(uint rate);
254     event onReturnRateSet(uint rate);
255     event onReturnAmount(address indexed borrower, uint amount);
256     event onBorrowerChanged(address indexed newBorrower);
257     event onInvestorChanged(address indexed oldInvestor, address indexed newInvestor);
258 
259     // modifiers
260     modifier checkProfileRegistered(string profile) {
261         bool isRegistered = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", profile, msg.sender)));
262         require(isRegistered, "Sender not registered in EthicHub.com");
263         _;
264     }
265 
266     modifier checkIfArbiter() {
267         address arbiter = ethicHubStorage.getAddress(keccak256(abi.encodePacked("arbiter", this)));
268         require(arbiter == msg.sender, "Sender not authorized");
269         _;
270     }
271 
272     modifier onlyOwnerOrLocalNode() {
273         require(localNode == msg.sender || owner == msg.sender,"Sender not authorized");
274         _;
275     }
276 
277     modifier onlyInvestorOrPaymentGateway() {
278         bool isInvestor = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "investor", msg.sender)));
279         bool isPaymentGateway = ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "paymentGateway", msg.sender)));
280         require(isPaymentGateway || isInvestor, "Sender not authorized");
281         _;
282     }
283 
284     constructor(
285         uint256 _fundingStartTime,
286         uint256 _fundingEndTime,
287         address _borrower,
288         uint256 _annualInterest,
289         uint256 _totalLendingAmount,
290         uint256 _lendingDays,
291         address _storageAddress,
292         address _localNode,
293         address _ethicHubTeam,
294         uint256 _ethichubFee,
295         uint256 _localNodeFee
296         )
297         EthicHubBase(_storageAddress)
298         public {
299         require(_fundingEndTime > fundingStartTime, "fundingEndTime should be later than fundingStartTime");
300         require(_borrower != address(0), "No borrower set");
301         require(ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "representative", _borrower))), "Borrower not registered representative");
302         require(_localNode != address(0), "No Local Node set");
303         require(_ethicHubTeam != address(0), "No EthicHub Team set");
304         require(ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "localNode", _localNode))), "Local Node is not registered");
305         require(_totalLendingAmount > 0, "_totalLendingAmount must be > 0");
306         require(_lendingDays > 0, "_lendingDays must be > 0");
307         require(_annualInterest > 0 && _annualInterest < 100, "_annualInterest must be between 0 and 100");
308         version = 6;
309         reclaimedContributions = 0;
310         reclaimedSurpluses = 0;
311         borrowerReturnDays = 0;
312         fundingStartTime = _fundingStartTime;
313         fundingEndTime = _fundingEndTime;
314         localNode = _localNode;
315         ethicHubTeam = _ethicHubTeam;
316         borrower = _borrower;
317         annualInterest = _annualInterest;
318         totalLendingAmount = _totalLendingAmount;
319         lendingDays = _lendingDays;
320         ethichubFee = _ethichubFee;
321         localNodeFee = _localNodeFee;
322         state = LendingState.Uninitialized;
323     }
324 
325     function saveInitialParametersToStorage(uint256 _maxDelayDays, uint256 _tier, uint256 _communityMembers, address _community) external onlyOwnerOrLocalNode {
326         require(_maxDelayDays != 0, "_maxDelayDays must be > 0");
327         require(state == LendingState.Uninitialized, "State must be Uninitialized");
328         require(_tier > 0, "_tier must be > 0");
329         require(_communityMembers > 0, "_communityMembers must be > 0");
330         require(ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "community", _community))), "Community is not registered");
331         ethicHubStorage.setUint(keccak256(abi.encodePacked("lending.maxDelayDays", this)), _maxDelayDays);
332         ethicHubStorage.setAddress(keccak256(abi.encodePacked("lending.community", this)), _community);
333         ethicHubStorage.setAddress(keccak256(abi.encodePacked("lending.localNode", this)), localNode);
334         ethicHubStorage.setUint(keccak256(abi.encodePacked("lending.tier", this)), _tier);
335         ethicHubStorage.setUint(keccak256(abi.encodePacked("lending.communityMembers", this)), _communityMembers);
336         tier = _tier;
337         state = LendingState.AcceptingContributions;
338         emit StateChange(uint(state));
339 
340     }
341 
342     function setBorrower(address _borrower) external checkIfArbiter {
343         require(_borrower != address(0), "No borrower set");
344         require(ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "representative", _borrower))), "Borrower not registered representative");
345         borrower = _borrower;
346         emit onBorrowerChanged(borrower);
347     }
348 
349     function changeInvestorAddress(address oldInvestor, address newInvestor) external checkIfArbiter {
350         require(newInvestor != address(0));
351         require(ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "investor", newInvestor))));
352         //oldInvestor should have invested in this project
353         require(investors[oldInvestor].amount != 0);
354         //newInvestor should not have invested anything in this project to not complicate return calculation
355         require(investors[newInvestor].amount == 0);
356         investors[newInvestor].amount = investors[oldInvestor].amount;
357         investors[newInvestor].isCompensated = investors[oldInvestor].isCompensated;
358         investors[newInvestor].surplusEthReclaimed = investors[oldInvestor].surplusEthReclaimed;
359         delete investors[oldInvestor];
360         emit onInvestorChanged(oldInvestor, newInvestor);
361     }
362 
363     function() public payable whenNotPaused {
364         require(state == LendingState.AwaitingReturn || state == LendingState.AcceptingContributions || state == LendingState.ExchangingToFiat, "Can't receive ETH in this state");
365         if(state == LendingState.AwaitingReturn) {
366             returnBorrowedEth();
367         } else if (state == LendingState.ExchangingToFiat) {
368             // borrower can send surplus eth back to contract to avoid paying interest
369             sendBackSurplusEth();
370         } else {
371             require(ethicHubStorage.getBool(keccak256(abi.encodePacked("user", "investor", msg.sender))), "Sender is not registered lender");
372             contributeWithAddress(msg.sender);
373         }
374     }
375 
376     function sendBackSurplusEth() internal {
377         require(state == LendingState.ExchangingToFiat);
378         require(msg.sender == borrower);
379         surplusEth = surplusEth.add(msg.value);
380         require(surplusEth <= totalLendingAmount);
381         emit onSurplusSent(msg.value);
382     }
383 
384     /**
385      * After the contribution period ends unsuccesfully, this method enables the contributor
386      *  to retrieve their contribution
387      */
388     function declareProjectNotFunded() external onlyOwnerOrLocalNode {
389         require(totalContributed < totalLendingAmount);
390         require(state == LendingState.AcceptingContributions);
391         require(now > fundingEndTime);
392         state = LendingState.ProjectNotFunded;
393         emit StateChange(uint(state));
394     }
395 
396     function declareProjectDefault() external onlyOwnerOrLocalNode {
397         require(state == LendingState.AwaitingReturn);
398         uint maxDelayDays = getMaxDelayDays();
399         require(getDelayDays(now) >= maxDelayDays);
400         EthicHubReputationInterface reputation = EthicHubReputationInterface(ethicHubStorage.getAddress(keccak256(abi.encodePacked("contract.name", "reputation"))));
401         require(reputation != address(0));
402         ethicHubStorage.setUint(keccak256(abi.encodePacked("lending.delayDays", this)), maxDelayDays);
403         reputation.burnReputation(maxDelayDays);
404         state = LendingState.Default;
405         emit StateChange(uint(state));
406     }
407 
408     function setBorrowerReturnEthPerFiatRate(uint256 _borrowerReturnEthPerFiatRate) external onlyOwnerOrLocalNode {
409         require(state == LendingState.AwaitingReturn, "State is not AwaitingReturn");
410         borrowerReturnEthPerFiatRate = _borrowerReturnEthPerFiatRate;
411         emit onReturnRateSet(borrowerReturnEthPerFiatRate);
412     }
413 
414     /**
415     * Marks the initial exchange period as over (the ETH collected amount has been exchanged for local Fiat currency)
416     * If there was surplus, the  amount returned is substracted over the total amount collected
417     * Sets the local currency to return, on the basis of which the interest will be calculated
418     * @param _initialEthPerFiatRate the rate with 2 decimals. i.e. 444.22 is 44422 , 1245.00 is 124500
419     */
420     function finishInitialExchangingPeriod(uint256 _initialEthPerFiatRate) external onlyOwnerOrLocalNode {
421         require(capReached == true, "Cap not reached");
422         require(state == LendingState.ExchangingToFiat, "State is not ExchangingToFiat");
423         initialEthPerFiatRate = _initialEthPerFiatRate;
424         if (surplusEth > 0) {
425             totalLendingAmount = totalLendingAmount.sub(surplusEth);
426         }
427         totalLendingFiatAmount = totalLendingAmount.mul(initialEthPerFiatRate);
428         emit onInitalRateSet(initialEthPerFiatRate);
429         state = LendingState.AwaitingReturn;
430         emit StateChange(uint(state));
431     }
432 
433     /**
434      * Method to reclaim contribution after project is declared default (% of partial funds)
435      * @param  beneficiary the contributor
436      *
437      */
438     function reclaimContributionDefault(address beneficiary) external {
439         require(state == LendingState.Default);
440         require(!investors[beneficiary].isCompensated);
441         // contribution = contribution * partial_funds / total_funds
442         uint256 contribution = checkInvestorReturns(beneficiary);
443         require(contribution > 0);
444         investors[beneficiary].isCompensated = true;
445         reclaimedContributions = reclaimedContributions.add(1);
446         doReclaim(beneficiary, contribution);
447     }
448 
449     /**
450      * Method to reclaim contribution after a project is declared as not funded
451      * @param  beneficiary the contributor
452      *
453      */
454     function reclaimContribution(address beneficiary) external {
455         require(state == LendingState.ProjectNotFunded, "State is not ProjectNotFunded");
456         require(!investors[beneficiary].isCompensated, "Contribution already reclaimed");
457         uint256 contribution = investors[beneficiary].amount;
458         require(contribution > 0, "Contribution is 0");
459         investors[beneficiary].isCompensated = true;
460         reclaimedContributions = reclaimedContributions.add(1);
461         doReclaim(beneficiary, contribution);
462     }
463 
464     function reclaimSurplusEth(address beneficiary) external {
465         require(surplusEth > 0, "No surplus ETH");
466         // only can be reclaimed after cap reduced
467         require(state != LendingState.ExchangingToFiat, "State is ExchangingToFiat");
468         require(!investors[beneficiary].surplusEthReclaimed, "Surplus already reclaimed");
469         uint256 surplusContribution = investors[beneficiary].amount.mul(surplusEth).div(surplusEth.add(totalLendingAmount));
470         require(surplusContribution > 0, "Surplus is 0");
471         investors[beneficiary].surplusEthReclaimed = true;
472         reclaimedSurpluses = reclaimedSurpluses.add(1);
473         emit onSurplusReclaimed(beneficiary, surplusContribution);
474         doReclaim(beneficiary, surplusContribution);
475     }
476 
477     function reclaimContributionWithInterest(address beneficiary) external {
478         require(state == LendingState.ContributionReturned, "State is not ContributionReturned");
479         require(!investors[beneficiary].isCompensated, "Lender already compensated");
480         uint256 contribution = checkInvestorReturns(beneficiary);
481         require(contribution > 0, "Contribution is 0");
482         investors[beneficiary].isCompensated = true;
483         reclaimedContributions = reclaimedContributions.add(1);
484         doReclaim(beneficiary, contribution);
485     }
486 
487     function reclaimLocalNodeFee() external {
488         require(state == LendingState.ContributionReturned, "State is not ContributionReturned");
489         require(localNodeFeeReclaimed == false, "Local Node's fee already reclaimed");
490         uint256 fee = totalLendingFiatAmount.mul(localNodeFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
491         require(fee > 0, "Local Node's team fee is 0");
492         localNodeFeeReclaimed = true;
493         doReclaim(localNode, fee);
494     }
495 
496     function reclaimEthicHubTeamFee() external {
497         require(state == LendingState.ContributionReturned, "State is not ContributionReturned");
498         require(ethicHubTeamFeeReclaimed == false, "EthicHub team's fee already reclaimed");
499         uint256 fee = totalLendingFiatAmount.mul(ethichubFee).mul(interestBaseUint).div(interestBasePercent).div(borrowerReturnEthPerFiatRate);
500         require(fee > 0, "EthicHub's team fee is 0");
501         ethicHubTeamFeeReclaimed = true;
502         doReclaim(ethicHubTeam, fee);
503     }
504 
505     function reclaimLeftoverEth() external checkIfArbiter {
506         require(state == LendingState.ContributionReturned || state == LendingState.Default, "State is not ContributionReturned or Default");
507         require(localNodeFeeReclaimed, "Local Node fee is not reclaimed");
508         require(ethicHubTeamFeeReclaimed, "Team fee is not reclaimed");
509         require(investorCount == reclaimedContributions, "Not all investors have reclaimed their share");
510         if(surplusEth > 0) {
511             require(investorCount == reclaimedSurpluses, "Not all investors have reclaimed their surplus");
512         }
513         doReclaim(ethicHubTeam, address(this).balance);
514     }
515 
516     function doReclaim(address target, uint256 amount) internal {
517         if ( address(this).balance < amount ) {
518             target.transfer(address(this).balance);
519         } else {
520             target.transfer(amount);
521         }
522     }
523 
524     function returnBorrowedEth() internal {
525         require(state == LendingState.AwaitingReturn, "State is not AwaitingReturn");
526         require(msg.sender == borrower, "Only the borrower can repay");
527         require(borrowerReturnEthPerFiatRate > 0, "Second exchange rate not set");
528         bool projectRepayed = false;
529         uint excessRepayment = 0;
530         uint newReturnedEth = 0;
531         emit onReturnAmount(msg.sender, msg.value);
532         (newReturnedEth, projectRepayed, excessRepayment) = calculatePaymentGoal(borrowerReturnAmount(), returnedEth, msg.value);
533         returnedEth = newReturnedEth;
534         if (projectRepayed == true) {
535             borrowerReturnDays = getDaysPassedBetweenDates(fundingEndTime, now);
536             state = LendingState.ContributionReturned;
537             emit StateChange(uint(state));
538             updateReputation();
539         }
540         if (excessRepayment > 0) {
541             msg.sender.transfer(excessRepayment);
542         }
543     }
544 
545 
546 
547     // @notice make cotribution throught a paymentGateway
548     // @param contributor Address
549     function contributeForAddress(address contributor) external checkProfileRegistered('paymentGateway') payable whenNotPaused {
550         contributeWithAddress(contributor);
551     }
552 
553     // @notice Function to participate in contribution period
554     //  Amounts from the same address should be added up
555     //  If cap is reached, end time should be modified
556     //  Funds should be transferred into multisig wallet
557     // @param contributor Address
558     function contributeWithAddress(address contributor) internal whenNotPaused {
559         require(state == LendingState.AcceptingContributions, "state is not AcceptingContributions");
560         require(isContribPeriodRunning(), "can't contribute outside contribution period");
561 
562         uint oldTotalContributed = totalContributed;
563         uint newTotalContributed = 0;
564         uint excessContribValue = 0;
565         (newTotalContributed, capReached, excessContribValue) = calculatePaymentGoal(totalLendingAmount, oldTotalContributed, msg.value);
566         totalContributed = newTotalContributed;
567         if (capReached) {
568             fundingEndTime = now;
569             emit onCapReached(fundingEndTime);
570         }
571         if (investors[contributor].amount == 0) {
572             investorCount = investorCount.add(1);
573         }
574         if (excessContribValue > 0) {
575             msg.sender.transfer(excessContribValue);
576             investors[contributor].amount = investors[contributor].amount.add(msg.value).sub(excessContribValue);
577             emit onContribution(newTotalContributed, contributor, msg.value.sub(excessContribValue), investorCount);
578         } else {
579             investors[contributor].amount = investors[contributor].amount.add(msg.value);
580             emit onContribution(newTotalContributed, contributor, msg.value, investorCount);
581         }
582     }
583 
584     /**
585      * Calculates if a target value is reached after increment, and by how much it was surpassed.
586      * @param goal the target to achieve
587      * @param oldTotal the total so far after the increment
588      * @param contribValue the increment
589      * @return (the incremented count, not bigger than max), (goal has been reached), (excess to return)
590      */
591     function calculatePaymentGoal(uint goal, uint oldTotal, uint contribValue) internal pure returns(uint, bool, uint) {
592         uint newTotal = oldTotal.add(contribValue);
593         bool goalReached = false;
594         uint excess = 0;
595         if (newTotal >= goal && oldTotal < goal) {
596             goalReached = true;
597             excess = newTotal.sub(goal);
598             contribValue = contribValue.sub(excess);
599             newTotal = goal;
600         }
601         return (newTotal, goalReached, excess);
602     }
603 
604     function sendFundsToBorrower() external onlyOwnerOrLocalNode {
605       //Waiting for Exchange
606         require(state == LendingState.AcceptingContributions);
607         require(capReached);
608         state = LendingState.ExchangingToFiat;
609         emit StateChange(uint(state));
610         borrower.transfer(totalContributed);
611     }
612 
613     function updateReputation() internal {
614         EthicHubReputationInterface reputation = EthicHubReputationInterface(
615             ethicHubStorage.getAddress(keccak256(abi.encodePacked("contract.name", "reputation")))
616             );
617         require(reputation != address(0));
618         uint delayDays = getDelayDays(now);
619         if (delayDays > 0) {
620             ethicHubStorage.setUint(keccak256(abi.encodePacked("lending.delayDays", this)), delayDays);
621             reputation.burnReputation(delayDays);
622         } else {
623             uint completedProjectsByTier = ethicHubStorage.getUint(keccak256(abi.encodePacked("community.completedProjectsByTier", this, tier))).add(1);
624             ethicHubStorage.setUint(keccak256(abi.encodePacked("community.completedProjectsByTier", this, tier)), completedProjectsByTier);
625             reputation.incrementReputation(completedProjectsByTier);
626         }
627     }
628     /**
629     * Calculates days passed after defaulting
630     * @param date timestamp to calculate days
631     * @return day number
632     */
633     function getDelayDays(uint date) public view returns(uint) {
634         uint lendingDaysSeconds = lendingDays * 1 days;
635         uint defaultTime = fundingEndTime.add(lendingDaysSeconds);
636         if (date < defaultTime) {
637             return 0;
638         } else {
639             return getDaysPassedBetweenDates(defaultTime, date);
640         }
641     }
642 
643     /**
644     * Calculates days passed between two dates in seconds
645     * @param firstDate timestamp
646     * @param lastDate timestamp
647     * @return days passed
648     */
649     function getDaysPassedBetweenDates(uint firstDate, uint lastDate) public pure returns(uint) {
650         require(firstDate <= lastDate, "lastDate must be bigger than firstDate");
651         return lastDate.sub(firstDate).div(60).div(60).div(24);
652     }
653 
654     /** Returns lending days for interest calculations. Once payed, it will return fundingEndTime + days passed until proyect repayment 
655     /* @return days
656     */
657     function getLendingDays() public view returns(uint) {
658         if(borrowerReturnDays > 0) {
659             return borrowerReturnDays;
660         } else {
661             return getDaysPassedBetweenDates(fundingEndTime, now);
662         }
663     }
664 
665     // lendingInterestRate with 2 decimal
666     // 15 * (lending days)/ 365 + 4% local node fee + 3% LendingDev fee
667     function lendingInterestRatePercentage() public view returns(uint256){
668         return annualInterest.mul(interestBaseUint)
669             // current days
670             .mul(getLendingDays()).div(365)
671             .add(localNodeFee.mul(interestBaseUint))
672             .add(ethichubFee.mul(interestBaseUint))
673             .add(interestBasePercent);
674     }
675 
676     // lendingInterestRate with 2 decimal
677     function investorInterest() public view returns(uint256){
678         return annualInterest.mul(interestBaseUint).mul(getLendingDays()).div(365).add(interestBasePercent);
679     }
680 
681     function borrowerReturnFiatAmount() public view returns(uint256) {
682         return totalLendingFiatAmount.mul(lendingInterestRatePercentage()).div(interestBasePercent);
683     }
684 
685     function borrowerReturnAmount() public view returns(uint256) {
686         return borrowerReturnFiatAmount().div(borrowerReturnEthPerFiatRate);
687     }
688 
689     function isContribPeriodRunning() public view returns(bool) {
690         return fundingStartTime <= now && fundingEndTime > now && !capReached;
691     }
692 
693     function checkInvestorContribution(address investor) public view returns(uint256){
694         return investors[investor].amount;
695     }
696 
697     function checkInvestorReturns(address investor) public view returns(uint256) {
698         uint256 investorAmount = 0;
699         if (state == LendingState.ContributionReturned) {
700             investorAmount = investors[investor].amount;
701             if (surplusEth > 0){
702                 investorAmount = investors[investor].amount.mul(totalLendingAmount).div(totalContributed);
703             }
704             return investorAmount.mul(initialEthPerFiatRate).mul(investorInterest()).div(borrowerReturnEthPerFiatRate).div(interestBasePercent);
705         } else if (state == LendingState.Default){
706             investorAmount = investors[investor].amount;
707             // contribution = contribution * partial_funds / total_funds
708             return investorAmount.mul(returnedEth).div(totalLendingAmount);
709         } else {
710             return 0;
711         }
712     }
713 
714     function getMaxDelayDays() public view returns(uint256){
715         return ethicHubStorage.getUint(keccak256(abi.encodePacked("lending.maxDelayDays", this)));
716     }
717 
718     function getUserContributionReclaimStatus(address userAddress) public view returns(bool isCompensated, bool surplusEthReclaimed){
719         isCompensated = investors[userAddress].isCompensated;
720         surplusEthReclaimed = investors[userAddress].surplusEthReclaimed;
721     }
722 }