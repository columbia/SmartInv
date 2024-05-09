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
50 contract IController {
51     function assertIsWhitelisted(address _target) public view returns(bool);
52     function lookup(bytes32 _key) public view returns(address);
53     function stopInEmergency() public view returns(bool);
54     function onlyInEmergency() public view returns(bool);
55     function getAugur() public view returns (IAugur);
56     function getTimestamp() public view returns (uint256);
57     function emergencyStop() public returns (bool);
58 }
59 
60 contract IOwnable {
61     function getOwner() public view returns (address);
62     function transferOwnership(address newOwner) public returns (bool);
63 }
64 
65 contract ITyped {
66     function getTypeName() public view returns (bytes32);
67 }
68 
69 contract Initializable {
70     bool private initialized = false;
71 
72     modifier afterInitialized {
73         require(initialized);
74         _;
75     }
76 
77     modifier beforeInitialized {
78         require(!initialized);
79         _;
80     }
81 
82     function endInitialization() internal beforeInitialized returns (bool) {
83         initialized = true;
84         return true;
85     }
86 
87     function getInitialized() public view returns (bool) {
88         return initialized;
89     }
90 }
91 
92 contract Ownable is IOwnable {
93     address internal owner;
94 
95     /**
96      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
97      * account.
98      */
99     function Ownable() public {
100         owner = msg.sender;
101     }
102 
103     /**
104      * @dev Throws if called by any account other than the owner.
105      */
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110 
111     function getOwner() public view returns (address) {
112         return owner;
113     }
114 
115     /**
116      * @dev Allows the current owner to transfer control of the contract to a newOwner.
117      * @param _newOwner The address to transfer ownership to.
118      */
119     function transferOwnership(address _newOwner) public onlyOwner returns (bool) {
120         if (_newOwner != address(0)) {
121             onTransferOwnership(owner, _newOwner);
122             owner = _newOwner;
123         }
124         return true;
125     }
126 
127     // Subclasses of this token may want to send additional logs through the centralized Augur log emitter contract
128     function onTransferOwnership(address, address) internal returns (bool);
129 }
130 
131 contract EscapeHatchController is Ownable {
132     IController public controller;
133 
134     function setController(IController _controller) public onlyOwner returns (bool) {
135         controller = _controller;
136         return true;
137     }
138 
139     function emergencyStop() public onlyOwner returns (bool) {
140         controller.emergencyStop();
141         return true;
142     }
143 
144     function onTransferOwnership(address, address) internal returns (bool) {
145         return true;
146     }
147 }
148 
149 library SafeMathUint256 {
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         uint256 c = a * b;
152         require(a == 0 || c / a == b);
153         return c;
154     }
155 
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         // assert(b > 0); // Solidity automatically throws when dividing by 0
158         uint256 c = a / b;
159         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160         return c;
161     }
162 
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b <= a);
165         return a - b;
166     }
167 
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         uint256 c = a + b;
170         require(c >= a);
171         return c;
172     }
173 
174     function min(uint256 a, uint256 b) internal pure returns (uint256) {
175         if (a <= b) {
176             return a;
177         } else {
178             return b;
179         }
180     }
181 
182     function max(uint256 a, uint256 b) internal pure returns (uint256) {
183         if (a >= b) {
184             return a;
185         } else {
186             return b;
187         }
188     }
189 
190     function getUint256Min() internal pure returns (uint256) {
191         return 0;
192     }
193 
194     function getUint256Max() internal pure returns (uint256) {
195         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
196     }
197 
198     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
199         return a % b == 0;
200     }
201 
202     // Float [fixed point] Operations
203     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
204         return div(mul(a, b), base);
205     }
206 
207     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
208         return div(mul(a, base), b);
209     }
210 }
211 
212 contract ERC20Basic {
213     event Transfer(address indexed from, address indexed to, uint256 value);
214 
215     function balanceOf(address _who) public view returns (uint256);
216     function transfer(address _to, uint256 _value) public returns (bool);
217     function totalSupply() public view returns (uint256);
218 }
219 
220 contract ERC20 is ERC20Basic {
221     event Approval(address indexed owner, address indexed spender, uint256 value);
222 
223     function allowance(address _owner, address _spender) public view returns (uint256);
224     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
225     function approve(address _spender, uint256 _value) public returns (bool);
226 }
227 
228 contract IFeeToken is ERC20, Initializable {
229     function initialize(IFeeWindow _feeWindow) public returns (bool);
230     function getFeeWindow() public view returns (IFeeWindow);
231     function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
232     function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
233 }
234 
235 contract IFeeWindow is ITyped, ERC20 {
236     function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
237     function getUniverse() public view returns (IUniverse);
238     function getReputationToken() public view returns (IReputationToken);
239     function getStartTime() public view returns (uint256);
240     function getEndTime() public view returns (uint256);
241     function getNumMarkets() public view returns (uint256);
242     function getNumInvalidMarkets() public view returns (uint256);
243     function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
244     function getNumDesignatedReportNoShows() public view returns (uint256);
245     function getFeeToken() public view returns (IFeeToken);
246     function isActive() public view returns (bool);
247     function isOver() public view returns (bool);
248     function onMarketFinalized() public returns (bool);
249     function buy(uint256 _attotokens) public returns (bool);
250     function redeem(address _sender) public returns (bool);
251     function redeemForReportingParticipant() public returns (bool);
252     function mintFeeTokens(uint256 _amount) public returns (bool);
253     function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
254 }
255 
256 contract IMailbox {
257     function initialize(address _owner, IMarket _market) public returns (bool);
258     function depositEther() public payable returns (bool);
259 }
260 
261 contract IMarket is ITyped, IOwnable {
262     enum MarketType {
263         YES_NO,
264         CATEGORICAL,
265         SCALAR
266     }
267 
268     function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
269     function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
270     function getUniverse() public view returns (IUniverse);
271     function getFeeWindow() public view returns (IFeeWindow);
272     function getNumberOfOutcomes() public view returns (uint256);
273     function getNumTicks() public view returns (uint256);
274     function getDenominationToken() public view returns (ICash);
275     function getShareToken(uint256 _outcome)  public view returns (IShareToken);
276     function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
277     function getForkingMarket() public view returns (IMarket _market);
278     function getEndTime() public view returns (uint256);
279     function getMarketCreatorMailbox() public view returns (IMailbox);
280     function getWinningPayoutDistributionHash() public view returns (bytes32);
281     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
282     function getReputationToken() public view returns (IReputationToken);
283     function getFinalizationTime() public view returns (uint256);
284     function getInitialReporterAddress() public view returns (address);
285     function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
286     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
287     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
288     function isInvalid() public view returns (bool);
289     function finalize() public returns (bool);
290     function designatedReporterWasCorrect() public view returns (bool);
291     function designatedReporterShowed() public view returns (bool);
292     function isFinalized() public view returns (bool);
293     function finalizeFork() public returns (bool);
294     function assertBalances() public view returns (bool);
295 }
296 
297 contract IReportingParticipant {
298     function getStake() public view returns (uint256);
299     function getPayoutDistributionHash() public view returns (bytes32);
300     function liquidateLosing() public returns (bool);
301     function redeem(address _redeemer) public returns (bool);
302     function isInvalid() public view returns (bool);
303     function isDisavowed() public view returns (bool);
304     function migrate() public returns (bool);
305     function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
306     function getMarket() public view returns (IMarket);
307     function getSize() public view returns (uint256);
308 }
309 
310 contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
311     function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
312     function contribute(address _participant, uint256 _amount) public returns (uint256);
313 }
314 
315 contract IReputationToken is ITyped, ERC20 {
316     function initialize(IUniverse _universe) public returns (bool);
317     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
318     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
319     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
320     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
321     function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
322     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
323     function getUniverse() public view returns (IUniverse);
324     function getTotalMigrated() public view returns (uint256);
325     function getTotalTheoreticalSupply() public view returns (uint256);
326     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
327 }
328 
329 contract IUniverse is ITyped {
330     function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
331     function fork() public returns (bool);
332     function getParentUniverse() public view returns (IUniverse);
333     function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
334     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
335     function getReputationToken() public view returns (IReputationToken);
336     function getForkingMarket() public view returns (IMarket);
337     function getForkEndTime() public view returns (uint256);
338     function getForkReputationGoal() public view returns (uint256);
339     function getParentPayoutDistributionHash() public view returns (bytes32);
340     function getDisputeRoundDurationInSeconds() public view returns (uint256);
341     function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
342     function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
343     function getOrCreateNextFeeWindow() public returns (IFeeWindow);
344     function getOpenInterestInAttoEth() public view returns (uint256);
345     function getRepMarketCapInAttoeth() public view returns (uint256);
346     function getTargetRepMarketCapInAttoeth() public view returns (uint256);
347     function getOrCacheValidityBond() public returns (uint256);
348     function getOrCacheDesignatedReportStake() public returns (uint256);
349     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
350     function getOrCacheReportingFeeDivisor() public returns (uint256);
351     function getDisputeThresholdForFork() public view returns (uint256);
352     function getInitialReportMinValue() public view returns (uint256);
353     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
354     function getOrCacheMarketCreationCost() public returns (uint256);
355     function getCurrentFeeWindow() public view returns (IFeeWindow);
356     function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
357     function isParentOf(IUniverse _shadyChild) public view returns (bool);
358     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
359     function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
360     function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
361     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
362     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
363     function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
364     function addMarketTo() public returns (bool);
365     function removeMarketFrom() public returns (bool);
366     function decrementOpenInterest(uint256 _amount) public returns (bool);
367     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
368     function incrementOpenInterest(uint256 _amount) public returns (bool);
369     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
370     function getWinningChildUniverse() public view returns (IUniverse);
371     function isForking() public view returns (bool);
372 }
373 
374 contract ICash is ERC20 {
375     function depositEther() external payable returns(bool);
376     function depositEtherFor(address _to) external payable returns(bool);
377     function withdrawEther(uint256 _amount) external returns(bool);
378     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
379     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
380 }
381 
382 contract IOrders {
383     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
384     function removeOrder(bytes32 _orderId) public returns (bool);
385     function getMarket(bytes32 _orderId) public view returns (IMarket);
386     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
387     function getOutcome(bytes32 _orderId) public view returns (uint256);
388     function getAmount(bytes32 _orderId) public view returns (uint256);
389     function getPrice(bytes32 _orderId) public view returns (uint256);
390     function getOrderCreator(bytes32 _orderId) public view returns (address);
391     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
392     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
393     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
394     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
395     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
396     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
397     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
398     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
399     function getTotalEscrowed(IMarket _market) public view returns (uint256);
400     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
401     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
402     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
403     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
404     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
405     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
406     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
407     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
408 }
409 
410 contract IShareToken is ITyped, ERC20 {
411     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
412     function createShares(address _owner, uint256 _amount) external returns (bool);
413     function destroyShares(address, uint256 balance) external returns (bool);
414     function getMarket() external view returns (IMarket);
415     function getOutcome() external view returns (uint256);
416     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
417     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
418     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
419 }
420 
421 library Order {
422     using SafeMathUint256 for uint256;
423 
424     enum Types {
425         Bid, Ask
426     }
427 
428     enum TradeDirections {
429         Long, Short
430     }
431 
432     struct Data {
433         // Contracts
434         IOrders orders;
435         IMarket market;
436         IAugur augur;
437 
438         // Order
439         bytes32 id;
440         address creator;
441         uint256 outcome;
442         Order.Types orderType;
443         uint256 amount;
444         uint256 price;
445         uint256 sharesEscrowed;
446         uint256 moneyEscrowed;
447         bytes32 betterOrderId;
448         bytes32 worseOrderId;
449     }
450 
451     //
452     // Constructor
453     //
454 
455     // No validation is needed here as it is simply a librarty function for organizing data
456     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
457         require(_outcome < _market.getNumberOfOutcomes());
458         require(_price < _market.getNumTicks());
459 
460         IOrders _orders = IOrders(_controller.lookup("Orders"));
461         IAugur _augur = _controller.getAugur();
462 
463         return Data({
464             orders: _orders,
465             market: _market,
466             augur: _augur,
467             id: 0,
468             creator: _creator,
469             outcome: _outcome,
470             orderType: _type,
471             amount: _attoshares,
472             price: _price,
473             sharesEscrowed: 0,
474             moneyEscrowed: 0,
475             betterOrderId: _betterOrderId,
476             worseOrderId: _worseOrderId
477         });
478     }
479 
480     //
481     // "public" functions
482     //
483 
484     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
485         if (_orderData.id == bytes32(0)) {
486             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
487             require(_orderData.orders.getAmount(_orderId) == 0);
488             _orderData.id = _orderId;
489         }
490         return _orderData.id;
491     }
492 
493     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
494         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
495     }
496 
497     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
498         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
499     }
500 
501     function escrowFunds(Order.Data _orderData) internal returns (bool) {
502         if (_orderData.orderType == Order.Types.Ask) {
503             return escrowFundsForAsk(_orderData);
504         } else if (_orderData.orderType == Order.Types.Bid) {
505             return escrowFundsForBid(_orderData);
506         }
507     }
508 
509     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
510         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
511     }
512 
513     //
514     // Private functions
515     //
516 
517     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
518         require(_orderData.moneyEscrowed == 0);
519         require(_orderData.sharesEscrowed == 0);
520         uint256 _attosharesToCover = _orderData.amount;
521         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
522 
523         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
524         uint256 _attosharesHeld = 2**254;
525         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
526             if (_i != _orderData.outcome) {
527                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
528                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
529             }
530         }
531 
532         // Take shares into escrow if they have any almost-complete-sets
533         if (_attosharesHeld > 0) {
534             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
535             _attosharesToCover -= _orderData.sharesEscrowed;
536             for (_i = 0; _i < _numberOfOutcomes; _i++) {
537                 if (_i != _orderData.outcome) {
538                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
539                 }
540             }
541         }
542         // If not able to cover entire order with shares alone, then cover remaining with tokens
543         if (_attosharesToCover > 0) {
544             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
545             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
546         }
547 
548         return true;
549     }
550 
551     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
552         require(_orderData.moneyEscrowed == 0);
553         require(_orderData.sharesEscrowed == 0);
554         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
555         uint256 _attosharesToCover = _orderData.amount;
556 
557         // Figure out how many shares of the outcome the creator has
558         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
559 
560         // Take shares in escrow if user has shares
561         if (_attosharesHeld > 0) {
562             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
563             _attosharesToCover -= _orderData.sharesEscrowed;
564             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
565         }
566 
567         // If not able to cover entire order with shares alone, then cover remaining with tokens
568         if (_attosharesToCover > 0) {
569             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
570             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
571         }
572 
573         return true;
574     }
575 }