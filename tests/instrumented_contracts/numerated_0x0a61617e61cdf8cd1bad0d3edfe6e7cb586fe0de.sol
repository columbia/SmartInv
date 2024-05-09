1 pragma solidity 0.5.0;
2 
3 // ---------------------------------------------------------------------------
4 // RICO
5 // ---------------------------------------------------------------------------
6 
7 // File: contracts/interfaces/IERC20.sol
8 
9 /**
10  * @title ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/20
12  */
13 interface IERC20 {
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address who) external view returns (uint256);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 // File: contracts/helpers/SafeMath.sol
32 
33 /**
34  * @title SafeMath
35  * @dev Unsigned math operations with safety checks that revert on error
36  */
37 library SafeMath {
38     /**
39     * @dev Multiplies two unsigned integers, reverts on overflow.
40     */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     /**
56     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
57     */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0);
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     /**
68     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69     */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78     * @dev Adds two unsigned integers, reverts on overflow.
79     */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a);
83 
84         return c;
85     }
86 }
87 
88 // File: contracts/helpers/ReentrancyGuard.sol
89 
90 /**
91  * @title Helps contracts guard against reentrancy attacks.
92  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
93  * @dev If you mark a function `nonReentrant`, you should also
94  * mark it `external`.
95  */
96 contract ReentrancyGuard {
97     /// @dev counter to allow mutex lock with only one SSTORE operation
98     uint256 private _guardCounter;
99 
100     constructor () internal {
101         // The counter starts at one to prevent changing it from zero to a non-zero
102         // value, which is a more expensive operation.
103         _guardCounter = 1;
104     }
105 
106     /**
107      * @dev Prevents a contract from calling itself, directly or indirectly.
108      * Calling a `nonReentrant` function from another `nonReentrant`
109      * function is not supported. It is possible to prevent this from happening
110      * by making the `nonReentrant` function external, and make it call a
111      * `private` function that does the actual work.
112      */
113     modifier nonReentrant() {
114         _guardCounter += 1;
115         uint256 localCounter = _guardCounter;
116         _;
117         require(localCounter == _guardCounter);
118     }
119 }
120 
121 // File: contracts/ownerships/ClusterRole.sol
122 
123 contract ClusterRole {
124     address payable private _cluster;
125 
126     /**
127      * @dev Throws if called by any account other than the cluster.
128      */
129     modifier onlyCluster() {
130         require(isCluster(), "onlyCluster: only cluster can call this method.");
131         _;
132     }
133 
134     /**
135      * @dev The Cluster Role sets the original `cluster` of the contract to the sender
136      * account.
137      */
138     constructor () internal {
139         _cluster = msg.sender;
140     }
141 
142     /**
143      * @return the address of the cluster contract.
144      */
145     function cluster() public view returns (address payable) {
146         return _cluster;
147     }
148 
149     /**
150      * @return true if `msg.sender` is the owner of the contract.
151      */
152     function isCluster() public view returns (bool) {
153         return msg.sender == _cluster;
154     }
155 }
156 
157 // File: contracts/ownerships/Ownable.sol
158 
159 contract OperatorRole {
160     address payable private _operator;
161 
162     event OwnershipTransferred(address indexed previousOperator, address indexed newOperator);
163 
164     /**
165      * @dev Throws if called by any account other than the operator.
166      */
167     modifier onlyOperator() {
168         require(isOperator(), "onlyOperator: only the operator can call this method.");
169         _;
170     }
171 
172     /**
173      * @dev The OperatorRole constructor sets the original `operator` of the contract to the sender
174      * account.
175      */
176     constructor (address payable operator) internal {
177         _operator = operator;
178         emit OwnershipTransferred(address(0), operator);
179     }
180 
181     /**
182      * @dev Allows the current operator to transfer control of the contract to a newOperator.
183      * @param newOperator The address to transfer ownership to.
184      */
185     function transferOwnership(address payable newOperator) external onlyOperator {
186         _transferOwnership(newOperator);
187     }
188 
189     /**
190      * @dev Transfers control of the contract to a newOperator.
191      * @param newOperator The address to transfer ownership to.
192      */
193     function _transferOwnership(address payable newOperator) private {
194         require(newOperator != address(0), "_transferOwnership: the address of new operator is not valid.");
195         emit OwnershipTransferred(_operator, newOperator);
196         _operator = newOperator;
197     }
198 
199     /**
200      * @return the address of the operator.
201      */
202     function operator() public view returns (address payable) {
203         return _operator;
204     }
205 
206     /**
207      * @return true if `msg.sender` is the operator of the contract.
208      */
209     function isOperator() public view returns (bool) {
210         return msg.sender == _operator;
211     }
212 }
213 
214 // File: contracts/Crowdsale.sol
215 
216 /**
217  * @title Crowdsale
218  * @dev Crowdsale is a base contract for managing a token crowdsale,
219  * allowing investors to purchase tokens with ether. This contract implements
220  * such functionality in its most fundamental form and can be extended to provide additional
221  * functionality and/or custom behavior.
222  * The external interface represents the basic interface for purchasing tokens, and conform
223  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
224  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
225  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
226  * behavior.
227  */
228 contract Crowdsale is ReentrancyGuard, ClusterRole, OperatorRole {
229     using SafeMath for uint256;
230 
231     IERC20 internal _token;
232 
233     // Crowdsale constant details
234     uint256 private _fee;
235     uint256 private _rate;
236     uint256 private _minInvestmentAmount;
237 
238     // Crowdsale purchase state
239     uint256 internal _weiRaised;
240     uint256 internal _tokensSold;
241 
242     // Emergency transfer variables
243     address private _newContract;
244     bool private _emergencyExitCalled;
245 
246     address[] private _investors;
247 
248     // Get Investor token/eth balances by address
249     struct Investor {
250         uint256 eth;
251         uint256 tokens;
252         uint256 withdrawnEth;
253         uint256 withdrawnTokens;
254         bool refunded;
255     }
256 
257     mapping(address => Investor) internal _balances;
258 
259     // Bonuses state
260     struct Bonus {
261         uint256 amount;
262         uint256 finishTimestamp;
263     }
264 
265     Bonus[] private _bonuses;
266 
267     event Deposited(address indexed beneficiary, uint256 indexed weiAmount, uint256 indexed tokensAmount, uint256 fee);
268     event EthTransfered(address indexed beneficiary,uint256 weiAmount);
269     event TokensTransfered(address indexed beneficiary, uint256 tokensAmount);
270     event Refunded(address indexed beneficiary, uint256 indexed weiAmount);
271     event EmergencyExitCalled(address indexed newContract, uint256 indexed tokensAmount, uint256 indexed weiAmount);
272 
273     /**
274      * @dev The rate is the conversion between wei and the smallest and indivisible
275      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
276      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
277      * @param token Address of the token being sold
278      */
279     constructor (
280         uint256 rate,
281         address token,
282         address payable operator,
283         uint256[] memory bonusFinishTimestamp,
284         uint256[] memory bonuses,
285         uint256 minInvestmentAmount,
286         uint256 fee
287         ) internal OperatorRole(operator) {
288         if (bonuses.length > 0) {
289             for (uint256 i = 0; i < bonuses.length; i++) {
290                 if (i != 0) {
291                     require(bonusFinishTimestamp[i] > bonusFinishTimestamp[i - 1], "Crowdsale: invalid bonus finish timestamp.");
292                 }
293 
294                 Bonus memory bonus = Bonus(bonuses[i], bonusFinishTimestamp[i]);
295                 _bonuses.push(bonus);
296             }
297         }
298 
299         _rate = rate;
300         _token = IERC20(token);
301         _minInvestmentAmount = minInvestmentAmount;
302         _fee = fee;
303     }
304 
305     // -----------------------------------------
306     // EXTERNAL
307     // -----------------------------------------
308 
309     /**
310      * @dev fallback function ***DO NOT OVERRIDE***
311      * Note that other contracts will transfer fund with a base gas stipend
312      * of 2300, which is not enough to call buyTokens. Consider calling
313      * buyTokens directly when purchasing tokens from a contract.
314      */
315     function () external payable {
316         buyTokens(msg.sender);
317     }
318 
319     /**
320      * @dev low level token purchase ***DO NOT OVERRIDE***
321      * This function has a non-reentrancy guard, so it shouldn't be called by
322      * another `nonReentrant` function.
323      * @param beneficiary Recipient of the token purchase
324      */
325     function buyTokens(address beneficiary) public nonReentrant payable {
326         uint256 weiAmount = msg.value;
327 
328         _preValidatePurchase(beneficiary, weiAmount);
329 
330         // calculating the fee from weiAmount
331         uint256 fee = _calculatePercent(weiAmount, _fee);
332 
333         // calculate token amount to be created
334         uint256 tokensAmount = _calculateTokensAmount(weiAmount);
335 
336         // removing the fee amount from main value
337         weiAmount = weiAmount.sub(fee);
338 
339         _processPurchase(beneficiary, weiAmount, tokensAmount);
340 
341         // transfer the fee to cluster contract
342         cluster().transfer(fee);
343 
344         emit Deposited(beneficiary, weiAmount, tokensAmount, fee);
345     }
346 
347     /**
348      * @dev transfer all funds (ETH/Tokens) to another contract, if this crowdsale has some issues
349      * @param newContract address of receiver contract
350      */
351     function emergencyExit(address payable newContract) public {
352         require(newContract != address(0), "emergencyExit: invalid new contract address.");
353         require(isCluster() || isOperator(), "emergencyExit: only operator or cluster can call this method.");
354 
355         if (isCluster()) {
356             _emergencyExitCalled = true;
357             _newContract = newContract;
358         } else if (isOperator()) {
359             require(_emergencyExitCalled == true, "emergencyExit: the cluster need to call this method first.");
360             require(_newContract == newContract, "emergencyExit: the newContract address is not the same address with clusters newContract.");
361 
362             uint256 allLockedTokens = _token.balanceOf(address(this));
363             _withdrawTokens(newContract, allLockedTokens);
364 
365             uint256 allLocketETH = address(this).balance;
366             _withdrawEther(newContract, allLocketETH);
367 
368             emit EmergencyExitCalled(newContract, allLockedTokens, allLocketETH);
369         }
370     }
371 
372     // -----------------------------------------
373     // INTERNAL
374     // -----------------------------------------
375 
376     /**
377      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
378      * @param beneficiary Address performing the token purchase
379      * @param weiAmount Value in wei involved in the purchase
380      */
381     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
382         require(weiAmount >= _minInvestmentAmount, "_preValidatePurchase: msg.amount should be bigger then _minInvestmentAmount.");
383         require(beneficiary != address(0), "_preValidatePurchase: invalid beneficiary address.");
384         require(_emergencyExitCalled == false, "_preValidatePurchase: the crowdsale contract address was transfered.");
385     }
386 
387     /**
388      * @dev Calculate the fee amount from msg.value
389      */
390     function _calculatePercent(uint256 amount, uint256 percent) internal pure returns (uint256) {
391         return amount.mul(percent).div(100);
392     }
393 
394     /**
395      * @dev Override to extend the way in which ether is converted to tokens.
396      * @param weiAmount Value in wei to be converted into tokens
397      * @return Number of tokens that can be purchased with the specified _weiAmount
398      */
399     function _calculateTokensAmount(uint256 weiAmount) internal view returns (uint256) {
400         uint256 tokensAmount = weiAmount.mul(_rate);
401 
402         for (uint256 i = 0; i < _bonuses.length; i++) {
403 			if (block.timestamp <= _bonuses[i].finishTimestamp) {
404 			    uint256 bonusAmount = _calculatePercent(tokensAmount, _bonuses[i].amount);
405 			    tokensAmount = tokensAmount.add(bonusAmount);
406 			    break;
407 			}
408 		}
409 
410         return tokensAmount;
411     }
412 
413     /**
414      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
415      * @param beneficiary Address receiving the tokens
416      * @param tokenAmount Number of tokens to be purchased
417      */
418     function _processPurchase(address beneficiary, uint256 weiAmount, uint256 tokenAmount) internal {
419         // updating the purchase state
420         _weiRaised = _weiRaised.add(weiAmount);
421         _tokensSold = _tokensSold.add(tokenAmount);
422 
423         // if investor is new pushing his/her address to investors list
424         if (_balances[beneficiary].eth == 0 && _balances[beneficiary].refunded == false) {
425             _investors.push(beneficiary);
426         }
427 
428         _balances[beneficiary].eth = _balances[beneficiary].eth.add(weiAmount);
429         _balances[beneficiary].tokens = _balances[beneficiary].tokens.add(tokenAmount);
430     }
431 
432     // -----------------------------------------
433     // FUNDS INTERNAL
434     // -----------------------------------------
435 
436     function _withdrawTokens(address beneficiary, uint256 amount) internal {
437         _token.transfer(beneficiary, amount);
438         emit TokensTransfered(beneficiary, amount);
439     }
440 
441     function _withdrawEther(address payable beneficiary, uint256 amount) internal {
442         beneficiary.transfer(amount);
443         emit EthTransfered(beneficiary, amount);
444     }
445 
446     // -----------------------------------------
447     // GETTERS
448     // -----------------------------------------
449 
450     /**
451      * @return the details of this crowdsale
452      */
453     function getCrowdsaleDetails() public view returns (uint256, address, uint256, uint256, uint256[] memory finishTimestamps, uint256[] memory bonuses) {
454         finishTimestamps = new uint256[](_bonuses.length);
455         bonuses = new uint256[](_bonuses.length);
456 
457         for (uint256 i = 0; i < _bonuses.length; i++) {
458             finishTimestamps[i] = _bonuses[i].finishTimestamp;
459             bonuses[i] = _bonuses[i].amount;
460         }
461 
462         return (
463             _rate,
464             address(_token),
465             _minInvestmentAmount,
466             _fee,
467             finishTimestamps,
468             bonuses
469         );
470     }
471 
472     /**
473      * @dev getInvestorBalances returns the eth/tokens balances of investor also withdrawn history of eth/tokens
474      */
475     function getInvestorBalances(address investor) public view returns (uint256, uint256, uint256, uint256, bool) {
476         return (
477             _balances[investor].eth,
478             _balances[investor].tokens,
479             _balances[investor].withdrawnEth,
480             _balances[investor].withdrawnTokens,
481             _balances[investor].refunded
482         );
483     }
484 
485     /**
486      * @dev getInvestorsArray returns the array of addresses of investors
487      */
488     function getInvestorsArray() public view returns (address[] memory investors) {
489         uint256 investorsAmount = _investors.length;
490         investors = new address[](investorsAmount);
491 
492         for (uint256 i = 0; i < investorsAmount; i++) {
493             investors[i] = _investors[i];
494         }
495 
496         return investors;
497     }
498 
499     /**
500      * @return the amount of wei raised.
501      */
502     function getRaisedWei() public view returns (uint256) {
503         return _weiRaised;
504     }
505 
506     /**
507      * @return the amount of tokens sold.
508      */
509     function getSoldTokens() public view returns (uint256) {
510         return _tokensSold;
511     }
512 
513     /**
514      * @dev isInvestor check if the address is investor or not
515      */
516     function isInvestor(address sender) public view returns (bool) {
517         return _balances[sender].eth != 0 && _balances[sender].tokens != 0;
518     }
519 }
520 
521 // File: contracts/TimedCrowdsale.sol
522 
523 /**
524  * @title TimedCrowdsale
525  * @dev Crowdsale accepting contributions only within a time frame.
526  */
527 contract TimedCrowdsale is Crowdsale {
528     uint256 private _openingTime;
529     uint256 private _closingTime;
530 
531     /**
532      * @dev Reverts if not in crowdsale time range.
533      */
534     modifier onlyWhileOpen() {
535         require(isOpen(), "onlyWhileOpen: investor can call this method only when crowdsale is open.");
536         _;
537     }
538 
539     /**
540      * @dev Constructor, takes crowdsale opening and closing times.
541      * @param openingTime Crowdsale opening time
542      * @param closingTime Crowdsale closing time
543      */
544     constructor (
545         uint256 rate,
546         address token,
547         uint256 openingTime,
548         uint256 closingTime,
549         address payable operator,
550         uint256[] memory bonusFinishTimestamp,
551         uint256[] memory bonuses,
552         uint256 minInvestmentAmount,
553         uint256 fee
554         ) internal Crowdsale(rate, token, operator, bonusFinishTimestamp, bonuses, minInvestmentAmount, fee) {
555         if (bonusFinishTimestamp.length > 0) {
556             require(bonusFinishTimestamp[0] >= openingTime, "TimedCrowdsale: the opening time is smaller then the first bonus timestamp.");
557             require(bonusFinishTimestamp[bonusFinishTimestamp.length - 1] <= closingTime, "TimedCrowdsale: the closing time is smaller then the last bonus timestamp.");
558         }
559 
560         _openingTime = openingTime;
561         _closingTime = closingTime;
562     }
563 
564     // -----------------------------------------
565     // INTERNAL
566     // -----------------------------------------
567 
568     /**
569      * @dev Extend parent behavior requiring to be within contributing period
570      * @param beneficiary Token purchaser
571      * @param weiAmount Amount of wei contributed
572      */
573     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
574         super._preValidatePurchase(beneficiary, weiAmount);
575     }
576 
577     // -----------------------------------------
578     // EXTERNAL
579     // -----------------------------------------
580 
581     /**
582      * @dev refund the investments to investor while crowdsale is open
583      */
584     function refundETH() external onlyWhileOpen {
585         require(isInvestor(msg.sender), "refundETH: only the active investors can call this method.");
586 
587         uint256 weiAmount = _balances[msg.sender].eth;
588         uint256 tokensAmount = _balances[msg.sender].tokens;
589 
590         _balances[msg.sender].eth = 0;
591         _balances[msg.sender].tokens = 0;
592 
593         if (_balances[msg.sender].refunded == false) {
594             _balances[msg.sender].refunded = true;
595         }
596 
597         _weiRaised = _weiRaised.sub(weiAmount);
598         _tokensSold = _tokensSold.sub(tokensAmount);
599 
600         msg.sender.transfer(weiAmount);
601 
602         emit Refunded(msg.sender, weiAmount);
603     }
604 
605     // -----------------------------------------
606     // GETTERS
607     // -----------------------------------------
608 
609     /**
610      * @return the crowdsale opening time.
611      */
612     function getOpeningTime() public view returns (uint256) {
613         return _openingTime;
614     }
615 
616     /**
617      * @return the crowdsale closing time.
618      */
619     function getClosingTime() public view returns (uint256) {
620         return _closingTime;
621     }
622 
623     /**
624      * @return true if the crowdsale is open, false otherwise.
625      */
626     function isOpen() public view returns (bool) {
627         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
628     }
629 
630     /**
631      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
632      * @return Whether crowdsale period has elapsed
633      */
634     function hasClosed() public view returns (bool) {
635         return block.timestamp > _closingTime;
636     }
637 }
638 
639 // File: contracts/ResponsibleCrowdsale.sol
640 
641 /**
642  * @title ResponsibleCrowdsale
643  * @dev Main crowdsale contract
644  */
645 contract ResponsibleCrowdsale is TimedCrowdsale {
646     uint256 private _cycleId;
647     uint256 private _milestoneId;
648     uint256 private constant _timeForDisputs = 10 minutes;
649 
650     uint256 private _allCyclesTokensPercent;
651     uint256 private _allCyclesEthPercent;
652 
653     bool private _operatorTransferedTokens;
654 
655     enum MilestoneStatus { PENDING, DISPUTS_PERIOD, APPROVED }
656     enum InvestorDisputeState { NO_DISPUTES, SUBMITTED, CLOSED, WINNED }
657 
658     struct Cycle {
659         uint256 tokenPercent;
660         uint256 ethPercent;
661         bytes32[] milestones;
662     }
663 
664     struct Dispute {
665         uint256 activeDisputes;
666         address[] winnedAddressList;
667         mapping(address => InvestorDisputeState) investorDispute;
668     }
669 
670     struct Milestone {
671         bytes32 name;
672         uint256 startTimestamp;
673         uint256 disputesOpeningTimestamp;
674         uint256 cycleId;
675         uint256 tokenPercent;
676         uint256 ethPercent;
677         Dispute disputes;
678         bool operatorWasWithdrawn;
679         bool validHash;
680         mapping(address => bool) userWasWithdrawn;
681     }
682 
683     // Mapping of circes by id
684     mapping(uint256 => Cycle) private _cycles;
685 
686     // Mapping of milestones with order
687     mapping(uint256 => bytes32) private _milestones;
688 
689     // Get detail of each milestone by Hash
690     mapping(bytes32 => Milestone) private _milestoneDetails;
691 
692     event MilestoneInvestmentsWithdrawn(bytes32 indexed milestoneHash, uint256 weiAmount, uint256 tokensAmount);
693     event MilestoneResultWithdrawn(bytes32 indexed milestoneHash, address indexed investor, uint256 weiAmount, uint256 tokensAmount);
694 
695     constructor (
696         uint256 rate,
697         address token,
698         uint256 openingTime,
699         uint256 closingTime,
700         address payable operator,
701         uint256[] memory bonusFinishTimestamp,
702         uint256[] memory bonuses,
703         uint256 minInvestmentAmount,
704         uint256 fee
705         ) public TimedCrowdsale(rate, token, openingTime, closingTime, operator, bonusFinishTimestamp, bonuses, minInvestmentAmount, fee) {}
706 
707     // -----------------------------------------
708     // OPERATOR FEATURES
709     // -----------------------------------------
710 
711     function addCycle(
712         uint256 tokenPercent,
713         uint256 ethPercent,
714         bytes32[] memory milestonesNames,
715         uint256[] memory milestonesTokenPercent,
716         uint256[] memory milestonesEthPercent,
717         uint256[] memory milestonesStartTimestamps
718         ) public onlyOperator returns (bool) {
719         // Checking incoming values
720         require(tokenPercent > 0 && tokenPercent < 100, "addCycle: the Token percent of the cycle should be bigger then 0 and smaller then 100.");
721         require(ethPercent > 0 && ethPercent < 100, "addCycle: the ETH percent of the cycle should be bigger then 0 and smaller then 100.");
722         require(milestonesNames.length > 0, "addCycle: the milestones length should be bigger than 0.");
723         require(milestonesTokenPercent.length == milestonesNames.length, "addCycle: the milestonesTokenPercent length should be equal to milestonesNames length.");
724         require(milestonesEthPercent.length == milestonesTokenPercent.length, "addCycle: the milestonesEthPercent length should be equal to milestonesTokenPercent length.");
725         require(milestonesStartTimestamps.length == milestonesEthPercent.length, "addCycle: the milestonesFinishTimestamps length should be equal to milestonesEthPercent length.");
726 
727         // Checking the calculated amount of percentages of all cycles
728         require(_allCyclesTokensPercent + tokenPercent <= 100, "addCycle: the calculated amount of token percents is bigger then 100.");
729         require(_allCyclesEthPercent + ethPercent <= 100, "addCycle: the calculated amount of eth percents is bigger then 100.");
730 
731         if (_cycleId == 0) {
732             require(tokenPercent <= 25 && ethPercent <= 25, "addCycle: for security reasons for the first cycle operator can withdraw only less than 25 percent of investments.");
733         }
734 
735         _cycles[_cycleId] = Cycle(
736             tokenPercent,
737             ethPercent,
738             new bytes32[](0)
739         );
740 
741         uint256 allMilestonesTokensPercent;
742         uint256 allMilestonesEthPercent;
743 
744         for (uint256 i = 0; i < milestonesNames.length; i++) {
745             if (i == 0 && _milestoneId == 0) {
746                 // checking if the first milestone starts after crowdsale finish
747                 require(milestonesStartTimestamps[i] > getClosingTime(), "addCycle: the first milestone timestamp should be bigger then crowdsale closing time.");
748             } else if (i == 0 && _milestoneId > 0) {
749                 // checking if the first milestone starts after the last milestone of the previous cycle
750                 uint256 previousCycleLastMilestoneStartTimestamp =  _milestoneDetails[_milestones[_milestoneId - 1]].startTimestamp;
751                 require(milestonesStartTimestamps[i] > previousCycleLastMilestoneStartTimestamp, "addCycle: the first timestamp of this milestone should be bigger then his previus milestons last timestamp.");
752                 require(milestonesStartTimestamps[i] >= block.timestamp + _timeForDisputs, "addCycle: the second cycle should be start a minimum 3 days after this transaction.");
753             } else if (i != 0) {
754                 // checking if the each next milestone finish timestamp is bigger than his previous one finish timestamp
755                 require(milestonesStartTimestamps[i] > milestonesStartTimestamps[i - 1], "addCycle: each timestamp should be bigger then his previus one.");
756             }
757 
758             // checking if the percentages (token/eth) in this milestones is bigger then 0 and smaller/equal to 100
759             require(milestonesTokenPercent[i] > 0 && milestonesTokenPercent[i] <= 100, "addCycle: the token percent of milestone should be bigger then 0 and smaller from 100.");
760             require(milestonesEthPercent[i] > 0 && milestonesEthPercent[i] <= 100, "addCycle: the ETH percent of milestone should be bigger then 0 and smaller from 100.");
761 
762             // generating the unique hash for each milestone
763             bytes32 hash = _generateHash(
764                 milestonesNames[i],
765                 milestonesStartTimestamps[i]
766             );
767 
768             // before starting the next milestone investors can open disputes within 3 days
769             uint256 disputesOpeningTimestamp = milestonesStartTimestamps[i] - _timeForDisputs;
770 
771             // The first milestone of the first cycle can not have disputes
772             if (i == 0 && _milestoneId == 0) {
773                 disputesOpeningTimestamp = milestonesStartTimestamps[i];
774             }
775 
776             // updating the state
777             _cycles[_cycleId].milestones.push(hash);
778             _milestones[i + _milestoneId] = hash;
779             _milestoneDetails[hash] = Milestone(
780                 milestonesNames[i],                 // Milestone name
781                 milestonesStartTimestamps[i],       // Milestone finish timestamp
782                 disputesOpeningTimestamp,           // Miliestone submit timestamp (it will be updated once when operator calls the submit milestone method)
783                 _cycleId,                           // cycle Id for detecting token and eth percent for this cycle
784                 milestonesTokenPercent[i],          // Token percent of this milestone
785                 milestonesEthPercent[i],            // ETH percent of this milestone
786                 Dispute(0, new address[](0)),       // Disputs state initialization
787                 false,                              // Operator does not withdrawn this milestone investments yet
788                 true                                // Milestone hash is valid
789             );
790 
791             allMilestonesTokensPercent += milestonesTokenPercent[i];
792             allMilestonesEthPercent += milestonesEthPercent[i];
793         }
794 
795         // checking if the calculated amount of all percentages (token/eth) in this milestones equal to 100
796         require(allMilestonesTokensPercent == 100, "addCycle: the calculated amount of Token percent should be equal to 100.");
797         require(allMilestonesEthPercent == 100, "addCycle: the calculated amount of ETH percent should be equal to 100.");
798 
799         _allCyclesTokensPercent += tokenPercent;
800         _allCyclesEthPercent += ethPercent;
801 
802         _cycleId++;
803         _milestoneId += milestonesNames.length;
804 
805         return true;
806     }
807 
808     function collectMilestoneInvestment(bytes32 hash) public onlyOperator {
809         require(_milestoneDetails[hash].validHash, "collectMilestoneInvestment: the milestone hash is not valid.");
810         require(_milestoneDetails[hash].operatorWasWithdrawn == false, "collectMilestoneInvestment: the operator already withdrawn his funds.");
811         require(getMilestoneStatus(hash) == MilestoneStatus.APPROVED, "collectMilestoneInvestment: the time for collecting funds is not started yet.");
812         require(isMilestoneHasActiveDisputes(hash) == false, "collectMilestoneInvestment: the milestone has unsolved disputes.");
813         require(_hadOperatorTransferredTokens(), "collectMilestoneInvestment: the operator need to transfer sold tokens to this contract for receiving investments.");
814 
815         _milestoneDetails[hash].operatorWasWithdrawn = true;
816 
817         uint256 milestoneRefundedTokens;
818         uint256 milestoneInvestmentWei = _calculateEthAmountByMilestone(getRaisedWei(), hash);
819         uint256 winnedDisputesAmount = _milestoneDetails[hash].disputes.winnedAddressList.length;
820 
821         if (winnedDisputesAmount > 0) {
822             for (uint256 i = 0; i < winnedDisputesAmount; i++) {
823                 address winnedInvestor = _milestoneDetails[hash].disputes.winnedAddressList[i];
824 
825                 uint256 investorWeiForMilestone = _calculateEthAmountByMilestone(_balances[winnedInvestor].eth, hash);
826                 uint256 investorTokensForMilestone = _calculateTokensAmountByMilestone(_balances[winnedInvestor].tokens, hash);
827 
828                 milestoneInvestmentWei = milestoneInvestmentWei.sub(investorWeiForMilestone);
829                 milestoneRefundedTokens = milestoneRefundedTokens.add(investorTokensForMilestone);
830             }
831         }
832 
833         _withdrawEther(operator(), milestoneInvestmentWei);
834 
835         if (milestoneRefundedTokens != 0) {
836             _withdrawTokens(operator(), milestoneRefundedTokens);
837         }
838 
839         emit MilestoneInvestmentsWithdrawn(hash, milestoneInvestmentWei, milestoneRefundedTokens);
840     }
841 
842     // -----------------------------------------
843     // DISPUTS FEATURES
844     // -----------------------------------------
845 
846     function openDispute(bytes32 hash, address investor) external onlyCluster returns (bool) {
847         _milestoneDetails[hash].disputes.investorDispute[investor] = InvestorDisputeState.SUBMITTED;
848         _milestoneDetails[hash].disputes.activeDisputes++;
849         return true;
850     }
851 
852     function solveDispute(bytes32 hash, address investor, bool investorWins) external onlyCluster {
853         require(isMilestoneHasActiveDisputes(hash) == true, "solveDispute: no active disputs available.");
854 
855         if (investorWins == true) {
856             _milestoneDetails[hash].disputes.investorDispute[investor] = InvestorDisputeState.WINNED;
857             _milestoneDetails[hash].disputes.winnedAddressList.push(investor);
858         } else {
859             _milestoneDetails[hash].disputes.investorDispute[investor] = InvestorDisputeState.CLOSED;
860         }
861 
862         _milestoneDetails[hash].disputes.activeDisputes--;
863     }
864 
865     // -----------------------------------------
866     // INVESTOR FEATURES
867     // -----------------------------------------
868 
869     function collectMilestoneResult(bytes32 hash) public {
870         require(isInvestor(msg.sender), "collectMilestoneResult: only the active investors can call this method.");
871         require(_milestoneDetails[hash].validHash, "collectMilestoneResult: the milestone hash is not valid.");
872         require(getMilestoneStatus(hash) == MilestoneStatus.APPROVED, "collectMilestoneResult: the time for collecting funds is not started yet.");
873         require(didInvestorWithdraw(hash, msg.sender) == false, "collectMilestoneResult: the investor already withdrawn his tokens.");
874         require(_milestoneDetails[hash].disputes.investorDispute[msg.sender] != InvestorDisputeState.SUBMITTED, "collectMilestoneResult: the investor has unsolved disputes.");
875         require(_hadOperatorTransferredTokens(), "collectMilestoneInvestment: the operator need to transfer sold tokens to this contract for receiving investments.");
876 
877         _milestoneDetails[hash].userWasWithdrawn[msg.sender] = true;
878 
879         uint256 investorBalance;
880         uint256 tokensToSend;
881         uint256 winnedWeis;
882 
883         if (_milestoneDetails[hash].disputes.investorDispute[msg.sender] != InvestorDisputeState.WINNED) {
884             investorBalance = _balances[msg.sender].tokens;
885             tokensToSend = _calculateTokensAmountByMilestone(investorBalance, hash);
886 
887             // transfering tokens to investor
888             _withdrawTokens(msg.sender, tokensToSend);
889             _balances[msg.sender].withdrawnTokens += tokensToSend;
890         } else {
891             investorBalance = _balances[msg.sender].eth;
892             winnedWeis = _calculateEthAmountByMilestone(investorBalance, hash);
893 
894             // transfering disputs ETH investor
895             _withdrawEther(msg.sender, winnedWeis);
896             _balances[msg.sender].withdrawnEth += winnedWeis;
897         }
898 
899         emit MilestoneResultWithdrawn(hash, msg.sender, winnedWeis, tokensToSend);
900     }
901 
902     // -----------------------------------------
903     // INTERNAL
904     // -----------------------------------------
905 
906     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
907         require(_cycleId > 0, "_preValidatePurchase: the cycles/milestones is not setted.");
908         super._preValidatePurchase(beneficiary, weiAmount);
909     }
910 
911     function _generateHash(bytes32 name, uint256 timestamp) private view returns (bytes32) {
912         // generating the unique hash for milestone using the name, start timestamp and the address of this crowdsale
913         return keccak256(abi.encodePacked(name, timestamp, address(this)));
914     }
915 
916     function _calculateEthAmountByMilestone(uint256 weiAmount, bytes32 milestone) private view returns (uint256) {
917         uint256 cycleId = _milestoneDetails[milestone].cycleId;
918         uint256 cyclePercent = _cycles[cycleId].ethPercent;
919         uint256 milestonePercent = _milestoneDetails[milestone].ethPercent;
920 
921         uint256 amount = _calculatePercent(milestonePercent, _calculatePercent(weiAmount, cyclePercent));
922         return amount;
923     }
924 
925     function _calculateTokensAmountByMilestone(uint256 tokens, bytes32 milestone) private view returns (uint256) {
926         uint256 cycleId = _milestoneDetails[milestone].cycleId;
927         uint256 cyclePercent = _cycles[cycleId].tokenPercent;
928         uint256 milestonePercent = _milestoneDetails[milestone].tokenPercent;
929 
930         uint256 amount = _calculatePercent(milestonePercent, _calculatePercent(tokens, cyclePercent));
931         return amount;
932     }
933 
934     function _hadOperatorTransferredTokens() private returns (bool) {
935         // the first time when the investor/operator want to withdraw the funds
936         if (_token.balanceOf(address(this)) == getSoldTokens()) {
937             _operatorTransferedTokens = true;
938             return true;
939         } else if (_operatorTransferedTokens == true) {
940             return true;
941         } else {
942             return false;
943         }
944     }
945 
946     // -----------------------------------------
947     // GETTERS
948     // -----------------------------------------
949 
950     function getCyclesAmount() external view returns (uint256) {
951         return _cycleId;
952     }
953 
954     function getCycleDetails(uint256 cycleId) external view returns (uint256, uint256, bytes32[] memory) {
955         return (
956             _cycles[cycleId].tokenPercent,
957             _cycles[cycleId].ethPercent,
958             _cycles[cycleId].milestones
959         );
960     }
961 
962     function getMilestonesHashes() external view returns (bytes32[] memory milestonesHashArray) {
963         milestonesHashArray = new bytes32[](_milestoneId);
964 
965         for (uint256 i = 0; i < _milestoneId; i++) {
966             milestonesHashArray[i] = _milestones[i];
967         }
968 
969         return milestonesHashArray;
970     }
971 
972     function getMilestoneDetails(bytes32 hash) external view returns (bytes32, uint256, uint256, uint256, uint256, uint256, uint256, MilestoneStatus status) {
973         Milestone memory mil = _milestoneDetails[hash];
974         status = getMilestoneStatus(hash);
975         return (
976             mil.name,
977             mil.startTimestamp,
978             mil.disputesOpeningTimestamp,
979             mil.cycleId,
980             mil.tokenPercent,
981             mil.ethPercent,
982             mil.disputes.activeDisputes,
983             status
984         );
985     }
986 
987     function getMilestoneStatus(bytes32 hash) public view returns (MilestoneStatus status) {
988         // checking if the time for collecting milestone funds was comes
989         if (block.timestamp >= _milestoneDetails[hash].startTimestamp) {
990             return MilestoneStatus.APPROVED;
991         } else if (block.timestamp > _milestoneDetails[hash].disputesOpeningTimestamp) {
992                 return MilestoneStatus.DISPUTS_PERIOD;
993         } else {
994             return MilestoneStatus.PENDING;
995         }
996     }
997 
998     function getCycleTotalPercents() external view returns (uint256, uint256) {
999         return (
1000             _allCyclesTokensPercent,
1001             _allCyclesEthPercent
1002         );
1003     }
1004 
1005     function canInvestorOpenNewDispute(bytes32 hash, address investor) public view returns (bool) {
1006         InvestorDisputeState state = _milestoneDetails[hash].disputes.investorDispute[investor];
1007         return state == InvestorDisputeState.NO_DISPUTES || state == InvestorDisputeState.CLOSED;
1008     }
1009 
1010     function isMilestoneHasActiveDisputes(bytes32 hash) public view returns (bool) {
1011         return _milestoneDetails[hash].disputes.activeDisputes > 0;
1012     }
1013 
1014     function didInvestorOpenedDisputeBefore(bytes32 hash, address investor) public view returns (bool) {
1015         return _milestoneDetails[hash].disputes.investorDispute[investor] != InvestorDisputeState.NO_DISPUTES;
1016     }
1017 
1018     function didInvestorWithdraw(bytes32 hash, address investor) public view returns (bool) {
1019         return _milestoneDetails[hash].userWasWithdrawn[investor];
1020     }
1021 }
1022 
1023 // File: contracts/deployers/CrowdsaleDeployer.sol
1024 
1025 library CrowdsaleDeployer {
1026     function addCrowdsale(
1027         uint256 rate,
1028         address token,
1029         uint256 openingTime,
1030         uint256 closingTime,
1031         address payable operator,
1032         uint256[] calldata bonusFinishTimestamp,
1033         uint256[] calldata bonuses,
1034         uint256 minInvestmentAmount,
1035         uint256 fee
1036         ) external returns (address) {
1037          return address(new ResponsibleCrowdsale(rate, token, openingTime, closingTime, operator, bonusFinishTimestamp, bonuses, minInvestmentAmount, fee));
1038     }
1039 }
1040 
1041 // ---------------------------------------------------------------------------
1042 // ARBITERS POOL
1043 // ---------------------------------------------------------------------------
1044 
1045 // File: contracts/ownerships/Roles.sol
1046 
1047 library Roles {
1048     struct Role {
1049         mapping (address => bool) bearer;
1050     }
1051 
1052     /**
1053      * @dev give an account access to this role
1054      */
1055     function add(Role storage role, address account) internal {
1056         require(account != address(0));
1057         require(!has(role, account));
1058 
1059         role.bearer[account] = true;
1060     }
1061 
1062     /**
1063      * @dev remove an account's access to this role
1064      */
1065     function remove(Role storage role, address account) internal {
1066         require(account != address(0));
1067         require(has(role, account));
1068 
1069         role.bearer[account] = false;
1070     }
1071 
1072     /**
1073      * @dev check if an account has this role
1074      * @return bool
1075      */
1076     function has(Role storage role, address account) internal view returns (bool) {
1077         require(account != address(0));
1078         return role.bearer[account];
1079     }
1080 }
1081 
1082 // File: contracts/ownerships/ArbiterRole.sol
1083 
1084 contract ArbiterRole is ClusterRole {
1085     using Roles for Roles.Role;
1086 
1087     uint256 private _arbitersAmount;
1088 
1089     event ArbiterAdded(address indexed arbiter);
1090     event ArbiterRemoved(address indexed arbiter);
1091 
1092     Roles.Role private _arbiters;
1093 
1094     modifier onlyArbiter() {
1095         require(isArbiter(msg.sender), "onlyArbiter: only arbiter can call this method.");
1096         _;
1097     }
1098 
1099     // -----------------------------------------
1100     // EXTERNAL
1101     // -----------------------------------------
1102 
1103     function addArbiter(address arbiter) public onlyCluster {
1104         _addArbiter(arbiter);
1105         _arbitersAmount++;
1106     }
1107 
1108     function removeArbiter(address arbiter) public onlyCluster {
1109         _removeArbiter(arbiter);
1110         _arbitersAmount--;
1111     }
1112 
1113     // -----------------------------------------
1114     // INTERNAL
1115     // -----------------------------------------
1116 
1117     function _addArbiter(address arbiter) private {
1118         _arbiters.add(arbiter);
1119         emit ArbiterAdded(arbiter);
1120     }
1121 
1122     function _removeArbiter(address arbiter) private {
1123         _arbiters.remove(arbiter);
1124         emit ArbiterRemoved(arbiter);
1125     }
1126 
1127     // -----------------------------------------
1128     // GETTERS
1129     // -----------------------------------------
1130 
1131     function isArbiter(address account) public view returns (bool) {
1132         return _arbiters.has(account);
1133     }
1134 
1135     function getArbitersAmount() external view returns (uint256) {
1136         return _arbitersAmount;
1137     }
1138 }
1139 
1140 // File: contracts/interfaces/ICluster.sol
1141 
1142 interface ICluster {
1143     function solveDispute(address crowdsale, bytes32 milestoneHash, address investor, bool investorWins) external;
1144 }
1145 
1146 // File: contracts/ArbitersPool.sol
1147 
1148 contract ArbitersPool is ArbiterRole {
1149     uint256 private _disputsAmount;
1150     uint256 private constant _necessaryVoices = 3;
1151 
1152     enum DisputeStatus { WAITING, SOLVED }
1153     enum Choice { OPERATOR_WINS, INVESTOR_WINS }
1154 
1155     ICluster private _clusterInterface;
1156 
1157     struct Vote {
1158         address arbiter;
1159         Choice choice;
1160     }
1161 
1162     struct Dispute {
1163         address investor;
1164         address crowdsale;
1165         bytes32 milestoneHash;
1166         string reason;
1167         uint256 votesAmount;
1168         DisputeStatus status;
1169         mapping(address => bool) hasVoted;
1170         mapping(uint256 => Vote) choices;
1171     }
1172 
1173     mapping(bytes32 => uint256[]) private _disputesByMilestone;
1174     mapping(uint256 => Dispute) private _disputesById;
1175 
1176     event Voted(uint256 indexed disputeId, address indexed arbiter, Choice choice);
1177     event NewDisputeCreated(uint256 disputeId, address indexed crowdsale, bytes32 indexed hash, address indexed investor);
1178     event DisputeSolved(uint256 disputeId, Choice choice, address indexed crowdsale, bytes32 indexed hash, address indexed investor);
1179 
1180     constructor () public {
1181         _clusterInterface = ICluster(msg.sender);
1182     }
1183 
1184     function createDispute(bytes32 milestoneHash, address crowdsale, address investor, string calldata reason) external onlyCluster returns (uint256) {
1185         Dispute memory dispute = Dispute(
1186             investor,
1187             crowdsale,
1188             milestoneHash,
1189             reason,
1190             0,
1191             DisputeStatus.WAITING
1192         );
1193 
1194         uint256 thisDisputeId = _disputsAmount;
1195         _disputsAmount++;
1196 
1197         _disputesById[thisDisputeId] = dispute;
1198         _disputesByMilestone[milestoneHash].push(thisDisputeId);
1199 
1200         emit NewDisputeCreated(thisDisputeId, crowdsale, milestoneHash, investor);
1201 
1202         return thisDisputeId;
1203     }
1204 
1205     function voteDispute(uint256 id, Choice choice) public onlyArbiter {
1206         require(_disputsAmount > id, "voteDispute: invalid number of dispute.");
1207         require(_disputesById[id].hasVoted[msg.sender] == false, "voteDispute: arbiter was already voted.");
1208         require(_disputesById[id].status == DisputeStatus.WAITING, "voteDispute: dispute was already closed.");
1209         require(_disputesById[id].votesAmount < _necessaryVoices, "voteDispute: dispute was already voted and finished.");
1210 
1211         _disputesById[id].hasVoted[msg.sender] = true;
1212 
1213         // updating the votes amount
1214         _disputesById[id].votesAmount++;
1215 
1216         // storing info about this vote
1217         uint256 votesAmount = _disputesById[id].votesAmount;
1218         _disputesById[id].choices[votesAmount] = Vote(msg.sender, choice);
1219 
1220         // checking, if the second arbiter voted the same result with the 1st voted arbiter, then dispute will be solved without 3rd vote
1221         if (_disputesById[id].votesAmount == 2 && _disputesById[id].choices[0].choice == choice) {
1222             _executeDispute(id, choice);
1223         } else if (_disputesById[id].votesAmount == _necessaryVoices) {
1224             Choice winner = _calculateWinner(id);
1225             _executeDispute(id, winner);
1226         }
1227 
1228         emit Voted(id, msg.sender, choice);
1229     }
1230 
1231     // -----------------------------------------
1232     // INTERNAL
1233     // -----------------------------------------
1234 
1235     function _calculateWinner(uint256 id) private view returns (Choice choice) {
1236         uint256 votesForInvestor = 0;
1237         for (uint256 i = 0; i < _necessaryVoices; i++) {
1238             if (_disputesById[id].choices[i].choice == Choice.INVESTOR_WINS) {
1239                 votesForInvestor++;
1240             }
1241         }
1242 
1243         return votesForInvestor >= 2 ? Choice.INVESTOR_WINS : Choice.OPERATOR_WINS;
1244     }
1245 
1246     function _executeDispute(uint256 id, Choice choice) private {
1247         _disputesById[id].status = DisputeStatus.SOLVED;
1248         _clusterInterface.solveDispute(
1249             _disputesById[id].crowdsale,
1250             _disputesById[id].milestoneHash,
1251             _disputesById[id].investor,
1252             choice == Choice.INVESTOR_WINS
1253         );
1254 
1255         emit DisputeSolved(
1256             id,
1257             choice,
1258             _disputesById[id].crowdsale,
1259             _disputesById[id].milestoneHash,
1260             _disputesById[id].investor
1261         );
1262     }
1263 
1264     // -----------------------------------------
1265     // GETTERS
1266     // -----------------------------------------
1267 
1268     function getDisputesAmount() external view returns (uint256) {
1269         return _disputsAmount;
1270     }
1271 
1272     function getDisputeDetails(uint256 id) external view returns (bytes32, address, address, string memory, uint256, DisputeStatus status) {
1273         Dispute memory dispute = _disputesById[id];
1274         return (
1275             dispute.milestoneHash,
1276             dispute.crowdsale,
1277             dispute.investor,
1278             dispute.reason,
1279             dispute.votesAmount,
1280             dispute.status
1281         );
1282     }
1283 
1284     function getMilestoneDisputes(bytes32 hash) external view returns (uint256[] memory disputesIDs) {
1285         uint256 disputesLength = _disputesByMilestone[hash].length;
1286         disputesIDs = new uint256[](disputesLength);
1287 
1288         for (uint256 i = 0; i < disputesLength; i++) {
1289             disputesIDs[i] = _disputesByMilestone[hash][i];
1290         }
1291 
1292         return disputesIDs;
1293     }
1294 
1295     function getDisputeVotes(uint256 id) external view returns(address[] memory arbiters, Choice[] memory choices) {
1296         uint256 votedArbitersAmount = _disputesById[id].votesAmount;
1297         arbiters = new address[](votedArbitersAmount);
1298         choices = new Choice[](votedArbitersAmount);
1299 
1300         for (uint256 i = 0; i < votedArbitersAmount; i++) {
1301             arbiters[i] = _disputesById[id].choices[i].arbiter;
1302             choices[i] = _disputesById[id].choices[i].choice;
1303         }
1304 
1305         return (
1306             arbiters,
1307             choices
1308         );
1309     }
1310 
1311     function hasDisputeSolved(uint256 id) external view returns (bool) {
1312         return _disputesById[id].status == DisputeStatus.SOLVED;
1313     }
1314 
1315     function hasArbiterVoted(uint256 id, address arbiter) external view returns (bool) {
1316         return _disputesById[id].hasVoted[arbiter];
1317     }
1318 }
1319 
1320 // ---------------------------------------------------------------------------
1321 // CLUSTER CONTRACT
1322 // ---------------------------------------------------------------------------
1323 
1324 // File: contracts/interfaces/IRICO.sol
1325 
1326 interface IRICO {
1327     enum MilestoneStatus { PENDING, DISPUTS_PERIOD, APPROVED }
1328 
1329     function getMilestoneStatus(bytes32 hash) external view returns (MilestoneStatus status);
1330     
1331     function getMilestonesHashes() external view returns (bytes32[] memory milestonesHashArray);
1332 
1333     function didInvestorOpenedDisputeBefore(bytes32 hash, address investor) external view returns (bool);
1334 
1335     function isInvestor(address investor) external view returns (bool);
1336 
1337     function canInvestorOpenNewDispute(bytes32 hash, address investor) external view returns (bool);
1338 
1339     function openDispute(bytes32 hash, address investor) external returns (bool);
1340 
1341     function solveDispute(bytes32 hash, address investor, bool investorWins) external;
1342 
1343     function emergencyExit(address payable newContract) external;
1344 }
1345 
1346 // File: contracts/interfaces/IArbitersPool.sol
1347 
1348 interface IArbitersPool {
1349     function createDispute(bytes32 milestoneHash, address crowdsale, address investor, string calldata reason) external returns (uint256);
1350 
1351     function addArbiter(address newArbiter) external;
1352 
1353     function renounceArbiter(address arbiter) external;
1354 }
1355 
1356 // File: contracts/ownerships/Ownable.sol
1357 
1358 contract Ownable {
1359     address payable private _owner;
1360 
1361     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1362 
1363     /**
1364      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1365      * account.
1366      */
1367     constructor () internal {
1368         _owner = msg.sender;
1369         emit OwnershipTransferred(address(0), _owner);
1370     }
1371 
1372     /**
1373      * @return the address of the owner.
1374      */
1375     function owner() public view returns (address payable) {
1376         return _owner;
1377     }
1378 
1379     /**
1380      * @dev Throws if called by any account other than the owner.
1381      */
1382     modifier onlyOwner() {
1383         require(isOwner(), "onlyOwner: only the owner can call this method.");
1384         _;
1385     }
1386 
1387     /**
1388      * @return true if `msg.sender` is the owner of the contract.
1389      */
1390     function isOwner() public view returns (bool) {
1391         return msg.sender == _owner;
1392     }
1393 
1394     /**
1395      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1396      * @param newOwner The address to transfer ownership to.
1397      */
1398     function transferOwnership(address payable newOwner) public onlyOwner {
1399         _transferOwnership(newOwner);
1400     }
1401 
1402     /**
1403      * @dev Transfers control of the contract to a newOwner.
1404      * @param newOwner The address to transfer ownership to.
1405      */
1406     function _transferOwnership(address payable newOwner) private {
1407         require(newOwner != address(0), "_transferOwnership: the address of new operator is not valid.");
1408         emit OwnershipTransferred(_owner, newOwner);
1409         _owner = newOwner;
1410     }
1411 }
1412 
1413 // File: contracts/ownerships/BackEndRole.sol
1414 
1415 contract BackEndRole is Ownable {
1416     using Roles for Roles.Role;
1417 
1418     event BackEndAdded(address indexed account);
1419     event BackEndRemoved(address indexed account);
1420 
1421     Roles.Role private _backEnds;
1422 
1423     modifier onlyBackEnd() {
1424         require(isBackEnd(msg.sender), "onlyBackEnd: only back end address can call this method.");
1425         _;
1426     }
1427 
1428     function isBackEnd(address account) public view returns (bool) {
1429         return _backEnds.has(account);
1430     }
1431 
1432     function addBackEnd(address account) public onlyOwner {
1433         _addBackEnd(account);
1434     }
1435 
1436     function removeBackEnd(address account) public onlyOwner {
1437         _removeBackEnd(account);
1438     }
1439 
1440     function _addBackEnd(address account) private {
1441         _backEnds.add(account);
1442         emit BackEndAdded(account);
1443     }
1444 
1445     function _removeBackEnd(address account) private {
1446         _backEnds.remove(account);
1447         emit BackEndRemoved(account);
1448     }
1449 }
1450 
1451 // File: contracts/Cluster.sol
1452 
1453 contract Cluster is BackEndRole {
1454     uint256 private constant _feeForMoreDisputes = 1 ether;
1455 
1456     address private _arbitersPoolAddress;
1457     address[] private _crowdsales;
1458 
1459     mapping(address => address[]) private _operatorsContracts;
1460 
1461     IArbitersPool private _arbitersPool;
1462 
1463     event WeiFunded(address indexed sender, uint256 indexed amount);
1464     event CrowdsaleCreated(
1465         address crowdsale,
1466         uint256 rate,
1467         address token,
1468         uint256 openingTime,
1469         uint256 closingTime,
1470         address operator,
1471         uint256[] bonusFinishTimestamp,
1472         uint256[] bonuses,
1473         uint256 minInvestmentAmount,
1474         uint256 fee
1475     );
1476 
1477     // -----------------------------------------
1478     // CONSTRUCTOR
1479     // -----------------------------------------
1480 
1481     constructor () public {
1482         _arbitersPoolAddress = address(new ArbitersPool());
1483         _arbitersPool = IArbitersPool(_arbitersPoolAddress);
1484     }
1485 
1486     function() external payable {
1487         emit WeiFunded(msg.sender, msg.value);
1488     }
1489 
1490     // -----------------------------------------
1491     // OWNER FEATURES
1492     // -----------------------------------------
1493 
1494     function withdrawEth() external onlyOwner {
1495         owner().transfer(address(this).balance);
1496     }
1497 
1498     function addArbiter(address newArbiter) external onlyBackEnd {
1499         require(newArbiter != address(0), "addArbiter: invalid type of address.");
1500 
1501         _arbitersPool.addArbiter(newArbiter);
1502     }
1503 
1504     function removeArbiter(address arbiter) external onlyBackEnd {
1505         require(arbiter != address(0), "removeArbiter: invalid type of address.");
1506 
1507         _arbitersPool.renounceArbiter(arbiter);
1508     }
1509 
1510     function addCrowdsale(
1511         uint256 rate,
1512         address token,
1513         uint256 openingTime,
1514         uint256 closingTime,
1515         address payable operator,
1516         uint256[] calldata bonusFinishTimestamp,
1517         uint256[] calldata bonuses,
1518         uint256 minInvestmentAmount,
1519         uint256 fee
1520         ) external onlyBackEnd returns (address) {
1521         require(rate != 0, "addCrowdsale: the rate should be bigger then 0.");
1522         require(token != address(0), "addCrowdsale: invalid token address.");
1523         require(openingTime >= block.timestamp, "addCrowdsale: invalid opening time.");
1524         require(closingTime > openingTime, "addCrowdsale: invalid closing time.");
1525         require(operator != address(0), "addCrowdsale: the address of operator is not valid.");
1526         require(bonusFinishTimestamp.length == bonuses.length, "addCrowdsale: the length of bonusFinishTimestamp and bonuses is not equal.");
1527 
1528         address crowdsale = CrowdsaleDeployer.addCrowdsale(
1529             rate,
1530             token,
1531             openingTime,
1532             closingTime,
1533             operator,
1534             bonusFinishTimestamp,
1535             bonuses,
1536             minInvestmentAmount,
1537             fee
1538         );
1539 
1540         // Updating the state
1541         _crowdsales.push(crowdsale);
1542         _operatorsContracts[operator].push(crowdsale);
1543 
1544         emit CrowdsaleCreated(
1545             crowdsale,
1546             rate,
1547             token,
1548             openingTime,
1549             closingTime,
1550             operator,
1551             bonusFinishTimestamp,
1552             bonuses,
1553             minInvestmentAmount,
1554             fee
1555         );
1556         return crowdsale;
1557     }
1558 
1559     // -----------------------------------------
1560     // OPERATOR FEATURES
1561     // -----------------------------------------
1562 
1563     function emergencyExit(address crowdsale, address payable newContract) external onlyOwner {
1564         IRICO(crowdsale).emergencyExit(newContract);
1565     }
1566 
1567     // -----------------------------------------
1568     // INVESTOR FEATURES
1569     // -----------------------------------------
1570 
1571     function openDispute(address crowdsale, bytes32 hash, string calldata reason) external payable returns (uint256) {
1572         require(IRICO(crowdsale).isInvestor(msg.sender) == true, "openDispute: sender is not an investor.");
1573         require(IRICO(crowdsale).canInvestorOpenNewDispute(hash, msg.sender) == true, "openDispute: investor cannot open a new dispute.");
1574         require(IRICO(crowdsale).getMilestoneStatus(hash) == IRICO.MilestoneStatus.DISPUTS_PERIOD, "openDispute: the period for opening new disputes was finished.");
1575 
1576         if (IRICO(crowdsale).didInvestorOpenedDisputeBefore(hash, msg.sender) == true) {
1577             require(msg.value == _feeForMoreDisputes, "openDispute: for the second and other disputes investor need to pay 1 ETH fee.");
1578         }
1579 
1580         IRICO(crowdsale).openDispute(hash, msg.sender);
1581         uint256 disputeID = _arbitersPool.createDispute(hash, crowdsale, msg.sender, reason);
1582 
1583         return disputeID;
1584     }
1585 
1586     // -----------------------------------------
1587     // ARBITERSPOOL FEATURES
1588     // -----------------------------------------
1589 
1590     function solveDispute(address crowdsale, bytes32 hash, address investor, bool investorWins) external {
1591         require(msg.sender == _arbitersPoolAddress, "solveDispute: the sender is not arbiters pool contract.");
1592 
1593         IRICO(crowdsale).solveDispute(hash, investor, investorWins);
1594     }
1595 
1596     // -----------------------------------------
1597     // GETTERS
1598     // -----------------------------------------
1599 
1600     function getArbitersPoolAddress() external view returns (address) {
1601         return _arbitersPoolAddress;
1602     }
1603 
1604     function getAllCrowdsalesAddresses() external view returns (address[] memory crowdsales) {
1605         crowdsales = new address[](_crowdsales.length);
1606         for (uint256 i = 0; i < _crowdsales.length; i++) {
1607             crowdsales[i] = _crowdsales[i];
1608         }
1609         return crowdsales;
1610     }
1611     
1612     function getCrowdsaleMilestones(address crowdsale) external view returns(bytes32[] memory milestonesHashArray) {
1613         return IRICO(crowdsale).getMilestonesHashes();
1614     }
1615 
1616     function getOperatorCrowdsaleAddresses(address operator) external view returns (address[] memory crowdsales) {
1617         crowdsales = new address[](_operatorsContracts[operator].length);
1618         for (uint256 i = 0; i < _operatorsContracts[operator].length; i++) {
1619             crowdsales[i] = _operatorsContracts[operator][i];
1620         }
1621         return crowdsales;
1622     }
1623 }