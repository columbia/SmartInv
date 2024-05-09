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
410 contract ICancelOrder {
411 
412 }
413 
414 contract CancelOrder is CashAutoConverter, ReentrancyGuard, ICancelOrder {
415     /**
416      * @dev Cancellation: cancels an order, if a bid refunds money, if an ask returns shares
417      * @return true if successful; throw on failure
418      */
419     function cancelOrder(bytes32 _orderId) nonReentrant convertToAndFromCash external returns (bool) {
420         require(_orderId != bytes32(0));
421 
422         // Look up the order the sender wants to cancel
423         IOrders _orders = IOrders(controller.lookup("Orders"));
424         uint256 _moneyEscrowed = _orders.getOrderMoneyEscrowed(_orderId);
425         uint256 _sharesEscrowed = _orders.getOrderSharesEscrowed(_orderId);
426         Order.Types _type = _orders.getOrderType(_orderId);
427         IMarket _market = _orders.getMarket(_orderId);
428         uint256 _outcome = _orders.getOutcome(_orderId);
429 
430         // Check that the order ID is correct and that the sender owns the order
431         require(msg.sender == _orders.getOrderCreator(_orderId));
432 
433         // Clear the order first
434         _orders.removeOrder(_orderId);
435 
436         refundOrder(msg.sender, _type, _sharesEscrowed, _moneyEscrowed, _market, _outcome);
437         _orders.decrementTotalEscrowed(_market, _moneyEscrowed);
438         _market.assertBalances();
439 
440         controller.getAugur().logOrderCanceled(_market.getUniverse(), _market.getShareToken(_outcome), msg.sender, _orderId, _type, _moneyEscrowed, _sharesEscrowed);
441 
442         return true;
443     }
444 
445     /**
446      * @dev Issue refunds
447      */
448     function refundOrder(address _sender, Order.Types _type, uint256 _sharesEscrowed, uint256 _moneyEscrowed, IMarket _market, uint256 _outcome) private returns (bool) {
449         if (_sharesEscrowed > 0) {
450             // Return to user sharesEscrowed that weren't filled yet for all outcomes except the order outcome
451             if (_type == Order.Types.Bid) {
452                 for (uint256 _i = 0; _i < _market.getNumberOfOutcomes(); ++_i) {
453                     if (_i != _outcome) {
454                         _market.getShareToken(_i).trustedCancelOrderTransfer(_market, _sender, _sharesEscrowed);
455                     }
456                 }
457             // Shares refund if has shares escrowed for this outcome
458             } else {
459                 _market.getShareToken(_outcome).trustedCancelOrderTransfer(_market, _sender, _sharesEscrowed);
460             }
461         }
462 
463         // Return to user moneyEscrowed that wasn't filled yet
464         if (_moneyEscrowed > 0) {
465             ICash _denominationToken = _market.getDenominationToken();
466             require(_denominationToken.transferFrom(_market, _sender, _moneyEscrowed));
467         }
468 
469         return true;
470     }
471 }
472 
473 contract ICash is ERC20 {
474     function depositEther() external payable returns(bool);
475     function depositEtherFor(address _to) external payable returns(bool);
476     function withdrawEther(uint256 _amount) external returns(bool);
477     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
478     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
479 }
480 
481 contract IOrders {
482     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
483     function removeOrder(bytes32 _orderId) public returns (bool);
484     function getMarket(bytes32 _orderId) public view returns (IMarket);
485     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
486     function getOutcome(bytes32 _orderId) public view returns (uint256);
487     function getAmount(bytes32 _orderId) public view returns (uint256);
488     function getPrice(bytes32 _orderId) public view returns (uint256);
489     function getOrderCreator(bytes32 _orderId) public view returns (address);
490     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
491     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
492     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
493     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
494     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
495     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
496     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
497     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
498     function getTotalEscrowed(IMarket _market) public view returns (uint256);
499     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
500     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
501     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
502     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
503     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
504     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
505     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
506     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
507 }
508 
509 contract IShareToken is ITyped, ERC20 {
510     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
511     function createShares(address _owner, uint256 _amount) external returns (bool);
512     function destroyShares(address, uint256 balance) external returns (bool);
513     function getMarket() external view returns (IMarket);
514     function getOutcome() external view returns (uint256);
515     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
516     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
517     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
518 }
519 
520 library Order {
521     using SafeMathUint256 for uint256;
522 
523     enum Types {
524         Bid, Ask
525     }
526 
527     enum TradeDirections {
528         Long, Short
529     }
530 
531     struct Data {
532         // Contracts
533         IOrders orders;
534         IMarket market;
535         IAugur augur;
536 
537         // Order
538         bytes32 id;
539         address creator;
540         uint256 outcome;
541         Order.Types orderType;
542         uint256 amount;
543         uint256 price;
544         uint256 sharesEscrowed;
545         uint256 moneyEscrowed;
546         bytes32 betterOrderId;
547         bytes32 worseOrderId;
548     }
549 
550     //
551     // Constructor
552     //
553 
554     // No validation is needed here as it is simply a librarty function for organizing data
555     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
556         require(_outcome < _market.getNumberOfOutcomes());
557         require(_price < _market.getNumTicks());
558 
559         IOrders _orders = IOrders(_controller.lookup("Orders"));
560         IAugur _augur = _controller.getAugur();
561 
562         return Data({
563             orders: _orders,
564             market: _market,
565             augur: _augur,
566             id: 0,
567             creator: _creator,
568             outcome: _outcome,
569             orderType: _type,
570             amount: _attoshares,
571             price: _price,
572             sharesEscrowed: 0,
573             moneyEscrowed: 0,
574             betterOrderId: _betterOrderId,
575             worseOrderId: _worseOrderId
576         });
577     }
578 
579     //
580     // "public" functions
581     //
582 
583     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
584         if (_orderData.id == bytes32(0)) {
585             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
586             require(_orderData.orders.getAmount(_orderId) == 0);
587             _orderData.id = _orderId;
588         }
589         return _orderData.id;
590     }
591 
592     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
593         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
594     }
595 
596     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
597         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
598     }
599 
600     function escrowFunds(Order.Data _orderData) internal returns (bool) {
601         if (_orderData.orderType == Order.Types.Ask) {
602             return escrowFundsForAsk(_orderData);
603         } else if (_orderData.orderType == Order.Types.Bid) {
604             return escrowFundsForBid(_orderData);
605         }
606     }
607 
608     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
609         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
610     }
611 
612     //
613     // Private functions
614     //
615 
616     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
617         require(_orderData.moneyEscrowed == 0);
618         require(_orderData.sharesEscrowed == 0);
619         uint256 _attosharesToCover = _orderData.amount;
620         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
621 
622         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
623         uint256 _attosharesHeld = 2**254;
624         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
625             if (_i != _orderData.outcome) {
626                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
627                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
628             }
629         }
630 
631         // Take shares into escrow if they have any almost-complete-sets
632         if (_attosharesHeld > 0) {
633             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
634             _attosharesToCover -= _orderData.sharesEscrowed;
635             for (_i = 0; _i < _numberOfOutcomes; _i++) {
636                 if (_i != _orderData.outcome) {
637                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
638                 }
639             }
640         }
641         // If not able to cover entire order with shares alone, then cover remaining with tokens
642         if (_attosharesToCover > 0) {
643             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
644             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
645         }
646 
647         return true;
648     }
649 
650     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
651         require(_orderData.moneyEscrowed == 0);
652         require(_orderData.sharesEscrowed == 0);
653         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
654         uint256 _attosharesToCover = _orderData.amount;
655 
656         // Figure out how many shares of the outcome the creator has
657         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
658 
659         // Take shares in escrow if user has shares
660         if (_attosharesHeld > 0) {
661             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
662             _attosharesToCover -= _orderData.sharesEscrowed;
663             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
664         }
665 
666         // If not able to cover entire order with shares alone, then cover remaining with tokens
667         if (_attosharesToCover > 0) {
668             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
669             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
670         }
671 
672         return true;
673     }
674 }