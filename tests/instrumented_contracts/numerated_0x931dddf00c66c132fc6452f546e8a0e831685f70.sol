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
338     bytes32 public constant TERMS_AND_CONDITIONS = 0xAA9C907B0D6B4890E7225C09CBC16A01CB97288840201AA7CDCB27F4ED7BF159; // Hashed terms and conditions as displayed on IPFS, decoded from base 58
339     address public COMPLIANCE = 0xFb5978C7ca78074B2044034CbdbC3f2E03Dfe2bA; // restrict to OnlyManager compliance module for this version
340 
341     // Constructor fields
342     string public VERSION_NUMBER; // SemVer of Melon protocol version
343     address public NATIVE_ASSET; // Address of wrapped native asset contract
344     address public GOVERNANCE; // Address of Melon protocol governance contract
345     bool public IS_MAINNET;  // whether this contract is on the mainnet (to use hardcoded module)
346 
347     // Methods fields
348     bool public isShutDown; // Governance feature, if yes than setupFund gets blocked and shutDownFund gets opened
349     address[] public listOfFunds; // A complete list of fund addresses created using this version
350     mapping (address => address) public managerToFunds; // Links manager address to fund address created using this version
351 
352     // EVENTS
353 
354     event FundUpdated(address ofFund);
355 
356     // METHODS
357 
358     // CONSTRUCTOR
359 
360     /// @param versionNumber SemVer of Melon protocol version
361     /// @param ofGovernance Address of Melon governance contract
362     /// @param ofNativeAsset Address of wrapped native asset contract
363     function Version(
364         string versionNumber,
365         address ofGovernance,
366         address ofNativeAsset,
367         bool isMainnet
368     ) {
369         VERSION_NUMBER = versionNumber;
370         GOVERNANCE = ofGovernance;
371         NATIVE_ASSET = ofNativeAsset;
372         IS_MAINNET = isMainnet;
373     }
374 
375     // EXTERNAL METHODS
376 
377     function shutDown() external pre_cond(msg.sender == GOVERNANCE) { isShutDown = true; }
378 
379     // PUBLIC METHODS
380 
381     /// @param ofFundName human-readable descriptive name (not necessarily unique)
382     /// @param ofQuoteAsset Asset against which performance fee is measured against
383     /// @param ofManagementFee A time based fee, given in a number which is divided by 10 ** 15
384     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 10 ** 15
385     /// @param ofCompliance Address of participation module
386     /// @param ofRiskMgmt Address of risk management module
387     /// @param ofPriceFeed Address of price feed module
388     /// @param ofExchanges Addresses of exchange on which this fund can trade
389     /// @param ofExchangeAdapters Addresses of exchange adapters
390     /// @param v ellipitc curve parameter v
391     /// @param r ellipitc curve parameter r
392     /// @param s ellipitc curve parameter s
393     function setupFund(
394         string ofFundName,
395         address ofQuoteAsset,
396         uint ofManagementFee,
397         uint ofPerformanceFee,
398         address ofCompliance,
399         address ofRiskMgmt,
400         address ofPriceFeed,
401         address[] ofExchanges,
402         address[] ofExchangeAdapters,
403         uint8 v,
404         bytes32 r,
405         bytes32 s
406     ) {
407         require(!isShutDown);
408         require(termsAndConditionsAreSigned(v, r, s));
409         // Either novel fund name or previous owner of fund name
410         require(managerToFunds[msg.sender] == 0); // Add limitation for simpler migration process of shutting down and setting up fund
411         if (IS_MAINNET) {
412             ofCompliance = COMPLIANCE;  // only for this version, with restricted compliance module on mainnet
413         }
414         address ofFund = new Fund(
415             msg.sender,
416             ofFundName,
417             ofQuoteAsset,
418             ofManagementFee,
419             ofPerformanceFee,
420             NATIVE_ASSET,
421             ofCompliance,
422             ofRiskMgmt,
423             ofPriceFeed,
424             ofExchanges,
425             ofExchangeAdapters
426         );
427         listOfFunds.push(ofFund);
428         managerToFunds[msg.sender] = ofFund;
429         FundUpdated(ofFund);
430     }
431 
432     /// @dev Dereference Fund and trigger selfdestruct
433     /// @param ofFund Address of the fund to be shut down
434     function shutDownFund(address ofFund)
435         pre_cond(isShutDown || managerToFunds[msg.sender] == ofFund)
436     {
437         Fund fund = Fund(ofFund);
438         delete managerToFunds[msg.sender];
439         fund.shutDown();
440         FundUpdated(ofFund);
441     }
442 
443     // PUBLIC VIEW METHODS
444 
445     /// @dev Proof that terms and conditions have been read and understood
446     /// @param v ellipitc curve parameter v
447     /// @param r ellipitc curve parameter r
448     /// @param s ellipitc curve parameter s
449     /// @return signed Whether or not terms and conditions have been read and understood
450     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed) {
451         return ecrecover(
452             // Parity does prepend \x19Ethereum Signed Message:\n{len(message)} before signing.
453             //  Signature order has also been changed in 1.6.7 and upcoming 1.7.x,
454             //  it will return rsv (same as geth; where v is [27, 28]).
455             // Note that if you are using ecrecover, v will be either "00" or "01".
456             //  As a result, in order to use this value, you will have to parse it to an
457             //  integer and then add 27. This will result in either a 27 or a 28.
458             //  https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethsign
459             keccak256("\x19Ethereum Signed Message:\n32", TERMS_AND_CONDITIONS),
460             v,
461             r,
462             s
463         ) == msg.sender; // Has sender signed TERMS_AND_CONDITIONS
464     }
465 
466     function getNativeAsset() view returns (address) { return NATIVE_ASSET; }
467     function getFundById(uint withId) view returns (address) { return listOfFunds[withId]; }
468     function getLastFundId() view returns (uint) { return listOfFunds.length - 1; }
469     function getFundByManager(address ofManager) view returns (address) { return managerToFunds[ofManager]; }
470 }
471 
472 contract DSMath {
473     function add(uint x, uint y) internal pure returns (uint z) {
474         require((z = x + y) >= x);
475     }
476     function sub(uint x, uint y) internal pure returns (uint z) {
477         require((z = x - y) <= x);
478     }
479     function mul(uint x, uint y) internal pure returns (uint z) {
480         require(y == 0 || (z = x * y) / y == x);
481     }
482 
483     function min(uint x, uint y) internal pure returns (uint z) {
484         return x <= y ? x : y;
485     }
486     function max(uint x, uint y) internal pure returns (uint z) {
487         return x >= y ? x : y;
488     }
489     function imin(int x, int y) internal pure returns (int z) {
490         return x <= y ? x : y;
491     }
492     function imax(int x, int y) internal pure returns (int z) {
493         return x >= y ? x : y;
494     }
495 
496     uint constant WAD = 10 ** 18;
497     uint constant RAY = 10 ** 27;
498 
499     function wmul(uint x, uint y) internal pure returns (uint z) {
500         z = add(mul(x, y), WAD / 2) / WAD;
501     }
502     function rmul(uint x, uint y) internal pure returns (uint z) {
503         z = add(mul(x, y), RAY / 2) / RAY;
504     }
505     function wdiv(uint x, uint y) internal pure returns (uint z) {
506         z = add(mul(x, WAD), y / 2) / y;
507     }
508     function rdiv(uint x, uint y) internal pure returns (uint z) {
509         z = add(mul(x, RAY), y / 2) / y;
510     }
511 
512     // This famous algorithm is called "exponentiation by squaring"
513     // and calculates x^n with x as fixed-point and n as regular unsigned.
514     //
515     // It's O(log n), instead of O(n) for naive repeated multiplication.
516     //
517     // These facts are why it works:
518     //
519     //  If n is even, then x^n = (x^2)^(n/2).
520     //  If n is odd,  then x^n = x * x^(n-1),
521     //   and applying the equation for even x gives
522     //    x^n = x * (x^2)^((n-1) / 2).
523     //
524     //  Also, EVM division is flooring and
525     //    floor[(n-1) / 2] = floor[n / 2].
526     //
527     function rpow(uint x, uint n) internal pure returns (uint z) {
528         z = n % 2 != 0 ? x : RAY;
529 
530         for (n /= 2; n != 0; n /= 2) {
531             x = rmul(x, x);
532 
533             if (n % 2 != 0) {
534                 z = rmul(z, x);
535             }
536         }
537     }
538 }
539 
540 contract Asset is DSMath, AssetInterface, ERC223Interface {
541 
542     // DATA STRUCTURES
543 
544     mapping (address => uint) balances;
545     mapping (address => mapping (address => uint)) allowed;
546     uint public totalSupply;
547 
548     // PUBLIC METHODS
549 
550     /**
551      * @notice Send `_value` tokens to `_to` from `msg.sender`
552      * @dev Transfers sender's tokens to a given address
553      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
554      * @param _to Address of token receiver
555      * @param _value Number of tokens to transfer
556      * @return Returns success of function call
557      */
558     function transfer(address _to, uint _value)
559         public
560         returns (bool success)
561     {
562         uint codeLength;
563         bytes memory empty;
564 
565         assembly {
566             // Retrieve the size of the code on target address, this needs assembly.
567             codeLength := extcodesize(_to)
568         }
569  
570         require(balances[msg.sender] >= _value); // sanity checks
571         require(balances[_to] + _value >= balances[_to]);
572 
573         balances[msg.sender] = sub(balances[msg.sender], _value);
574         balances[_to] = add(balances[_to], _value);
575         // if (codeLength > 0) {
576         //     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
577         //     receiver.tokenFallback(msg.sender, _value, empty);
578         // }
579         Transfer(msg.sender, _to, _value, empty);
580         return true;
581     }
582 
583     /**
584      * @notice Send `_value` tokens to `_to` from `msg.sender` and trigger tokenFallback if sender is a contract
585      * @dev Function that is called when a user or contract wants to transfer funds
586      * @param _to Address of token receiver
587      * @param _value Number of tokens to transfer
588      * @param _data Data to be sent to tokenFallback
589      * @return Returns success of function call
590      */
591     function transfer(address _to, uint _value, bytes _data)
592         public
593         returns (bool success)
594     {
595         uint codeLength;
596 
597         assembly {
598             // Retrieve the size of the code on target address, this needs assembly.
599             codeLength := extcodesize(_to)
600         }
601 
602         require(balances[msg.sender] >= _value); // sanity checks
603         require(balances[_to] + _value >= balances[_to]);
604 
605         balances[msg.sender] = sub(balances[msg.sender], _value);
606         balances[_to] = add(balances[_to], _value);
607         // if (codeLength > 0) {
608         //     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
609         //     receiver.tokenFallback(msg.sender, _value, _data);
610         // }
611         Transfer(msg.sender, _to, _value);
612         return true;
613     }
614 
615     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
616     /// @notice Restriction: An account can only use this function to send to itself
617     /// @dev Allows for an approved third party to transfer tokens from one
618     /// address to another. Returns success.
619     /// @param _from Address from where tokens are withdrawn.
620     /// @param _to Address to where tokens are sent.
621     /// @param _value Number of tokens to transfer.
622     /// @return Returns success of function call.
623     function transferFrom(address _from, address _to, uint _value)
624         public
625         returns (bool)
626     {
627         require(_from != 0x0);
628         require(_to != 0x0);
629         require(_to != address(this));
630         require(balances[_from] >= _value);
631         require(allowed[_from][msg.sender] >= _value);
632         require(balances[_to] + _value >= balances[_to]);
633         // require(_to == msg.sender); // can only use transferFrom to send to self
634 
635         balances[_to] += _value;
636         balances[_from] -= _value;
637         allowed[_from][msg.sender] -= _value;
638 
639         Transfer(_from, _to, _value);
640         return true;
641     }
642 
643     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
644     /// @dev Sets approved amount of tokens for spender. Returns success.
645     /// @param _spender Address of allowed account.
646     /// @param _value Number of approved tokens.
647     /// @return Returns success of function call.
648     function approve(address _spender, uint _value) public returns (bool) {
649         require(_spender != 0x0);
650 
651         // To change the approve amount you first have to reduce the addresses`
652         // allowance to zero by calling `approve(_spender, 0)` if it is not
653         // already 0 to mitigate the race condition described here:
654         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
655         // require(_value == 0 || allowed[msg.sender][_spender] == 0);
656 
657         allowed[msg.sender][_spender] = _value;
658         Approval(msg.sender, _spender, _value);
659         return true;
660     }
661 
662     // PUBLIC VIEW METHODS
663 
664     /// @dev Returns number of allowed tokens that a spender can transfer on
665     /// behalf of a token owner.
666     /// @param _owner Address of token owner.
667     /// @param _spender Address of token spender.
668     /// @return Returns remaining allowance for spender.
669     function allowance(address _owner, address _spender)
670         constant
671         public
672         returns (uint)
673     {
674         return allowed[_owner][_spender];
675     }
676 
677     /// @dev Returns number of tokens owned by the given address.
678     /// @param _owner Address of token owner.
679     /// @return Returns balance of owner.
680     function balanceOf(address _owner) constant public returns (uint) {
681         return balances[_owner];
682     }
683 }
684 
685 contract Shares is Asset, SharesInterface {
686 
687     // FIELDS
688 
689     // Constructor fields
690     string public name;
691     string public symbol;
692     uint public decimal;
693     uint public creationTime;
694 
695     // METHODS
696 
697     // CONSTRUCTOR
698 
699     /// @param _name Name these shares
700     /// @param _symbol Symbol of shares
701     /// @param _decimal Amount of decimals sharePrice is denominated in, defined to be equal as deciamls in REFERENCE_ASSET contract
702     /// @param _creationTime Timestamp of share creation
703     function Shares(string _name, string _symbol, uint _decimal, uint _creationTime) {
704         name = _name;
705         symbol = _symbol;
706         decimal = _decimal;
707         creationTime = _creationTime;
708     }
709 
710     // PUBLIC METHODS
711     // PUBLIC VIEW METHODS
712 
713     function getName() view returns (string) { return name; }
714     function getSymbol() view returns (string) { return symbol; }
715     function getDecimals() view returns (uint) { return decimal; }
716     function getCreationTime() view returns (uint) { return creationTime; }
717     function toSmallestShareUnit(uint quantity) view returns (uint) { return mul(quantity, 10 ** getDecimals()); }
718     function toWholeShareUnit(uint quantity) view returns (uint) { return quantity / (10 ** getDecimals()); }
719     function transfer(address _to, uint256 _value) public returns (bool) { require(_to == address(this)); }
720     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) { require(_to == address(this)); }
721     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) { require(_to == address(this)); }
722 
723     // INTERNAL METHODS
724 
725     /// @param recipient Address the new shares should be sent to
726     /// @param shareQuantity Number of shares to be created
727     function createShares(address recipient, uint shareQuantity) internal {
728         totalSupply = add(totalSupply, shareQuantity);
729         balances[recipient] = add(balances[recipient], shareQuantity);
730         Created(msg.sender, now, shareQuantity);
731     }
732 
733     /// @param recipient Address the new shares should be taken from when destroyed
734     /// @param shareQuantity Number of shares to be annihilated
735     function annihilateShares(address recipient, uint shareQuantity) internal {
736         totalSupply = sub(totalSupply, shareQuantity);
737         balances[recipient] = sub(balances[recipient], shareQuantity);
738         Annihilated(msg.sender, now, shareQuantity);
739     }
740 }
741 
742 contract RestrictedShares is Shares {
743 
744     // CONSTRUCTOR
745 
746     /// @param _name Name these shares
747     /// @param _symbol Symbol of shares
748     /// @param _decimal Amount of decimals sharePrice is denominated in, defined to be equal as deciamls in REFERENCE_ASSET contract
749     /// @param _creationTime Timestamp of share creation
750     function RestrictedShares(
751         string _name,
752         string _symbol,
753         uint _decimal,
754         uint _creationTime
755     ) Shares(_name, _symbol, _decimal, _creationTime) {}
756 
757     // PUBLIC METHODS
758 
759     /**
760      * @notice Send `_value` tokens to `_to` from `msg.sender`
761      * @dev Transfers sender's tokens to a given address
762      * @dev Similar to transfer(address, uint, bytes), but without _data parameter
763      * @param _to Address of token receiver
764      * @param _value Number of tokens to transfer
765      * @return Returns success of function call
766      */
767     function transfer(address _to, uint _value)
768         public
769         returns (bool success)
770     {
771         require(msg.sender == address(this) || _to == address(this));
772         uint codeLength;
773         bytes memory empty;
774 
775         assembly {
776             // Retrieve the size of the code on target address, this needs assembly.
777             codeLength := extcodesize(_to)
778         }
779 
780         require(balances[msg.sender] >= _value); // sanity checks
781         require(balances[_to] + _value >= balances[_to]);
782 
783         balances[msg.sender] = sub(balances[msg.sender], _value);
784         balances[_to] = add(balances[_to], _value);
785         if (codeLength > 0) {
786             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
787             receiver.tokenFallback(msg.sender, _value, empty);
788         }
789         Transfer(msg.sender, _to, _value, empty);
790         return true;
791     }
792 
793     /**
794      * @notice Send `_value` tokens to `_to` from `msg.sender` and trigger tokenFallback if sender is a contract
795      * @dev Function that is called when a user or contract wants to transfer funds
796      * @param _to Address of token receiver
797      * @param _value Number of tokens to transfer
798      * @param _data Data to be sent to tokenFallback
799      * @return Returns success of function call
800      */
801     function transfer(address _to, uint _value, bytes _data)
802         public
803         returns (bool success)
804     {
805         require(msg.sender == address(this) || _to == address(this));
806         uint codeLength;
807 
808         assembly {
809             // Retrieve the size of the code on target address, this needs assembly.
810             codeLength := extcodesize(_to)
811         }
812 
813         require(balances[msg.sender] >= _value); // sanity checks
814         require(balances[_to] + _value >= balances[_to]);
815 
816         balances[msg.sender] = sub(balances[msg.sender], _value);
817         balances[_to] = add(balances[_to], _value);
818         if (codeLength > 0) {
819             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
820             receiver.tokenFallback(msg.sender, _value, _data);
821         }
822         Transfer(msg.sender, _to, _value);
823         return true;
824     }
825 
826     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
827     /// @dev Sets approved amount of tokens for spender. Returns success.
828     /// @param _spender Address of allowed account.
829     /// @param _value Number of approved tokens.
830     /// @return Returns success of function call.
831     function approve(address _spender, uint _value) public returns (bool) {
832         require(msg.sender == address(this));
833         require(_spender != 0x0);
834 
835         // To change the approve amount you first have to reduce the addresses`
836         // allowance to zero by calling `approve(_spender, 0)` if it is not
837         // already 0 to mitigate the race condition described here:
838         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
839         require(_value == 0 || allowed[msg.sender][_spender] == 0);
840 
841         allowed[msg.sender][_spender] = _value;
842         Approval(msg.sender, _spender, _value);
843         return true;
844     }
845 
846 }
847 
848 contract Fund is DSMath, DBC, Owned, RestrictedShares, FundInterface, ERC223ReceivingContract {
849     // TYPES
850 
851     struct Modules { // Describes all modular parts, standardised through an interface
852         PriceFeedInterface pricefeed; // Provides all external data
853         ComplianceInterface compliance; // Boolean functions regarding invest/redeem
854         RiskMgmtInterface riskmgmt; // Boolean functions regarding make/take orders
855     }
856 
857     struct Calculations { // List of internal calculations
858         uint gav; // Gross asset value
859         uint managementFee; // Time based fee
860         uint performanceFee; // Performance based fee measured against QUOTE_ASSET
861         uint unclaimedFees; // Fees not yet allocated to the fund manager
862         uint nav; // Net asset value
863         uint highWaterMark; // A record of best all-time fund performance
864         uint totalSupply; // Total supply of shares
865         uint timestamp; // Time when calculations are performed in seconds
866     }
867 
868     enum RequestStatus { active, cancelled, executed }
869     enum RequestType { invest, redeem, tokenFallbackRedeem }
870     struct Request { // Describes and logs whenever asset enter and leave fund due to Participants
871         address participant; // Participant in Melon fund requesting investment or redemption
872         RequestStatus status; // Enum: active, cancelled, executed; Status of request
873         RequestType requestType; // Enum: invest, redeem, tokenFallbackRedeem
874         address requestAsset; // Address of the asset being requested
875         uint shareQuantity; // Quantity of Melon fund shares
876         uint giveQuantity; // Quantity in Melon asset to give to Melon fund to receive shareQuantity
877         uint receiveQuantity; // Quantity in Melon asset to receive from Melon fund for given shareQuantity
878         uint timestamp;     // Time of request creation in seconds
879         uint atUpdateId;    // Pricefeed updateId when this request was created
880     }
881 
882     enum OrderStatus { active, partiallyFilled, fullyFilled, cancelled }
883     enum OrderType { make, take }
884     struct Order { // Describes and logs whenever assets enter and leave fund due to Manager
885         uint exchangeId; // Id as returned from exchange
886         OrderStatus status; // Enum: active, partiallyFilled, fullyFilled, cancelled
887         OrderType orderType; // Enum: make, take
888         address sellAsset; // Asset (as registered in Asset registrar) to be sold
889         address buyAsset; // Asset (as registered in Asset registrar) to be bought
890         uint sellQuantity; // Quantity of sellAsset to be sold
891         uint buyQuantity; // Quantity of sellAsset to be bought
892         uint timestamp; // Time of order creation in seconds
893         uint fillQuantity; // Buy quantity filled; Always less than buy_quantity
894     }
895 
896     struct Exchange {
897         address exchange; // Address of the exchange
898         ExchangeInterface exchangeAdapter; //Exchange adapter contracts respective to the exchange
899         bool isApproveOnly; // True in case of exchange implementation which requires  are approved when an order is made instead of transfer
900     }
901 
902     // FIELDS
903 
904     // Constant fields
905     uint public constant MAX_FUND_ASSETS = 4; // Max ownable assets by the fund supported by gas limits
906     // Constructor fields
907     uint public MANAGEMENT_FEE_RATE; // Fee rate in QUOTE_ASSET per delta improvement in WAD
908     uint public PERFORMANCE_FEE_RATE; // Fee rate in QUOTE_ASSET per managed seconds in WAD
909     address public VERSION; // Address of Version contract
910     Asset public QUOTE_ASSET; // QUOTE asset as ERC20 contract
911     NativeAssetInterface public NATIVE_ASSET; // Native asset as ERC20 contract
912     // Methods fields
913     Modules public module; // Struct which holds all the initialised module instances
914     Exchange[] public exchanges; // Array containing exchanges this fund supports
915     Calculations public atLastUnclaimedFeeAllocation; // Calculation results at last allocateUnclaimedFees() call
916     bool public isShutDown; // Security feature, if yes than investing, managing, allocateUnclaimedFees gets blocked
917     Request[] public requests; // All the requests this fund received from participants
918     bool public isInvestAllowed; // User option, if false fund rejects Melon investments
919     bool public isRedeemAllowed; // User option, if false fund rejects Melon redemptions; Redemptions using slices always possible
920     Order[] public orders; // All the orders this fund placed on exchanges
921     mapping (uint => mapping(address => uint)) public exchangeIdsToOpenMakeOrderIds; // exchangeIndex to: asset to open make order ID ; if no open make orders, orderID is zero
922     address[] public ownedAssets; // List of all assets owned by the fund or for which the fund has open make orders
923     mapping (address => bool) public isInAssetList; // Mapping from asset to whether the asset exists in ownedAssets
924     mapping (address => bool) public isInOpenMakeOrder; // Mapping from asset to whether the asset is in a open make order as buy asset
925 
926     // METHODS
927 
928     // CONSTRUCTOR
929 
930     /// @dev Should only be called via Version.setupFund(..)
931     /// @param withName human-readable descriptive name (not necessarily unique)
932     /// @param ofQuoteAsset Asset against which mgmt and performance fee is measured against and which can be used to invest/redeem using this single asset
933     /// @param ofManagementFee A time based fee expressed, given in a number which is divided by 1 WAD
934     /// @param ofPerformanceFee A time performance based fee, performance relative to ofQuoteAsset, given in a number which is divided by 1 WAD
935     /// @param ofCompliance Address of compliance module
936     /// @param ofRiskMgmt Address of risk management module
937     /// @param ofPriceFeed Address of price feed module
938     /// @param ofExchanges Addresses of exchange on which this fund can trade
939     /// @param ofExchangeAdapters Addresses of exchange adapters
940     /// @return Deployed Fund with manager set as ofManager
941     function Fund(
942         address ofManager,
943         string withName,
944         address ofQuoteAsset,
945         uint ofManagementFee,
946         uint ofPerformanceFee,
947         address ofNativeAsset,
948         address ofCompliance,
949         address ofRiskMgmt,
950         address ofPriceFeed,
951         address[] ofExchanges,
952         address[] ofExchangeAdapters
953     )
954         RestrictedShares(withName, "MLNF", 18, now)
955     {
956         isInvestAllowed = true;
957         isRedeemAllowed = true;
958         owner = ofManager;
959         require(ofManagementFee < 10 ** 18); // Require management fee to be less than 100 percent
960         MANAGEMENT_FEE_RATE = ofManagementFee; // 1 percent is expressed as 0.01 * 10 ** 18
961         require(ofPerformanceFee < 10 ** 18); // Require performance fee to be less than 100 percent
962         PERFORMANCE_FEE_RATE = ofPerformanceFee; // 1 percent is expressed as 0.01 * 10 ** 18
963         VERSION = msg.sender;
964         module.compliance = ComplianceInterface(ofCompliance);
965         module.riskmgmt = RiskMgmtInterface(ofRiskMgmt);
966         module.pricefeed = PriceFeedInterface(ofPriceFeed);
967         // Bridged to Melon exchange interface by exchangeAdapter library
968         for (uint i = 0; i < ofExchanges.length; ++i) {
969             ExchangeInterface adapter = ExchangeInterface(ofExchangeAdapters[i]);
970             bool isApproveOnly = adapter.isApproveOnly();
971             exchanges.push(Exchange({
972                 exchange: ofExchanges[i],
973                 exchangeAdapter: adapter,
974                 isApproveOnly: isApproveOnly
975             }));
976         }
977         // Require Quote assets exists in pricefeed
978         QUOTE_ASSET = Asset(ofQuoteAsset);
979         NATIVE_ASSET = NativeAssetInterface(ofNativeAsset);
980         // Quote Asset and Native asset always in owned assets list
981         ownedAssets.push(ofQuoteAsset);
982         isInAssetList[ofQuoteAsset] = true;
983         ownedAssets.push(ofNativeAsset);
984         isInAssetList[ofNativeAsset] = true;
985         require(address(QUOTE_ASSET) == module.pricefeed.getQuoteAsset()); // Sanity check
986         atLastUnclaimedFeeAllocation = Calculations({
987             gav: 0,
988             managementFee: 0,
989             performanceFee: 0,
990             unclaimedFees: 0,
991             nav: 0,
992             highWaterMark: 10 ** getDecimals(),
993             totalSupply: totalSupply,
994             timestamp: now
995         });
996     }
997 
998     // EXTERNAL METHODS
999 
1000     // EXTERNAL : ADMINISTRATION
1001 
1002     function enableInvestment() external pre_cond(isOwner()) { isInvestAllowed = true; }
1003     function disableInvestment() external pre_cond(isOwner()) { isInvestAllowed = false; }
1004     function enableRedemption() external pre_cond(isOwner()) { isRedeemAllowed = true; }
1005     function disableRedemption() external pre_cond(isOwner()) { isRedeemAllowed = false; }
1006     function shutDown() external pre_cond(msg.sender == VERSION) { isShutDown = true; }
1007 
1008 
1009     // EXTERNAL : PARTICIPATION
1010 
1011     /// @notice Give melon tokens to receive shares of this fund
1012     /// @dev Recommended to give some leeway in prices to account for possibly slightly changing prices
1013     /// @param giveQuantity Quantity of Melon token times 10 ** 18 offered to receive shareQuantity
1014     /// @param shareQuantity Quantity of shares times 10 ** 18 requested to be received
1015     function requestInvestment(
1016         uint giveQuantity,
1017         uint shareQuantity,
1018         bool isNativeAsset
1019     )
1020         external
1021         pre_cond(!isShutDown)
1022         pre_cond(isInvestAllowed) // investment using Melon has not been deactivated by the Manager
1023         pre_cond(module.compliance.isInvestmentPermitted(msg.sender, giveQuantity, shareQuantity))    // Compliance Module: Investment permitted
1024     {
1025         requests.push(Request({
1026             participant: msg.sender,
1027             status: RequestStatus.active,
1028             requestType: RequestType.invest,
1029             requestAsset: isNativeAsset ? address(NATIVE_ASSET) : address(QUOTE_ASSET),
1030             shareQuantity: shareQuantity,
1031             giveQuantity: giveQuantity,
1032             receiveQuantity: shareQuantity,
1033             timestamp: now,
1034             atUpdateId: module.pricefeed.getLastUpdateId()
1035         }));
1036         RequestUpdated(getLastRequestId());
1037     }
1038 
1039     /// @notice Give shares of this fund to receive melon tokens
1040     /// @dev Recommended to give some leeway in prices to account for possibly slightly changing prices
1041     /// @param shareQuantity Quantity of shares times 10 ** 18 offered to redeem
1042     /// @param receiveQuantity Quantity of Melon token times 10 ** 18 requested to receive for shareQuantity
1043     function requestRedemption(
1044         uint shareQuantity,
1045         uint receiveQuantity,
1046         bool isNativeAsset
1047       )
1048         external
1049         pre_cond(!isShutDown)
1050         pre_cond(isRedeemAllowed) // Redemption using Melon has not been deactivated by Manager
1051         pre_cond(module.compliance.isRedemptionPermitted(msg.sender, shareQuantity, receiveQuantity)) // Compliance Module: Redemption permitted
1052     {
1053         requests.push(Request({
1054             participant: msg.sender,
1055             status: RequestStatus.active,
1056             requestType: RequestType.redeem,
1057             requestAsset: isNativeAsset ? address(NATIVE_ASSET) : address(QUOTE_ASSET),
1058             shareQuantity: shareQuantity,
1059             giveQuantity: shareQuantity,
1060             receiveQuantity: receiveQuantity,
1061             timestamp: now,
1062             atUpdateId: module.pricefeed.getLastUpdateId()
1063         }));
1064         RequestUpdated(getLastRequestId());
1065     }
1066 
1067     /// @notice Executes active investment and redemption requests, in a way that minimises information advantages of investor
1068     /// @dev Distributes melon and shares according to the request
1069     /// @param id Index of request to be executed
1070     /// @dev Active investment or redemption request executed
1071     function executeRequest(uint id)
1072         external
1073         pre_cond(!isShutDown)
1074         pre_cond(requests[id].status == RequestStatus.active)
1075         pre_cond(requests[id].requestType != RequestType.redeem || requests[id].shareQuantity <= balances[requests[id].participant]) // request owner does not own enough shares
1076         pre_cond(
1077             totalSupply == 0 ||
1078             (
1079                 now >= add(requests[id].timestamp, module.pricefeed.getInterval()) &&
1080                 module.pricefeed.getLastUpdateId() >= add(requests[id].atUpdateId, 2)
1081             )
1082         )   // PriceFeed Module: Wait at least one interval time and two updates before continuing (unless it is the first investment)
1083 
1084     {
1085         Request request = requests[id];
1086         // PriceFeed Module: No recent updates for fund asset list
1087         require(module.pricefeed.hasRecentPrice(address(request.requestAsset)));
1088 
1089         // sharePrice quoted in QUOTE_ASSET and multiplied by 10 ** fundDecimals
1090         uint costQuantity = toWholeShareUnit(mul(request.shareQuantity, calcSharePriceAndAllocateFees())); // By definition quoteDecimals == fundDecimals
1091         if (request.requestAsset == address(NATIVE_ASSET)) {
1092             var (isPriceRecent, invertedNativeAssetPrice, nativeAssetDecimal) = module.pricefeed.getInvertedPrice(address(NATIVE_ASSET));
1093             if (!isPriceRecent) {
1094                 revert();
1095             }
1096             costQuantity = mul(costQuantity, invertedNativeAssetPrice) / 10 ** nativeAssetDecimal;
1097         }
1098 
1099         if (
1100             isInvestAllowed &&
1101             request.requestType == RequestType.invest &&
1102             costQuantity <= request.giveQuantity
1103         ) {
1104             request.status = RequestStatus.executed;
1105             assert(AssetInterface(request.requestAsset).transferFrom(request.participant, this, costQuantity)); // Allocate Value
1106             createShares(request.participant, request.shareQuantity); // Accounting
1107         } else if (
1108             isRedeemAllowed &&
1109             request.requestType == RequestType.redeem &&
1110             request.receiveQuantity <= costQuantity
1111         ) {
1112             request.status = RequestStatus.executed;
1113             assert(AssetInterface(request.requestAsset).transfer(request.participant, costQuantity)); // Return value
1114             annihilateShares(request.participant, request.shareQuantity); // Accounting
1115         } else if (
1116             isRedeemAllowed &&
1117             request.requestType == RequestType.tokenFallbackRedeem &&
1118             request.receiveQuantity <= costQuantity
1119         ) {
1120             request.status = RequestStatus.executed;
1121             assert(AssetInterface(request.requestAsset).transfer(request.participant, costQuantity)); // Return value
1122             annihilateShares(this, request.shareQuantity); // Accounting
1123         } else {
1124             revert(); // Invalid Request or invalid giveQuantity / receiveQuantity
1125         }
1126     }
1127 
1128     /// @notice Cancels active investment and redemption requests
1129     /// @param id Index of request to be executed
1130     function cancelRequest(uint id)
1131         external
1132         pre_cond(requests[id].status == RequestStatus.active) // Request is active
1133         pre_cond(requests[id].participant == msg.sender || isShutDown) // Either request creator or fund is shut down
1134     {
1135         requests[id].status = RequestStatus.cancelled;
1136     }
1137 
1138     /// @notice Redeems by allocating an ownership percentage of each asset to the participant
1139     /// @dev Independent of running price feed!
1140     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for individual assets
1141     /// @return Whether all assets sent to shareholder or not
1142     function redeemAllOwnedAssets(uint shareQuantity)
1143         external
1144         returns (bool success)
1145     {
1146         return emergencyRedeem(shareQuantity, ownedAssets);
1147     }
1148 
1149     // EXTERNAL : MANAGING
1150 
1151     /// @notice Makes an order on the selected exchange
1152     /// @dev These are orders that are not expected to settle immediately.  Sufficient balance (== sellQuantity) of sellAsset
1153     /// @param sellAsset Asset (as registered in Asset registrar) to be sold
1154     /// @param buyAsset Asset (as registered in Asset registrar) to be bought
1155     /// @param sellQuantity Quantity of sellAsset to be sold
1156     /// @param buyQuantity Quantity of buyAsset to be bought
1157     function makeOrder(
1158         uint exchangeNumber,
1159         address sellAsset,
1160         address buyAsset,
1161         uint sellQuantity,
1162         uint buyQuantity
1163     )
1164         external
1165         pre_cond(isOwner())
1166         pre_cond(!isShutDown)
1167     {
1168         require(buyAsset != address(this)); // Prevent buying of own fund token
1169         require(quantityHeldInCustodyOfExchange(sellAsset) == 0); // Curr only one make order per sellAsset allowed. Please wait or cancel existing make order.
1170         require(module.pricefeed.existsPriceOnAssetPair(sellAsset, buyAsset)); // PriceFeed module: Requested asset pair not valid
1171         var (isRecent, referencePrice, ) = module.pricefeed.getReferencePrice(sellAsset, buyAsset);
1172         require(isRecent);  // Reference price is required to be recent
1173         require(
1174             module.riskmgmt.isMakePermitted(
1175                 module.pricefeed.getOrderPrice(
1176                     sellAsset,
1177                     buyAsset,
1178                     sellQuantity,
1179                     buyQuantity
1180                 ),
1181                 referencePrice,
1182                 sellAsset,
1183                 buyAsset,
1184                 sellQuantity,
1185                 buyQuantity
1186             )
1187         ); // RiskMgmt module: Make order not permitted
1188         require(isInAssetList[buyAsset] || ownedAssets.length < MAX_FUND_ASSETS); // Limit for max ownable assets by the fund reached
1189         require(AssetInterface(sellAsset).approve(exchanges[exchangeNumber].exchange, sellQuantity)); // Approve exchange to spend assets
1190 
1191         // Since there is only one openMakeOrder allowed for each asset, we can assume that openMakeOrderId is set as zero by quantityHeldInCustodyOfExchange() function
1192         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("makeOrder(address,address,address,uint256,uint256)")), exchanges[exchangeNumber].exchange, sellAsset, buyAsset, sellQuantity, buyQuantity));
1193         exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset] = exchanges[exchangeNumber].exchangeAdapter.getLastOrderId(exchanges[exchangeNumber].exchange);
1194 
1195         // Success defined as non-zero order id
1196         require(exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset] != 0);
1197 
1198         // Update ownedAssets array and isInAssetList, isInOpenMakeOrder mapping
1199         isInOpenMakeOrder[buyAsset] = true;
1200         if (!isInAssetList[buyAsset]) {
1201             ownedAssets.push(buyAsset);
1202             isInAssetList[buyAsset] = true;
1203         }
1204 
1205         orders.push(Order({
1206             exchangeId: exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset],
1207             status: OrderStatus.active,
1208             orderType: OrderType.make,
1209             sellAsset: sellAsset,
1210             buyAsset: buyAsset,
1211             sellQuantity: sellQuantity,
1212             buyQuantity: buyQuantity,
1213             timestamp: now,
1214             fillQuantity: 0
1215         }));
1216 
1217         OrderUpdated(exchangeIdsToOpenMakeOrderIds[exchangeNumber][sellAsset]);
1218     }
1219 
1220     /// @notice Takes an active order on the selected exchange
1221     /// @dev These are orders that are expected to settle immediately
1222     /// @param id Active order id
1223     /// @param receiveQuantity Buy quantity of what others are selling on selected Exchange
1224     function takeOrder(uint exchangeNumber, uint id, uint receiveQuantity)
1225         external
1226         pre_cond(isOwner())
1227         pre_cond(!isShutDown)
1228     {
1229         // Get information of order by order id
1230         Order memory order; // Inverse variable terminology! Buying what another person is selling
1231         (
1232             order.sellAsset,
1233             order.buyAsset,
1234             order.sellQuantity,
1235             order.buyQuantity
1236         ) = exchanges[exchangeNumber].exchangeAdapter.getOrder(exchanges[exchangeNumber].exchange, id);
1237         // Check pre conditions
1238         require(order.sellAsset != address(this)); // Prevent buying of own fund token
1239         require(module.pricefeed.existsPriceOnAssetPair(order.buyAsset, order.sellAsset)); // PriceFeed module: Requested asset pair not valid
1240         require(isInAssetList[order.sellAsset] || ownedAssets.length < MAX_FUND_ASSETS); // Limit for max ownable assets by the fund reached
1241         var (isRecent, referencePrice, ) = module.pricefeed.getReferencePrice(order.buyAsset, order.sellAsset);
1242         require(isRecent); // Reference price is required to be recent
1243         require(receiveQuantity <= order.sellQuantity); // Not enough quantity of order for what is trying to be bought
1244         uint spendQuantity = mul(receiveQuantity, order.buyQuantity) / order.sellQuantity;
1245         require(AssetInterface(order.buyAsset).approve(exchanges[exchangeNumber].exchange, spendQuantity)); // Could not approve spending of spendQuantity of order.buyAsset
1246         require(
1247             module.riskmgmt.isTakePermitted(
1248             module.pricefeed.getOrderPrice(
1249                 order.buyAsset,
1250                 order.sellAsset,
1251                 order.buyQuantity, // spendQuantity
1252                 order.sellQuantity // receiveQuantity
1253             ),
1254             referencePrice,
1255             order.buyAsset,
1256             order.sellAsset,
1257             order.buyQuantity,
1258             order.sellQuantity
1259         )); // RiskMgmt module: Take order not permitted
1260 
1261         // Execute request
1262         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("takeOrder(address,uint256,uint256)")), exchanges[exchangeNumber].exchange, id, receiveQuantity));
1263 
1264         // Update ownedAssets array and isInAssetList mapping
1265         if (!isInAssetList[order.sellAsset]) {
1266             ownedAssets.push(order.sellAsset);
1267             isInAssetList[order.sellAsset] = true;
1268         }
1269 
1270         order.exchangeId = id;
1271         order.status = OrderStatus.fullyFilled;
1272         order.orderType = OrderType.take;
1273         order.timestamp = now;
1274         order.fillQuantity = receiveQuantity;
1275         orders.push(order);
1276         OrderUpdated(id);
1277     }
1278 
1279     /// @notice Cancels orders that were not expected to settle immediately, i.e. makeOrders
1280     /// @dev Reduce exposure with exchange interaction
1281     /// @param id Active order id of this order array with order owner of this contract on selected Exchange
1282     function cancelOrder(uint exchangeNumber, uint id)
1283         external
1284         pre_cond(isOwner() || isShutDown)
1285     {
1286         // Get information of fund order by order id
1287         Order order = orders[id];
1288 
1289         // Execute request
1290         require(address(exchanges[exchangeNumber].exchangeAdapter).delegatecall(bytes4(keccak256("cancelOrder(address,uint256)")), exchanges[exchangeNumber].exchange, order.exchangeId));
1291 
1292         order.status = OrderStatus.cancelled;
1293         OrderUpdated(id);
1294     }
1295 
1296 
1297     // PUBLIC METHODS
1298 
1299     // PUBLIC METHODS : ERC223
1300 
1301     /// @dev Standard ERC223 function that handles incoming token transfers.
1302     /// @dev This type of redemption can be seen as a "market order", where price is calculated at execution time
1303     /// @param ofSender  Token sender address.
1304     /// @param tokenAmount Amount of tokens sent.
1305     /// @param metadata  Transaction metadata.
1306     function tokenFallback(
1307         address ofSender,
1308         uint tokenAmount,
1309         bytes metadata
1310     ) {
1311         if (msg.sender != address(this)) {
1312             // when ofSender is a recognized exchange, receive tokens, otherwise revert
1313             for (uint i; i < exchanges.length; i++) {
1314                 if (exchanges[i].exchange == ofSender) return; // receive tokens and do nothing
1315             }
1316             revert();
1317         } else {    // otherwise, make a redemption request
1318             requests.push(Request({
1319                 participant: ofSender,
1320                 status: RequestStatus.active,
1321                 requestType: RequestType.tokenFallbackRedeem,
1322                 requestAsset: address(QUOTE_ASSET), // redeem in QUOTE_ASSET
1323                 shareQuantity: tokenAmount,
1324                 giveQuantity: tokenAmount,              // shares being sent
1325                 receiveQuantity: 0,          // value of the shares at request time
1326                 timestamp: now,
1327                 atUpdateId: module.pricefeed.getLastUpdateId()
1328             }));
1329             RequestUpdated(getLastRequestId());
1330         }
1331     }
1332 
1333 
1334     // PUBLIC METHODS : ACCOUNTING
1335 
1336     /// @notice Calculates gross asset value of the fund
1337     /// @dev Decimals in assets must be equal to decimals in PriceFeed for all entries in AssetRegistrar
1338     /// @dev Assumes that module.pricefeed.getPrice(..) returns recent prices
1339     /// @return gav Gross asset value quoted in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1340     function calcGav() returns (uint gav) {
1341         // prices quoted in QUOTE_ASSET and multiplied by 10 ** assetDecimal
1342         address[] memory tempOwnedAssets; // To store ownedAssets
1343         tempOwnedAssets = ownedAssets;
1344         delete ownedAssets;
1345         for (uint i = 0; i < tempOwnedAssets.length; ++i) {
1346             address ofAsset = tempOwnedAssets[i];
1347             // assetHoldings formatting: mul(exchangeHoldings, 10 ** assetDecimal)
1348             uint assetHoldings = add(
1349                 uint(AssetInterface(ofAsset).balanceOf(this)), // asset base units held by fund
1350                 quantityHeldInCustodyOfExchange(ofAsset)
1351             );
1352             // assetPrice formatting: mul(exchangePrice, 10 ** assetDecimal)
1353             var (isRecent, assetPrice, assetDecimals) = module.pricefeed.getPrice(ofAsset);
1354             if (!isRecent) {
1355                 revert();
1356             }
1357             // gav as sum of mul(assetHoldings, assetPrice) with formatting: mul(mul(exchangeHoldings, exchangePrice), 10 ** shareDecimals)
1358             gav = add(gav, mul(assetHoldings, assetPrice) / (10 ** uint256(assetDecimals)));   // Sum up product of asset holdings of this vault and asset prices
1359             if (assetHoldings != 0 || ofAsset == address(QUOTE_ASSET) || ofAsset == address(NATIVE_ASSET) || isInOpenMakeOrder[ofAsset]) { // Check if asset holdings is not zero or is address(QUOTE_ASSET) or in open make order
1360                 ownedAssets.push(ofAsset);
1361             } else {
1362                 isInAssetList[ofAsset] = false; // Remove from ownedAssets if asset holdings are zero
1363             }
1364             PortfolioContent(assetHoldings, assetPrice, assetDecimals);
1365         }
1366     }
1367 
1368     /**
1369     @notice Calculates unclaimed fees of the fund manager
1370     @param gav Gross asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1371     @return {
1372       "managementFees": "A time (seconds) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1373       "performanceFees": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee in QUOTE_ASSET and multiplied by 10 ** shareDecimals",
1374       "unclaimedfees": "The sum of both managementfee and performancefee in QUOTE_ASSET and multiplied by 10 ** shareDecimals"
1375     }
1376     */
1377     function calcUnclaimedFees(uint gav)
1378         view
1379         returns (
1380             uint managementFee,
1381             uint performanceFee,
1382             uint unclaimedFees)
1383     {
1384         // Management fee calculation
1385         uint timePassed = sub(now, atLastUnclaimedFeeAllocation.timestamp);
1386         uint gavPercentage = mul(timePassed, gav) / (1 years);
1387         managementFee = wmul(gavPercentage, MANAGEMENT_FEE_RATE);
1388 
1389         // Performance fee calculation
1390         // Handle potential division through zero by defining a default value
1391         uint valuePerShareExclMgmtFees = totalSupply > 0 ? calcValuePerShare(sub(gav, managementFee), totalSupply) : toSmallestShareUnit(1);
1392         if (valuePerShareExclMgmtFees > atLastUnclaimedFeeAllocation.highWaterMark) {
1393             uint gainInSharePrice = sub(valuePerShareExclMgmtFees, atLastUnclaimedFeeAllocation.highWaterMark);
1394             uint investmentProfits = wmul(gainInSharePrice, totalSupply);
1395             performanceFee = wmul(investmentProfits, PERFORMANCE_FEE_RATE);
1396         }
1397 
1398         // Sum of all FEES
1399         unclaimedFees = add(managementFee, performanceFee);
1400     }
1401 
1402     /// @notice Calculates the Net asset value of this fund
1403     /// @param gav Gross asset value of this fund in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1404     /// @param unclaimedFees The sum of both managementFee and performanceFee in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1405     /// @return nav Net asset value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1406     function calcNav(uint gav, uint unclaimedFees)
1407         view
1408         returns (uint nav)
1409     {
1410         nav = sub(gav, unclaimedFees);
1411     }
1412 
1413     /// @notice Calculates the share price of the fund
1414     /// @dev Convention for valuePerShare (== sharePrice) formatting: mul(totalValue / numShares, 10 ** decimal), to avoid floating numbers
1415     /// @dev Non-zero share supply; value denominated in [base unit of melonAsset]
1416     /// @param totalValue the total value in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1417     /// @param numShares the number of shares multiplied by 10 ** shareDecimals
1418     /// @return valuePerShare Share price denominated in QUOTE_ASSET and multiplied by 10 ** shareDecimals
1419     function calcValuePerShare(uint totalValue, uint numShares)
1420         view
1421         pre_cond(numShares > 0)
1422         returns (uint valuePerShare)
1423     {
1424         valuePerShare = toSmallestShareUnit(totalValue) / numShares;
1425     }
1426 
1427     /**
1428     @notice Calculates essential fund metrics
1429     @return {
1430       "gav": "Gross asset value of this fund denominated in [base unit of melonAsset]",
1431       "managementFee": "A time (seconds) based fee",
1432       "performanceFee": "A performance (rise of sharePrice measured in QUOTE_ASSET) based fee",
1433       "unclaimedFees": "The sum of both managementFee and performanceFee denominated in [base unit of melonAsset]",
1434       "feesShareQuantity": "The number of shares to be given as fees to the manager",
1435       "nav": "Net asset value denominated in [base unit of melonAsset]",
1436       "sharePrice": "Share price denominated in [base unit of melonAsset]"
1437     }
1438     */
1439     function performCalculations()
1440         view
1441         returns (
1442             uint gav,
1443             uint managementFee,
1444             uint performanceFee,
1445             uint unclaimedFees,
1446             uint feesShareQuantity,
1447             uint nav,
1448             uint sharePrice
1449         )
1450     {
1451         gav = calcGav(); // Reflects value independent of fees
1452         (managementFee, performanceFee, unclaimedFees) = calcUnclaimedFees(gav);
1453         nav = calcNav(gav, unclaimedFees);
1454 
1455         // The value of unclaimedFees measured in shares of this fund at current value
1456         feesShareQuantity = (gav == 0) ? 0 : mul(totalSupply, unclaimedFees) / gav;
1457         // The total share supply including the value of unclaimedFees, measured in shares of this fund
1458         uint totalSupplyAccountingForFees = add(totalSupply, feesShareQuantity);
1459         sharePrice = nav > 0 ? calcValuePerShare(gav, totalSupplyAccountingForFees) : toSmallestShareUnit(1); // Handle potential division through zero by defining a default value
1460     }
1461 
1462     /// @notice Converts unclaimed fees of the manager into fund shares
1463     /// @return sharePrice Share price denominated in [base unit of melonAsset]
1464     function calcSharePriceAndAllocateFees() public returns (uint)
1465     {
1466         var (
1467             gav,
1468             managementFee,
1469             performanceFee,
1470             unclaimedFees,
1471             feesShareQuantity,
1472             nav,
1473             sharePrice
1474         ) = performCalculations();
1475 
1476         createShares(owner, feesShareQuantity); // Updates totalSupply by creating shares allocated to manager
1477 
1478         // Update Calculations
1479         uint highWaterMark = atLastUnclaimedFeeAllocation.highWaterMark >= sharePrice ? atLastUnclaimedFeeAllocation.highWaterMark : sharePrice;
1480         atLastUnclaimedFeeAllocation = Calculations({
1481             gav: gav,
1482             managementFee: managementFee,
1483             performanceFee: performanceFee,
1484             unclaimedFees: unclaimedFees,
1485             nav: nav,
1486             highWaterMark: highWaterMark,
1487             totalSupply: totalSupply,
1488             timestamp: now
1489         });
1490 
1491         FeesConverted(now, feesShareQuantity, unclaimedFees);
1492         CalculationUpdate(now, managementFee, performanceFee, nav, sharePrice, totalSupply);
1493 
1494         return sharePrice;
1495     }
1496 
1497     // PUBLIC : REDEEMING
1498 
1499     /// @notice Redeems by allocating an ownership percentage only of requestedAssets to the participant
1500     /// @dev Independent of running price feed! Note: if requestedAssets != ownedAssets then participant misses out on some owned value
1501     /// @param shareQuantity Number of shares owned by the participant, which the participant would like to redeem for individual assets
1502     /// @param requestedAssets List of addresses that consitute a subset of ownedAssets.
1503     /// @return Whether all assets sent to shareholder or not
1504     function emergencyRedeem(uint shareQuantity, address[] requestedAssets)
1505         public
1506         pre_cond(balances[msg.sender] >= shareQuantity)  // sender owns enough shares
1507         returns (bool)
1508     {
1509         address ofAsset;
1510         uint[] memory ownershipQuantities = new uint[](requestedAssets.length);
1511 
1512         // Check whether enough assets held by fund
1513         for (uint i = 0; i < requestedAssets.length; ++i) {
1514             ofAsset = requestedAssets[i];
1515             uint assetHoldings = add(
1516                 uint(AssetInterface(ofAsset).balanceOf(this)),
1517                 quantityHeldInCustodyOfExchange(ofAsset)
1518             );
1519 
1520             if (assetHoldings == 0) continue;
1521 
1522             // participant's ownership percentage of asset holdings
1523             ownershipQuantities[i] = mul(assetHoldings, shareQuantity) / totalSupply;
1524 
1525             // CRITICAL ERR: Not enough fund asset balance for owed ownershipQuantitiy, eg in case of unreturned asset quantity at address(exchanges[i].exchange) address
1526             if (uint(AssetInterface(ofAsset).balanceOf(this)) < ownershipQuantities[i]) {
1527                 isShutDown = true;
1528                 ErrorMessage("CRITICAL ERR: Not enough assetHoldings for owed ownershipQuantitiy");
1529                 return false;
1530             }
1531         }
1532 
1533         // Annihilate shares before external calls to prevent reentrancy
1534         annihilateShares(msg.sender, shareQuantity);
1535 
1536         // Transfer ownershipQuantity of Assets
1537         for (uint j = 0; j < requestedAssets.length; ++j) {
1538             // Failed to send owed ownershipQuantity from fund to participant
1539             ofAsset = requestedAssets[j];
1540             if (ownershipQuantities[j] == 0) {
1541                 continue;
1542             } else if (!AssetInterface(ofAsset).transfer(msg.sender, ownershipQuantities[j])) {
1543                 revert();
1544             }
1545         }
1546         Redeemed(msg.sender, now, shareQuantity);
1547         return true;
1548     }
1549 
1550     // PUBLIC : FEES
1551 
1552     /// @dev Quantity of asset held in exchange according to associated order id
1553     /// @param ofAsset Address of asset
1554     /// @return Quantity of input asset held in exchange
1555     function quantityHeldInCustodyOfExchange(address ofAsset) returns (uint) {
1556         uint totalSellQuantity;     // quantity in custody across exchanges
1557         uint totalSellQuantityInApprove; // quantity of asset in approve (allowance) but not custody of exchange
1558         for (uint i; i < exchanges.length; i++) {
1559             if (exchangeIdsToOpenMakeOrderIds[i][ofAsset] == 0) {
1560                 continue;
1561             }
1562             var (sellAsset, , sellQuantity, ) = exchanges[i].exchangeAdapter.getOrder(exchanges[i].exchange, exchangeIdsToOpenMakeOrderIds[i][ofAsset]);
1563             if (sellQuantity == 0) {
1564                 exchangeIdsToOpenMakeOrderIds[i][ofAsset] = 0;
1565             }
1566             totalSellQuantity = add(totalSellQuantity, sellQuantity);
1567             if (exchanges[i].isApproveOnly) {
1568                 totalSellQuantityInApprove += sellQuantity;
1569             }
1570         }
1571         if (totalSellQuantity == 0) {
1572             isInOpenMakeOrder[sellAsset] = false;
1573         }
1574         return sub(totalSellQuantity, totalSellQuantityInApprove); // Since quantity in approve is not actually in custody
1575     }
1576 
1577     // PUBLIC VIEW METHODS
1578 
1579     /// @notice Calculates sharePrice denominated in [base unit of melonAsset]
1580     /// @return sharePrice Share price denominated in [base unit of melonAsset]
1581     function calcSharePrice() view returns (uint sharePrice) {
1582         (, , , , , sharePrice) = performCalculations();
1583         return sharePrice;
1584     }
1585 
1586     function getModules() view returns (address, address, address) {
1587         return (
1588             address(module.pricefeed),
1589             address(module.compliance),
1590             address(module.riskmgmt)
1591         );
1592     }
1593 
1594     function getLastOrderId() view returns (uint) { return orders.length - 1; }
1595     function getLastRequestId() view returns (uint) { return requests.length - 1; }
1596     function getNameHash() view returns (bytes32) { return bytes32(keccak256(name)); }
1597     function getManager() view returns (address) { return owner; }
1598 }
1599 
1600 contract WETH9_ {
1601     string public name     = "Wrapped Ether";
1602     string public symbol   = "WETH";
1603     uint8  public decimals = 18;
1604 
1605     event  Approval(address indexed src, address indexed guy, uint wad);
1606     event  Transfer(address indexed src, address indexed dst, uint wad);
1607     event  Deposit(address indexed dst, uint wad);
1608     event  Withdrawal(address indexed src, uint wad);
1609 
1610     mapping (address => uint)                       public  balanceOf;
1611     mapping (address => mapping (address => uint))  public  allowance;
1612 
1613     function() public payable {
1614         deposit();
1615     }
1616     function deposit() public payable {
1617         balanceOf[msg.sender] += msg.value;
1618         Deposit(msg.sender, msg.value);
1619     }
1620     function withdraw(uint wad) public {
1621         require(balanceOf[msg.sender] >= wad);
1622         balanceOf[msg.sender] -= wad;
1623         msg.sender.transfer(wad);
1624         Withdrawal(msg.sender, wad);
1625     }
1626 
1627     function totalSupply() public view returns (uint) {
1628         return this.balance;
1629     }
1630 
1631     function approve(address guy, uint wad) public returns (bool) {
1632         allowance[msg.sender][guy] = wad;
1633         Approval(msg.sender, guy, wad);
1634         return true;
1635     }
1636 
1637     function transfer(address dst, uint wad) public returns (bool) {
1638         return transferFrom(msg.sender, dst, wad);
1639     }
1640 
1641     function transferFrom(address src, address dst, uint wad)
1642         public
1643         returns (bool)
1644     {
1645         require(balanceOf[src] >= wad);
1646 
1647         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
1648             require(allowance[src][msg.sender] >= wad);
1649             allowance[src][msg.sender] -= wad;
1650         }
1651 
1652         balanceOf[src] -= wad;
1653         balanceOf[dst] += wad;
1654 
1655         Transfer(src, dst, wad);
1656 
1657         return true;
1658     }
1659 }