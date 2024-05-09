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
106 contract Controller is IController {
107     struct ContractDetails {
108         bytes32 name;
109         address contractAddress;
110         bytes20 commitHash;
111         bytes32 bytecodeHash;
112     }
113 
114     address public owner;
115     mapping(address => bool) public whitelist;
116     mapping(bytes32 => ContractDetails) public registry;
117     bool public stopped = false;
118 
119     modifier onlyOwnerCaller {
120         require(msg.sender == owner);
121         _;
122     }
123 
124     modifier onlyInBadTimes {
125         require(stopped);
126         _;
127     }
128 
129     modifier onlyInGoodTimes {
130         require(!stopped);
131         _;
132     }
133 
134     function Controller() public {
135         owner = msg.sender;
136         whitelist[msg.sender] = true;
137     }
138 
139     /*
140      * Contract Administration
141      */
142 
143     function addToWhitelist(address _target) public onlyOwnerCaller returns (bool) {
144         whitelist[_target] = true;
145         return true;
146     }
147 
148     function removeFromWhitelist(address _target) public onlyOwnerCaller returns (bool) {
149         whitelist[_target] = false;
150         return true;
151     }
152 
153     function assertIsWhitelisted(address _target) public view returns (bool) {
154         require(whitelist[_target]);
155         return true;
156     }
157 
158     function registerContract(bytes32 _key, address _address, bytes20 _commitHash, bytes32 _bytecodeHash) public onlyOwnerCaller returns (bool) {
159         require(registry[_key].contractAddress == address(0));
160         registry[_key] = ContractDetails(_key, _address, _commitHash, _bytecodeHash);
161         return true;
162     }
163 
164     function getContractDetails(bytes32 _key) public view returns (address, bytes20, bytes32) {
165         ContractDetails storage _details = registry[_key];
166         return (_details.contractAddress, _details.commitHash, _details.bytecodeHash);
167     }
168 
169     function lookup(bytes32 _key) public view returns (address) {
170         return registry[_key].contractAddress;
171     }
172 
173     function transferOwnership(address _newOwner) public onlyOwnerCaller returns (bool) {
174         owner = _newOwner;
175         return true;
176     }
177 
178     function emergencyStop() public onlyOwnerCaller onlyInGoodTimes returns (bool) {
179         getAugur().logEscapeHatchChanged(true);
180         stopped = true;
181         return true;
182     }
183 
184     function stopInEmergency() public view onlyInGoodTimes returns (bool) {
185         return true;
186     }
187 
188     function onlyInEmergency() public view onlyInBadTimes returns (bool) {
189         return true;
190     }
191 
192     /*
193      * Helper functions
194      */
195 
196     function getAugur() public view returns (IAugur) {
197         return IAugur(lookup("Augur"));
198     }
199 
200     function getTimestamp() public view returns (uint256) {
201         return ITime(lookup("Time")).getTimestamp();
202     }
203 }
204 
205 contract IOwnable {
206     function getOwner() public view returns (address);
207     function transferOwnership(address newOwner) public returns (bool);
208 }
209 
210 contract ITyped {
211     function getTypeName() public view returns (bytes32);
212 }
213 
214 contract ITime is Controlled, ITyped {
215     function getTimestamp() external view returns (uint256);
216 }
217 
218 contract Initializable {
219     bool private initialized = false;
220 
221     modifier afterInitialized {
222         require(initialized);
223         _;
224     }
225 
226     modifier beforeInitialized {
227         require(!initialized);
228         _;
229     }
230 
231     function endInitialization() internal beforeInitialized returns (bool) {
232         initialized = true;
233         return true;
234     }
235 
236     function getInitialized() public view returns (bool) {
237         return initialized;
238     }
239 }
240 
241 library SafeMathUint256 {
242     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
243         uint256 c = a * b;
244         require(a == 0 || c / a == b);
245         return c;
246     }
247 
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         // assert(b > 0); // Solidity automatically throws when dividing by 0
250         uint256 c = a / b;
251         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
252         return c;
253     }
254 
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         require(b <= a);
257         return a - b;
258     }
259 
260     function add(uint256 a, uint256 b) internal pure returns (uint256) {
261         uint256 c = a + b;
262         require(c >= a);
263         return c;
264     }
265 
266     function min(uint256 a, uint256 b) internal pure returns (uint256) {
267         if (a <= b) {
268             return a;
269         } else {
270             return b;
271         }
272     }
273 
274     function max(uint256 a, uint256 b) internal pure returns (uint256) {
275         if (a >= b) {
276             return a;
277         } else {
278             return b;
279         }
280     }
281 
282     function getUint256Min() internal pure returns (uint256) {
283         return 0;
284     }
285 
286     function getUint256Max() internal pure returns (uint256) {
287         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
288     }
289 
290     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
291         return a % b == 0;
292     }
293 
294     // Float [fixed point] Operations
295     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
296         return div(mul(a, b), base);
297     }
298 
299     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
300         return div(mul(a, base), b);
301     }
302 }
303 
304 contract ERC20Basic {
305     event Transfer(address indexed from, address indexed to, uint256 value);
306 
307     function balanceOf(address _who) public view returns (uint256);
308     function transfer(address _to, uint256 _value) public returns (bool);
309     function totalSupply() public view returns (uint256);
310 }
311 
312 contract ERC20 is ERC20Basic {
313     event Approval(address indexed owner, address indexed spender, uint256 value);
314 
315     function allowance(address _owner, address _spender) public view returns (uint256);
316     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
317     function approve(address _spender, uint256 _value) public returns (bool);
318 }
319 
320 contract IFeeToken is ERC20, Initializable {
321     function initialize(IFeeWindow _feeWindow) public returns (bool);
322     function getFeeWindow() public view returns (IFeeWindow);
323     function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
324     function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
325 }
326 
327 contract IFeeWindow is ITyped, ERC20 {
328     function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
329     function getUniverse() public view returns (IUniverse);
330     function getReputationToken() public view returns (IReputationToken);
331     function getStartTime() public view returns (uint256);
332     function getEndTime() public view returns (uint256);
333     function getNumMarkets() public view returns (uint256);
334     function getNumInvalidMarkets() public view returns (uint256);
335     function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
336     function getNumDesignatedReportNoShows() public view returns (uint256);
337     function getFeeToken() public view returns (IFeeToken);
338     function isActive() public view returns (bool);
339     function isOver() public view returns (bool);
340     function onMarketFinalized() public returns (bool);
341     function buy(uint256 _attotokens) public returns (bool);
342     function redeem(address _sender) public returns (bool);
343     function redeemForReportingParticipant() public returns (bool);
344     function mintFeeTokens(uint256 _amount) public returns (bool);
345     function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
346 }
347 
348 contract IMailbox {
349     function initialize(address _owner, IMarket _market) public returns (bool);
350     function depositEther() public payable returns (bool);
351 }
352 
353 contract IMarket is ITyped, IOwnable {
354     enum MarketType {
355         YES_NO,
356         CATEGORICAL,
357         SCALAR
358     }
359 
360     function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
361     function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
362     function getUniverse() public view returns (IUniverse);
363     function getFeeWindow() public view returns (IFeeWindow);
364     function getNumberOfOutcomes() public view returns (uint256);
365     function getNumTicks() public view returns (uint256);
366     function getDenominationToken() public view returns (ICash);
367     function getShareToken(uint256 _outcome)  public view returns (IShareToken);
368     function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
369     function getForkingMarket() public view returns (IMarket _market);
370     function getEndTime() public view returns (uint256);
371     function getMarketCreatorMailbox() public view returns (IMailbox);
372     function getWinningPayoutDistributionHash() public view returns (bytes32);
373     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
374     function getReputationToken() public view returns (IReputationToken);
375     function getFinalizationTime() public view returns (uint256);
376     function getInitialReporterAddress() public view returns (address);
377     function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
378     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
379     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
380     function isInvalid() public view returns (bool);
381     function finalize() public returns (bool);
382     function designatedReporterWasCorrect() public view returns (bool);
383     function designatedReporterShowed() public view returns (bool);
384     function isFinalized() public view returns (bool);
385     function finalizeFork() public returns (bool);
386     function assertBalances() public view returns (bool);
387 }
388 
389 contract IReportingParticipant {
390     function getStake() public view returns (uint256);
391     function getPayoutDistributionHash() public view returns (bytes32);
392     function liquidateLosing() public returns (bool);
393     function redeem(address _redeemer) public returns (bool);
394     function isInvalid() public view returns (bool);
395     function isDisavowed() public view returns (bool);
396     function migrate() public returns (bool);
397     function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
398     function getMarket() public view returns (IMarket);
399     function getSize() public view returns (uint256);
400 }
401 
402 contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
403     function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
404     function contribute(address _participant, uint256 _amount) public returns (uint256);
405 }
406 
407 contract IReputationToken is ITyped, ERC20 {
408     function initialize(IUniverse _universe) public returns (bool);
409     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
410     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
411     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
412     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
413     function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
414     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
415     function getUniverse() public view returns (IUniverse);
416     function getTotalMigrated() public view returns (uint256);
417     function getTotalTheoreticalSupply() public view returns (uint256);
418     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
419 }
420 
421 contract IUniverse is ITyped {
422     function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
423     function fork() public returns (bool);
424     function getParentUniverse() public view returns (IUniverse);
425     function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
426     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
427     function getReputationToken() public view returns (IReputationToken);
428     function getForkingMarket() public view returns (IMarket);
429     function getForkEndTime() public view returns (uint256);
430     function getForkReputationGoal() public view returns (uint256);
431     function getParentPayoutDistributionHash() public view returns (bytes32);
432     function getDisputeRoundDurationInSeconds() public view returns (uint256);
433     function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
434     function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
435     function getOrCreateNextFeeWindow() public returns (IFeeWindow);
436     function getOpenInterestInAttoEth() public view returns (uint256);
437     function getRepMarketCapInAttoeth() public view returns (uint256);
438     function getTargetRepMarketCapInAttoeth() public view returns (uint256);
439     function getOrCacheValidityBond() public returns (uint256);
440     function getOrCacheDesignatedReportStake() public returns (uint256);
441     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
442     function getOrCacheReportingFeeDivisor() public returns (uint256);
443     function getDisputeThresholdForFork() public view returns (uint256);
444     function getInitialReportMinValue() public view returns (uint256);
445     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
446     function getOrCacheMarketCreationCost() public returns (uint256);
447     function getCurrentFeeWindow() public view returns (IFeeWindow);
448     function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
449     function isParentOf(IUniverse _shadyChild) public view returns (bool);
450     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
451     function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
452     function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
453     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
454     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
455     function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
456     function addMarketTo() public returns (bool);
457     function removeMarketFrom() public returns (bool);
458     function decrementOpenInterest(uint256 _amount) public returns (bool);
459     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
460     function incrementOpenInterest(uint256 _amount) public returns (bool);
461     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
462     function getWinningChildUniverse() public view returns (IUniverse);
463     function isForking() public view returns (bool);
464 }
465 
466 contract ICash is ERC20 {
467     function depositEther() external payable returns(bool);
468     function depositEtherFor(address _to) external payable returns(bool);
469     function withdrawEther(uint256 _amount) external returns(bool);
470     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
471     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
472 }
473 
474 contract IOrders {
475     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
476     function removeOrder(bytes32 _orderId) public returns (bool);
477     function getMarket(bytes32 _orderId) public view returns (IMarket);
478     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
479     function getOutcome(bytes32 _orderId) public view returns (uint256);
480     function getAmount(bytes32 _orderId) public view returns (uint256);
481     function getPrice(bytes32 _orderId) public view returns (uint256);
482     function getOrderCreator(bytes32 _orderId) public view returns (address);
483     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
484     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
485     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
486     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
487     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
488     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
489     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
490     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
491     function getTotalEscrowed(IMarket _market) public view returns (uint256);
492     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
493     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
494     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
495     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
496     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
497     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
498     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
499     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
500 }
501 
502 contract IShareToken is ITyped, ERC20 {
503     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
504     function createShares(address _owner, uint256 _amount) external returns (bool);
505     function destroyShares(address, uint256 balance) external returns (bool);
506     function getMarket() external view returns (IMarket);
507     function getOutcome() external view returns (uint256);
508     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
509     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
510     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
511 }
512 
513 library Order {
514     using SafeMathUint256 for uint256;
515 
516     enum Types {
517         Bid, Ask
518     }
519 
520     enum TradeDirections {
521         Long, Short
522     }
523 
524     struct Data {
525         // Contracts
526         IOrders orders;
527         IMarket market;
528         IAugur augur;
529 
530         // Order
531         bytes32 id;
532         address creator;
533         uint256 outcome;
534         Order.Types orderType;
535         uint256 amount;
536         uint256 price;
537         uint256 sharesEscrowed;
538         uint256 moneyEscrowed;
539         bytes32 betterOrderId;
540         bytes32 worseOrderId;
541     }
542 
543     //
544     // Constructor
545     //
546 
547     // No validation is needed here as it is simply a librarty function for organizing data
548     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
549         require(_outcome < _market.getNumberOfOutcomes());
550         require(_price < _market.getNumTicks());
551 
552         IOrders _orders = IOrders(_controller.lookup("Orders"));
553         IAugur _augur = _controller.getAugur();
554 
555         return Data({
556             orders: _orders,
557             market: _market,
558             augur: _augur,
559             id: 0,
560             creator: _creator,
561             outcome: _outcome,
562             orderType: _type,
563             amount: _attoshares,
564             price: _price,
565             sharesEscrowed: 0,
566             moneyEscrowed: 0,
567             betterOrderId: _betterOrderId,
568             worseOrderId: _worseOrderId
569         });
570     }
571 
572     //
573     // "public" functions
574     //
575 
576     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
577         if (_orderData.id == bytes32(0)) {
578             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
579             require(_orderData.orders.getAmount(_orderId) == 0);
580             _orderData.id = _orderId;
581         }
582         return _orderData.id;
583     }
584 
585     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
586         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
587     }
588 
589     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
590         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
591     }
592 
593     function escrowFunds(Order.Data _orderData) internal returns (bool) {
594         if (_orderData.orderType == Order.Types.Ask) {
595             return escrowFundsForAsk(_orderData);
596         } else if (_orderData.orderType == Order.Types.Bid) {
597             return escrowFundsForBid(_orderData);
598         }
599     }
600 
601     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
602         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
603     }
604 
605     //
606     // Private functions
607     //
608 
609     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
610         require(_orderData.moneyEscrowed == 0);
611         require(_orderData.sharesEscrowed == 0);
612         uint256 _attosharesToCover = _orderData.amount;
613         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
614 
615         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
616         uint256 _attosharesHeld = 2**254;
617         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
618             if (_i != _orderData.outcome) {
619                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
620                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
621             }
622         }
623 
624         // Take shares into escrow if they have any almost-complete-sets
625         if (_attosharesHeld > 0) {
626             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
627             _attosharesToCover -= _orderData.sharesEscrowed;
628             for (_i = 0; _i < _numberOfOutcomes; _i++) {
629                 if (_i != _orderData.outcome) {
630                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
631                 }
632             }
633         }
634         // If not able to cover entire order with shares alone, then cover remaining with tokens
635         if (_attosharesToCover > 0) {
636             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
637             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
638         }
639 
640         return true;
641     }
642 
643     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
644         require(_orderData.moneyEscrowed == 0);
645         require(_orderData.sharesEscrowed == 0);
646         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
647         uint256 _attosharesToCover = _orderData.amount;
648 
649         // Figure out how many shares of the outcome the creator has
650         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
651 
652         // Take shares in escrow if user has shares
653         if (_attosharesHeld > 0) {
654             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
655             _attosharesToCover -= _orderData.sharesEscrowed;
656             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
657         }
658 
659         // If not able to cover entire order with shares alone, then cover remaining with tokens
660         if (_attosharesToCover > 0) {
661             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
662             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
663         }
664 
665         return true;
666     }
667 }