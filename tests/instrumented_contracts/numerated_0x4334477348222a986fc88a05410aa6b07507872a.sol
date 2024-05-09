1 pragma solidity 0.4.20;
2 
3 contract IAugur {
4     function createChildUniverse(bytes32 _parentPayoutDistributionHash, uint256[] _parentPayoutNumerators, bool _parentInvalid) public returns (IUniverse);
5     function isKnownUniverse(IUniverse _universe) public view returns (bool);
6     function trustedTransfer(ERC20 _token, address _from, address _to, uint256 _amount) public returns (bool);
7     function logMarketCreated(bytes32 _topic, string _description, string _extraInfo, IUniverse _universe, address _market, address _marketCreator, bytes32[] _outcomes, int256 _minPrice, int256 _maxPrice, IMarket.MarketType _marketType) public returns (bool);
8     function logMarketCreated(bytes32 _topic, string _description, string _extraInfo, IUniverse _universe, address _market, address _marketCreator, int256 _minPrice, int256 _maxPrice, IMarket.MarketType _marketType) public returns (bool);
9     function logInitialReportSubmitted(IUniverse _universe, address _reporter, address _market, uint256 _amountStaked, bool _isDesignatedReporter, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
10     function disputeCrowdsourcerCreated(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] _payoutNumerators, uint256 _size, bool _invalid) public returns (bool);
11     function logDisputeCrowdsourcerContribution(IUniverse _universe, address _reporter, address _market, address _disputeCrowdsourcer, uint256 _amountStaked) public returns (bool);
12     function logDisputeCrowdsourcerCompleted(IUniverse _universe, address _market, address _disputeCrowdsourcer) public returns (bool);
13     function logInitialReporterRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256 _reportingFeesReceived, uint256[] _payoutNumerators) public returns (bool);
14     function logDisputeCrowdsourcerRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256 _reportingFeesReceived, uint256[] _payoutNumerators) public returns (bool);
15     function logFeeWindowRedeemed(IUniverse _universe, address _reporter, uint256 _amountRedeemed, uint256 _reportingFeesReceived) public returns (bool);
16     function logMarketFinalized(IUniverse _universe) public returns (bool);
17     function logMarketMigrated(IMarket _market, IUniverse _originalUniverse) public returns (bool);
18     function logReportingParticipantDisavowed(IUniverse _universe, IMarket _market) public returns (bool);
19     function logMarketParticipantsDisavowed(IUniverse _universe) public returns (bool);
20     function logOrderCanceled(IUniverse _universe, address _shareToken, address _sender, bytes32 _orderId, Order.Types _orderType, uint256 _tokenRefund, uint256 _sharesRefund) public returns (bool);
21     function logOrderCreated(Order.Types _orderType, uint256 _amount, uint256 _price, address _creator, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _tradeGroupId, bytes32 _orderId, IUniverse _universe, address _shareToken) public returns (bool);
22     function logOrderFilled(IUniverse _universe, address _shareToken, address _filler, bytes32 _orderId, uint256 _numCreatorShares, uint256 _numCreatorTokens, uint256 _numFillerShares, uint256 _numFillerTokens, uint256 _marketCreatorFees, uint256 _reporterFees, uint256 _amountFilled, bytes32 _tradeGroupId) public returns (bool);
23     function logCompleteSetsPurchased(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public returns (bool);
24     function logCompleteSetsSold(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public returns (bool);
25     function logTradingProceedsClaimed(IUniverse _universe, address _shareToken, address _sender, address _market, uint256 _numShares, uint256 _numPayoutTokens, uint256 _finalTokenBalance) public returns (bool);
26     function logUniverseForked() public returns (bool);
27     function logFeeWindowTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
28     function logReputationTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
29     function logDisputeCrowdsourcerTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
30     function logShareTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
31     function logReputationTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
32     function logReputationTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
33     function logShareTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
34     function logShareTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
35     function logFeeWindowBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
36     function logFeeWindowMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
37     function logDisputeCrowdsourcerTokensBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
38     function logDisputeCrowdsourcerTokensMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
39     function logFeeWindowCreated(IFeeWindow _feeWindow, uint256 _id) public returns (bool);
40     function logFeeTokenTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
41     function logFeeTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
42     function logFeeTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
43     function logTimestampSet(uint256 _newTimestamp) public returns (bool);
44     function logInitialReporterTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool);
45     function logMarketTransferred(IUniverse _universe, address _from, address _to) public returns (bool);
46     function logMarketMailboxTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool);
47     function logEscapeHatchChanged(bool _isOn) public returns (bool);
48 }
49 
50 contract IControlled {
51     function getController() public view returns (IController);
52     function setController(IController _controller) public returns(bool);
53 }
54 
55 contract Controlled is IControlled {
56     IController internal controller;
57 
58     modifier onlyWhitelistedCallers {
59         require(controller.assertIsWhitelisted(msg.sender));
60         _;
61     }
62 
63     modifier onlyCaller(bytes32 _key) {
64         require(msg.sender == controller.lookup(_key));
65         _;
66     }
67 
68     modifier onlyControllerCaller {
69         require(IController(msg.sender) == controller);
70         _;
71     }
72 
73     modifier onlyInGoodTimes {
74         require(controller.stopInEmergency());
75         _;
76     }
77 
78     modifier onlyInBadTimes {
79         require(controller.onlyInEmergency());
80         _;
81     }
82 
83     function Controlled() public {
84         controller = IController(msg.sender);
85     }
86 
87     function getController() public view returns(IController) {
88         return controller;
89     }
90 
91     function setController(IController _controller) public onlyControllerCaller returns(bool) {
92         controller = _controller;
93         return true;
94     }
95 }
96 
97 contract IController {
98     function assertIsWhitelisted(address _target) public view returns(bool);
99     function lookup(bytes32 _key) public view returns(address);
100     function stopInEmergency() public view returns(bool);
101     function onlyInEmergency() public view returns(bool);
102     function getAugur() public view returns (IAugur);
103     function getTimestamp() public view returns (uint256);
104 }
105 
106 contract CashAutoConverter is Controlled {
107     /**
108      * @dev Convert any ETH provided in the transaction into Cash before the function executes and convert any remaining Cash balance into ETH after the function completes
109      */
110     modifier convertToAndFromCash() {
111         ethToCash();
112         _;
113         cashToEth();
114     }
115 
116     function ethToCash() private returns (bool) {
117         if (msg.value > 0) {
118             ICash(controller.lookup("Cash")).depositEtherFor.value(msg.value)(msg.sender);
119         }
120         return true;
121     }
122 
123     function cashToEth() private returns (bool) {
124         ICash _cash = ICash(controller.lookup("Cash"));
125         uint256 _tokenBalance = _cash.balanceOf(msg.sender);
126         if (_tokenBalance > 0) {
127             IAugur augur = controller.getAugur();
128             augur.trustedTransfer(_cash, msg.sender, this, _tokenBalance);
129             _cash.withdrawEtherTo(msg.sender, _tokenBalance);
130         }
131         return true;
132     }
133 }
134 
135 contract IOwnable {
136     function getOwner() public view returns (address);
137     function transferOwnership(address newOwner) public returns (bool);
138 }
139 
140 contract ITyped {
141     function getTypeName() public view returns (bytes32);
142 }
143 
144 contract Initializable {
145     bool private initialized = false;
146 
147     modifier afterInitialized {
148         require(initialized);
149         _;
150     }
151 
152     modifier beforeInitialized {
153         require(!initialized);
154         _;
155     }
156 
157     function endInitialization() internal beforeInitialized returns (bool) {
158         initialized = true;
159         return true;
160     }
161 
162     function getInitialized() public view returns (bool) {
163         return initialized;
164     }
165 }
166 
167 contract MarketValidator is Controlled {
168     modifier marketIsLegit(IMarket _market) {
169         IUniverse _universe = _market.getUniverse();
170         require(controller.getAugur().isKnownUniverse(_universe));
171         require(_universe.isContainerForMarket(_market));
172         _;
173     }
174 }
175 
176 contract ReentrancyGuard {
177     /**
178      * @dev We use a single lock for the whole contract.
179      */
180     bool private rentrancyLock = false;
181 
182     /**
183      * @dev Prevents a contract from calling itself, directly or indirectly.
184      * @notice If you mark a function `nonReentrant`, you should also mark it `external`. Calling one nonReentrant function from another is not supported. Instead, you can implement a `private` function doing the actual work, and a `external` wrapper marked as `nonReentrant`.
185      */
186     modifier nonReentrant() {
187         require(!rentrancyLock);
188         rentrancyLock = true;
189         _;
190         rentrancyLock = false;
191     }
192 }
193 
194 library SafeMathUint256 {
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         uint256 c = a * b;
197         require(a == 0 || c / a == b);
198         return c;
199     }
200 
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         // assert(b > 0); // Solidity automatically throws when dividing by 0
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205         return c;
206     }
207 
208     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
209         require(b <= a);
210         return a - b;
211     }
212 
213     function add(uint256 a, uint256 b) internal pure returns (uint256) {
214         uint256 c = a + b;
215         require(c >= a);
216         return c;
217     }
218 
219     function min(uint256 a, uint256 b) internal pure returns (uint256) {
220         if (a <= b) {
221             return a;
222         } else {
223             return b;
224         }
225     }
226 
227     function max(uint256 a, uint256 b) internal pure returns (uint256) {
228         if (a >= b) {
229             return a;
230         } else {
231             return b;
232         }
233     }
234 
235     function getUint256Min() internal pure returns (uint256) {
236         return 0;
237     }
238 
239     function getUint256Max() internal pure returns (uint256) {
240         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
241     }
242 
243     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
244         return a % b == 0;
245     }
246 
247     // Float [fixed point] Operations
248     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
249         return div(mul(a, b), base);
250     }
251 
252     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
253         return div(mul(a, base), b);
254     }
255 }
256 
257 contract ERC20Basic {
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     function balanceOf(address _who) public view returns (uint256);
261     function transfer(address _to, uint256 _value) public returns (bool);
262     function totalSupply() public view returns (uint256);
263 }
264 
265 contract ERC20 is ERC20Basic {
266     event Approval(address indexed owner, address indexed spender, uint256 value);
267 
268     function allowance(address _owner, address _spender) public view returns (uint256);
269     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
270     function approve(address _spender, uint256 _value) public returns (bool);
271 }
272 
273 contract IFeeToken is ERC20, Initializable {
274     function initialize(IFeeWindow _feeWindow) public returns (bool);
275     function getFeeWindow() public view returns (IFeeWindow);
276     function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
277     function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
278 }
279 
280 contract IFeeWindow is ITyped, ERC20 {
281     function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
282     function getUniverse() public view returns (IUniverse);
283     function getReputationToken() public view returns (IReputationToken);
284     function getStartTime() public view returns (uint256);
285     function getEndTime() public view returns (uint256);
286     function getNumMarkets() public view returns (uint256);
287     function getNumInvalidMarkets() public view returns (uint256);
288     function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
289     function getNumDesignatedReportNoShows() public view returns (uint256);
290     function getFeeToken() public view returns (IFeeToken);
291     function isActive() public view returns (bool);
292     function isOver() public view returns (bool);
293     function onMarketFinalized() public returns (bool);
294     function buy(uint256 _attotokens) public returns (bool);
295     function redeem(address _sender) public returns (bool);
296     function redeemForReportingParticipant() public returns (bool);
297     function mintFeeTokens(uint256 _amount) public returns (bool);
298     function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
299 }
300 
301 contract IMailbox {
302     function initialize(address _owner, IMarket _market) public returns (bool);
303     function depositEther() public payable returns (bool);
304 }
305 
306 contract IMarket is ITyped, IOwnable {
307     enum MarketType {
308         YES_NO,
309         CATEGORICAL,
310         SCALAR
311     }
312 
313     function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
314     function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
315     function getUniverse() public view returns (IUniverse);
316     function getFeeWindow() public view returns (IFeeWindow);
317     function getNumberOfOutcomes() public view returns (uint256);
318     function getNumTicks() public view returns (uint256);
319     function getDenominationToken() public view returns (ICash);
320     function getShareToken(uint256 _outcome)  public view returns (IShareToken);
321     function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
322     function getForkingMarket() public view returns (IMarket _market);
323     function getEndTime() public view returns (uint256);
324     function getMarketCreatorMailbox() public view returns (IMailbox);
325     function getWinningPayoutDistributionHash() public view returns (bytes32);
326     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
327     function getReputationToken() public view returns (IReputationToken);
328     function getFinalizationTime() public view returns (uint256);
329     function getInitialReporterAddress() public view returns (address);
330     function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
331     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
332     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
333     function isInvalid() public view returns (bool);
334     function finalize() public returns (bool);
335     function designatedReporterWasCorrect() public view returns (bool);
336     function designatedReporterShowed() public view returns (bool);
337     function isFinalized() public view returns (bool);
338     function finalizeFork() public returns (bool);
339     function assertBalances() public view returns (bool);
340 }
341 
342 contract IReportingParticipant {
343     function getStake() public view returns (uint256);
344     function getPayoutDistributionHash() public view returns (bytes32);
345     function liquidateLosing() public returns (bool);
346     function redeem(address _redeemer) public returns (bool);
347     function isInvalid() public view returns (bool);
348     function isDisavowed() public view returns (bool);
349     function migrate() public returns (bool);
350     function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
351     function getMarket() public view returns (IMarket);
352     function getSize() public view returns (uint256);
353 }
354 
355 contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
356     function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
357     function contribute(address _participant, uint256 _amount) public returns (uint256);
358 }
359 
360 contract IReputationToken is ITyped, ERC20 {
361     function initialize(IUniverse _universe) public returns (bool);
362     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
363     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
364     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
365     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
366     function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
367     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
368     function getUniverse() public view returns (IUniverse);
369     function getTotalMigrated() public view returns (uint256);
370     function getTotalTheoreticalSupply() public view returns (uint256);
371     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
372 }
373 
374 contract IUniverse is ITyped {
375     function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
376     function fork() public returns (bool);
377     function getParentUniverse() public view returns (IUniverse);
378     function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
379     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
380     function getReputationToken() public view returns (IReputationToken);
381     function getForkingMarket() public view returns (IMarket);
382     function getForkEndTime() public view returns (uint256);
383     function getForkReputationGoal() public view returns (uint256);
384     function getParentPayoutDistributionHash() public view returns (bytes32);
385     function getDisputeRoundDurationInSeconds() public view returns (uint256);
386     function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
387     function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
388     function getOrCreateNextFeeWindow() public returns (IFeeWindow);
389     function getOpenInterestInAttoEth() public view returns (uint256);
390     function getRepMarketCapInAttoeth() public view returns (uint256);
391     function getTargetRepMarketCapInAttoeth() public view returns (uint256);
392     function getOrCacheValidityBond() public returns (uint256);
393     function getOrCacheDesignatedReportStake() public returns (uint256);
394     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
395     function getOrCacheReportingFeeDivisor() public returns (uint256);
396     function getDisputeThresholdForFork() public view returns (uint256);
397     function getInitialReportMinValue() public view returns (uint256);
398     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
399     function getOrCacheMarketCreationCost() public returns (uint256);
400     function getCurrentFeeWindow() public view returns (IFeeWindow);
401     function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
402     function isParentOf(IUniverse _shadyChild) public view returns (bool);
403     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
404     function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
405     function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
406     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
407     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
408     function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
409     function addMarketTo() public returns (bool);
410     function removeMarketFrom() public returns (bool);
411     function decrementOpenInterest(uint256 _amount) public returns (bool);
412     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
413     function incrementOpenInterest(uint256 _amount) public returns (bool);
414     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
415     function getWinningChildUniverse() public view returns (IUniverse);
416     function isForking() public view returns (bool);
417 }
418 
419 library Reporting {
420     uint256 private constant DESIGNATED_REPORTING_DURATION_SECONDS = 3 days;
421     uint256 private constant DISPUTE_ROUND_DURATION_SECONDS = 7 days;
422     uint256 private constant CLAIM_PROCEEDS_WAIT_TIME = 3 days;
423     uint256 private constant FORK_DURATION_SECONDS = 60 days;
424 
425     uint256 private constant INITIAL_REP_SUPPLY = 11 * 10 ** 6 * 10 ** 18; // 11 Million REP
426 
427     uint256 private constant DEFAULT_VALIDITY_BOND = 1 ether / 100;
428     uint256 private constant VALIDITY_BOND_FLOOR = 1 ether / 100;
429     uint256 private constant DEFAULT_REPORTING_FEE_DIVISOR = 100; // 1% fees
430     uint256 private constant MAXIMUM_REPORTING_FEE_DIVISOR = 10000; // Minimum .01% fees
431     uint256 private constant MINIMUM_REPORTING_FEE_DIVISOR = 3; // Maximum 33.3~% fees. Note than anything less than a value of 2 here will likely result in bugs such as divide by 0 cases.
432 
433     uint256 private constant TARGET_INVALID_MARKETS_DIVISOR = 100; // 1% of markets are expected to be invalid
434     uint256 private constant TARGET_INCORRECT_DESIGNATED_REPORT_MARKETS_DIVISOR = 100; // 1% of markets are expected to have an incorrect designate report
435     uint256 private constant TARGET_DESIGNATED_REPORT_NO_SHOWS_DIVISOR = 100; // 1% of markets are expected to have an incorrect designate report
436     uint256 private constant TARGET_REP_MARKET_CAP_MULTIPLIER = 15; // We multiply and divide by constants since we want to multiply by a fractional amount (7.5)
437     uint256 private constant TARGET_REP_MARKET_CAP_DIVISOR = 2;
438 
439     uint256 private constant FORK_MIGRATION_PERCENTAGE_BONUS_DIVISOR = 20; // 5% bonus to any REP migrated during a fork
440 
441     function getDesignatedReportingDurationSeconds() internal pure returns (uint256) { return DESIGNATED_REPORTING_DURATION_SECONDS; }
442     function getDisputeRoundDurationSeconds() internal pure returns (uint256) { return DISPUTE_ROUND_DURATION_SECONDS; }
443     function getClaimTradingProceedsWaitTime() internal pure returns (uint256) { return CLAIM_PROCEEDS_WAIT_TIME; }
444     function getForkDurationSeconds() internal pure returns (uint256) { return FORK_DURATION_SECONDS; }
445     function getDefaultValidityBond() internal pure returns (uint256) { return DEFAULT_VALIDITY_BOND; }
446     function getValidityBondFloor() internal pure returns (uint256) { return VALIDITY_BOND_FLOOR; }
447     function getTargetInvalidMarketsDivisor() internal pure returns (uint256) { return TARGET_INVALID_MARKETS_DIVISOR; }
448     function getTargetIncorrectDesignatedReportMarketsDivisor() internal pure returns (uint256) { return TARGET_INCORRECT_DESIGNATED_REPORT_MARKETS_DIVISOR; }
449     function getTargetDesignatedReportNoShowsDivisor() internal pure returns (uint256) { return TARGET_DESIGNATED_REPORT_NO_SHOWS_DIVISOR; }
450     function getTargetRepMarketCapMultiplier() internal pure returns (uint256) { return TARGET_REP_MARKET_CAP_MULTIPLIER; }
451     function getTargetRepMarketCapDivisor() internal pure returns (uint256) { return TARGET_REP_MARKET_CAP_DIVISOR; }
452     function getForkMigrationPercentageBonusDivisor() internal pure returns (uint256) { return FORK_MIGRATION_PERCENTAGE_BONUS_DIVISOR; }
453     function getMaximumReportingFeeDivisor() internal pure returns (uint256) { return MAXIMUM_REPORTING_FEE_DIVISOR; }
454     function getMinimumReportingFeeDivisor() internal pure returns (uint256) { return MINIMUM_REPORTING_FEE_DIVISOR; }
455     function getDefaultReportingFeeDivisor() internal pure returns (uint256) { return DEFAULT_REPORTING_FEE_DIVISOR; }
456     function getInitialREPSupply() internal pure returns (uint256) { return INITIAL_REP_SUPPLY; }
457 }
458 
459 contract ICash is ERC20 {
460     function depositEther() external payable returns(bool);
461     function depositEtherFor(address _to) external payable returns(bool);
462     function withdrawEther(uint256 _amount) external returns(bool);
463     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
464     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
465 }
466 
467 contract IClaimTradingProceeds {
468 
469 }
470 
471 contract ClaimTradingProceeds is CashAutoConverter, ReentrancyGuard, MarketValidator, IClaimTradingProceeds {
472     using SafeMathUint256 for uint256;
473 
474     function claimTradingProceeds(IMarket _market, address _shareHolder) marketIsLegit(_market) onlyInGoodTimes nonReentrant external returns(bool) {
475         // NOTE: this requirement does _not_ enforce market finalization. That requirement occurs later on in this function when calling getWinningPayoutNumerator. When this requirement is removed we may want to consider explicitly requiring it here (or modifying this comment and keeping the gas savings)
476         require(controller.getTimestamp() > _market.getFinalizationTime().add(Reporting.getClaimTradingProceedsWaitTime()));
477 
478         ICash _denominationToken = _market.getDenominationToken();
479 
480         for (uint256 _outcome = 0; _outcome < _market.getNumberOfOutcomes(); ++_outcome) {
481             IShareToken _shareToken = _market.getShareToken(_outcome);
482             uint256 _numberOfShares = _shareToken.balanceOf(_shareHolder);
483             uint256 _proceeds;
484             uint256 _shareHolderShare;
485             uint256 _creatorShare;
486             uint256 _reporterShare;
487             (_proceeds, _shareHolderShare, _creatorShare, _reporterShare) = divideUpWinnings(_market, _outcome, _numberOfShares);
488 
489             // always destroy shares as it gives a minor gas refund and is good for the network
490             if (_numberOfShares > 0) {
491                 _shareToken.destroyShares(_shareHolder, _numberOfShares);
492                 logTradingProceedsClaimed(_market, _shareToken, _shareHolder, _numberOfShares, _shareHolderShare);
493             }
494             if (_shareHolderShare > 0) {
495                 require(_denominationToken.transferFrom(_market, this, _shareHolderShare));
496                 _denominationToken.withdrawEtherTo(_shareHolder, _shareHolderShare);
497             }
498             if (_creatorShare > 0) {
499                 require(_denominationToken.transferFrom(_market, _market.getMarketCreatorMailbox(), _creatorShare));
500             }
501             if (_reporterShare > 0) {
502                 require(_denominationToken.transferFrom(_market, _market.getUniverse().getOrCreateNextFeeWindow(), _reporterShare));
503             }
504         }
505 
506         _market.assertBalances();
507 
508         return true;
509     }
510 
511     function logTradingProceedsClaimed(IMarket _market, address _shareToken, address _sender, uint256 _numShares, uint256 _numPayoutTokens) private returns (bool) {
512         controller.getAugur().logTradingProceedsClaimed(_market.getUniverse(), _shareToken, _sender, _market, _numShares, _numPayoutTokens, _sender.balance.add(_numPayoutTokens));
513         return true;
514     }
515 
516     function divideUpWinnings(IMarket _market, uint256 _outcome, uint256 _numberOfShares) public returns (uint256 _proceeds, uint256 _shareHolderShare, uint256 _creatorShare, uint256 _reporterShare) {
517         _proceeds = calculateProceeds(_market, _outcome, _numberOfShares);
518         _creatorShare = calculateCreatorFee(_market, _proceeds);
519         _reporterShare = calculateReportingFee(_market, _proceeds);
520         _shareHolderShare = _proceeds.sub(_creatorShare).sub(_reporterShare);
521         return (_proceeds, _shareHolderShare, _creatorShare, _reporterShare);
522     }
523 
524     function calculateProceeds(IMarket _market, uint256 _outcome, uint256 _numberOfShares) public view returns (uint256) {
525         uint256 _payoutNumerator = _market.getWinningPayoutNumerator(_outcome);
526         return _numberOfShares.mul(_payoutNumerator);
527     }
528 
529     function calculateReportingFee(IMarket _market, uint256 _amount) public returns (uint256) {
530         uint256 _reportingFeeDivisor = _market.getUniverse().getOrCacheReportingFeeDivisor();
531         return _amount.div(_reportingFeeDivisor);
532     }
533 
534     function calculateCreatorFee(IMarket _market, uint256 _amount) public view returns (uint256) {
535         return _market.deriveMarketCreatorFeeAmount(_amount);
536     }
537 }
538 
539 contract IOrders {
540     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
541     function removeOrder(bytes32 _orderId) public returns (bool);
542     function getMarket(bytes32 _orderId) public view returns (IMarket);
543     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
544     function getOutcome(bytes32 _orderId) public view returns (uint256);
545     function getAmount(bytes32 _orderId) public view returns (uint256);
546     function getPrice(bytes32 _orderId) public view returns (uint256);
547     function getOrderCreator(bytes32 _orderId) public view returns (address);
548     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
549     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
550     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
551     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
552     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
553     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
554     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
555     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
556     function getTotalEscrowed(IMarket _market) public view returns (uint256);
557     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
558     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
559     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
560     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
561     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
562     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
563     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
564     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
565 }
566 
567 contract IShareToken is ITyped, ERC20 {
568     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
569     function createShares(address _owner, uint256 _amount) external returns (bool);
570     function destroyShares(address, uint256 balance) external returns (bool);
571     function getMarket() external view returns (IMarket);
572     function getOutcome() external view returns (uint256);
573     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
574     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
575     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
576 }
577 
578 library Order {
579     using SafeMathUint256 for uint256;
580 
581     enum Types {
582         Bid, Ask
583     }
584 
585     enum TradeDirections {
586         Long, Short
587     }
588 
589     struct Data {
590         // Contracts
591         IOrders orders;
592         IMarket market;
593         IAugur augur;
594 
595         // Order
596         bytes32 id;
597         address creator;
598         uint256 outcome;
599         Order.Types orderType;
600         uint256 amount;
601         uint256 price;
602         uint256 sharesEscrowed;
603         uint256 moneyEscrowed;
604         bytes32 betterOrderId;
605         bytes32 worseOrderId;
606     }
607 
608     //
609     // Constructor
610     //
611 
612     // No validation is needed here as it is simply a librarty function for organizing data
613     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
614         require(_outcome < _market.getNumberOfOutcomes());
615         require(_price < _market.getNumTicks());
616 
617         IOrders _orders = IOrders(_controller.lookup("Orders"));
618         IAugur _augur = _controller.getAugur();
619 
620         return Data({
621             orders: _orders,
622             market: _market,
623             augur: _augur,
624             id: 0,
625             creator: _creator,
626             outcome: _outcome,
627             orderType: _type,
628             amount: _attoshares,
629             price: _price,
630             sharesEscrowed: 0,
631             moneyEscrowed: 0,
632             betterOrderId: _betterOrderId,
633             worseOrderId: _worseOrderId
634         });
635     }
636 
637     //
638     // "public" functions
639     //
640 
641     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
642         if (_orderData.id == bytes32(0)) {
643             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
644             require(_orderData.orders.getAmount(_orderId) == 0);
645             _orderData.id = _orderId;
646         }
647         return _orderData.id;
648     }
649 
650     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
651         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
652     }
653 
654     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
655         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
656     }
657 
658     function escrowFunds(Order.Data _orderData) internal returns (bool) {
659         if (_orderData.orderType == Order.Types.Ask) {
660             return escrowFundsForAsk(_orderData);
661         } else if (_orderData.orderType == Order.Types.Bid) {
662             return escrowFundsForBid(_orderData);
663         }
664     }
665 
666     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
667         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
668     }
669 
670     //
671     // Private functions
672     //
673 
674     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
675         require(_orderData.moneyEscrowed == 0);
676         require(_orderData.sharesEscrowed == 0);
677         uint256 _attosharesToCover = _orderData.amount;
678         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
679 
680         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
681         uint256 _attosharesHeld = 2**254;
682         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
683             if (_i != _orderData.outcome) {
684                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
685                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
686             }
687         }
688 
689         // Take shares into escrow if they have any almost-complete-sets
690         if (_attosharesHeld > 0) {
691             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
692             _attosharesToCover -= _orderData.sharesEscrowed;
693             for (_i = 0; _i < _numberOfOutcomes; _i++) {
694                 if (_i != _orderData.outcome) {
695                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
696                 }
697             }
698         }
699         // If not able to cover entire order with shares alone, then cover remaining with tokens
700         if (_attosharesToCover > 0) {
701             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
702             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
703         }
704 
705         return true;
706     }
707 
708     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
709         require(_orderData.moneyEscrowed == 0);
710         require(_orderData.sharesEscrowed == 0);
711         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
712         uint256 _attosharesToCover = _orderData.amount;
713 
714         // Figure out how many shares of the outcome the creator has
715         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
716 
717         // Take shares in escrow if user has shares
718         if (_attosharesHeld > 0) {
719             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
720             _attosharesToCover -= _orderData.sharesEscrowed;
721             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
722         }
723 
724         // If not able to cover entire order with shares alone, then cover remaining with tokens
725         if (_attosharesToCover > 0) {
726             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
727             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
728         }
729 
730         return true;
731     }
732 }