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
106 contract DelegationTarget is Controlled {
107     bytes32 public controllerLookupName;
108 }
109 
110 contract Delegator is DelegationTarget {
111     function Delegator(IController _controller, bytes32 _controllerLookupName) public {
112         controller = _controller;
113         controllerLookupName = _controllerLookupName;
114     }
115 
116     function() external payable {
117         // Do nothing if we haven't properly set up the delegator to delegate calls
118         if (controllerLookupName == 0) {
119             return;
120         }
121 
122         // Get the delegation target contract
123         address _target = controller.lookup(controllerLookupName);
124 
125         assembly {
126             //0x40 is the address where the next free memory slot is stored in Solidity
127             let _calldataMemoryOffset := mload(0x40)
128             // new "memory end" including padding. The bitwise operations here ensure we get rounded up to the nearest 32 byte boundary
129             let _size := and(add(calldatasize, 0x1f), not(0x1f))
130             // Update the pointer at 0x40 to point at new free memory location so any theoretical allocation doesn't stomp our memory in this call
131             mstore(0x40, add(_calldataMemoryOffset, _size))
132             // Copy method signature and parameters of this call into memory
133             calldatacopy(_calldataMemoryOffset, 0x0, calldatasize)
134             // Call the actual method via delegation
135             let _retval := delegatecall(gas, _target, _calldataMemoryOffset, calldatasize, 0, 0)
136             switch _retval
137             case 0 {
138                 // 0 == it threw, so we revert
139                 revert(0,0)
140             } default {
141                 // If the call succeeded return the return data from the delegate call
142                 let _returndataMemoryOffset := mload(0x40)
143                 // Update the pointer at 0x40 again to point at new free memory location so any theoretical allocation doesn't stomp our memory in this call
144                 mstore(0x40, add(_returndataMemoryOffset, returndatasize))
145                 returndatacopy(_returndataMemoryOffset, 0x0, returndatasize)
146                 return(_returndataMemoryOffset, returndatasize)
147             }
148         }
149     }
150 }
151 
152 contract IOwnable {
153     function getOwner() public view returns (address);
154     function transferOwnership(address newOwner) public returns (bool);
155 }
156 
157 contract ITyped {
158     function getTypeName() public view returns (bytes32);
159 }
160 
161 contract Initializable {
162     bool private initialized = false;
163 
164     modifier afterInitialized {
165         require(initialized);
166         _;
167     }
168 
169     modifier beforeInitialized {
170         require(!initialized);
171         _;
172     }
173 
174     function endInitialization() internal beforeInitialized returns (bool) {
175         initialized = true;
176         return true;
177     }
178 
179     function getInitialized() public view returns (bool) {
180         return initialized;
181     }
182 }
183 
184 library SafeMathUint256 {
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         uint256 c = a * b;
187         require(a == 0 || c / a == b);
188         return c;
189     }
190 
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         // assert(b > 0); // Solidity automatically throws when dividing by 0
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195         return c;
196     }
197 
198     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
199         require(b <= a);
200         return a - b;
201     }
202 
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         uint256 c = a + b;
205         require(c >= a);
206         return c;
207     }
208 
209     function min(uint256 a, uint256 b) internal pure returns (uint256) {
210         if (a <= b) {
211             return a;
212         } else {
213             return b;
214         }
215     }
216 
217     function max(uint256 a, uint256 b) internal pure returns (uint256) {
218         if (a >= b) {
219             return a;
220         } else {
221             return b;
222         }
223     }
224 
225     function getUint256Min() internal pure returns (uint256) {
226         return 0;
227     }
228 
229     function getUint256Max() internal pure returns (uint256) {
230         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
231     }
232 
233     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
234         return a % b == 0;
235     }
236 
237     // Float [fixed point] Operations
238     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
239         return div(mul(a, b), base);
240     }
241 
242     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
243         return div(mul(a, base), b);
244     }
245 }
246 
247 contract ERC20Basic {
248     event Transfer(address indexed from, address indexed to, uint256 value);
249 
250     function balanceOf(address _who) public view returns (uint256);
251     function transfer(address _to, uint256 _value) public returns (bool);
252     function totalSupply() public view returns (uint256);
253 }
254 
255 contract ERC20 is ERC20Basic {
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 
258     function allowance(address _owner, address _spender) public view returns (uint256);
259     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
260     function approve(address _spender, uint256 _value) public returns (bool);
261 }
262 
263 contract IFeeToken is ERC20, Initializable {
264     function initialize(IFeeWindow _feeWindow) public returns (bool);
265     function getFeeWindow() public view returns (IFeeWindow);
266     function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
267     function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
268 }
269 
270 contract IFeeWindow is ITyped, ERC20 {
271     function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
272     function getUniverse() public view returns (IUniverse);
273     function getReputationToken() public view returns (IReputationToken);
274     function getStartTime() public view returns (uint256);
275     function getEndTime() public view returns (uint256);
276     function getNumMarkets() public view returns (uint256);
277     function getNumInvalidMarkets() public view returns (uint256);
278     function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
279     function getNumDesignatedReportNoShows() public view returns (uint256);
280     function getFeeToken() public view returns (IFeeToken);
281     function isActive() public view returns (bool);
282     function isOver() public view returns (bool);
283     function onMarketFinalized() public returns (bool);
284     function buy(uint256 _attotokens) public returns (bool);
285     function redeem(address _sender) public returns (bool);
286     function redeemForReportingParticipant() public returns (bool);
287     function mintFeeTokens(uint256 _amount) public returns (bool);
288     function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
289 }
290 
291 contract IMailbox {
292     function initialize(address _owner, IMarket _market) public returns (bool);
293     function depositEther() public payable returns (bool);
294 }
295 
296 contract IMarket is ITyped, IOwnable {
297     enum MarketType {
298         YES_NO,
299         CATEGORICAL,
300         SCALAR
301     }
302 
303     function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
304     function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
305     function getUniverse() public view returns (IUniverse);
306     function getFeeWindow() public view returns (IFeeWindow);
307     function getNumberOfOutcomes() public view returns (uint256);
308     function getNumTicks() public view returns (uint256);
309     function getDenominationToken() public view returns (ICash);
310     function getShareToken(uint256 _outcome)  public view returns (IShareToken);
311     function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
312     function getForkingMarket() public view returns (IMarket _market);
313     function getEndTime() public view returns (uint256);
314     function getMarketCreatorMailbox() public view returns (IMailbox);
315     function getWinningPayoutDistributionHash() public view returns (bytes32);
316     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
317     function getReputationToken() public view returns (IReputationToken);
318     function getFinalizationTime() public view returns (uint256);
319     function getInitialReporterAddress() public view returns (address);
320     function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
321     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
322     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
323     function isInvalid() public view returns (bool);
324     function finalize() public returns (bool);
325     function designatedReporterWasCorrect() public view returns (bool);
326     function designatedReporterShowed() public view returns (bool);
327     function isFinalized() public view returns (bool);
328     function finalizeFork() public returns (bool);
329     function assertBalances() public view returns (bool);
330 }
331 
332 contract IReportingParticipant {
333     function getStake() public view returns (uint256);
334     function getPayoutDistributionHash() public view returns (bytes32);
335     function liquidateLosing() public returns (bool);
336     function redeem(address _redeemer) public returns (bool);
337     function isInvalid() public view returns (bool);
338     function isDisavowed() public view returns (bool);
339     function migrate() public returns (bool);
340     function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
341     function getMarket() public view returns (IMarket);
342     function getSize() public view returns (uint256);
343 }
344 
345 contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
346     function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
347     function contribute(address _participant, uint256 _amount) public returns (uint256);
348 }
349 
350 contract IReputationToken is ITyped, ERC20 {
351     function initialize(IUniverse _universe) public returns (bool);
352     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
353     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
354     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
355     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
356     function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
357     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
358     function getUniverse() public view returns (IUniverse);
359     function getTotalMigrated() public view returns (uint256);
360     function getTotalTheoreticalSupply() public view returns (uint256);
361     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
362 }
363 
364 contract IUniverse is ITyped {
365     function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
366     function fork() public returns (bool);
367     function getParentUniverse() public view returns (IUniverse);
368     function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
369     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
370     function getReputationToken() public view returns (IReputationToken);
371     function getForkingMarket() public view returns (IMarket);
372     function getForkEndTime() public view returns (uint256);
373     function getForkReputationGoal() public view returns (uint256);
374     function getParentPayoutDistributionHash() public view returns (bytes32);
375     function getDisputeRoundDurationInSeconds() public view returns (uint256);
376     function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
377     function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
378     function getOrCreateNextFeeWindow() public returns (IFeeWindow);
379     function getOpenInterestInAttoEth() public view returns (uint256);
380     function getRepMarketCapInAttoeth() public view returns (uint256);
381     function getTargetRepMarketCapInAttoeth() public view returns (uint256);
382     function getOrCacheValidityBond() public returns (uint256);
383     function getOrCacheDesignatedReportStake() public returns (uint256);
384     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
385     function getOrCacheReportingFeeDivisor() public returns (uint256);
386     function getDisputeThresholdForFork() public view returns (uint256);
387     function getInitialReportMinValue() public view returns (uint256);
388     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
389     function getOrCacheMarketCreationCost() public returns (uint256);
390     function getCurrentFeeWindow() public view returns (IFeeWindow);
391     function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
392     function isParentOf(IUniverse _shadyChild) public view returns (bool);
393     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
394     function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
395     function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
396     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
397     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
398     function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
399     function addMarketTo() public returns (bool);
400     function removeMarketFrom() public returns (bool);
401     function decrementOpenInterest(uint256 _amount) public returns (bool);
402     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
403     function incrementOpenInterest(uint256 _amount) public returns (bool);
404     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
405     function getWinningChildUniverse() public view returns (IUniverse);
406     function isForking() public view returns (bool);
407 }
408 
409 contract ICash is ERC20 {
410     function depositEther() external payable returns(bool);
411     function depositEtherFor(address _to) external payable returns(bool);
412     function withdrawEther(uint256 _amount) external returns(bool);
413     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
414     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
415 }
416 
417 contract IOrders {
418     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
419     function removeOrder(bytes32 _orderId) public returns (bool);
420     function getMarket(bytes32 _orderId) public view returns (IMarket);
421     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
422     function getOutcome(bytes32 _orderId) public view returns (uint256);
423     function getAmount(bytes32 _orderId) public view returns (uint256);
424     function getPrice(bytes32 _orderId) public view returns (uint256);
425     function getOrderCreator(bytes32 _orderId) public view returns (address);
426     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
427     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
428     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
429     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
430     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
431     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
432     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
433     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
434     function getTotalEscrowed(IMarket _market) public view returns (uint256);
435     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
436     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
437     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
438     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
439     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
440     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
441     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
442     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
443 }
444 
445 contract IShareToken is ITyped, ERC20 {
446     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
447     function createShares(address _owner, uint256 _amount) external returns (bool);
448     function destroyShares(address, uint256 balance) external returns (bool);
449     function getMarket() external view returns (IMarket);
450     function getOutcome() external view returns (uint256);
451     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
452     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
453     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
454 }
455 
456 library Order {
457     using SafeMathUint256 for uint256;
458 
459     enum Types {
460         Bid, Ask
461     }
462 
463     enum TradeDirections {
464         Long, Short
465     }
466 
467     struct Data {
468         // Contracts
469         IOrders orders;
470         IMarket market;
471         IAugur augur;
472 
473         // Order
474         bytes32 id;
475         address creator;
476         uint256 outcome;
477         Order.Types orderType;
478         uint256 amount;
479         uint256 price;
480         uint256 sharesEscrowed;
481         uint256 moneyEscrowed;
482         bytes32 betterOrderId;
483         bytes32 worseOrderId;
484     }
485 
486     //
487     // Constructor
488     //
489 
490     // No validation is needed here as it is simply a librarty function for organizing data
491     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
492         require(_outcome < _market.getNumberOfOutcomes());
493         require(_price < _market.getNumTicks());
494 
495         IOrders _orders = IOrders(_controller.lookup("Orders"));
496         IAugur _augur = _controller.getAugur();
497 
498         return Data({
499             orders: _orders,
500             market: _market,
501             augur: _augur,
502             id: 0,
503             creator: _creator,
504             outcome: _outcome,
505             orderType: _type,
506             amount: _attoshares,
507             price: _price,
508             sharesEscrowed: 0,
509             moneyEscrowed: 0,
510             betterOrderId: _betterOrderId,
511             worseOrderId: _worseOrderId
512         });
513     }
514 
515     //
516     // "public" functions
517     //
518 
519     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
520         if (_orderData.id == bytes32(0)) {
521             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
522             require(_orderData.orders.getAmount(_orderId) == 0);
523             _orderData.id = _orderId;
524         }
525         return _orderData.id;
526     }
527 
528     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
529         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
530     }
531 
532     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
533         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
534     }
535 
536     function escrowFunds(Order.Data _orderData) internal returns (bool) {
537         if (_orderData.orderType == Order.Types.Ask) {
538             return escrowFundsForAsk(_orderData);
539         } else if (_orderData.orderType == Order.Types.Bid) {
540             return escrowFundsForBid(_orderData);
541         }
542     }
543 
544     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
545         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
546     }
547 
548     //
549     // Private functions
550     //
551 
552     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
553         require(_orderData.moneyEscrowed == 0);
554         require(_orderData.sharesEscrowed == 0);
555         uint256 _attosharesToCover = _orderData.amount;
556         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
557 
558         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
559         uint256 _attosharesHeld = 2**254;
560         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
561             if (_i != _orderData.outcome) {
562                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
563                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
564             }
565         }
566 
567         // Take shares into escrow if they have any almost-complete-sets
568         if (_attosharesHeld > 0) {
569             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
570             _attosharesToCover -= _orderData.sharesEscrowed;
571             for (_i = 0; _i < _numberOfOutcomes; _i++) {
572                 if (_i != _orderData.outcome) {
573                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
574                 }
575             }
576         }
577         // If not able to cover entire order with shares alone, then cover remaining with tokens
578         if (_attosharesToCover > 0) {
579             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
580             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
581         }
582 
583         return true;
584     }
585 
586     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
587         require(_orderData.moneyEscrowed == 0);
588         require(_orderData.sharesEscrowed == 0);
589         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
590         uint256 _attosharesToCover = _orderData.amount;
591 
592         // Figure out how many shares of the outcome the creator has
593         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
594 
595         // Take shares in escrow if user has shares
596         if (_attosharesHeld > 0) {
597             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
598             _attosharesToCover -= _orderData.sharesEscrowed;
599             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
600         }
601 
602         // If not able to cover entire order with shares alone, then cover remaining with tokens
603         if (_attosharesToCover > 0) {
604             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
605             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
606         }
607 
608         return true;
609     }
610 }