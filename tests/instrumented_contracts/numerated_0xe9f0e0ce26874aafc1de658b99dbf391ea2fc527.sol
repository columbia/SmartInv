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
106 contract IOwnable {
107     function getOwner() public view returns (address);
108     function transferOwnership(address newOwner) public returns (bool);
109 }
110 
111 contract ITyped {
112     function getTypeName() public view returns (bytes32);
113 }
114 
115 contract ITime is Controlled, ITyped {
116     function getTimestamp() external view returns (uint256);
117 }
118 
119 contract Time is ITime {
120     function getTimestamp() external view returns (uint256) {
121         return block.timestamp;
122     }
123 
124     function getTypeName() public view returns (bytes32) {
125         return "Time";
126     }
127 }
128 
129 contract Initializable {
130     bool private initialized = false;
131 
132     modifier afterInitialized {
133         require(initialized);
134         _;
135     }
136 
137     modifier beforeInitialized {
138         require(!initialized);
139         _;
140     }
141 
142     function endInitialization() internal beforeInitialized returns (bool) {
143         initialized = true;
144         return true;
145     }
146 
147     function getInitialized() public view returns (bool) {
148         return initialized;
149     }
150 }
151 
152 library SafeMathUint256 {
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a * b;
155         require(a == 0 || c / a == b);
156         return c;
157     }
158 
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         // assert(b > 0); // Solidity automatically throws when dividing by 0
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163         return c;
164     }
165 
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         require(b <= a);
168         return a - b;
169     }
170 
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         uint256 c = a + b;
173         require(c >= a);
174         return c;
175     }
176 
177     function min(uint256 a, uint256 b) internal pure returns (uint256) {
178         if (a <= b) {
179             return a;
180         } else {
181             return b;
182         }
183     }
184 
185     function max(uint256 a, uint256 b) internal pure returns (uint256) {
186         if (a >= b) {
187             return a;
188         } else {
189             return b;
190         }
191     }
192 
193     function getUint256Min() internal pure returns (uint256) {
194         return 0;
195     }
196 
197     function getUint256Max() internal pure returns (uint256) {
198         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
199     }
200 
201     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
202         return a % b == 0;
203     }
204 
205     // Float [fixed point] Operations
206     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
207         return div(mul(a, b), base);
208     }
209 
210     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
211         return div(mul(a, base), b);
212     }
213 }
214 
215 contract ERC20Basic {
216     event Transfer(address indexed from, address indexed to, uint256 value);
217 
218     function balanceOf(address _who) public view returns (uint256);
219     function transfer(address _to, uint256 _value) public returns (bool);
220     function totalSupply() public view returns (uint256);
221 }
222 
223 contract ERC20 is ERC20Basic {
224     event Approval(address indexed owner, address indexed spender, uint256 value);
225 
226     function allowance(address _owner, address _spender) public view returns (uint256);
227     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
228     function approve(address _spender, uint256 _value) public returns (bool);
229 }
230 
231 contract IFeeToken is ERC20, Initializable {
232     function initialize(IFeeWindow _feeWindow) public returns (bool);
233     function getFeeWindow() public view returns (IFeeWindow);
234     function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
235     function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
236 }
237 
238 contract IFeeWindow is ITyped, ERC20 {
239     function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
240     function getUniverse() public view returns (IUniverse);
241     function getReputationToken() public view returns (IReputationToken);
242     function getStartTime() public view returns (uint256);
243     function getEndTime() public view returns (uint256);
244     function getNumMarkets() public view returns (uint256);
245     function getNumInvalidMarkets() public view returns (uint256);
246     function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
247     function getNumDesignatedReportNoShows() public view returns (uint256);
248     function getFeeToken() public view returns (IFeeToken);
249     function isActive() public view returns (bool);
250     function isOver() public view returns (bool);
251     function onMarketFinalized() public returns (bool);
252     function buy(uint256 _attotokens) public returns (bool);
253     function redeem(address _sender) public returns (bool);
254     function redeemForReportingParticipant() public returns (bool);
255     function mintFeeTokens(uint256 _amount) public returns (bool);
256     function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
257 }
258 
259 contract IMailbox {
260     function initialize(address _owner, IMarket _market) public returns (bool);
261     function depositEther() public payable returns (bool);
262 }
263 
264 contract IMarket is ITyped, IOwnable {
265     enum MarketType {
266         YES_NO,
267         CATEGORICAL,
268         SCALAR
269     }
270 
271     function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
272     function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
273     function getUniverse() public view returns (IUniverse);
274     function getFeeWindow() public view returns (IFeeWindow);
275     function getNumberOfOutcomes() public view returns (uint256);
276     function getNumTicks() public view returns (uint256);
277     function getDenominationToken() public view returns (ICash);
278     function getShareToken(uint256 _outcome)  public view returns (IShareToken);
279     function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
280     function getForkingMarket() public view returns (IMarket _market);
281     function getEndTime() public view returns (uint256);
282     function getMarketCreatorMailbox() public view returns (IMailbox);
283     function getWinningPayoutDistributionHash() public view returns (bytes32);
284     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
285     function getReputationToken() public view returns (IReputationToken);
286     function getFinalizationTime() public view returns (uint256);
287     function getInitialReporterAddress() public view returns (address);
288     function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
289     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
290     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
291     function isInvalid() public view returns (bool);
292     function finalize() public returns (bool);
293     function designatedReporterWasCorrect() public view returns (bool);
294     function designatedReporterShowed() public view returns (bool);
295     function isFinalized() public view returns (bool);
296     function finalizeFork() public returns (bool);
297     function assertBalances() public view returns (bool);
298 }
299 
300 contract IReportingParticipant {
301     function getStake() public view returns (uint256);
302     function getPayoutDistributionHash() public view returns (bytes32);
303     function liquidateLosing() public returns (bool);
304     function redeem(address _redeemer) public returns (bool);
305     function isInvalid() public view returns (bool);
306     function isDisavowed() public view returns (bool);
307     function migrate() public returns (bool);
308     function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
309     function getMarket() public view returns (IMarket);
310     function getSize() public view returns (uint256);
311 }
312 
313 contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
314     function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
315     function contribute(address _participant, uint256 _amount) public returns (uint256);
316 }
317 
318 contract IReputationToken is ITyped, ERC20 {
319     function initialize(IUniverse _universe) public returns (bool);
320     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
321     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
322     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
323     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
324     function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
325     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
326     function getUniverse() public view returns (IUniverse);
327     function getTotalMigrated() public view returns (uint256);
328     function getTotalTheoreticalSupply() public view returns (uint256);
329     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
330 }
331 
332 contract IUniverse is ITyped {
333     function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
334     function fork() public returns (bool);
335     function getParentUniverse() public view returns (IUniverse);
336     function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
337     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
338     function getReputationToken() public view returns (IReputationToken);
339     function getForkingMarket() public view returns (IMarket);
340     function getForkEndTime() public view returns (uint256);
341     function getForkReputationGoal() public view returns (uint256);
342     function getParentPayoutDistributionHash() public view returns (bytes32);
343     function getDisputeRoundDurationInSeconds() public view returns (uint256);
344     function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
345     function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
346     function getOrCreateNextFeeWindow() public returns (IFeeWindow);
347     function getOpenInterestInAttoEth() public view returns (uint256);
348     function getRepMarketCapInAttoeth() public view returns (uint256);
349     function getTargetRepMarketCapInAttoeth() public view returns (uint256);
350     function getOrCacheValidityBond() public returns (uint256);
351     function getOrCacheDesignatedReportStake() public returns (uint256);
352     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
353     function getOrCacheReportingFeeDivisor() public returns (uint256);
354     function getDisputeThresholdForFork() public view returns (uint256);
355     function getInitialReportMinValue() public view returns (uint256);
356     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
357     function getOrCacheMarketCreationCost() public returns (uint256);
358     function getCurrentFeeWindow() public view returns (IFeeWindow);
359     function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
360     function isParentOf(IUniverse _shadyChild) public view returns (bool);
361     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
362     function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
363     function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
364     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
365     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
366     function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
367     function addMarketTo() public returns (bool);
368     function removeMarketFrom() public returns (bool);
369     function decrementOpenInterest(uint256 _amount) public returns (bool);
370     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
371     function incrementOpenInterest(uint256 _amount) public returns (bool);
372     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
373     function getWinningChildUniverse() public view returns (IUniverse);
374     function isForking() public view returns (bool);
375 }
376 
377 contract ICash is ERC20 {
378     function depositEther() external payable returns(bool);
379     function depositEtherFor(address _to) external payable returns(bool);
380     function withdrawEther(uint256 _amount) external returns(bool);
381     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
382     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
383 }
384 
385 contract IOrders {
386     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
387     function removeOrder(bytes32 _orderId) public returns (bool);
388     function getMarket(bytes32 _orderId) public view returns (IMarket);
389     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
390     function getOutcome(bytes32 _orderId) public view returns (uint256);
391     function getAmount(bytes32 _orderId) public view returns (uint256);
392     function getPrice(bytes32 _orderId) public view returns (uint256);
393     function getOrderCreator(bytes32 _orderId) public view returns (address);
394     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
395     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
396     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
397     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
398     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
399     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
400     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
401     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
402     function getTotalEscrowed(IMarket _market) public view returns (uint256);
403     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
404     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
405     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
406     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
407     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
408     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
409     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
410     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
411 }
412 
413 contract IShareToken is ITyped, ERC20 {
414     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
415     function createShares(address _owner, uint256 _amount) external returns (bool);
416     function destroyShares(address, uint256 balance) external returns (bool);
417     function getMarket() external view returns (IMarket);
418     function getOutcome() external view returns (uint256);
419     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
420     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
421     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
422 }
423 
424 library Order {
425     using SafeMathUint256 for uint256;
426 
427     enum Types {
428         Bid, Ask
429     }
430 
431     enum TradeDirections {
432         Long, Short
433     }
434 
435     struct Data {
436         // Contracts
437         IOrders orders;
438         IMarket market;
439         IAugur augur;
440 
441         // Order
442         bytes32 id;
443         address creator;
444         uint256 outcome;
445         Order.Types orderType;
446         uint256 amount;
447         uint256 price;
448         uint256 sharesEscrowed;
449         uint256 moneyEscrowed;
450         bytes32 betterOrderId;
451         bytes32 worseOrderId;
452     }
453 
454     //
455     // Constructor
456     //
457 
458     // No validation is needed here as it is simply a librarty function for organizing data
459     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
460         require(_outcome < _market.getNumberOfOutcomes());
461         require(_price < _market.getNumTicks());
462 
463         IOrders _orders = IOrders(_controller.lookup("Orders"));
464         IAugur _augur = _controller.getAugur();
465 
466         return Data({
467             orders: _orders,
468             market: _market,
469             augur: _augur,
470             id: 0,
471             creator: _creator,
472             outcome: _outcome,
473             orderType: _type,
474             amount: _attoshares,
475             price: _price,
476             sharesEscrowed: 0,
477             moneyEscrowed: 0,
478             betterOrderId: _betterOrderId,
479             worseOrderId: _worseOrderId
480         });
481     }
482 
483     //
484     // "public" functions
485     //
486 
487     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
488         if (_orderData.id == bytes32(0)) {
489             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
490             require(_orderData.orders.getAmount(_orderId) == 0);
491             _orderData.id = _orderId;
492         }
493         return _orderData.id;
494     }
495 
496     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
497         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
498     }
499 
500     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
501         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
502     }
503 
504     function escrowFunds(Order.Data _orderData) internal returns (bool) {
505         if (_orderData.orderType == Order.Types.Ask) {
506             return escrowFundsForAsk(_orderData);
507         } else if (_orderData.orderType == Order.Types.Bid) {
508             return escrowFundsForBid(_orderData);
509         }
510     }
511 
512     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
513         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
514     }
515 
516     //
517     // Private functions
518     //
519 
520     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
521         require(_orderData.moneyEscrowed == 0);
522         require(_orderData.sharesEscrowed == 0);
523         uint256 _attosharesToCover = _orderData.amount;
524         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
525 
526         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
527         uint256 _attosharesHeld = 2**254;
528         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
529             if (_i != _orderData.outcome) {
530                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
531                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
532             }
533         }
534 
535         // Take shares into escrow if they have any almost-complete-sets
536         if (_attosharesHeld > 0) {
537             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
538             _attosharesToCover -= _orderData.sharesEscrowed;
539             for (_i = 0; _i < _numberOfOutcomes; _i++) {
540                 if (_i != _orderData.outcome) {
541                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
542                 }
543             }
544         }
545         // If not able to cover entire order with shares alone, then cover remaining with tokens
546         if (_attosharesToCover > 0) {
547             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
548             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
549         }
550 
551         return true;
552     }
553 
554     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
555         require(_orderData.moneyEscrowed == 0);
556         require(_orderData.sharesEscrowed == 0);
557         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
558         uint256 _attosharesToCover = _orderData.amount;
559 
560         // Figure out how many shares of the outcome the creator has
561         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
562 
563         // Take shares in escrow if user has shares
564         if (_attosharesHeld > 0) {
565             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
566             _attosharesToCover -= _orderData.sharesEscrowed;
567             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
568         }
569 
570         // If not able to cover entire order with shares alone, then cover remaining with tokens
571         if (_attosharesToCover > 0) {
572             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
573             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
574         }
575 
576         return true;
577     }
578 }