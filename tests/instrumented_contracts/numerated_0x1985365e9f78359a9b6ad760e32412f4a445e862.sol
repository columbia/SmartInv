1 pragma solidity 0.4.20;
2 
3 // File: contracts/libraries/ITyped.sol
4 
5 contract ITyped {
6     function getTypeName() public view returns (bytes32);
7 }
8 
9 // File: contracts/libraries/token/ERC20Basic.sol
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     function balanceOf(address _who) public view returns (uint256);
20     function transfer(address _to, uint256 _value) public returns (bool);
21     function totalSupply() public view returns (uint256);
22 }
23 
24 // File: contracts/libraries/token/ERC20.sol
25 
26 /**
27  * @title ERC20 interface
28  * @dev see https://github.com/ethereum/EIPs/issues/20
29  */
30 contract ERC20 is ERC20Basic {
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 
33     function allowance(address _owner, address _spender) public view returns (uint256);
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
35     function approve(address _spender, uint256 _value) public returns (bool);
36 }
37 
38 // File: contracts/reporting/IReputationToken.sol
39 
40 contract IReputationToken is ITyped, ERC20 {
41     function initialize(IUniverse _universe) public returns (bool);
42     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
43     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
44     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
45     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
46     function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
47     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
48     function getUniverse() public view returns (IUniverse);
49     function getTotalMigrated() public view returns (uint256);
50     function getTotalTheoreticalSupply() public view returns (uint256);
51     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
52 }
53 
54 // File: contracts/libraries/IOwnable.sol
55 
56 contract IOwnable {
57     function getOwner() public view returns (address);
58     function transferOwnership(address newOwner) public returns (bool);
59 }
60 
61 // File: contracts/trading/ICash.sol
62 
63 contract ICash is ERC20 {
64     function depositEther() external payable returns(bool);
65     function depositEtherFor(address _to) external payable returns(bool);
66     function withdrawEther(uint256 _amount) external returns(bool);
67     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
68     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
69 }
70 
71 // File: contracts/trading/IShareToken.sol
72 
73 contract IShareToken is ITyped, ERC20 {
74     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
75     function createShares(address _owner, uint256 _amount) external returns (bool);
76     function destroyShares(address, uint256 balance) external returns (bool);
77     function getMarket() external view returns (IMarket);
78     function getOutcome() external view returns (uint256);
79     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
80     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
81     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
82 }
83 
84 // File: contracts/reporting/IReportingParticipant.sol
85 
86 contract IReportingParticipant {
87     function getStake() public view returns (uint256);
88     function getPayoutDistributionHash() public view returns (bytes32);
89     function liquidateLosing() public returns (bool);
90     function redeem(address _redeemer) public returns (bool);
91     function isInvalid() public view returns (bool);
92     function isDisavowed() public view returns (bool);
93     function migrate() public returns (bool);
94     function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
95     function getMarket() public view returns (IMarket);
96     function getSize() public view returns (uint256);
97 }
98 
99 // File: contracts/reporting/IMailbox.sol
100 
101 contract IMailbox {
102     function initialize(address _owner, IMarket _market) public returns (bool);
103     function depositEther() public payable returns (bool);
104 }
105 
106 // File: contracts/reporting/IMarket.sol
107 
108 //import 'reporting/IInitialReporter.sol';
109 
110 
111 
112 contract IMarket is ITyped, IOwnable {
113     enum MarketType {
114         YES_NO,
115         CATEGORICAL,
116         SCALAR
117     }
118 
119     function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
120     function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
121     function getUniverse() public view returns (IUniverse);
122     function getFeeWindow() public view returns (IFeeWindow);
123     function getNumberOfOutcomes() public view returns (uint256);
124     function getNumTicks() public view returns (uint256);
125     function getDenominationToken() public view returns (ICash);
126     function getShareToken(uint256 _outcome)  public view returns (IShareToken);
127     function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
128     function getForkingMarket() public view returns (IMarket _market);
129     function getEndTime() public view returns (uint256);
130     function getMarketCreatorMailbox() public view returns (IMailbox);
131     function getWinningPayoutDistributionHash() public view returns (bytes32);
132     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
133     function getReputationToken() public view returns (IReputationToken);
134     function getFinalizationTime() public view returns (uint256);
135     function getInitialReporterAddress() public view returns (address);
136     function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
137     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
138     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
139     function isInvalid() public view returns (bool);
140     function finalize() public returns (bool);
141     function designatedReporterWasCorrect() public view returns (bool);
142     function designatedReporterShowed() public view returns (bool);
143     function isFinalized() public view returns (bool);
144     function finalizeFork() public returns (bool);
145     function assertBalances() public view returns (bool);
146 }
147 
148 // File: contracts/libraries/Initializable.sol
149 
150 contract Initializable {
151     bool private initialized = false;
152 
153     modifier afterInitialized {
154         require(initialized);
155         _;
156     }
157 
158     modifier beforeInitialized {
159         require(!initialized);
160         _;
161     }
162 
163     function endInitialization() internal beforeInitialized returns (bool) {
164         initialized = true;
165         return true;
166     }
167 
168     function getInitialized() public view returns (bool) {
169         return initialized;
170     }
171 }
172 
173 // File: contracts/reporting/IFeeToken.sol
174 
175 contract IFeeToken is ERC20, Initializable {
176     function initialize(IFeeWindow _feeWindow) public returns (bool);
177     function getFeeWindow() public view returns (IFeeWindow);
178     function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
179     function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
180 }
181 
182 // File: contracts/reporting/IFeeWindow.sol
183 
184 contract IFeeWindow is ITyped, ERC20 {
185     function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
186     function getUniverse() public view returns (IUniverse);
187     function getReputationToken() public view returns (IReputationToken);
188     function getStartTime() public view returns (uint256);
189     function getEndTime() public view returns (uint256);
190     function getNumMarkets() public view returns (uint256);
191     function getNumInvalidMarkets() public view returns (uint256);
192     function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
193     function getNumDesignatedReportNoShows() public view returns (uint256);
194     function getFeeToken() public view returns (IFeeToken);
195     function isActive() public view returns (bool);
196     function isOver() public view returns (bool);
197     function onMarketFinalized() public returns (bool);
198     function buy(uint256 _attotokens) public returns (bool);
199     function redeem(address _sender) public returns (bool);
200     function redeemForReportingParticipant() public returns (bool);
201     function mintFeeTokens(uint256 _amount) public returns (bool);
202     function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
203 }
204 
205 // File: contracts/reporting/IUniverse.sol
206 
207 contract IUniverse is ITyped {
208     function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
209     function fork() public returns (bool);
210     function getParentUniverse() public view returns (IUniverse);
211     function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
212     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
213     function getReputationToken() public view returns (IReputationToken);
214     function getForkingMarket() public view returns (IMarket);
215     function getForkEndTime() public view returns (uint256);
216     function getForkReputationGoal() public view returns (uint256);
217     function getParentPayoutDistributionHash() public view returns (bytes32);
218     function getDisputeRoundDurationInSeconds() public view returns (uint256);
219     function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
220     function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
221     function getOrCreateNextFeeWindow() public returns (IFeeWindow);
222     function getOpenInterestInAttoEth() public view returns (uint256);
223     function getRepMarketCapInAttoeth() public view returns (uint256);
224     function getTargetRepMarketCapInAttoeth() public view returns (uint256);
225     function getOrCacheValidityBond() public returns (uint256);
226     function getOrCacheDesignatedReportStake() public returns (uint256);
227     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
228     function getOrCacheReportingFeeDivisor() public returns (uint256);
229     function getDisputeThresholdForFork() public view returns (uint256);
230     function getInitialReportMinValue() public view returns (uint256);
231     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
232     function getOrCacheMarketCreationCost() public returns (uint256);
233     function getCurrentFeeWindow() public view returns (IFeeWindow);
234     function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
235     function isParentOf(IUniverse _shadyChild) public view returns (bool);
236     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
237     function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
238     function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
239     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
240     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
241     function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
242     function addMarketTo() public returns (bool);
243     function removeMarketFrom() public returns (bool);
244     function decrementOpenInterest(uint256 _amount) public returns (bool);
245     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
246     function incrementOpenInterest(uint256 _amount) public returns (bool);
247     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
248     function getWinningChildUniverse() public view returns (IUniverse);
249     function isForking() public view returns (bool);
250 }
251 
252 // File: contracts/reporting/IDisputeCrowdsourcer.sol
253 
254 contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
255     function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
256     function contribute(address _participant, uint256 _amount) public returns (uint256);
257 }
258 
259 // File: contracts/libraries/math/SafeMathUint256.sol
260 
261 /**
262  * @title SafeMathUint256
263  * @dev Uint256 math operations with safety checks that throw on error
264  */
265 library SafeMathUint256 {
266     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267         uint256 c = a * b;
268         require(a == 0 || c / a == b);
269         return c;
270     }
271 
272     function div(uint256 a, uint256 b) internal pure returns (uint256) {
273         // assert(b > 0); // Solidity automatically throws when dividing by 0
274         uint256 c = a / b;
275         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
276         return c;
277     }
278 
279     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
280         require(b <= a);
281         return a - b;
282     }
283 
284     function add(uint256 a, uint256 b) internal pure returns (uint256) {
285         uint256 c = a + b;
286         require(c >= a);
287         return c;
288     }
289 
290     function min(uint256 a, uint256 b) internal pure returns (uint256) {
291         if (a <= b) {
292             return a;
293         } else {
294             return b;
295         }
296     }
297 
298     function max(uint256 a, uint256 b) internal pure returns (uint256) {
299         if (a >= b) {
300             return a;
301         } else {
302             return b;
303         }
304     }
305 
306     function getUint256Min() internal pure returns (uint256) {
307         return 0;
308     }
309 
310     function getUint256Max() internal pure returns (uint256) {
311         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
312     }
313 
314     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
315         return a % b == 0;
316     }
317 
318     // Float [fixed point] Operations
319     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
320         return div(mul(a, b), base);
321     }
322 
323     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
324         return div(mul(a, base), b);
325     }
326 }
327 
328 // File: contracts/trading/IOrders.sol
329 
330 contract IOrders {
331     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
332     function removeOrder(bytes32 _orderId) public returns (bool);
333     function getMarket(bytes32 _orderId) public view returns (IMarket);
334     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
335     function getOutcome(bytes32 _orderId) public view returns (uint256);
336     function getAmount(bytes32 _orderId) public view returns (uint256);
337     function getPrice(bytes32 _orderId) public view returns (uint256);
338     function getOrderCreator(bytes32 _orderId) public view returns (address);
339     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
340     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
341     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
342     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
343     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
344     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
345     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
346     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
347     function getTotalEscrowed(IMarket _market) public view returns (uint256);
348     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
349     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
350     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
351     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
352     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
353     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
354     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
355     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
356 }
357 
358 // File: contracts/trading/Order.sol
359 
360 // Copyright (C) 2015 Forecast Foundation OU, full GPL notice in LICENSE
361 
362 // Bid / Ask actions: puts orders on the book
363 // price is denominated by the specific market's numTicks
364 // amount is the number of attoshares the order is for (either to buy or to sell).
365 // price is the exact price you want to buy/sell at [which may not be the cost, for example to short a yesNo market it'll cost numTicks-price, to go long it'll cost price]
366 
367 pragma solidity 0.4.20;
368 
369 
370 
371 
372 
373 
374 
375 // CONSIDER: Is `price` the most appropriate name for the value being used? It does correspond 1:1 with the attoETH per share, but the range might be considered unusual?
376 library Order {
377     using SafeMathUint256 for uint256;
378 
379     enum Types {
380         Bid, Ask
381     }
382 
383     enum TradeDirections {
384         Long, Short
385     }
386 
387     struct Data {
388         // Contracts
389         IOrders orders;
390         IMarket market;
391         IAugur augur;
392 
393         // Order
394         bytes32 id;
395         address creator;
396         uint256 outcome;
397         Order.Types orderType;
398         uint256 amount;
399         uint256 price;
400         uint256 sharesEscrowed;
401         uint256 moneyEscrowed;
402         bytes32 betterOrderId;
403         bytes32 worseOrderId;
404     }
405 
406     //
407     // Constructor
408     //
409 
410     // No validation is needed here as it is simply a librarty function for organizing data
411     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
412         require(_outcome < _market.getNumberOfOutcomes());
413         require(_price < _market.getNumTicks());
414 
415         IOrders _orders = IOrders(_controller.lookup("Orders"));
416         IAugur _augur = _controller.getAugur();
417 
418         return Data({
419             orders: _orders,
420             market: _market,
421             augur: _augur,
422             id: 0,
423             creator: _creator,
424             outcome: _outcome,
425             orderType: _type,
426             amount: _attoshares,
427             price: _price,
428             sharesEscrowed: 0,
429             moneyEscrowed: 0,
430             betterOrderId: _betterOrderId,
431             worseOrderId: _worseOrderId
432         });
433     }
434 
435     //
436     // "public" functions
437     //
438 
439     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
440         if (_orderData.id == bytes32(0)) {
441             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
442             require(_orderData.orders.getAmount(_orderId) == 0);
443             _orderData.id = _orderId;
444         }
445         return _orderData.id;
446     }
447 
448     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
449         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
450     }
451 
452     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
453         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
454     }
455 
456     function escrowFunds(Order.Data _orderData) internal returns (bool) {
457         if (_orderData.orderType == Order.Types.Ask) {
458             return escrowFundsForAsk(_orderData);
459         } else if (_orderData.orderType == Order.Types.Bid) {
460             return escrowFundsForBid(_orderData);
461         }
462     }
463 
464     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
465         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
466     }
467 
468     //
469     // Private functions
470     //
471 
472     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
473         require(_orderData.moneyEscrowed == 0);
474         require(_orderData.sharesEscrowed == 0);
475         uint256 _attosharesToCover = _orderData.amount;
476         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
477 
478         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
479         uint256 _attosharesHeld = 2**254;
480         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
481             if (_i != _orderData.outcome) {
482                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
483                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
484             }
485         }
486 
487         // Take shares into escrow if they have any almost-complete-sets
488         if (_attosharesHeld > 0) {
489             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
490             _attosharesToCover -= _orderData.sharesEscrowed;
491             for (_i = 0; _i < _numberOfOutcomes; _i++) {
492                 if (_i != _orderData.outcome) {
493                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
494                 }
495             }
496         }
497         // If not able to cover entire order with shares alone, then cover remaining with tokens
498         if (_attosharesToCover > 0) {
499             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
500             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
501         }
502 
503         return true;
504     }
505 
506     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
507         require(_orderData.moneyEscrowed == 0);
508         require(_orderData.sharesEscrowed == 0);
509         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
510         uint256 _attosharesToCover = _orderData.amount;
511 
512         // Figure out how many shares of the outcome the creator has
513         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
514 
515         // Take shares in escrow if user has shares
516         if (_attosharesHeld > 0) {
517             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
518             _attosharesToCover -= _orderData.sharesEscrowed;
519             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
520         }
521 
522         // If not able to cover entire order with shares alone, then cover remaining with tokens
523         if (_attosharesToCover > 0) {
524             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
525             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
526         }
527 
528         return true;
529     }
530 }
531 
532 // File: contracts/IAugur.sol
533 
534 contract IAugur {
535     function createChildUniverse(bytes32 _parentPayoutDistributionHash, uint256[] _parentPayoutNumerators, bool _parentInvalid) public returns (IUniverse);
536     function isKnownUniverse(IUniverse _universe) public view returns (bool);
537     function trustedTransfer(ERC20 _token, address _from, address _to, uint256 _amount) public returns (bool);
538     function logMarketCreated(bytes32 _topic, string _description, string _extraInfo, IUniverse _universe, address _market, address _marketCreator, bytes32[] _outcomes, int256 _minPrice, int256 _maxPrice, IMarket.MarketType _marketType) public returns (bool);
539     function logMarketCreated(bytes32 _topic, string _description, string _extraInfo, IUniverse _universe, address _market, address _marketCreator, int256 _minPrice, int256 _maxPrice, IMarket.MarketType _marketType) public returns (bool);
540     function logInitialReportSubmitted(IUniverse _universe, address _reporter, address _market, uint256 _amountStaked, bool _isDesignatedReporter, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
541     function disputeCrowdsourcerCreated(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] _payoutNumerators, uint256 _size, bool _invalid) public returns (bool);
542     function logDisputeCrowdsourcerContribution(IUniverse _universe, address _reporter, address _market, address _disputeCrowdsourcer, uint256 _amountStaked) public returns (bool);
543     function logDisputeCrowdsourcerCompleted(IUniverse _universe, address _market, address _disputeCrowdsourcer) public returns (bool);
544     function logInitialReporterRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256 _reportingFeesReceived, uint256[] _payoutNumerators) public returns (bool);
545     function logDisputeCrowdsourcerRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256 _reportingFeesReceived, uint256[] _payoutNumerators) public returns (bool);
546     function logFeeWindowRedeemed(IUniverse _universe, address _reporter, uint256 _amountRedeemed, uint256 _reportingFeesReceived) public returns (bool);
547     function logMarketFinalized(IUniverse _universe) public returns (bool);
548     function logMarketMigrated(IMarket _market, IUniverse _originalUniverse) public returns (bool);
549     function logReportingParticipantDisavowed(IUniverse _universe, IMarket _market) public returns (bool);
550     function logMarketParticipantsDisavowed(IUniverse _universe) public returns (bool);
551     function logOrderCanceled(IUniverse _universe, address _shareToken, address _sender, bytes32 _orderId, Order.Types _orderType, uint256 _tokenRefund, uint256 _sharesRefund) public returns (bool);
552     function logOrderCreated(Order.Types _orderType, uint256 _amount, uint256 _price, address _creator, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _tradeGroupId, bytes32 _orderId, IUniverse _universe, address _shareToken) public returns (bool);
553     function logOrderFilled(IUniverse _universe, address _shareToken, address _filler, bytes32 _orderId, uint256 _numCreatorShares, uint256 _numCreatorTokens, uint256 _numFillerShares, uint256 _numFillerTokens, uint256 _marketCreatorFees, uint256 _reporterFees, uint256 _amountFilled, bytes32 _tradeGroupId) public returns (bool);
554     function logCompleteSetsPurchased(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public returns (bool);
555     function logCompleteSetsSold(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public returns (bool);
556     function logTradingProceedsClaimed(IUniverse _universe, address _shareToken, address _sender, address _market, uint256 _numShares, uint256 _numPayoutTokens, uint256 _finalTokenBalance) public returns (bool);
557     function logUniverseForked() public returns (bool);
558     function logFeeWindowTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
559     function logReputationTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
560     function logDisputeCrowdsourcerTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
561     function logShareTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
562     function logReputationTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
563     function logReputationTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
564     function logShareTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
565     function logShareTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
566     function logFeeWindowBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
567     function logFeeWindowMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
568     function logDisputeCrowdsourcerTokensBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
569     function logDisputeCrowdsourcerTokensMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
570     function logFeeWindowCreated(IFeeWindow _feeWindow, uint256 _id) public returns (bool);
571     function logFeeTokenTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool);
572     function logFeeTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
573     function logFeeTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool);
574     function logTimestampSet(uint256 _newTimestamp) public returns (bool);
575     function logInitialReporterTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool);
576     function logMarketTransferred(IUniverse _universe, address _from, address _to) public returns (bool);
577     function logMarketMailboxTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool);
578     function logEscapeHatchChanged(bool _isOn) public returns (bool);
579 }
580 
581 // File: contracts/IController.sol
582 
583 contract IController {
584     function assertIsWhitelisted(address _target) public view returns(bool);
585     function lookup(bytes32 _key) public view returns(address);
586     function stopInEmergency() public view returns(bool);
587     function onlyInEmergency() public view returns(bool);
588     function getAugur() public view returns (IAugur);
589     function getTimestamp() public view returns (uint256);
590 }
591 
592 // File: contracts/IControlled.sol
593 
594 contract IControlled {
595     function getController() public view returns (IController);
596     function setController(IController _controller) public returns(bool);
597 }
598 
599 // File: contracts/Controlled.sol
600 
601 contract Controlled is IControlled {
602     IController internal controller;
603 
604     modifier onlyWhitelistedCallers {
605         require(controller.assertIsWhitelisted(msg.sender));
606         _;
607     }
608 
609     modifier onlyCaller(bytes32 _key) {
610         require(msg.sender == controller.lookup(_key));
611         _;
612     }
613 
614     modifier onlyControllerCaller {
615         require(IController(msg.sender) == controller);
616         _;
617     }
618 
619     modifier onlyInGoodTimes {
620         require(controller.stopInEmergency());
621         _;
622     }
623 
624     modifier onlyInBadTimes {
625         require(controller.onlyInEmergency());
626         _;
627     }
628 
629     function Controlled() public {
630         controller = IController(msg.sender);
631     }
632 
633     function getController() public view returns(IController) {
634         return controller;
635     }
636 
637     function setController(IController _controller) public onlyControllerCaller returns(bool) {
638         controller = _controller;
639         return true;
640     }
641 }
642 
643 // File: contracts/libraries/DelegationTarget.sol
644 
645 contract DelegationTarget is Controlled {
646     bytes32 public controllerLookupName;
647 }
648 
649 // File: contracts/libraries/Delegator.sol
650 
651 contract Delegator is DelegationTarget {
652     function Delegator(IController _controller, bytes32 _controllerLookupName) public {
653         controller = _controller;
654         controllerLookupName = _controllerLookupName;
655     }
656 
657     function() external payable {
658         // Do nothing if we haven't properly set up the delegator to delegate calls
659         if (controllerLookupName == 0) {
660             return;
661         }
662 
663         // Get the delegation target contract
664         address _target = controller.lookup(controllerLookupName);
665 
666         assembly {
667             //0x40 is the address where the next free memory slot is stored in Solidity
668             let _calldataMemoryOffset := mload(0x40)
669             // new "memory end" including padding. The bitwise operations here ensure we get rounded up to the nearest 32 byte boundary
670             let _size := and(add(calldatasize, 0x1f), not(0x1f))
671             // Update the pointer at 0x40 to point at new free memory location so any theoretical allocation doesn't stomp our memory in this call
672             mstore(0x40, add(_calldataMemoryOffset, _size))
673             // Copy method signature and parameters of this call into memory
674             calldatacopy(_calldataMemoryOffset, 0x0, calldatasize)
675             // Call the actual method via delegation
676             let _retval := delegatecall(gas, _target, _calldataMemoryOffset, calldatasize, 0, 0)
677             switch _retval
678             case 0 {
679                 // 0 == it threw, so we revert
680                 revert(0,0)
681             } default {
682                 // If the call succeeded return the return data from the delegate call
683                 let _returndataMemoryOffset := mload(0x40)
684                 // Update the pointer at 0x40 again to point at new free memory location so any theoretical allocation doesn't stomp our memory in this call
685                 mstore(0x40, add(_returndataMemoryOffset, returndatasize))
686                 returndatacopy(_returndataMemoryOffset, 0x0, returndatasize)
687                 return(_returndataMemoryOffset, returndatasize)
688             }
689         }
690     }
691 }