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
419 contract CreateOrder is CashAutoConverter, ReentrancyGuard, MarketValidator {
420     using Order for Order.Data;
421 
422     // CONSIDER: Do we want the API to be in terms of shares as it is now, or would the desired amount of ETH to place be preferable? Would both be useful?
423     function publicCreateOrder(Order.Types _type, uint256 _attoshares, uint256 _displayPrice, IMarket _market, uint256 _outcome, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) external payable marketIsLegit(_market) convertToAndFromCash onlyInGoodTimes returns (bytes32) {
424         bytes32 _result = this.createOrder(msg.sender, _type, _attoshares, _displayPrice, _market, _outcome, _betterOrderId, _worseOrderId, _tradeGroupId);
425         _market.assertBalances();
426         return _result;
427     }
428 
429     function createOrder(address _creator, Order.Types _type, uint256 _attoshares, uint256 _displayPrice, IMarket _market, uint256 _outcome, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) external onlyWhitelistedCallers nonReentrant returns (bytes32) {
430         Order.Data memory _orderData = Order.create(controller, _creator, _outcome, _type, _attoshares, _displayPrice, _market, _betterOrderId, _worseOrderId);
431         Order.escrowFunds(_orderData);
432         require(_orderData.orders.getAmount(_orderData.getOrderId()) == 0);
433         return Order.saveOrder(_orderData, _tradeGroupId);
434     }
435 }
436 
437 contract ICash is ERC20 {
438     function depositEther() external payable returns(bool);
439     function depositEtherFor(address _to) external payable returns(bool);
440     function withdrawEther(uint256 _amount) external returns(bool);
441     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
442     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
443 }
444 
445 contract ICreateOrder {
446     function publicCreateOrder(Order.Types, uint256, uint256, IMarket, uint256, bytes32, bytes32, bytes32) external payable returns (bytes32);
447     function createOrder(address, Order.Types, uint256, uint256, IMarket, uint256, bytes32, bytes32, bytes32) external returns (bytes32);
448 }
449 
450 contract IOrders {
451     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
452     function removeOrder(bytes32 _orderId) public returns (bool);
453     function getMarket(bytes32 _orderId) public view returns (IMarket);
454     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
455     function getOutcome(bytes32 _orderId) public view returns (uint256);
456     function getAmount(bytes32 _orderId) public view returns (uint256);
457     function getPrice(bytes32 _orderId) public view returns (uint256);
458     function getOrderCreator(bytes32 _orderId) public view returns (address);
459     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
460     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
461     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
462     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
463     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
464     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
465     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
466     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
467     function getTotalEscrowed(IMarket _market) public view returns (uint256);
468     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
469     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
470     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
471     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
472     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
473     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
474     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
475     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
476 }
477 
478 contract IShareToken is ITyped, ERC20 {
479     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
480     function createShares(address _owner, uint256 _amount) external returns (bool);
481     function destroyShares(address, uint256 balance) external returns (bool);
482     function getMarket() external view returns (IMarket);
483     function getOutcome() external view returns (uint256);
484     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
485     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
486     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
487 }
488 
489 library Order {
490     using SafeMathUint256 for uint256;
491 
492     enum Types {
493         Bid, Ask
494     }
495 
496     enum TradeDirections {
497         Long, Short
498     }
499 
500     struct Data {
501         // Contracts
502         IOrders orders;
503         IMarket market;
504         IAugur augur;
505 
506         // Order
507         bytes32 id;
508         address creator;
509         uint256 outcome;
510         Order.Types orderType;
511         uint256 amount;
512         uint256 price;
513         uint256 sharesEscrowed;
514         uint256 moneyEscrowed;
515         bytes32 betterOrderId;
516         bytes32 worseOrderId;
517     }
518 
519     //
520     // Constructor
521     //
522 
523     // No validation is needed here as it is simply a librarty function for organizing data
524     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
525         require(_outcome < _market.getNumberOfOutcomes());
526         require(_price < _market.getNumTicks());
527 
528         IOrders _orders = IOrders(_controller.lookup("Orders"));
529         IAugur _augur = _controller.getAugur();
530 
531         return Data({
532             orders: _orders,
533             market: _market,
534             augur: _augur,
535             id: 0,
536             creator: _creator,
537             outcome: _outcome,
538             orderType: _type,
539             amount: _attoshares,
540             price: _price,
541             sharesEscrowed: 0,
542             moneyEscrowed: 0,
543             betterOrderId: _betterOrderId,
544             worseOrderId: _worseOrderId
545         });
546     }
547 
548     //
549     // "public" functions
550     //
551 
552     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
553         if (_orderData.id == bytes32(0)) {
554             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
555             require(_orderData.orders.getAmount(_orderId) == 0);
556             _orderData.id = _orderId;
557         }
558         return _orderData.id;
559     }
560 
561     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
562         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
563     }
564 
565     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
566         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
567     }
568 
569     function escrowFunds(Order.Data _orderData) internal returns (bool) {
570         if (_orderData.orderType == Order.Types.Ask) {
571             return escrowFundsForAsk(_orderData);
572         } else if (_orderData.orderType == Order.Types.Bid) {
573             return escrowFundsForBid(_orderData);
574         }
575     }
576 
577     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
578         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
579     }
580 
581     //
582     // Private functions
583     //
584 
585     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
586         require(_orderData.moneyEscrowed == 0);
587         require(_orderData.sharesEscrowed == 0);
588         uint256 _attosharesToCover = _orderData.amount;
589         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
590 
591         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
592         uint256 _attosharesHeld = 2**254;
593         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
594             if (_i != _orderData.outcome) {
595                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
596                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
597             }
598         }
599 
600         // Take shares into escrow if they have any almost-complete-sets
601         if (_attosharesHeld > 0) {
602             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
603             _attosharesToCover -= _orderData.sharesEscrowed;
604             for (_i = 0; _i < _numberOfOutcomes; _i++) {
605                 if (_i != _orderData.outcome) {
606                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
607                 }
608             }
609         }
610         // If not able to cover entire order with shares alone, then cover remaining with tokens
611         if (_attosharesToCover > 0) {
612             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
613             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
614         }
615 
616         return true;
617     }
618 
619     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
620         require(_orderData.moneyEscrowed == 0);
621         require(_orderData.sharesEscrowed == 0);
622         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
623         uint256 _attosharesToCover = _orderData.amount;
624 
625         // Figure out how many shares of the outcome the creator has
626         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
627 
628         // Take shares in escrow if user has shares
629         if (_attosharesHeld > 0) {
630             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
631             _attosharesToCover -= _orderData.sharesEscrowed;
632             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
633         }
634 
635         // If not able to cover entire order with shares alone, then cover remaining with tokens
636         if (_attosharesToCover > 0) {
637             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
638             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
639         }
640 
641         return true;
642     }
643 }