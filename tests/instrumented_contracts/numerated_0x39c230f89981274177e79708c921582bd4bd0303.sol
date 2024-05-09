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
167 contract ReentrancyGuard {
168     /**
169      * @dev We use a single lock for the whole contract.
170      */
171     bool private rentrancyLock = false;
172 
173     /**
174      * @dev Prevents a contract from calling itself, directly or indirectly.
175      * @notice If you mark a function `nonReentrant`, you should also mark it `external`. Calling one nonReentrant function from another is not supported. Instead, you can implement a `private` function doing the actual work, and a `external` wrapper marked as `nonReentrant`.
176      */
177     modifier nonReentrant() {
178         require(!rentrancyLock);
179         rentrancyLock = true;
180         _;
181         rentrancyLock = false;
182     }
183 }
184 
185 library SafeMathUint256 {
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         uint256 c = a * b;
188         require(a == 0 || c / a == b);
189         return c;
190     }
191 
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         // assert(b > 0); // Solidity automatically throws when dividing by 0
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196         return c;
197     }
198 
199     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200         require(b <= a);
201         return a - b;
202     }
203 
204     function add(uint256 a, uint256 b) internal pure returns (uint256) {
205         uint256 c = a + b;
206         require(c >= a);
207         return c;
208     }
209 
210     function min(uint256 a, uint256 b) internal pure returns (uint256) {
211         if (a <= b) {
212             return a;
213         } else {
214             return b;
215         }
216     }
217 
218     function max(uint256 a, uint256 b) internal pure returns (uint256) {
219         if (a >= b) {
220             return a;
221         } else {
222             return b;
223         }
224     }
225 
226     function getUint256Min() internal pure returns (uint256) {
227         return 0;
228     }
229 
230     function getUint256Max() internal pure returns (uint256) {
231         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
232     }
233 
234     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
235         return a % b == 0;
236     }
237 
238     // Float [fixed point] Operations
239     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
240         return div(mul(a, b), base);
241     }
242 
243     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
244         return div(mul(a, base), b);
245     }
246 }
247 
248 contract ERC20Basic {
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     function balanceOf(address _who) public view returns (uint256);
252     function transfer(address _to, uint256 _value) public returns (bool);
253     function totalSupply() public view returns (uint256);
254 }
255 
256 contract ERC20 is ERC20Basic {
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 
259     function allowance(address _owner, address _spender) public view returns (uint256);
260     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
261     function approve(address _spender, uint256 _value) public returns (bool);
262 }
263 
264 contract IFeeToken is ERC20, Initializable {
265     function initialize(IFeeWindow _feeWindow) public returns (bool);
266     function getFeeWindow() public view returns (IFeeWindow);
267     function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
268     function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
269 }
270 
271 contract IFeeWindow is ITyped, ERC20 {
272     function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
273     function getUniverse() public view returns (IUniverse);
274     function getReputationToken() public view returns (IReputationToken);
275     function getStartTime() public view returns (uint256);
276     function getEndTime() public view returns (uint256);
277     function getNumMarkets() public view returns (uint256);
278     function getNumInvalidMarkets() public view returns (uint256);
279     function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
280     function getNumDesignatedReportNoShows() public view returns (uint256);
281     function getFeeToken() public view returns (IFeeToken);
282     function isActive() public view returns (bool);
283     function isOver() public view returns (bool);
284     function onMarketFinalized() public returns (bool);
285     function buy(uint256 _attotokens) public returns (bool);
286     function redeem(address _sender) public returns (bool);
287     function redeemForReportingParticipant() public returns (bool);
288     function mintFeeTokens(uint256 _amount) public returns (bool);
289     function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
290 }
291 
292 contract IMailbox {
293     function initialize(address _owner, IMarket _market) public returns (bool);
294     function depositEther() public payable returns (bool);
295 }
296 
297 contract IMarket is ITyped, IOwnable {
298     enum MarketType {
299         YES_NO,
300         CATEGORICAL,
301         SCALAR
302     }
303 
304     function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
305     function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
306     function getUniverse() public view returns (IUniverse);
307     function getFeeWindow() public view returns (IFeeWindow);
308     function getNumberOfOutcomes() public view returns (uint256);
309     function getNumTicks() public view returns (uint256);
310     function getDenominationToken() public view returns (ICash);
311     function getShareToken(uint256 _outcome)  public view returns (IShareToken);
312     function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
313     function getForkingMarket() public view returns (IMarket _market);
314     function getEndTime() public view returns (uint256);
315     function getMarketCreatorMailbox() public view returns (IMailbox);
316     function getWinningPayoutDistributionHash() public view returns (bytes32);
317     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
318     function getReputationToken() public view returns (IReputationToken);
319     function getFinalizationTime() public view returns (uint256);
320     function getInitialReporterAddress() public view returns (address);
321     function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
322     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
323     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
324     function isInvalid() public view returns (bool);
325     function finalize() public returns (bool);
326     function designatedReporterWasCorrect() public view returns (bool);
327     function designatedReporterShowed() public view returns (bool);
328     function isFinalized() public view returns (bool);
329     function finalizeFork() public returns (bool);
330     function assertBalances() public view returns (bool);
331 }
332 
333 contract IReportingParticipant {
334     function getStake() public view returns (uint256);
335     function getPayoutDistributionHash() public view returns (bytes32);
336     function liquidateLosing() public returns (bool);
337     function redeem(address _redeemer) public returns (bool);
338     function isInvalid() public view returns (bool);
339     function isDisavowed() public view returns (bool);
340     function migrate() public returns (bool);
341     function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
342     function getMarket() public view returns (IMarket);
343     function getSize() public view returns (uint256);
344 }
345 
346 contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
347     function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
348     function contribute(address _participant, uint256 _amount) public returns (uint256);
349 }
350 
351 contract IReputationToken is ITyped, ERC20 {
352     function initialize(IUniverse _universe) public returns (bool);
353     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
354     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
355     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
356     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
357     function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
358     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
359     function getUniverse() public view returns (IUniverse);
360     function getTotalMigrated() public view returns (uint256);
361     function getTotalTheoreticalSupply() public view returns (uint256);
362     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
363 }
364 
365 contract IUniverse is ITyped {
366     function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
367     function fork() public returns (bool);
368     function getParentUniverse() public view returns (IUniverse);
369     function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
370     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
371     function getReputationToken() public view returns (IReputationToken);
372     function getForkingMarket() public view returns (IMarket);
373     function getForkEndTime() public view returns (uint256);
374     function getForkReputationGoal() public view returns (uint256);
375     function getParentPayoutDistributionHash() public view returns (bytes32);
376     function getDisputeRoundDurationInSeconds() public view returns (uint256);
377     function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
378     function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
379     function getOrCreateNextFeeWindow() public returns (IFeeWindow);
380     function getOpenInterestInAttoEth() public view returns (uint256);
381     function getRepMarketCapInAttoeth() public view returns (uint256);
382     function getTargetRepMarketCapInAttoeth() public view returns (uint256);
383     function getOrCacheValidityBond() public returns (uint256);
384     function getOrCacheDesignatedReportStake() public returns (uint256);
385     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
386     function getOrCacheReportingFeeDivisor() public returns (uint256);
387     function getDisputeThresholdForFork() public view returns (uint256);
388     function getInitialReportMinValue() public view returns (uint256);
389     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
390     function getOrCacheMarketCreationCost() public returns (uint256);
391     function getCurrentFeeWindow() public view returns (IFeeWindow);
392     function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
393     function isParentOf(IUniverse _shadyChild) public view returns (bool);
394     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
395     function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
396     function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
397     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
398     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
399     function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
400     function addMarketTo() public returns (bool);
401     function removeMarketFrom() public returns (bool);
402     function decrementOpenInterest(uint256 _amount) public returns (bool);
403     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
404     function incrementOpenInterest(uint256 _amount) public returns (bool);
405     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
406     function getWinningChildUniverse() public view returns (IUniverse);
407     function isForking() public view returns (bool);
408 }
409 
410 library Trade {
411     using SafeMathUint256 for uint256;
412 
413     enum Direction {
414         Long,
415         Short
416     }
417 
418     struct Contracts {
419         IOrders orders;
420         IMarket market;
421         ICompleteSets completeSets;
422         ICash denominationToken;
423         IShareToken longShareToken;
424         IShareToken[] shortShareTokens;
425         IAugur augur;
426     }
427 
428     struct FilledOrder {
429         bytes32 orderId;
430         uint256 outcome;
431         uint256 sharePriceRange;
432         uint256 sharePriceLong;
433         uint256 sharePriceShort;
434     }
435 
436     struct Participant {
437         address participantAddress;
438         Direction direction;
439         uint256 startingSharesToSell;
440         uint256 startingSharesToBuy;
441         uint256 sharesToSell;
442         uint256 sharesToBuy;
443     }
444 
445     struct Data {
446         Contracts contracts;
447         FilledOrder order;
448         Participant creator;
449         Participant filler;
450     }
451 
452     //
453     // Constructor
454     //
455 
456     function create(IController _controller, bytes32 _orderId, address _fillerAddress, uint256 _fillerSize) internal view returns (Data) {
457         Contracts memory _contracts = getContracts(_controller, _orderId);
458         FilledOrder memory _order = getOrder(_contracts, _orderId);
459         Order.Types _orderOrderType = _contracts.orders.getOrderType(_orderId);
460         Participant memory _creator = getMaker(_contracts, _order, _orderOrderType);
461         Participant memory _filler = getFiller(_contracts, _orderOrderType, _fillerAddress, _fillerSize);
462 
463         return Data({
464             contracts: _contracts,
465             order: _order,
466             creator: _creator,
467             filler: _filler
468         });
469     }
470 
471     //
472     // "public" functions
473     //
474 
475     function tradeMakerSharesForFillerShares(Data _data) internal returns (uint256, uint256) {
476         uint256 _numberOfCompleteSets = _data.creator.sharesToSell.min(_data.filler.sharesToSell);
477         if (_numberOfCompleteSets == 0) {
478             return (0, 0);
479         }
480 
481         // transfer shares to this contract from each participant
482         _data.contracts.longShareToken.trustedFillOrderTransfer(getLongShareSellerSource(_data), this, _numberOfCompleteSets);
483         for (uint256 _i = 0; _i < _data.contracts.shortShareTokens.length; ++_i) {
484             _data.contracts.shortShareTokens[_i].trustedFillOrderTransfer(getShortShareSellerSource(_data), this, _numberOfCompleteSets);
485         }
486 
487         // sell complete sets
488         uint256 _marketCreatorFees;
489         uint256 _reporterFees;
490         (_marketCreatorFees, _reporterFees) = _data.contracts.completeSets.sellCompleteSets(this, _data.contracts.market, _numberOfCompleteSets);
491 
492         // distribute payout proportionately (fees will have been deducted)
493         uint256 _payout = _data.contracts.denominationToken.balanceOf(this);
494         uint256 _longShare = _payout.mul(_data.order.sharePriceLong).div(_data.order.sharePriceRange);
495         uint256 _shortShare = _payout.sub(_longShare);
496         _data.contracts.denominationToken.transfer(getLongShareSellerDestination(_data), _longShare);
497         _data.contracts.denominationToken.transfer(getShortShareSellerDestination(_data), _shortShare);
498 
499         // update available shares for creator and filler
500         _data.creator.sharesToSell -= _numberOfCompleteSets;
501         _data.filler.sharesToSell -= _numberOfCompleteSets;
502         return (_marketCreatorFees, _reporterFees);
503     }
504 
505     function tradeMakerSharesForFillerTokens(Data _data) internal returns (bool) {
506         uint256 _numberOfSharesToTrade = _data.creator.sharesToSell.min(_data.filler.sharesToBuy);
507         if (_numberOfSharesToTrade == 0) {
508             return true;
509         }
510 
511         // transfer shares from creator (escrowed in market) to filler
512         if (_data.creator.direction == Direction.Short) {
513             _data.contracts.longShareToken.trustedFillOrderTransfer(_data.contracts.market, _data.filler.participantAddress, _numberOfSharesToTrade);
514         } else {
515             for (uint256 _i = 0; _i < _data.contracts.shortShareTokens.length; ++_i) {
516                 _data.contracts.shortShareTokens[_i].trustedFillOrderTransfer(_data.contracts.market, _data.filler.participantAddress, _numberOfSharesToTrade);
517             }
518         }
519 
520         uint256 _tokensToCover = getTokensToCover(_data, _data.filler.direction, _numberOfSharesToTrade);
521         _data.contracts.augur.trustedTransfer(_data.contracts.denominationToken, _data.filler.participantAddress, _data.creator.participantAddress, _tokensToCover);
522 
523         // update available assets for creator and filler
524         _data.creator.sharesToSell -= _numberOfSharesToTrade;
525         _data.filler.sharesToBuy -= _numberOfSharesToTrade;
526         return true;
527     }
528 
529     function tradeMakerTokensForFillerShares(Data _data) internal returns (bool) {
530         uint256 _numberOfSharesToTrade = _data.filler.sharesToSell.min(_data.creator.sharesToBuy);
531         if (_numberOfSharesToTrade == 0) {
532             return true;
533         }
534 
535         // transfer shares from filler to creator
536         if (_data.filler.direction == Direction.Short) {
537             _data.contracts.longShareToken.trustedFillOrderTransfer(_data.filler.participantAddress, _data.creator.participantAddress, _numberOfSharesToTrade);
538         } else {
539             for (uint256 _i = 0; _i < _data.contracts.shortShareTokens.length; ++_i) {
540                 _data.contracts.shortShareTokens[_i].trustedFillOrderTransfer(_data.filler.participantAddress, _data.creator.participantAddress, _numberOfSharesToTrade);
541             }
542         }
543 
544         // transfer tokens from creator (escrowed in market) to filler
545         uint256 _tokensToCover = getTokensToCover(_data, _data.creator.direction, _numberOfSharesToTrade);
546         _data.contracts.denominationToken.transferFrom(_data.contracts.market, _data.filler.participantAddress, _tokensToCover);
547 
548         // update available assets for creator and filler
549         _data.creator.sharesToBuy -= _numberOfSharesToTrade;
550         _data.filler.sharesToSell -= _numberOfSharesToTrade;
551         return true;
552     }
553 
554     function tradeMakerTokensForFillerTokens(Data _data) internal returns (bool) {
555         uint256 _numberOfCompleteSets = _data.creator.sharesToBuy.min(_data.filler.sharesToBuy);
556         if (_numberOfCompleteSets == 0) {
557             return true;
558         }
559 
560         // transfer tokens to this contract
561         uint256 _creatorTokensToCover = getTokensToCover(_data, _data.creator.direction, _numberOfCompleteSets);
562         uint256 _fillerTokensToCover = getTokensToCover(_data, _data.filler.direction, _numberOfCompleteSets);
563 
564         // If someone is filling their own order with ETH both ways we just return the ETH
565         if (_data.creator.participantAddress == _data.filler.participantAddress) {
566             require(_data.contracts.denominationToken.transferFrom(_data.contracts.market, _data.creator.participantAddress, _creatorTokensToCover));
567 
568             _data.creator.sharesToBuy -= _numberOfCompleteSets;
569             _data.filler.sharesToBuy -= _numberOfCompleteSets;
570             return true;
571         }
572 
573         require(_data.contracts.denominationToken.transferFrom(_data.contracts.market, this, _creatorTokensToCover));
574         _data.contracts.augur.trustedTransfer(_data.contracts.denominationToken, _data.filler.participantAddress, this, _fillerTokensToCover);
575 
576         // buy complete sets
577         uint256 _cost = _numberOfCompleteSets.mul(_data.contracts.market.getNumTicks());
578         if (_data.contracts.denominationToken.allowance(this, _data.contracts.augur) < _cost) {
579             require(_data.contracts.denominationToken.approve(_data.contracts.augur, _cost));
580         }
581         _data.contracts.completeSets.buyCompleteSets(this, _data.contracts.market, _numberOfCompleteSets);
582 
583         // distribute shares to participants
584         address _longBuyer = getLongShareBuyerDestination(_data);
585         address _shortBuyer = getShortShareBuyerDestination(_data);
586         require(_data.contracts.longShareToken.transfer(_longBuyer, _numberOfCompleteSets));
587         for (uint256 _i = 0; _i < _data.contracts.shortShareTokens.length; ++_i) {
588             require(_data.contracts.shortShareTokens[_i].transfer(_shortBuyer, _numberOfCompleteSets));
589         }
590 
591         _data.creator.sharesToBuy -= _numberOfCompleteSets;
592         _data.filler.sharesToBuy -= _numberOfCompleteSets;
593         return true;
594     }
595 
596     //
597     // Helpers
598     //
599 
600     function getLongShareBuyerDestination(Data _data) internal pure returns (address) {
601         return (_data.creator.direction == Direction.Long) ? _data.creator.participantAddress : _data.filler.participantAddress;
602     }
603 
604     function getShortShareBuyerDestination(Data _data) internal pure returns (address) {
605         return (_data.creator.direction == Direction.Short) ? _data.creator.participantAddress : _data.filler.participantAddress;
606     }
607 
608     function getLongShareSellerSource(Data _data) internal pure returns (address) {
609         return (_data.creator.direction == Direction.Short) ? _data.contracts.market : _data.filler.participantAddress;
610     }
611 
612     function getShortShareSellerSource(Data _data) internal pure returns (address) {
613         return (_data.creator.direction == Direction.Long) ? _data.contracts.market : _data.filler.participantAddress;
614     }
615 
616     function getLongShareSellerDestination(Data _data) internal pure returns (address) {
617         return (_data.creator.direction == Direction.Short) ? _data.creator.participantAddress : _data.filler.participantAddress;
618     }
619 
620     function getShortShareSellerDestination(Data _data) internal pure returns (address) {
621         return (_data.creator.direction == Direction.Long) ? _data.creator.participantAddress : _data.filler.participantAddress;
622     }
623 
624     function getMakerSharesDepleted(Data _data) internal pure returns (uint256) {
625         return _data.creator.startingSharesToSell.sub(_data.creator.sharesToSell);
626     }
627 
628     function getFillerSharesDepleted(Data _data) internal pure returns (uint256) {
629         return _data.filler.startingSharesToSell.sub(_data.filler.sharesToSell);
630     }
631 
632     function getMakerTokensDepleted(Data _data) internal pure returns (uint256) {
633         return getTokensDepleted(_data, _data.creator.direction, _data.creator.startingSharesToBuy, _data.creator.sharesToBuy);
634     }
635 
636     function getFillerTokensDepleted(Data _data) internal pure returns (uint256) {
637         return getTokensDepleted(_data, _data.filler.direction, _data.filler.startingSharesToBuy, _data.filler.sharesToBuy);
638     }
639 
640     function getTokensDepleted(Data _data, Direction _direction, uint256 _startingSharesToBuy, uint256 _endingSharesToBuy) internal pure returns (uint256) {
641         return _startingSharesToBuy
642             .sub(_endingSharesToBuy)
643             .mul((_direction == Direction.Long) ? _data.order.sharePriceLong : _data.order.sharePriceShort);
644     }
645 
646     function getTokensToCover(Data _data, Direction _direction, uint256 _numShares) internal pure returns (uint256) {
647         return getTokensToCover(_direction, _data.order.sharePriceLong, _data.order.sharePriceShort, _numShares);
648     }
649 
650     //
651     // Construction helpers
652     //
653 
654     function getContracts(IController _controller, bytes32 _orderId) private view returns (Contracts memory) {
655         IOrders _orders = IOrders(_controller.lookup("Orders"));
656         IMarket _market = _orders.getMarket(_orderId);
657         uint256 _outcome = _orders.getOutcome(_orderId);
658         return Contracts({
659             orders: _orders,
660             market: _market,
661             completeSets: ICompleteSets(_controller.lookup("CompleteSets")),
662             denominationToken: _market.getDenominationToken(),
663             longShareToken: _market.getShareToken(_outcome),
664             shortShareTokens: getShortShareTokens(_market, _outcome),
665             augur: _controller.getAugur()
666         });
667     }
668 
669     function getOrder(Contracts _contracts, bytes32 _orderId) private view returns (FilledOrder memory) {
670         uint256 _sharePriceRange;
671         uint256 _sharePriceLong;
672         uint256 _sharePriceShort;
673         (_sharePriceRange, _sharePriceLong, _sharePriceShort) = getSharePriceDetails(_contracts.market, _contracts.orders, _orderId);
674         return FilledOrder({
675             orderId: _orderId,
676             outcome: _contracts.orders.getOutcome(_orderId),
677             sharePriceRange: _sharePriceRange,
678             sharePriceLong: _sharePriceLong,
679             sharePriceShort: _sharePriceShort
680         });
681     }
682 
683     function getMaker(Contracts _contracts, FilledOrder _order, Order.Types _orderOrderType) private view returns (Participant memory) {
684         Direction _direction = (_orderOrderType == Order.Types.Bid) ? Direction.Long : Direction.Short;
685         uint256 _sharesToSell = _contracts.orders.getOrderSharesEscrowed(_order.orderId);
686         uint256 _sharesToBuy = _contracts.orders.getAmount(_order.orderId).sub(_sharesToSell);
687         return Participant({
688             participantAddress: _contracts.orders.getOrderCreator(_order.orderId),
689             direction: _direction,
690             startingSharesToSell: _sharesToSell,
691             startingSharesToBuy: _sharesToBuy,
692             sharesToSell: _sharesToSell,
693             sharesToBuy: _sharesToBuy
694         });
695     }
696 
697     function getFiller(Contracts _contracts, Order.Types _orderOrderType, address _address, uint256 _size) private view returns (Participant memory) {
698         Direction _direction = (_orderOrderType == Order.Types.Bid) ? Direction.Short : Direction.Long;
699         uint256 _sharesToSell = getFillerSharesToSell(_contracts.longShareToken, _contracts.shortShareTokens, _address, _direction, _size);
700         uint256 _sharesToBuy = _size.sub(_sharesToSell);
701         return Participant({
702             participantAddress: _address,
703             direction: _direction,
704             startingSharesToSell: _sharesToSell,
705             startingSharesToBuy: _sharesToBuy,
706             sharesToSell: _sharesToSell,
707             sharesToBuy: _sharesToBuy
708         });
709     }
710 
711     function getTokensToCover(Direction _direction, uint256 _sharePriceLong, uint256 _sharePriceShort, uint256 _numShares) internal pure returns (uint256) {
712         return _numShares.mul((_direction == Direction.Long) ? _sharePriceLong : _sharePriceShort);
713     }
714 
715     function getShortShareTokens(IMarket _market, uint256 _longOutcome) private view returns (IShareToken[] memory) {
716         IShareToken[] memory _shortShareTokens = new IShareToken[](_market.getNumberOfOutcomes() - 1);
717         for (uint256 _outcome = 0; _outcome < _shortShareTokens.length + 1; ++_outcome) {
718             if (_outcome == _longOutcome) {
719                 continue;
720             }
721             uint256 _index = (_outcome < _longOutcome) ? _outcome : _outcome - 1;
722             _shortShareTokens[_index] = _market.getShareToken(_outcome);
723         }
724         return _shortShareTokens;
725     }
726 
727     function getSharePriceDetails(IMarket _market, IOrders _orders, bytes32 _orderId) private view returns (uint256 _sharePriceRange, uint256 _sharePriceLong, uint256 _sharePriceShort) {
728         uint256 _numTicks = _market.getNumTicks();
729         uint256 _orderPrice = _orders.getPrice(_orderId);
730         _sharePriceShort = uint256(_numTicks.sub(_orderPrice));
731         return (_numTicks, _orderPrice, _sharePriceShort);
732     }
733 
734     function getFillerSharesToSell(IShareToken _longShareToken, IShareToken[] memory _shortShareTokens, address _filler, Direction _fillerDirection, uint256 _fillerSize) private view returns (uint256) {
735         uint256 _sharesAvailable = SafeMathUint256.getUint256Max();
736         if (_fillerDirection == Direction.Short) {
737             _sharesAvailable = _longShareToken.balanceOf(_filler);
738         } else {
739             for (uint256 _outcome = 0; _outcome < _shortShareTokens.length; ++_outcome) {
740                 _sharesAvailable = _shortShareTokens[_outcome].balanceOf(_filler).min(_sharesAvailable);
741             }
742         }
743         return _sharesAvailable.min(_fillerSize);
744     }
745 }
746 
747 contract ICash is ERC20 {
748     function depositEther() external payable returns(bool);
749     function depositEtherFor(address _to) external payable returns(bool);
750     function withdrawEther(uint256 _amount) external returns(bool);
751     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
752     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
753 }
754 
755 contract ICompleteSets {
756     function buyCompleteSets(address _sender, IMarket _market, uint256 _amount) external returns (bool);
757     function sellCompleteSets(address _sender, IMarket _market, uint256 _amount) external returns (uint256, uint256);
758 }
759 
760 contract IFillOrder {
761     function publicFillOrder(bytes32 _orderId, uint256 _amountFillerWants, bytes32 _tradeGroupId) external payable returns (uint256);
762     function fillOrder(address _filler, bytes32 _orderId, uint256 _amountFillerWants, bytes32 tradeGroupId) external returns (uint256);
763 }
764 
765 contract FillOrder is CashAutoConverter, ReentrancyGuard, IFillOrder {
766     using SafeMathUint256 for uint256;
767     using Trade for Trade.Data;
768 
769     // CONSIDER: Do we want the API to be in terms of shares as it is now, or would the desired amount of ETH to place be preferable? Would both be useful?
770     function publicFillOrder(bytes32 _orderId, uint256 _amountFillerWants, bytes32 _tradeGroupId) external payable convertToAndFromCash onlyInGoodTimes returns (uint256) {
771         uint256 _result = this.fillOrder(msg.sender, _orderId, _amountFillerWants, _tradeGroupId);
772         IMarket _market = IOrders(controller.lookup("Orders")).getMarket(_orderId);
773         _market.assertBalances();
774         return _result;
775     }
776 
777     function fillOrder(address _filler, bytes32 _orderId, uint256 _amountFillerWants, bytes32 _tradeGroupId) external onlyWhitelistedCallers nonReentrant returns (uint256) {
778         Trade.Data memory _tradeData = Trade.create(controller, _orderId, _filler, _amountFillerWants);
779         uint256 _marketCreatorFees;
780         uint256 _reporterFees;
781         (_marketCreatorFees, _reporterFees) = _tradeData.tradeMakerSharesForFillerShares();
782         _tradeData.tradeMakerSharesForFillerTokens();
783         _tradeData.tradeMakerTokensForFillerShares();
784         _tradeData.tradeMakerTokensForFillerTokens();
785         // Turn any remaining Cash balance the creator has into ETH. This is done for the filler though the use of a CashAutoConverter modifier. If someone is taking their own order we skip this step since the modifier will do it and they may need the ETH in the tx to make an order later in the context of publicTrade
786         uint256 _creatorCashBalance = _tradeData.contracts.denominationToken.balanceOf(_tradeData.creator.participantAddress);
787         bool _isOwnOrder = _tradeData.creator.participantAddress == _tradeData.filler.participantAddress;
788         if (_creatorCashBalance > 0 && !_isOwnOrder) {
789             _tradeData.contracts.augur.trustedTransfer(_tradeData.contracts.denominationToken, _tradeData.creator.participantAddress, this, _creatorCashBalance);
790             _tradeData.contracts.denominationToken.withdrawEtherToIfPossible(_tradeData.creator.participantAddress, _creatorCashBalance);
791         }
792 
793         uint256 _amountRemainingFillerWants = _tradeData.filler.sharesToSell.add(_tradeData.filler.sharesToBuy);
794         uint256 _amountFilled = _amountFillerWants.sub(_amountRemainingFillerWants);
795         logOrderFilled(_tradeData, _marketCreatorFees, _reporterFees, _amountFilled, _tradeGroupId);
796         _tradeData.contracts.orders.recordFillOrder(_orderId, _tradeData.getMakerSharesDepleted(), _tradeData.getMakerTokensDepleted());
797         return _amountRemainingFillerWants;
798     }
799 
800     function logOrderFilled(Trade.Data _tradeData, uint256 _marketCreatorFees, uint256 _reporterFees, uint256 _amountFilled, bytes32 _tradeGroupId) private returns (bool) {
801         controller.getAugur().logOrderFilled(_tradeData.contracts.market.getUniverse(), _tradeData.contracts.market.getShareToken(_tradeData.order.outcome), _tradeData.filler.participantAddress, _tradeData.order.orderId, _tradeData.getMakerSharesDepleted(), _tradeData.getMakerTokensDepleted(), _tradeData.getFillerSharesDepleted(), _tradeData.getFillerTokensDepleted(), _marketCreatorFees, _reporterFees, _amountFilled, _tradeGroupId);
802         return true;
803     }
804 }
805 
806 contract IOrders {
807     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
808     function removeOrder(bytes32 _orderId) public returns (bool);
809     function getMarket(bytes32 _orderId) public view returns (IMarket);
810     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
811     function getOutcome(bytes32 _orderId) public view returns (uint256);
812     function getAmount(bytes32 _orderId) public view returns (uint256);
813     function getPrice(bytes32 _orderId) public view returns (uint256);
814     function getOrderCreator(bytes32 _orderId) public view returns (address);
815     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
816     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
817     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
818     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
819     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
820     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
821     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
822     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
823     function getTotalEscrowed(IMarket _market) public view returns (uint256);
824     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
825     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
826     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
827     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
828     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
829     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
830     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
831     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
832 }
833 
834 contract IShareToken is ITyped, ERC20 {
835     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
836     function createShares(address _owner, uint256 _amount) external returns (bool);
837     function destroyShares(address, uint256 balance) external returns (bool);
838     function getMarket() external view returns (IMarket);
839     function getOutcome() external view returns (uint256);
840     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
841     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
842     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
843 }
844 
845 library Order {
846     using SafeMathUint256 for uint256;
847 
848     enum Types {
849         Bid, Ask
850     }
851 
852     enum TradeDirections {
853         Long, Short
854     }
855 
856     struct Data {
857         // Contracts
858         IOrders orders;
859         IMarket market;
860         IAugur augur;
861 
862         // Order
863         bytes32 id;
864         address creator;
865         uint256 outcome;
866         Order.Types orderType;
867         uint256 amount;
868         uint256 price;
869         uint256 sharesEscrowed;
870         uint256 moneyEscrowed;
871         bytes32 betterOrderId;
872         bytes32 worseOrderId;
873     }
874 
875     //
876     // Constructor
877     //
878 
879     // No validation is needed here as it is simply a librarty function for organizing data
880     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
881         require(_outcome < _market.getNumberOfOutcomes());
882         require(_price < _market.getNumTicks());
883 
884         IOrders _orders = IOrders(_controller.lookup("Orders"));
885         IAugur _augur = _controller.getAugur();
886 
887         return Data({
888             orders: _orders,
889             market: _market,
890             augur: _augur,
891             id: 0,
892             creator: _creator,
893             outcome: _outcome,
894             orderType: _type,
895             amount: _attoshares,
896             price: _price,
897             sharesEscrowed: 0,
898             moneyEscrowed: 0,
899             betterOrderId: _betterOrderId,
900             worseOrderId: _worseOrderId
901         });
902     }
903 
904     //
905     // "public" functions
906     //
907 
908     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
909         if (_orderData.id == bytes32(0)) {
910             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
911             require(_orderData.orders.getAmount(_orderId) == 0);
912             _orderData.id = _orderId;
913         }
914         return _orderData.id;
915     }
916 
917     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
918         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
919     }
920 
921     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
922         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
923     }
924 
925     function escrowFunds(Order.Data _orderData) internal returns (bool) {
926         if (_orderData.orderType == Order.Types.Ask) {
927             return escrowFundsForAsk(_orderData);
928         } else if (_orderData.orderType == Order.Types.Bid) {
929             return escrowFundsForBid(_orderData);
930         }
931     }
932 
933     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
934         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
935     }
936 
937     //
938     // Private functions
939     //
940 
941     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
942         require(_orderData.moneyEscrowed == 0);
943         require(_orderData.sharesEscrowed == 0);
944         uint256 _attosharesToCover = _orderData.amount;
945         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
946 
947         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
948         uint256 _attosharesHeld = 2**254;
949         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
950             if (_i != _orderData.outcome) {
951                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
952                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
953             }
954         }
955 
956         // Take shares into escrow if they have any almost-complete-sets
957         if (_attosharesHeld > 0) {
958             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
959             _attosharesToCover -= _orderData.sharesEscrowed;
960             for (_i = 0; _i < _numberOfOutcomes; _i++) {
961                 if (_i != _orderData.outcome) {
962                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
963                 }
964             }
965         }
966         // If not able to cover entire order with shares alone, then cover remaining with tokens
967         if (_attosharesToCover > 0) {
968             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
969             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
970         }
971 
972         return true;
973     }
974 
975     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
976         require(_orderData.moneyEscrowed == 0);
977         require(_orderData.sharesEscrowed == 0);
978         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
979         uint256 _attosharesToCover = _orderData.amount;
980 
981         // Figure out how many shares of the outcome the creator has
982         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
983 
984         // Take shares in escrow if user has shares
985         if (_attosharesHeld > 0) {
986             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
987             _attosharesToCover -= _orderData.sharesEscrowed;
988             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
989         }
990 
991         // If not able to cover entire order with shares alone, then cover remaining with tokens
992         if (_attosharesToCover > 0) {
993             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
994             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
995         }
996 
997         return true;
998     }
999 }