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
106 contract UniverseFactory {
107     function createUniverse(IController _controller, IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) public returns (IUniverse) {
108         Delegator _delegator = new Delegator(_controller, "Universe");
109         IUniverse _universe = IUniverse(_delegator);
110         _universe.initialize(_parentUniverse, _parentPayoutDistributionHash);
111         return _universe;
112     }
113 }
114 
115 contract DelegationTarget is Controlled {
116     bytes32 public controllerLookupName;
117 }
118 
119 contract Delegator is DelegationTarget {
120     function Delegator(IController _controller, bytes32 _controllerLookupName) public {
121         controller = _controller;
122         controllerLookupName = _controllerLookupName;
123     }
124 
125     function() external payable {
126         // Do nothing if we haven't properly set up the delegator to delegate calls
127         if (controllerLookupName == 0) {
128             return;
129         }
130 
131         // Get the delegation target contract
132         address _target = controller.lookup(controllerLookupName);
133 
134         assembly {
135             //0x40 is the address where the next free memory slot is stored in Solidity
136             let _calldataMemoryOffset := mload(0x40)
137             // new "memory end" including padding. The bitwise operations here ensure we get rounded up to the nearest 32 byte boundary
138             let _size := and(add(calldatasize, 0x1f), not(0x1f))
139             // Update the pointer at 0x40 to point at new free memory location so any theoretical allocation doesn't stomp our memory in this call
140             mstore(0x40, add(_calldataMemoryOffset, _size))
141             // Copy method signature and parameters of this call into memory
142             calldatacopy(_calldataMemoryOffset, 0x0, calldatasize)
143             // Call the actual method via delegation
144             let _retval := delegatecall(gas, _target, _calldataMemoryOffset, calldatasize, 0, 0)
145             switch _retval
146             case 0 {
147                 // 0 == it threw, so we revert
148                 revert(0,0)
149             } default {
150                 // If the call succeeded return the return data from the delegate call
151                 let _returndataMemoryOffset := mload(0x40)
152                 // Update the pointer at 0x40 again to point at new free memory location so any theoretical allocation doesn't stomp our memory in this call
153                 mstore(0x40, add(_returndataMemoryOffset, returndatasize))
154                 returndatacopy(_returndataMemoryOffset, 0x0, returndatasize)
155                 return(_returndataMemoryOffset, returndatasize)
156             }
157         }
158     }
159 }
160 
161 contract IOwnable {
162     function getOwner() public view returns (address);
163     function transferOwnership(address newOwner) public returns (bool);
164 }
165 
166 contract ITyped {
167     function getTypeName() public view returns (bytes32);
168 }
169 
170 contract Initializable {
171     bool private initialized = false;
172 
173     modifier afterInitialized {
174         require(initialized);
175         _;
176     }
177 
178     modifier beforeInitialized {
179         require(!initialized);
180         _;
181     }
182 
183     function endInitialization() internal beforeInitialized returns (bool) {
184         initialized = true;
185         return true;
186     }
187 
188     function getInitialized() public view returns (bool) {
189         return initialized;
190     }
191 }
192 
193 library SafeMathUint256 {
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a * b;
196         require(a == 0 || c / a == b);
197         return c;
198     }
199 
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         // assert(b > 0); // Solidity automatically throws when dividing by 0
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204         return c;
205     }
206 
207     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
208         require(b <= a);
209         return a - b;
210     }
211 
212     function add(uint256 a, uint256 b) internal pure returns (uint256) {
213         uint256 c = a + b;
214         require(c >= a);
215         return c;
216     }
217 
218     function min(uint256 a, uint256 b) internal pure returns (uint256) {
219         if (a <= b) {
220             return a;
221         } else {
222             return b;
223         }
224     }
225 
226     function max(uint256 a, uint256 b) internal pure returns (uint256) {
227         if (a >= b) {
228             return a;
229         } else {
230             return b;
231         }
232     }
233 
234     function getUint256Min() internal pure returns (uint256) {
235         return 0;
236     }
237 
238     function getUint256Max() internal pure returns (uint256) {
239         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
240     }
241 
242     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
243         return a % b == 0;
244     }
245 
246     // Float [fixed point] Operations
247     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
248         return div(mul(a, b), base);
249     }
250 
251     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
252         return div(mul(a, base), b);
253     }
254 }
255 
256 contract ERC20Basic {
257     event Transfer(address indexed from, address indexed to, uint256 value);
258 
259     function balanceOf(address _who) public view returns (uint256);
260     function transfer(address _to, uint256 _value) public returns (bool);
261     function totalSupply() public view returns (uint256);
262 }
263 
264 contract ERC20 is ERC20Basic {
265     event Approval(address indexed owner, address indexed spender, uint256 value);
266 
267     function allowance(address _owner, address _spender) public view returns (uint256);
268     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
269     function approve(address _spender, uint256 _value) public returns (bool);
270 }
271 
272 contract IFeeToken is ERC20, Initializable {
273     function initialize(IFeeWindow _feeWindow) public returns (bool);
274     function getFeeWindow() public view returns (IFeeWindow);
275     function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
276     function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
277 }
278 
279 contract IFeeWindow is ITyped, ERC20 {
280     function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
281     function getUniverse() public view returns (IUniverse);
282     function getReputationToken() public view returns (IReputationToken);
283     function getStartTime() public view returns (uint256);
284     function getEndTime() public view returns (uint256);
285     function getNumMarkets() public view returns (uint256);
286     function getNumInvalidMarkets() public view returns (uint256);
287     function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
288     function getNumDesignatedReportNoShows() public view returns (uint256);
289     function getFeeToken() public view returns (IFeeToken);
290     function isActive() public view returns (bool);
291     function isOver() public view returns (bool);
292     function onMarketFinalized() public returns (bool);
293     function buy(uint256 _attotokens) public returns (bool);
294     function redeem(address _sender) public returns (bool);
295     function redeemForReportingParticipant() public returns (bool);
296     function mintFeeTokens(uint256 _amount) public returns (bool);
297     function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
298 }
299 
300 contract IMailbox {
301     function initialize(address _owner, IMarket _market) public returns (bool);
302     function depositEther() public payable returns (bool);
303 }
304 
305 contract IMarket is ITyped, IOwnable {
306     enum MarketType {
307         YES_NO,
308         CATEGORICAL,
309         SCALAR
310     }
311 
312     function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
313     function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
314     function getUniverse() public view returns (IUniverse);
315     function getFeeWindow() public view returns (IFeeWindow);
316     function getNumberOfOutcomes() public view returns (uint256);
317     function getNumTicks() public view returns (uint256);
318     function getDenominationToken() public view returns (ICash);
319     function getShareToken(uint256 _outcome)  public view returns (IShareToken);
320     function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
321     function getForkingMarket() public view returns (IMarket _market);
322     function getEndTime() public view returns (uint256);
323     function getMarketCreatorMailbox() public view returns (IMailbox);
324     function getWinningPayoutDistributionHash() public view returns (bytes32);
325     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
326     function getReputationToken() public view returns (IReputationToken);
327     function getFinalizationTime() public view returns (uint256);
328     function getInitialReporterAddress() public view returns (address);
329     function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
330     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
331     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
332     function isInvalid() public view returns (bool);
333     function finalize() public returns (bool);
334     function designatedReporterWasCorrect() public view returns (bool);
335     function designatedReporterShowed() public view returns (bool);
336     function isFinalized() public view returns (bool);
337     function finalizeFork() public returns (bool);
338     function assertBalances() public view returns (bool);
339 }
340 
341 contract IReportingParticipant {
342     function getStake() public view returns (uint256);
343     function getPayoutDistributionHash() public view returns (bytes32);
344     function liquidateLosing() public returns (bool);
345     function redeem(address _redeemer) public returns (bool);
346     function isInvalid() public view returns (bool);
347     function isDisavowed() public view returns (bool);
348     function migrate() public returns (bool);
349     function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
350     function getMarket() public view returns (IMarket);
351     function getSize() public view returns (uint256);
352 }
353 
354 contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
355     function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
356     function contribute(address _participant, uint256 _amount) public returns (uint256);
357 }
358 
359 contract IReputationToken is ITyped, ERC20 {
360     function initialize(IUniverse _universe) public returns (bool);
361     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
362     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
363     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
364     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
365     function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
366     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
367     function getUniverse() public view returns (IUniverse);
368     function getTotalMigrated() public view returns (uint256);
369     function getTotalTheoreticalSupply() public view returns (uint256);
370     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
371 }
372 
373 contract IUniverse is ITyped {
374     function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
375     function fork() public returns (bool);
376     function getParentUniverse() public view returns (IUniverse);
377     function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
378     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
379     function getReputationToken() public view returns (IReputationToken);
380     function getForkingMarket() public view returns (IMarket);
381     function getForkEndTime() public view returns (uint256);
382     function getForkReputationGoal() public view returns (uint256);
383     function getParentPayoutDistributionHash() public view returns (bytes32);
384     function getDisputeRoundDurationInSeconds() public view returns (uint256);
385     function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
386     function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
387     function getOrCreateNextFeeWindow() public returns (IFeeWindow);
388     function getOpenInterestInAttoEth() public view returns (uint256);
389     function getRepMarketCapInAttoeth() public view returns (uint256);
390     function getTargetRepMarketCapInAttoeth() public view returns (uint256);
391     function getOrCacheValidityBond() public returns (uint256);
392     function getOrCacheDesignatedReportStake() public returns (uint256);
393     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
394     function getOrCacheReportingFeeDivisor() public returns (uint256);
395     function getDisputeThresholdForFork() public view returns (uint256);
396     function getInitialReportMinValue() public view returns (uint256);
397     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
398     function getOrCacheMarketCreationCost() public returns (uint256);
399     function getCurrentFeeWindow() public view returns (IFeeWindow);
400     function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
401     function isParentOf(IUniverse _shadyChild) public view returns (bool);
402     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
403     function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
404     function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
405     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
406     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
407     function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
408     function addMarketTo() public returns (bool);
409     function removeMarketFrom() public returns (bool);
410     function decrementOpenInterest(uint256 _amount) public returns (bool);
411     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
412     function incrementOpenInterest(uint256 _amount) public returns (bool);
413     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
414     function getWinningChildUniverse() public view returns (IUniverse);
415     function isForking() public view returns (bool);
416 }
417 
418 contract ICash is ERC20 {
419     function depositEther() external payable returns(bool);
420     function depositEtherFor(address _to) external payable returns(bool);
421     function withdrawEther(uint256 _amount) external returns(bool);
422     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
423     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
424 }
425 
426 contract IOrders {
427     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
428     function removeOrder(bytes32 _orderId) public returns (bool);
429     function getMarket(bytes32 _orderId) public view returns (IMarket);
430     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
431     function getOutcome(bytes32 _orderId) public view returns (uint256);
432     function getAmount(bytes32 _orderId) public view returns (uint256);
433     function getPrice(bytes32 _orderId) public view returns (uint256);
434     function getOrderCreator(bytes32 _orderId) public view returns (address);
435     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
436     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
437     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
438     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
439     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
440     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
441     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
442     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
443     function getTotalEscrowed(IMarket _market) public view returns (uint256);
444     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
445     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
446     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
447     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
448     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
449     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
450     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
451     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
452 }
453 
454 contract IShareToken is ITyped, ERC20 {
455     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
456     function createShares(address _owner, uint256 _amount) external returns (bool);
457     function destroyShares(address, uint256 balance) external returns (bool);
458     function getMarket() external view returns (IMarket);
459     function getOutcome() external view returns (uint256);
460     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
461     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
462     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
463 }
464 
465 library Order {
466     using SafeMathUint256 for uint256;
467 
468     enum Types {
469         Bid, Ask
470     }
471 
472     enum TradeDirections {
473         Long, Short
474     }
475 
476     struct Data {
477         // Contracts
478         IOrders orders;
479         IMarket market;
480         IAugur augur;
481 
482         // Order
483         bytes32 id;
484         address creator;
485         uint256 outcome;
486         Order.Types orderType;
487         uint256 amount;
488         uint256 price;
489         uint256 sharesEscrowed;
490         uint256 moneyEscrowed;
491         bytes32 betterOrderId;
492         bytes32 worseOrderId;
493     }
494 
495     //
496     // Constructor
497     //
498 
499     // No validation is needed here as it is simply a librarty function for organizing data
500     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
501         require(_outcome < _market.getNumberOfOutcomes());
502         require(_price < _market.getNumTicks());
503 
504         IOrders _orders = IOrders(_controller.lookup("Orders"));
505         IAugur _augur = _controller.getAugur();
506 
507         return Data({
508             orders: _orders,
509             market: _market,
510             augur: _augur,
511             id: 0,
512             creator: _creator,
513             outcome: _outcome,
514             orderType: _type,
515             amount: _attoshares,
516             price: _price,
517             sharesEscrowed: 0,
518             moneyEscrowed: 0,
519             betterOrderId: _betterOrderId,
520             worseOrderId: _worseOrderId
521         });
522     }
523 
524     //
525     // "public" functions
526     //
527 
528     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
529         if (_orderData.id == bytes32(0)) {
530             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
531             require(_orderData.orders.getAmount(_orderId) == 0);
532             _orderData.id = _orderId;
533         }
534         return _orderData.id;
535     }
536 
537     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
538         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
539     }
540 
541     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
542         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
543     }
544 
545     function escrowFunds(Order.Data _orderData) internal returns (bool) {
546         if (_orderData.orderType == Order.Types.Ask) {
547             return escrowFundsForAsk(_orderData);
548         } else if (_orderData.orderType == Order.Types.Bid) {
549             return escrowFundsForBid(_orderData);
550         }
551     }
552 
553     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
554         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
555     }
556 
557     //
558     // Private functions
559     //
560 
561     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
562         require(_orderData.moneyEscrowed == 0);
563         require(_orderData.sharesEscrowed == 0);
564         uint256 _attosharesToCover = _orderData.amount;
565         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
566 
567         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
568         uint256 _attosharesHeld = 2**254;
569         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
570             if (_i != _orderData.outcome) {
571                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
572                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
573             }
574         }
575 
576         // Take shares into escrow if they have any almost-complete-sets
577         if (_attosharesHeld > 0) {
578             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
579             _attosharesToCover -= _orderData.sharesEscrowed;
580             for (_i = 0; _i < _numberOfOutcomes; _i++) {
581                 if (_i != _orderData.outcome) {
582                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
583                 }
584             }
585         }
586         // If not able to cover entire order with shares alone, then cover remaining with tokens
587         if (_attosharesToCover > 0) {
588             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
589             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
590         }
591 
592         return true;
593     }
594 
595     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
596         require(_orderData.moneyEscrowed == 0);
597         require(_orderData.sharesEscrowed == 0);
598         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
599         uint256 _attosharesToCover = _orderData.amount;
600 
601         // Figure out how many shares of the outcome the creator has
602         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
603 
604         // Take shares in escrow if user has shares
605         if (_attosharesHeld > 0) {
606             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
607             _attosharesToCover -= _orderData.sharesEscrowed;
608             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
609         }
610 
611         // If not able to cover entire order with shares alone, then cover remaining with tokens
612         if (_attosharesToCover > 0) {
613             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
614             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
615         }
616 
617         return true;
618     }
619 }