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
115 contract Initializable {
116     bool private initialized = false;
117 
118     modifier afterInitialized {
119         require(initialized);
120         _;
121     }
122 
123     modifier beforeInitialized {
124         require(!initialized);
125         _;
126     }
127 
128     function endInitialization() internal beforeInitialized returns (bool) {
129         initialized = true;
130         return true;
131     }
132 
133     function getInitialized() public view returns (bool) {
134         return initialized;
135     }
136 }
137 
138 library SafeMathUint256 {
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a * b;
141         require(a == 0 || c / a == b);
142         return c;
143     }
144 
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         // assert(b > 0); // Solidity automatically throws when dividing by 0
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149         return c;
150     }
151 
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b <= a);
154         return a - b;
155     }
156 
157     function add(uint256 a, uint256 b) internal pure returns (uint256) {
158         uint256 c = a + b;
159         require(c >= a);
160         return c;
161     }
162 
163     function min(uint256 a, uint256 b) internal pure returns (uint256) {
164         if (a <= b) {
165             return a;
166         } else {
167             return b;
168         }
169     }
170 
171     function max(uint256 a, uint256 b) internal pure returns (uint256) {
172         if (a >= b) {
173             return a;
174         } else {
175             return b;
176         }
177     }
178 
179     function getUint256Min() internal pure returns (uint256) {
180         return 0;
181     }
182 
183     function getUint256Max() internal pure returns (uint256) {
184         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
185     }
186 
187     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
188         return a % b == 0;
189     }
190 
191     // Float [fixed point] Operations
192     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
193         return div(mul(a, b), base);
194     }
195 
196     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
197         return div(mul(a, base), b);
198     }
199 }
200 
201 contract ERC20Basic {
202     event Transfer(address indexed from, address indexed to, uint256 value);
203 
204     function balanceOf(address _who) public view returns (uint256);
205     function transfer(address _to, uint256 _value) public returns (bool);
206     function totalSupply() public view returns (uint256);
207 }
208 
209 contract ERC20 is ERC20Basic {
210     event Approval(address indexed owner, address indexed spender, uint256 value);
211 
212     function allowance(address _owner, address _spender) public view returns (uint256);
213     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
214     function approve(address _spender, uint256 _value) public returns (bool);
215 }
216 
217 contract IFeeToken is ERC20, Initializable {
218     function initialize(IFeeWindow _feeWindow) public returns (bool);
219     function getFeeWindow() public view returns (IFeeWindow);
220     function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
221     function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
222 }
223 
224 contract IFeeWindow is ITyped, ERC20 {
225     function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
226     function getUniverse() public view returns (IUniverse);
227     function getReputationToken() public view returns (IReputationToken);
228     function getStartTime() public view returns (uint256);
229     function getEndTime() public view returns (uint256);
230     function getNumMarkets() public view returns (uint256);
231     function getNumInvalidMarkets() public view returns (uint256);
232     function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
233     function getNumDesignatedReportNoShows() public view returns (uint256);
234     function getFeeToken() public view returns (IFeeToken);
235     function isActive() public view returns (bool);
236     function isOver() public view returns (bool);
237     function onMarketFinalized() public returns (bool);
238     function buy(uint256 _attotokens) public returns (bool);
239     function redeem(address _sender) public returns (bool);
240     function redeemForReportingParticipant() public returns (bool);
241     function mintFeeTokens(uint256 _amount) public returns (bool);
242     function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
243 }
244 
245 contract IMailbox {
246     function initialize(address _owner, IMarket _market) public returns (bool);
247     function depositEther() public payable returns (bool);
248 }
249 
250 contract IMarket is ITyped, IOwnable {
251     enum MarketType {
252         YES_NO,
253         CATEGORICAL,
254         SCALAR
255     }
256 
257     function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
258     function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
259     function getUniverse() public view returns (IUniverse);
260     function getFeeWindow() public view returns (IFeeWindow);
261     function getNumberOfOutcomes() public view returns (uint256);
262     function getNumTicks() public view returns (uint256);
263     function getDenominationToken() public view returns (ICash);
264     function getShareToken(uint256 _outcome)  public view returns (IShareToken);
265     function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
266     function getForkingMarket() public view returns (IMarket _market);
267     function getEndTime() public view returns (uint256);
268     function getMarketCreatorMailbox() public view returns (IMailbox);
269     function getWinningPayoutDistributionHash() public view returns (bytes32);
270     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
271     function getReputationToken() public view returns (IReputationToken);
272     function getFinalizationTime() public view returns (uint256);
273     function getInitialReporterAddress() public view returns (address);
274     function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
275     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
276     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
277     function isInvalid() public view returns (bool);
278     function finalize() public returns (bool);
279     function designatedReporterWasCorrect() public view returns (bool);
280     function designatedReporterShowed() public view returns (bool);
281     function isFinalized() public view returns (bool);
282     function finalizeFork() public returns (bool);
283     function assertBalances() public view returns (bool);
284 }
285 
286 contract IReportingParticipant {
287     function getStake() public view returns (uint256);
288     function getPayoutDistributionHash() public view returns (bytes32);
289     function liquidateLosing() public returns (bool);
290     function redeem(address _redeemer) public returns (bool);
291     function isInvalid() public view returns (bool);
292     function isDisavowed() public view returns (bool);
293     function migrate() public returns (bool);
294     function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
295     function getMarket() public view returns (IMarket);
296     function getSize() public view returns (uint256);
297 }
298 
299 contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
300     function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
301     function contribute(address _participant, uint256 _amount) public returns (uint256);
302 }
303 
304 contract IReputationToken is ITyped, ERC20 {
305     function initialize(IUniverse _universe) public returns (bool);
306     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
307     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
308     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
309     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
310     function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
311     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
312     function getUniverse() public view returns (IUniverse);
313     function getTotalMigrated() public view returns (uint256);
314     function getTotalTheoreticalSupply() public view returns (uint256);
315     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
316 }
317 
318 contract IUniverse is ITyped {
319     function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
320     function fork() public returns (bool);
321     function getParentUniverse() public view returns (IUniverse);
322     function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
323     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
324     function getReputationToken() public view returns (IReputationToken);
325     function getForkingMarket() public view returns (IMarket);
326     function getForkEndTime() public view returns (uint256);
327     function getForkReputationGoal() public view returns (uint256);
328     function getParentPayoutDistributionHash() public view returns (bytes32);
329     function getDisputeRoundDurationInSeconds() public view returns (uint256);
330     function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
331     function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
332     function getOrCreateNextFeeWindow() public returns (IFeeWindow);
333     function getOpenInterestInAttoEth() public view returns (uint256);
334     function getRepMarketCapInAttoeth() public view returns (uint256);
335     function getTargetRepMarketCapInAttoeth() public view returns (uint256);
336     function getOrCacheValidityBond() public returns (uint256);
337     function getOrCacheDesignatedReportStake() public returns (uint256);
338     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
339     function getOrCacheReportingFeeDivisor() public returns (uint256);
340     function getDisputeThresholdForFork() public view returns (uint256);
341     function getInitialReportMinValue() public view returns (uint256);
342     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
343     function getOrCacheMarketCreationCost() public returns (uint256);
344     function getCurrentFeeWindow() public view returns (IFeeWindow);
345     function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
346     function isParentOf(IUniverse _shadyChild) public view returns (bool);
347     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
348     function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
349     function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
350     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
351     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
352     function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
353     function addMarketTo() public returns (bool);
354     function removeMarketFrom() public returns (bool);
355     function decrementOpenInterest(uint256 _amount) public returns (bool);
356     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
357     function incrementOpenInterest(uint256 _amount) public returns (bool);
358     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
359     function getWinningChildUniverse() public view returns (IUniverse);
360     function isForking() public view returns (bool);
361 }
362 
363 contract ICash is ERC20 {
364     function depositEther() external payable returns(bool);
365     function depositEtherFor(address _to) external payable returns(bool);
366     function withdrawEther(uint256 _amount) external returns(bool);
367     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
368     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
369 }
370 
371 contract IOrders {
372     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
373     function removeOrder(bytes32 _orderId) public returns (bool);
374     function getMarket(bytes32 _orderId) public view returns (IMarket);
375     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
376     function getOutcome(bytes32 _orderId) public view returns (uint256);
377     function getAmount(bytes32 _orderId) public view returns (uint256);
378     function getPrice(bytes32 _orderId) public view returns (uint256);
379     function getOrderCreator(bytes32 _orderId) public view returns (address);
380     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
381     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
382     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
383     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
384     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
385     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
386     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
387     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
388     function getTotalEscrowed(IMarket _market) public view returns (uint256);
389     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
390     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
391     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
392     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
393     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
394     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
395     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
396     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
397 }
398 
399 contract IOrdersFetcher {
400     function findBoundingOrders(Order.Types _type, uint256 _price, bytes32 _bestOrderId, bytes32 _worstOrderId, bytes32 _betterOrderId, bytes32 _worseOrderId) public returns (bytes32, bytes32);
401 }
402 
403 contract IShareToken is ITyped, ERC20 {
404     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
405     function createShares(address _owner, uint256 _amount) external returns (bool);
406     function destroyShares(address, uint256 balance) external returns (bool);
407     function getMarket() external view returns (IMarket);
408     function getOutcome() external view returns (uint256);
409     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
410     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
411     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
412 }
413 
414 library Order {
415     using SafeMathUint256 for uint256;
416 
417     enum Types {
418         Bid, Ask
419     }
420 
421     enum TradeDirections {
422         Long, Short
423     }
424 
425     struct Data {
426         // Contracts
427         IOrders orders;
428         IMarket market;
429         IAugur augur;
430 
431         // Order
432         bytes32 id;
433         address creator;
434         uint256 outcome;
435         Order.Types orderType;
436         uint256 amount;
437         uint256 price;
438         uint256 sharesEscrowed;
439         uint256 moneyEscrowed;
440         bytes32 betterOrderId;
441         bytes32 worseOrderId;
442     }
443 
444     //
445     // Constructor
446     //
447 
448     // No validation is needed here as it is simply a librarty function for organizing data
449     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
450         require(_outcome < _market.getNumberOfOutcomes());
451         require(_price < _market.getNumTicks());
452 
453         IOrders _orders = IOrders(_controller.lookup("Orders"));
454         IAugur _augur = _controller.getAugur();
455 
456         return Data({
457             orders: _orders,
458             market: _market,
459             augur: _augur,
460             id: 0,
461             creator: _creator,
462             outcome: _outcome,
463             orderType: _type,
464             amount: _attoshares,
465             price: _price,
466             sharesEscrowed: 0,
467             moneyEscrowed: 0,
468             betterOrderId: _betterOrderId,
469             worseOrderId: _worseOrderId
470         });
471     }
472 
473     //
474     // "public" functions
475     //
476 
477     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
478         if (_orderData.id == bytes32(0)) {
479             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
480             require(_orderData.orders.getAmount(_orderId) == 0);
481             _orderData.id = _orderId;
482         }
483         return _orderData.id;
484     }
485 
486     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
487         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
488     }
489 
490     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
491         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
492     }
493 
494     function escrowFunds(Order.Data _orderData) internal returns (bool) {
495         if (_orderData.orderType == Order.Types.Ask) {
496             return escrowFundsForAsk(_orderData);
497         } else if (_orderData.orderType == Order.Types.Bid) {
498             return escrowFundsForBid(_orderData);
499         }
500     }
501 
502     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
503         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
504     }
505 
506     //
507     // Private functions
508     //
509 
510     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
511         require(_orderData.moneyEscrowed == 0);
512         require(_orderData.sharesEscrowed == 0);
513         uint256 _attosharesToCover = _orderData.amount;
514         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
515 
516         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
517         uint256 _attosharesHeld = 2**254;
518         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
519             if (_i != _orderData.outcome) {
520                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
521                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
522             }
523         }
524 
525         // Take shares into escrow if they have any almost-complete-sets
526         if (_attosharesHeld > 0) {
527             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
528             _attosharesToCover -= _orderData.sharesEscrowed;
529             for (_i = 0; _i < _numberOfOutcomes; _i++) {
530                 if (_i != _orderData.outcome) {
531                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
532                 }
533             }
534         }
535         // If not able to cover entire order with shares alone, then cover remaining with tokens
536         if (_attosharesToCover > 0) {
537             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
538             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
539         }
540 
541         return true;
542     }
543 
544     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
545         require(_orderData.moneyEscrowed == 0);
546         require(_orderData.sharesEscrowed == 0);
547         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
548         uint256 _attosharesToCover = _orderData.amount;
549 
550         // Figure out how many shares of the outcome the creator has
551         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
552 
553         // Take shares in escrow if user has shares
554         if (_attosharesHeld > 0) {
555             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
556             _attosharesToCover -= _orderData.sharesEscrowed;
557             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
558         }
559 
560         // If not able to cover entire order with shares alone, then cover remaining with tokens
561         if (_attosharesToCover > 0) {
562             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
563             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
564         }
565 
566         return true;
567     }
568 }
569 
570 contract OrdersFetcher is Controlled, IOrdersFetcher {
571     function ascendOrderList(Order.Types _type, uint256 _price, bytes32 _lowestOrderId) public view returns (bytes32 _betterOrderId, bytes32 _worseOrderId) {
572         _worseOrderId = _lowestOrderId;
573         bool _isWorstPrice;
574         IOrders _orders = IOrders(controller.lookup("Orders"));
575         if (_type == Order.Types.Bid) {
576             _isWorstPrice = _price <= _orders.getPrice(_worseOrderId);
577         } else if (_type == Order.Types.Ask) {
578             _isWorstPrice = _price >= _orders.getPrice(_worseOrderId);
579         }
580         if (_isWorstPrice) {
581             return (_worseOrderId, _orders.getWorseOrderId(_worseOrderId));
582         }
583         bool _isBetterPrice = _orders.isBetterPrice(_type, _price, _worseOrderId);
584         while (_isBetterPrice && _orders.getBetterOrderId(_worseOrderId) != 0 && _price != _orders.getPrice(_orders.getBetterOrderId(_worseOrderId))) {
585             _betterOrderId = _orders.getBetterOrderId(_worseOrderId);
586             _isBetterPrice = _orders.isBetterPrice(_type, _price, _betterOrderId);
587             if (_isBetterPrice) {
588                 _worseOrderId = _orders.getBetterOrderId(_worseOrderId);
589             }
590         }
591         _betterOrderId = _orders.getBetterOrderId(_worseOrderId);
592         return (_betterOrderId, _worseOrderId);
593     }
594 
595     function descendOrderList(Order.Types _type, uint256 _price, bytes32 _highestOrderId) public view returns (bytes32 _betterOrderId, bytes32 _worseOrderId) {
596         _betterOrderId = _highestOrderId;
597         bool _isBestPrice;
598         IOrders _orders = IOrders(controller.lookup("Orders"));
599         if (_type == Order.Types.Bid) {
600             _isBestPrice = _price > _orders.getPrice(_betterOrderId);
601         } else if (_type == Order.Types.Ask) {
602             _isBestPrice = _price < _orders.getPrice(_betterOrderId);
603         }
604         if (_isBestPrice) {
605             return (0, _betterOrderId);
606         }
607         if (_price == _orders.getPrice(_betterOrderId)) {
608             return (_betterOrderId, _orders.getWorseOrderId(_betterOrderId));
609         }
610         bool _isWorsePrice = _orders.isWorsePrice(_type, _price, _betterOrderId);
611         while (_isWorsePrice && _orders.getWorseOrderId(_betterOrderId) != 0) {
612             _worseOrderId = _orders.getWorseOrderId(_betterOrderId);
613             _isWorsePrice = _orders.isWorsePrice(_type, _price, _worseOrderId);
614             if (_isWorsePrice || _price == _orders.getPrice(_orders.getWorseOrderId(_betterOrderId))) {
615                 _betterOrderId = _orders.getWorseOrderId(_betterOrderId);
616             }
617         }
618         _worseOrderId = _orders.getWorseOrderId(_betterOrderId);
619         return (_betterOrderId, _worseOrderId);
620     }
621 
622     function findBoundingOrders(Order.Types _type, uint256 _price, bytes32 _bestOrderId, bytes32 _worstOrderId, bytes32 _betterOrderId, bytes32 _worseOrderId) public returns (bytes32, bytes32) {
623         IOrders _orders = IOrders(controller.lookup("Orders"));
624         if (_bestOrderId == _worstOrderId) {
625             if (_bestOrderId == bytes32(0)) {
626                 return (bytes32(0), bytes32(0));
627             } else if (_orders.isBetterPrice(_type, _price, _bestOrderId)) {
628                 return (bytes32(0), _bestOrderId);
629             } else {
630                 return (_bestOrderId, bytes32(0));
631             }
632         }
633         if (_betterOrderId != bytes32(0)) {
634             if (_orders.getPrice(_betterOrderId) == 0) {
635                 _betterOrderId = bytes32(0);
636             } else {
637                 _orders.assertIsNotBetterPrice(_type, _price, _betterOrderId);
638             }
639         }
640         if (_worseOrderId != bytes32(0)) {
641             if (_orders.getPrice(_worseOrderId) == 0) {
642                 _worseOrderId = bytes32(0);
643             } else {
644                 _orders.assertIsNotWorsePrice(_type, _price, _worseOrderId);
645             }
646         }
647         if (_betterOrderId == bytes32(0) && _worseOrderId == bytes32(0)) {
648             return (descendOrderList(_type, _price, _bestOrderId));
649         } else if (_betterOrderId == bytes32(0)) {
650             return (ascendOrderList(_type, _price, _worseOrderId));
651         } else if (_worseOrderId == bytes32(0)) {
652             return (descendOrderList(_type, _price, _betterOrderId));
653         }
654         if (_orders.getWorseOrderId(_betterOrderId) != _worseOrderId) {
655             return (descendOrderList(_type, _price, _betterOrderId));
656         } else if (_orders.getBetterOrderId(_worseOrderId) != _betterOrderId) {
657             // Coverage: This condition is likely unreachable or at least seems to be. Rather than remove it I'm keeping it for now just to be paranoid
658             return (ascendOrderList(_type, _price, _worseOrderId));
659         }
660         return (_betterOrderId, _worseOrderId);
661     }
662 }