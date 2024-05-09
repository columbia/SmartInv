1 pragma solidity 0.5.3;
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
22     function name() external pure returns (string memory);
23 
24     function symbol() external pure returns (string memory);
25 
26     function decimals() external pure returns (uint256);
27 
28     function balanceOf(address who) external view returns (uint256);
29 
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 // File: contracts/helpers/SafeMath.sol
38 
39 /**
40  * @title SafeMath
41  * @dev Unsigned math operations with safety checks that revert on error
42  */
43 library SafeMath {
44     /**
45     * @dev Multiplies two unsigned integers, reverts on overflow.
46     */
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint256 c = a * b;
56         require(c / a == b);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
63     */
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Solidity only automatically asserts when dividing by 0
66         require(b > 0);
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     /**
74     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
75     */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b <= a);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84     * @dev Adds two unsigned integers, reverts on overflow.
85     */
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a);
89 
90         return c;
91     }
92 }
93 
94 // File: contracts/helpers/ReentrancyGuard.sol
95 
96 /**
97  * @title Helps contracts guard against reentrancy attacks.
98  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
99  * @dev If you mark a function `nonReentrant`, you should also
100  * mark it `external`.
101  */
102 contract ReentrancyGuard {
103     /// @dev counter to allow mutex lock with only one SSTORE operation
104     uint256 private _guardCounter;
105 
106     constructor () internal {
107         // The counter starts at one to prevent changing it from zero to a non-zero
108         // value, which is a more expensive operation.
109         _guardCounter = 1;
110     }
111 
112     /**
113      * @dev Prevents a contract from calling itself, directly or indirectly.
114      * Calling a `nonReentrant` function from another `nonReentrant`
115      * function is not supported. It is possible to prevent this from happening
116      * by making the `nonReentrant` function external, and make it call a
117      * `private` function that does the actual work.
118      */
119     modifier nonReentrant() {
120         _guardCounter += 1;
121         uint256 localCounter = _guardCounter;
122         _;
123         require(localCounter == _guardCounter);
124     }
125 }
126 
127 // File: contracts/ownerships/ClusterRole.sol
128 
129 contract ClusterRole {
130     address payable private _cluster;
131 
132     /**
133      * @dev Throws if called by any account other than the cluster.
134      */
135     modifier onlyCluster() {
136         require(isCluster(), "onlyCluster: only cluster can call this method.");
137         _;
138     }
139 
140     /**
141      * @dev The Cluster Role sets the original `cluster` of the contract to the sender
142      * account.
143      */
144     constructor () internal {
145         _cluster = msg.sender;
146     }
147 
148     /**
149      * @return the address of the cluster contract.
150      */
151     function cluster() public view returns (address payable) {
152         return _cluster;
153     }
154 
155     /**
156      * @return true if `msg.sender` is the owner of the contract.
157      */
158     function isCluster() public view returns (bool) {
159         return msg.sender == _cluster;
160     }
161 }
162 
163 // File: contracts/ownerships/Ownable.sol
164 
165 contract OperatorRole {
166     address payable private _operator;
167 
168     event OwnershipTransferred(address indexed previousOperator, address indexed newOperator);
169 
170     /**
171      * @dev Throws if called by any account other than the operator.
172      */
173     modifier onlyOperator() {
174         require(isOperator(), "onlyOperator: only the operator can call this method.");
175         _;
176     }
177 
178     /**
179      * @dev The OperatorRole constructor sets the original `operator` of the contract to the sender
180      * account.
181      */
182     constructor (address payable operator) internal {
183         _operator = operator;
184         emit OwnershipTransferred(address(0), operator);
185     }
186 
187     /**
188      * @dev Allows the current operator to transfer control of the contract to a newOperator.
189      * @param newOperator The address to transfer ownership to.
190      */
191     function transferOwnership(address payable newOperator) external onlyOperator {
192         _transferOwnership(newOperator);
193     }
194 
195     /**
196      * @dev Transfers control of the contract to a newOperator.
197      * @param newOperator The address to transfer ownership to.
198      */
199     function _transferOwnership(address payable newOperator) private {
200         require(newOperator != address(0), "_transferOwnership: the address of new operator is not valid.");
201         emit OwnershipTransferred(_operator, newOperator);
202         _operator = newOperator;
203     }
204 
205     /**
206      * @return the address of the operator.
207      */
208     function operator() public view returns (address payable) {
209         return _operator;
210     }
211 
212     /**
213      * @return true if `msg.sender` is the operator of the contract.
214      */
215     function isOperator() public view returns (bool) {
216         return msg.sender == _operator;
217     }
218 }
219 
220 // File: contracts/Crowdsale.sol
221 
222 /**
223  * @title Crowdsale
224  * @dev Crowdsale is a base contract for managing a token crowdsale,
225  * allowing investors to purchase tokens with ether. This contract implements
226  * such functionality in its most fundamental form and can be extended to provide additional
227  * functionality and/or custom behavior.
228  * The external interface represents the basic interface for purchasing tokens, and conform
229  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
230  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
231  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
232  * behavior.
233  */
234 contract Crowdsale is ReentrancyGuard, ClusterRole, OperatorRole {
235     using SafeMath for uint256;
236 
237     IERC20 internal _token;
238 
239     // Crowdsale constant details
240     uint256 private _fee;
241     uint256 private _rate;
242     uint256 private _minInvestmentAmount;
243 
244     // Crowdsale purchase state
245     uint256 internal _weiRaised;
246     uint256 internal _tokensSold;
247 
248     // Emergency transfer variables
249     address private _newContract;
250     bool private _emergencyExitCalled;
251 
252     address[] private _investors;
253 
254     // Get Investor token/eth balances by address
255     struct Investor {
256         uint256 eth;
257         uint256 tokens;
258         uint256 withdrawnEth;
259         uint256 withdrawnTokens;
260         bool refunded;
261     }
262 
263     mapping (address => Investor) internal _balances;
264 
265     // Bonuses state
266     struct Bonus {
267         uint256 amount;
268         uint256 finishTimestamp;
269     }
270 
271     Bonus[] private _bonuses;
272 
273     event Deposited(address indexed beneficiary, uint256 indexed weiAmount, uint256 indexed tokensAmount, uint256 fee);
274     event EthTransfered(address indexed beneficiary,uint256 weiAmount);
275     event TokensTransfered(address indexed beneficiary, uint256 tokensAmount);
276     event Refunded(address indexed beneficiary, uint256 indexed weiAmount);
277     event EmergencyExitCalled(address indexed newContract, uint256 indexed tokensAmount, uint256 indexed weiAmount);
278 
279     /**
280      * @dev The rate is the conversion between wei and the smallest and indivisible
281      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
282      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
283      * @param token Address of the token being sold
284      */
285     constructor (
286         uint256 rate,
287         address token,
288         address payable operator,
289         uint256[] memory bonusFinishTimestamp,
290         uint256[] memory bonuses,
291         uint256 minInvestmentAmount,
292         uint256 fee
293         ) internal OperatorRole(operator) {
294         if (bonuses.length > 0) {
295             for (uint256 i = 0; i < bonuses.length; i++) {
296                 if (i != 0) {
297                     require(bonusFinishTimestamp[i] > bonusFinishTimestamp[i - 1], "Crowdsale: invalid bonus finish timestamp.");
298                 }
299 
300                 Bonus memory bonus = Bonus(bonuses[i], bonusFinishTimestamp[i]);
301                 _bonuses.push(bonus);
302             }
303         }
304 
305         _rate = rate;
306         _token = IERC20(token);
307         _minInvestmentAmount = minInvestmentAmount;
308         _fee = fee;
309     }
310 
311     // -----------------------------------------
312     // EXTERNAL
313     // -----------------------------------------
314 
315     /**
316      * @dev fallback function ***DO NOT OVERRIDE***
317      * Note that other contracts will transfer fund with a base gas stipend
318      * of 2300, which is not enough to call buyTokens. Consider calling
319      * buyTokens directly when purchasing tokens from a contract.
320      */
321     function () external payable {
322         buyTokens(msg.sender);
323     }
324 
325     /**
326      * @dev low level token purchase ***DO NOT OVERRIDE***
327      * This function has a non-reentrancy guard, so it shouldn't be called by
328      * another `nonReentrant` function.
329      * @param beneficiary Recipient of the token purchase
330      */
331     function buyTokens(address beneficiary) public nonReentrant payable {
332         uint256 weiAmount = msg.value;
333 
334         _preValidatePurchase(beneficiary, weiAmount);
335 
336         // calculating the fee from weiAmount
337         uint256 fee = _calculatePercent(weiAmount, _fee);
338 
339         // calculate token amount to be created
340         uint256 tokensAmount = _calculateTokensAmount(weiAmount);
341 
342         // removing the fee amount from main value
343         weiAmount = weiAmount.sub(fee);
344 
345         _processPurchase(beneficiary, weiAmount, tokensAmount);
346 
347         // transfer the fee to cluster contract
348         cluster().transfer(fee);
349 
350         emit Deposited(beneficiary, weiAmount, tokensAmount, fee);
351     }
352 
353     /**
354      * @dev transfer all funds (ETH/Tokens) to another contract, if this crowdsale has some issues
355      * @param newContract address of receiver contract
356      */
357     function emergencyExit(address payable newContract) public {
358         require(newContract != address(0), "emergencyExit: invalid new contract address.");
359         require(isCluster() || isOperator(), "emergencyExit: only operator or cluster can call this method.");
360 
361         if (isCluster()) {
362             _emergencyExitCalled = true;
363             _newContract = newContract;
364         } else if (isOperator()) {
365             require(_emergencyExitCalled == true, "emergencyExit: the cluster need to call this method first.");
366             require(_newContract == newContract, "emergencyExit: the newContract address is not the same address with clusters newContract.");
367 
368             uint256 allLockedTokens = _token.balanceOf(address(this));
369             _withdrawTokens(newContract, allLockedTokens);
370 
371             uint256 allLocketETH = address(this).balance;
372             _withdrawEther(newContract, allLocketETH);
373 
374             emit EmergencyExitCalled(newContract, allLockedTokens, allLocketETH);
375         }
376     }
377 
378     // -----------------------------------------
379     // INTERNAL
380     // -----------------------------------------
381 
382     /**
383      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
384      * @param beneficiary Address performing the token purchase
385      * @param weiAmount Value in wei involved in the purchase
386      */
387     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
388         require(weiAmount >= _minInvestmentAmount, "_preValidatePurchase: msg.amount should be bigger then _minInvestmentAmount.");
389         require(beneficiary != address(0), "_preValidatePurchase: invalid beneficiary address.");
390         require(_emergencyExitCalled == false, "_preValidatePurchase: the crowdsale contract address was transfered.");
391     }
392 
393     /**
394      * @dev Calculate the fee amount from msg.value
395      */
396     function _calculatePercent(uint256 amount, uint256 percent) internal pure returns (uint256) {
397         return amount.mul(percent).div(100);
398     }
399 
400     /**
401      * @dev Override to extend the way in which ether is converted to tokens.
402      * @param weiAmount Value in wei to be converted into tokens
403      * @return Number of tokens that can be purchased with the specified _weiAmount
404      */
405     function _calculateTokensAmount(uint256 weiAmount) internal view returns (uint256) {
406         uint256 tokensAmount = weiAmount.mul(_rate);
407 
408         for (uint256 i = 0; i < _bonuses.length; i++) {
409 			if (block.timestamp <= _bonuses[i].finishTimestamp) {
410 			    uint256 bonusAmount = _calculatePercent(tokensAmount, _bonuses[i].amount);
411 			    tokensAmount = tokensAmount.add(bonusAmount);
412 			    break;
413 			}
414 		}
415 
416         return tokensAmount;
417     }
418 
419     /**
420      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
421      * @param beneficiary Address receiving the tokens
422      * @param tokenAmount Number of tokens to be purchased
423      */
424     function _processPurchase(address beneficiary, uint256 weiAmount, uint256 tokenAmount) internal {
425         // updating the purchase state
426         _weiRaised = _weiRaised.add(weiAmount);
427         _tokensSold = _tokensSold.add(tokenAmount);
428 
429         // if investor is new pushing his/her address to investors list
430         if (_balances[beneficiary].eth == 0 && _balances[beneficiary].refunded == false) {
431             _investors.push(beneficiary);
432         }
433 
434         _balances[beneficiary].eth = _balances[beneficiary].eth.add(weiAmount);
435         _balances[beneficiary].tokens = _balances[beneficiary].tokens.add(tokenAmount);
436     }
437 
438     // -----------------------------------------
439     // FUNDS INTERNAL
440     // -----------------------------------------
441 
442     function _withdrawTokens(address beneficiary, uint256 amount) internal {
443         _token.transfer(beneficiary, amount);
444         emit TokensTransfered(beneficiary, amount);
445     }
446 
447     function _withdrawEther(address payable beneficiary, uint256 amount) internal {
448         beneficiary.transfer(amount);
449         emit EthTransfered(beneficiary, amount);
450     }
451 
452     // -----------------------------------------
453     // GETTERS
454     // -----------------------------------------
455 
456     /**
457      * @return the details of this crowdsale
458      */
459     function getCrowdsaleDetails() public view returns (uint256, address, uint256, uint256, uint256[] memory finishTimestamps, uint256[] memory bonuses) {
460         finishTimestamps = new uint256[](_bonuses.length);
461         bonuses = new uint256[](_bonuses.length);
462 
463         for (uint256 i = 0; i < _bonuses.length; i++) {
464             finishTimestamps[i] = _bonuses[i].finishTimestamp;
465             bonuses[i] = _bonuses[i].amount;
466         }
467 
468         return (
469             _rate,
470             address(_token),
471             _minInvestmentAmount,
472             _fee,
473             finishTimestamps,
474             bonuses
475         );
476     }
477 
478     /**
479      * @dev getInvestorBalances returns the eth/tokens balances of investor also withdrawn history of eth/tokens
480      */
481     function getInvestorBalances(address investor) public view returns (uint256, uint256, uint256, uint256, bool) {
482         return (
483             _balances[investor].eth,
484             _balances[investor].tokens,
485             _balances[investor].withdrawnEth,
486             _balances[investor].withdrawnTokens,
487             _balances[investor].refunded
488         );
489     }
490 
491     /**
492      * @dev getInvestorsArray returns the array of addresses of investors
493      */
494     function getInvestorsArray() public view returns (address[] memory investors) {
495         uint256 investorsAmount = _investors.length;
496         investors = new address[](investorsAmount);
497 
498         for (uint256 i = 0; i < investorsAmount; i++) {
499             investors[i] = _investors[i];
500         }
501 
502         return investors;
503     }
504 
505     /**
506      * @return the amount of wei raised.
507      */
508     function getRaisedWei() public view returns (uint256) {
509         return _weiRaised;
510     }
511 
512     /**
513      * @return the amount of tokens sold.
514      */
515     function getSoldTokens() public view returns (uint256) {
516         return _tokensSold;
517     }
518 
519     /**
520      * @dev isInvestor check if the address is investor or not
521      */
522     function isInvestor(address sender) public view returns (bool) {
523         return _balances[sender].eth != 0 && _balances[sender].tokens != 0;
524     }
525 }
526 
527 // File: contracts/TimedCrowdsale.sol
528 
529 /**
530  * @title TimedCrowdsale
531  * @dev Crowdsale accepting contributions only within a time frame.
532  */
533 contract TimedCrowdsale is Crowdsale {
534     uint256 private _openingTime;
535     uint256 private _closingTime;
536 
537     /**
538      * @dev Reverts if not in crowdsale time range.
539      */
540     modifier onlyWhileOpen() {
541         require(isOpen(), "onlyWhileOpen: investor can call this method only when crowdsale is open.");
542         _;
543     }
544 
545     /**
546      * @dev Constructor, takes crowdsale opening and closing times.
547      * @param openingTime Crowdsale opening time
548      * @param closingTime Crowdsale closing time
549      */
550     constructor (
551         uint256 rate,
552         address token,
553         uint256 openingTime,
554         uint256 closingTime,
555         address payable operator,
556         uint256[] memory bonusFinishTimestamp,
557         uint256[] memory bonuses,
558         uint256 minInvestmentAmount,
559         uint256 fee
560         ) internal Crowdsale(rate, token, operator, bonusFinishTimestamp, bonuses, minInvestmentAmount, fee) {
561         if (bonusFinishTimestamp.length > 0) {
562             require(bonusFinishTimestamp[0] >= openingTime, "TimedCrowdsale: the opening time is smaller then the first bonus timestamp.");
563             require(bonusFinishTimestamp[bonusFinishTimestamp.length - 1] <= closingTime, "TimedCrowdsale: the closing time is smaller then the last bonus timestamp.");
564         }
565 
566         _openingTime = openingTime;
567         _closingTime = closingTime;
568     }
569 
570     // -----------------------------------------
571     // INTERNAL
572     // -----------------------------------------
573 
574     /**
575      * @dev Extend parent behavior requiring to be within contributing period
576      * @param beneficiary Token purchaser
577      * @param weiAmount Amount of wei contributed
578      */
579     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
580         super._preValidatePurchase(beneficiary, weiAmount);
581     }
582 
583     // -----------------------------------------
584     // EXTERNAL
585     // -----------------------------------------
586 
587     /**
588      * @dev refund the investments to investor while crowdsale is open
589      */
590     function refundETH() external onlyWhileOpen {
591         require(isInvestor(msg.sender), "refundETH: only the active investors can call this method.");
592 
593         uint256 weiAmount = _balances[msg.sender].eth;
594         uint256 tokensAmount = _balances[msg.sender].tokens;
595 
596         _balances[msg.sender].eth = 0;
597         _balances[msg.sender].tokens = 0;
598 
599         if (_balances[msg.sender].refunded == false) {
600             _balances[msg.sender].refunded = true;
601         }
602 
603         _weiRaised = _weiRaised.sub(weiAmount);
604         _tokensSold = _tokensSold.sub(tokensAmount);
605 
606         msg.sender.transfer(weiAmount);
607 
608         emit Refunded(msg.sender, weiAmount);
609     }
610 
611     // -----------------------------------------
612     // GETTERS
613     // -----------------------------------------
614 
615     /**
616      * @return the crowdsale opening time.
617      */
618     function getOpeningTime() public view returns (uint256) {
619         return _openingTime;
620     }
621 
622     /**
623      * @return the crowdsale closing time.
624      */
625     function getClosingTime() public view returns (uint256) {
626         return _closingTime;
627     }
628 
629     /**
630      * @return true if the crowdsale is open, false otherwise.
631      */
632     function isOpen() public view returns (bool) {
633         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
634     }
635 
636     /**
637      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
638      * @return Whether crowdsale period has elapsed
639      */
640     function hasClosed() public view returns (bool) {
641         return block.timestamp > _closingTime;
642     }
643 }
644 
645 // File: contracts/ResponsibleCrowdsale.sol
646 
647 /**
648  * @title ResponsibleCrowdsale
649  * @dev Main crowdsale contract
650  */
651 contract ResponsibleCrowdsale is TimedCrowdsale {
652     uint256 private _cycleId;
653     uint256 private _milestoneId;
654     uint256 private constant _timeForDisputs = 3 days;
655 
656     uint256 private _allCyclesTokensPercent;
657     uint256 private _allCyclesEthPercent;
658 
659     bool private _operatorTransferedTokens;
660 
661     enum MilestoneStatus { PENDING, DISPUTS_PERIOD, APPROVED }
662     enum InvestorDisputeState { NO_DISPUTES, SUBMITTED, CLOSED, WINNED }
663 
664     struct Cycle {
665         uint256 tokenPercent;
666         uint256 ethPercent;
667         bytes32[] milestones;
668     }
669 
670     struct Dispute {
671         uint256 activeDisputes;
672         address[] winnedAddressList;
673         mapping (address => InvestorDisputeState) investorDispute;
674     }
675 
676     struct Milestone {
677         bytes32 name;
678         uint256 startTimestamp;
679         uint256 disputesOpeningTimestamp;
680         uint256 cycleId;
681         uint256 tokenPercent;
682         uint256 ethPercent;
683         Dispute disputes;
684         bool operatorWasWithdrawn;
685         bool validHash;
686         mapping (address => bool) userWasWithdrawn;
687     }
688 
689     // Mapping of circes by id
690     mapping (uint256 => Cycle) private _cycles;
691 
692     // Mapping of milestones with order
693     mapping (uint256 => bytes32) private _milestones;
694 
695     // Get detail of each milestone by Hash
696     mapping (bytes32 => Milestone) private _milestoneDetails;
697 
698     event MilestoneInvestmentsWithdrawn(bytes32 indexed milestoneHash, uint256 weiAmount, uint256 tokensAmount);
699     event MilestoneResultWithdrawn(bytes32 indexed milestoneHash, address indexed investor, uint256 weiAmount, uint256 tokensAmount);
700 
701     constructor (
702         uint256 rate,
703         address token,
704         uint256 openingTime,
705         uint256 closingTime,
706         address payable operator,
707         uint256[] memory bonusFinishTimestamp,
708         uint256[] memory bonuses,
709         uint256 minInvestmentAmount,
710         uint256 fee
711     )
712         public TimedCrowdsale(rate, token, openingTime, closingTime, operator, bonusFinishTimestamp, bonuses, minInvestmentAmount, fee)
713     {}
714 
715     // -----------------------------------------
716     // OPERATOR FEATURES
717     // -----------------------------------------
718 
719     function addCycle(
720         uint256 tokenPercent,
721         uint256 ethPercent,
722         bytes32[] memory milestonesNames,
723         uint256[] memory milestonesTokenPercent,
724         uint256[] memory milestonesEthPercent,
725         uint256[] memory milestonesStartTimestamps
726     )
727         public onlyOperator returns (bool)
728     {
729         // Checking incoming values
730         require(tokenPercent > 0 && tokenPercent <= 100, "addCycle: the Token percent of the cycle should be bigger then 0 and smaller then 100.");
731         require(ethPercent > 0 && ethPercent <= 100, "addCycle: the ETH percent of the cycle should be bigger then 0 and smaller then 100.");
732         require(milestonesNames.length > 0, "addCycle: the milestones length should be bigger than 0.");
733         require(milestonesTokenPercent.length == milestonesNames.length, "addCycle: the milestonesTokenPercent length should be equal to milestonesNames length.");
734         require(milestonesEthPercent.length == milestonesTokenPercent.length, "addCycle: the milestonesEthPercent length should be equal to milestonesTokenPercent length.");
735         require(milestonesStartTimestamps.length == milestonesEthPercent.length, "addCycle: the milestonesFinishTimestamps length should be equal to milestonesEthPercent length.");
736 
737         // Checking the calculated amount of percentages of all cycles
738         require(_allCyclesTokensPercent + tokenPercent <= 100, "addCycle: the calculated amount of token percents is bigger then 100.");
739         require(_allCyclesEthPercent + ethPercent <= 100, "addCycle: the calculated amount of eth percents is bigger then 100.");
740 
741         _cycles[_cycleId] = Cycle(
742             tokenPercent,
743             ethPercent,
744             new bytes32[](0)
745         );
746 
747         uint256 allMilestonesTokensPercent;
748         uint256 allMilestonesEthPercent;
749 
750         for (uint256 i = 0; i < milestonesNames.length; i++) {
751             // checking if the percentages (token/eth) in this milestones is bigger then 0 and smaller/equal to 100
752             require(milestonesTokenPercent[i] > 0 && milestonesTokenPercent[i] <= 100, "addCycle: the token percent of milestone should be bigger then 0 and smaller from 100.");
753             require(milestonesEthPercent[i] > 0 && milestonesEthPercent[i] <= 100, "addCycle: the ETH percent of milestone should be bigger then 0 and smaller from 100.");
754 
755             if (i == 0 && _milestoneId == 0) {
756                 // checking the first milestone of the first cycle
757                 require(milestonesStartTimestamps[i] > getClosingTime(), "addCycle: the first milestone timestamp should be bigger then crowdsale closing time.");
758                 require(milestonesTokenPercent[i] <= 25 && milestonesEthPercent[i] <= 25, "addCycle: for security reasons for the first milestone the operator can withdraw only less than 25 percent of investments.");
759             } else if (i == 0 && _milestoneId > 0) {
760                 // checking if the first milestone starts after the last milestone of the previous cycle
761                 uint256 previousCycleLastMilestoneStartTimestamp =  _milestoneDetails[_milestones[_milestoneId - 1]].startTimestamp;
762                 require(milestonesStartTimestamps[i] > previousCycleLastMilestoneStartTimestamp, "addCycle: the first timestamp of this milestone should be bigger then his previus milestons last timestamp.");
763                 require(milestonesStartTimestamps[i] >= block.timestamp + _timeForDisputs, "addCycle: the second cycle should be start a minimum 3 days after this transaction.");
764             } else if (i != 0) {
765                 // checking if the each next milestone finish timestamp is bigger than his previous one finish timestamp
766                 require(milestonesStartTimestamps[i] > milestonesStartTimestamps[i - 1], "addCycle: each timestamp should be bigger then his previus one.");
767             }
768 
769             // generating the unique hash for each milestone
770             bytes32 hash = _generateHash(
771                 milestonesNames[i],
772                 milestonesStartTimestamps[i]
773             );
774 
775             // before starting the next milestone investors can open disputes within 3 days
776             uint256 disputesOpeningTimestamp = milestonesStartTimestamps[i] - _timeForDisputs;
777 
778             // The first milestone of the first cycle can not have disputes
779             if (i == 0 && _milestoneId == 0) {
780                 disputesOpeningTimestamp = milestonesStartTimestamps[i];
781             }
782 
783             // updating the state
784             _cycles[_cycleId].milestones.push(hash);
785             _milestones[i + _milestoneId] = hash;
786             _milestoneDetails[hash] = Milestone(
787                 milestonesNames[i],                 // Milestone name
788                 milestonesStartTimestamps[i],       // Milestone finish timestamp
789                 disputesOpeningTimestamp,           // Miliestone submit timestamp (it will be updated once when operator calls the submit milestone method)
790                 _cycleId,                           // cycle Id for detecting token and eth percent for this cycle
791                 milestonesTokenPercent[i],          // Token percent of this milestone
792                 milestonesEthPercent[i],            // ETH percent of this milestone
793                 Dispute(0, new address[](0)),       // Disputs state initialization
794                 false,                              // Operator does not withdrawn this milestone investments yet
795                 true                                // Milestone hash is valid
796             );
797 
798             allMilestonesTokensPercent += milestonesTokenPercent[i];
799             allMilestonesEthPercent += milestonesEthPercent[i];
800         }
801 
802         // checking if the calculated amount of all percentages (token/eth) in this milestones equal to 100
803         require(allMilestonesTokensPercent == 100, "addCycle: the calculated amount of Token percent should be equal to 100.");
804         require(allMilestonesEthPercent == 100, "addCycle: the calculated amount of ETH percent should be equal to 100.");
805 
806         _allCyclesTokensPercent += tokenPercent;
807         _allCyclesEthPercent += ethPercent;
808 
809         _cycleId++;
810         _milestoneId += milestonesNames.length;
811 
812         return true;
813     }
814 
815     function collectMilestoneInvestment(bytes32 hash) public onlyOperator {
816         require(_milestoneDetails[hash].validHash, "collectMilestoneInvestment: the milestone hash is not valid.");
817         require(_milestoneDetails[hash].operatorWasWithdrawn == false, "collectMilestoneInvestment: the operator already withdrawn his funds.");
818         require(getMilestoneStatus(hash) == MilestoneStatus.APPROVED, "collectMilestoneInvestment: the time for collecting funds is not started yet.");
819         require(isMilestoneHasActiveDisputes(hash) == false, "collectMilestoneInvestment: the milestone has unsolved disputes.");
820         require(_hadOperatorTransferredTokens(), "collectMilestoneInvestment: the operator need to transfer sold tokens to this contract for receiving investments.");
821 
822         _milestoneDetails[hash].operatorWasWithdrawn = true;
823 
824         uint256 milestoneRefundedTokens;
825         uint256 milestoneInvestmentWei = _calculateEthAmountByMilestone(getRaisedWei(), hash);
826         uint256 winnedDisputesAmount = _milestoneDetails[hash].disputes.winnedAddressList.length;
827 
828         if (winnedDisputesAmount > 0) {
829             for (uint256 i = 0; i < winnedDisputesAmount; i++) {
830                 address winnedInvestor = _milestoneDetails[hash].disputes.winnedAddressList[i];
831 
832                 uint256 investorWeiForMilestone = _calculateEthAmountByMilestone(_balances[winnedInvestor].eth, hash);
833                 uint256 investorTokensForMilestone = _calculateTokensAmountByMilestone(_balances[winnedInvestor].tokens, hash);
834 
835                 milestoneInvestmentWei = milestoneInvestmentWei.sub(investorWeiForMilestone);
836                 milestoneRefundedTokens = milestoneRefundedTokens.add(investorTokensForMilestone);
837             }
838         }
839 
840         _withdrawEther(operator(), milestoneInvestmentWei);
841 
842         if (milestoneRefundedTokens != 0) {
843             _withdrawTokens(operator(), milestoneRefundedTokens);
844         }
845 
846         emit MilestoneInvestmentsWithdrawn(hash, milestoneInvestmentWei, milestoneRefundedTokens);
847     }
848 
849     // -----------------------------------------
850     // DISPUTS FEATURES
851     // -----------------------------------------
852 
853     function openDispute(bytes32 hash, address investor) external onlyCluster returns (bool) {
854         _milestoneDetails[hash].disputes.investorDispute[investor] = InvestorDisputeState.SUBMITTED;
855         _milestoneDetails[hash].disputes.activeDisputes++;
856         return true;
857     }
858 
859     function solveDispute(bytes32 hash, address investor, bool investorWins) external onlyCluster {
860         require(isMilestoneHasActiveDisputes(hash) == true, "solveDispute: no active disputs available.");
861 
862         if (investorWins == true) {
863             _milestoneDetails[hash].disputes.investorDispute[investor] = InvestorDisputeState.WINNED;
864             _milestoneDetails[hash].disputes.winnedAddressList.push(investor);
865         } else {
866             _milestoneDetails[hash].disputes.investorDispute[investor] = InvestorDisputeState.CLOSED;
867         }
868 
869         _milestoneDetails[hash].disputes.activeDisputes--;
870     }
871 
872     // -----------------------------------------
873     // INVESTOR FEATURES
874     // -----------------------------------------
875 
876     function collectMilestoneResult(bytes32 hash) public {
877         require(isInvestor(msg.sender), "collectMilestoneResult: only the active investors can call this method.");
878         require(_milestoneDetails[hash].validHash, "collectMilestoneResult: the milestone hash is not valid.");
879         require(getMilestoneStatus(hash) == MilestoneStatus.APPROVED, "collectMilestoneResult: the time for collecting funds is not started yet.");
880         require(didInvestorWithdraw(hash, msg.sender) == false, "collectMilestoneResult: the investor already withdrawn his tokens.");
881         require(_milestoneDetails[hash].disputes.investorDispute[msg.sender] != InvestorDisputeState.SUBMITTED, "collectMilestoneResult: the investor has unsolved disputes.");
882         require(_hadOperatorTransferredTokens(), "collectMilestoneInvestment: the operator need to transfer sold tokens to this contract for receiving investments.");
883 
884         _milestoneDetails[hash].userWasWithdrawn[msg.sender] = true;
885 
886         uint256 investorBalance;
887         uint256 tokensToSend;
888         uint256 winnedWeis;
889 
890         if (_milestoneDetails[hash].disputes.investorDispute[msg.sender] != InvestorDisputeState.WINNED) {
891             investorBalance = _balances[msg.sender].tokens;
892             tokensToSend = _calculateTokensAmountByMilestone(investorBalance, hash);
893 
894             // transfering tokens to investor
895             _withdrawTokens(msg.sender, tokensToSend);
896             _balances[msg.sender].withdrawnTokens += tokensToSend;
897         } else {
898             investorBalance = _balances[msg.sender].eth;
899             winnedWeis = _calculateEthAmountByMilestone(investorBalance, hash);
900 
901             // transfering disputs ETH investor
902             _withdrawEther(msg.sender, winnedWeis);
903             _balances[msg.sender].withdrawnEth += winnedWeis;
904         }
905 
906         emit MilestoneResultWithdrawn(hash, msg.sender, winnedWeis, tokensToSend);
907     }
908 
909     // -----------------------------------------
910     // INTERNAL
911     // -----------------------------------------
912 
913     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
914         require(_cycleId > 0, "_preValidatePurchase: the cycles/milestones is not setted.");
915         super._preValidatePurchase(beneficiary, weiAmount);
916     }
917 
918     function _generateHash(bytes32 name, uint256 timestamp) private view returns (bytes32) {
919         // generating the unique hash for milestone using the name, start timestamp and the address of this crowdsale
920         return keccak256(abi.encodePacked(name, timestamp, address(this)));
921     }
922 
923     function _calculateEthAmountByMilestone(uint256 weiAmount, bytes32 milestone) private view returns (uint256) {
924         uint256 cycleId = _milestoneDetails[milestone].cycleId;
925         uint256 cyclePercent = _cycles[cycleId].ethPercent;
926         uint256 milestonePercent = _milestoneDetails[milestone].ethPercent;
927 
928         uint256 amount = _calculatePercent(milestonePercent, _calculatePercent(weiAmount, cyclePercent));
929         return amount;
930     }
931 
932     function _calculateTokensAmountByMilestone(uint256 tokens, bytes32 milestone) private view returns (uint256) {
933         uint256 cycleId = _milestoneDetails[milestone].cycleId;
934         uint256 cyclePercent = _cycles[cycleId].tokenPercent;
935         uint256 milestonePercent = _milestoneDetails[milestone].tokenPercent;
936 
937         uint256 amount = _calculatePercent(milestonePercent, _calculatePercent(tokens, cyclePercent));
938         return amount;
939     }
940 
941     function _hadOperatorTransferredTokens() private returns (bool) {
942         // the first time when the investor/operator want to withdraw the funds
943         if (_token.balanceOf(address(this)) == getSoldTokens()) {
944             _operatorTransferedTokens = true;
945             return true;
946         } else if (_operatorTransferedTokens == true) {
947             return true;
948         } else {
949             return false;
950         }
951     }
952 
953     // -----------------------------------------
954     // GETTERS
955     // -----------------------------------------
956 
957     function getCyclesAmount() external view returns (uint256) {
958         return _cycleId;
959     }
960 
961     function getCycleDetails(uint256 cycleId) external view returns (uint256, uint256, bytes32[] memory) {
962         return (
963             _cycles[cycleId].tokenPercent,
964             _cycles[cycleId].ethPercent,
965             _cycles[cycleId].milestones
966         );
967     }
968 
969     function getMilestonesHashes() external view returns (bytes32[] memory milestonesHashArray) {
970         milestonesHashArray = new bytes32[](_milestoneId);
971 
972         for (uint256 i = 0; i < _milestoneId; i++) {
973             milestonesHashArray[i] = _milestones[i];
974         }
975 
976         return milestonesHashArray;
977     }
978 
979     function getMilestoneDetails(bytes32 hash) external view returns (bytes32, uint256, uint256, uint256, uint256, uint256, uint256, MilestoneStatus status) {
980         Milestone memory mil = _milestoneDetails[hash];
981         status = getMilestoneStatus(hash);
982         return (
983             mil.name,
984             mil.startTimestamp,
985             mil.disputesOpeningTimestamp,
986             mil.cycleId,
987             mil.tokenPercent,
988             mil.ethPercent,
989             mil.disputes.activeDisputes,
990             status
991         );
992     }
993 
994     function getMilestoneStatus(bytes32 hash) public view returns (MilestoneStatus status) {
995         // checking if the time for collecting milestone funds was comes
996         if (block.timestamp >= _milestoneDetails[hash].startTimestamp) {
997             return MilestoneStatus.APPROVED;
998         } else if (block.timestamp > _milestoneDetails[hash].disputesOpeningTimestamp) {
999                 return MilestoneStatus.DISPUTS_PERIOD;
1000         } else {
1001             return MilestoneStatus.PENDING;
1002         }
1003     }
1004 
1005     function getCycleTotalPercents() external view returns (uint256, uint256) {
1006         return (
1007             _allCyclesTokensPercent,
1008             _allCyclesEthPercent
1009         );
1010     }
1011 
1012     function canInvestorOpenNewDispute(bytes32 hash, address investor) public view returns (bool) {
1013         InvestorDisputeState state = _milestoneDetails[hash].disputes.investorDispute[investor];
1014         return state == InvestorDisputeState.NO_DISPUTES || state == InvestorDisputeState.CLOSED;
1015     }
1016 
1017     function isMilestoneHasActiveDisputes(bytes32 hash) public view returns (bool) {
1018         return _milestoneDetails[hash].disputes.activeDisputes > 0;
1019     }
1020 
1021     function didInvestorOpenedDisputeBefore(bytes32 hash, address investor) public view returns (bool) {
1022         return _milestoneDetails[hash].disputes.investorDispute[investor] != InvestorDisputeState.NO_DISPUTES;
1023     }
1024 
1025     function didInvestorWithdraw(bytes32 hash, address investor) public view returns (bool) {
1026         return _milestoneDetails[hash].userWasWithdrawn[investor];
1027     }
1028 }
1029 
1030 // File: contracts/deployers/CrowdsaleDeployer.sol
1031 
1032 library CrowdsaleDeployer {
1033     function addCrowdsale(
1034         uint256 rate,
1035         address token,
1036         uint256 openingTime,
1037         uint256 closingTime,
1038         address payable operator,
1039         uint256[] calldata bonusFinishTimestamp,
1040         uint256[] calldata bonuses,
1041         uint256 minInvestmentAmount,
1042         uint256 fee
1043         ) external returns (address) {
1044          return address(new ResponsibleCrowdsale(rate, token, openingTime, closingTime, operator, bonusFinishTimestamp, bonuses, minInvestmentAmount, fee));
1045     }
1046 }
1047 
1048 // ---------------------------------------------------------------------------
1049 // ARBITERS POOL
1050 // ---------------------------------------------------------------------------
1051 
1052 // File: contracts/ownerships/Roles.sol
1053 
1054 library Roles {
1055     struct Role {
1056         mapping (address => bool) bearer;
1057     }
1058 
1059     /**
1060      * @dev give an account access to this role
1061      */
1062     function add(Role storage role, address account) internal {
1063         require(account != address(0));
1064         require(!has(role, account));
1065 
1066         role.bearer[account] = true;
1067     }
1068 
1069     /**
1070      * @dev remove an account's access to this role
1071      */
1072     function remove(Role storage role, address account) internal {
1073         require(account != address(0));
1074         require(has(role, account));
1075 
1076         role.bearer[account] = false;
1077     }
1078 
1079     /**
1080      * @dev check if an account has this role
1081      * @return bool
1082      */
1083     function has(Role storage role, address account) internal view returns (bool) {
1084         require(account != address(0));
1085         return role.bearer[account];
1086     }
1087 }
1088 
1089 // File: contracts/ownerships/ArbiterRole.sol
1090 
1091 contract ArbiterRole is ClusterRole {
1092     using Roles for Roles.Role;
1093 
1094     uint256 private _arbitersAmount;
1095 
1096     event ArbiterAdded(address indexed arbiter);
1097     event ArbiterRemoved(address indexed arbiter);
1098 
1099     Roles.Role private _arbiters;
1100 
1101     modifier onlyArbiter() {
1102         require(isArbiter(msg.sender), "onlyArbiter: only arbiter can call this method.");
1103         _;
1104     }
1105 
1106     // -----------------------------------------
1107     // EXTERNAL
1108     // -----------------------------------------
1109 
1110     function addArbiter(address arbiter) public onlyCluster {
1111         _addArbiter(arbiter);
1112         _arbitersAmount++;
1113     }
1114 
1115     function removeArbiter(address arbiter) public onlyCluster {
1116         _removeArbiter(arbiter);
1117         _arbitersAmount--;
1118     }
1119 
1120     // -----------------------------------------
1121     // INTERNAL
1122     // -----------------------------------------
1123 
1124     function _addArbiter(address arbiter) private {
1125         _arbiters.add(arbiter);
1126         emit ArbiterAdded(arbiter);
1127     }
1128 
1129     function _removeArbiter(address arbiter) private {
1130         _arbiters.remove(arbiter);
1131         emit ArbiterRemoved(arbiter);
1132     }
1133 
1134     // -----------------------------------------
1135     // GETTERS
1136     // -----------------------------------------
1137 
1138     function isArbiter(address account) public view returns (bool) {
1139         return _arbiters.has(account);
1140     }
1141 
1142     function getArbitersAmount() external view returns (uint256) {
1143         return _arbitersAmount;
1144     }
1145 }
1146 
1147 // File: contracts/interfaces/ICluster.sol
1148 
1149 interface ICluster {
1150     function withdrawEth() external;
1151 
1152     function addArbiter(address newArbiter) external;
1153 
1154     function removeArbiter(address arbiter) external;
1155 
1156     function addCrowdsale(
1157         uint256 rate,
1158         address token,
1159         uint256 openingTime,
1160         uint256 closingTime,
1161         address payable operator,
1162         uint256[] calldata bonusFinishTimestamp,
1163         uint256[] calldata bonuses,
1164         uint256 minInvestmentAmount,
1165         uint256 fee
1166     ) external returns (address);
1167 
1168     function emergencyExit(address crowdsale, address payable newContract) external;
1169 
1170     function openDispute(address crowdsale, bytes32 hash, string calldata reason) external payable returns (uint256);
1171 
1172     function solveDispute(address crowdsale, bytes32 hash, address investor, bool investorWins) external;
1173 
1174     function getArbitersPoolAddress() external view returns (address);
1175 
1176     function getAllCrowdsalesAddresses() external view returns (address[] memory crowdsales);
1177 
1178     function getCrowdsaleMilestones(address crowdsale) external view returns(bytes32[] memory milestonesHashArray);
1179 
1180     function getOperatorCrowdsaleAddresses(address operator) external view returns (address[] memory crowdsales);
1181 
1182     function owner() external view returns (address payable);
1183 
1184     function isOwner() external view returns (bool);
1185 
1186     function transferOwnership(address payable newOwner) external;
1187 
1188     function isBackEnd(address account) external view returns (bool);
1189 
1190     function addBackEnd(address account) external;
1191 
1192     function removeBackEnd(address account) external;
1193 }
1194 
1195 // File: contracts/ArbitersPool.sol
1196 
1197 contract ArbitersPool is ArbiterRole {
1198     uint256 private _disputsAmount;
1199     uint256 private constant _necessaryVoices = 3;
1200 
1201     enum DisputeStatus { WAITING, SOLVED }
1202     enum Choice { OPERATOR_WINS, INVESTOR_WINS }
1203 
1204     ICluster private _clusterInterface;
1205 
1206     struct Vote {
1207         address arbiter;
1208         Choice choice;
1209     }
1210 
1211     struct Dispute {
1212         address investor;
1213         address crowdsale;
1214         bytes32 milestoneHash;
1215         string reason;
1216         uint256 votesAmount;
1217         DisputeStatus status;
1218         mapping (address => bool) hasVoted;
1219         mapping (uint256 => Vote) choices;
1220     }
1221 
1222     mapping (uint256 => Dispute) private _disputesById;
1223     mapping (address => uint256[]) private _disputesByInvestor;
1224     mapping (bytes32 => uint256[]) private _disputesByMilestone;
1225 
1226     event Voted(uint256 indexed disputeId, address indexed arbiter, Choice choice);
1227     event NewDisputeCreated(uint256 disputeId, address indexed crowdsale, bytes32 indexed hash, address indexed investor);
1228     event DisputeSolved(uint256 disputeId, Choice choice, address indexed crowdsale, bytes32 indexed hash, address indexed investor);
1229 
1230     constructor () public {
1231         _clusterInterface = ICluster(msg.sender);
1232     }
1233 
1234     function createDispute(bytes32 milestoneHash, address crowdsale, address investor, string calldata reason) external onlyCluster returns (uint256) {
1235         Dispute memory dispute = Dispute(
1236             investor,
1237             crowdsale,
1238             milestoneHash,
1239             reason,
1240             0,
1241             DisputeStatus.WAITING
1242         );
1243 
1244         uint256 thisDisputeId = _disputsAmount;
1245         _disputsAmount++;
1246 
1247         _disputesById[thisDisputeId] = dispute;
1248         _disputesByMilestone[milestoneHash].push(thisDisputeId);
1249         _disputesByInvestor[investor].push(thisDisputeId);
1250 
1251         emit NewDisputeCreated(thisDisputeId, crowdsale, milestoneHash, investor);
1252 
1253         return thisDisputeId;
1254     }
1255 
1256     function voteDispute(uint256 id, Choice choice) public onlyArbiter {
1257         require(_disputsAmount > id, "voteDispute: invalid number of dispute.");
1258         require(_disputesById[id].hasVoted[msg.sender] == false, "voteDispute: arbiter was already voted.");
1259         require(_disputesById[id].status == DisputeStatus.WAITING, "voteDispute: dispute was already closed.");
1260         require(_disputesById[id].votesAmount < _necessaryVoices, "voteDispute: dispute was already voted and finished.");
1261 
1262         _disputesById[id].hasVoted[msg.sender] = true;
1263 
1264         // updating the votes amount
1265         _disputesById[id].votesAmount++;
1266 
1267         // storing info about this vote
1268         uint256 votesAmount = _disputesById[id].votesAmount;
1269         _disputesById[id].choices[votesAmount] = Vote(msg.sender, choice);
1270 
1271         // checking, if the second arbiter voted the same result with the 1st voted arbiter, then dispute will be solved without 3rd vote
1272         if (_disputesById[id].votesAmount == 2 && _disputesById[id].choices[0].choice == choice) {
1273             _executeDispute(id, choice);
1274         } else if (_disputesById[id].votesAmount == _necessaryVoices) {
1275             Choice winner = _calculateWinner(id);
1276             _executeDispute(id, winner);
1277         }
1278 
1279         emit Voted(id, msg.sender, choice);
1280     }
1281 
1282     // -----------------------------------------
1283     // INTERNAL
1284     // -----------------------------------------
1285 
1286     function _calculateWinner(uint256 id) private view returns (Choice choice) {
1287         uint256 votesForInvestor = 0;
1288         for (uint256 i = 0; i < _necessaryVoices; i++) {
1289             if (_disputesById[id].choices[i].choice == Choice.INVESTOR_WINS) {
1290                 votesForInvestor++;
1291             }
1292         }
1293 
1294         return votesForInvestor >= 2 ? Choice.INVESTOR_WINS : Choice.OPERATOR_WINS;
1295     }
1296 
1297     function _executeDispute(uint256 id, Choice choice) private {
1298         _disputesById[id].status = DisputeStatus.SOLVED;
1299         _clusterInterface.solveDispute(
1300             _disputesById[id].crowdsale,
1301             _disputesById[id].milestoneHash,
1302             _disputesById[id].investor,
1303             choice == Choice.INVESTOR_WINS
1304         );
1305 
1306         emit DisputeSolved(
1307             id,
1308             choice,
1309             _disputesById[id].crowdsale,
1310             _disputesById[id].milestoneHash,
1311             _disputesById[id].investor
1312         );
1313     }
1314 
1315     // -----------------------------------------
1316     // GETTERS
1317     // -----------------------------------------
1318 
1319     function getDisputesAmount() external view returns (uint256) {
1320         return _disputsAmount;
1321     }
1322 
1323     function getDisputeDetails(uint256 id) external view returns (bytes32, address, address, string memory, uint256, DisputeStatus status) {
1324         Dispute memory dispute = _disputesById[id];
1325         return (
1326             dispute.milestoneHash,
1327             dispute.crowdsale,
1328             dispute.investor,
1329             dispute.reason,
1330             dispute.votesAmount,
1331             dispute.status
1332         );
1333     }
1334 
1335     function getMilestoneDisputes(bytes32 hash) external view returns (uint256[] memory disputesIDs) {
1336         uint256 disputesLength = _disputesByMilestone[hash].length;
1337         disputesIDs = new uint256[](disputesLength);
1338 
1339         for (uint256 i = 0; i < disputesLength; i++) {
1340             disputesIDs[i] = _disputesByMilestone[hash][i];
1341         }
1342 
1343         return disputesIDs;
1344     }
1345 
1346     function getInvestorDisputes(address investor) external view returns (uint256[] memory disputesIDs) {
1347         uint256 disputesLength = _disputesByInvestor[investor].length;
1348         disputesIDs = new uint256[](disputesLength);
1349 
1350         for (uint256 i = 0; i < disputesLength; i++) {
1351             disputesIDs[i] = _disputesByInvestor[investor][i];
1352         }
1353 
1354         return disputesIDs;
1355     }
1356 
1357     function getDisputeVotes(uint256 id) external view returns(address[] memory arbiters, Choice[] memory choices) {
1358         uint256 votedArbitersAmount = _disputesById[id].votesAmount;
1359         arbiters = new address[](votedArbitersAmount);
1360         choices = new Choice[](votedArbitersAmount);
1361 
1362         for (uint256 i = 0; i < votedArbitersAmount; i++) {
1363             arbiters[i] = _disputesById[id].choices[i].arbiter;
1364             choices[i] = _disputesById[id].choices[i].choice;
1365         }
1366 
1367         return (
1368             arbiters,
1369             choices
1370         );
1371     }
1372 
1373     function hasDisputeSolved(uint256 id) external view returns (bool) {
1374         return _disputesById[id].status == DisputeStatus.SOLVED;
1375     }
1376 
1377     function hasArbiterVoted(uint256 id, address arbiter) external view returns (bool) {
1378         return _disputesById[id].hasVoted[arbiter];
1379     }
1380 }
1381 
1382 // ---------------------------------------------------------------------------
1383 // CLUSTER CONTRACT
1384 // ---------------------------------------------------------------------------
1385 
1386 // File: contracts/interfaces/IArbitersPool.sol
1387 
1388 interface IArbitersPool {
1389     enum DisputeStatus { WAITING, SOLVED }
1390     enum Choice { OPERATOR_WINS, INVESTOR_WINS }
1391 
1392     function createDispute(bytes32 milestoneHash, address crowdsale, address investor, string calldata reason) external returns (uint256);
1393 
1394     function voteDispute(uint256 id, Choice choice) external;
1395 
1396     function addArbiter(address newArbiter) external;
1397 
1398     function renounceArbiter(address arbiter) external;
1399 
1400     function getDisputesAmount() external view returns (uint256);
1401 
1402     function getDisputeDetails(uint256 id) external view returns (bytes32, address, address, string memory, uint256, DisputeStatus status);
1403 
1404     function getMilestoneDisputes(bytes32 hash) external view returns (uint256[] memory disputesIDs);
1405 
1406     function getInvestorDisputes(address investor) external view returns (uint256[] memory disputesIDs);
1407 
1408     function getDisputeVotes(uint256 id) external view returns(address[] memory arbiters, Choice[] memory choices);
1409 
1410     function getArbitersAmount() external view returns (uint256);
1411 
1412     function isArbiter(address account) external view returns (bool);
1413 
1414     function hasDisputeSolved(uint256 id) external view returns (bool);
1415 
1416     function hasArbiterVoted(uint256 id, address arbiter) external view returns (bool);
1417 
1418     function cluster() external view returns (address payable);
1419 
1420     function isCluster() external view returns (bool);
1421 }
1422 
1423 // File: contracts/interfaces/IRICO.sol
1424 
1425 interface IRICO {
1426     enum MilestoneStatus { PENDING, DISPUTS_PERIOD, APPROVED }
1427 
1428     function addCycle(
1429         uint256 tokenPercent,
1430         uint256 ethPercent,
1431         bytes32[] calldata milestonesNames,
1432         uint256[] calldata milestonesTokenPercent,
1433         uint256[] calldata milestonesEthPercent,
1434         uint256[] calldata milestonesStartTimestamps
1435     ) external returns (bool);
1436 
1437     function collectMilestoneInvestment(bytes32 hash) external;
1438 
1439     function collectMilestoneResult(bytes32 hash) external;
1440 
1441     function getCyclesAmount() external view returns (uint256);
1442 
1443     function getCycleDetails(uint256 cycleId) external view returns (uint256, uint256, bytes32[] memory);
1444 
1445     function getMilestonesHashes() external view returns (bytes32[] memory milestonesHashArray);
1446 
1447     function getMilestoneDetails(bytes32 hash) external view returns (bytes32, uint256, uint256, uint256, uint256, uint256, uint256, MilestoneStatus status);
1448 
1449     function getMilestoneStatus(bytes32 hash) external view returns (MilestoneStatus status);
1450 
1451     function getCycleTotalPercents() external view returns (uint256, uint256);
1452 
1453     function canInvestorOpenNewDispute(bytes32 hash, address investor) external view returns (bool);
1454 
1455     function isMilestoneHasActiveDisputes(bytes32 hash) external view returns (bool);
1456 
1457     function didInvestorOpenedDisputeBefore(bytes32 hash, address investor) external view returns (bool);
1458 
1459     function didInvestorWithdraw(bytes32 hash, address investor) external view returns (bool);
1460 
1461     function buyTokens(address beneficiary) external payable;
1462 
1463     function isInvestor(address sender) external view returns (bool);
1464 
1465     function openDispute(bytes32 hash, address investor) external returns (bool);
1466 
1467     function solveDispute(bytes32 hash, address investor, bool investorWins) external;
1468 
1469     function emergencyExit(address payable newContract) external;
1470 
1471     function getCrowdsaleDetails() external view returns (uint256, address, uint256, uint256, uint256[] memory finishTimestamps, uint256[] memory bonuses);
1472 
1473     function getInvestorBalances(address investor) external view returns (uint256, uint256, uint256, uint256, bool);
1474 
1475     function getInvestorsArray() external view returns (address[] memory investors);
1476 
1477     function getRaisedWei() external view returns (uint256);
1478 
1479     function getSoldTokens() external view returns (uint256);
1480 
1481     function refundETH() external;
1482 
1483     function getOpeningTime() external view returns (uint256);
1484 
1485     function getClosingTime() external view returns (uint256);
1486 
1487     function isOpen() external view returns (bool);
1488 
1489     function hasClosed() external view returns (bool);
1490 
1491     function cluster() external view returns (address payable);
1492 
1493     function isCluster() external view returns (bool);
1494 
1495     function operator() external view returns (address payable);
1496 
1497     function isOperator() external view returns (bool);
1498 }
1499 
1500 // File: contracts/ownerships/Ownable.sol
1501 
1502 contract Ownable {
1503     address payable private _owner;
1504 
1505     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1506 
1507     /**
1508      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1509      * account.
1510      */
1511     constructor () internal {
1512         _owner = msg.sender;
1513         emit OwnershipTransferred(address(0), _owner);
1514     }
1515 
1516     /**
1517      * @return the address of the owner.
1518      */
1519     function owner() public view returns (address payable) {
1520         return _owner;
1521     }
1522 
1523     /**
1524      * @dev Throws if called by any account other than the owner.
1525      */
1526     modifier onlyOwner() {
1527         require(isOwner(), "onlyOwner: only the owner can call this method.");
1528         _;
1529     }
1530 
1531     /**
1532      * @return true if `msg.sender` is the owner of the contract.
1533      */
1534     function isOwner() public view returns (bool) {
1535         return msg.sender == _owner;
1536     }
1537 
1538     /**
1539      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1540      * @param newOwner The address to transfer ownership to.
1541      */
1542     function transferOwnership(address payable newOwner) public onlyOwner {
1543         _transferOwnership(newOwner);
1544     }
1545 
1546     /**
1547      * @dev Transfers control of the contract to a newOwner.
1548      * @param newOwner The address to transfer ownership to.
1549      */
1550     function _transferOwnership(address payable newOwner) private {
1551         require(newOwner != address(0), "_transferOwnership: the address of new operator is not valid.");
1552         emit OwnershipTransferred(_owner, newOwner);
1553         _owner = newOwner;
1554     }
1555 }
1556 
1557 // File: contracts/ownerships/BackEndRole.sol
1558 
1559 contract BackEndRole is Ownable {
1560     using Roles for Roles.Role;
1561 
1562     event BackEndAdded(address indexed account);
1563     event BackEndRemoved(address indexed account);
1564 
1565     Roles.Role private _backEnds;
1566 
1567     modifier onlyBackEnd() {
1568         require(isBackEnd(msg.sender), "onlyBackEnd: only back end address can call this method.");
1569         _;
1570     }
1571 
1572     function isBackEnd(address account) public view returns (bool) {
1573         return _backEnds.has(account);
1574     }
1575 
1576     function addBackEnd(address account) public onlyOwner {
1577         _addBackEnd(account);
1578     }
1579 
1580     function removeBackEnd(address account) public onlyOwner {
1581         _removeBackEnd(account);
1582     }
1583 
1584     function _addBackEnd(address account) private {
1585         _backEnds.add(account);
1586         emit BackEndAdded(account);
1587     }
1588 
1589     function _removeBackEnd(address account) private {
1590         _backEnds.remove(account);
1591         emit BackEndRemoved(account);
1592     }
1593 }
1594 
1595 // File: contracts/Cluster.sol
1596 
1597 contract Cluster is BackEndRole {
1598     uint256 private constant _feeForMoreDisputes = 1 ether;
1599 
1600     address private _arbitersPoolAddress;
1601     address[] private _crowdsales;
1602 
1603     mapping (address => address[]) private _operatorsContracts;
1604 
1605     IArbitersPool private _arbitersPool;
1606 
1607     event WeiFunded(address indexed sender, uint256 indexed amount);
1608     event CrowdsaleCreated(
1609         address crowdsale,
1610         uint256 rate,
1611         address token,
1612         uint256 openingTime,
1613         uint256 closingTime,
1614         address operator,
1615         uint256[] bonusFinishTimestamp,
1616         uint256[] bonuses,
1617         uint256 minInvestmentAmount,
1618         uint256 fee
1619     );
1620 
1621     // -----------------------------------------
1622     // CONSTRUCTOR
1623     // -----------------------------------------
1624 
1625     constructor () public {
1626         _arbitersPoolAddress = address(new ArbitersPool());
1627         _arbitersPool = IArbitersPool(_arbitersPoolAddress);
1628     }
1629 
1630     function() external payable {
1631         emit WeiFunded(msg.sender, msg.value);
1632     }
1633 
1634     // -----------------------------------------
1635     // OWNER FEATURES
1636     // -----------------------------------------
1637 
1638     function withdrawEth() external onlyOwner {
1639         owner().transfer(address(this).balance);
1640     }
1641 
1642     function addArbiter(address newArbiter) external onlyBackEnd {
1643         require(newArbiter != address(0), "addArbiter: invalid type of address.");
1644 
1645         _arbitersPool.addArbiter(newArbiter);
1646     }
1647 
1648     function removeArbiter(address arbiter) external onlyBackEnd {
1649         require(arbiter != address(0), "removeArbiter: invalid type of address.");
1650 
1651         _arbitersPool.renounceArbiter(arbiter);
1652     }
1653 
1654     function addCrowdsale(
1655         uint256 rate,
1656         address token,
1657         uint256 openingTime,
1658         uint256 closingTime,
1659         address payable operator,
1660         uint256[] calldata bonusFinishTimestamp,
1661         uint256[] calldata bonuses,
1662         uint256 minInvestmentAmount,
1663         uint256 fee
1664         ) external onlyBackEnd returns (address) {
1665         require(rate != 0, "addCrowdsale: the rate should be bigger then 0.");
1666         require(token != address(0), "addCrowdsale: invalid token address.");
1667         require(openingTime >= block.timestamp, "addCrowdsale: invalid opening time.");
1668         require(closingTime > openingTime, "addCrowdsale: invalid closing time.");
1669         require(operator != address(0), "addCrowdsale: the address of operator is not valid.");
1670         require(bonusFinishTimestamp.length == bonuses.length, "addCrowdsale: the length of bonusFinishTimestamp and bonuses is not equal.");
1671 
1672         address crowdsale = CrowdsaleDeployer.addCrowdsale(
1673             rate,
1674             token,
1675             openingTime,
1676             closingTime,
1677             operator,
1678             bonusFinishTimestamp,
1679             bonuses,
1680             minInvestmentAmount,
1681             fee
1682         );
1683 
1684         // Updating the state
1685         _crowdsales.push(crowdsale);
1686         _operatorsContracts[operator].push(crowdsale);
1687 
1688         emit CrowdsaleCreated(
1689             crowdsale,
1690             rate,
1691             token,
1692             openingTime,
1693             closingTime,
1694             operator,
1695             bonusFinishTimestamp,
1696             bonuses,
1697             minInvestmentAmount,
1698             fee
1699         );
1700         return crowdsale;
1701     }
1702 
1703     // -----------------------------------------
1704     // OPERATOR FEATURES
1705     // -----------------------------------------
1706 
1707     function emergencyExit(address crowdsale, address payable newContract) external onlyOwner {
1708         IRICO(crowdsale).emergencyExit(newContract);
1709     }
1710 
1711     // -----------------------------------------
1712     // INVESTOR FEATURES
1713     // -----------------------------------------
1714 
1715     function openDispute(address crowdsale, bytes32 hash, string calldata reason) external payable returns (uint256) {
1716         require(IRICO(crowdsale).isInvestor(msg.sender) == true, "openDispute: sender is not an investor.");
1717         require(IRICO(crowdsale).canInvestorOpenNewDispute(hash, msg.sender) == true, "openDispute: investor cannot open a new dispute.");
1718         require(IRICO(crowdsale).getMilestoneStatus(hash) == IRICO.MilestoneStatus.DISPUTS_PERIOD, "openDispute: the period for opening new disputes was finished.");
1719 
1720         if (IRICO(crowdsale).didInvestorOpenedDisputeBefore(hash, msg.sender) == true) {
1721             require(msg.value == _feeForMoreDisputes, "openDispute: for the second and other disputes investor need to pay 1 ETH fee.");
1722         }
1723 
1724         IRICO(crowdsale).openDispute(hash, msg.sender);
1725         uint256 disputeID = _arbitersPool.createDispute(hash, crowdsale, msg.sender, reason);
1726 
1727         return disputeID;
1728     }
1729 
1730     // -----------------------------------------
1731     // ARBITERSPOOL FEATURES
1732     // -----------------------------------------
1733 
1734     function solveDispute(address crowdsale, bytes32 hash, address investor, bool investorWins) external {
1735         require(msg.sender == _arbitersPoolAddress, "solveDispute: the sender is not arbiters pool contract.");
1736 
1737         IRICO(crowdsale).solveDispute(hash, investor, investorWins);
1738     }
1739 
1740     // -----------------------------------------
1741     // GETTERS
1742     // -----------------------------------------
1743 
1744     function getArbitersPoolAddress() external view returns (address) {
1745         return _arbitersPoolAddress;
1746     }
1747 
1748     function getAllCrowdsalesAddresses() external view returns (address[] memory crowdsales) {
1749         crowdsales = new address[](_crowdsales.length);
1750         for (uint256 i = 0; i < _crowdsales.length; i++) {
1751             crowdsales[i] = _crowdsales[i];
1752         }
1753         return crowdsales;
1754     }
1755 
1756     function getCrowdsaleMilestones(address crowdsale) external view returns(bytes32[] memory milestonesHashArray) {
1757         return IRICO(crowdsale).getMilestonesHashes();
1758     }
1759 
1760     function getOperatorCrowdsaleAddresses(address operator) external view returns (address[] memory crowdsales) {
1761         crowdsales = new address[](_operatorsContracts[operator].length);
1762         for (uint256 i = 0; i < _operatorsContracts[operator].length; i++) {
1763             crowdsales[i] = _operatorsContracts[operator][i];
1764         }
1765         return crowdsales;
1766     }
1767 }