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
97 contract Augur is Controlled, IAugur {
98 
99     enum TokenType{
100         ReputationToken,
101         ShareToken,
102         DisputeCrowdsourcer,
103         FeeWindow,
104         FeeToken
105     }
106 
107     event MarketCreated(bytes32 indexed topic, string description, string extraInfo, address indexed universe, address market, address indexed marketCreator, bytes32[] outcomes, uint256 marketCreationFee, int256 minPrice, int256 maxPrice, IMarket.MarketType marketType);
108     event InitialReportSubmitted(address indexed universe, address indexed reporter, address indexed market, uint256 amountStaked, bool isDesignatedReporter, uint256[] payoutNumerators, bool invalid);
109     event DisputeCrowdsourcerCreated(address indexed universe, address indexed market, address disputeCrowdsourcer, uint256[] payoutNumerators, uint256 size, bool invalid);
110     event DisputeCrowdsourcerContribution(address indexed universe, address indexed reporter, address indexed market, address disputeCrowdsourcer, uint256 amountStaked);
111     event DisputeCrowdsourcerCompleted(address indexed universe, address indexed market, address disputeCrowdsourcer);
112     event InitialReporterRedeemed(address indexed universe, address indexed reporter, address indexed market, uint256 amountRedeemed, uint256 repReceived, uint256 reportingFeesReceived, uint256[] payoutNumerators);
113     event DisputeCrowdsourcerRedeemed(address indexed universe, address indexed reporter, address indexed market, address disputeCrowdsourcer, uint256 amountRedeemed, uint256 repReceived, uint256 reportingFeesReceived, uint256[] payoutNumerators);
114     event ReportingParticipantDisavowed(address indexed universe, address indexed market, address reportingParticipant);
115     event MarketParticipantsDisavowed(address indexed universe, address indexed market);
116     event FeeWindowRedeemed(address indexed universe, address indexed reporter, address indexed feeWindow, uint256 amountRedeemed, uint256 reportingFeesReceived);
117     event MarketFinalized(address indexed universe, address indexed market);
118     event MarketMigrated(address indexed market, address indexed originalUniverse, address indexed newUniverse);
119     event UniverseForked(address indexed universe);
120     event UniverseCreated(address indexed parentUniverse, address indexed childUniverse, uint256[] payoutNumerators, bool invalid);
121     event OrderCanceled(address indexed universe, address indexed shareToken, address indexed sender, bytes32 orderId, Order.Types orderType, uint256 tokenRefund, uint256 sharesRefund);
122     // The ordering here is to match functions higher in the call chain to avoid stack depth issues
123     event OrderCreated(Order.Types orderType, uint256 amount, uint256 price, address indexed creator, uint256 moneyEscrowed, uint256 sharesEscrowed, bytes32 tradeGroupId, bytes32 orderId, address indexed universe, address indexed shareToken);
124     event OrderFilled(address indexed universe, address indexed shareToken, address filler, bytes32 orderId, uint256 numCreatorShares, uint256 numCreatorTokens, uint256 numFillerShares, uint256 numFillerTokens, uint256 marketCreatorFees, uint256 reporterFees, uint256 amountFilled, bytes32 tradeGroupId);
125     event CompleteSetsPurchased(address indexed universe, address indexed market, address indexed account, uint256 numCompleteSets);
126     event CompleteSetsSold(address indexed universe, address indexed market, address indexed account, uint256 numCompleteSets);
127     event TradingProceedsClaimed(address indexed universe, address indexed shareToken, address indexed sender, address market, uint256 numShares, uint256 numPayoutTokens, uint256 finalTokenBalance);
128     event TokensTransferred(address indexed universe, address indexed token, address indexed from, address to, uint256 value, TokenType tokenType, address market);
129     event TokensMinted(address indexed universe, address indexed token, address indexed target, uint256 amount, TokenType tokenType, address market);
130     event TokensBurned(address indexed universe, address indexed token, address indexed target, uint256 amount, TokenType tokenType, address market);
131     event FeeWindowCreated(address indexed universe, address feeWindow, uint256 startTime, uint256 endTime, uint256 id);
132     event InitialReporterTransferred(address indexed universe, address indexed market, address from, address to);
133     event MarketTransferred(address indexed universe, address indexed market, address from, address to);
134     event MarketMailboxTransferred(address indexed universe, address indexed market, address indexed mailbox, address from, address to);
135     event EscapeHatchChanged(bool isOn);
136     event TimestampSet(uint256 newTimestamp);
137 
138     mapping(address => bool) private universes;
139     mapping(address => bool) private crowdsourcers;
140 
141     //
142     // Universe
143     //
144 
145     function createGenesisUniverse() public returns (IUniverse) {
146         return createUniverse(IUniverse(0), bytes32(0), new uint256[](0), false);
147     }
148 
149     function createChildUniverse(bytes32 _parentPayoutDistributionHash, uint256[] _parentPayoutNumerators, bool _parentInvalid) public returns (IUniverse) {
150         IUniverse _parentUniverse = IUniverse(msg.sender);
151         require(isKnownUniverse(_parentUniverse));
152         return createUniverse(_parentUniverse, _parentPayoutDistributionHash, _parentPayoutNumerators, _parentInvalid);
153     }
154 
155     function createUniverse(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash, uint256[] _parentPayoutNumerators, bool _parentInvalid) private returns (IUniverse) {
156         UniverseFactory _universeFactory = UniverseFactory(controller.lookup("UniverseFactory"));
157         IUniverse _newUniverse = _universeFactory.createUniverse(controller, _parentUniverse, _parentPayoutDistributionHash);
158         universes[_newUniverse] = true;
159         UniverseCreated(_parentUniverse, _newUniverse, _parentPayoutNumerators, _parentInvalid);
160         return _newUniverse;
161     }
162 
163     function isKnownUniverse(IUniverse _universe) public view returns (bool) {
164         return universes[_universe];
165     }
166 
167     //
168     // Crowdsourcers
169     //
170 
171     function isKnownCrowdsourcer(IDisputeCrowdsourcer _crowdsourcer) public view returns (bool) {
172         return crowdsourcers[_crowdsourcer];
173     }
174 
175     function disputeCrowdsourcerCreated(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] _payoutNumerators, uint256 _size, bool _invalid) public returns (bool) {
176         require(isKnownUniverse(_universe));
177         require(_universe.isContainerForMarket(IMarket(msg.sender)));
178         crowdsourcers[_disputeCrowdsourcer] = true;
179         DisputeCrowdsourcerCreated(_universe, _market, _disputeCrowdsourcer, _payoutNumerators, _size, _invalid);
180         return true;
181     }
182 
183     //
184     // Transfer
185     //
186 
187     function trustedTransfer(ERC20 _token, address _from, address _to, uint256 _amount) public onlyWhitelistedCallers returns (bool) {
188         require(_amount > 0);
189         require(_token.transferFrom(_from, _to, _amount));
190         return true;
191     }
192 
193     //
194     // Logging
195     //
196 
197     // This signature is intended for the categorical market creation. We use two signatures for the same event because of stack depth issues which can be circumvented by maintaining order of paramaters
198     function logMarketCreated(bytes32 _topic, string _description, string _extraInfo, IUniverse _universe, address _market, address _marketCreator, bytes32[] _outcomes, int256 _minPrice, int256 _maxPrice, IMarket.MarketType _marketType) public returns (bool) {
199         require(isKnownUniverse(_universe));
200         require(_universe == IUniverse(msg.sender));
201         MarketCreated(_topic, _description, _extraInfo, _universe, _market, _marketCreator, _outcomes, _universe.getOrCacheMarketCreationCost(), _minPrice, _maxPrice, _marketType);
202         return true;
203     }
204 
205     // This signature is intended for yesNo and scalar market creation. See function comment above for explanation.
206     function logMarketCreated(bytes32 _topic, string _description, string _extraInfo, IUniverse _universe, address _market, address _marketCreator, int256 _minPrice, int256 _maxPrice, IMarket.MarketType _marketType) public returns (bool) {
207         require(isKnownUniverse(_universe));
208         require(_universe == IUniverse(msg.sender));
209         MarketCreated(_topic, _description, _extraInfo, _universe, _market, _marketCreator, new bytes32[](0), _universe.getOrCacheMarketCreationCost(), _minPrice, _maxPrice, _marketType);
210         return true;
211     }
212 
213     function logInitialReportSubmitted(IUniverse _universe, address _reporter, address _market, uint256 _amountStaked, bool _isDesignatedReporter, uint256[] _payoutNumerators, bool _invalid) public returns (bool) {
214         require(isKnownUniverse(_universe));
215         require(_universe.isContainerForMarket(IMarket(msg.sender)));
216         InitialReportSubmitted(_universe, _reporter, _market, _amountStaked, _isDesignatedReporter, _payoutNumerators, _invalid);
217         return true;
218     }
219 
220     function logDisputeCrowdsourcerContribution(IUniverse _universe, address _reporter, address _market, address _disputeCrowdsourcer, uint256 _amountStaked) public returns (bool) {
221         require(isKnownUniverse(_universe));
222         require(_universe.isContainerForMarket(IMarket(msg.sender)));
223         DisputeCrowdsourcerContribution(_universe, _reporter, _market, _disputeCrowdsourcer, _amountStaked);
224         return true;
225     }
226 
227     function logDisputeCrowdsourcerCompleted(IUniverse _universe, address _market, address _disputeCrowdsourcer) public returns (bool) {
228         require(isKnownUniverse(_universe));
229         require(_universe.isContainerForMarket(IMarket(msg.sender)));
230         DisputeCrowdsourcerCompleted(_universe, _market, _disputeCrowdsourcer);
231         return true;
232     }
233 
234     function logInitialReporterRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256 _reportingFeesReceived, uint256[] _payoutNumerators) public returns (bool) {
235         require(isKnownUniverse(_universe));
236         require(_universe.isContainerForReportingParticipant(IReportingParticipant(msg.sender)));
237         InitialReporterRedeemed(_universe, _reporter, _market, _amountRedeemed, _repReceived, _reportingFeesReceived, _payoutNumerators);
238         return true;
239     }
240 
241     function logDisputeCrowdsourcerRedeemed(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256 _reportingFeesReceived, uint256[] _payoutNumerators) public returns (bool) {
242         IDisputeCrowdsourcer _disputeCrowdsourcer = IDisputeCrowdsourcer(msg.sender);
243         require(isKnownCrowdsourcer(_disputeCrowdsourcer));
244         DisputeCrowdsourcerRedeemed(_universe, _reporter, _market, _disputeCrowdsourcer, _amountRedeemed, _repReceived, _reportingFeesReceived, _payoutNumerators);
245         return true;
246     }
247 
248     function logReportingParticipantDisavowed(IUniverse _universe, IMarket _market) public returns (bool) {
249         require(isKnownUniverse(_universe));
250         require(_universe.isContainerForReportingParticipant(IReportingParticipant(msg.sender)));
251         ReportingParticipantDisavowed(_universe, _market, msg.sender);
252         return true;
253     }
254 
255     function logMarketParticipantsDisavowed(IUniverse _universe) public returns (bool) {
256         require(isKnownUniverse(_universe));
257         IMarket _market = IMarket(msg.sender);
258         require(_universe.isContainerForMarket(_market));
259         MarketParticipantsDisavowed(_universe, _market);
260         return true;
261     }
262 
263     function logFeeWindowRedeemed(IUniverse _universe, address _reporter, uint256 _amountRedeemed, uint256 _reportingFeesReceived) public returns (bool) {
264         require(isKnownUniverse(_universe));
265         require(_universe.isContainerForFeeWindow(IFeeWindow(msg.sender)));
266         FeeWindowRedeemed(_universe, _reporter, msg.sender, _amountRedeemed, _reportingFeesReceived);
267         return true;
268     }
269 
270     function logMarketFinalized(IUniverse _universe) public returns (bool) {
271         require(isKnownUniverse(_universe));
272         IMarket _market = IMarket(msg.sender);
273         require(_universe.isContainerForMarket(_market));
274         MarketFinalized(_universe, _market);
275         return true;
276     }
277 
278     function logMarketMigrated(IMarket _market, IUniverse _originalUniverse) public returns (bool) {
279         IUniverse _newUniverse = IUniverse(msg.sender);
280         require(isKnownUniverse(_newUniverse));
281         MarketMigrated(_market, _originalUniverse, _newUniverse);
282         return true;
283     }
284 
285     function logOrderCanceled(IUniverse _universe, address _shareToken, address _sender, bytes32 _orderId, Order.Types _orderType, uint256 _tokenRefund, uint256 _sharesRefund) public onlyWhitelistedCallers returns (bool) {
286         OrderCanceled(_universe, _shareToken, _sender, _orderId, _orderType, _tokenRefund, _sharesRefund);
287         return true;
288     }
289 
290     function logOrderCreated(Order.Types _orderType, uint256 _amount, uint256 _price, address _creator, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _tradeGroupId, bytes32 _orderId, IUniverse _universe, address _shareToken) public onlyWhitelistedCallers returns (bool) {
291         OrderCreated(_orderType, _amount, _price, _creator, _moneyEscrowed, _sharesEscrowed, _tradeGroupId, _orderId, _universe, _shareToken);
292         return true;
293     }
294 
295     function logOrderFilled(IUniverse _universe, address _shareToken, address _filler, bytes32 _orderId, uint256 _numCreatorShares, uint256 _numCreatorTokens, uint256 _numFillerShares, uint256 _numFillerTokens, uint256 _marketCreatorFees, uint256 _reporterFees, uint256 _amountFilled, bytes32 _tradeGroupId) public onlyWhitelistedCallers returns (bool) {
296         OrderFilled(_universe, _shareToken, _filler, _orderId, _numCreatorShares, _numCreatorTokens, _numFillerShares, _numFillerTokens, _marketCreatorFees, _reporterFees, _amountFilled, _tradeGroupId);
297         return true;
298     }
299 
300     function logCompleteSetsPurchased(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public onlyWhitelistedCallers returns (bool) {
301         CompleteSetsPurchased(_universe, _market, _account, _numCompleteSets);
302         return true;
303     }
304 
305     function logCompleteSetsSold(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public onlyWhitelistedCallers returns (bool) {
306         CompleteSetsSold(_universe, _market, _account, _numCompleteSets);
307         return true;
308     }
309 
310     function logTradingProceedsClaimed(IUniverse _universe, address _shareToken, address _sender, address _market, uint256 _numShares, uint256 _numPayoutTokens, uint256 _finalTokenBalance) public onlyWhitelistedCallers returns (bool) {
311         TradingProceedsClaimed(_universe, _shareToken, _sender, _market, _numShares, _numPayoutTokens, _finalTokenBalance);
312         return true;
313     }
314 
315     function logUniverseForked() public returns (bool) {
316         require(universes[msg.sender]);
317         UniverseForked(msg.sender);
318         return true;
319     }
320 
321     function logFeeWindowTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool) {
322         require(isKnownUniverse(_universe));
323         require(_universe.isContainerForFeeWindow(IFeeWindow(msg.sender)));
324         TokensTransferred(_universe, msg.sender, _from, _to, _value, TokenType.FeeWindow, 0);
325         return true;
326     }
327 
328     function logReputationTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool) {
329         require(isKnownUniverse(_universe));
330         require(_universe.getReputationToken() == IReputationToken(msg.sender));
331         TokensTransferred(_universe, msg.sender, _from, _to, _value, TokenType.ReputationToken, 0);
332         return true;
333     }
334 
335     function logDisputeCrowdsourcerTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool) {
336         IDisputeCrowdsourcer _disputeCrowdsourcer = IDisputeCrowdsourcer(msg.sender);
337         require(isKnownCrowdsourcer(_disputeCrowdsourcer));
338         TokensTransferred(_universe, msg.sender, _from, _to, _value, TokenType.DisputeCrowdsourcer, _disputeCrowdsourcer.getMarket());
339         return true;
340     }
341 
342     function logShareTokensTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool) {
343         require(isKnownUniverse(_universe));
344         IShareToken _shareToken = IShareToken(msg.sender);
345         require(_universe.isContainerForShareToken(_shareToken));
346         TokensTransferred(_universe, msg.sender, _from, _to, _value, TokenType.ShareToken, _shareToken.getMarket());
347         return true;
348     }
349 
350     function logReputationTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool) {
351         require(isKnownUniverse(_universe));
352         require(_universe.getReputationToken() == IReputationToken(msg.sender));
353         TokensBurned(_universe, msg.sender, _target, _amount, TokenType.ReputationToken, 0);
354         return true;
355     }
356 
357     function logReputationTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool) {
358         require(isKnownUniverse(_universe));
359         require(_universe.getReputationToken() == IReputationToken(msg.sender));
360         TokensMinted(_universe, msg.sender, _target, _amount, TokenType.ReputationToken, 0);
361         return true;
362     }
363 
364     function logShareTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool) {
365         require(isKnownUniverse(_universe));
366         IShareToken _shareToken = IShareToken(msg.sender);
367         require(_universe.isContainerForShareToken(_shareToken));
368         TokensBurned(_universe, msg.sender, _target, _amount, TokenType.ShareToken, _shareToken.getMarket());
369         return true;
370     }
371 
372     function logShareTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool) {
373         require(isKnownUniverse(_universe));
374         IShareToken _shareToken = IShareToken(msg.sender);
375         require(_universe.isContainerForShareToken(_shareToken));
376         TokensMinted(_universe, msg.sender, _target, _amount, TokenType.ShareToken, _shareToken.getMarket());
377         return true;
378     }
379 
380     function logFeeWindowBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool) {
381         require(isKnownUniverse(_universe));
382         require(_universe.isContainerForFeeWindow(IFeeWindow(msg.sender)));
383         TokensBurned(_universe, msg.sender, _target, _amount, TokenType.FeeWindow, 0);
384         return true;
385     }
386 
387     function logFeeWindowMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool) {
388         require(isKnownUniverse(_universe));
389         require(_universe.isContainerForFeeWindow(IFeeWindow(msg.sender)));
390         TokensMinted(_universe, msg.sender, _target, _amount, TokenType.FeeWindow, 0);
391         return true;
392     }
393 
394     function logDisputeCrowdsourcerTokensBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool) {
395         IDisputeCrowdsourcer _disputeCrowdsourcer = IDisputeCrowdsourcer(msg.sender);
396         require(isKnownCrowdsourcer(_disputeCrowdsourcer));
397         TokensBurned(_universe, msg.sender, _target, _amount, TokenType.DisputeCrowdsourcer, _disputeCrowdsourcer.getMarket());
398         return true;
399     }
400 
401     function logDisputeCrowdsourcerTokensMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool) {
402         IDisputeCrowdsourcer _disputeCrowdsourcer = IDisputeCrowdsourcer(msg.sender);
403         require(isKnownCrowdsourcer(_disputeCrowdsourcer));
404         TokensMinted(_universe, msg.sender, _target, _amount, TokenType.DisputeCrowdsourcer, _disputeCrowdsourcer.getMarket());
405         return true;
406     }
407 
408     function logFeeWindowCreated(IFeeWindow _feeWindow, uint256 _id) public returns (bool) {
409         require(universes[msg.sender]);
410         FeeWindowCreated(msg.sender, _feeWindow, _feeWindow.getStartTime(), _feeWindow.getEndTime(), _id);
411         return true;
412     }
413 
414     function logFeeTokenTransferred(IUniverse _universe, address _from, address _to, uint256 _value) public returns (bool) {
415         require(isKnownUniverse(_universe));
416         require(_universe.isContainerForFeeToken(IFeeToken(msg.sender)));
417         TokensTransferred(_universe, msg.sender, _from, _to, _value, TokenType.FeeToken, 0);
418         return true;
419     }
420 
421     function logFeeTokenBurned(IUniverse _universe, address _target, uint256 _amount) public returns (bool) {
422         require(isKnownUniverse(_universe));
423         require(_universe.isContainerForFeeToken(IFeeToken(msg.sender)));
424         TokensBurned(_universe, msg.sender, _target, _amount, TokenType.FeeToken, 0);
425         return true;
426     }
427 
428     function logFeeTokenMinted(IUniverse _universe, address _target, uint256 _amount) public returns (bool) {
429         require(isKnownUniverse(_universe));
430         require(_universe.isContainerForFeeToken(IFeeToken(msg.sender)));
431         TokensMinted(_universe, msg.sender, _target, _amount, TokenType.FeeToken, 0);
432         return true;
433     }
434 
435     function logTimestampSet(uint256 _newTimestamp) public returns (bool) {
436         require(msg.sender == controller.lookup("Time"));
437         TimestampSet(_newTimestamp);
438         return true;
439     }
440 
441     function logInitialReporterTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool) {
442         require(isKnownUniverse(_universe));
443         require(_universe.isContainerForMarket(_market));
444         require(msg.sender == _market.getInitialReporterAddress());
445         InitialReporterTransferred(_universe, _market, _from, _to);
446         return true;
447     }
448 
449     function logMarketTransferred(IUniverse _universe, address _from, address _to) public returns (bool) {
450         require(isKnownUniverse(_universe));
451         IMarket _market = IMarket(msg.sender);
452         require(_universe.isContainerForMarket(_market));
453         MarketTransferred(_universe, _market, _from, _to);
454         return true;
455     }
456 
457     function logMarketMailboxTransferred(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool) {
458         require(isKnownUniverse(_universe));
459         require(_universe.isContainerForMarket(_market));
460         require(IMailbox(msg.sender) == _market.getMarketCreatorMailbox());
461         MarketMailboxTransferred(_universe, _market, msg.sender, _from, _to);
462         return true;
463     }
464 
465     function logEscapeHatchChanged(bool _isOn) public returns (bool) {
466         require(msg.sender == address(controller));
467         EscapeHatchChanged(_isOn);
468         return true;
469     }
470 }
471 
472 contract IController {
473     function assertIsWhitelisted(address _target) public view returns(bool);
474     function lookup(bytes32 _key) public view returns(address);
475     function stopInEmergency() public view returns(bool);
476     function onlyInEmergency() public view returns(bool);
477     function getAugur() public view returns (IAugur);
478     function getTimestamp() public view returns (uint256);
479 }
480 
481 contract UniverseFactory {
482     function createUniverse(IController _controller, IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) public returns (IUniverse) {
483         Delegator _delegator = new Delegator(_controller, "Universe");
484         IUniverse _universe = IUniverse(_delegator);
485         _universe.initialize(_parentUniverse, _parentPayoutDistributionHash);
486         return _universe;
487     }
488 }
489 
490 contract DelegationTarget is Controlled {
491     bytes32 public controllerLookupName;
492 }
493 
494 contract Delegator is DelegationTarget {
495     function Delegator(IController _controller, bytes32 _controllerLookupName) public {
496         controller = _controller;
497         controllerLookupName = _controllerLookupName;
498     }
499 
500     function() external payable {
501         // Do nothing if we haven't properly set up the delegator to delegate calls
502         if (controllerLookupName == 0) {
503             return;
504         }
505 
506         // Get the delegation target contract
507         address _target = controller.lookup(controllerLookupName);
508 
509         assembly {
510             //0x40 is the address where the next free memory slot is stored in Solidity
511             let _calldataMemoryOffset := mload(0x40)
512             // new "memory end" including padding. The bitwise operations here ensure we get rounded up to the nearest 32 byte boundary
513             let _size := and(add(calldatasize, 0x1f), not(0x1f))
514             // Update the pointer at 0x40 to point at new free memory location so any theoretical allocation doesn't stomp our memory in this call
515             mstore(0x40, add(_calldataMemoryOffset, _size))
516             // Copy method signature and parameters of this call into memory
517             calldatacopy(_calldataMemoryOffset, 0x0, calldatasize)
518             // Call the actual method via delegation
519             let _retval := delegatecall(gas, _target, _calldataMemoryOffset, calldatasize, 0, 0)
520             switch _retval
521             case 0 {
522                 // 0 == it threw, so we revert
523                 revert(0,0)
524             } default {
525                 // If the call succeeded return the return data from the delegate call
526                 let _returndataMemoryOffset := mload(0x40)
527                 // Update the pointer at 0x40 again to point at new free memory location so any theoretical allocation doesn't stomp our memory in this call
528                 mstore(0x40, add(_returndataMemoryOffset, returndatasize))
529                 returndatacopy(_returndataMemoryOffset, 0x0, returndatasize)
530                 return(_returndataMemoryOffset, returndatasize)
531             }
532         }
533     }
534 }
535 
536 contract IOwnable {
537     function getOwner() public view returns (address);
538     function transferOwnership(address newOwner) public returns (bool);
539 }
540 
541 contract ITyped {
542     function getTypeName() public view returns (bytes32);
543 }
544 
545 contract Initializable {
546     bool private initialized = false;
547 
548     modifier afterInitialized {
549         require(initialized);
550         _;
551     }
552 
553     modifier beforeInitialized {
554         require(!initialized);
555         _;
556     }
557 
558     function endInitialization() internal beforeInitialized returns (bool) {
559         initialized = true;
560         return true;
561     }
562 
563     function getInitialized() public view returns (bool) {
564         return initialized;
565     }
566 }
567 
568 library SafeMathUint256 {
569     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
570         uint256 c = a * b;
571         require(a == 0 || c / a == b);
572         return c;
573     }
574 
575     function div(uint256 a, uint256 b) internal pure returns (uint256) {
576         // assert(b > 0); // Solidity automatically throws when dividing by 0
577         uint256 c = a / b;
578         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
579         return c;
580     }
581 
582     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
583         require(b <= a);
584         return a - b;
585     }
586 
587     function add(uint256 a, uint256 b) internal pure returns (uint256) {
588         uint256 c = a + b;
589         require(c >= a);
590         return c;
591     }
592 
593     function min(uint256 a, uint256 b) internal pure returns (uint256) {
594         if (a <= b) {
595             return a;
596         } else {
597             return b;
598         }
599     }
600 
601     function max(uint256 a, uint256 b) internal pure returns (uint256) {
602         if (a >= b) {
603             return a;
604         } else {
605             return b;
606         }
607     }
608 
609     function getUint256Min() internal pure returns (uint256) {
610         return 0;
611     }
612 
613     function getUint256Max() internal pure returns (uint256) {
614         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
615     }
616 
617     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
618         return a % b == 0;
619     }
620 
621     // Float [fixed point] Operations
622     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
623         return div(mul(a, b), base);
624     }
625 
626     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
627         return div(mul(a, base), b);
628     }
629 }
630 
631 contract ERC20Basic {
632     event Transfer(address indexed from, address indexed to, uint256 value);
633 
634     function balanceOf(address _who) public view returns (uint256);
635     function transfer(address _to, uint256 _value) public returns (bool);
636     function totalSupply() public view returns (uint256);
637 }
638 
639 contract ERC20 is ERC20Basic {
640     event Approval(address indexed owner, address indexed spender, uint256 value);
641 
642     function allowance(address _owner, address _spender) public view returns (uint256);
643     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
644     function approve(address _spender, uint256 _value) public returns (bool);
645 }
646 
647 contract IFeeToken is ERC20, Initializable {
648     function initialize(IFeeWindow _feeWindow) public returns (bool);
649     function getFeeWindow() public view returns (IFeeWindow);
650     function feeWindowBurn(address _target, uint256 _amount) public returns (bool);
651     function mintForReportingParticipant(address _target, uint256 _amount) public returns (bool);
652 }
653 
654 contract IFeeWindow is ITyped, ERC20 {
655     function initialize(IUniverse _universe, uint256 _feeWindowId) public returns (bool);
656     function getUniverse() public view returns (IUniverse);
657     function getReputationToken() public view returns (IReputationToken);
658     function getStartTime() public view returns (uint256);
659     function getEndTime() public view returns (uint256);
660     function getNumMarkets() public view returns (uint256);
661     function getNumInvalidMarkets() public view returns (uint256);
662     function getNumIncorrectDesignatedReportMarkets() public view returns (uint256);
663     function getNumDesignatedReportNoShows() public view returns (uint256);
664     function getFeeToken() public view returns (IFeeToken);
665     function isActive() public view returns (bool);
666     function isOver() public view returns (bool);
667     function onMarketFinalized() public returns (bool);
668     function buy(uint256 _attotokens) public returns (bool);
669     function redeem(address _sender) public returns (bool);
670     function redeemForReportingParticipant() public returns (bool);
671     function mintFeeTokens(uint256 _amount) public returns (bool);
672     function trustedUniverseBuy(address _buyer, uint256 _attotokens) public returns (bool);
673 }
674 
675 contract IMailbox {
676     function initialize(address _owner, IMarket _market) public returns (bool);
677     function depositEther() public payable returns (bool);
678 }
679 
680 contract IMarket is ITyped, IOwnable {
681     enum MarketType {
682         YES_NO,
683         CATEGORICAL,
684         SCALAR
685     }
686 
687     function initialize(IUniverse _universe, uint256 _endTime, uint256 _feePerEthInAttoeth, ICash _cash, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public payable returns (bool _success);
688     function derivePayoutDistributionHash(uint256[] _payoutNumerators, bool _invalid) public view returns (bytes32);
689     function getUniverse() public view returns (IUniverse);
690     function getFeeWindow() public view returns (IFeeWindow);
691     function getNumberOfOutcomes() public view returns (uint256);
692     function getNumTicks() public view returns (uint256);
693     function getDenominationToken() public view returns (ICash);
694     function getShareToken(uint256 _outcome)  public view returns (IShareToken);
695     function getMarketCreatorSettlementFeeDivisor() public view returns (uint256);
696     function getForkingMarket() public view returns (IMarket _market);
697     function getEndTime() public view returns (uint256);
698     function getMarketCreatorMailbox() public view returns (IMailbox);
699     function getWinningPayoutDistributionHash() public view returns (bytes32);
700     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
701     function getReputationToken() public view returns (IReputationToken);
702     function getFinalizationTime() public view returns (uint256);
703     function getInitialReporterAddress() public view returns (address);
704     function deriveMarketCreatorFeeAmount(uint256 _amount) public view returns (uint256);
705     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
706     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
707     function isInvalid() public view returns (bool);
708     function finalize() public returns (bool);
709     function designatedReporterWasCorrect() public view returns (bool);
710     function designatedReporterShowed() public view returns (bool);
711     function isFinalized() public view returns (bool);
712     function finalizeFork() public returns (bool);
713     function assertBalances() public view returns (bool);
714 }
715 
716 contract IReportingParticipant {
717     function getStake() public view returns (uint256);
718     function getPayoutDistributionHash() public view returns (bytes32);
719     function liquidateLosing() public returns (bool);
720     function redeem(address _redeemer) public returns (bool);
721     function isInvalid() public view returns (bool);
722     function isDisavowed() public view returns (bool);
723     function migrate() public returns (bool);
724     function getPayoutNumerator(uint256 _outcome) public view returns (uint256);
725     function getMarket() public view returns (IMarket);
726     function getSize() public view returns (uint256);
727 }
728 
729 contract IDisputeCrowdsourcer is IReportingParticipant, ERC20 {
730     function initialize(IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
731     function contribute(address _participant, uint256 _amount) public returns (uint256);
732 }
733 
734 contract IInitialReporter is IReportingParticipant {
735     function initialize(IMarket _market, address _designatedReporter) public returns (bool);
736     function report(address _reporter, bytes32 _payoutDistributionHash, uint256[] _payoutNumerators, bool _invalid) public returns (bool);
737     function resetReportTimestamp() public returns (bool);
738     function designatedReporterShowed() public view returns (bool);
739     function designatedReporterWasCorrect() public view returns (bool);
740     function getDesignatedReporter() public view returns (address);
741     function getReportTimestamp() public view returns (uint256);
742     function migrateREP() public returns (bool);
743 }
744 
745 contract IReputationToken is ITyped, ERC20 {
746     function initialize(IUniverse _universe) public returns (bool);
747     function migrateOut(IReputationToken _destination, uint256 _attotokens) public returns (bool);
748     function migrateIn(address _reporter, uint256 _attotokens) public returns (bool);
749     function trustedReportingParticipantTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
750     function trustedMarketTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
751     function trustedFeeWindowTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
752     function trustedUniverseTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
753     function getUniverse() public view returns (IUniverse);
754     function getTotalMigrated() public view returns (uint256);
755     function getTotalTheoreticalSupply() public view returns (uint256);
756     function mintForReportingParticipant(uint256 _amountMigrated) public returns (bool);
757 }
758 
759 contract IUniverse is ITyped {
760     function initialize(IUniverse _parentUniverse, bytes32 _parentPayoutDistributionHash) external returns (bool);
761     function fork() public returns (bool);
762     function getParentUniverse() public view returns (IUniverse);
763     function createChildUniverse(uint256[] _parentPayoutNumerators, bool _invalid) public returns (IUniverse);
764     function getChildUniverse(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);
765     function getReputationToken() public view returns (IReputationToken);
766     function getForkingMarket() public view returns (IMarket);
767     function getForkEndTime() public view returns (uint256);
768     function getForkReputationGoal() public view returns (uint256);
769     function getParentPayoutDistributionHash() public view returns (bytes32);
770     function getDisputeRoundDurationInSeconds() public view returns (uint256);
771     function getOrCreateFeeWindowByTimestamp(uint256 _timestamp) public returns (IFeeWindow);
772     function getOrCreateCurrentFeeWindow() public returns (IFeeWindow);
773     function getOrCreateNextFeeWindow() public returns (IFeeWindow);
774     function getOpenInterestInAttoEth() public view returns (uint256);
775     function getRepMarketCapInAttoeth() public view returns (uint256);
776     function getTargetRepMarketCapInAttoeth() public view returns (uint256);
777     function getOrCacheValidityBond() public returns (uint256);
778     function getOrCacheDesignatedReportStake() public returns (uint256);
779     function getOrCacheDesignatedReportNoShowBond() public returns (uint256);
780     function getOrCacheReportingFeeDivisor() public returns (uint256);
781     function getDisputeThresholdForFork() public view returns (uint256);
782     function getInitialReportMinValue() public view returns (uint256);
783     function calculateFloatingValue(uint256 _badMarkets, uint256 _totalMarkets, uint256 _targetDivisor, uint256 _previousValue, uint256 _defaultValue, uint256 _floor) public pure returns (uint256 _newValue);
784     function getOrCacheMarketCreationCost() public returns (uint256);
785     function getCurrentFeeWindow() public view returns (IFeeWindow);
786     function getOrCreateFeeWindowBefore(IFeeWindow _feeWindow) public returns (IFeeWindow);
787     function isParentOf(IUniverse _shadyChild) public view returns (bool);
788     function updateTentativeWinningChildUniverse(bytes32 _parentPayoutDistributionHash) public returns (bool);
789     function isContainerForFeeWindow(IFeeWindow _shadyTarget) public view returns (bool);
790     function isContainerForMarket(IMarket _shadyTarget) public view returns (bool);
791     function isContainerForReportingParticipant(IReportingParticipant _reportingParticipant) public view returns (bool);
792     function isContainerForShareToken(IShareToken _shadyTarget) public view returns (bool);
793     function isContainerForFeeToken(IFeeToken _shadyTarget) public view returns (bool);
794     function addMarketTo() public returns (bool);
795     function removeMarketFrom() public returns (bool);
796     function decrementOpenInterest(uint256 _amount) public returns (bool);
797     function decrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
798     function incrementOpenInterest(uint256 _amount) public returns (bool);
799     function incrementOpenInterestFromMarket(uint256 _amount) public returns (bool);
800     function getWinningChildUniverse() public view returns (IUniverse);
801     function isForking() public view returns (bool);
802 }
803 
804 contract ICash is ERC20 {
805     function depositEther() external payable returns(bool);
806     function depositEtherFor(address _to) external payable returns(bool);
807     function withdrawEther(uint256 _amount) external returns(bool);
808     function withdrawEtherTo(address _to, uint256 _amount) external returns(bool);
809     function withdrawEtherToIfPossible(address _to, uint256 _amount) external returns (bool);
810 }
811 
812 contract IOrders {
813     function saveOrder(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed, bytes32 _betterOrderId, bytes32 _worseOrderId, bytes32 _tradeGroupId) public returns (bytes32 _orderId);
814     function removeOrder(bytes32 _orderId) public returns (bool);
815     function getMarket(bytes32 _orderId) public view returns (IMarket);
816     function getOrderType(bytes32 _orderId) public view returns (Order.Types);
817     function getOutcome(bytes32 _orderId) public view returns (uint256);
818     function getAmount(bytes32 _orderId) public view returns (uint256);
819     function getPrice(bytes32 _orderId) public view returns (uint256);
820     function getOrderCreator(bytes32 _orderId) public view returns (address);
821     function getOrderSharesEscrowed(bytes32 _orderId) public view returns (uint256);
822     function getOrderMoneyEscrowed(bytes32 _orderId) public view returns (uint256);
823     function getBetterOrderId(bytes32 _orderId) public view returns (bytes32);
824     function getWorseOrderId(bytes32 _orderId) public view returns (bytes32);
825     function getBestOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
826     function getWorstOrderId(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);
827     function getLastOutcomePrice(IMarket _market, uint256 _outcome) public view returns (uint256);
828     function getOrderId(Order.Types _type, IMarket _market, uint256 _fxpAmount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);
829     function getTotalEscrowed(IMarket _market) public view returns (uint256);
830     function isBetterPrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
831     function isWorsePrice(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);
832     function assertIsNotBetterPrice(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);
833     function assertIsNotWorsePrice(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);
834     function recordFillOrder(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled) public returns (bool);
835     function setPrice(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);
836     function incrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
837     function decrementTotalEscrowed(IMarket _market, uint256 _amount) external returns (bool);
838 }
839 
840 contract IShareToken is ITyped, ERC20 {
841     function initialize(IMarket _market, uint256 _outcome) external returns (bool);
842     function createShares(address _owner, uint256 _amount) external returns (bool);
843     function destroyShares(address, uint256 balance) external returns (bool);
844     function getMarket() external view returns (IMarket);
845     function getOutcome() external view returns (uint256);
846     function trustedOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
847     function trustedFillOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
848     function trustedCancelOrderTransfer(address _source, address _destination, uint256 _attotokens) public returns (bool);
849 }
850 
851 library Order {
852     using SafeMathUint256 for uint256;
853 
854     enum Types {
855         Bid, Ask
856     }
857 
858     enum TradeDirections {
859         Long, Short
860     }
861 
862     struct Data {
863         // Contracts
864         IOrders orders;
865         IMarket market;
866         IAugur augur;
867 
868         // Order
869         bytes32 id;
870         address creator;
871         uint256 outcome;
872         Order.Types orderType;
873         uint256 amount;
874         uint256 price;
875         uint256 sharesEscrowed;
876         uint256 moneyEscrowed;
877         bytes32 betterOrderId;
878         bytes32 worseOrderId;
879     }
880 
881     //
882     // Constructor
883     //
884 
885     // No validation is needed here as it is simply a librarty function for organizing data
886     function create(IController _controller, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data) {
887         require(_outcome < _market.getNumberOfOutcomes());
888         require(_price < _market.getNumTicks());
889 
890         IOrders _orders = IOrders(_controller.lookup("Orders"));
891         IAugur _augur = _controller.getAugur();
892 
893         return Data({
894             orders: _orders,
895             market: _market,
896             augur: _augur,
897             id: 0,
898             creator: _creator,
899             outcome: _outcome,
900             orderType: _type,
901             amount: _attoshares,
902             price: _price,
903             sharesEscrowed: 0,
904             moneyEscrowed: 0,
905             betterOrderId: _betterOrderId,
906             worseOrderId: _worseOrderId
907         });
908     }
909 
910     //
911     // "public" functions
912     //
913 
914     function getOrderId(Order.Data _orderData) internal view returns (bytes32) {
915         if (_orderData.id == bytes32(0)) {
916             bytes32 _orderId = _orderData.orders.getOrderId(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
917             require(_orderData.orders.getAmount(_orderId) == 0);
918             _orderData.id = _orderId;
919         }
920         return _orderData.id;
921     }
922 
923     function getOrderTradingTypeFromMakerDirection(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {
924         return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
925     }
926 
927     function getOrderTradingTypeFromFillerDirection(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {
928         return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
929     }
930 
931     function escrowFunds(Order.Data _orderData) internal returns (bool) {
932         if (_orderData.orderType == Order.Types.Ask) {
933             return escrowFundsForAsk(_orderData);
934         } else if (_orderData.orderType == Order.Types.Bid) {
935             return escrowFundsForBid(_orderData);
936         }
937     }
938 
939     function saveOrder(Order.Data _orderData, bytes32 _tradeGroupId) internal returns (bytes32) {
940         return _orderData.orders.saveOrder(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed, _orderData.betterOrderId, _orderData.worseOrderId, _tradeGroupId);
941     }
942 
943     //
944     // Private functions
945     //
946 
947     function escrowFundsForBid(Order.Data _orderData) private returns (bool) {
948         require(_orderData.moneyEscrowed == 0);
949         require(_orderData.sharesEscrowed == 0);
950         uint256 _attosharesToCover = _orderData.amount;
951         uint256 _numberOfOutcomes = _orderData.market.getNumberOfOutcomes();
952 
953         // Figure out how many almost-complete-sets (just missing `outcome` share) the creator has
954         uint256 _attosharesHeld = 2**254;
955         for (uint256 _i = 0; _i < _numberOfOutcomes; _i++) {
956             if (_i != _orderData.outcome) {
957                 uint256 _creatorShareTokenBalance = _orderData.market.getShareToken(_i).balanceOf(_orderData.creator);
958                 _attosharesHeld = SafeMathUint256.min(_creatorShareTokenBalance, _attosharesHeld);
959             }
960         }
961 
962         // Take shares into escrow if they have any almost-complete-sets
963         if (_attosharesHeld > 0) {
964             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
965             _attosharesToCover -= _orderData.sharesEscrowed;
966             for (_i = 0; _i < _numberOfOutcomes; _i++) {
967                 if (_i != _orderData.outcome) {
968                     _orderData.market.getShareToken(_i).trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
969                 }
970             }
971         }
972         // If not able to cover entire order with shares alone, then cover remaining with tokens
973         if (_attosharesToCover > 0) {
974             _orderData.moneyEscrowed = _attosharesToCover.mul(_orderData.price);
975             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
976         }
977 
978         return true;
979     }
980 
981     function escrowFundsForAsk(Order.Data _orderData) private returns (bool) {
982         require(_orderData.moneyEscrowed == 0);
983         require(_orderData.sharesEscrowed == 0);
984         IShareToken _shareToken = _orderData.market.getShareToken(_orderData.outcome);
985         uint256 _attosharesToCover = _orderData.amount;
986 
987         // Figure out how many shares of the outcome the creator has
988         uint256 _attosharesHeld = _shareToken.balanceOf(_orderData.creator);
989 
990         // Take shares in escrow if user has shares
991         if (_attosharesHeld > 0) {
992             _orderData.sharesEscrowed = SafeMathUint256.min(_attosharesHeld, _attosharesToCover);
993             _attosharesToCover -= _orderData.sharesEscrowed;
994             _shareToken.trustedOrderTransfer(_orderData.creator, _orderData.market, _orderData.sharesEscrowed);
995         }
996 
997         // If not able to cover entire order with shares alone, then cover remaining with tokens
998         if (_attosharesToCover > 0) {
999             _orderData.moneyEscrowed = _orderData.market.getNumTicks().sub(_orderData.price).mul(_attosharesToCover);
1000             require(_orderData.augur.trustedTransfer(_orderData.market.getDenominationToken(), _orderData.creator, _orderData.market, _orderData.moneyEscrowed));
1001         }
1002 
1003         return true;
1004     }
1005 }