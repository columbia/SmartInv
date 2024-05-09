1 pragma solidity ^0.4.13;
2 
3 interface FundInterface {
4 
5     // EVENTS
6 
7     event PortfolioContent(uint holdings, uint price, uint decimals);
8     event RequestUpdated(uint id);
9     event Invested(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
10     event Redeemed(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
11     event SpendingApproved(address onConsigned, address ofAsset, uint amount);
12     event FeesConverted(uint atTimestamp, uint shareQuantityConverted, uint unclaimed);
13     event CalculationUpdate(uint atTimestamp, uint managementFee, uint performanceFee, uint nav, uint sharePrice, uint totalSupply);
14     event OrderUpdated(uint id);
15     event LogError(uint ERROR_CODE);
16     event ErrorMessage(string errorMessage);
17 
18     // EXTERNAL METHODS
19     // Compliance by Investor
20     function requestInvestment(uint giveQuantity, uint shareQuantity, bool isNativeAsset) external;
21     function requestRedemption(uint shareQuantity, uint receiveQuantity, bool isNativeAsset) external;
22     function executeRequest(uint requestId) external;
23     function cancelRequest(uint requestId) external;
24     function redeemAllOwnedAssets(uint shareQuantity) external returns (bool);
25     // Administration by Manager
26     function enableInvestment() external;
27     function disableInvestment() external;
28     function enableRedemption() external;
29     function disableRedemption() external;
30     function shutDown() external;
31     // Managing by Manager
32     function makeOrder(uint exchangeId, address sellAsset, address buyAsset, uint sellQuantity, uint buyQuantity) external;
33     function takeOrder(uint exchangeId, uint id, uint quantity) external;
34     function cancelOrder(uint exchangeId, uint id) external;
35 
36     // PUBLIC METHODS
37     function emergencyRedeem(uint shareQuantity, address[] requestedAssets) public returns (bool success);
38     function calcSharePriceAndAllocateFees() public returns (uint);
39 
40 
41     // PUBLIC VIEW METHODS
42     // Get general information
43     function getModules() view returns (address, address, address);
44     function getLastOrderId() view returns (uint);
45     function getLastRequestId() view returns (uint);
46     function getNameHash() view returns (bytes32);
47     function getManager() view returns (address);
48 
49     // Get accounting information
50     function performCalculations() view returns (uint, uint, uint, uint, uint, uint, uint);
51     function calcSharePrice() view returns (uint);
52 }
53 
54 interface AssetInterface {
55     /*
56      * Implements ERC 20 standard.
57      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
58      * https://github.com/ethereum/EIPs/issues/20
59      *
60      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
61      *  https://github.com/ethereum/EIPs/issues/223
62      */
63 
64     // Events
65     event Transfer(address indexed _from, address indexed _to, uint _value);
66     event Approval(address indexed _owner, address indexed _spender, uint _value);
67 
68     // There is no ERC223 compatible Transfer event, with `_data` included.
69 
70     //ERC 223
71     // PUBLIC METHODS
72     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
73 
74     // ERC 20
75     // PUBLIC METHODS
76     function transfer(address _to, uint _value) public returns (bool success);
77     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
78     function approve(address _spender, uint _value) public returns (bool success);
79     // PUBLIC VIEW METHODS
80     function balanceOf(address _owner) view public returns (uint balance);
81     function allowance(address _owner, address _spender) public view returns (uint remaining);
82 }
83 
84 interface ERC223Interface {
85     function balanceOf(address who) constant returns (uint);
86     function transfer(address to, uint value) returns (bool);
87     function transfer(address to, uint value, bytes data) returns (bool);
88     event Transfer(address indexed from, address indexed to, uint value, bytes data);
89 }
90 
91 interface ERC223ReceivingContract {
92 
93     /// @dev Function that is called when a user or another contract wants to transfer funds.
94     /// @param _from Transaction initiator, analogue of msg.sender
95     /// @param _value Number of tokens to transfer.
96     /// @param _data Data containing a function signature and/or parameters
97     function tokenFallback(address _from, uint256 _value, bytes _data) public;
98 }
99 
100 interface NativeAssetInterface {
101 
102     // PUBLIC METHODS
103     function deposit() public payable;
104     function withdraw(uint wad) public;
105 }
106 
107 interface SharesInterface {
108 
109     event Created(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
110     event Annihilated(address indexed ofParticipant, uint atTimestamp, uint shareQuantity);
111 
112     // VIEW METHODS
113 
114     function getName() view returns (string);
115     function getSymbol() view returns (string);
116     function getDecimals() view returns (uint);
117     function getCreationTime() view returns (uint);
118     function toSmallestShareUnit(uint quantity) view returns (uint);
119     function toWholeShareUnit(uint quantity) view returns (uint);
120 
121 }
122 
123 interface ComplianceInterface {
124 
125     // PUBLIC VIEW METHODS
126 
127     /// @notice Checks whether investment is permitted for a participant
128     /// @param ofParticipant Address requesting to invest in a Melon fund
129     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
130     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
131     /// @return Whether identity is eligible to invest in a Melon fund.
132     function isInvestmentPermitted(
133         address ofParticipant,
134         uint256 giveQuantity,
135         uint256 shareQuantity
136     ) view returns (bool);
137 
138     /// @notice Checks whether redemption is permitted for a participant
139     /// @param ofParticipant Address requesting to redeem from a Melon fund
140     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
141     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
142     /// @return Whether identity is eligible to redeem from a Melon fund.
143     function isRedemptionPermitted(
144         address ofParticipant,
145         uint256 shareQuantity,
146         uint256 receiveQuantity
147     ) view returns (bool);
148 }
149 
150 contract DBC {
151 
152     // MODIFIERS
153 
154     modifier pre_cond(bool condition) {
155         require(condition);
156         _;
157     }
158 
159     modifier post_cond(bool condition) {
160         _;
161         assert(condition);
162     }
163 
164     modifier invariant(bool condition) {
165         require(condition);
166         _;
167         assert(condition);
168     }
169 }
170 
171 contract Owned is DBC {
172 
173     // FIELDS
174 
175     address public owner;
176 
177     // NON-CONSTANT METHODS
178 
179     function Owned() { owner = msg.sender; }
180 
181     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
182 
183     // PRE, POST, INVARIANT CONDITIONS
184 
185     function isOwner() internal returns (bool) { return msg.sender == owner; }
186 
187 }
188 
189 interface ExchangeInterface {
190 
191     // EVENTS
192 
193     event OrderUpdated(uint id);
194 
195     // METHODS
196     // EXTERNAL METHODS
197 
198     function makeOrder(
199         address onExchange,
200         address sellAsset,
201         address buyAsset,
202         uint sellQuantity,
203         uint buyQuantity
204     ) external returns (uint);
205     function takeOrder(address onExchange, uint id, uint quantity) external returns (bool);
206     function cancelOrder(address onExchange, uint id) external returns (bool);
207 
208 
209     // PUBLIC METHODS
210     // PUBLIC VIEW METHODS
211 
212     function isApproveOnly() view returns (bool);
213     function getLastOrderId(address onExchange) view returns (uint);
214     function isActive(address onExchange, uint id) view returns (bool);
215     function getOwner(address onExchange, uint id) view returns (address);
216     function getOrder(address onExchange, uint id) view returns (address, address, uint, uint);
217     function getTimestamp(address onExchange, uint id) view returns (uint);
218 
219 }
220 
221 interface PriceFeedInterface {
222 
223     // EVENTS
224 
225     event PriceUpdated(uint timestamp);
226 
227     // PUBLIC METHODS
228 
229     function update(address[] ofAssets, uint[] newPrices);
230 
231     // PUBLIC VIEW METHODS
232 
233     // Get asset specific information
234     function getName(address ofAsset) view returns (string);
235     function getSymbol(address ofAsset) view returns (string);
236     function getDecimals(address ofAsset) view returns (uint);
237     // Get price feed operation specific information
238     function getQuoteAsset() view returns (address);
239     function getInterval() view returns (uint);
240     function getValidity() view returns (uint);
241     function getLastUpdateId() view returns (uint);
242     // Get asset specific information as updated in price feed
243     function hasRecentPrice(address ofAsset) view returns (bool isRecent);
244     function hasRecentPrices(address[] ofAssets) view returns (bool areRecent);
245     function getPrice(address ofAsset) view returns (bool isRecent, uint price, uint decimal);
246     function getPrices(address[] ofAssets) view returns (bool areRecent, uint[] prices, uint[] decimals);
247     function getInvertedPrice(address ofAsset) view returns (bool isRecent, uint invertedPrice, uint decimal);
248     function getReferencePrice(address ofBase, address ofQuote) view returns (bool isRecent, uint referencePrice, uint decimal);
249     function getOrderPrice(
250         address sellAsset,
251         address buyAsset,
252         uint sellQuantity,
253         uint buyQuantity
254     ) view returns (uint orderPrice);
255     function existsPriceOnAssetPair(address sellAsset, address buyAsset) view returns (bool isExistent);
256 }
257 
258 interface RiskMgmtInterface {
259 
260     // METHODS
261     // PUBLIC VIEW METHODS
262 
263     /// @notice Checks if the makeOrder price is reasonable and not manipulative
264     /// @param orderPrice Price of Order
265     /// @param referencePrice Reference price obtained through PriceFeed contract
266     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
267     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
268     /// @param sellQuantity Quantity of sellAsset to be sold
269     /// @param buyQuantity Quantity of buyAsset to be bought
270     /// @return If makeOrder is permitted
271     function isMakePermitted(
272         uint orderPrice,
273         uint referencePrice,
274         address sellAsset,
275         address buyAsset,
276         uint sellQuantity,
277         uint buyQuantity
278     ) view returns (bool);
279 
280     /// @notice Checks if the takeOrder price is reasonable and not manipulative
281     /// @param orderPrice Price of Order
282     /// @param referencePrice Reference price obtained through PriceFeed contract
283     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
284     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
285     /// @param sellQuantity Quantity of sellAsset to be sold
286     /// @param buyQuantity Quantity of buyAsset to be bought
287     /// @return If takeOrder is permitted
288     function isTakePermitted(
289         uint orderPrice,
290         uint referencePrice,
291         address sellAsset,
292         address buyAsset,
293         uint sellQuantity,
294         uint buyQuantity
295     ) view returns (bool);
296 }
297 
298 interface VersionInterface {
299 
300     // EVENTS
301 
302     event FundUpdated(uint id);
303 
304     // PUBLIC METHODS
305 
306     function shutDown() external;
307 
308     function setupFund(
309         string ofFundName,
310         address ofQuoteAsset,
311         uint ofManagementFee,
312         uint ofPerformanceFee,
313         address ofCompliance,
314         address ofRiskMgmt,
315         address ofPriceFeed,
316         address[] ofExchanges,
317         address[] ofExchangeAdapters,
318         uint8 v,
319         bytes32 r,
320         bytes32 s
321     );
322     function shutDownFund(address ofFund);
323 
324     // PUBLIC VIEW METHODS
325 
326     function getNativeAsset() view returns (address);
327     function getFundById(uint withId) view returns (address);
328     function getLastFundId() view returns (uint);
329     function getFundByManager(address ofManager) view returns (address);
330     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed);
331 
332 }
333 
334 contract Version is DBC, Owned, VersionInterface {
335     // FIELDS
336 
337     // Constant fields
338     bytes32 public constant TERMS_AND_CONDITIONS = 0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad; // Hashed terms and conditions as displayed on IPFS.
339     // Constructor fields
340     string public VERSION_NUMBER; // SemVer of Melon protocol version
341     address public NATIVE_ASSET; // Address of wrapped native asset contract
342     address public GOVERNANCE; // Address of Melon protocol governance contract
343     // Methods fields
344     bool public isShutDown; // Governance feature, if yes than setupFund gets blocked and shutDownFund gets opened
345     address[] public listOfFunds; // A complete list of fund addresses created using this version
346     mapping (address => address) public managerToFunds; // Links manager address to fund address created using this version
347 
348     // EVENTS
349 
350     event FundUpdated(address ofFund);
351 
352     // METHODS
353 
354     // CONSTRUCTOR
355 
356     /// @param versionNumber SemVer of Melon protocol version
357     /// @param ofGovernance Address of Melon governance contract
358     /// @param ofNativeAsset Address of wrapped native asset contract
359     function Version(
360         string versionNumber,
361         address ofGovernance,
362         address ofNativeAsset
363     ) {
364         VERSION_NUMBER = versionNumber;
365         GOVERNANCE = ofGovernance;
366         NATIVE_ASSET = ofNativeAsset;
367     }
368 
369     // EXTERNAL METHODS
370 
371     function shutDown() external pre_cond(msg.sender == GOVERNANCE) { isShutDown = true; }
372 
373     // PUBLIC METHODS
374 
375     /// @param ofFundName human-readable descriptive name (not necessarily unique)
376     /// @param ofQuoteAsset Asset against which performance fee is measured against
377     /// @param ofManagementFee A time based fee, given in a number which is divided by 10 ** 15
378     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 10 ** 15
379     /// @param ofCompliance Address of participation module
380     /// @param ofRiskMgmt Address of risk management module
381     /// @param ofPriceFeed Address of price feed module
382     /// @param ofExchanges Addresses of exchange on which this fund can trade
383     /// @param ofExchangeAdapters Addresses of exchange adapters
384     /// @param v ellipitc curve parameter v
385     /// @param r ellipitc curve parameter r
386     /// @param s ellipitc curve parameter s
387     function setupFund(
388         string ofFundName,
389         address ofQuoteAsset,
390         uint ofManagementFee,
391         uint ofPerformanceFee,
392         address ofCompliance,
393         address ofRiskMgmt,
394         address ofPriceFeed,
395         address[] ofExchanges,
396         address[] ofExchangeAdapters,
397         uint8 v,
398         bytes32 r,
399         bytes32 s
400     ) {
401         require(!isShutDown);
402         require(termsAndConditionsAreSigned(v, r, s));
403         // Either novel fund name or previous owner of fund name
404         require(managerToFunds[msg.sender] == 0); // Add limitation for simpler migration process of shutting down and setting up fund
405         address ofFund = new Fund(
406             msg.sender,
407             ofFundName,
408             ofQuoteAsset,
409             ofManagementFee,
410             ofPerformanceFee,
411             NATIVE_ASSET,
412             ofCompliance,
413             ofRiskMgmt,
414             ofPriceFeed,
415             ofExchanges,
416             ofExchangeAdapters
417         );
418         listOfFunds.push(ofFund);
419         managerToFunds[msg.sender] = ofFund;
420         FundUpdated(ofFund);
421     }
422 
423     /// @dev Dereference Fund and trigger selfdestruct
424     /// @param ofFund Address of the fund to be shut down
425     function shutDownFund(address ofFund)
426         pre_cond(isShutDown || managerToFunds[msg.sender] == ofFund)
427     {
428         Fund fund = Fund(ofFund);
429         delete managerToFunds[msg.sender];
430         fund.shutDown();
431         FundUpdated(ofFund);
432     }
433 
434     // PUBLIC VIEW METHODS
435 
436     /// @dev Proof that terms and conditions have been read and understood
437     /// @param v ellipitc curve parameter v
438     /// @param r ellipitc curve parameter r
439     /// @param s ellipitc curve parameter s
440     /// @return signed Whether or not terms and conditions have been read and understood
441     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed) {
442         return ecrecover(
443             // Parity does prepend \x19Ethereum Signed Message:\n{len(message)} before signing.
444             //  Signature order has also been changed in 1.6.7 and upcoming 1.7.x,
445             //  it will return rsv (same as geth; where v is [27, 28]).
446             // Note that if you are using ecrecover, v will be either "00" or "01".
447             //  As a result, in order to use this value, you will have to parse it to an
448             //  integer and then add 27. This will result in either a 27 or a 28.
449             //  https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsign
450             keccak256("\x19Ethereum Signed Message:\n32", TERMS_AND_CONDITIONS),
451             v,
452             r,
453             s
454         ) == msg.sender; // Has sender signed TERMS_AND_CONDITIONS
455     }
456 
457     function getNativeAsset() view returns (address) { return NATIVE_ASSET; }
458     function getFundById(uint withId) view returns (address) { return listOfFunds[withId]; }
459     function getLastFundId() view returns (uint) { return listOfFunds.length - 1; }
460     function getFundByManager(address ofManager) view returns (address) { return managerToFunds[ofManager]; }
461 }
462 
463 contract DSMath {
464     function add(uint x, uint y) internal pure returns (uint z) {
465         require((z = x + y) >= x);
466     }
467     function sub(uint x, uint y) internal pure returns (uint z) {
468         require((z = x - y) <= x);
469     }
470     function mul(uint x, uint y) internal pure returns (uint z) {
471         require(y == 0 || (z = x * y) / y == x);
472     }
473 
474     function min(uint x, uint y) internal pure returns (uint z) {
475         return x <= y ? x : y;
476     }
477     function max(uint x, uint y) internal pure returns (uint z) {
478         return x >= y ? x : y;
479     }
480     function imin(int x, int y) internal pure returns (int z) {
481         return x <= y ? x : y;
482     }
483     function imax(int x, int y) internal pure returns (int z) {
484         return x >= y ? x : y;
485     }
486 
487     uint constant WAD = 10 ** 18;
488     uint constant RAY = 10 ** 27;
489 
490     function wmul(uint x, uint y) internal pure returns (uint z) {
491         z = add(mul(x, y), WAD / 2) / WAD;
492     }
493     function rmul(uint x, uint y) internal pure returns (uint z) {
494         z = add(mul(x, y), RAY / 2) / RAY;
495     }
496     function wdiv(uint x, uint y) internal pure returns (uint z) {
497         z = add(mul(x, WAD), y / 2) / y;
498     }
499     function rdiv(uint x, uint y) internal pure returns (uint z) {
500         z = add(mul(x, RAY), y / 2) / y;
501     }
502 
503     // This famous algorithm is called "exponentiation by squaring"
504     // and calculates x^n with x as fixed-point and n as regular unsigned.
505     //
506     // It's O(log n), instead of O(n) for naive repeated multiplication.
507     //
508     // These facts are why it works:
509     //
510     //  If n is even, then x^n = (x^2)^(n/2).
511     //  If n is odd,  then x^n = x * x^(n-1),
512     //   and applying the equation for even x gives
513     //    x^n = x * (x^2)^((n-1) / 2).
514     //
515     //  Also, EVM division is flooring and
516     //    floor[(n-1) / 2] = floor[n / 2].
517     //
518     function rpow(uint x, uint n) internal pure returns (uint z) {
519         z = n % 2 != 0 ? x : RAY;
520 
521         for (n /= 2; n != 0; n /= 2) {
522             x = rmul(x, x);
523 
524             if (n % 2 != 0) {
525                 z = rmul(z, x);
526             }
527         }
528     }
529 }
530 
531 contract Asset is DSMath, AssetInterface, ERC223Interface {
532 
533     // DATA STRUCTURES
534 
535     mapping (address => uint) balances;
536     mapping (address => mapping (address => uint)) allowed;
537     uint public totalSupply;
538 
539     // PUBLIC METHODS
540 
541     /**
542      * @notice Send `_value` tokens to `_to` from `msg.sender`
543      * @dev Transfers sender's tokens to a given address
544      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
545      * @param _to Address of token receiver
546      * @param _value Number of tokens to transfer
547      * @return Returns success of function call
548      */
549     function transfer(address _to, uint _value)
550         public
551         returns (bool success)
552     {
553         uint codeLength;
554         bytes memory empty;
555 
556         assembly {
557             // Retrieve the size of the code on target address, this needs assembly.
558             codeLength := extcodesize(_to)
559         }
560  
561         require(balances[msg.sender] >= _value); // sanity checks
562         require(balances[_to] + _value >= balances[_to]);
563 
564         balances[msg.sender] = sub(balances[msg.sender], _value);
565         balances[_to] = add(balances[_to], _value);
566         // if (codeLength > 0) {
567         //     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
568         //     receiver.tokenFallback(msg.sender, _value, empty);
569         // }
570         Transfer(msg.sender, _to, _value, empty);
571         return true;
572     }
573 
574     /**
575      * @notice Send `_value` tokens to `_to` from `msg.sender` and trigger tokenFallback if sender is a contract
576      * @dev Function that is called when a user or contract wants to transfer funds
577      * @param _to Address of token receiver
578      * @param _value Number of tokens to transfer
579      * @param _data Data to be sent to tokenFallback
580      * @return Returns success of function call
581      */
582     function transfer(address _to, uint _value, bytes _data)
583         public
584         returns (bool success)
585     {
586         uint codeLength;
587 
588         assembly {
589             // Retrieve the size of the code on target address, this needs assembly.
590             codeLength := extcodesize(_to)
591         }
592 
593         require(balances[msg.sender] >= _value); // sanity checks
594         require(balances[_to] + _value >= balances[_to]);
595 
596         balances[msg.sender] = sub(balances[msg.sender], _value);
597         balances[_to] = add(balances[_to], _value);
598         // if (codeLength > 0) {
599         //     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
600         //     receiver.tokenFallback(msg.sender, _value, _data);
601         // }
602         Transfer(msg.sender, _to, _value);
603         return true;
604     }
605 
606     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
607     /// @notice Restriction: An account can only use this function to send to itself
608     /// @dev Allows for an approved third party to transfer tokens from one
609     /// address to another. Returns success.
610     /// @param _from Address from where tokens are withdrawn.
611     /// @param _to Address to where tokens are sent.
612     /// @param _value Number of tokens to transfer.
613     /// @return Returns success of function call.
614     function transferFrom(address _from, address _to, uint _value)
615         public
616         returns (bool)
617     {
618         require(_from != 0x0);
619         require(_to != 0x0);
620         require(_to != address(this));
621         require(balances[_from] >= _value);
622         require(allowed[_from][msg.sender] >= _value);
623         require(balances[_to] + _value >= balances[_to]);
624         // require(_to == msg.sender); // can only use transferFrom to send to self
625 
626         balances[_to] += _value;
627         balances[_from] -= _value;
628         allowed[_from][msg.sender] -= _value;
629 
630         Transfer(_from, _to, _value);
631         return true;
632     }
633 
634     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
635     /// @dev Sets approved amount of tokens for spender. Returns success.
636     /// @param _spender Address of allowed account.
637     /// @param _value Number of approved tokens.
638     /// @return Returns success of function call.
639     function approve(address _spender, uint _value) public returns (bool) {
640         require(_spender != 0x0);
641 
642         // To change the approve amount you first have to reduce the addresses`
643         // allowance to zero by calling `approve(_spender, 0)` if it is not
644         // already 0 to mitigate the race condition described here:
645         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
646         // require(_value == 0 || allowed[msg.sender][_spender] == 0);
647 
648         allowed[msg.sender][_spender] = _value;
649         Approval(msg.sender, _spender, _value);
650         return true;
651     }
652 
653     // PUBLIC VIEW METHODS
654 
655     /// @dev Returns number of allowed tokens that a spender can transfer on
656     /// behalf of a token owner.
657     /// @param _owner Address of token owner.
658     /// @param _spender Address of token spender.
659     /// @return Returns remaining allowance for spender.
660     function allowance(address _owner, address _spender)
661         constant
662         public
663         returns (uint)
664     {
665         return allowed[_owner][_spender];
666     }
667 
668     /// @dev Returns number of tokens owned by the given address.
669     /// @param _owner Address of token owner.
670     /// @return Returns balance of owner.
671     function balanceOf(address _owner) constant public returns (uint) {
672         return balances[_owner];
673     }
674 }
675 
676 contract Shares is Asset, SharesInterface {
677 
678     // FIELDS
679 
680     // Constructor fields
681     string public name;
682     string public symbol;
683     uint public decimal;
684     uint public creationTime;
685 
686     // METHODS
687 
688     // CONSTRUCTOR
689 
690     /// @param _name Name these shares
691     /// @param _symbol Symbol of shares
692     /// @param _decimal Amount of decimals sharePrice is denominated in, defined to be equal as deciamls in REFERENCE_ASSET contract
693     /// @param _creationTime Timestamp of share creation
694     function Shares(string _name, string _symbol, uint _decimal, uint _creationTime) {
695         name = _name;
696         symbol = _symbol;
697         decimal = _decimal;
698         creationTime = _creationTime;
699     }
700 
701     // PUBLIC METHODS
702     // PUBLIC VIEW METHODS
703 
704     function getName() view returns (string) { return name; }
705     function getSymbol() view returns (string) { return symbol; }
706     function getDecimals() view returns (uint) { return decimal; }
707     function getCreationTime() view returns (uint) { return creationTime; }
708     function toSmallestShareUnit(uint quantity) view returns (uint) { return mul(quantity, 10 ** getDecimals()); }
709     function toWholeShareUnit(uint quantity) view returns (uint) { return quantity / (10 ** getDecimals()); }
710     function transfer(address _to, uint256 _value) public returns (bool) { require(_to == address(this)); }
711     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) { require(_to == address(this)); }
712     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) { require(_to == address(this)); }
713 
714     // INTERNAL METHODS
715 
716     /// @param recipient Address the new shares should be sent to
717     /// @param shareQuantity Number of shares to be created
718     function createShares(address recipient, uint shareQuantity) internal {
719         totalSupply = add(totalSupply, shareQuantity);
720         balances[recipient] = add(balances[recipient], shareQuantity);
721         Created(msg.sender, now, shareQuantity);
722     }
723 
724     /// @param recipient Address the new shares should be taken from when destroyed
725     /// @param shareQuantity Number of shares to be annihilated
726     function annihilateShares(address recipient, uint shareQuantity) internal {
727         totalSupply = sub(totalSupply, shareQuantity);
728         balances[recipient] = sub(balances[recipient], shareQuantity);
729         Annihilated(msg.sender, now, shareQuantity);
730     }
731 }
732 
733 contract RestrictedShares is Shares {
734 
735     // CONSTRUCTOR
736 
737     /// @param _name Name these shares
738     /// @param _symbol Symbol of shares
739     /// @param _decimal Amount of decimals sharePrice is denominated in, defined to be equal as deciamls in REFERENCE_ASSET contract
740     /// @param _creationTime Timestamp of share creation
741     function RestrictedShares(
742         string _name,
743         string _symbol,
744         uint _decimal,
745         uint _creationTime
746     ) Shares(_name, _symbol, _decimal, _creationTime) {}
747 
748     // PUBLIC METHODS
749 
750     /**
751      * @notice Send `_value` tokens to `_to` from `msg.sender`
752      * @dev Transfers sender's tokens to a given address
753      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
754      * @param _to Address of token receiver
755      * @param _value Number of tokens to transfer
756      * @return Returns success of function call
757      */
758     function transfer(address _to, uint _value)
759         public
760         returns (bool success)
761     {
762         require(msg.sender == address(this) || _to == address(this));
763         uint codeLength;
764         bytes memory empty;
765 
766         assembly {
767             // Retrieve the size of the code on target address, this needs assembly.
768             codeLength := extcodesize(_to)
769         }
770 
771         require(balances[msg.sender] >= _value); // sanity checks
772         require(balances[_to] + _value >= balances[_to]);
773 
774         balances[msg.sender] = sub(balances[msg.sender], _value);
775         balances[_to] = add(balances[_to], _value);
776         if (codeLength > 0) {
777             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
778             receiver.tokenFallback(msg.sender, _value, empty);
779         }
780         Transfer(msg.sender, _to, _value, empty);
781         return true;
782     }
783 
784     /**
785      * @notice Send `_value` tokens to `_to` from `msg.sender` and trigger tokenFallback if sender is a contract
786      * @dev Function that is called when a user or contract wants to transfer funds
787      * @param _to Address of token receiver
788      * @param _value Number of tokens to transfer
789      * @param _data Data to be sent to tokenFallback
790      * @return Returns success of function call
791      */
792     function transfer(address _to, uint _value, bytes _data)
793         public
794         returns (bool success)
795     {
796         require(msg.sender == address(this) || _to == address(this));
797         uint codeLength;
798 
799         assembly {
800             // Retrieve the size of the code on target address, this needs assembly.
801             codeLength := extcodesize(_to)
802         }
803 
804         require(balances[msg.sender] >= _value); // sanity checks
805         require(balances[_to] + _value >= balances[_to]);
806 
807         balances[msg.sender] = sub(balances[msg.sender], _value);
808         balances[_to] = add(balances[_to], _value);
809         if (codeLength > 0) {
810             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
811             receiver.tokenFallback(msg.sender, _value, _data);
812         }
813         Transfer(msg.sender, _to, _value);
814         return true;
815     }
816 
817     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
818     /// @dev Sets approved amount of tokens for spender. Returns success.
819     /// @param _spender Address of allowed account.
820     /// @param _value Number of approved tokens.
821     /// @return Returns success of function call.
822     function approve(address _spender, uint _value) public returns (bool) {
823         require(msg.sender == address(this));
824         require(_spender != 0x0);
825 
826         // To change the approve amount you first have to reduce the addresses`
827         // allowance to zero by calling `approve(_spender, 0)` if it is not
828         // already 0 to mitigate the race condition described here:
829         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
830         require(_value == 0 || allowed[msg.sender][_spender] == 0);
831 
832         allowed[msg.sender][_spender] = _value;
833         Approval(msg.sender, _spender, _value);
834         return true;
835     }
836 
837 }
838 
839 contract Fund is DSMath, DBC, Owned, RestrictedShares, FundInterface, ERC223ReceivingContract {
840     // TYPES
841 
842     struct Modules { // Describes all modular parts, standardised through an interface
843         PriceFeedInterface pricefeed; // Provides all external data
844         ComplianceInterface compliance; // Boolean functions regarding invest/redeem
845         RiskMgmtInterface riskmgmt; // Boolean functions regarding make/take orders
846     }
847 
848     struct Calculations { // List of internal calculations
849         uint gav; // Gross asset value
850         uint managementFee; // Time based fee
851         uint performanceFee; // Performance based fee measured against QUOTE_ASSET
852         uint unclaimedFees; // Fees not yet allocated to the fund manager
853         uint nav; // Net asset value
854         uint highWaterMark; // A record of best all-time fund performance
855         uint totalSupply; // Total supply of shares
856         uint timestamp; // Time when calculations are performed in seconds
857     }
858 
859     enum RequestStatus { active, cancelled, executed }
860     enum RequestType { invest, redeem, tokenFallbackRedeem }
861     struct Request { // Describes and logs whenever asset enter and leave fund due to Participants
862         address participant; // Participant in Melon fund requesting investment or redemption
863         RequestStatus status; // Enum: active, cancelled, executed; Status of request
864         RequestType requestType; // Enum: invest, redeem, tokenFallbackRedeem
865         address requestAsset; // Address of the asset being requested
866         uint shareQuantity; // Quantity of Melon fund shares
867         uint giveQuantity; // Quantity in Melon asset to give to Melon fund to receive shareQuantity
868         uint receiveQuantity; // Quantity in Melon asset to receive from Melon fund for given shareQuantity
869         uint timestamp;     // Time of request creation in seconds
870         uint atUpdateId;    // Pricefeed updateId when this request was created
871     }
872 
873     enum OrderStatus { active, partiallyFilled, fullyFilled, cancelled }
874     enum OrderType { make, take }
875     struct Order { // Describes and logs whenever assets enter and leave fund due to Manager
876         uint exchangeId; // Id as returned from exchange
877         OrderStatus status; // Enum: active, partiallyFilled, fullyFilled, cancelled
878         OrderType orderType; // Enum: make, take
879         address sellAsset; // Asset (as registered in Asset registrar) to be sold
880         address buyAsset; // Asset (as registered in Asset registrar) to be bought
881         uint sellQuantity; // Quantity of sellAsset to be sold
882         uint buyQuantity; // Quantity of sellAsset to be bought
883         uint timestamp; // Time of order creation in seconds
884         uint fillQuantity; // Buy quantity filled; Always less than buy_quantity
885     }
886 
887     struct Exchange {
888         address exchange; // Address of the exchange
889         ExchangeInterface exchangeAdapter; //Exchange adapter contracts respective to the exchange
890         bool isApproveOnly; // True in case of exchange implementation which requires  are approved when an order is made instead of transfer
891     }
892 
893     // FIELDS
894 
895     // Constant fields
896     uint public constant MAX_FUND_ASSETS = 4; // Max ownable assets by the fund supported by gas limits
897     // Constructor fields
898     uint public MANAGEMENT_FEE_RATE; // Fee rate in QUOTE_ASSET per delta improvement in WAD
899     uint public PERFORMANCE_FEE_RATE; // Fee rate in QUOTE_ASSET per managed seconds in WAD
900     address public VERSION; // Address of Version contract
901     Asset public QUOTE_ASSET; // QUOTE asset as ERC20 contract
902     NativeAssetInterface public NATIVE_ASSET; // Native asset as ERC20 contract
903     // Methods fields
904     Modules public module; // Struct which holds all the initialised module instances
905     Exchange[] public exchanges; // Array containing exchanges this fund supports
906     Calculations public atLastUnclaimedFeeAllocation; // Calculation results at last allocateUnclaimedFees() call
907     bool public isShutDown; // Security feature, if yes than investing, managing, allocateUnclaimedFees gets blocked
908     Request[] public requests; // All the requests this fund received from participants
909     bool public isInvestAllowed; // User option, if false fund rejects Melon investments
910     bool public isRedeemAllowed; // User option, if false fund rejects Melon redemptions; Redemptions using slices always possible
911     Order[] public orders; // All the orders this fund placed on exchanges
912     mapping (uint => mapping(address => uint)) public exchangeIdsToOpenMakeOrderIds; // exchangeIndex to: asset to open make order ID ; if no open make orders, orderID is zero
913     address[] public ownedAssets; // List of all assets owned by the fund or for which the fund has open make orders
914     mapping (address => bool) public isInAssetList; // Mapping from asset to whether the asset exists in ownedAssets
915     mapping (address => bool) public isInOpenMakeOrder; // Mapping from asset to whether the asset is in a open make order as buy asset
916 
917     // METHODS
918 
919     // CONSTRUCTOR
920 
921     /// @dev Should only be called via Version.setupFund(..)
922     /// @param withName human-readable descriptive name (not necessarily unique)
923     /// @param ofQuoteAsset Asset against which mgmt and performance fee is measured against and which can be used to invest/redeem using this single asset
924     /// @param ofManagementFee A time based fee expressed, given in a number which is divided by 1 WAD
925     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 1 WAD
926     /// @param ofCompliance Address of compliance module
927     /// @param ofRiskMgmt Address of risk management module
928     /// @param ofPriceFeed Address of price feed module
929     /// @param ofExchanges Addresses of exchange on which this fund can trade
930     /// @param ofExchangeAdapters Addresses of exchange adapters
931     /// @return Deployed Fund with manager set as ofManager
932     function Fund(
933         address ofManager,
934         string withName,
935         address ofQuoteAsset,
936         uint ofManagementFee,
937         uint ofPerformanceFee,
938         address ofNativeAsset,
939         address ofCompliance,
940         address ofRiskMgmt,
941         address ofPriceFeed,
942         address[] ofExchanges,
943         address[] ofExchangeAdapters
944     )
945         RestrictedShares(withName, "MLNF", 18, now)
946     {
947         isInvestAllowed = true;
948         isRedeemAllowed = true;
949         owner = ofManager;
950         require(ofManagementFee < 10 ** 18); // Require management fee to be less than 100 percent
951         MANAGEMENT_FEE_RATE = ofManagementFee; // 1 percent is expressed as 0.01 * 10 ** 18
952         require(ofPerformanceFee < 10 ** 18); // Require performance fee to be less than 100 percent
953         PERFORMANCE_FEE_RATE = ofPerformanceFee; // 1 percent is expressed as 0.01 * 10 ** 18
954         VERSION = msg.sender;
955         module.compliance = ComplianceInterface(ofCompliance);
956         module.riskmgmt = RiskMgmtInterface(ofRiskMgmt);
957         module.pricefeed = PriceFeedInterface(ofPriceFeed);
958         // Bridged to Melon exchange interface by exchangeAdapter library
959         for (uint i = 0; i < ofExchanges.length; ++i) {
960             ExchangeInterface adapter = ExchangeInterface(ofExchangeAdapters[i]);
961             bool isApproveOnly = adapter.isApproveOnly();
962             exchanges.push(Exchange({
963                 exchange: ofExchanges[i],
964                 exchangeAdapter: adapter,
965                 isApproveOnly: isApproveOnly
966             }));
967         }
968         // Require Quote assets exists in pricefeed
969         QUOTE_ASSET = Asset(ofQuoteAsset);
970         NATIVE_ASSET = NativeAssetInterface(ofNativeAsset);
971         // Quote Asset and Native asset always in owned assets list
972         ownedAssets.push(ofQuoteAsset);
973         isInAssetList[ofQuoteAsset] = true;
974         ownedAssets.push(ofNativeAsset);
975         isInAssetList[ofNativeAsset] = true;
976         require(address(QUOTE_ASSET) == module.pricefeed.getQuoteAsset()); // Sanity check
977         atLastUnclaimedFeeAllocation = Calculations({
978             gav: 0,
979             managementFee: 0,
980             performanceFee: 0,
981             unclaimedFees: 0,
982             nav: 0,
983             highWaterMark: 10 ** getDecimals(),
984             totalSupply: totalSupply,
985             timestamp: now
986         });
987     }
988 
989     // EXTERNAL METHODS
990 
991     // EXTERNAL : ADMINISTRATION
992 
993     function enableInvestment() external pre_cond(isOwner()) { isInvestAllowed = true; }
994     function disableInvestment() external pre_cond(isOwner()) { isInvestAllowed = false; }
995     function enableRedemption() external pre_cond(isOwner()) { isRedeemAllowed = true; }
996     function disableRedemption() external pre_cond(isOwner()) { isRedeemAllowed = false; }
997     function shutDown() external pre_cond(msg.sender == VERSION) { isShutDown = true; }
998 
999 
1000     // EXTERNAL : PARTICIPATION
1001 
1002     /// @notice Give melon tokens to receive shares of this fund
1003     /// @dev Recommended to give some leeway in prices to account for possibly slightly changing prices
1004     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
1005     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
1006     function requestInvestment(
1007         uint giveQuantity,
1008         uint shareQuantity,
1009         bool isNativeAsset
1010     )
1011         external
1012         pre_cond(!isShutDown)
1013         pre_cond(isInvestAllowed) // investment using Melon has not been deactivated by the Manager
1014         pre_cond(module.compliance.isInvestmentPermitted(msg.sender, giveQuantity, shareQuantity))    // Compliance Module: Investment permitted
1015     {
1016         requests.push(Request({
1017             participant: msg.sender,
1018             status: RequestStatus.active,
1019             requestType: RequestType.invest,
1020             requestAsset: isNativeAsset ? address(NATIVE_ASSET) : address(QUOTE_ASSET),
1021             shareQuantity: shareQuantity,
1022             giveQuantity: giveQuantity,
1023             receiveQuantity: shareQuantity,
1024             timestamp: now,
1025             atUpdateId: module.pricefeed.getLastUpdateId()
1026         }));
1027         RequestUpdated(getLastRequestId());
1028     }
1029 
1030     /// @notice Give shares of this fund to receive melon tokens
1031     /// @dev Recommended to give some leeway in prices to account for possibly slightly changing prices
1032     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
1033     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
1034     function requestRedemption(
1035         uint shareQuantity,
1036         uint receiveQuantity,
1037         bool isNativeAsset
1038       )
1039         external
1040         pre_cond(!isShutDown)
1041         pre_cond(isRedeemAllowed) // Redemption using Melon has not been deactivated by Manager
1042         pre_cond(module.compliance.isRedemptionPermitted(msg.sender, shareQuantity, receiveQuantity)) // Compliance Module: Redemption permitted
1043     {
1044         requests.push(Request({
1045             participant: msg.sender,
1046             status: RequestStatus.active,
1047             requestType: RequestType.redeem,
1048             requestAsset: isNativeAsset ? address(NATIVE_ASSET) : address(QUOTE_ASSET),
1049             shareQuantity: shareQuantity,
1050             giveQuantity: shareQuantity,
1051             receiveQuantity: receiveQuantity,
1052             timestamp: now,
1053             atUpdateId: module.pricefeed.getLastUpdateId()
1054         }));
1055         RequestUpdated(getLastRequestId());
1056     }
1057 
1058     /// @notice Executes active investment and redemption requests, in a way that minimises information advantages of investor
1059     /// @dev Distributes melon and shares according to the request
1060     /// @param id Index of request to be executed
1061     /// @dev Active investment or redemption request executed
1062     function executeRequest(uint id)
1063         external
1064         pre_cond(!isShutDown)
1065         pre_cond(requests[id].status == RequestStatus.active)
1066         pre_cond(requests[id].requestType != RequestType.redeem || requests[id].shareQuantity <= balances[requests[id].participant]) // request owner does not own enough shares
1067         pre_cond(
1068             totalSupply == 0 ||
1069             (
1070                 now >= add(requests[id].timestamp, module.pricefeed.getInterval()) &&
1071                 module.pricefeed.getLastUpdateId() >= add(requests[id].atUpdateId, 2)
1072             )
1073         )   // PriceFeed Module: Wait at least one interval time and two updates before continuing (unless it is the first investment)
1074 
1075     {
1076         Request request = requests[id];
1077         // PriceFeed Module: No recent updates for fund asset list
1078         require(module.pricefeed.hasRecentPrice(address(request.requestAsset)));
1079 
1080         // sharePrice quoted in QUOTE_ASSET and multiplied by 10 ** fundDecimals
1081         uint costQuantity = toWholeShareUnit(mul(request.shareQuantity, calcSharePriceAndAllocateFees())); // By definition quoteDecimals == fundDecimals
1082         if (request.requestAsset == address(NATIVE_ASSET)) {
1083             var (isPriceRecent, invertedNativeAssetPrice, nativeAssetDecimal) = module.pricefeed.getInvertedPrice(address(NATIVE_ASSET));
1084             if (!isPriceRecent) {
1085                 revert();
1086             }
1087             costQuantity = mul(costQuantity, invertedNativeAssetPrice) / 10 ** nativeAssetDecimal;
1088         }
1089 
1090         if (
1091             isInvestAllowed &&
1092             request.requestType == RequestType.invest &&
1093             costQuantity <= request.giveQuantity
1094         ) {
1095             request.status = RequestStatus.executed;
1096             assert(AssetInterface(request.requestAsset).transferFrom(request.participant, this, costQuantity)); // Allocate Value
1097             createShares(request.participant, request.shareQuantity); // Accounting
1098         } else if (
1099             isRedeemAllowed &&
1100             request.requestType == RequestType.redeem &&
1101             request.receiveQuantity <= costQuantity
1102         ) {
1103             request.status = RequestStatus.executed;
1104             assert(AssetInterface(request.requestAsset).transfer(request.participant, costQuantity)); // Return value
1105             annihilateShares(request.participant, request.shareQuantity); // Accounting
1106         } else if (
1107             isRedeemAllowed &&
1108             request.requestType == RequestType.tokenFallbackRedeem &&
1109             request.receiveQuantity <= costQuantity
1110         ) {
1111             request.status = RequestStatus.executed;
1112             assert(AssetInterface(request.requestAsset).transfer(request.participant, costQuantity)); // Return value
1113             annihilateShares(this, request.shareQuantity); // Accounting
1114         } else {
1115             revert(); // Invalid Request or invalid giveQuantity / receiveQuantity
1116         }
1117     }
1118 
1119     /// @notice Cancels active investment and redemption requests
1120     /// @param id Index of request to be executed
1121     function cancelRequest(uint id)
1122         external
1123         pre_cond(requests[id].status == RequestStatus.active) // Request is active
1124         pre_cond(requests[id].participant == msg.sender || isShutDown) // Either request creator or fund is shut down
1125     {
1126         requests[id].status = RequestStatus.cancelled;
1127     }
1128 
1129     /// @notice Redeems by allocating an ownership percentage of each asset to the participant
1130     /// @dev Independent of running price feed!
1131     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for individual assets
1132     /// @return Whether all assets sent to shareholder or not
1133     function redeemAllOwnedAssets(uint shareQuantity)
1134         external
1135         returns (bool success)
1136     {
1137         return emergencyRedeem(shareQuantity, ownedAssets);
1138     }
1139 
1140     // EXTERNAL : MANAGING
1141 
1142     /// @notice Makes an order on the selected exchange
1143     /// @dev These are orders that are not expected to settle immediately.  Sufficient balance (== sellQuantity) of sellAsset
1144     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
1145     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
1146     /// @param sellQuantity Quantity of sellAsset to be sold
1147     /// @param buyQuantity Quantity of buyAsset to be bought
1148     function makeOrder(
1149         uint exchangeNumber,
1150         address sellAsset,
1151         address buyAsset,
1152         uint sellQuantity,
1153         uint buyQuantity
1154     )
1155         external
1156         pre_cond(isOwner())
1157         pre_cond(!isShutDown)
1158     {
1159         require(buyAsset != address(this)); // Prevent buying of own fund token
1160         require(quantityHeldInCustodyOfExchange(sellAsset) == 0); // Curr only one make order per sellAsset allowed. Please wait or cancel existing make order.
1161         require(module.pricefeed.existsPriceOnAssetPair(sellAsset, buyAsset)); // PriceFeed module: Requested asset pair not valid
1162         var (isRecent, referencePrice, ) = module.pricefeed.getReferencePrice(sellAsset, buyAsset);
1163         require(isRecent);  // Reference price is required to be recent
1164         require(
1165             module.riskmgmt.isMakePermitted(
1166                 module.pricefeed.getOrderPrice(
1167                     sellAsset,
1168                     buyAsset,
1169                     sellQuantity,
1170                     buyQuantity
1171                 ),
1172                 referencePrice,
1173                 sellAsset,
1174                 buyAsset,
1175                 sellQuantity,
1176                 buyQuantity
1177             )
1178         ); // RiskMgmt module: Make order not permitted
1179         require(isInAssetList[buyAsset] || ownedAssets.length < MAX_FUND_ASSETS); // Limit for max ownable assets by the fund reached
1180         require(AssetInterface(sellAsset).approve(exchanges[exchangeNumber].exchange, sellQuantity)); // Approve exchange to spend assets
1181 
1182         // Since there is only one openMakeOrder allowed for each asset, we can assume that openMakeOrderId is set as zero by quantityHeldInCustodyOfExchange() function
1183         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("makeOrder(address,address,address,uint256,uint256)")), exchanges[exchangeNumber].exchange, sellAsset, buyAsset, sellQuantity, buyQuantity));
1184         exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset] = exchanges[exchangeNumber].exchangeAdapter.getLastOrderId(exchanges[exchangeNumber].exchange);
1185 
1186         // Success defined as non-zero order id
1187         require(exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset] != 0);
1188 
1189         // Update ownedAssets array and isInAssetList, isInOpenMakeOrder mapping
1190         isInOpenMakeOrder[buyAsset] = true;
1191         if (!isInAssetList[buyAsset]) {
1192             ownedAssets.push(buyAsset);
1193             isInAssetList[buyAsset] = true;
1194         }
1195 
1196         orders.push(Order({
1197             exchangeId: exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset],
1198             status: OrderStatus.active,
1199             orderType: OrderType.make,
1200             sellAsset: sellAsset,
1201             buyAsset: buyAsset,
1202             sellQuantity: sellQuantity,
1203             buyQuantity: buyQuantity,
1204             timestamp: now,
1205             fillQuantity: 0
1206         }));
1207 
1208         OrderUpdated(exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset]);
1209     }
1210 
1211     /// @notice Takes an active order on the selected exchange
1212     /// @dev These are orders that are expected to settle immediately
1213     /// @param id Active order id
1214     /// @param receiveQuantity Buy quantity of what others are selling on selected Exchange
1215     function takeOrder(uint exchangeNumber, uint id, uint receiveQuantity)
1216         external
1217         pre_cond(isOwner())
1218         pre_cond(!isShutDown)
1219     {
1220         // Get information of order by order id
1221         Order memory order; // Inverse variable terminology! Buying what another person is selling
1222         (
1223             order.sellAsset,
1224             order.buyAsset,
1225             order.sellQuantity,
1226             order.buyQuantity
1227         ) = exchanges[exchangeNumber].exchangeAdapter.getOrder(exchanges[exchangeNumber].exchange, id);
1228         // Check pre conditions
1229         require(order.sellAsset != address(this)); // Prevent buying of own fund token
1230         require(module.pricefeed.existsPriceOnAssetPair(order.buyAsset, order.sellAsset)); // PriceFeed module: Requested asset pair not valid
1231         require(isInAssetList[order.sellAsset] || ownedAssets.length < MAX_FUND_ASSETS); // Limit for max ownable assets by the fund reached
1232         var (isRecent, referencePrice, ) = module.pricefeed.getReferencePrice(order.buyAsset, order.sellAsset);
1233         require(isRecent); // Reference price is required to be recent
1234         require(receiveQuantity <= order.sellQuantity); // Not enough quantity of order for what is trying to be bought
1235         uint spendQuantity = mul(receiveQuantity, order.buyQuantity) / order.sellQuantity;
1236         require(AssetInterface(order.buyAsset).approve(exchanges[exchangeNumber].exchange, spendQuantity)); // Could not approve spending of spendQuantity of order.buyAsset
1237         require(
1238             module.riskmgmt.isTakePermitted(
1239             module.pricefeed.getOrderPrice(
1240                 order.buyAsset,
1241                 order.sellAsset,
1242                 order.buyQuantity, // spendQuantity
1243                 order.sellQuantity // receiveQuantity
1244             ),
1245             referencePrice,
1246             order.buyAsset,
1247             order.sellAsset,
1248             order.buyQuantity,
1249             order.sellQuantity
1250         )); // RiskMgmt module: Take order not permitted
1251 
1252         // Execute request
1253         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("takeOrder(address,uint256,uint256)")), exchanges[exchangeNumber].exchange, id, receiveQuantity));
1254 
1255         // Update ownedAssets array and isInAssetList mapping
1256         if (!isInAssetList[order.sellAsset]) {
1257             ownedAssets.push(order.sellAsset);
1258             isInAssetList[order.sellAsset] = true;
1259         }
1260 
1261         order.exchangeId = id;
1262         order.status = OrderStatus.fullyFilled;
1263         order.orderType = OrderType.take;
1264         order.timestamp = now;
1265         order.fillQuantity = receiveQuantity;
1266         orders.push(order);
1267         OrderUpdated(id);
1268     }
1269 
1270     /// @notice Cancels orders that were not expected to settle immediately, i.e. makeOrders
1271     /// @dev Reduce exposure with exchange interaction
1272     /// @param id Active order id of this order array with order owner of this contract on selected Exchange
1273     function cancelOrder(uint exchangeNumber, uint id)
1274         external
1275         pre_cond(isOwner() || isShutDown)
1276     {
1277         // Get information of fund order by order id
1278         Order order = orders[id];
1279 
1280         // Execute request
1281         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("cancelOrder(address,uint256)")), exchanges[exchangeNumber].exchange, order.exchangeId));
1282 
1283         order.status = OrderStatus.cancelled;
1284         OrderUpdated(id);
1285     }
1286 
1287 
1288     // PUBLIC METHODS
1289 
1290     // PUBLIC METHODS : ERC223
1291 
1292     /// @dev Standard ERC223 function that handles incoming token transfers.
1293     /// @dev This type of redemption can be seen as a "market order", where price is calculated at execution time
1294     /// @param ofSender  Token sender address.
1295     /// @param tokenAmount Amount of tokens sent.
1296     /// @param metadata  Transaction metadata.
1297     function tokenFallback(
1298         address ofSender,
1299         uint tokenAmount,
1300         bytes metadata
1301     ) {
1302         if (msg.sender != address(this)) {
1303             // when ofSender is a recognized exchange, receive tokens, otherwise revert
1304             for (uint i; i < exchanges.length; i++) {
1305                 if (exchanges[i].exchange == ofSender) return; // receive tokens and do nothing
1306             }
1307             revert();
1308         } else {    // otherwise, make a redemption request
1309             requests.push(Request({
1310                 participant: ofSender,
1311                 status: RequestStatus.active,
1312                 requestType: RequestType.tokenFallbackRedeem,
1313                 requestAsset: address(QUOTE_ASSET), // redeem in QUOTE_ASSET
1314                 shareQuantity: tokenAmount,
1315                 giveQuantity: tokenAmount,              // shares being sent
1316                 receiveQuantity: 0,          // value of the shares at request time
1317                 timestamp: now,
1318                 atUpdateId: module.pricefeed.getLastUpdateId()
1319             }));
1320             RequestUpdated(getLastRequestId());
1321         }
1322     }
1323 
1324 
1325     // PUBLIC METHODS : ACCOUNTING
1326 
1327     /// @notice Calculates gross asset value of the fund
1328     /// @dev Decimals in assets must be equal to decimals in PriceFeed for all entries in AssetRegistrar
1329     /// @dev Assumes that module.pricefeed.getPrice(..) returns recent prices
1330     /// @return gav Gross asset value quoted in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1331     function calcGav() returns (uint gav) {
1332         // prices quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
1333         address[] memory tempOwnedAssets; // To store ownedAssets
1334         tempOwnedAssets = ownedAssets;
1335         delete ownedAssets;
1336         for (uint i = 0; i < tempOwnedAssets.length; ++i) {
1337             address ofAsset = tempOwnedAssets[i];
1338             // assetHoldings formatting: mul(exchangeHoldings, 10 ** assetDecimal)
1339             uint assetHoldings = add(
1340                 uint(AssetInterface(ofAsset).balanceOf(this)), // asset base units held by fund
1341                 quantityHeldInCustodyOfExchange(ofAsset)
1342             );
1343             // assetPrice formatting: mul(exchangePrice, 10 ** assetDecimal)
1344             var (isRecent, assetPrice, assetDecimals) = module.pricefeed.getPrice(ofAsset);
1345             if (!isRecent) {
1346                 revert();
1347             }
1348             // gav as sum of mul(assetHoldings, assetPrice) with formatting: mul(mul(exchangeHoldings, exchangePrice), 10 ** shareDecimals)
1349             gav = add(gav, mul(assetHoldings, assetPrice) / (10 ** uint256(assetDecimals)));   // Sum up product of asset holdings of this vault and asset prices
1350             if (assetHoldings != 0 || ofAsset == address(QUOTE_ASSET) || ofAsset == address(NATIVE_ASSET) || isInOpenMakeOrder[ofAsset]) { // Check if asset holdings is not zero or is address(QUOTE_ASSET) or in open make order
1351                 ownedAssets.push(ofAsset);
1352             } else {
1353                 isInAssetList[ofAsset] = false; // Remove from ownedAssets if asset holdings are zero
1354             }
1355             PortfolioContent(assetHoldings, assetPrice, assetDecimals);
1356         }
1357     }
1358 
1359     /**
1360     @notice Calculates unclaimed fees of the fund manager
1361     @param gav Gross asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1362     @return {
1363       "managementFees": "A time (seconds) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1364       "performanceFees": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1365       "unclaimedfees": "The sum of both managementfee and performancefee in QUOTE_ASSET and multiplied by 10 ** shareDecimals"
1366     }
1367     */
1368     function calcUnclaimedFees(uint gav)
1369         view
1370         returns (
1371             uint managementFee,
1372             uint performanceFee,
1373             uint unclaimedFees)
1374     {
1375         // Management fee calculation
1376         uint timePassed = sub(now, atLastUnclaimedFeeAllocation.timestamp);
1377         uint gavPercentage = mul(timePassed, gav) / (1 years);
1378         managementFee = wmul(gavPercentage, MANAGEMENT_FEE_RATE);
1379 
1380         // Performance fee calculation
1381         // Handle potential division through zero by defining a default value
1382         uint valuePerShareExclMgmtFees = totalSupply > 0 ? calcValuePerShare(sub(gav, managementFee), totalSupply) : toSmallestShareUnit(1);
1383         if (valuePerShareExclMgmtFees > atLastUnclaimedFeeAllocation.highWaterMark) {
1384             uint gainInSharePrice = sub(valuePerShareExclMgmtFees, atLastUnclaimedFeeAllocation.highWaterMark);
1385             uint investmentProfits = wmul(gainInSharePrice, totalSupply);
1386             performanceFee = wmul(investmentProfits, PERFORMANCE_FEE_RATE);
1387         }
1388 
1389         // Sum of all FEES
1390         unclaimedFees = add(managementFee, performanceFee);
1391     }
1392 
1393     /// @notice Calculates the Net asset value of this fund
1394     /// @param gav Gross asset value of this fund in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1395     /// @param unclaimedFees The sum of both managementFee and performanceFee in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1396     /// @return nav Net asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1397     function calcNav(uint gav, uint unclaimedFees)
1398         view
1399         returns (uint nav)
1400     {
1401         nav = sub(gav, unclaimedFees);
1402     }
1403 
1404     /// @notice Calculates the share price of the fund
1405     /// @dev Convention for valuePerShare (== sharePrice) formatting: mul(totalValue / numShares, 10 ** decimal), to avoid floating numbers
1406     /// @dev Non-zero share supply; value denominated in [base unit of melonAsset]
1407     /// @param totalValue the total value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1408     /// @param numShares the number of shares multiplied by 10 ** shareDecimals
1409     /// @return valuePerShare Share price denominated in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1410     function calcValuePerShare(uint totalValue, uint numShares)
1411         view
1412         pre_cond(numShares > 0)
1413         returns (uint valuePerShare)
1414     {
1415         valuePerShare = toSmallestShareUnit(totalValue) / numShares;
1416     }
1417 
1418     /**
1419     @notice Calculates essential fund metrics
1420     @return {
1421       "gav": "Gross asset value of this fund denominated in [base unit of melonAsset]",
1422       "managementFee": "A time (seconds) based fee",
1423       "performanceFee": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee",
1424       "unclaimedFees": "The sum of both managementFee and performanceFee denominated in [base unit of melonAsset]",
1425       "feesShareQuantity": "The number of shares to be given as fees to the manager",
1426       "nav": "Net asset value denominated in [base unit of melonAsset]",
1427       "sharePrice": "Share price denominated in [base unit of melonAsset]"
1428     }
1429     */
1430     function performCalculations()
1431         view
1432         returns (
1433             uint gav,
1434             uint managementFee,
1435             uint performanceFee,
1436             uint unclaimedFees,
1437             uint feesShareQuantity,
1438             uint nav,
1439             uint sharePrice
1440         )
1441     {
1442         gav = calcGav(); // Reflects value independent of fees
1443         (managementFee, performanceFee, unclaimedFees) = calcUnclaimedFees(gav);
1444         nav = calcNav(gav, unclaimedFees);
1445 
1446         // The value of unclaimedFees measured in shares of this fund at current value
1447         feesShareQuantity = (gav == 0) ? 0 : mul(totalSupply, unclaimedFees) / gav;
1448         // The total share supply including the value of unclaimedFees, measured in shares of this fund
1449         uint totalSupplyAccountingForFees = add(totalSupply, feesShareQuantity);
1450         sharePrice = nav > 0 ? calcValuePerShare(gav, totalSupplyAccountingForFees) : toSmallestShareUnit(1); // Handle potential division through zero by defining a default value
1451     }
1452 
1453     /// @notice Converts unclaimed fees of the manager into fund shares
1454     /// @return sharePrice Share price denominated in [base unit of melonAsset]
1455     function calcSharePriceAndAllocateFees() public returns (uint)
1456     {
1457         var (
1458             gav,
1459             managementFee,
1460             performanceFee,
1461             unclaimedFees,
1462             feesShareQuantity,
1463             nav,
1464             sharePrice
1465         ) = performCalculations();
1466 
1467         createShares(owner, feesShareQuantity); // Updates totalSupply by creating shares allocated to manager
1468 
1469         // Update Calculations
1470         uint highWaterMark = atLastUnclaimedFeeAllocation.highWaterMark >= sharePrice ? atLastUnclaimedFeeAllocation.highWaterMark : sharePrice;
1471         atLastUnclaimedFeeAllocation = Calculations({
1472             gav: gav,
1473             managementFee: managementFee,
1474             performanceFee: performanceFee,
1475             unclaimedFees: unclaimedFees,
1476             nav: nav,
1477             highWaterMark: highWaterMark,
1478             totalSupply: totalSupply,
1479             timestamp: now
1480         });
1481 
1482         FeesConverted(now, feesShareQuantity, unclaimedFees);
1483         CalculationUpdate(now, managementFee, performanceFee, nav, sharePrice, totalSupply);
1484 
1485         return sharePrice;
1486     }
1487 
1488     // PUBLIC : REDEEMING
1489 
1490     /// @notice Redeems by allocating an ownership percentage only of requestedAssets to the participant
1491     /// @dev Independent of running price feed! Note: if requestedAssets != ownedAssets then participant misses out on some owned value
1492     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for individual assets
1493     /// @param requestedAssets List of addresses that consitute a subset of ownedAssets.
1494     /// @return Whether all assets sent to shareholder or not
1495     function emergencyRedeem(uint shareQuantity, address[] requestedAssets)
1496         public
1497         pre_cond(balances[msg.sender] >= shareQuantity)  // sender owns enough shares
1498         returns (bool)
1499     {
1500         address ofAsset;
1501         uint[] memory ownershipQuantities = new uint[](requestedAssets.length);
1502 
1503         // Check whether enough assets held by fund
1504         for (uint i = 0; i < requestedAssets.length; ++i) {
1505             ofAsset = requestedAssets[i];
1506             uint assetHoldings = add(
1507                 uint(AssetInterface(ofAsset).balanceOf(this)),
1508                 quantityHeldInCustodyOfExchange(ofAsset)
1509             );
1510 
1511             if (assetHoldings == 0) continue;
1512 
1513             // participant's ownership percentage of asset holdings
1514             ownershipQuantities[i] = mul(assetHoldings, shareQuantity) / totalSupply;
1515 
1516             // CRITICAL ERR: Not enough fund asset balance for owed ownershipQuantitiy, eg in case of unreturned asset quantity at address(exchanges[i].exchange) address
1517             if (uint(AssetInterface(ofAsset).balanceOf(this)) < ownershipQuantities[i]) {
1518                 isShutDown = true;
1519                 ErrorMessage("CRITICAL ERR: Not enough assetHoldings for owed ownershipQuantitiy");
1520                 return false;
1521             }
1522         }
1523 
1524         // Annihilate shares before external calls to prevent reentrancy
1525         annihilateShares(msg.sender, shareQuantity);
1526 
1527         // Transfer ownershipQuantity of Assets
1528         for (uint j = 0; j < requestedAssets.length; ++j) {
1529             // Failed to send owed ownershipQuantity from fund to participant
1530             ofAsset = requestedAssets[j];
1531             if (ownershipQuantities[j] == 0) {
1532                 continue;
1533             } else if (!AssetInterface(ofAsset).transfer(msg.sender, ownershipQuantities[j])) {
1534                 revert();
1535             }
1536         }
1537         Redeemed(msg.sender, now, shareQuantity);
1538         return true;
1539     }
1540 
1541     // PUBLIC : FEES
1542 
1543     /// @dev Quantity of asset held in exchange according to associated order id
1544     /// @param ofAsset Address of asset
1545     /// @return Quantity of input asset held in exchange
1546     function quantityHeldInCustodyOfExchange(address ofAsset) returns (uint) {
1547         uint totalSellQuantity;     // quantity in custody across exchanges
1548         uint totalSellQuantityInApprove; // quantity of asset in approve (allowance) but not custody of exchange
1549         for (uint i; i < exchanges.length; i++) {
1550             if (exchangeIdsToOpenMakeOrderIds[i][ofAsset] == 0) {
1551                 continue;
1552             }
1553             var (sellAsset, , sellQuantity, ) = exchanges[i].exchangeAdapter.getOrder(exchanges[i].exchange, exchangeIdsToOpenMakeOrderIds[i][ofAsset]);
1554             if (sellQuantity == 0) {
1555                 exchangeIdsToOpenMakeOrderIds[i][ofAsset] = 0;
1556             }
1557             totalSellQuantity = add(totalSellQuantity, sellQuantity);
1558             if (exchanges[i].isApproveOnly) {
1559                 totalSellQuantityInApprove += sellQuantity;
1560             }
1561         }
1562         if (totalSellQuantity == 0) {
1563             isInOpenMakeOrder[sellAsset] = false;
1564         }
1565         return sub(totalSellQuantity, totalSellQuantityInApprove); // Since quantity in approve is not actually in custody
1566     }
1567 
1568     // PUBLIC VIEW METHODS
1569 
1570     /// @notice Calculates sharePrice denominated in [base unit of melonAsset]
1571     /// @return sharePrice Share price denominated in [base unit of melonAsset]
1572     function calcSharePrice() view returns (uint sharePrice) {
1573         (, , , , , sharePrice) = performCalculations();
1574         return sharePrice;
1575     }
1576 
1577     function getModules() view returns (address, address, address) {
1578         return (
1579             address(module.pricefeed),
1580             address(module.compliance),
1581             address(module.riskmgmt)
1582         );
1583     }
1584 
1585     function getLastOrderId() view returns (uint) { return orders.length - 1; }
1586     function getLastRequestId() view returns (uint) { return requests.length - 1; }
1587     function getNameHash() view returns (bytes32) { return bytes32(keccak256(name)); }
1588     function getManager() view returns (address) { return owner; }
1589 }
1590 
1591 contract WETH9_ {
1592     string public name     = "Wrapped Ether";
1593     string public symbol   = "WETH";
1594     uint8  public decimals = 18;
1595 
1596     event  Approval(address indexed src, address indexed guy, uint wad);
1597     event  Transfer(address indexed src, address indexed dst, uint wad);
1598     event  Deposit(address indexed dst, uint wad);
1599     event  Withdrawal(address indexed src, uint wad);
1600 
1601     mapping (address => uint)                       public  balanceOf;
1602     mapping (address => mapping (address => uint))  public  allowance;
1603 
1604     function() public payable {
1605         deposit();
1606     }
1607     function deposit() public payable {
1608         balanceOf[msg.sender] += msg.value;
1609         Deposit(msg.sender, msg.value);
1610     }
1611     function withdraw(uint wad) public {
1612         require(balanceOf[msg.sender] >= wad);
1613         balanceOf[msg.sender] -= wad;
1614         msg.sender.transfer(wad);
1615         Withdrawal(msg.sender, wad);
1616     }
1617 
1618     function totalSupply() public view returns (uint) {
1619         return this.balance;
1620     }
1621 
1622     function approve(address guy, uint wad) public returns (bool) {
1623         allowance[msg.sender][guy] = wad;
1624         Approval(msg.sender, guy, wad);
1625         return true;
1626     }
1627 
1628     function transfer(address dst, uint wad) public returns (bool) {
1629         return transferFrom(msg.sender, dst, wad);
1630     }
1631 
1632     function transferFrom(address src, address dst, uint wad)
1633         public
1634         returns (bool)
1635     {
1636         require(balanceOf[src] >= wad);
1637 
1638         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
1639             require(allowance[src][msg.sender] >= wad);
1640             allowance[src][msg.sender] -= wad;
1641         }
1642 
1643         balanceOf[src] -= wad;
1644         balanceOf[dst] += wad;
1645 
1646         Transfer(src, dst, wad);
1647 
1648         return true;
1649     }
1650 }